<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>Rules for PEPPOL Order Cancellation transaction 3.0</title>

    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:OrderCancellation-2"
       prefix="ubl"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>

    

    

    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:gln"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>

    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:slack"
             as="xs:boolean">
      <param name="exp" as="xs:decimal"/>
      <param name="val" as="xs:decimal"/>
      <param name="slack" as="xs:decimal"/>
      <value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
   </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod11"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCodiceIPA"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
      <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:addPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string"/>
      <param name="pari" as="xs:integer"/>
      <variable name="tappo"
                select="if (not($arg castable as xs:integer)) then 0 else 1"/>
      <variable name="mapper"
                select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF16"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVAseIT"
             as="xs:boolean">
      <param name="arg" as="xs:string"/>
      <variable name="paese" select="substring($arg,1,2)"/>
      <variable name="codice" select="substring($arg,3)"/>
      <sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod97-0208"
             as="xs:boolean">
      <param name="val"/>
      <variable name="checkdigits" select="substring($val,9,2)"/>
      <variable name="calculated_digits"
                select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
      <value-of select="number($checkdigits) = number($calculated_digits)"/>
  </function>
	  	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
      <param name="val"/>
      <value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>

    

    <pattern>
 
		    <rule context="//*[not(*) and not(normalize-space())]">
			      <assert id="PEPPOL-COMMON-R001" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
		    </rule> 
   
   </pattern>
    <pattern>

      <rule context="/*">
        <assert id="PEPPOL-COMMON-R003"
                 test="not(@*:schemaLocation)"
                 flag="warning">Document SHOULD not contain schema location.</assert>

      </rule>

      <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
        <assert id="PEPPOL-COMMON-R030"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
      </rule>

    
      <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
        <assert id="PEPPOL-COMMON-R040"
                 test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"
                 flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
        <assert id="PEPPOL-COMMON-R041"
                 test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"
                 flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
         <assert id="PEPPOL-COMMON-R043"
                 test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())"
                 flag="fatal">Belgian enterprise number MUST be stated in the correct format.</assert>
      </rule>	
      <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
         <assert id="PEPPOL-COMMON-R044"
                 test="u:checkCodiceIPA(normalize-space())"
                 flag="warning">IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
         <assert id="PEPPOL-COMMON-R045"
                 test="u:checkCF(normalize-space())"
                 flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '9907']">
         <assert id="PEPPOL-COMMON-R046"
                 test="u:checkCF(normalize-space())"
                 flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
         <assert id="PEPPOL-COMMON-R047"
                 test="u:checkPIVAseIT(normalize-space())"
                 flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '9906']">
         <assert id="PEPPOL-COMMON-R048"
                 test="u:checkPIVAseIT(normalize-space())"
                 flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
         <assert id="PEPPOL-COMMON-R049"
                 test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'"
                 flag="fatal">Swedish organization number MUST be stated in the correct format.</assert>     
      </rule> 
      <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
         <assert id="PEPPOL-COMMON-R050"
                 test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())"
                 flag="fatal">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
      </rule> 
   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <let name="cleas"
           value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 9901 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')"/>
      <let name="clMimeCode"
           value="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230', '\s')"/>
      <let name="clISO3166"
           value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
      <rule context="/ubl:OrderCancellation">
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T115-B00101">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T115-B00102">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B00103">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T115-B00104">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:CancellationNote" flag="fatal" id="PEPPOL-T115-B00105">Element 'cbc:CancellationNote' MUST be provided.</assert>
         <assert test="cac:OrderReference" flag="fatal" id="PEPPOL-T115-B00106">Element 'cac:OrderReference' MUST be provided.</assert>
         <assert test="cac:BuyerCustomerParty" flag="fatal" id="PEPPOL-T115-B00107">Element 'cac:BuyerCustomerParty' MUST be provided.</assert>
         <assert test="cac:SellerSupplierParty" flag="fatal" id="PEPPOL-T115-B00108">Element 'cac:SellerSupplierParty' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T115-B00109">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cbc:CustomizationID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:trns:order_cancellation:3'"
                 flag="fatal"
                 id="PEPPOL-T115-B00201">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:poacc:trns:order_cancellation:3'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3'"
                 flag="fatal"
                 id="PEPPOL-T115-B00301">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cbc:ID"/>
      <rule context="/ubl:OrderCancellation/cbc:IssueDate"/>
      <rule context="/ubl:OrderCancellation/cbc:IssueTime"/>
      <rule context="/ubl:OrderCancellation/cbc:Note"/>
      <rule context="/ubl:OrderCancellation/cbc:CancellationNote"/>
      <rule context="/ubl:OrderCancellation/cac:OrderReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B00901">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OrderReference/cbc:ID"/>
      <rule context="/ubl:OrderCancellation/cac:OrderReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B00902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B01101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference/cbc:ID"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B01102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B01301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:ID"/>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment"/>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
         <assert test="@mimeCode" flag="fatal" id="PEPPOL-T115-B01701">Attribute 'mimeCode' MUST be present.</assert>
         <assert test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)"
                 flag="fatal"
                 id="PEPPOL-T115-B01702">Value MUST be part of code list 'Mime code (IANA Subset)'.</assert>
         <assert test="@filename" flag="fatal" id="PEPPOL-T115-B01703">Attribute 'filename' MUST be present.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert test="cbc:URI" flag="fatal" id="PEPPOL-T115-B02001">Element 'cbc:URI' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B02002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/cac:Attachment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B01601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:AdditionalDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B01302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:Contract">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B02201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:Contract/cbc:ID"/>
      <rule context="/ubl:OrderCancellation/cac:Contract/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B02202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T115-B02401">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T115-B02501">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T115-B02502">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T115-B02601">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T115-B02602">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B02801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T115-B02901">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T115-B03101">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T115-B03301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T115-B04101">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T115-B04201">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B04102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B03302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T115-B04301">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T115-B04302">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B04501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B04502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B04303">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T115-B04701">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T115-B04901">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T115-B05101">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T115-B05301">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T115-B05401">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B05302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B05102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B04702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B05501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B02503">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:BuyerCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B02402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T115-B05901">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T115-B06001">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PostalAddress" flag="fatal" id="PEPPOL-T115-B06002">Element 'cac:PostalAddress' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T115-B06003">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T115-B06101">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B06301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T115-B06401">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T115-B06601">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T115-B06801">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T115-B07601">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T115-B07701">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B07602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B06802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T115-B07801">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T115-B08001">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T115-B08201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T115-B08401">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T115-B08501">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B08402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B08202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B07802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B08601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B06004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:SellerSupplierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B05902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T115-B09001">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T115-B09201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T115-B09301">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T115-B09501">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B09701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B09101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/cac:OriginatorCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B09002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:OrderCancellation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T115-B00110">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>

      <rule context="cbc:ProfileID">
        <assert id="PEPPOL-T115-R031"
                 test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3', '\s') satisfies $p = normalize-space(.)"
                 flag="fatal">An order cancellation transaction MUST use profile advanced_ordering.</assert>
      </rule>

		    <rule context="cbc:CustomizationID">
				     <assert id="PEPPOL-T115-R034"
                 test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_cancellation:3')"
                 flag="fatal">Specification identifier MUST start with the value 'urn:fdc:peppol.eu:poacc:trns:order_cancellation:3'.</assert>
		    </rule>

   </pattern>

</schema>
