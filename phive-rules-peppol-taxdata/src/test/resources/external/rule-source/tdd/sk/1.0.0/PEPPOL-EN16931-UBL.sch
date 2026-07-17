<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">
  <title>Rules for Peppol BIS 3.0 Billing</title>
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
  <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
  <ns uri="urn:peppol:schema:sk-taxdata:1.0" prefix="pxs-taxdata"/>
  <ns uri="utils" prefix="u"/>
  
   
    
  <let name="profile" value="if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID and (matches(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:selfbilling:([0-9]{2}):1.0') or matches(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')))        then          tokenize(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID), ':')[7]        else          'Unknown'"/>
  <let name="supplierCountry" value="       if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then         upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))       else         if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then           upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))         else           if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then             upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))           else             'XX'"/>
  <let name="customerCountry" value="   if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then   upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))   else   if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then   upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))   else   'XX'"/>
  
  <let name="supplierCountryIsDE" value="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')"/>
  <let name="customerCountryIsDE" value="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')"/>

  <let name="documentCurrencyCode" value="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:DocumentCurrencyCode"/>
  
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
    <param name="val"/>
    <variable name="length" select="string-length($val) - 1"/>
    <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
    <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
    <sequence select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
    <param name="exp" as="xs:decimal"/>
    <param name="val" as="xs:decimal"/>
    <param name="slack" as="xs:decimal"/>
   <sequence select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
    <param name="val"/>
    <variable name="length" select="string-length($val) - 1"/>
    <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
    <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
    <sequence select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod97-0208" as="xs:boolean">
    <param name="val"/>
    <variable name="checkdigits" select="substring($val,9,2)"/>
    <variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
    <sequence select="number($checkdigits) = number($calculated_digits)"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCodiceIPA" as="xs:boolean">
    <param name="arg" as="xs:string?"/>
    <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
    <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCF" as="xs:boolean">
    <param name="arg" as="xs:string?"/>
    <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCF16" as="xs:boolean">
    <param name="arg" as="xs:string?"/>
    <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
    <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVAseIT" as="xs:boolean">
    <param name="arg" as="xs:string"/>
    <variable name="paese" select="substring($arg,1,2)"/>
    <variable name="codice" select="substring($arg,3)"/>
    <sequence select="     if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then     (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVA" as="xs:integer">
    <param name="arg" as="xs:string?"/>
    <sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:addPIVA" as="xs:integer">
    <param name="arg" as="xs:string"/>
    <param name="pari" as="xs:integer"/>
    <variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1"/>
    <variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
    <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:abn" as="xs:boolean">
    <param name="val"/>
    <sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
  </function>

  
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:TinVerification" as="xs:boolean">
    <param name="val" as="xs:string"/>
    <variable name="digits" select="    for $ch in string-to-codepoints($val)    return codepoints-to-string($ch)"/>
    <variable name="checksum" select="    (number($digits[8])*2) +    (number($digits[7])*4) +    (number($digits[6])*8) +    (number($digits[5])*16) +    (number($digits[4])*32) +    (number($digits[3])*64) +    (number($digits[2])*128) +    (number($digits[1])*256) "/>
    <sequence select="($checksum  mod 11) mod 10 = number($digits[9])"/>
  </function>

  
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkSEOrgnr" as="xs:boolean">
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
      <assert id="PEPPOL-EN16931-R008" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
    </rule>
  </pattern>
  
  
  <pattern>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument">
      <assert id="PEPPOL-EN16931-R001" test="cbc:ProfileID" flag="fatal">Business process MUST be provided.</assert>
      <assert id="PEPPOL-EN16931-R007" test="$profile != 'Unknown'" flag="fatal">Business process MUST be in the format 'urn:fdc:peppol.eu:2017:poacc:billing:NN:1.0' or 'urn:fdc:peppol.eu:2017:poacc:selfbilling:NN:1.0' where NN indicates the process number.</assert>
      <assert id="PEPPOL-EN16931-R002" test="count(cbc:Note) &lt;= 1 or ($supplierCountryIsDE and $customerCountryIsDE)" flag="fatal">No more than one note is allowed on document level, unless both the buyer and seller are German organizations.</assert>
      
    
      <assert id="PEPPOL-EN16931-R004" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:selfbilling:3.0')" flag="fatal">Specification identifier MUST have the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0' or 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:selfbilling:3.0'.</assert>
      <assert id="PEPPOL-EN16931-R053" test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1" flag="fatal">Only one tax total with tax subtotals MUST be provided.</assert>
      <assert id="PEPPOL-EN16931-R054" test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)" flag="fatal">Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</assert>
      <assert id="PEPPOL-EN16931-R055" test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) " flag="fatal">Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</assert>
    </rule>

    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:TaxCurrencyCode">
      <assert id="PEPPOL-EN16931-R005" test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))" flag="fatal">VAT accounting currency code MUST be different from invoice currency code when provided.</assert>
    </rule>

    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | pxs-taxdata:DocumentLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
      <assert id="PEPPOL-EN16931-R041" test="false()" flag="fatal">Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | pxs-taxdata:DocumentLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
      <assert id="PEPPOL-EN16931-R042" test="false()" flag="fatal">Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge | pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:AllowanceCharge">
      <assert id="PEPPOL-EN16931-R040" test="           not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then             cbc:Amount           else             0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" flag="fatal">Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</assert>
      <assert id="PEPPOL-EN16931-R043" test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'" flag="fatal">Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
    </rule>

    
     
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[some $code in tokenize('49 59', '\s') satisfies normalize-space(cbc:PaymentMeansCode) = $code]">
      <assert id="PEPPOL-EN16931-R061" test="cac:PaymentMandate/cbc:ID" flag="fatal">Mandate reference MUST be provided for direct debit.</assert>
    </rule>
    
    <rule context="/*/cbc:Amount | /*/cbc:BaseAmount | /*/cbc:PriceAmount | /*/cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | /*/cac:TaxSubtotal/cbc:TaxAmount |/*/cbc:TaxableAmount | /*/cbc:LineExtensionAmount | /*/cbc:TaxExclusiveAmount | /*/cbc:TaxInclusiveAmount | /*/cbc:AllowanceTotalAmount | /*/cbc:ChargeTotalAmount | /*/cbc:PrepaidAmount | /*/cbc:PayableRoundingAmount | /*/cbc:PayableAmount">
      <assert id="PEPPOL-EN16931-R051" test="@currencyID = $documentCurrencyCode" flag="fatal">All currencyID attributes must have the same value as the invoice currency code (BT-5), except for the invoice total VAT amount in accounting currency (BT-111).</assert>
    </rule>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[cac:InvoicePeriod/cbc:StartDate]/pxs-taxdata:DocumentLine/cac:InvoicePeriod/cbc:StartDate">
      <assert id="PEPPOL-EN16931-R110" test="xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)" flag="fatal">Start date of line period MUST be within invoice period.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[cac:InvoicePeriod/cbc:EndDate]/pxs-taxdata:DocumentLine/cac:InvoicePeriod/cbc:EndDate">
      <assert id="PEPPOL-EN16931-R111" test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)" flag="fatal">End date of line period MUST be within invoice period.</assert>
    </rule>
    
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine">
    
      <let name="lineExtensionAmount" value="           if (cbc:LineExtensionAmount) then             xs:decimal(cbc:LineExtensionAmount)           else             0"/>
      <let name="quantity" value="           if (cbc:InvoicedQuantity) then               xs:decimal(cbc:InvoicedQuantity)             else               1"/>
      <let name="priceAmount" value="           if (cac:Price/cbc:PriceAmount) then             xs:decimal(cac:Price/cbc:PriceAmount)           else             0"/>
      <let name="baseQuantity" value="           if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then             xs:decimal(cac:Price/cbc:BaseQuantity)           else             1"/>
      <let name="allowancesTotal" value="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
      <let name="chargesTotal" value="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
      <assert id="PEPPOL-EN16931-R120" test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)" flag="fatal">Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</assert>
      <assert id="PEPPOL-EN16931-R121" test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0" flag="fatal">Base quantity MUST be a positive number above zero.</assert>

    </rule>
    
    
    <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088']">
      <assert id="PEPPOL-COMMON-R040" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())" flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192']">
      <assert id="PEPPOL-COMMON-R041" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184']">
      <assert id="PEPPOL-COMMON-R042" test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)                or               (string-length(string()) = 8) and (string-length(translate(substring(string(), 1, 8),'1234567890', '')) = 0)" flag="fatal">Danish organization number (CVR) MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096']">
      <assert id="PEPPOL-COMMON-R052" test="(string-length(string()) = 10) and (string-length(translate(substring(string(), 1, 10),'1234567890', '')) = 0)" flag="warning">Danish chamber of commerce number (P) MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198']">
      <assert id="PEPPOL-COMMON-R053" test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)" flag="warning">Danish ERSTORG number (SE) MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208']">
      <assert id="PEPPOL-COMMON-R043" test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())" flag="fatal">Belgian enterprise number MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201']">
      <assert id="PEPPOL-COMMON-R044" test="u:checkCodiceIPA(normalize-space())" flag="warning">IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210']">
      <assert id="PEPPOL-COMMON-R045" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '9907']">
      <assert id="PEPPOL-COMMON-R046" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211']">
      <assert id="PEPPOL-COMMON-R047" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
    </rule>
    
    <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007']">
      <assert id="PEPPOL-COMMON-R049" test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())" flag="fatal">Swedish organization number MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151']">
      <assert id="PEPPOL-COMMON-R050" test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())" flag="fatal">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
    </rule>
  </pattern>
  
  <pattern>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NO']">
      <assert id="NO-R-001" test="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO' and matches(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID,3), '^[0-9]{9}MVA$')           and u:mod11(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID, 3, 9)) or not(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO')" flag="fatal">For Norwegian suppliers, a VAT number MUST be the country code prefix NO followed by a valid Norwegian organization number (nine numbers) followed by the letters MVA.</assert>
    </rule>
  </pattern>
  
  <pattern>
    <let name="DKSupplierCountry" value="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
    <let name="DKCustomerCountry" value="//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
    
   
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']">
      <assert id="DK-R-016" test="not((cbc:DocumentTypeCode = ('381','396','81','83','532')) and (number(pxs-taxdata:MonetaryTotal/cbc:PayableAmount/text()) &lt; 0))" flag="fatal">For Danish Suppliers, a Credit note cannot have a negative total (PayableAmount)</assert>
    </rule>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans">
      <assert id="DK-R-005" test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))" flag="fatal">For Danish suppliers the following Payment means codes are allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97</assert>
      <assert id="DK-R-006" test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))       and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))       )" flag="fatal">For Danish suppliers bank account and registration account is mandatory if payment means is 31 or 42</assert>
      <assert id="DK-R-007" test="not((cbc:PaymentMeansCode = '49')       and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '')           and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != ''))       )" flag="fatal">For Danish suppliers PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when payment means is 49</assert>
      <assert id="DK-R-008" test="not((cbc:PaymentMeansCode = '50')       and not(((substring(cbc:PaymentID, 1, 3) = '01#')           or (substring(cbc:PaymentID, 1, 3) = '04#')           or (substring(cbc:PaymentID, 1, 3) = '15#'))         and matches(cac:PayeeFinancialAccount/cbc:ID, '^[0-9]{7,8}$')         )       )" flag="fatal">For Danish Suppliers PaymentID is mandatory and MUST start with 01#, 04# or 15# (kortartkode), and PayeeFinancialAccount/ID (Giro kontonummer) is mandatory and must be 7 or 8 numerical characters long, when payment means equals 50 (Giro)</assert>
      <assert id="DK-R-009" test="not((cbc:PaymentMeansCode = '50')       and ((substring(cbc:PaymentID, 1, 3) = '04#')          or (substring(cbc:PaymentID, 1, 3)  = '15#'))       and not(string-length(cbc:PaymentID) = 19)       )" flag="fatal">For Danish Suppliers if the PaymentID is prefixed with 04# or 15# the 16 digits instruction Id must be added to the PaymentID eg. "04#1234567890123456" when Payment means equals 50 (Giro)</assert>
      <assert id="DK-R-010" test="not((cbc:PaymentMeansCode = '93')       and not(((substring(cbc:PaymentID, 1, 3) = '71#')           or (substring(cbc:PaymentID, 1, 3) = '73#')           or (substring(cbc:PaymentID, 1, 3) = '75#'))         and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8)         )       )" flag="fatal">For Danish Suppliers the PaymentID is mandatory and MUST start with 71#, 73# or 75# (kortartkode) and CreditAccount/AccountID (Kreditornummer) is mandatory and MUST be exactly 8 characters long, when Payment means equals 93 (FIK)</assert>
      <assert id="DK-R-011" test="not((cbc:PaymentMeansCode = '93')       and ((substring(cbc:PaymentID, 1, 3) = '71#')          or (substring(cbc:PaymentID, 1, 3)  = '75#'))       and not((string-length(cbc:PaymentID) = 18)          or (string-length(cbc:PaymentID) = 19))       )" flag="fatal">For Danish Suppliers if the PaymentID is prefixed with 71# or 75# the 15-16 digits instruction Id must be added to the PaymentID eg. "71#1234567890123456" when payment Method equals 93 (FIK)</assert>
    </rule>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/pxs-taxdata:DocumentLine">
      <assert id="DK-R-003" test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST')       and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01')           or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501')                                or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.08.01')                                or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.0801')           )       )" flag="warning">If ItemClassification is provided from Danish suppliers, UNSPSC version 19.05.01 or 26.08.01 should be used.</assert>
    </rule>
    
    
    <rule context="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']">
      <assert id="DK-R-004" test="not((cbc:AllowanceChargeReasonCode = 'ZZZ')       and not(((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4)         and (number(cbc:AllowanceChargeReason) &gt;= 0)         and (number(cbc:AllowanceChargeReason) &lt;= 9999)) or         (((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#')                                   and not(starts-with(cbc:AllowanceChargeReason, '#'))                                   and not(ends-with(cbc:AllowanceChargeReason, '#')))) )                                )      )" flag="fatal">When specifying non-VAT Taxes for Danish customers, Danish suppliers MUST use the AllowanceChargeReasonCode="ZZZ" and MUST be specified in AllowanceChargeReason; Either as the 4-digit Tax category or must include a #, but the # is not allowed as first and last character</assert>
    </rule>
  </pattern>
  
  
  <pattern>
    <rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']">
      <assert id="SE-R-001" test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14" flag="fatal">For Swedish suppliers, Swedish VAT-numbers must consist of 14 characters.</assert>
      <assert id="SE-R-002" test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'" flag="fatal">For Swedish suppliers, the Swedish VAT-numbers must have the trailing 12 characters in numeric form</assert>
    </rule>
    
    <rule context="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S']">
      <assert id="SE-R-006" test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6" flag="fatal">For Swedish suppliers, only standard VAT rate of 6, 12 or 25 are used</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID">
      <assert id="SE-R-007" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must be numeric </assert>
      <assert id="SE-R-010" test="string-length(normalize-space(.)) &gt;= 2 and string-length(normalize-space(.)) &lt;= 8" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must have 2-8 characters</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID">
      <assert id="SE-R-008" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must be numeric </assert>
      <assert id="SE-R-009" test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must have 7-8 characters</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]">
      <assert id="SE-R-011" test="false()" flag="warning">For Swedish suppliers using Swedish Bankgiro or Plusgiro, the proper way to indicate this is to use Code 30 for PaymentMeans and FinancialInstitutionBranch ID with code SE:BANKGIRO or SE:PLUSGIRO</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]">
      <assert id="SE-R-012" test="false()" flag="warning">For domestic transactions between Swedish trading partners, credit transfer should be indicated by PaymentMeansCode="30"</assert>
    </rule>
  </pattern>
  
  
  <let name="isGreekSender" value="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
  <let name="isGreekReceiver" value="($customerCountry ='GR') or ($customerCountry ='EL')"/>
  <let name="isGreekSenderandReceiver" value="$isGreekSender and $isGreekReceiver"/>
  
  <let name="accountingSupplierCountry" value="     if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then     upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))     else     if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then     upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))     else     'XX'"/>
  
  <pattern>
    <let name="dateRegExp" value="'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]{2}'"/>
    <let name="greekDocumentType" value="tokenize('1.1 1.6 2.1 2.4 5.1 5.2 ','\s')"/>
    <let name="tokenizedUblIssueDate" value="tokenize(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:IssueDate,'-')"/>
    
    <rule context="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ID[$isGreekSender]">
      <let name="IdSegments" value="tokenize(.,'\|')"/>
      <assert id="GR-R-001-1" test="count($IdSegments) = 6" flag="fatal"> When the Supplier is Greek, the Invoice Id should consist of 6 segments</assert>
      <assert id="GR-R-001-2" test="string-length(normalize-space($IdSegments[1])) = 9                                   and u:TinVerification($IdSegments[1])                                  and ($IdSegments[1] = /*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9)                                  or $IdSegments[1] = /*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )" flag="fatal">When the Supplier is Greek, the Invoice Id first segment must be a valid TIN Number and match either the Supplier's or the Tax Representative's Tin Number</assert>
      <let name="tokenizedIdDate" value="tokenize($IdSegments[2],'/')"/>
      <assert id="GR-R-001-3" test="string-length(normalize-space($IdSegments[2]))&gt;0                                   and matches($IdSegments[2],$dateRegExp)                                  and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3]                                     and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2]                                    and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])" flag="fatal">When the Supplier is Greek, the Invoice Id second segment must be a valid Date that matches the invoice Issue Date</assert>
      <assert id="GR-R-001-4" test="string-length(normalize-space($IdSegments[3]))&gt;0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) &gt;= 0" flag="fatal">When Supplier is Greek, the Invoice Id third segment must be a positive integer</assert>
      <assert id="GR-R-001-5" test="string-length(normalize-space($IdSegments[4]))&gt;0 and (some $c in $greekDocumentType satisfies $IdSegments[4] = $c)" flag="fatal">When Supplier is Greek, the Invoice Id in the fourth segment must be a valid greek document type</assert>
      <assert id="GR-R-001-6" test="string-length($IdSegments[5]) &gt; 0 " flag="fatal">When Supplier is Greek, the Invoice Id fifth segment must not be empty</assert>
      <assert id="GR-R-001-7" test="string-length($IdSegments[6]) &gt; 0 " flag="fatal">When Supplier is Greek, the Invoice Id sixth segment must not be empty</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty[$isGreekSender]/cac:Party">
      
      <assert id="GR-R-002" test="string-length(./cac:PartyName/cbc:Name)&gt;0" flag="fatal">Greek Suppliers must provide their full name as they are registered in the Greek Business Registry (G.E.MH.) as a legal entity or in the Tax Registry as a natural person </assert>
      
      <assert id="GR-S-011" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and                             substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and                             u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="warning">Greek suppliers must provide their Seller Tax Registration Number, prefixed by the country code</assert>
    </rule>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID">
      <assert id="GR-R-003" test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))" flag="fatal">For the Greek Suppliers, the VAT must start with 'EL' and must be a valid TIN number</assert>
    </rule>

    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty[$isGreekSender]/cac:Party">
      <assert id="GR-R-005" test="string-length(./cac:PartyName/cbc:Name)&gt;0" flag="fatal">Greek Suppliers must provide the full name of the buyer</assert>
    </rule>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID">
      <assert id="GR-R-009" test="./@schemeID='9933' and u:TinVerification(.)" flag="fatal">Greek suppliers that send an invoice through the PEPPOL network must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (schemeID 9933).</assert>
    </rule>
  </pattern>
  
  <pattern>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party">
      <assert id="GR-R-006" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and                             substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and                             u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="fatal">Greek Suppliers must provide the VAT number of the buyer, if the buyer is Greek </assert>
    </rule>
   
  </pattern>
  
  <pattern>
    <let name="SupplierCountry" value="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
    <let name="CustomerCountry" value="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
    <rule context="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$SupplierCountry = 'IS']">
      <assert id="IS-R-001" test="( ( not(contains(normalize-space(pxs-taxdata:DocumentTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(pxs-taxdata:DocumentTypeCode),' ') ) ) )" flag="warning">[IS-R-001]-If seller is icelandic then invoice type should be 380 or 381 — Ef seljandi er íslenskur þá ætti gerð reiknings (BT-3) að vera sölureikningur (380) eða kreditreikningur (381).</assert>
      <assert id="IS-R-006" test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)         and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12        or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))" flag="fatal">[IS-R-006]-If seller is icelandic and payment means code is 9 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er krafa (kóti 9) þá skal koma fram 12 stafa númer (bankanúmer, höfuðbók 66 og reikningsnúmer) (BT-84)</assert>
      <assert id="IS-R-007" test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)         and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12        or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))" flag="fatal">[IS-R-007]-If seller is icelandic and payment means code is 42 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 42) þá skal koma fram 12 stafa reikningnúmer (BT-84)</assert>
      </rule>
    
  </pattern>
  
  <pattern>
    <let name="supplierCountryIsNL" value="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
    <let name="customerCountryIsNL" value="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
    <let name="taxRepresentativeCountryIsNL" value="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
    <rule context="pxs-taxdata:DocumentTypeCode[.='381'][$supplierCountryIsNL]">
      
      <assert id="NL-R-001" test="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" flag="fatal">[NL-R-001] For suppliers in the Netherlands, if the document is a creditnote, the document MUST contain an invoice reference (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID)</assert>
    </rule>
    
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:MonetaryTotal[$supplierCountryIsNL]">
      
      <assert id="NL-R-007" test="(../pxs-taxdata:DocumentTypeCode[.='71' or .='80' or .='82' or .='84' or .='102' or .='218' or .='219' or .='326' or .='331' or .='380' or .='382' or .='383' or .='384' or .='386' or .='388' or .='393' or .='395' or .='553' or .='575' or .='623' or .='780' or .='817' or .='870' or .='875' or .='876' or .='877'] and xs:decimal(cbc:PayableAmount) &lt;= 0.0) or (../pxs-taxdata:DocumentTypeCode[.='381' or .='396' or .='81' or .='83' or .='532'] and xs:decimal(cbc:PayableAmount) &gt;= 0.0) or (//cac:PaymentMeans)" flag="fatal">[NL-R-007] For suppliers in the Netherlands, the supplier MUST provide a means of payment (cac:PaymentMeans) if the payment is from customer to supplier</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[$supplierCountryIsNL and $customerCountryIsNL]">
      
      <assert id="NL-R-008" test="normalize-space(cbc:PaymentMeansCode) = '30' or         normalize-space(cbc:PaymentMeansCode) = '48' or         normalize-space(cbc:PaymentMeansCode) = '49' or         normalize-space(cbc:PaymentMeansCode) = '57' or         normalize-space(cbc:PaymentMeansCode) = '58' or         normalize-space(cbc:PaymentMeansCode) = '59'" flag="fatal">[NL-R-008] For suppliers in the Netherlands, if the customer is in the Netherlands, the payment means code (cac:PaymentMeans/cbc:PaymentMeansCode) MUST be one of 30, 48, 49, 57, 58 or 59</assert>
    </rule>
   
  </pattern>
  
  <pattern id="german-rules">
    <let name="XR-SKONTO-REGEX" value="'#(SKONTO)#TAGE=([0-9]+#PROZENT=[0-9]+\.[0-9]{2})(#BASISBETRAG=-?[0-9]+\.[0-9]{2})?#$'"/>
    <let name="XR-EMAIL-REGEX" value="'^[a-zA-Z0-9!#\$%&amp;&#34;*+/=?^_`{|}~-]+(\.[a-zA-Z0-9!#\$%&amp;&#34;*+/=?^_`{|}~-]+)*@([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$'"/>
    <let name="XR-TELEPHONE-REGEX" value="'.*([0-9].*){3,}.*'"/>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:ReportedDocument[$supplierCountryIsDE and $customerCountryIsDE]">
      <assert test="cac:PaymentMeans" flag="fatal" id="DE-R-001">An invoice shall contain information on "PAYMENT INSTRUCTIONS" (BG-16).</assert>
     
      <let name="supportedVATCodes" value="('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')"/>
      <let name="BT-31orBT-32Path" value="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))]"/>
      <let name="BT-95-UBL-Inv" value="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and         following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
      <let name="BT-95-UBL-CN" value="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']"/>
      <let name="BT-102" value="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']"/>
      <let name="BT-151" value="(pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID)"/>
      
      <assert test="         (not(           ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or           ($BT-102 = $supportedVATCodes) or           ($BT-151 = $supportedVATCodes)         ) or         (cac:TaxRepresentativeParty, $BT-31orBT-32Path))         " flag="fatal" id="DE-R-016">If one of the VAT codes S, Z, E, AE, K, G, L, or M is used, an invoice shall contain at least one of the following elements: "Seller VAT identifier" (BT-31) or "Seller tax registration identifier" (BT-32) or "SELLER TAX REPRESENTATIVE PARTY" (BG-11).</assert>
      <let name="supportedInvAndCNTypeCodes" value="('326', '380', '384', '389', '381', '875', '876', '877')"/>
      <assert test="pxs-taxdata:DocumentTypeCode = $supportedInvAndCNTypeCodes" flag="warning" id="DE-R-017">The element "Invoice type code" (BT-3) should only contain the following values from code list UNTDID 1001: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice), 381 (Credit note), 875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
      <assert test="((not(pxs-taxdata:DocumentTypeCode = 384) or                     (cac:BillingReference/cac:InvoiceDocumentReference)))" flag="warning" id="DE-R-026">If "Invoice type code" (BT-3) contains the code 384 (Corrected invoice), "PRECEDING INVOICE REFERENCE" (BG-3) should be provided at least once.</assert>
       <assert test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)" flag="fatal" id="DE-R-031">If the group "DIRECT DEBIT" (BG-19) is delivered, the element "Debited account identifier" (BT-91) shall be provided.</assert>
    </rule>
    
    
   
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)][$supplierCountryIsDE and $customerCountryIsDE]">
      
      <assert test="not(cbc:PaymentMeansCode = '58') or matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1" flag="warning" id="DE-R-019">The element "Payment account identifier" (BT-84) should contain a valid IBAN if code 58 SEPA is provided in "Payment means type code" (BT-81).</assert>
      <assert test="cac:PayeeFinancialAccount" flag="fatal" id="DE-R-023-1">If "Payment means type code" (BT-81) contains a code for credit transfer (30, 58), "CREDIT TRANSFER" (BG-17) shall
        be provided.</assert>
      <assert test="not(cac:CardAccount) and                     not(cac:PaymentMandate)" flag="fatal" id="DE-R-023-2">If "Payment means type code" (BT-81) contains a code for credit transfer (30, 58), BG-18 and BG-19 shall not be provided.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)][$supplierCountryIsDE and $customerCountryIsDE]">
      <assert test="cac:CardAccount" flag="fatal" id="DE-R-024-1">If "Payment means type code" (BT-81) contains a code for payment card (48, 54, 55), "PAYMENT CARD INFORMATION" (BG-18) shall be provided.</assert>
      <assert test="not(cac:PayeeFinancialAccount) and                     not(cac:PaymentMandate)" flag="fatal" id="DE-R-024-2">If "Payment means type code" (BT-81) contains a code for payment card (48, 54, 55), BG-17 and BG-19 shall not be provided.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[cbc:PaymentMeansCode = 59][$supplierCountryIsDE and $customerCountryIsDE]">
      <assert test="not(cbc:PaymentMeansCode = '59') or                     matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1" flag="warning" id="DE-R-020">The element "Debited account identifier" (BT-91) should contain a valid IBAN if code 59 SEPA is provided in "Payment means type code" (BT-81). </assert>
      <assert test="cac:PaymentMandate" flag="fatal" id="DE-R-025-1">If "Payment means type code" (BT-81) contains a code for direct debit (59), "DIRECT DEBIT" (BG-19) shall be provided.</assert>
      <assert test="not(cac:PayeeFinancialAccount) and                     not(cac:CardAccount)" flag="fatal" id="DE-R-025-2">If "Payment means type code" (BT-81) contains a code for direct debit (59), BG-17 and BG-18 shall not be provided.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal[$supplierCountryIsDE and $customerCountryIsDE]">
      <assert test="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]" flag="fatal" id="DE-R-014">The element "VAT category rate" (BT-119) shall be provided.</assert>
    </rule>
  </pattern>
  
