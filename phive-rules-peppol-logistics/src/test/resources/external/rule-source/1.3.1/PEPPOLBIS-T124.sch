<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>Rules for Transport Execution Plan</title>

	  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:TransportExecutionPlan-2"
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
      <sequence select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
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
      <sequence select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
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
      <sequence select="number($checkdigits) = number($calculated_digits)"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
      <param name="val"/>
      <sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkSEOrgnr"
             as="xs:boolean">
	
	     <param name="number" as="xs:string"/>
	     <choose>
		
		       <when test="not(matches($number, '^\d+$'))">
			         <sequence select="false()"/>
		       </when>
		       <otherwise>
			
			         <variable name="mainPart" select="substring($number, 1, 9)"/>
			         <variable name="checkDigit" select="substring($number, 10, 1)"/>
			         <variable name="sum" as="xs:integer">
			            <sequence select="xs:integer(sum(       for $pos in 1 to string-length($mainPart) return         if ($pos mod 2 = 1)         then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +           (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10         else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      ))"/>
			         </variable>
			         <variable name="calculatedCheckDigit" select="(10 - $sum mod 10) mod 10"/>
			         <sequence select="$calculatedCheckDigit = number($checkDigit)"/>
		       </otherwise>
	     </choose>
   </function>
    

    <pattern>
 
		    <rule context="//*[not(*) and not(normalize-space())]">
			      <assert id="PEPPOL-COMMON-R001" test="false()" flag="fatal">[PEPPOL-COMMON-R001]-Document MUST not contain empty elements.</assert>
		    </rule> 
   
   </pattern>
    <pattern>

      <rule context="/*">
        <assert id="PEPPOL-COMMON-R003"
                 test="not(@*:schemaLocation)"
                 flag="warning">[PEPPOL-COMMON-R003]-Document SHOULD not contain schema location.</assert>

      </rule>

      <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
        <assert id="PEPPOL-COMMON-R030"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">[PEPPOL-COMMON-R030]-A date must be formatted YYYY-MM-DD.</assert>
      </rule>

    
      <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
         <assert id="PEPPOL-COMMON-R040"
                 test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"
                 flag="fatal">[PEPPOL-COMMON-R040]-GLN must have a valid format according to GS1 rules.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
         <assert id="PEPPOL-COMMON-R041"
                 test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"
                 flag="fatal">[PEPPOL-COMMON-R041]-Norwegian organization number MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']">
         <assert id="PEPPOL-COMMON-R042"
                 test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)                or               (string-length(string()) = 8) and (string-length(translate(substring(string(), 1, 8),'1234567890', '')) = 0)"
                 flag="fatal">[PEPPOL-COMMON-R042]-Danish organization number (CVR) MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']">
         <assert id="PEPPOL-COMMON-R052"
                 test="(string-length(string()) = 10) and (string-length(translate(substring(string(), 1, 10),'1234567890', '')) = 0)"
                 flag="fatal">[PEPPOL-COMMON-R052]-Danish chamber of commerce number (P) MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']">
         <assert id="PEPPOL-COMMON-R053"
                 test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)"
                 flag="fatal">[PEPPOL-COMMON-R053]-Danish ERSTORG number (SE) MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
         <assert id="PEPPOL-COMMON-R043"
                 test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())"
                 flag="fatal">[PEPPOL-COMMON-R043]-Belgian enterprise number MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
         <assert id="PEPPOL-COMMON-R044"
                 test="u:checkCodiceIPA(normalize-space())"
                 flag="warning">[PEPPOL-COMMON-R044]-IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
         <assert id="PEPPOL-COMMON-R045"
                 test="u:checkCF(normalize-space())"
                 flag="warning">[PEPPOL-COMMON-R045]-Tax Code (Codice Fiscale) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '9907']">
         <assert id="PEPPOL-COMMON-R046"
                 test="u:checkCF(normalize-space())"
                 flag="warning">[PEPPOL-COMMON-R046]-Tax Code (Codice Fiscale) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
         <assert id="PEPPOL-COMMON-R047"
                 test="u:checkPIVAseIT(normalize-space())"
                 flag="warning">[PEPPOL-COMMON-R047]-Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
      </rule>
    
      <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
         <assert id="PEPPOL-COMMON-R049"
                 test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())"
                 flag="fatal">[PEPPOL-COMMON-R049]-Swedish organization number MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
         <assert id="PEPPOL-COMMON-R050"
                 test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())"
                 flag="fatal">[PEPPOL-COMMON-R050]-Australian Business Number (ABN) MUST be stated in the correct format.</assert>
      </rule>
        <rule context="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']">
         <assert id="PEPPOL-COMMON-R054"
                 test="matches(normalize-space(), '^[0-9]{8}$')"
                 flag="warning">[PEPPOL-COMMON-R054]-Dutch Chamber of Commerce (KVK) numbers (0106) MUST be stated in the correct format (12345678).</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']">
         <assert id="PEPPOL-COMMON-R055"
                 test="matches(normalize-space(), '^[0-9]{20}$')"
                 flag="warning">[PEPPOL-COMMON-R055]-Dutch organization identification numbers (0190) MUST be stated in the correct format (12345678901234567890).</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']">
         <assert id="PEPPOL-COMMON-R056-1"
                 test="matches(normalize-space(), '^NL[0-9]{9}B[0-9]{2}$')"
                 flag="warning">[PEPPOL-COMMON-R056-1]-Dutch VAT numbers (9944) MUST be stated in the correct format (NL123456789B12).</assert>
      </rule>
    
      <rule context="cac:PartyTaxScheme                    [normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']                    /cbc:CompanyID                    [starts-with(normalize-space(.), 'NL')]">
         <assert id="PEPPOL-COMMON-R056-2"
                 test="matches(normalize-space(.), '^NL[0-9]{9}B[0-9]{2}$')"
                 flag="warning">[PEPPOL-COMMON-R056-2]-Dutch VAT numbers MUST have the format (NL123456789B12).</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']">
         <assert id="PEPPOL-COMMON-R057"
                 test="matches(normalize-space(), '^[0-9]{12}$')"
                 flag="warning">[PEPPOL-COMMON-R057]-Dutch Chamber of Commerce Establishment numbers (0217) MUST be stated in the correct format (123456789012).</assert>
      </rule>
   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <let name="clDocumentStatusCode" value="tokenize('1 5 9 22 55', '\s')"/>
      <let name="clMimeCode"
           value="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
      <let name="clISO3166"
           value="tokenize('1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW', '\s')"/>
      <let name="clUNCL8273"
           value="tokenize('ADR ADS ADT ADU ADY ADZ ADV ADW ADX AEA AEB AGS ANR ARD CFR COM GVE GVS ICA IMD RGE RID UI ZZZ', '\s')"/>
      <let name="clTRED8155"
           value="tokenize('1 2 6 7 9 10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45', '\s')"/>
      <let name="clConsignmentIDType" value="tokenize('GINC', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244 0245 0246 0247 0248', '\s')"/>
      <let name="cleas"
           value="tokenize('0002 0007 0009 0060 0088 0096 0097 0106 0130 0135 0142 0151 0158 0183 0184 0188 0190 0191 0192 0195 0196 0198 0199 0200 0201 0204 0208 0209 0210 0211 0216 0218 0221 0225 0230 0235 0240 0242 0244 0245 0246 0248 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')"/>
      <let name="clUNCL6313-T120"
           value="tokenize('AAF AAA AAB AAW AAX ABT ACV HT LN WD TC AAO ABJ T', '\s')"/>
      <let name="clUNCL8053"
           value="tokenize('AA AB AD AE AG AH AI AJ AK AL AM AN AO AP AQ AT BL BPN BPO BPP BPQ BPR BPS BPT BPU BPV BPW BPX BPY BPZ BR BX CH CN DPA DPB EFP EYP FPN FPR IL LAR LU MPA PA PBP PFP PL PPA PST RF RG RGF RO RR SPP STR SW TE TP TS TSU UL', '\s')"/>
      <let name="clFreightAllowanceChargeReasonCode" value="tokenize('1 2', '\s')"/>
      <let name="clTransportServiceCode"
           value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25', '\s')"/>
      <let name="clUNCL1001"
           value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')"/>
      <let name="clUNECERec21"
           value="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV O1 O2 O3 O4 O5 O6 O7 O8 O9 OA OB OC OD OE OF OG OH OI OJ OK OL OM ON OP OQ OR OS OT OU OV OW OX OY OZ P1 P2 P3 P4 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SX SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ', '\s')"/>
      <let name="clUNECERec19" value="tokenize('0 1 2 3 4 5 6 7 8 9', '\s')"/>
      <let name="clTransportHandlingUnitIDType" value="tokenize('SSCC', '\s')"/>
      <let name="clUNECERec20"
           value="tokenize('1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A20 A21 A22 A23 A24 A26 A27 A28 A29 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A40 A41 A42 A43 A44 A45 A47 A48 A49 A53 A54 A55 A56 A59 A68 A69 A70 A71 A73 A74 A75 A76 A84 A85 A86 A87 A88 A89 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B3 B4 B7 B8 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B30 B31 B32 B33 B34 B35 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C3 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C70 C71 C72 C73 C74 C75 C76 C78 C79 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D1 D2 D03 D04 D5 D6 D10 D11 D12 D13 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E4 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G2 G3 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G20 G21 G23 G24 G25 G26 G27 G28 G29 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J2 J10 J12 J13 J14 J15 J16 J17 J18 J19 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K2 K3 K6 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K20 K21 K22 K23 K26 K27 K28 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L2 L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M4 M5 M7 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N3 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P2 P5 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q3 Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 X1A X1B X1D X1F X1G X1W X2C X3A X3H X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C X43 X44 XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOJ XOK XOL XOM XON XOP XOQ XOR XOS XOT XOU XOV XOW XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ YDK YDQ YRD Z9 Z11 ZP ZZ', '\s')"/>
      <let name="clUNCL7143"
           value="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EMD EN FS GB GMN GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PPI PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ', '\s')"/>
      <rule context="/ubl:TransportExecutionPlan">
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T124-B00101">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T124-B00102">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B00103">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T124-B00104">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T124-B00105">Element 'cbc:IssueTime' MUST be provided.</assert>
         <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T124-B00106">Element 'cac:SenderParty' MUST be provided.</assert>
         <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T124-B00107">Element 'cac:ReceiverParty' MUST be provided.</assert>
         <assert test="cac:TransportUserParty" flag="fatal" id="PEPPOL-T124-B00108">Element 'cac:TransportUserParty' MUST be provided.</assert>
         <assert test="cac:TransportServiceProviderParty"
                 flag="fatal"
                 id="PEPPOL-T124-B00109">Element 'cac:TransportServiceProviderParty' MUST be provided.</assert>
         <assert test="cac:MainTransportationService"
                 flag="fatal"
                 id="PEPPOL-T124-B00110">Element 'cac:MainTransportationService' MUST be provided.</assert>
         <assert test="cac:Consignment" flag="fatal" id="PEPPOL-T124-B00111">Element 'cac:Consignment' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T124-B00112">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cbc:CustomizationID"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:ProfileID"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:ProfileExecutionID"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:IssueDate"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:IssueTime"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:DocumentStatusCode">
         <assert test="(some $code in $clDocumentStatusCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B00801">Value MUST be part of code list 'Document status code (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cbc:Note"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:TransportUserRemarks"/>
      <rule context="/ubl:TransportExecutionPlan/cbc:TransportServiceProviderRemarks"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T124-B01201">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T124-B01202">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B01301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B01302">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B01501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B01601">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B01801">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B02001">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B02601">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B02801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B02901">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B02802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B02002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T124-B03001">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T124-B03002">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B03201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B03202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B03003">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B03401">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B03601">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B03602">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B03801">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B04101">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B04001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B03802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B03402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B04201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:SenderParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B01203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T124-B04601">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T124-B04602">Element 'cac:PartyIdentification' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T124-B04603">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B04701">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B04702">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyIdentification"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B05001">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B05201">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B05401">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B06001">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B06201">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B06301">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B06202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B05402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T124-B06401">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T124-B06402">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B06601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B06602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B06403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B06801">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B07001">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B07002">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B07201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B07501">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B07401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B07202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B06802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B07601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B04604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty">
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T124-B08001">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B08101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B08201">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B08401">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B08601">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B09201">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B09401">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B09501">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B09402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B08602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T124-B09601">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T124-B09602">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B09801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B09802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B09603">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B10001">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B10201">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B10202">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B10401">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B10701">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B10601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B10402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B10002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B10801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B08002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty">
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T124-B11201">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B11301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B11401">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B11601">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B11801">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B12401">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B12601">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B12701">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B12602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B11802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T124-B12801">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T124-B12802">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B13001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B13002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B12803">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B13201">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B13401">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B13402">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B13601">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B13801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B13901">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B13802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B13602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B13202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B14001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B11202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty">
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T124-B14401">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B14501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B14601">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B14602">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B14801">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B15001">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B15601">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B15801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B15901">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B15802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B15002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T124-B16001">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T124-B16002">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B16201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B16202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B16003">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B16401">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B16601">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B16602">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B16801">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B17101">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B17001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B16802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B16402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B17201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:BillToParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B14402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B17601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:IssueDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:IssueTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B17602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B18001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
         <assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B18201">Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment"/>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
         <assert test="@mimeCode" flag="fatal" id="PEPPOL-T124-B18501">Attribute 'mimeCode' MUST be present.</assert>
         <assert test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B18502">Value MUST be part of code list 'Mime code (IANA Subset)'.</assert>
         <assert test="@filename" flag="fatal" id="PEPPOL-T124-B18503">Attribute 'filename' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert test="cbc:URI" flag="fatal" id="PEPPOL-T124-B18801">Element 'cbc:URI' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B18802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B18401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B18002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService">
         <assert test="cbc:TransportServiceCode"
                 flag="fatal"
                 id="PEPPOL-T124-B19001">Element 'cbc:TransportServiceCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService/cbc:TransportServiceCode">
         <assert test="(some $code in $clTransportServiceCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B19101">Value MUST be part of code list 'Transport Service Code (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService/cbc:TransportationServiceDescription"/>
      <rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B19002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService">
         <assert test="cbc:TransportServiceCode"
                 flag="fatal"
                 id="PEPPOL-T124-B19301">Element 'cbc:TransportServiceCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/cbc:TransportServiceCode">
         <assert test="(some $code in $clTransportServiceCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B19401">Value MUST be part of code list 'Transport Service Code (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/cbc:TransportationServiceDescription"/>
      <rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B19302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B19601">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cac:ConsigneeParty" flag="fatal" id="PEPPOL-T124-B19602">Element 'cac:ConsigneeParty' MUST be provided.</assert>
         <assert test="cac:ConsignorParty" flag="fatal" id="PEPPOL-T124-B19603">Element 'cac:ConsignorParty' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clConsignmentIDType satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B19701">Value MUST be part of code list 'Type of Consignment ID (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ConsigneeAssignedID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ConsignorAssignedID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:GrossWeightMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B20101">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:GrossVolumeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B20301">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:LoadingLengthMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B20501">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:HazardousRiskIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:TotalTransportHandlingUnitQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B20801">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B21001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cbc:FunctionCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod">
         <assert test="cbc:StartDate" flag="fatal" id="PEPPOL-T124-B21301">Element 'cbc:StartDate' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B21302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty">
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T124-B21501">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B21601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B21701">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B21901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B22101">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B22701">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B22901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B23001">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B22902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B22102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T124-B23101">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T124-B23102">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B23301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B23302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B23103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B23501">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B23701">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B23702">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B23901">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B24101">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B24201">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B24102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B23902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B23502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B24301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B21502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B24701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
         <assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B24901">Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B24702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B21002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B25101">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B25102">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B25401">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B26301">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B26601">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B26501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B26701">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B26702">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B26703">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B26901">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B26902">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B27101">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B27102">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B27301">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B27302">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B26704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B25701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B25301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B27501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B25103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B28001">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B28002">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B28301">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B29201">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B29501">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B29401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B29601">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B29602">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B29603">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B29801">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B29802">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B30001">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B30002">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B30201">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B30202">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B29604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B28601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B28201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B30401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B28003">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B30901">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B30902">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B31201">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B32101">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B32401">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B32301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B32501">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B32502">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B32503">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B32701">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B32702">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B32901">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B32902">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B33101">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B33102">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B32504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B31501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B31101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B33301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B30903">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B33801">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B33802">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B34101">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B35001">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B35301">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B35201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B35401">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B35402">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B35403">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B35601">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B35602">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B35801">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B35802">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B36001">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B36002">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B35404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B34401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B34001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B36201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B33803">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B36801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B36901">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B37101">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B37301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B37901">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B38101">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B38201">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B38102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B37302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B38301">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B38501">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B38502">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B38701">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B38901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B39001">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B38902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B38702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B38302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B39101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B36701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B39601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B39701">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B39901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B40101">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B40701">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B40901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B41001">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B40902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B40102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B41101">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B41301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B41302">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B41501">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B41801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B41701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B41502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B41102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B41901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B39501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B42401">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B42501">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B42701">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B42901">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B43501">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B43701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B43801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B43702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B42902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B43901">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B44101">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B44102">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B44301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B44501">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B44601">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B44502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B44302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B43902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B44701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person">
         <assert test="cac:IdentityDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T124-B45101">Element 'cac:IdentityDocumentReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B45201">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentType" flag="fatal" id="PEPPOL-T124-B45202">Element 'cbc:DocumentType' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B45203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B45102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B42301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B45501">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B45601">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B45502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B45801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B45701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent">
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B45901">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B46101">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B47001">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B47301">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B47201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B47401">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B47402">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B47403">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B47601">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B47602">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B47801">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B47802">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B48001">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B48002">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B47404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B46401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B46001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B48201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B45902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cbc:SpecialTerms"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B49101">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B49001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B48701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/cbc:Note"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B49401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge">
         <assert test="cbc:ChargeIndicator" flag="fatal" id="PEPPOL-T124-B49701">Element 'cbc:ChargeIndicator' MUST be provided.</assert>
         <assert test="cbc:AllowanceChargeReasonCode"
                 flag="fatal"
                 id="PEPPOL-T124-B49702">Element 'cbc:AllowanceChargeReasonCode' MUST be provided.</assert>
         <assert test="cbc:Amount" flag="fatal" id="PEPPOL-T124-B49703">Element 'cbc:Amount' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:ChargeIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:AllowanceChargeReasonCode">
         <assert test="(some $code in $clFreightAllowanceChargeReasonCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B49901">Value MUST be part of code list 'Freight Allowance-Charge Reason Code'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:Amount">
         <assert test="@currencyID" flag="fatal" id="PEPPOL-T124-B50001">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B49704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage">
         <assert test="cbc:TransportModeCode" flag="fatal" id="PEPPOL-T124-B50201">Element 'cbc:TransportModeCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cbc:TransportModeCode">
         <assert test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B50301">Value MUST be part of code list 'Recommandation 19 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cbc:HazardousRiskIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B50601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B50701">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B50901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B51101">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B51701">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B51901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B52001">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B51902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B51102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B52101">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B52301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B52302">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B52501">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B52701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B52801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B52702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B52502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B52102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B52901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person">
         <assert test="cac:IdentityDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T124-B53301">Element 'cac:IdentityDocumentReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B53401">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentType" flag="fatal" id="PEPPOL-T124-B53402">Element 'cbc:DocumentType' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B53403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B53302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B50501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B53701">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B53702">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B54001">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B54301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B54901">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B55101">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B55201">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B55102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B55301">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B55302">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B55303">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B55501">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B55502">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B55701">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B55702">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B55901">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B55902">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B55304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B54302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B53901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B56101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B53703">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent">
         <assert test="cbc:IdentificationID" flag="fatal" id="PEPPOL-T124-B56601">Element 'cbc:IdentificationID' MUST be provided.</assert>
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B56602">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B56603">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B56901">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B57201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B57601">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B57701">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B57602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B57202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B56801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B57801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B56604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B50202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage">
         <assert test="cbc:TransportModeCode" flag="fatal" id="PEPPOL-T124-B58301">Element 'cbc:TransportModeCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cbc:TransportModeCode">
         <assert test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B58401">Value MUST be part of code list 'Recommandation 19 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B58601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B58701">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B58901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B59101">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B59701">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B59901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B60001">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B59902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B59102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B60101">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B60301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B60302">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B60501">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B60701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B60801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B60702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B60502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B60102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B60901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person">
         <assert test="cac:IdentityDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T124-B61301">Element 'cac:IdentityDocumentReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B61401">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentType" flag="fatal" id="PEPPOL-T124-B61402">Element 'cbc:DocumentType' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B61403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B61302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B58501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B61701">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B61702">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B62001">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B62301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B62901">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B63101">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B63201">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B63102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B63301">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B63302">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B63303">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B63501">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B63502">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B63701">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B63702">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B63901">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B63902">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B63304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B62302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B61901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B64101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B61703">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent">
         <assert test="cbc:IdentificationID" flag="fatal" id="PEPPOL-T124-B64601">Element 'cbc:IdentificationID' MUST be provided.</assert>
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B64602">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B64603">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B64901">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B65201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B65601">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B65701">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B65602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B65202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B64801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B65801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B64604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B58302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage">
         <assert test="cbc:TransportModeCode" flag="fatal" id="PEPPOL-T124-B66301">Element 'cbc:TransportModeCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cbc:TransportModeCode">
         <assert test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B66401">Value MUST be part of code list 'Recommandation 19 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cbc:HazardousRiskIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B66701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B66801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T124-B67001">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B67201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B67801">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B68001">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B68101">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B68002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B67202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T124-B68201">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T124-B68401">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B68402">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B68601">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B68801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B68901">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B68802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B68602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B68202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B69001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person">
         <assert test="cac:IdentityDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T124-B69401">Element 'cac:IdentityDocumentReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B69501">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentType" flag="fatal" id="PEPPOL-T124-B69502">Element 'cbc:DocumentType' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B69503">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B69402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B66601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent">
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B69801">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B69802">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B70101">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B70401">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B71001">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B71201">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B71301">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B71202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B71401">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B71402">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B71403">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B71601">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B71602">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B71801">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B71802">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B72001">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B72002">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B71404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B70402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B70001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B72201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B69803">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent">
         <assert test="cbc:IdentificationID" flag="fatal" id="PEPPOL-T124-B72701">Element 'cbc:IdentificationID' MUST be provided.</assert>
         <assert test="cac:Location" flag="fatal" id="PEPPOL-T124-B72702">Element 'cac:Location' MUST be provided.</assert>
         <assert test="cac:Period" flag="fatal" id="PEPPOL-T124-B72703">Element 'cac:Period' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B73001">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T124-B73301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B73701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B73801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B73702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B73302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B72901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B73901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B72704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B66302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B74401">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:TransportHandlingUnitTypeCode"
                 flag="fatal"
                 id="PEPPOL-T124-B74402">Element 'cbc:TransportHandlingUnitTypeCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clTransportHandlingUnitIDType satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B74501">Value MUST be part of code list 'Type of Transport Handling Unit ID (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode">
         <assert test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B74701">Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HandlingCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HandlingInstructions"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:ShippingMarks"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B75201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:TransportEquipmentTypeCode">
         <assert test="(some $code in $clUNCL8053 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B75401">Value MUST be part of code list 'Transport equipment type code (UNCL8053) '.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:SizeTypeCode">
         <assert test="(some $code in $clTRED8155 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B75501">Value MUST be part of code list 'Size type code (TRED8155)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:RefrigerationOnIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:Description"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:PowerIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B75202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension">
         <assert test="cbc:AttributeID" flag="fatal" id="PEPPOL-T124-B75901">Element 'cbc:AttributeID' MUST be provided.</assert>
         <assert test="cbc:Measure" flag="fatal" id="PEPPOL-T124-B75902">Element 'cbc:Measure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID">
         <assert test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B76001">Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset) T120'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B76101">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B76102">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B75903">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature">
         <assert test="cbc:AttributeID" flag="fatal" id="PEPPOL-T124-B76301">Element 'cbc:AttributeID' MUST be provided.</assert>
         <assert test="cbc:Measure" flag="fatal" id="PEPPOL-T124-B76302">Element 'cbc:Measure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/cbc:AttributeID">
         <assert test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B76401">Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset) T120'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/cbc:Measure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B76501">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B76303">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature">
         <assert test="cbc:AttributeID" flag="fatal" id="PEPPOL-T124-B76701">Element 'cbc:AttributeID' MUST be provided.</assert>
         <assert test="cbc:Measure" flag="fatal" id="PEPPOL-T124-B76702">Element 'cbc:Measure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/cbc:AttributeID">
         <assert test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B76801">Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset) T120'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/cbc:Measure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B76901">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B76703">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:SequenceNumberID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:Description"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:HazardousRiskIndicator"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:Quantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B77601">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification">
         <assert test="cbc:ItemClassificationCode"
                 flag="fatal"
                 id="PEPPOL-T124-B78001">Element 'cbc:ItemClassificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
         <assert test="@listID" flag="fatal" id="PEPPOL-T124-B78101">Attribute 'listID' MUST be present.</assert>
         <assert test="not(@listID) or (some $code in $clUNCL7143 satisfies $code = @listID)"
                 flag="fatal"
                 id="PEPPOL-T124-B78102">Value MUST be part of code list 'Item type identification code (UNCL7143)'.</assert>
         <assert test="@listVersionID" flag="fatal" id="PEPPOL-T124-B78103">Attribute 'listVersionID' MUST be present.</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T124-B78104">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B78002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:AdditionalInformation"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:UNDGCode">
         <assert test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B78801">Value MUST be part of code list 'Dangerous goods regulations code (UNCL8273)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:TechnicalName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:CategoryName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:HazardousCategoryCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:HazardClassID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:NetWeightMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B79301">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B79302">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:NetVolumeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B79501">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B79502">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit">
         <assert test="cbc:PackingCriteriaCode" flag="fatal" id="PEPPOL-T124-B79701">Element 'cbc:PackingCriteriaCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit/cbc:PackingCriteriaCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B79702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature">
         <assert test="cbc:AttributeID" flag="fatal" id="PEPPOL-T124-B79901">Element 'cbc:AttributeID' MUST be provided.</assert>
         <assert test="cbc:Measure" flag="fatal" id="PEPPOL-T124-B79902">Element 'cbc:Measure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/cbc:AttributeID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/cbc:Measure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B80101">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B80102">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B79903">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B78501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B77801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B77101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B80301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:DocumentTypeCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B80302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B74403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T124-B80801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cbc:Name"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:CityName"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T124-B81701">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T124-B81901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B82001">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B81902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate">
         <assert test="cbc:CoordinateSystemCode"
                 flag="fatal"
                 id="PEPPOL-T124-B82101">Element 'cbc:CoordinateSystemCode' MUST be provided.</assert>
         <assert test="cbc:LatitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B82102">Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</assert>
         <assert test="cbc:LongitudeDegreesMeasure"
                 flag="fatal"
                 id="PEPPOL-T124-B82103">Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B82301">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B82302">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B82501">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B82502">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T124-B82701">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T124-B82702">Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B82104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B81101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B80701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T124-B82901">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:DocumentTypeCode">
         <assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T124-B83101">Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B82902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/cac:Consignment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B19604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportExecutionPlan/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T124-B00113">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>

	     <rule context="cbc:CustomizationID">
		       <assert id="PEPPOL-T124-R001"
                 test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1')"
                 flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1'.</assert>
	     </rule>
	     <rule context="cbc:ProfileID">
		       <assert id="PEPPOL-T124-R002"
                 test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1 urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_only:1 urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1', '\s') satisfies $p = normalize-space(.)"
                 flag="fatal">ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1' or 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_only:1' or 'urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1'.</assert>
	     </rule>
	     <rule context="cac:Consignment">
		       <assert id="PEPPOL-T124-R003"
                 test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) &gt;= 0"
                 flag="warning">[PEPPOL-T124-R003]Total transport handling unit quantity SHALL not be negative</assert>
		       <assert id="PEPPOL-T124-R004"
                 test="not(cbc:TotalTransportHandlingUnitQuantity) or not(cac:TransportHandlingUnit) or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)"
                 flag="warning">[PEPPOL-T124-R004] Shipment transport handling unit quantity SHALL match the number of the transport handling units specified</assert>
		       <let name="THUGrossWeight"
              value="round(sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) * 1000)"/>
		       <assert id="PEPPOL-T124-R005"
                 test="not(cbc:GrossWeightMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) or (cbc:GrossWeightMeasure/@unitCode) &gt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or (cbc:GrossWeightMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or ((cbc:GrossWeightMeasure)/xs:decimal(.) * 1000) = $THUGrossWeight"
                 flag="warning">
			[PEPPOL-T124-R005] Gross Weight Measure value must be equal to the sum of the MeasurementDimension/Measure values with AttributeID 'AAB'.
		</assert>

		       <let name="THUGrossVolume"
              value="round(sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure) * 1000)"/>
		       <assert id="PEPPOL-T124-R006"
                 test="not(cbc:GrossVolumeMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure) or (cbc:GrossVolumeMeasure/@unitCode) &gt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or (cbc:GrossVolumeMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or ((cbc:GrossVolumeMeasure)/xs:decimal(.) * 1000) &gt;= $THUGrossVolume"
                 flag="warning">
			[PEPPOL-T124-R006] Gross Volume Measure value must be greater than or equal to the sum of the MeasurementDimension/Measure values with AttributeID 'AAW'.
		</assert>

		       <assert id="PEPPOL-T124-R007"
                 test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))"
                 flag="fatal">[PEPPOL-T124-R007] Either ID or special terms need to be specified in Delivery terms</assert>
		       <assert id="PEPPOL-T124-R008"
                 test="(cbc:GrossWeightMeasure) or (cbc:GrossVolumeMeasure) or (cbc:LoadingLengthMeasure)"
                 flag="warning">[PEPPOL-T124-R008] Either gross weight, gross volume or loading length must be specified</assert>
		       <assert id="PEPPOL-T124-R010"
                 test="not(cac:PaymentTerms) or cac:PaymentTerms/cbc:ID or cac:PaymentTerms/cbc:Note"
                 flag="warning">[PEPPOL-T124-R010] When Payment terms is specified, either the ID or the note must be specified</assert>			
	     </rule>
	
	     <rule context="cac:Period">
		       <assert id="PEPPOL-T124-R011"
                 test="cbc:EndDate or cbc:StartDate"
                 flag="fatal">[PEPPOL-T124-R011] Start date or end date must be spefied in a period</assert>
		       <assert id="PEPPOL-T124-R012"
                 test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')"
                 flag="fatal">[PEPPOL-T124-R012] Start date must be earlier or equal to end date</assert>
		       <assert id="PEPPOL-T124-R013"
                 test="not(cbc:EndTime) or ((cbc:EndTime) and (cbc:StartTime)) or ((cbc:EndDate) and (cbc:EndTime) and not(cbc:StartDate) and not(cbc:StartTime))"
                 flag="fatal">[PEPPOL-T124-R013] EndTime cannot be specified without StartTime</assert>
		       <assert id="PEPPOL-T124-R014"
                 test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)"
                 flag="fatal">[PEPPOL-T124-R014] EndTime cannot be specified without EndDate</assert>
		       <assert id="PEPPOL-T124-R015"
                 test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) "
                 flag="fatal">[PEPPOL-T124-R015] StartTime must be before EndTime</assert>
		       <assert id="PEPPOL-T124-R016"
                 test="not(cbc:StartTime) or count(timezone-from-time(cbc:StartTime)) &gt; 0"
                 flag="fatal"> [PEPPOL-T124-R016] IssueTime MUST include timezone information.</assert>
		       <assert id="PEPPOL-T124-R017"
                 test="not(cbc:EndTime) or count(timezone-from-time(cbc:EndTime)) &gt; 0"
                 flag="fatal"> [PEPPOL-T124-R017] IssueTime MUST include timezone information.</assert>
	     </rule>

	     <rule context="ubl:TransportExecutionPlan/cbc:IssueTime">
		       <assert id="PEPPOL-T124-R018"
                 test="count(timezone-from-time(.)) &gt; 0"
                 flag="fatal"> [PEPPOL-T124-R018] IssueTime MUST include timezone information.</assert>
	     </rule>

	     <rule context="ubl:TransportExecutionPlan/cac:SenderParty">
		       <assert id="PEPPOL-T124-R031"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R031] Party must include either a party name or a party identification.</assert>
	     </rule>
	     <rule context="ubl:TransportExecutionPlan/cac:ReceiverParty">
		       <assert id="PEPPOL-T124-R032"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R032] Party must include either a party name or a party identification.</assert>
	     </rule>
	     <rule context="ubl:TransportExecutionPlan/cac:TransportUserParty">
		       <assert id="PEPPOL-T124-R033"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R033] Party must include either a party name or a party identification.</assert>
	     </rule>
	     <rule context="ubl:TransportExecutionPlan/cac:TransportServiceProviderParty">
		       <assert id="PEPPOL-T124-R034"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R034] Party must include either a party name or a party identification.</assert>
	     </rule>
	     <rule context="ubl:TransportExecutionPlan">
		       <assert id="PEPPOL-T124-R035"
                 test="not(cac:BillToParty) or cac:BillToParty/cac:PartyName or cac:BillToParty/cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R035] Party must include either a party name or a party identification.</assert>
		       <assert id="PEPPOL-T124-R040"
                 test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24'))      or (cac:Consignment/cac:PlannedPickupTransportEvent)"
                 flag="fatal">[PEPPOL-T124-R040] cac:Consignment/cac:PlannedPickupTransportEvent must be present when cac:MainTransportationService = "4", "22", "23" or "24".</assert>
		       <assert id="PEPPOL-T124-R041"
                 test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24'))      or (cac:Consignment/cac:PlannedDeliveryTransportEvent)"
                 flag="fatal">[PEPPOL-T124-R041] cac:Consignment/cac:PlannedDeliveryTransportEvent must be present when cac:MainTransportationService = "4", "22", "23" or "24".</assert>
		       <assert id="PEPPOL-T124-R042"
                 test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24'))      or (cac:Consignment/cac:MainCarriageShipmentStage)"
                 flag="fatal">[PEPPOL-T124-R042] cac:Consignment/cac:MainCarriageShipmentStage must be present when cac:MainTransportationService = "4", "22", "23" or "24".</assert>
	     </rule>
	     <rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty">
		       <assert id="PEPPOL-T124-R036"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R036] Party must include either a party name or a party identification.</assert>
	     </rule>
	     <rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty">
		       <assert id="PEPPOL-T124-R037"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R037] Party must include either a party name or a party identification.</assert>
	     </rule>

	     <rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage">
		       <assert id="PEPPOL-T124-R030"
                 test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R030] Party must include either a party name or a party identification.</assert>
	     </rule>
	
	     <rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage">
		       <assert id="PEPPOL-T124-R038"
                 test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R038] Party must include either a party name or a party identification.</assert>
	     </rule>
	
	     <rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage">
		       <assert id="PEPPOL-T124-R039"
                 test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T124-R039] Party must include either a party name or a party identification.</assert>
	     </rule>
   </pattern>    

</schema>
