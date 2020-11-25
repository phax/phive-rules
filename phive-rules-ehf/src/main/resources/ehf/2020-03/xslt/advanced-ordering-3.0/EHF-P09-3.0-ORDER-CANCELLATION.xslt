<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Order-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
  <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 1, $length)) return $i -48)" />
  <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))" />
  <xsl:value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))" />
</xsl:function>
  <xsl:function as="xs:boolean" name="u:mod11">
  <xsl:param name="val" />
  <xsl:variable name="length" select="string-length($val) - 1" />
  <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
  <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))" />
  <xsl:value-of select="number($val) > 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))" />
</xsl:function>
  <xsl:function as="xs:boolean" name="u:slack">
    <xsl:param as="xs:decimal" name="exp" />
    <xsl:param as="xs:decimal" name="val" />
    <xsl:param as="xs:decimal" name="slack" />
    <xsl:value-of select="xs:decimal($exp + $slack) >= $val and xs:decimal($exp - $slack) &lt;= $val" />
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
    <svrl:schematron-output schemaVersion="iso" title="EHF Advanced Order Change 3.0">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>EHF Advanced Order Change 3.0</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="cbc:*" mode="M10" priority="1001">
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
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:*" mode="M10" priority="1000">
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
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0195 0196', '\s')" />
  <xsl:variable name="clMimeCode" select="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:variable name="cleas" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0135 0142 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9917 9918 9919 9920 9921 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957 9958', '\s')" />
  <xsl:variable name="clISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW', '\s')" />

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation" mode="M11" priority="1183">
    <svrl:fired-rule context="/ubl:OrderCancellation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID">
          <xsl:attribute name="id">EHF-P09-CAN-B00101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B00102</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B00103</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B00104</xsl:attribute>
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
      <xsl:when test="cbc:CancellationNote" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CancellationNote">
          <xsl:attribute name="id">EHF-P09-CAN-B00105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CancellationNote' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:BuyerCustomerParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:BuyerCustomerParty">
          <xsl:attribute name="id">EHF-P09-CAN-B00106</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B00107</xsl:attribute>
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
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">EHF-P09-CAN-B00108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:CustomizationID" mode="M11" priority="1182">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:spec:adv-order-cancellation:3.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:spec:adv-order-cancellation:3.0'">
          <xsl:attribute name="id">EHF-P09-CAN-B00201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:anskaffelser.no:2019:ehf:spec:adv-order-cancellation:3.0'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:CustomizationID/*" mode="M11" priority="1181">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:CustomizationID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:ProfileID" mode="M11" priority="1180">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:09:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:09:1.0'">
          <xsl:attribute name="id">EHF-P09-CAN-B00301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ProfileID' MUST contain value 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:09:1.0'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:ProfileID/*" mode="M11" priority="1179">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:ProfileID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:UUID" mode="M11" priority="1178">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:UUID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:UUID/*" mode="M11" priority="1177">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:UUID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:ID" mode="M11" priority="1176">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:ID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:ID/*" mode="M11" priority="1175">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:IssueDate" mode="M11" priority="1174">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:IssueDate" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:IssueDate/*" mode="M11" priority="1173">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:IssueDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:IssueTime" mode="M11" priority="1172">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:IssueTime" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:IssueTime/*" mode="M11" priority="1171">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:IssueTime/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:Note" mode="M11" priority="1170">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:Note" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:Note/*" mode="M11" priority="1169">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:Note/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:CancellationNote" mode="M11" priority="1168">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:CancellationNote" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cbc:CancellationNote/*" mode="M11" priority="1167">
    <svrl:fired-rule context="/ubl:OrderCancellation/cbc:CancellationNote/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OrderReference" mode="M11" priority="1166">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OrderReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B01001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OrderReference/cbc:ID" mode="M11" priority="1165">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OrderReference/cbc:ID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OrderReference/cbc:ID/*" mode="M11" priority="1164">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OrderReference/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OrderReference/*" mode="M11" priority="1163">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OrderReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorDocumentReference" mode="M11" priority="1162">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B01201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorDocumentReference/cbc:ID" mode="M11" priority="1161">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorDocumentReference/cbc:ID/*" mode="M11" priority="1160">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorDocumentReference/*" mode="M11" priority="1159">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference" mode="M11" priority="1158">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B01401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:ID" mode="M11" priority="1157">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:ID/*" mode="M11" priority="1156">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:DocumentType" mode="M11" priority="1155">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:DocumentType/*" mode="M11" priority="1154">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:DocumentType/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment" mode="M11" priority="1153">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" mode="M11" priority="1152">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">EHF-P09-CAN-B01801</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B01802</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B01803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/*" mode="M11" priority="1151">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01804</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" mode="M11" priority="1150">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">EHF-P09-CAN-B02101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" mode="M11" priority="1149">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI/*" mode="M11" priority="1148">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*" mode="M11" priority="1147">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/*" mode="M11" priority="1146">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:AdditionalDocumentReference/*" mode="M11" priority="1145">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B01402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:Contract" mode="M11" priority="1144">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:Contract" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B02301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:Contract/cbc:ID" mode="M11" priority="1143">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:Contract/cbc:ID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:Contract/cbc:ID/*" mode="M11" priority="1142">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:Contract/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:Contract/*" mode="M11" priority="1141">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:Contract/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty" mode="M11" priority="1140">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">EHF-P09-CAN-B02501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party" mode="M11" priority="1139">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">EHF-P09-CAN-B02601</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B02602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" mode="M11" priority="1138">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">EHF-P09-CAN-B02701</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B02702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID/*" mode="M11" priority="1137">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" mode="M11" priority="1136">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B02901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M11" priority="1135">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-P09-CAN-B03001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ICD list (ISO 6523) '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/*" mode="M11" priority="1134">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/*" mode="M11" priority="1133">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName" mode="M11" priority="1132">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-P09-CAN-B03201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M11" priority="1131">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name/*" mode="M11" priority="1130">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/*" mode="M11" priority="1129">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" mode="M11" priority="1128">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-P09-CAN-B03401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M11" priority="1127">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" mode="M11" priority="1126">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M11" priority="1125">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" mode="M11" priority="1124">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M11" priority="1123">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName/*" mode="M11" priority="1122">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M11" priority="1121">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" mode="M11" priority="1120">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M11" priority="1119">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" mode="M11" priority="1118">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M11" priority="1117">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M11" priority="1116">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" mode="M11" priority="1115">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" mode="M11" priority="1114">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M11" priority="1113">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-P09-CAN-B04201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M11" priority="1112">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-P09-CAN-B04301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" mode="M11" priority="1111">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M11" priority="1110">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" mode="M11" priority="1109">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B03402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M11" priority="1108">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">EHF-P09-CAN-B04401</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B04402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" mode="M11" priority="1107">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/*" mode="M11" priority="1106">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M11" priority="1105">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B04601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M11" priority="1104">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'VAT'">
          <xsl:attribute name="id">EHF-P09-CAN-B04701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST contain value 'VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" mode="M11" priority="1103">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M11" priority="1102">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*" mode="M11" priority="1101">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M11" priority="1100">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">EHF-P09-CAN-B04801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M11" priority="1099">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" mode="M11" priority="1098">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M11" priority="1097">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-P09-CAN-B05001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ICD list (ISO 6523) '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" mode="M11" priority="1096">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M11" priority="1095">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-P09-CAN-B05201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M11" priority="1094">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName/*" mode="M11" priority="1093">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M11" priority="1092">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-P09-CAN-B05401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M11" priority="1091">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-P09-CAN-B05501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode/*" mode="M11" priority="1090">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M11" priority="1089">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M11" priority="1088">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*" mode="M11" priority="1087">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B04802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact" mode="M11" priority="1086">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M11" priority="1085">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name/*" mode="M11" priority="1084">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M11" priority="1083">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone/*" mode="M11" priority="1082">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M11" priority="1081">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" mode="M11" priority="1080">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/*" mode="M11" priority="1079">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B05601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/*" mode="M11" priority="1078">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:BuyerCustomerParty/*" mode="M11" priority="1077">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B02502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty" mode="M11" priority="1076">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">EHF-P09-CAN-B06001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party" mode="M11" priority="1075">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">EHF-P09-CAN-B06101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B06102</xsl:attribute>
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
          <xsl:attribute name="id">EHF-P09-CAN-B06103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" mode="M11" priority="1074">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or @schemeID = '0192'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or @schemeID = '0192'">
          <xsl:attribute name="id">EHF-P09-CAN-B06201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST contain value '0192'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">EHF-P09-CAN-B06202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cbc:EndpointID/*" mode="M11" priority="1073">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cbc:EndpointID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" mode="M11" priority="1072">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B06401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M11" priority="1071">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-P09-CAN-B06501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ICD list (ISO 6523) '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/*" mode="M11" priority="1070">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/*" mode="M11" priority="1069">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName" mode="M11" priority="1068">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-P09-CAN-B06701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" mode="M11" priority="1067">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name/*" mode="M11" priority="1066">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/*" mode="M11" priority="1065">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" mode="M11" priority="1064">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-P09-CAN-B06901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M11" priority="1063">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" mode="M11" priority="1062">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M11" priority="1061">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" mode="M11" priority="1060">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M11" priority="1059">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName/*" mode="M11" priority="1058">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M11" priority="1057">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" mode="M11" priority="1056">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M11" priority="1055">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" mode="M11" priority="1054">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M11" priority="1053">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M11" priority="1052">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" mode="M11" priority="1051">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" mode="M11" priority="1050">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M11" priority="1049">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-P09-CAN-B07701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M11" priority="1048">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-P09-CAN-B07801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" mode="M11" priority="1047">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M11" priority="1046">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" mode="M11" priority="1045">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" mode="M11" priority="1044">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">EHF-P09-CAN-B07901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M11" priority="1043">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" mode="M11" priority="1042">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M11" priority="1041">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-P09-CAN-B08101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ICD list (ISO 6523) '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" mode="M11" priority="1040">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M11" priority="1039">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-P09-CAN-B08301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M11" priority="1038">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName/*" mode="M11" priority="1037">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M11" priority="1036">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-P09-CAN-B08501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M11" priority="1035">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-P09-CAN-B08601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode/*" mode="M11" priority="1034">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M11" priority="1033">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M11" priority="1032">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*" mode="M11" priority="1031">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B07902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact" mode="M11" priority="1030">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" mode="M11" priority="1029">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name/*" mode="M11" priority="1028">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" mode="M11" priority="1027">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone/*" mode="M11" priority="1026">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M11" priority="1025">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" mode="M11" priority="1024">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/*" mode="M11" priority="1023">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B08701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/*" mode="M11" priority="1022">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:SellerSupplierParty/*" mode="M11" priority="1021">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B06002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty" mode="M11" priority="1020">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">EHF-P09-CAN-B09101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party" mode="M11" priority="1019">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" mode="M11" priority="1018">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-P09-CAN-B09301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M11" priority="1017">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-P09-CAN-B09401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ICD list (ISO 6523) '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/*" mode="M11" priority="1016">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/*" mode="M11" priority="1015">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" mode="M11" priority="1014">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-P09-CAN-B09601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M11" priority="1013">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name/*" mode="M11" priority="1012">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/*" mode="M11" priority="1011">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact" mode="M11" priority="1010">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M11" priority="1009">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name/*" mode="M11" priority="1008">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M11" priority="1007">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone/*" mode="M11" priority="1006">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B10001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M11" priority="1005">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" mode="M11" priority="1004">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B10101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*" mode="M11" priority="1003">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/*" mode="M11" priority="1002">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/cac:OriginatorCustomerParty/*" mode="M11" priority="1001">
    <svrl:fired-rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B09102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderCancellation/*" mode="M11" priority="1000">
    <svrl:fired-rule context="/ubl:OrderCancellation/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-P09-CAN-B00109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M12" priority="1000">
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
    <xsl:apply-templates mode="M12" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