<pattern>
    <let name="ISO3166" value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
    <let name="ISO4217" value="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VED VES VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWG XXX CNH', '\s')"/>
    <let name="MIMECODE" value="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
    <let name="UNCL2005" value="tokenize('3 35 432', '\s')"/>
    <let name="UNCL5189" value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
    <let name="UNCL7161" value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL PRV RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
    <let name="UNCL5305" value="tokenize('AE E S Z G O K L M B', '\s')"/>
    <let name="eaid" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 0147 0154 0158 0170 0194 0203 0205 0217 0225 0240 0242 0244 0245', '\s')"/>
    
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode">
      <assert id="PEPPOL-EN16931-CL002" test="           some $code in $UNCL5189             satisfies normalize-space(text()) = $code" flag="fatal">Reason code MUST be according to subset of UNCL 5189 D.16B.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode">
      <assert id="PEPPOL-EN16931-CL003" test="           some $code in $UNCL7161             satisfies normalize-space(text()) = $code" flag="fatal">Reason code MUST be according to UNCL 7161 D.16B.</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:InvoicePeriod/cbc:DescriptionCode">
      <assert id="PEPPOL-EN16931-CL006" test="           some $code in $UNCL2005             satisfies normalize-space(text()) = $code" flag="fatal">Invoice period description code must be according to UNCL 2005 D.16B.</assert>
    </rule>
    <rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
      <assert id="PEPPOL-EN16931-CL007" test="           some $code in $ISO4217             satisfies @currencyID = $code" flag="fatal">Currency code must be according to ISO 4217:2005</assert>
    </rule>
    <rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentTypeCode">
      <assert id="PEPPOL-EN16931-P0100" test="           $profile != '01' or (some $code in tokenize('71 80 82 84 102 218 219 261 326 331 380 382 383 384 386 388 389 393 395 553 575 623 780 817 870 875 876 877 381 396 81 83 527 532', '\s')             satisfies normalize-space(text()) = $code)" flag="fatal">Invoice/Credit note type code MUST be set according to the profile.</assert>
      <assert id="PEPPOL-EN16931-P0112" test="not(normalize-space(.) = '326' or normalize-space(.) = '384') or ($supplierCountryIsDE and $customerCountryIsDE)" flag="fatal">Invoice type code 326 or 384 are only allowed when both buyer and seller are German organizations </assert>		
    </rule>
		
    <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
      <assert id="PEPPOL-EN16931-F001" test="string-length(text()) = 10 and (string(.) castable as xs:date)" flag="fatal">A date MUST be formatted YYYY-MM-DD.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID]">
      <assert id="PEPPOL-EN16931-CL008" test="         some $code in $eaid         satisfies @schemeID = $code" flag="fatal">Electronic address identifier scheme must be from the codelist "Electronic Address Identifier Scheme"</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']">
      <assert id="PEPPOL-EN16931-P0104" test="normalize-space(cbc:ID)='G'" flag="fatal">Tax Category G MUST be used when exemption reason code is VATEX-EU-G</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']">
      <assert id="PEPPOL-EN16931-P0105" test="normalize-space(cbc:ID)='O'" flag="fatal">Tax Category O MUST be used when exemption reason code is VATEX-EU-O</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']">
      <assert id="PEPPOL-EN16931-P0106" test="normalize-space(cbc:ID)='K'" flag="fatal">Tax Category K MUST be used when exemption reason code is VATEX-EU-IC</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']">
      <assert id="PEPPOL-EN16931-P0107" test="normalize-space(cbc:ID)='AE'" flag="fatal">Tax Category AE MUST be used when exemption reason code is VATEX-EU-AE</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']">
      <assert id="PEPPOL-EN16931-P0108" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-D</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']">
      <assert id="PEPPOL-EN16931-P0109" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-F</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']">
      <assert id="PEPPOL-EN16931-P0110" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-I</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']">
      <assert id="PEPPOL-EN16931-P0111" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-J</assert>
    </rule>
  </pattern>
  
</schema>