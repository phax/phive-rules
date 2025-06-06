<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
    <xsl:param name="val" />
    <xsl:variable name="length" select="string-length($val) - 1" />
    <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
    <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))" />
    <xsl:value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))" />
</xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
    <xsl:param name="exp" as="xs:decimal" />
    <xsl:param name="val" as="xs:decimal" />
    <xsl:param name="slack" as="xs:decimal" />
    <xsl:value-of select="xs:decimal($exp + $slack) >= $val and xs:decimal($exp - $slack) &lt;= $val" />
</xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:checkCF" as="xs:boolean">
    <xsl:param name="arg" as="xs:string?" />
    <xsl:sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   " />
  </xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
  <xsl:param name="val" />
  <xsl:variable name="length" select="string-length($val) - 1" />
  <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
  <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))" />
  <xsl:value-of select="number($val) > 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))" />
</xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:mod97-0208" as="xs:boolean">
    <xsl:param name="val" />
    <xsl:variable name="checkdigits" select="substring($val,9,2)" />
    <xsl:variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))" />
    <xsl:value-of select="number($checkdigits) = number($calculated_digits)" />
  </xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:checkCodiceIPA" as="xs:boolean">
    <xsl:param name="arg" as="xs:string?" />
    <xsl:variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</xsl:variable>
    <xsl:sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()" />
  </xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVAseIT" as="xs:boolean">
    <xsl:param name="arg" as="xs:string" />
    <xsl:variable name="paese" select="substring($arg,1,2)" />
    <xsl:variable name="codice" select="substring($arg,3)" />
    <xsl:sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      " />
  </xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:abn" as="xs:boolean">
    <xsl:param name="val" />
    <xsl:value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 " />
</xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:checkCF16" as="xs:boolean">
    <xsl:param name="arg" as="xs:string?" />
    <xsl:variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     " />
  </xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVA" as="xs:integer">
    <xsl:param name="arg" as="xs:string?" />
    <xsl:sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )" />
  </xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:checkSEOrgnr" as="xs:boolean">
	    <!-- Function for Swedish organisation numbers (0007) -->
	<xsl:param name="number" as="xs:string" />
	<xsl:choose>
		      <!-- Check if input is numeric -->
		<xsl:when test="not(matches($number, '^\d+$'))">
			<xsl:sequence select="false()" />
		</xsl:when>
		<xsl:otherwise>
			        <!-- verify the check number of the provided identifier according to the Luhn algorithm-->
			<xsl:variable name="mainPart" select="substring($number, 1, 9)" />
			<xsl:variable name="checkDigit" select="substring($number, 10, 1)" />
			<xsl:variable name="sum" as="xs:integer">
			  <xsl:value-of select="sum(       for $pos in 1 to string-length($mainPart) return         if ($pos mod 2 = 1)         then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +           (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10         else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      )" />
			</xsl:variable>
			<xsl:variable name="calculatedCheckDigit" select="(10 - $sum mod 10) mod 10" />
			<xsl:sequence select="$calculatedCheckDigit = number($checkDigit)" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:addPIVA" as="xs:integer">
    <xsl:param name="arg" as="xs:string" />
    <xsl:param name="pari" as="xs:integer" />
    <xsl:variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1" />
    <xsl:variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )" />
    <xsl:sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )" />
  </xsl:function>
  <ns prefix="ubl-creditnote" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <ns prefix="ubl-invoice" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
  <ns prefix="u" uri="utils" />
  <pattern>
    <rule context="/">
      <assert id="OIOUBL-INV-001" flag="fatal" test="name(/*) eq 'CreditNote'">The root element
                must be 'CreditNote'.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/">
      <assert id="OIOUBL-COMMON-020" flag="fatal" test="not(.//cac:Signature/cac:SignatoryParty/cac:PostalAddress)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Signature/cac:SignatoryParty/cac:PostalAddress'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-021" flag="fatal" test="not(.//cac:OrderReference/cac:DocumentReference)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:OrderReference/cac:DocumentReference'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-022" flag="fatal" test="not(.//cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-023" flag="fatal" test="not(.//cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:SelfBilledInvoiceDocumentReference'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-024" flag="fatal" test="not(.//cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-025" flag="fatal" test="not(.//cac:BillingReference/cac:DebitNoteDocumentReference)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:DebitNoteDocumentReference'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-026" flag="fatal" test="not(.//cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-027" flag="fatal" test="not(.//cac:Delivery/cac:DeliveryAddress)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryAddress'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-028" flag="fatal" test="not(.//cac:Delivery/cac:CarrierParty)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:CarrierParty'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-029" flag="fatal" test="not(.//cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-030" flag="fatal" test="not(.//cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-031" flag="fatal" test="not(.//cac:BillingReference/cac:AdditionalDocumentReference)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:AdditionalDocumentReference'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-032" flag="fatal" test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-033" flag="fatal" test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-034" flag="fatal" test="not(.//cac:PaymentMeans/cbc:PaymentDueDate)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:PaymentMeans/cbc:PaymentDueDate'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-035" flag="fatal" test="not(.//cac:AllowanceCharge/cac:PaymentMeans)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:AllowanceCharge/cac:PaymentMeans'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-037" flag="fatal" test="not(.//cac:AllowanceCharge/cac:Taxtotal)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:AllowanceCharge/cac:Taxtotal'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-038" flag="fatal" test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:Percent'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-039" flag="fatal" test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-040" flag="fatal" test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-041" flag="fatal" test="not(.//cac:Person)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Person'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-043" flag="fatal" test="not(.//cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject'), '(/Q\{[^}]+\})', '/')" />
</assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="OIOUBL-COMMON-052" flag="fatal" test="not(cac:Delivery/cbc:LatestDeliveryDate)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cbc:LatestDeliveryDate'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-053" flag="fatal" test="not(cac:Delivery/cbc:LatestDeliveryTime)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cbc:LatestDeliveryTime'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-054" flag="fatal" test="not(cac:Delivery/cac:DeliveryAddress)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryAddress'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-055" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-056" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-057" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-058" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-059" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-060" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-061" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-062" flag="fatal" test="not(cac:PaymentTerms)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:PaymentTerms'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-063" flag="fatal" test="not(cac:Item/cac:TransactionConditions)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Item/cac:TransactionConditions'), '(/Q\{[^}]+\})', '/')" />
</assert>
      <assert id="OIOUBL-COMMON-064" flag="fatal" test="not(cac:Price/cac:AllowanceCharge/cac:PaymentMeans)">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Price/cac:AllowanceCharge/cac:PaymentMeans'), '(/Q\{[^}]+\})', '/')" />
</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//*[not(*) and not(normalize-space())]">
      <assert id="PEPPOL-EN16931-R008" flag="fatal" test="false()">Document MUST not
                        contain empty elements.</assert>
    </rule>
    <rule context="ubl-creditnote:CreditNote/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
      <assert id="OIOUBL-BIL-099" flag="fatal" test="number(text()) >= 0 or /*/cac:AdditionalDocumentReference/cbc:DocumentTypeCode[@listAgencyName = 'ERST'] = 'PEPPOLBIS32OIOUBL'">The value of TaxInclusiveAmount must not be negative unless
                        DocumentTypeCode is 'PEPPOLBIS32OIOUBL' with listAgencyName 'ERST' - Value
                        found: '<value-of select="." />' </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
      <assert id="PEPPOL-EN16931-R080" flag="fatal" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '50']) &lt;= 1)">Only one project reference is allowed on document
                        level</assert>
      <assert id="PEPPOL-EN16931-R001" flag="fatal" test="cbc:ProfileID">Business process MUST be provided.</assert>
      <assert id="PEPPOL-EN16931-R002" flag="fatal" test="count(cbc:Note) &lt;= 1">No more than one note is allowed on document level.</assert>
      <assert id="PEPPOL-EN16931-R003" flag="fatal" test="cbc:BuyerReference or cac:OrderReference/cbc:ID">A buyer reference or purchase order reference MUST be
                        provided.</assert>
      <assert id="PEPPOL-EN16931-R053" flag="fatal" test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1">Only one tax total with tax subtotals MUST be
                        provided.</assert>
      <assert id="PEPPOL-EN16931-R054" flag="fatal" test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then                                         1                                 else                                         0)">Only one tax total without tax subtotals MUST be provided when
                        tax currency code is provided.</assert>
      <assert id="PEPPOL-EN16931-R055" flag="fatal" test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID = normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID = normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID = normalize-space(../../cbc:TaxCurrencyCode)] >= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID = normalize-space(../../cbc:DocumentCurrencyCode)] >= 0)">Invoice total VAT amount and Invoice total VAT amount in
                        accounting currency MUST have the same operational sign</assert>
    </rule>
    <rule context="cbc:TaxCurrencyCode">
      <assert id="PEPPOL-EN16931-R005" flag="fatal" test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))">VAT accounting currency code MUST be different from invoice
                        currency code when provided</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party">
      <assert id="PEPPOL-EN16931-R010" flag="fatal" test="cbc:EndpointID">Buyer electronic address MUST be provided</assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party">
      <assert id="PEPPOL-EN16931-R020" flag="fatal" test="cbc:EndpointID">Seller electronic address MUST be provided</assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
      <assert id="PEPPOL-EN16931-R041" flag="fatal" test="false()">Allowance/charge base amount MUST be provided when
                        allowance/charge percentage is provided.</assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
      <assert id="PEPPOL-EN16931-R042" flag="fatal" test="false()">Allowance/charge percentage MUST be provided when
                        allowance/charge base amount is provided.</assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge">
      <assert id="PEPPOL-EN16931-R040" flag="fatal" test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then                                         cbc:Amount                                 else                                         0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">Allowance/charge amount must equal base amount * percentage/100
                        if base amount and percentage exists</assert>
      <assert id="PEPPOL-EN16931-R043" flag="fatal" test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'">Allowance/charge ChargeIndicator value MUST equal 'true' or
                        'false'</assert>
    </rule>
    <rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
      <let name="documentCurrencyCode" value="/*/cbc:DocumentCurrencyCode" />
      <assert id="PEPPOL-EN16931-CL007" flag="fatal" test="some $code in $ISO4217                                         satisfies @currencyID = $code">Currency code must be according to ISO 4217:2005</assert>
      <assert id="PEPPOL-EN16931-R051" flag="fatal" test="@currencyID = $documentCurrencyCode">All currencyID attributes must have the same value as the
                        invoice currency code (BT-5), except for the invoice total VAT amount in
                        accounting currency (BT-111).</assert>
    </rule>
    <rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
      <assert id="PEPPOL-EN16931-R110" flag="fatal" test="xs:date(text()) >= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)">Start date of line period MUST be within invoice
                        period.</assert>
    </rule>
    <rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
      <assert id="PEPPOL-EN16931-R111" flag="fatal" test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)">End date of line period MUST be within invoice period.</assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <let name="lineExtensionAmount" value="if (cbc:LineExtensionAmount) then                                         xs:decimal(cbc:LineExtensionAmount)                                 else                                         0" />
      <let name="quantity" value="if (/ubl-invoice:Invoice) then                                         (if (cbc:InvoicedQuantity) then                                                 xs:decimal(cbc:InvoicedQuantity)                                         else                                                 1)                                 else                                         (if (cbc:CreditedQuantity) then                                                 xs:decimal(cbc:CreditedQuantity)                                         else                                                 1)" />
      <let name="priceAmount" value="if (cac:Price/cbc:PriceAmount) then                                         xs:decimal(cac:Price/cbc:PriceAmount)                                 else                                         0" />
      <let name="baseQuantity" value="if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then                                         xs:decimal(cac:Price/cbc:BaseQuantity)                                 else                                         1" />
      <let name="allowancesTotal" value="if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then                                         round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100                                 else                                         0" />
      <let name="chargesTotal" value="if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then                                         round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100                                 else                                         0" />
      <assert id="PEPPOL-EN16931-R120" flag="fatal" test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)">Invoice line net amount MUST equal (Invoiced quantity * (Item
                        net price/item price base quantity) + Sum of invoice line charge amount -
                        sum of invoice line allowance amount</assert>
      <assert id="PEPPOL-EN16931-R121" flag="fatal" test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) > 0">Base quantity MUST be a positive number above zero.</assert>
      <assert id="PEPPOL-EN16931-R100" flag="fatal" test="(count(cac:DocumentReference) &lt;= 1)">Only one invoiced object is allowed pr line</assert>
      <assert id="PEPPOL-EN16931-R101" flag="fatal" test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode = '130'))">Element Document reference can only be used for Invoice line
                        object</assert>
    </rule>
    <rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
      <let name="hasQuantity" value="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity" />
      <let name="quantity" value="if (/ubl-invoice:Invoice) then                                         ../../cbc:InvoicedQuantity                                 else                                         ../../cbc:CreditedQuantity" />
      <assert id="PEPPOL-EN16931-R130" flag="fatal" test="not($hasQuantity) or @unitCode = $quantity/@unitCode">Unit code of price base quantity MUST be same as invoiced
                        quantity.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
      <assert id="PEPPOL-COMMON-R040" flag="fatal" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())">GLN must have a valid format according to GS1 rules.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
      <assert id="PEPPOL-COMMON-R041" flag="fatal" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())">Norwegian organization number MUST be stated in the correct
                        format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
      <assert id="PEPPOL-COMMON-R043" flag="fatal" test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())">Belgian enterprise number MUST be stated in the correct
                        format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
      <assert id="PEPPOL-COMMON-R044" flag="warning" test="u:checkCodiceIPA(normalize-space())">IPA Code (Codice Univoco Unità Organizzativa) must be stated
                        in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
      <assert id="PEPPOL-COMMON-R045" flag="warning" test="u:checkCF(normalize-space())">Tax Code (Codice Fiscale) must be stated in the correct
                        format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '9907']">
      <assert id="PEPPOL-COMMON-R046" flag="warning" test="u:checkCF(normalize-space())">Tax Code (Codice Fiscale) must be stated in the correct
                        format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
      <assert id="PEPPOL-COMMON-R047" flag="warning" test="u:checkPIVAseIT(normalize-space())">Italian VAT Code (Partita Iva) must be stated in the correct
                        format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
      <assert id="PEPPOL-COMMON-R049" flag="fatal" test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())">Swedish organization number MUST be stated in the correct
                        format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
      <assert id="PEPPOL-COMMON-R050" flag="fatal" test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())">Australian Business Number (ABN) MUST be stated in the correct
                        format.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
      <assert id="PEPPOL-EN16931-CL001" flag="fatal" test="some $code in $MIMECODE                                         satisfies @mimeCode = $code">Mime code must be according to subset of IANA code
                        list.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode">
      <assert id="PEPPOL-EN16931-CL002" flag="fatal" test="some $code in $UNCL5189                                         satisfies normalize-space(text()) = $code">Reason code MUST be according to subset of UNCL 5189
                        D.16B.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode">
      <assert id="PEPPOL-EN16931-CL003" flag="fatal" test="some $code in $UNCL7161                                         satisfies normalize-space(text()) = $code">Reason code MUST be according to UNCL 7161 D.16B.</assert>
    </rule>
    <rule context="cac:InvoicePeriod/cbc:DescriptionCode">
      <assert id="PEPPOL-EN16931-CL006" flag="fatal" test="some $code in $UNCL2005                                         satisfies normalize-space(text()) = $code">Invoice period description code must be according to UNCL 2005
                        D.16B.</assert>
    </rule>
    <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
      <assert id="PEPPOL-EN16931-F001" flag="fatal" test="string-length(text()) = 10 and (string(.) castable as xs:date)">A date MUST be formatted YYYY-MM-DD.</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-G']">
      <assert id="PEPPOL-EN16931-P0104" flag="fatal" test="normalize-space(cbc:ID) = 'G'">Tax Category G MUST be used when exemption reason code is
                        VATEX-EU-G</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-O']">
      <assert id="PEPPOL-EN16931-P0105" flag="fatal" test="normalize-space(cbc:ID) = 'O'">Tax Category O MUST be used when exemption reason code is
                        VATEX-EU-O</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-IC']">
      <assert id="PEPPOL-EN16931-P0106" flag="fatal" test="normalize-space(cbc:ID) = 'K'">Tax Category K MUST be used when exemption reason code is
                        VATEX-EU-IC</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-AE']">
      <assert id="PEPPOL-EN16931-P0107" flag="fatal" test="normalize-space(cbc:ID) = 'AE'">Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-AE</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-D']">
      <assert id="PEPPOL-EN16931-P0108" flag="fatal" test="normalize-space(cbc:ID) = 'E'">Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-D</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-F']">
      <assert id="PEPPOL-EN16931-P0109" flag="fatal" test="normalize-space(cbc:ID) = 'E'">Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-F</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-I']">
      <assert id="PEPPOL-EN16931-P0110" flag="fatal" test="normalize-space(cbc:ID) = 'E'">Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-I</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-J']">
      <assert id="PEPPOL-EN16931-P0111" flag="fatal" test="normalize-space(cbc:ID) = 'E'">Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-J</assert>
    </rule>
    <rule context="cac:PaymentMeans[some $code in tokenize('49 59', '\s')                                 satisfies normalize-space(cbc:PaymentMeansCode) = $code]">
      <assert id="PEPPOL-EN16931-R061" flag="fatal" test="cac:PaymentMandate/cbc:ID">Mandate reference MUST be provided for direct debit.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID]">
      <assert id="PEPPOL-EN16931-CL008" flag="fatal" test="some $code in $eaid                                         satisfies @schemeID = $code">Electronic address identifier scheme must be from the codelist
                        "Electronic Address Identifier Scheme"</assert>
    </rule>
    <let name="ISO3166" value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW', '\s')" />
    <let name="MIMECODE" value="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
    <let name="UNCL2005" value="tokenize('3 35 432', '\s')" />
    <let name="UNCL5189" value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')" />
    <let name="UNCL7161" value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CD CG CS CT DAB DAD DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')" />
    <let name="UNCL5305" value="tokenize('AE E S Z G O K L M', '\s')" />
    <let name="eaid" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')" />
    <let name="ISO4217" value="tokenize('AFN EUR ALL DZD USD AOA XCD XCD ARS AMD AWG AUD AZN BSD BHD BDT BBD BYN BZD XOF BMD INR BTN BOB BOV USD BAM BWP NOK BRL USD BND BGN XOF BIF CVE KHR XAF CAD KYD XAF XAF CLP CLF CNY AUD AUD COP COU KMF CDF XAF NZD CRC XOF HRK CUP CUC ANG CZK DKK DJF XCD DOP USD EGP SVC USD XAF ERN ETB FKP DKK FJD XPF XAF GMD GEL GHS GIP DKK XCD USD GTQ GBP GNF XOF GYD HTG USD AUD HNL HKD HUF ISK INR IDR XDR IRR IQD GBP ILS JMD JPY GBP JOD KZT KES AUD KPW KRW KWD KGS LAK LBP LSL ZAR LRD LYD CHF MOP MKD MGA MWK MYR MVR XOF USD MRO MUR XUA MXN MXV USD MDL MNT XCD MAD MZN MMK NAD ZAR AUD NPR XPF NZD NIO XOF NGN NZD AUD USD NOK OMR PKR USD PAB USD PGK PYG PEN PHP NZD PLN USD QAR RON RUB RWF SHP XCD XCD XCD WST STD SAR XOF RSD SCR SLL SGD ANG XSU SBD SOS ZAR SSP LKR SDG SRD NOK SZL SEK CHF CHE CHW SYP TWD TJS TZS THB USD XOF NZD TOP TTD TND TRY TMT USD AUD UGX UAH AED GBP USD USD USN UYU UYI UZS VUV VEF VND USD USD XPF MAD YER ZMW ZWL XBA XBB XBC XBD XTS XXX XAU XPD XPT XAG', '\s')" />
  </pattern>
  <pattern>
    <let name="profile" value="if (/*/cbc:ProfileID and                         (matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:oioubl.dk:bis:billing_with_response:3') or                         matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:oioubl.dk:bis:billing_private_without_response:3')))                                                  then                                 tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]                                                  else                                 'Unknown'" />
    <rule context="ubl-creditnote:CreditNote">
      <assert id="OIOUBL-BIL-016" flag="fatal" test="number(normalize-space(cac:LegalMonetaryTotal/cbc:PayableAmount)) > 0">PayableAmount must be greater than 0 - Value found: '<value-of select="cac:LegalMonetaryTotal/cbc:PayableAmount" />'</assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cac:PaymentMeans">
      <assert id="OIOUBL-BIL-005" flag="fatal" test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))">For Danish suppliers the following Payment means codes are
                        allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97</assert>
      <assert id="OIOUBL-BIL-006" flag="fatal" test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))                                 and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))                                 )">Bank account and registration account is
                        mandatory if payment means is 31 or 42</assert>
      <assert id="OIOUBL-BIL-007" flag="fatal" test="not(cbc:PaymentMeansCode='49' and cbc:PaymentChannelCode='IBAN')                          or (cac:PaymentMandate/cbc:ID and cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)">PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when PaymentMeansCode is '49' and PaymentChannelCode is 'IBAN'
                </assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cbc:CustomizationID">
      <assert id="OIOUBL-BIL-020" flag="fatal" test=". = 'urn:fdc:oioubl.dk:trns:billing:invoice:3.0'">For Invoice the CustomizationID must be
                        'urn:fdc:oioubl.dk:trns:billing:invoice:3.0' - Value found: '<value-of select="." />'</assert>
    </rule>
    <rule context="ubl-creditnote:CreditNote/cbc:CustomizationID">
      <assert id="OIOUBL-BIL-022" flag="fatal" test=". = 'urn:fdc:oioubl.dk:trns:billing:creditnote:3.0'">For CreditNote the CustomizationID must be
                        'urn:fdc:oioubl.dk:trns:billing:creditnote:3.0' - Value found: '<value-of select="." />'</assert>
    </rule>
    <rule context="cbc:UBLVersionID">
      <assert id="OIOUBL-BIL-019" flag="fatal" test=". = 2.1">The value of UBLVersionID must be equal to 2.1 - Value
                        found: '<value-of select="." />'</assert>
    </rule>
    <rule context="cbc:ProfileID">
      <assert id="OIOUBL-BIL-023" flag="fatal" test=". = 'urn:fdc:oioubl.dk:bis:billing_with_response:3' or . = 'urn:fdc:oioubl.dk:bis:billing_private_without_response:3'">The ProfileID must be qual either
                        'urn:fdc:oioubl.dk:bis:billing_with_response:3' or
                        'urn:fdc:oioubl.dk:bis:billing_private_without_response:3' - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cbc:InvoiceTypeCode">
      <assert id="OIOUBL-BIL-017" flag="fatal" test="$profile != '01' or (some $code in tokenize('71 82 102 218 219 326 331 380 382 383 384 386 388 390 393 395 553 575 623 780 817 870 875 876 877', '\s')                                         satisfies normalize-space(text()) = $code)">Invoice type code MUST be set according to the
                        profile.</assert>
    </rule>
    <rule context="cbc:CreditNoteTypeCode">
      <assert id="OIOUBL-BIL-018" flag="fatal" test="$profile != '01' or (some $code in tokenize('81 83 308 381 396 532', '\s')                                         satisfies normalize-space(text()) = $code)">Credit note type code MUST be set according to the
                        profile.</assert>
    </rule>
    <rule context="cac:LegalMonetaryTotal/cbc:LineExtensionAmount |                         cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount |                         cac:LegalMonetaryTotal/cbc:PayableAmount">
      <assert id="OIOUBL-BIL-098" flag="fatal" test="not(starts-with(text(), '-'))">The value of '<value-of select="name()" />'must not be negative - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity">
      <assert id="OIOUBL-BIL-100" flag="fatal" test="not(cbc:CompanyID[@schemeID = '0237'])">The element 'CompanyID' must not use schemeID='0237' under
                        'AccountingCustomerParty'</assert>
    </rule>
    <rule context="cbc:CreditedQuantity[@unitCode] | cbc:InvoicedQuantity[@unitCode] | cac:Price/cbc:BaseQuantity[@unitCode] | cac:Item/cbc:PackQuantity[@unitCode]">
      <assert id="OIOUBL-BIL-106" flag="fatal" test="some $code in $UNECERec20-11e                                         satisfies @unitCode = $code">
                        The value in '@unitCode' is not valid. It must be one from the codellist UNECERec20 - Value found: '<value-of select="@unitCode" />' 
                </assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="OIOUBL-BIL-101" flag="fatal" test="count(cac:Delivery/cbc:ActualDeliveryDate) = 0 or count(../cac:Delivery/cbc:ActualDeliveryDate) = 0">Only use Delivery/ActualDeliveryDate if not specified on header level (Invoice/Delivery or CreditNote/Delivery)</assert>
      <assert id="OIOUBL-BIL-102" flag="fatal" test="count(cac:Delivery/cac:DeliveryLocation) = 0 or count(../cac:Delivery/cac:DeliveryLocation) = 0">Only use Delivery/DeliveryLocation if not specified on header level (Invoice/Delivery or CreditNote/Delivery)</assert>
      <assert id="OIOUBL-BIL-103" flag="fatal" test="count(cac:Delivery/cac:DeliveryParty) = 0 or count(../cac:Delivery/cac:DeliveryParty) = 0">Only use Delivery/DeliveryParty if not specified on header level (Invoice/Delivery or CreditNote/Delivery)</assert>
      <assert id="OIOUBL-BIL-107" flag="fatal" test="not(position() &lt; 5000 and cbc:ID = preceding-sibling::cac:InvoiceLine[position() &lt; 5000]/cbc:ID)">
                        The ID of each InvoiceLine must be unique, but the validation is only applied to the firste 5000 lines.

                </assert>
      <assert id="OIOUBL-BIL-108" flag="fatal" test="not(position() &lt; 5000 and cbc:ID = preceding-sibling::cac:CreditNoteLine[position() &lt; 5000]/cbc:ID)">
                        The ID of each CreditNoteLine must be unique, but the validation is only applied to the firste 5000 lines.

                </assert>
      <assert id="OIOUBL-BIL-110" flag="fatal" test="not(position() &lt; 5000 and cbc:ID = preceding-sibling::cac:CreditNoteLine[position() &lt; 5000]/cbc:ID)">
                        The ID of each CreditNoteLine must be unique, but the validation is only applied to the firste 5000 lines.

                </assert>
      <assert id="OIOUBL-BIL-105" flag="fatal" test="not(matches(cbc:InvoicedQuantity, '^0+(\.0+)?$'))">InvoicedQuantity/CreditedQuantity must not be 0 - Value found: <value-of select="cbc:PaymentMeansCode" />
</assert>
      <assert id="OIOUBL-BIL-130" flag="fatal" test="not(cac:OrderLineReference) or /*/cac:OrderReference">Invoice/OrderReference is mandatory when OrderLineReference class is present
                </assert>
      <assert id="OIOUBL-BIL-131" flag="fatal" test="cac:TaxTotal">One or more TaxTotal classes must be present on line level
                </assert>
    </rule>
    <rule context="cac:TaxExchangeRate">
      <assert id="OIOUBL-BIL-111" flag="fatal" test="cbc:CalculationRate > 0 and matches(cbc:CalculationRate, '^\d+\.\d{4}$')">CalculationRate must be greater than zero and have exactly 4 decimal places</assert>
      <assert id="OIOUBL-BIL-112" flag="fatal" test="cbc:MathematicOperatorCode = 'multiply' or cbc:MathematicOperatorCode = 'divide'">MathematicOperatorCode must be either 'multiply' or 'divide'</assert>
    </rule>
    <rule context="cac:TaxTotal/cac:TaxSubtotal">
      <assert id="OIOUBL-BIL-115" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']/cbc:ID)">
                        Each VAT breakdown shall be defined through a VAT category code
                </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '1']">
      <assert id="OIOUBL-BIL-124" flag="fatal" test="not(cbc:PaymentChannelCode)">PaymentChannelCode is not allow when the
                        PaymentMeans = 1</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '10']">
      <assert id="OIOUBL-BIL-125" flag="fatal" test="not(cbc:PaymentChannelCode)">PaymentChannelCode is not allow when the
                        PaymentMeans = 10</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '31']">
      <assert id="OIOUBL-BIL-028" flag="fatal" test="not(cbc:InstructionNote)">InstructionNote is not allow when the PaymentMeansCode = '31'</assert>
      <assert id="OIOUBL-BIL-029" flag="fatal" test="cac:PayeeFinancialAccount/cbc:ID">PayeeFinancialAccount/ID is mandatory when the PaymentMeansCode = '31'</assert>
      <assert id="OIOUBL-BIL-030" flag="fatal" test="string-length(cac:PayerFinancialAccount/cbc:PaymentNote) &lt;= 20">PaymentNote must not be more than 20 characters when the
                        PaymentMeansCode = '31' - Value found: '<value-of select="cac:PayerFinancialAccount/cbc:PaymentNote" />' </assert>
      <assert id="OIOUBL-BIL-091" flag="fatal" test="string-length(cac:PayeeFinancialAccount/cbc:PaymentNote) &lt;= 20">PaymentNote must not be more than 20 characters when the
                        PaymentMeansCode = '31' - Value found: '<value-of select="cac:PayeeFinancialAccount/cbc:PaymentNote" />' </assert>
      <assert id="OIOUBL-BIL-031" flag="fatal" test="string-length(cac:CreditAccount/cbc:AccountID) &lt;= 8">If PaymentMeansCode = 31 CreditAccount/AccountID must not be
                        more than 8 characters - Value found: '<value-of select="cbc:AccountID" />' </assert>
      <assert id="OIOUBL-BIL-024" flag="fatal" test="cbc:PaymentChannelCode != 'IBAN' or (string-length(cac:PayeeFinancialAccount/cbc:ID) &lt;= 34)">If PaymentMeansCode = 31 and PaymentChannelCode is 'IBAN', then PayeeFinancialAccount/ID must not
                        be more than 34 digits - Value found: '<value-of select="cac:PayeeFinancialAccount/cbc:ID" />' </assert>
      <assert id="OIOUBL-BIL-025" flag="fatal" test="not(cbc:PaymentChannelCode = 'ZZZ') or cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID">PaymentMeansCode = 31 then FinancialInstitutionBranch/ID is mandatory when PaymentChannelCode equals 'ZZZ'
                </assert>
      <assert id="OIOUBL-BIL-026" flag="fatal" test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name">If PaymentMeansCode = 31 then FinancialInstitutionBranch/Name
                        element is mandatory </assert>
      <assert id="OIOUBL-BIL-027" flag="fatal" test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address">If PaymentMeansCode = 31 then
                        FinancialInstitutionBranch/Address class is mandatory </assert>
      <assert id="OIOUBL-BIL-095" flag="fatal" test="cbc:PaymentChannelCode != 'IBAN' or (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) != '')">When PaymentMeansCode = 31 and PaymentChannelCode is 'IBAN', the ID element in PayeeFinancialAccount/FinancialInstitutionBranch/FinancialInstitution/ must be used</assert>
      <assert id="OIOUBL-BIL-120" flag="fatal" test="cbc:PaymentChannelCode">When PaymentMeansCode is = 31, then PaymentChannelCode is mandatory</assert>
      <assert id="OIOUBL-BIL-121" flag="fatal" test="cbc:PaymentChannelCode = 'IBAN' or cbc:PaymentChannelCode = 'ZZZ'">When PaymentMeansCode = 31, then PaymentChannelCode should be either 'IBAN' or 'ZZZ' - Value found: '<value-of select="cbc:PaymentChannelCode" />'</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '42']">
      <assert id="OIOUBL-BIL-113" flag="fatal" test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:BANK'">If PaymentChannelCode is present, its value must be 'DK:BANK' when PaymentMeansCode is '42' - Value found = '<value-of select="cbc:PaymentChannelCode" />'</assert>
      <assert id="OIOUBL-BIL-033" flag="fatal" test="not(cac:CreditAccount)">CreditAccount is not allow when the PaymentMeans = '42'</assert>
      <assert id="OIOUBL-BIL-034" flag="fatal" test="not(cbc:InstructionNote)">InstructionNote is not allow when the PaymentMeans = '42'</assert>
      <assert id="OIOUBL-BIL-035" flag="fatal" test="string-length(cac:PayerFinancialAccount/cbc:PaymentNote) &lt;= 20">PaymentNote must not be more than 20 characters when
                        PaymentMeansCode = '42' - Value found: '<value-of select="cac:PayerFinancialAccount/cbc:PaymentNote" />' </assert>
      <assert id="OIOUBL-BIL-092" flag="fatal" test="string-length(cac:PayeeFinancialAccount/cbc:PaymentNote) &lt;= 20">PaymentNote must not be more than 20 characters when
                        PaymentMeansCode = '42' - Value found: '<value-of select="cac:PayeeFinancialAccount/cbc:PaymentNote" />' </assert>
      <assert id="OIOUBL-BIL-037" flag="fatal" test="cac:PayeeFinancialAccount">PayeeFinancialAccount is mandatory when the PaymentMeans = '42'</assert>
      <assert id="OIOUBL-BIL-038" flag="fatal" test="cac:PayeeFinancialAccount/cbc:ID">PayeeFinancialAccount/ID is mandatory when the PaymentMeans = '42'</assert>
      <assert id="OIOUBL-BIL-039" flag="fatal" test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID and matches(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID, '^\d{4}$')">PayeeFinancialAccount/FinancialInstitutionBranch/ID must exist
                        and be 4 digits long when PaymentMeansCode = '42' - Value found: '<value-of select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID" />' </assert>
      <assert id="OIOUBL-BIL-040" flag="fatal" test="string-length(cac:PayeeFinancialAccount/cbc:ID) &lt;= 10">PayeeFinancialAccount/ID must not be more than 10 characters when PaymentMeansCode = '42' -
                        Value found: '<value-of select="cac:PayeeFinancialAccount/cbc:ID" />' </assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '48']">
      <assert id="OIOUBL-BIL-032" flag="fatal" test="not(cbc:PaymentChannelCode)">PaymentChannelCode is not allow when the
                        PaymentMeans = 48</assert>
      <assert id="OIOUBL-BIL-041" flag="fatal" test="not(cbc:InstructionID)">InstructionID is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-042" flag="fatal" test="not(cbc:InstructionNote)">InstructionNote is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-043" flag="fatal" test="not(cac:PayerFinancialAccount)">PayerFinancialAccount is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-044" flag="fatal" test="not(cac:PayeeFinancialAccount)">PayeeFinancialAccount is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-045" flag="fatal" test="not(cac:CreditAccount)">CreditAccount is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-046" flag="fatal" test="cac:CardAccount">CardAccount must be used when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-047" flag="fatal" test="not(cac:CardAccount/cbc:CardTypeCode)">CardAccount/CardTypeCode is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-048" flag="fatal" test="not(cac:CardAccount/cbc:ValidityStartDate)">CardAccount/ValidityStartDate is not allow when the
                        PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-049" flag="fatal" test="not(cac:CardAccount/cbc:ExpiryDate)">CardAccount/ExpiryDate is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-050" flag="fatal" test="not(cac:CardAccount/cbc:IssuerID)">CardAccount/IssuerID is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-051" flag="fatal" test="not(cac:CardAccount/cbc:IssueNumberID)">CardAccount/IssueNumberID is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-052" flag="fatal" test="not(cac:CardAccount/cbc:CV2ID)">CardAccount/CV2ID is not allow when the PaymentMeans = '48'&gt;</assert>
      <assert id="OIOUBL-BIL-053" flag="fatal" test="not(cac:CardAccount/cbc:CardChipCode)">CardAccount/CardChipCode is not allow when the PaymentMeans = '48'</assert>
      <assert id="OIOUBL-BIL-054" flag="fatal" test="not(cac:CardAccount/cbc:ChipApplicationID)">CardAccount/ChipApplicationID is not allow when the
                        PaymentMeans = '48'</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '49']">
      <assert id="OIOUBL-BIL-122" flag="fatal" test="cbc:PaymentChannelCode">When PaymentMeansCode = 49 then PaymentChannelCode is mandatory</assert>
      <assert id="OIOUBL-BIL-123" flag="fatal" test="cbc:PaymentChannelCode = 'DK:BANK' or cbc:PaymentChannelCode = 'IBAN'">When PaymentMeansCode = 49 then PaymentChannelCode should be either 'DK:BANK' or 'IBAN' - Value found: '<value-of select="cbc:PaymentChannelCode" />'</assert>
      <assert id="OIOUBL-BIL-055" flag="fatal" test="not(cbc:InstructionNote)">InstructionNote is not allow when the PaymentMeans = '49'/&gt;</assert>
      <assert id="OIOUBL-BIL-056" flag="fatal" test="not(cac:CreditAccount)">CreditAccount is not allowed when the PaymentMeans = '49'/&gt;</assert>
      <assert id="OIOUBL-BIL-057" flag="fatal" test="cbc:InstructionID">InstructionID is mandatory when PaymentMeans = '49'"/&gt;
                </assert>
      <assert id="OIOUBL-BIL-058" flag="fatal" test="string-length(cac:PayerFinancialAccount/cbc:PaymentNote) &lt;= 20">PaymentNote must not be more than 20 characters when
                        PaymentMeansCode = '49' - Value found: '<value-of select="cac:PayerFinancialAccount/cbc:PaymentNote" />' </assert>
      <assert id="OIOUBL-BIL-059" flag="fatal" test="string-length(cbc:InstructionID) &lt;= 60">InstructionID must not be more than 60 characters when
                        PaymentMeansCode = '49' - Value found: '<value-of select="cbc:InstructionID" />' </assert>
      <assert id="OIOUBL-BIL-060" flag="fatal" test="not(cbc:PaymentChannelCode='DK:BANK')                         or (cac:PaymentMandate/cbc:ID and cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)">PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when PaymentMeansCode is '49' and PaymentChannelCode is 'DK:BANK' - Value found:  '<value-of select="cac:PayerFinancialAccount/cbc:ID" />' </assert>
      <assert id="OIOUBL-BIL-061" flag="fatal" test="not(cbc:PaymentChannelCode = 'DK:BANK') or string-length(cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 4">If cbc:PaymentChannelCode is 'DK:BANK', then PaymentMandate/PayeeFinancialAccount/FinancialInstitutionBranch/ID must be 4 characters when
                        PaymentMeansCode = '49' - Value found:'<value-of select="cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID" />' </assert>
      <assert id="OIOUBL-BIL-062" flag="fatal" test="not(cbc:PaymentChannelCode = 'IBAN') or (string-length(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID) >= 18 and string-length(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID) &lt;= 34)">If PaymentChannelCode = 'IBAN' then PaymentMandate/ayerFinancialAccount/ID must be between 18 and 34 characters
                        when PaymentMeansCode = '49' - Value found: '<value-of select="cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID" />' </assert>
      <assert id="OIOUBL-BIL-063" flag="fatal" test="not(cbc:PaymentChannelCode = 'IBAN') or (not(cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID))">If PaymentChannelCode = 'IBAN' then PaymentMandate/PayerFinancialAccount/FinancialInstitutionBranch/ID is not
                        allowed when PaymentMeansCode = '49'"/&gt;</assert>
      <assert id="OIOUBL-BIL-064" flag="fatal" test="not(cbc:PaymentChannelCode = 'IBAN') or (cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)">If PaymentChannelCode = 'IBAN' then PaymentMandate/PayerFinancialAccount/FinancialInstitutionBranch/FinancialInstitution/ID
                        must be present when PaymentMeansCode = '49'"/&gt;</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '50']">
      <assert id="OIOUBL-BIL-114" flag="fatal" test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:GIRO'">If PaymentChannelCode is present, its value must be 'DK:GIRO' when PaymentMeansCode is '50' - Value found = '<value-of select="cbc:PaymentChannelCode" />'</assert>
      <assert id="OIOUBL-BIL-065" flag="fatal" test="not(cac:CreditAccount)">CreditAccount is not allowed when the PaymentMeans = '50'</assert>
      <assert id="OIOUBL-BIL-066" flag="fatal" test="cbc:PaymentID">PaymentID must be present when PaymentMeansCode ='50'</assert>
      <assert id="OIOUBL-BIL-067" flag="fatal" test="cac:PayeeFinancialAccount/cbc:ID">PayeeFinancialAccount/ID must be present when PaymentMeansCode
                        = '50'</assert>
      <assert id="OIOUBL-BIL-068" flag="fatal" test="not(cbc:PaymentID = ('04', '15')) or cbc:InstructionID">InstructionID is mandatory when PaymentID equals 04 or 15 and
                        PaymentMeansCode = '50'</assert>
      <assert id="OIOUBL-BIL-069" flag="fatal" test="not(cbc:PaymentMeansCode) or cbc:PaymentID = ('01', '04', '15')">PaymentID must equal 01, 04 or 15 when PaymentMeansCode = '50'</assert>
      <assert id="OIOUBL-BIL-070" flag="fatal" test="not(cbc:InstructionNote) or (cbc:PaymentID = '01')">InstructionNote is only allowed if PaymentID equals 01 when
                        PaymentMeansCode = '50'</assert>
      <assert id="OIOUBL-BIL-072" flag="fatal" test="string-length(cbc:InstructionID) &lt;= 16">InstructionID must be 18 or less characters when
                        PaymentMeansCode = '50'- Value found: '<value-of select="cbc:InstructionID" />' </assert>
      <assert id="OIOUBL-BIL-073" flag="fatal" test="not(cbc:PaymentID = ('04', '15')) and cbc:PaymentMeansCode = '50' or matches(cbc:InstructionID, '^\d+$')">InstructionID must be numeric when PaymentID = '04' or '15' and
                        PaymentMeansCode = '50' - Value found: '<value-of select="cbc:InstructionID" />' </assert>
      <assert id="OIOUBL-BIL-074" flag="fatal" test="not(cbc:PaymentMeansCode = '50')                                 or matches(cac:PayeeFinancialAccount/cbc:ID, '^[0-9]{7,8}$')">PayeeFinancialAccount/ID must consist of 7 or 8 numerical
                        characters when PaymentMeansCode = '50' - Value found: '<value-of select="cac:PayeeFinancialAccount/cbc:ID" />' </assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '58']">
      <assert id="OIOUBL-BIL-094" flag="fatal" test="not(cbc:PaymentChannelCode)">PaymentChannelCode is not allow when the
                        PaymentMeans = 58'</assert>
      <assert id="OIOUBL-BIL-075" flag="fatal" test="cac:PayeeFinancialAccount/cbc:ID">PayeeFinancialAccount/ID must be present when PaymentMeansCode
                        = '58'</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '59']">
      <assert id="OIOUBL-BIL-126" flag="fatal" test="not(cbc:PaymentChannelCode)">PaymentChannelCode is not allow when the
                        PaymentMeans = 59</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '93']">
      <assert id="OIOUBL-BIL-1150" flag="fatal" test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:FIK'">If PaymentChannelCode is present, its value must be 'DK:FIK' when PaymentMeansCode is '93' - Value found = '<value-of select="cbc:PaymentChannelCode" />'</assert>
      <assert id="OIOUBL-BIL-076" flag="fatal" test="cbc:PaymentID">PaymentID must be present when PaymentMeansCode = '93'</assert>
      <assert id="OIOUBL-BIL-077" flag="fatal" test="not(cbc:PaymentID = '71' or cbc:PaymentID = '75') or cbc:InstructionID">InstructionID is mandatory when PaymentID equals 71 or 75 and
                        PaymentMeansCode = '93'</assert>
      <assert id="OIOUBL-BIL-078" flag="fatal" test="not(cbc:InstructionNote) or (cbc:PaymentID = '73' or cbc:PaymentID = '75')">InstructionNote is only allowed when PaymentID equals 73 or 75
                        and PaymentMeansCode = '93'</assert>
      <assert id="OIOUBL-BIL-079" flag="fatal" test="cbc:PaymentID = ('71', '73', '75')">PaymentID must equal 71, 73 or 75 when PaymentMeansCode = '93' - Value found: '<value-of select="cbc:PaymentID" />' </assert>
      <assert id="OIOUBL-BIL-080" flag="fatal" test="not(cbc:PaymentID = '71') or string-length(cbc:InstructionID) = 15">InstructionID must equal 15 characters when PaymentID equals 71
                        and PaymentMeansCode = '93' - Value found: '<value-of select="cbc:InstructionID" />' </assert>
      <assert id="OIOUBL-BIL-081" flag="fatal" test="not(cbc:PaymentID = '75') or string-length(cbc:InstructionID) = 16">InstructionID must equal 16 characters when PaymentID equals 75
                        and PaymentMeansCode = '93' - Value found: '<value-of select="cbc:InstructionID" />' </assert>
      <assert id="OIOUBL-BIL-082" flag="fatal" test="not(cbc:PaymentID = ('71', '75')) or matches(cbc:InstructionID, '^[0-9]+$')">InstructionID must be a numeric value when PaymentID equals 71
                        or 75 and PaymentMeansCode = '93' - Value found: '<value-of select="cbc:InstructionID" />' </assert>
      <assert id="OIOUBL-BIL-083" flag="fatal" test="not(cbc:InstructionID) or (cbc:PaymentID = '71' or cbc:PaymentID = '75')">InstructionID only allowed if PaymentID equals 71 or 75 when
                        PaymentMeansCode = '93'"/&gt;</assert>
      <assert id="OIOUBL-BIL-084" flag="fatal" test="string-length(cac:CreditAccount/cbc:AccountID) = 8">CreditAccount/AccountID must be 8 characters when
                        PaymentMeansCode = '93' - Value found: '<value-of select="cac:CreditAccount/cbc:AccountID" />' </assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '97']">
      <assert id="OIOUBL-BIL-116" flag="fatal" test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:NEMKONTO'">If PaymentChannelCode is present, its value must be 'DK:NEMKONTO' when PaymentMeansCode is '97' - Value found = '<value-of select="cbc:PaymentChannelCode" />'</assert>
      <assert id="OIOUBL-BIL-085" flag="fatal" test="not(cbc:InstructionID)">InstructionID is not allowed when PaymentMeansCode = '97'</assert>
      <assert id="OIOUBL-BIL-086" flag="fatal" test="not(cbc:InstructionNote)">InstructionNote is not allowed when PaymentMeansCode = '97'&gt;</assert>
      <assert id="OIOUBL-BIL-087" flag="fatal" test="not(cbc:PaymentID)">PaymentID is not allowed when PaymentMeansCode = '97'</assert>
      <assert id="OIOUBL-BIL-088" flag="fatal" test="not(cac:PayerFinancialAccount)">PayerFinancialAccount is not allowed when PaymentMeansCode = '97'&gt;</assert>
      <assert id="OIOUBL-BIL-089" flag="fatal" test="not(cac:PayeeFinancialAccount)">PayeeFinancialAccount is not allowed when PaymentMeansCode = '97'</assert>
      <assert id="OIOUBL-BIL-090" flag="fatal" test="not(cac:CreditAccount)">CreditAccount is not allowed when PaymentMeansCode = '97'</assert>
    </rule>
    <rule context="cac:PaymentTerms">
      <assert id="OIOUBL-BIL-096" flag="fatal" test="not(cbc:ID = 'Factoring') or cbc:Note">When ID equals 'Factoring', Note element is mandatory
                        (factoring note)</assert>
      <assert id="OIOUBL-BIL-097" flag="fatal" test="count(cbc:Note) &lt;= 1">No more than one Note element may be present</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0184'] | cbc:EndpointID[@schemeID eq '0184'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0184']">
      <assert id="OIOUBL-COMMON-001" flag="fatal" test="matches(normalize-space(), '^\d{8}$')">The DK:CVR (0184) must be stated in the correct format (8
                        digits) - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cac:AdditionalDocumentReference/cbc:ID[@schemeID eq 'ARR']">
      <assert id="OIOUBL-COMMON-002" flag="fatal" test="(matches(normalize-space(.), '^\d{10}$')) and (../cbc:DocumentTypeCode eq '130')"> When 'cac:AdditionalDocumentReference/cbc:ID schemaID' equals 'ARR' The
                        value in ID must equal 10 digits - Value found: '<value-of select="." />' The
                        value in DocumentTypeCode must equal '130' - Value found: '<value-of select="../cbc:DocumentTypeCode" />' </assert>
    </rule>
    <rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0096'] | cbc:EndpointID[@schemeID eq '0096'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0096']">
      <assert id="OIOUBL-COMMON-003" flag="fatal" test="matches(normalize-space(), '^\d{10}$')">The DK:P (0096) value must be stated in the correct format (10
                        digits) - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0198'] | cbc:EndpointID[@schemeID eq '0198'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0198'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0198']">
      <assert id="OIOUBL-COMMON-004" flag="fatal" test="matches(normalize-space(), '^DK\d{8}$')">The DK:SE (0198) value must be stated in the correct format (DK
                        followed by 8 digits) - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0237'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0237'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0237']">
      <assert id="OIOUBL-COMMON-013" flag="fatal" test="matches(normalize-space(), '^\d{10}$')">The DK:CPR (0237)value must be stated in the correct format (10
                        digits) - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cbc:UUID">
      <assert id="OIOUBL-COMMON-005" flag="fatal" test="matches(., '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')">The element must contain a valid UUID - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="ext:UBLExtensions">
      <assert id="OIOUBL-COMMON-006" flag="fatal" test="ext:UBLExtension/ext:ExtensionAgencyID = 'ERST'                                 and (number(ext:UBLExtension/cbc:ID) >= 1001 and number(ext:UBLExtension/cbc:ID) &lt;= 1999)">Invalid UBLExtension/ID when UBLExtension/ExtensionAgencyID is
                        equal to 'ERST'. ID must be an assigned value between '1001' and '1999' -
                        Value found: '<value-of select="ext:UBLExtension/cbc:ID" />'</assert>
    </rule>
    <rule context="cbc:SequenceNumeric">
      <assert id="OIOUBL-COMMON-007" flag="fatal" test="not(starts-with(., '-'))">SequenceNumeric must not be negative - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cac:Address | cac:DespatchAddress | cac:JurisdictionRegionAddress | cac:OriginAddress | cac:PostalAddress | cac:RegistrationAddress | cac:ReturnAddress">
      <assert id="OIOUBL-COMMON-008" flag="fatal" test="count(./cbc:CityName) = 1 and count(./cbc:PostalZone) = 1">CityName AND PostalZone MUST be present.</assert>
      <assert id="OIOUBL-COMMON-009" flag="fatal" test="count(./cbc:Postbox) = 1 or                                 (count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)">IF Postbox does not exist, StreetName AND BuildingNumber MUST be present.</assert>
      <assert id="OIOUBL-COMMON-010" flag="fatal" test="count(./cbc:Floor) = 0 or                                 (count(./cbc:Floor) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)">IF Floor is present, StreetName and BuildingNumber MUST be present.</assert>
      <assert id="OIOUBL-COMMON-011" flag="fatal" test="count(./cbc:Room) = 0 or                                 (count(./cbc:Room) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)">IF Room is present, StreetName and BuildingNumber MUST be present.</assert>
      <assert id="OIOUBL-COMMON-012" flag="fatal" test="(count(./cbc:BuildingNumber) = 0 and count(./cbc:StreetName) = 0) or                                 (count(./cbc:BuildingNumber) = 1 and count(./cbc:StreetName) = 1)">IF BuildingNumber is present, StreetName MUST be present. IF StreetName is present, BuildingNumber MUST be present.</assert>
    </rule>
    <rule context="cac:AllowanceCharge">
      <assert id="OIOUBL-COMMON-150" flag="fatal" test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or cbc:AllowanceChargeReason">When AllowanceChargeReasonCode = ZZZ is used, then AllowanceChargeReason must be present</assert>
      <assert id="OIOUBL-COMMON-014" flag="fatal" test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or                                 ((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#')                                 and not(starts-with(cbc:AllowanceChargeReason, '#'))                                 and not(ends-with(cbc:AllowanceChargeReason, '#'))))">AllowanceChargeReason must include a #, but the # is not allowed as first and last character
                </assert>
    </rule>
    <rule context="cac:AccountingSupplierParty">
      <assert id="OIOUBL-COMMON-102" flag="fatal" test="not(cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID = '0237'])                                 or (ancestor::*/cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:billing_private_without_response:3')">SchemaID = '0237' is only allowed when ProfileID='urn:fdc:oioubl.dk:bis:billing_private_without_response:3'</assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="OIOUBL-COMMON-103" flag="fatal" test="count(cac:Item/cac:ManufacturersItemIdentification) &lt;= 1">No more than one ManufacturersItemIdentification class may be present</assert>
      <assert id="OIOUBL-COMMON-104" flag="fatal" test="not(cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID) or (some $val in $PackagingMarkedLabelAccreditationCode                         satisfies (cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID = $val))">The value of CertificateTypeCode must be one of the PackagingMarkedLabelAccreditationCode from GS1 Global Data Dictionary - Value found: '<value-of select="cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID" />' </assert>
    </rule>
    <rule context="cac:Party">
      <assert id="OIOUBL-COMMON-100" flag="fatal" test="cac:PartyLegalEntity">The element 'PartyLegalEntity' is mandatory in the 'Party'</assert>
      <assert id="OIOUBL-COMMON-101" flag="fatal" test="cac:PartyLegalEntity/cbc:CompanyID">The element 'CompanyID' is mandatory in the 'PartyLegalEntity'</assert>
      <assert id="OIOUBL-COMMON-106" flag="fatal" test="count(./cac:PartyName/cbc:Name) = 1">cac:Party/cac:PartyName/cbc:Name must be present.</assert>
      <assert id="OIOUBL-COMMON-107" flag="fatal" test="count(./cac:PartyLegalEntity) = 1">cac:Party/cac:PartyLegalEntity must be present.</assert>
      <assert id="OIOUBL-COMMON-108" flag="fatal" test="count(./cac:PartyLegalEntity/cbc:CompanyID) = 1">cac:Party/cac:PartyLegalEntity/cbc:CompanyID must be present.</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
      <assert id="OIOUBL-COMMON-105" flag="fatal" test="count(./cbc:ID) = 1">cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID must be present.</assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme | cac:TaxRepresentativeParty/cac:PartyTaxScheme">
      <assert id="OIOUBL-COMMON-109" flag="fatal" test="cbc:CompanyID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')">cac:PartyTaxScheme/cbc:CompanyID must be present when cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID differ from 'O'.</assert>
      <assert id="OIOUBL-COMMON-110" flag="fatal" test="cac:TaxScheme/cbc:ID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')">cac:PartyTaxScheme/cac:TaxScheme/cbc:ID mmust be present when cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID differ from 'O'.</assert>
    </rule>
    <rule context="cac:Party/cbc:EndpointID">
      <assert id="OIOUBL-COMMON-111" flag="fatal" test="@schemeID">cac:Party/cbc:EndpointID must have a @schemeID attribute.</assert>
    </rule>
    <rule context="cac:Party/cac:PartyIdentification/cbc:ID">
      <assert id="OIOUBL-COMMON-112" flag="fatal" test="@schemeID">cac:Party/cac:PartyIdentification/cbc:ID must have a @schemeID attribute.</assert>
    </rule>
    <rule context="cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
      <assert id="OIOUBL-COMMON-113" flag="fatal" test="@schemeID">cac:Party/cac:PartyLegalEntity/cbc:CompanyID must have a @schemeID attribute.</assert>
    </rule>
    <rule context="cac:PartyTaxScheme/cbc:CompanyID">
      <assert id="OIOUBL-COMMON-114" flag="fatal" test="@schemeID">cac:PartyTaxScheme/cbc:CompanyID must have a @schemeID attribute.</assert>
      <assert id="OIOUBL-COMMON-115" flag="fatal" test="some $code in $DK-ISO-6523-ICD                                         satisfies @schemeID = $code">@schemeID must be in ISO 6523 ICD code list or have the special DK value 'ZZZ'</assert>
    </rule>
    <rule context="cac:Signature">
      <assert id="OIOUBL-COMMON-116" flag="fatal" test="count(./cac:DigitalSignatureAttachment) = 1">The element 'DigitalSignatureAttachment' is mandatory in 'Signature'</assert>
      <assert id="OIOUBL-COMMON-117" flag="fatal" test="count(./cac:OriginalDocumentReference) = 1">The element 'OriginalDocumentReference' is mandatory in 'Signature'</assert>
      <assert id="OIOUBL-COMMON-118" flag="fatal" test="count(./cac:SignatoryParty) = 1">The element 'SignatoryParty' is mandatory in 'Signature'</assert>
      <assert id="OIOUBL-COMMON-119" flag="fatal" test="count(./cbc:CanonicalizationMethod) = 1">The element 'CanonicalizationMethod' is mandatory in 'Signature'</assert>
      <assert id="OIOUBL-COMMON-120" flag="fatal" test="count(./cbc:SignatureMethod) = 1">The element 'SignatureMethod' is mandatory in 'Signature'</assert>
    </rule>
    <rule context="cac:ActivityPeriod | cac:ApplicablePeriod | cac:ConstitutionPeriod | cac:ContractAcceptancePeriod | cac:ContractFormalizationPeriod | cac:DeliveryPeriod | cac:DocumentAvailabilityPeriod | cac:DurationPeriod | cac:EffectivePeriod | cac:EstimatedDeliveryPeriod | cac:EstimatedDespatchPeriod | cac:EstimatedDurationPeriod | cac:EstimatedTransitPeriod | cac:ExceptionObservationPeriod | cac:ForecastPeriod | cac:FrequencyPeriod | cac:InventoryPeriod | cac:InvitationSubmissionPeriod | cac:InvoicePeriod | cac:LineValidityPeriod | cac:MainPeriod | cac:NominationPeriod | cac:NotificationPeriod | cac:OptionValidityPeriod | cac:ParticipationRequestReceptionPeriod | cac:PaymentReversalPeriod | cac:PenaltyPeriod | cac:Period | cac:PlannedPeriod | cac:PresentationPeriod | cac:PromisedDeliveryPeriod | cac:ReminderPeriod | cac:RequestedDeliveryPeriod | cac:RequestedDespatchPeriod | cac:RequestedStatusPeriod | cac:RequestedValidityPeriod | cac:ServiceEndTimePeriod | cac:ServiceStartTimePeriod | cac:SettlementPeriod | cac:StatementPeriod | cac:StatusPeriod | cac:TenderSubmissionDeadlinePeriod | cac:TenderValidityPeriod | cac:TransitPeriod | cac:TransportServiceProviderResponseDeadlinePeriod | cac:TransportServiceProviderResponseRequiredPeriod | cac:TransportUserResponseRequiredPeriod | cac:UsabilityPeriod | cac:ValidityPeriod | cac:WarrantyValidityPeriod">
      <assert id="OIOUBL-COMMON-121" flag="fatal" test="not(matches(./cbc:StartDate, '^\d{4}-\d{2}-\d{2}$'))                                 or not(matches(./cbc:StartTime, '^\d{2}:\d{2}:\d{2}$'))                                 or not(matches(./cbc:EndDate, '^\d{4}-\d{2}-\d{2}$'))                                 or not(matches(./cbc:EndTime, '^\d{2}:\d{2}:\d{2}$'))                                 or not(xs:dateTime(concat(./cbc:StartDate, 'T', ./cbc:StartTime)) gt xs:dateTime(concat(./cbc:EndDate, 'T', ./cbc:EndTime)))">StartDate + StartTime must be before or the same as EndDate + EndTime</assert>
      <assert id="OIOUBL-COMMON-122" flag="fatal" test="count(./cbc:StartTime) = 0 or (count(./cbc:StartDate) = 1 and count(./cbc:StartTime) = 1)">If StartTime exists, StartDate must be present</assert>
      <assert id="OIOUBL-COMMON-123" flag="fatal" test="count(./cbc:EndTime) = 0 or (count(./cbc:EndDate) = 1 and count(./cbc:EndTime) = 1)">If EndTime exists, EndDate must be present</assert>
    </rule>
    <rule context="cbc:StartTime | cbc:EndTime">
      <assert id="OIOUBL-COMMON-124" flag="fatal" test="matches(., '^\d{2}:\d{2}:\d{2}$')">IF StartTime exists or EndTime exists, format must follow time format (without date format)</assert>
    </rule>
    <rule context="cac:Contact">
      <assert id="OIOUBL-COMMON-125" flag="fatal" test="not(matches(./cbc:ID, '^\d{6}-?\d{4}$'))">ID must not be a CPR number (must not have format XXXXXXXXXX or XXXXXX-XXXX)</assert>
      <assert id="OIOUBL-COMMON-126" flag="fatal" test="matches(./cbc:Telephone, '^(?:\+|00).*$')">Telephone must include country code (must start with '+' or '00')</assert>
      <assert id="OIOUBL-COMMON-127" flag="fatal" test="matches(./cbc:ElectronicMail, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$')">ElectronicMail must have valid format (like 'user123@example.com')</assert>
    </rule>
    <rule context="cac:Attachment">
      <assert id="OIOUBL-COMMON-128" flag="fatal" test="not(count(./cbc:EmbeddedDocumentBinaryObject) = 1 and count(./cac:ExternalReference) = 1)">Must not have both embedded document and external reference.</assert>
    </rule>
    <rule context="cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
      <assert id="OIOUBL-COMMON-129" flag="fatal" test="@filename">EmbeddedDocumentBinaryObject must have filename attribute</assert>
      <assert id="OIOUBL-COMMON-130" flag="fatal" test="some $code in $OpenPEPPOL-IANA-MimeCode                                         satisfies @mimeCode = $code">Attribute mimeCode must be a value from the code list</assert>
    </rule>
    <rule context="cac:Attachment/cac:ExternalReference">
      <assert id="OIOUBL-COMMON-131" flag="fatal" test="matches(./cbc:URI, '^.+$')">When using ExternalReference, URI is mandatory</assert>
      <assert id="OIOUBL-COMMON-132" flag="fatal" test="(count(./cbc:DocumentHash) = 1 and count(./cbc:HashAlgorithmMethod) = 1)                                 or (count(./cbc:DocumentHash) = 0 and count(./cbc:HashAlgorithmMethod) = 0)">If DocumentHash or HashAlgorithmMethod is present, the other must also be present.</assert>
      <assert id="OIOUBL-COMMON-133" flag="fatal" test="(count(./cbc:ExpiryTime) = 1 and count(./cbc:ExpiryDate) = 1)                                 or count(./cbc:ExpiryTime) = 0">If ExpiryTime is present, ExpiryDate MUST be present</assert>
    </rule>
    <rule context="cac:DocumentReference">
      <assert id="OIOUBL-COMMON-134" flag="fatal" test="(count(./cbc:IssueTime) = 1 and count(./cbc:IssueDate) = 1)                                 or count(./cbc:IssueTime) = 0">If IssueTime is present, IssueDate must be present</assert>
    </rule>
    <rule context="cac:TaxExchangeRate | cac:PricingExchangeRate | cac:PaymentExchangeRate | cac:PaymentAlternativeExchangeRate">
      <assert id="OIOUBL-COMMON-140" flag="fatal" test="cbc:CalculationRate > 0 and matches(cbc:CalculationRate, '^[0-9]+(\.[0-9]{4})?$')">CalculationRate must be greater than zero and have exactly 4 decimal places - Value found:  <value-of select="cbc:CalculationRate" /> </assert>
      <assert id="OIOUBL-COMMON-141" flag="fatal" test="cbc:MathematicOperatorCode = 'multiply' or cbc:MathematicOperatorCode = 'divide'">MathematicOperatorCode must be either 'multiply' or 'divide'</assert>
    </rule>
    <let name="PackagingMarkedLabelAccreditationCode" value="tokenize('100_PERCENT_CANADIAN_MILK,100_PERCENT_VEGANSKT,3PMSF,ACMI,ADCCPA,AFIA_PET_FOOD_FACILITY,AGENCE_BIO,AGRI_CONFIANCE,AGRI_NATURA,AGRICULTURE_BIOLOGIQUE,AHAM,AISE,AISE_2005,AISE_2010,AISE_2020_BRAND,AISE_2020_COMPANY,AKC_PEACH_KOSHER,ALENTEJO_SUSTAINABILITY_PROGRAMME,ALIMENTATION_DU_TOUT_PETIT,ALIMENTS_BIO_PREPARES_AU_QUEBEC,ALIMENTS_DU_QUEBEC,ALIMENTS_DU_QUEBEC_BIO,ALIMENTS_PREPARES_AU_QUEBEC,ALPINAVERA,ALUMINIUM_GESAMTVERBAND_DER_ALUMINIUMINDUSTRIE,AMA_GENUSSREGION,AMA_ORGANIC_SEAL,AMA_ORGANIC_SEAL_BLACK,AMA_SEAL_OF_APPROVAL,AMERICAN_DENTAL_ASSOCIATION,AMERICAN_HEART_ASSOCIATION_CERTIFIED,ANIMAL_WELFARE_APPROVED_GRASSFED,AOP,APPELLATION_ORIGINE_CONTROLEE,APPROVED_BY_ASTHMA_AND_ALLERGY_ASSOC,AQUA_GAP,AQUACULTURE_STEWARDSHIP_COUNCIL,ARGE_GENTECHNIK_FREI,ARGENCERT,ARLA_FARMER_OWNED,ASCO,ASMI,ASTHMA_AND_ALLERGY_FOUNDATION_OF_AMERICA,ATG,AUS_KAUP_ESTONIA,AUSTRALIAN_CERTIFIED_ORGANIC,AUSTRIA_BIO_GARANTIE,AUSTRIAN_ECO_LABEL,BCARA_ORGANIC,BDIH_LOGO,BEBAT,BEDRE_DYREVELFAERD_1HEART,BEDRE_DYREVELFAERD_2HEART,BEDRE_DYREVELFAERD_3HEART,BEE_FRIENDLY,BELGAQUA,BENOR,BERCHTESGADENER_LAND,BEST_AQUACULTURE_PRACTICES,BEST_AQUACULTURE_PRACTICES_2_STARS,BEST_AQUACULTURE_PRACTICES_3_STARS,BEST_AQUACULTURE_PRACTICES_4_STARS,BETER_LEVEN_1_STER,BETER_LEVEN_2_STER,BETER_LEVEN_3_STER,BETTER_BUSINESS_BUREAU_ACCREDITED,BETTER_COTTON_INITIATIVE,BEVEG,BEWUSST_TIROL,BEWUSTE_KEUZE,BIKO_TIROL,BIO_AUSTRIA_LABEL,BIO_BAYERN_WITH_CERTIFICATE_PROVENANCE,BIO_BAYERN_WITHOUT_CERTIFICATE_PROVENANCE,BIO_BUD_SEAL,BIO_BUD_SEAL_TRANSITION,BIO_CZECH_LABEL,BIO_FISCH,BIO_GOURMET_BUD,BIO_LABEL_BADEN_WURTTENBERG,BIO_LABEL_GERMAN,BIO_LABEL_HESSEN,BIO_PARTENAIRE,BIO_RING_ALLGAEU,BIO_SOLIDAIRE,BIO_SUISSE_BUD_SEAL,BIO_SUISSE_BUD_SEAL_TRANSITION,BIOCHECKED_NON_GLYPHOSATE_CERTIFIED,BIOCHECKED_NON_GMO_VERIFIED,BIODEGRADABLE,BIODEGRADABLE_PRODUCTS_INSTITUTE,BIODYNAMIC_CERTIFICATION,BIODYNAMISCH,BIOGARANTIE,BIOKREIS,BIOLAND,BIOLAND_ENNSTAL,BIOPARK,BIOS_KONTROLLE,BIRD_FRIENDLY_COFFEE_SMITHSONIAN_CERTIFICATION,BK_CHECK_VAAD_HAKASHRUS_OF_BUFFALO,BLEU_BLANC_COEUR,BLUE_ANGEL,BLUE_RIBBON_KOSHER,BLUESIGN,BODEGAS_ARGENTINA_SUSTAINABILITY_PROTOCOL,BONSUCRO,BORD_BIA_APPROVED,BORD_BIA_APPROVED_MEAT,BRA_MILJOVAL_LABEL_SWEDISH,BRC_GLOBAL_STANDARDS,BREATHEWAY,BRITISH_DENTAL_HEALTH,BRITISH_RETAIL_CONSORTIUM_CERTIFICATION,BSCI,BULLFROG,CA_BEEF,CA_BOTH_DOM_IMPORT,CA_BULK,CA_CANNED,CA_DISTILLED,CA_IMPORT,CA_INGREDIENT,CA_MADE,CA_MUSTARD_SEEDS,CA_OATS,CA_PREPARED,CA_PROCESSED,CA_PRODUCT,CA_PROUD,CA_REFINED,CA_ROASTED_BLENDED,CAC_ABSENCE_EGG_MILK,CAC_ABSENCE_EGG_MILK_PEANUTS,CAC_ABSENCE_OF_ALMOND,CAC_ABSENCE_OF_EGG,CAC_ABSENCE_OF_MILK,CAC_ABSENCE_OF_PEANUT,CAC_ABSENCE_PEANUT_ALMOND,CAFE_PRACTICES,CAN_BNQ_CERTIFIED,CANADA_GAP,CANADIAN_AGRICULTURAL_PRODUCTS,CANADIAN_ASSOCIATION_FIRE_CHIEFS_APPROVED,CANADIAN_CERTIFIED_COMPOSTABLE,CANADIAN_DERMATOLOGY_ASSOCIATION_SKIN_HEALTH,CANADIAN_DERMATOLOGY_ASSOCIATION_SUN_PROTECTION,CARBON_FOOTPRINT_STANDARD,CARBON_NEUTRAL,CARBON_NEUTRAL_NCOS_CERTIFIED,CARBON_NEUTRAL_PACKAGING,CARIBBEAN_KOSHER,CCA_GLUTEN_FREE,CCC,CCF_RABBIT,CCOF,CCSW,CEBEC,CEL,CELIAC_SPRUE_ASSOCIATION,CENTRAL_RABBINICAL_CONGRESS_KOSHER,CERTIFIE_TERROIR_CHARLEVOIX,CERTIFIED_ANGUS_BEEF,CERTIFIED_B_CORPORATION,CERTIFIED_CARBON_FREE,CERTIFIED_HUMANE_ORGANISATION,CERTIFIED_NATURALLY_GROWN,CERTIFIED_OE_100,CERTIFIED_ORGANIC_BAYSTATE_ORGANIC_CERTIFIERS,CERTIFIED_ORGANIC_BY_ORGANIC_CERTIFIERS,CERTIFIED_PALEO,CERTIFIED_PALEO_FRIENDLY,CERTIFIED_PLANT_BASED,CERTIFIED_SUSTAINABLE_WINE_CHILE,CERTIFIED_WBENC,CERTIFIED_WILDLIFE_FRIENDLY,CFG_PROCESSED_EGG,CFIA,CFIA_DAIRY,CFIA_FISH,CFIA_GRADE_A,CFIA_GRADE_C,CFIA_ORGANIC,CFIA_UTILITY_POULTRY_EGG,CHASSEURS_DE_FRANCE,CHEESE_WORLD_CHAMPION_CHEESE_CONTEST,CHES_K,CHICAGO_RABBINICAL_COUNCIL,CINCINNATI_KOSHER,CLARO_FAIR_TRADE,CLIMATE_NEUTRAL,CLIMATE_NEUTRAL_PARTNER,CNG,CO2_REDUCERET_EMBALLAGE,CO2LOGIC_CO2_NEUTRAL_CERTIFIED,COCOA_HORIZONS,COCOA_LIFE,COMPOSTABLE_DIN_CERTCO,COMTE_GREEN_BELL,CONFORMITE_EUROPEENNE,CONSUMER_CHOICE_AWARD,COR_DETROIT,COR_KOSHER,CORRUGATED_RECYCLES,COSMEBIO,COSMEBIO_COSMOS_NATURAL,COSMEBIO_COSMOS_ORGANIC,COTTON_MADE_IN_AFRICA,CPE_SCHARREL_EIEREN,CPE_VRIJE_UITLOOP_EIEREN,CRADLE_TO_CRADLE,CROSSED_GRAIN_SYMBOL,CROWN_CHK,CRUELTY_FREE_PETA,CSA_INTERNATIONAL,CSA_NCA_GLUTEN_FREE,CSI,CULINARIUM,CULTIVUP_EXIGENCE,CULTIVUP_RESPONSABLE,CZECH_FOOD,DALLAS_KOSHER,DANSK_IP_KVALITET,DANSK_MAELK,DEBIO,DELINAT,DEMETER_LABEL,DESIGN_FOR_THE_ENVIRONMENT,DESIGN_FROM_FINLAND,DIAMOND_K,DIAMOND_KA_KASHRUT_AUTHORITY_OF_AUSTRALIA_AND_NZ,DIRECT_TRADE,DK_ECO,DLG_AWARD,DLG_CERTIFIED_ALLERGEN_MANAGEMENT ,DNV_BUSINESS_ASSURANCE,DOLPHIN_SAFE,DONAU_SOYA_STANDARD,DRP,DUURZAAM_VARKENSVLEES,DVF_VEGAN,DVF_VEGETARIAN,DYRENES_BESKYTTELSE,DZG_GLUTEN_FREE,EARTHKOSHER_KOSHER,EARTHSURE,ECARF_SEAL,ECO_KREIS,ECO_LABEL_CZECH,ECO_LABEL_LADYBUG,ECO_LOGO,ECOCERT_CERTIFICATE,ECOCERT_COSMOS_NATURAL,ECOCERT_COSMOS_ORGANIC,ECOCERT_ORGANIC,ECOGARANTIE,ECOLAND,ECOLOGO_CERTIFIED,ECOLOGO_CERTIFIED_2,ECOVIN,ECZEMA_SOCIETY_OF_CANADA,EESTI_OKOMARK,EESTI_PARIM_TOIDUAINE,EKO,ENEC,ENERGY_LABEL_A,ENERGY_LABEL_A+,ENERGY_LABEL_A++,ENERGY_LABEL_A+++,ENERGY_LABEL_B,ENERGY_LABEL_C,ENERGY_LABEL_D,ENERGY_LABEL_E,ENERGY_LABEL_F,ENERGY_LABEL_G,ENERGY_STAR,ENTREPRISE_DU_PATRIMOINE_VIVANT,ENTWINE_AUSTRALIA,EPA_DFE,EPEAT_BRONZE,EPEAT_GOLD,EPEAT_SILVER,EQUAL_EXCHANGE_FAIRLY_TRADED,EQUALITAS_SUSTAINABLE_WINE,ERDE_SAAT,ERKEND_STREEK_PRODUCT,ETP,EU_ECO_LABEL,EU_ENERGY_LABEL,EU_ORGANIC_FARMING,EUROPE_SOYA_STANDARD,EUROPEAN_V_LABEL_VEGAN,EUROPEAN_V_LABEL_VEGETARIAN,EUROPEAN_VEGETARIAN_UNION,EWG_VERIFIED,FAIR_FLOWERS_FAIR_PLANTS,FAIR_FOOD_PROGRAM_LABEL,FAIR_FOR_LIFE,FAIR_N_GREEN,FAIR_TRADE_MARK,FAIR_TRADE_USA,FAIR_TRADE_USA,FAIR_TRADE_USA_INGREDIENTS,FAIR_TSA,FAIRTRADE_CASHEW_NUTS,FAIRTRADE_COCOA,FAIRTRADE_COCONUT,FAIRTRADE_COTTON,FAIRTRADE_DRIED_APRICOTS,FAIRTRADE_GREEN_TEA,FAIRTRADE_HONEY,FAIRTRADE_LIME_JUICE,FAIRTRADE_MANGO_JUICE,FAIRTRADE_OLIVE_OIL,FAIRTRADE_PEPPER,FAIRTRADE_QUINOA,FAIRTRADE_RICE,FAIRTRADE_ROSES,FAIRTRADE_SUGAR,FAIRTRADE_TEA,FAIRTRADE_VANILLA,FALKEN,FCC,FEDERALLY_REGISTERED_INSPECTED_CANADA,FIDELIO,FINNISH_HEART_SYMBOL,FISH_WISE_CERTIFCATION,FLAMME_VERTE,FLANDRIA,FLEURS_DE_FRANCE,FODMAP,FODMAP_FRIENDLY,FOOD_ALLIANCE_CERTIFIED,FOOD_JUSTICE_CERTIFIED,FOOD_SAFETY_SYSTEM_CERTIFICATION_22000,FOODLAND_ONTARIO,FOR_LIFE,FOREST_PRODUCTS_Z809,FOREST_STEWARDSHIP_COUNCIL_100_PERCENT,FOREST_STEWARDSHIP_COUNCIL_LABEL,FOREST_STEWARDSHIP_COUNCIL_MIX,FOREST_STEWARDSHIP_COUNCIL_RECYCLED,FOUNDATION_ART,FRAN_SVERIGE,FRANCE_LIMOUSIN_MEAT,FREILAND,FRESHCARE,FRIEND_OF_THE_SEA,FRUITS_ET_LEGUMES_DE_FRANCE,GAEA,GANEDEN_BC30_PROBIOTIC,GAP_1,GAP_2,GAP_3,GAP_4,GAP_5,GAP_5_PLUS,GASKEUR,GASTEC,GCP,GEBANA,GENUSS_REGION_AUSTRIA,GENUSS_REGION_AUSTRIA,GEPRUEFTE_SICHERHEIT,GEZONDERE_KEUZE,GFCO,GFCO,GFCP,GIG_GLUTEN_FREE_FOODSERVICE,GLOBAL_CARE,GLOBAL_GAP,GLOBAL_ORGANIC_LATEX_STANDARD,GLOBAL_ORGANIC_TEXTILE_STANDARD,GLOBAL_RECYCLED_STANDARD,GLYCAMIC_INDEX_FOUNDATION,GLYCAMIC_RESEARCH_INSTITUTE,GMO_GUARD_FROM_NATURAL_FOOD_CERTIFIERS,GMO_MARKED,GMP_CERTIFIED,GMP_ISO_22716,GOA_ORGANIC,GODKAND_FOR_EKOLOGISK_ODLING_KRAV,GOOD_HOUSEKEEPING,GOODS_FROM_FINLAND_BLUE_SWAN,GOODWEAVE,GRASKEURMERK,GRASP,GREEN_AMERICA_CERTIFIED_BUSINESS,GREEN_DOT,GREEN_E_ENERGY_CERT,GREEN_E_ORG,GREEN_RESTAURANT_ASSOCIATION_ENDORSED,GREEN_SEAL,GREEN_SEAL_CERTIFIED,GREEN_SHIELD_CERTIFIED,GREEN_STAR_CERTIFIED,GREENCHOICE,GROEN_LABEL_KAS,GRUYERE_FRANCE,GUARANTEED_IRISH,HALAL_AUSTRALIA,HALAL_CERTIFICATION_SERVICES,HALAL_CERTIFICATION_SERVICES_CH,HALAL_CORRECT,HALAL_FOOD_COUNCIL_OF_SOUTH_EAST_ASIA_THAILAND,HALAL_HIC,HALAL_HPDS,HALAL_INDIA,HALAL_ISLAMIC_FOOD_CANADA,HALAL_ISLAMIC_SOCIETY_OF_NORTH_AMERICA,HALAL_PLUS,HAUTE_VALEUR_ENVIRONNEMENTALE,HAZARD_ANALYSIS_CRITICAL_CONTROL_POINT,HEALTH_CHECK,HEALTH_FOOD_BLUE_HAT_SIGN,HEUMILCH,HFAC_HUMANE,HMCA_HALAL_MONTREAL_CERTIFICATION_AUTHORITY,HOCHSTAMM_SUISSE,HOW_2_RECYCLE,HUMANE_HEARTLAND,HYPERTENSION_CANADA_MEDICAL_DEVICE,ICADA,ICEA,ICELAND_RESPONSIBLE_FISHERIES,ICS_ORGANIC,IFANCA_HALAL,IFOAM,IFS_HPC,IGP,IHTK_SEAL,IKB_EIEREN,IKB_KIP,IKB_VARKEN,INDEKLIMA_MAERKET,INSTITUT_FRESENIUS,INT_PROTECTION,INTEGRITY_AND_SUSTAINABILITY_CERTIFIED,INTERNATIONAL_ALOE_SCIENCE_COUNCIL_CERTIFICATE,INTERNATIONAL_KOSHER_COUNCIL,INTERNATIONAL_TASTE_QUALITY,INTERTEK_CERTIFICATE,INTERTEK_ETL,IP_SUISSE,ISCC,ISCC_SUPPORTING_THE_BIOECONOMY,ISEAL_ALLIANCE,ISO_QUALITY,IVN_NATURAL_LEATHER,IVN_NATURAL_TEXTILES_BEST,IVO_OMEGA3,JAS_ORGANIC,JAY_KOSHER_PAREVE,JODSALZ_BZGA,KABELKEUR,KAGFREILAND,KEHILLA_KOSHER_CALIFORNIA_K,KEHILLA_KOSHER_HEART_K,KEMA_KEUR,KIWA,KLASA,KOF_K_KOSHER,KOMO,KOSHER_AUSTRALIA,KOSHER_BDMC,KOSHER_CERTIFICATION_SERVICE,KOSHER_CHECK,KOSHER_CHICAGO_RABBINICAL_COUNCIL_DAIRY,KOSHER_CHICAGO_RABBINICAL_COUNCIL_PAREVE,KOSHER_COR_DAIRY,KOSHER_COR_DAIRY_EQUIPMENT,KOSHER_COR_FISH,KOSHER_EIDAH_HACHAREIDIS,KOSHER_GRAND_RABBINATE_OF_QUEBEC_PARVE,KOSHER_GREECE,KOSHER_INSPECTION_SERVICE_INDIA,KOSHER_KW_YOUNG_ISRAEL_OF_WEST_HEMPSTEAD,KOSHER_MADRID_SPAIN,KOSHER_OK_DAIRY,KOSHER_ORGANICS,KOSHER_ORTHODOX_JEWISH_CONGREGATION_PARVE,KOSHER_OTTAWA_VAAD_HAKASHRUT_CANADA,KOSHER_PARVE_BKA,KOSHER_PARVE_NATURAL_FOOD_CERTIFIER,KOSHER_PERU,KOSHER_RAV_LANDAU,KOSHER_STAR_K_PARVE,KOSHER_STAR_K_PARVE_PASSOVER,KOSHER_STAR_S_P_KITNIYOT,KOSHERMEX,KOTT_FRAN_SVERIGE,KRAV_MARK,KSA_KOSHER,KSA_KOSHER_DAIRY,KVBG_APPROVED,LAATUVASTUU,LABEL_OF_THE_ALLERGY_AND_ASTHMA_FEDERATION,LABEL_ROUGE,LACON,LAENDLE_QUALITAET,LAIT_COLLECTE_ET_CONDITIONNE_EN_FRANCE,LAIT_COLLECTE_ET_TRANSFORME_EN_FRANCE,LAPIN_DE_FRANCE,LE_PORC_FRANCAIS,LEAPING_BUNNY,LEGUMES_DE_FRANCE,LETIS_ORGANIC,LGA,LOCALIZE,LODI_RULES_CODE,LONDON_BETH_DIN_KOSHER,LOODUSSOBRALIK_TOODE_ESTONIA,LOVE_IRISH_FOOD,LVA,MADE_GREEN_IN_ITALY,MADE_IN_FINLAND_FLAG_WITH_KEY,MADE_OF_PLASTIC_BEVERAGE_CUPS,MADE_WITH_CANADIAN_BEEF,MAITRE_ARTISAN,MARINE_STEWARDSHIP_COUNCIL_LABEL,MAX_HAVELAAR,MCIA_ORGANIC,MEHR_WEG,MIDWEST_KOSHER,MILIEUKEUR,MINNESOTA_KOSHER_COUNCIL,MJOLK_FRAN_SVERIGE,MOMS_CHOICE_AWARD,MONTREAL_VAAD_HAIR_MK_PAREVE,MORTADELLA_BOLOGNA,MPS_A,MUNDUSVINI_GOLD,MUNDUSVINI_SILVER,MUSLIM_JUDICIAL_COUNCIL_HALAAL_TRUST,MY_CLIMATE,NAOOA_CERTIFIED_QUALITY,NASAA_CERTIFIED_ORGANIC,NATRUE_LABEL,NATURA_BEEF,NATURA_VEAL,NATURE_CARE_PRODUCT,NATURE_ET_PROGRES,NATUREPLUS,NATURLAND,NATURLAND_FAIR_TRADE,NATURLAND_WILDFISH,NC_NATURAL_COSMETICS_STANDARD,NC_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NC_VEGAN_NATURAL_COSMETICS,NC_VEGAN_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NCA_GLUTEN_FREE,NDOA,NEA,NEULAND,NEW_ZEALAND_SUSTAINABLE_WINEGROWING,NF_MARQUE,NFCA_GLUTEN_FREE,NIX18,NMX,NOM,NON_GMO_BY_EARTHKOSHER,NON_GMO_PROJECT,NPA,NSF,NSF_CERTIFIED_FOR_SPORT,NSF_GLUTEN_FREE,NSF_NON_GMO_TRUE_NORTH,NSF_SUSTAINABILITY_CERTIFIED,NSM,NYCKELHALET,OCEAN_WISE,OCIA,OCQV_ORGANIC,OECD_BIO_INGREDIENTS,OEKO_CONTROL,OEKO_KREISLAUF,OEKO_QUALITY_GUARANTEE_BAVARIA,OEKO_TEX_LABEL,OEKO_TEX_MADE_IN_GREEN,OEUFS_DE_FRANCE,OFF_ORGANIC,OFFICIAL_ECO_LABEL_SUN,OFG_ORGANIC,OHNE_GEN_TECHNIK,OK_COMPOST_HOME,OK_COMPOST_INDUSTRIAL ,OK_COMPOST_VINCOTTE,OK_KOSHER,OKOTEST,ON_THE_WAY_TO_PLANETPROOF,ONE_PERCENT_FOR_THE_PLANET,ONTARIO_APPROVED,ONTARIO_PORK,ORB,ORBI,OREGON_KOSHER,OREGON_LIVE,OREGON_TILTH,ORGANIC_100_CONTENT_STANDARD,ORGANIC_COTTON,ORGANIC_TRADE_ASSOCIATION,ORIGIN_OF_EGGS,ORIGINE_FRANCE_GARANTIE,ORTHODOX_UNION,OTCO_ORGANIC,OU_KOSHER,OU_KOSHER_DAIRY,OU_KOSHER_FISH,OU_KOSHER_MEAT,OU_KOSHER_PASSOVER,OZONE_FRIENDLY_GENERAL_CLAIM,PACS_ORGANIC,PALEO_APPROVED,PALEO_BY_EARTHKOSHER,PARENT_TESTED_PARENT_APPROVED,PAVILLON_FRANCE,PCO,PEFC,PEFC_CERTIFIED,PEFC_RECYCLED,PET_TO_PET,PGI_CNIPA,PGI_GAQSIQ,PGI_MARA,PGI_TO_SAIC,PLASTIC_FREE_TRUST_MARK,PLASTIC_IN_FILTER_TOBACCO,PLASTIC_IN_PRODUCT_BEVERAGE_CUPS,PLASTIC_IN_PRODUCT_TAMPONS,PLASTIC_IN_PRODUCT_WIPES_SANITARY_PADS,PLASTIC_NEUTRAL,POMMES_DE_TERRES_DE_FRANCE,PREGNANCY_WARNING,PRO_SPECIE_RARA,PRO_TERRA_NON-GMO_CERTIFICATION,PROCERT_ORGANIC,PRODERM,PRODUCT_OF_THE_YEAR_CONSUMER_SURVEY,PRODUIT_EN_BRETAGNE,PROTECTED_DESIGNATION_OF_ORIGIN,PROTECTED_GEOGRAPHICAL_INDICATION,PROTECTED_HARVEST_CERTIFIED,PROVEN_QUALITY_BAVARIA,PUHTAASTI_KOTIMAINEN,QAI,QCS_ORGANIC,QS,QS_PRODUCTION_PERMIT,QUALENVI,QUALITAET_TIROL,QUALITY_CONFORMANCE_MARKING_CN,QUALITY_MARK_IRELAND,QUALITY_RHOEN,RABBINICAL_COUNCIL_OF_BRITISH_COLUMBIA,RABBINICAL_COUNCIL_OF_CALIFORNIA_(RCC),RABBINICAL_COUNCIL_OF_NEW_ENGLAND,RAINFOREST_ALLIANCE,RAINFOREST_ALLIANCE_PEOPLE_NATURE,RAL_QUALITY_CANDLES,REAL_CALIFORNIA_CHEESE,REAL_CALIFORNIA_MILK,REAL_FOOD_SEAL,RECUPEL,RECYCLABLE_GENERAL_CLAIM,REGIONAL_FOOD_CZECH,REGIONALFENSTER,REGIONALTHEKE_FRANKEN,RETURNABLE_PET_BOTTLE_NL,RHP,ROQUEFORT_RED_EWE,ROUNDTABLE_ON_RESPONSIBLE_SOY,RSB,RUP_GUADELOUPE,RUP_GUYANE,RUP_MARTINIQUE,RUP_MAYOTTE,RUP_REUNION,RUP_SAINT_MARTIN,SA8000,SAFE_FEED_SAFE_FOOD,SAFE_QUALITY_FOOD,SAFER_CHOICE,SALMON_SAFE_CERTIFICATION,SALZBURGER_LAND_HERKUNFT,SCHARRELVLEES,SCHLESWIG_HOLSTEIN_QUALITY,SCROLL_K,SCS_RECYCLED_CONTENT_CERTIFICATION,SCS_SUSTAINABLY_GROWN,SEACHOICE,SFC_MEMBER_SEAL,SFC_MEMBER_SEAL_GOLD,SFC_MEMBER_SEAL_PLATINUM,SFC_MEMBER_SEAL_SILVER,SGS_ORGANIC,SHOPPER_ARMY,SIP,SKG_CERTIFICATE,SKG_CERTIFICATE_1_STAR,SKG_CERTIFICATE_2_STAR,SKG_CERTIFICATE_3_STAR,SLG_CHILD_SAFETY,SLG_TYPE_TESTED,SLK_BIO,SOCIETY_PLASTICS_INDUSTRY,SOIL_ASSOCIATION_ORGANIC_SYMBOL,SOIL_COSMOS_NATURAL,SOIL_ORGANIC_COSMOS,SOSTAIN,SPCA_BC,STAR_D_KOSHER,STAR_K_KOSHER,STEEL_RECYCLING,STELLAR_CERTIFICATION_SERVICES,STIFTUNG_WARENTEST,STOP_CLIMATE_CHANGE,STREEKPRODUCT_BE,STRICTLY_KOSHER_NORWAY,SUISSE_GARANTIE,SUNSHINE_STATE_KOSHER,SUOMEN_HAMMASLAAKARILIITTO_SUOSITTELEE_KSYLITOLIA,SUS,SUSTAINABLE_AUSTRALIA_WINEGROWING,SUSTAINABLE_AUSTRIA,SUSTAINABLE_FORESTRY_INITIATIVE,SUSTAINABLE_PALM_OIL_RSPO,SUSTAINABLE_PALM_OIL_RSPO_CREDITS,SUSTAINABLE_PALM_OIL_RSPO_MIXED,SVANEN,SVENSK_FAGEL,SVENSKT_KOTT,SVENSKT_SIGILL_KLIMATCERTIFIERAD,SVENSKT_SIGILL_NATURBETESKOTT,SWEDISH_SEAL_OF_QUALITY,SWISS_ALLERGY_LABEL,SWISS_ALPS_PRODUCT,SWISS_MOUNTAIN_PRODUCT,SWISSGAP,SWISSMILK_GREEN,SWISSPRIMGOURMET,TARNOPOL_KASHRUS_KOSHER,TCO_DEVELOPMENT,TCO_ORGANIC,TERRA_VITIS,TERRACYCLE,THE_FAIR_RUBBER_ASSOCIATION,THE_NATURAL_AND_ORGANIC_AWARDS,THREE_LINE_KOSHER,TIERSCHUTZBUND,TNO_APPROVED,TOOTHFRIENDLY,TRADITIONAL_SPECIALTY_GUARANTEED,TRIANGLE_K,TRIMAN,TRUE_FOODS_CANADA_TRUSTMARK,TRUE_SOURCE_CERTIFIED,TUEV_GEPRUEFT,TUNNUSTATUD_EESTI_MAITSE,TUNNUSTATUD_MAITSE,UDEN_GMO_FODER,UMWELTBAUM,UNDERWRITERS_LABORATORY,UNDERWRITERS_LABORATORY_CERTIFIED_CANADA_US,UNIQUELY_FINNISH,UNITED_EGG_PRODUCERS_CERTIFIED,UNSER_LAND,URDINKEL,USDA,USDA_CERTIFIED_BIOBASED,USDA_GRADE_A,USDA_GRADE_AA,USDA_INSPECTION,USDA_ORGANIC,UTZ_CERTIFIED,UTZ_CERTIFIED_COCOA,VAAD_HOEIR_KOSHER,VAELG_FULDKORN_FORST,VDE,VDS_CERTIFICATE,VEGAN_AWARENESS_FOUNDATION,VEGAN_BY_EARTHKOSHER,VEGAN_NATURAL_FOOD_CERTIFIERS,VEGAN_SOCIETY_VEGAN_LOGO,VEGAPLAN,VEGATARIAN_SOCIETY_V_LOGO,VEGECERT,VEILIG_WONEN_POLITIE_KEURMERK,VERBUND_OEKOHOEFE,VIANDE_AGNEAU_FRANCAIS,VIANDE_BOVINE_FRANCAISE,VIANDE_CHEVALINE_FRANCAISE,VIANDE_DE_CHEVRE_FRANCAISE,VIANDE_DE_CHEVREAU_FRANCAISE,VIANDE_DE_VEAU_FRANCAISE,VIANDE_OVINE_FRANCAISE,VIANDES_DE_FRANCE,VIGNERONS_EN_DEVELOPPEMENT_DURABLE,VIM_CO_JIM,VINATURA,VINHO_VERDE,VITICULTURE_DURABLE_EN_CHAMPAGNE,VIVA,VOLAILLE_FRANCAISE,WARRANT_HOLDER_OF_THE_COURT_OF_BELGIUM,WEIDEMELK,WEIGHT_WATCHERS_ENDORSED,WESTERN_KOSHER,WHOLE_GRAIN_100_PERCENT_STAMP,WHOLE_GRAIN_BASIC_STAMP,WHOLE_GRAIN_COUNCIL_STAMP,WHOLE_GRAINS_50_PERCENT_STAMP,WIETA (Wine and Agricultural Ethical Trading Association),WINERIES_FOR_CLIMATE_PROTECTION,WISCONSIN_K,WQA_TESTED_CERTIFIED_WATER,WSDA,WWF_PANDA_LABEL,ZELDZAAM_LEKKER,ZERO_WASTE_BUSINESS_COUNCIL_CERTIFIED', ',')" />
    <let name="DK-ISO-6523-ICD" value="tokenize('ZZZ 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230', '\s')" />
    <let name="OpenPEPPOL-IANA-MimeCode" value="tokenize('text/csv application/pdf image/png image/jpeg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  </pattern>
  <pattern>
    <rule context="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode |                 cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
      <assert id="OIOUBL-Common-GP001" flag="fatal" test="not(@listID = 'TST') or (@listVersionID = '19.05.01' or @listVersionID = '19.0501' or @listVersionID = '26.08.01' or @listVersionID = '26.0801')">When @listID is "TST", the value of @listVersionID must be on of the following: "19.05.01", "19.0501", "26.08.01", or "26.0801" - Value
                        found: '<value-of select="@listVersionID" />' </assert>
      <assert id="OIOUBL-Common-GP002" flag="fatal" test="not(@listID = 'TST') or (matches(., '^\d{8}$'))">When ItemClassificationCodevalue/listID = 'TST' then the value must be 8 digits - Value found: '<value-of select="." />' </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:AdditionalItemProperty |                         cac:CreditNoteLine/cac:Item/cac:AdditionalItemProperty">
      <assert id="OIOUBL-Common-GP004" flag="fatal" test="not(cbc:Name = 'EmissionFactor') or (number(cbc:Value) = number(cbc:Value))">If AdditionalItemProperty/Name is 'EmissionFactor', then the AdditionalItemProperty/Value must be a valid numeric value</assert>
      <assert id="OIOUBL-Common-GP005" flag="fatal" test="not(cbc:Name = 'NetEmissionQuantity') or                         (                         round(number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value) * number(../../cbc:InvoicedQuantity) * 10000) div 10000 = round(number(cbc:Value)*10000) div 10000 or                         round(number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value) * number(../../cbc:CreditedQuantity) * 10000) div 10000 = round(number(cbc:Value)*10000) div 10000)">if Name is 'NetEmissionQuantity', then its Value must equal EmissionFactor * Quantity (InvoicedQuantity / CreditedQuantity)"
                        Values found
                        - NetEmissionQuantity value  <value-of select="number(cbc:Value)" />
                        - NetEmissionFactor value <value-of select="number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value)" />
                        - Quantity: <value-of select="number(../../cbc:InvoicedQuantity)" />
</assert>
      <assert id="OIOUBL-Common-GP006" flag="fatal" test="not(cbc:Name = 'EmissionFactorSource') or                                 (cbc:Value = 'Database' or cbc:Value = 'Internal')">If AdditionalItemProperty/Name is 'EmissionFactorSource', then AdditionalItemProperty/Value must be either 'Database' or
                        'Internal'</assert>
      <assert id="OIOUBL-Common-GP007" flag="fatal" test="not(cbc:Name = 'EmissionFactor') or                         (../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactorSource'])">If AdditionalItemProperty/Name is 'EmissionFactor', then another AdditionalItemProperty/Name = 'EmissionFactorSource' must exist </assert>
      <assert id="OIOUBL-Common-GP008" flag="fatal" test="not(cbc:Name = 'EmissionFactorCalculationUnit') or                                 (some $val in $UNECERec20-11e                                         satisfies (cbc:Value = $val))">If AdditionalItemProperty/Name equal
                        'EmissionFactorCalculationUnit' then AdditionalItemProperty/Value must have a valid UnitCode value from the codelist UNECERec20-11e</assert>
    </rule>
    <let name="UNCL7143" value="tokenize('AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ,CC,CG,CL,CR,CV,DR,DW,EC,EF,EMD,EN,FS,GB,GMN,GN,GS,HS,IB,IN,IS,IT,IZ,MA,MF,MN,MP,NB,ON,PD,PL,PO,PV,QS,RC,RN,RU,RY,SA,SG,SK,SN,SRS,SRT,SRU,SRV,SRW,SRX,SRY,SRZ,SS,SSA,SSB,SSC,SSD,SSE,SSF,SSG,SSH,SSI,SSJ,SSK,SSL,SSM,SSN,SSO,SSP,SSQ,SSR,SSS,SST,SSU,SSV,SSW,SSX,SSY,SSZ,ST,STA,STB,STC,STD,STE,STF,STG,STH,STI,STJ,STK,STL,STM,STN,STO,STP,STQ,STR,STS,STT,STU,STV,STW,STX,STY,STZ,SUA,SUB,SUC,SUD,SUE,SUF,SUG,SUH,SUI,SUJ,SUK,SUL,SUM,TG,TSN,TSO,TSP,TSQ,TSR,TSS,TST,TSU,UA,UP,VN,VP,VS,VX,ZZZ', ',')" />
    <let name="UNECERec20-11e" value="tokenize('10,11,13,14,15,20,21,22,23,24,25,27,28,33,34,35,37,38,40,41,56,57,58,59,60,61,74,77,80,81,85,87,89,91,1I,2A,2B,2C,2G,2H,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2X,2Y,2Z,3B,3C,4C,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5E,5J,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A53,A54,A55,A56,A59,A6,A68,A69,A7,A70,A71,A73,A74,A75,A76,A8,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,A99,AA,AB,ACR,ACT,AD,AE,AH,AI,AK,AL,AMH,AMP,ANN,APZ,AQ,AS,ASM,ASU,ATM,AWG,AY,AZ,B1,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B30,B31,B32,B33,B34,B35,B4,B41,B42,B43,B44,B45,B46,B47,B48,B49,B50,B52,B53,B54,B55,B56,B57,B58,B59,B60,B61,B62,B63,B64,B66,B67,B68,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B80,B81,B82,B83,B84,B85,B86,B87,B88,B89,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BFT,BHP,BIL,BLD,BLL,BP,BPM,BQL,BTU,BUA,BUI,C0,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C37,C38,C39,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C74,C75,C76,C78,C79,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C99,CCT,CDL,CEL,CEN,CG,CGM,CKG,CLF,CLT,CMK,CMQ,CMT,CNP,CNT,COU,CTG,CTM,CTN,CUR,CWA,CWI,D03,D04,D1,D10,D11,D12,D13,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D29,D30,D31,D32,D33,D34,D36,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D65,D68,D69,D73,D74,D77,D78,D80,D81,D82,D83,D85,D86,D87,D88,D89,D91,D93,D94,D95,DAA,DAD,DAY,DB,DBM,DBW,DD,DEC,DG,DJ,DLT,DMA,DMK,DMO,DMQ,DMT,DN,DPC,DPR,DPT,DRA,DRI,DRL,DT,DTN,DWT,DZN,DZP,E01,E07,E08,E09,E10,E12,E14,E15,E16,E17,E18,E19,E20,E21,E22,E23,E25,E27,E28,E30,E31,E32,E33,E34,E35,E36,E37,E38,E39,E4,E40,E41,E42,E43,E44,E45,E46,E47,E48,E49,E50,E51,E52,E53,E54,E55,E56,E57,E58,E59,E60,E61,E62,E63,E64,E65,E66,E67,E68,E69,E70,E71,E72,E73,E74,E75,E76,E77,E78,E79,E80,E81,E82,E83,E84,E85,E86,E87,E88,E89,E90,E91,E92,E93,E94,E95,E96,E97,E98,E99,EA,EB,EQ,F01,F02,F03,F04,F05,F06,F07,F08,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56,F57,F58,F59,F60,F61,F62,F63,F64,F65,F66,F67,F68,F69,F70,F71,F72,F73,F74,F75,F76,F77,F78,F79,F80,F81,F82,F83,F84,F85,F86,F87,F88,F89,F90,F91,F92,F93,F94,F95,F96,F97,F98,F99,FAH,FAR,FBM,FC,FF,FH,FIT,FL,FNU,FOT,FP,FR,FS,FTK,FTQ,G01,G04,G05,G06,G08,G09,G10,G11,G12,G13,G14,G15,G16,G17,G18,G19,G2,G20,G21,G23,G24,G25,G26,G27,G28,G29,G3,G30,G31,G32,G33,G34,G35,G36,G37,G38,G39,G40,G41,G42,G43,G44,G45,G46,G47,G48,G49,G50,G51,G52,G53,G54,G55,G56,G57,G58,G59,G60,G61,G62,G63,G64,G65,G66,G67,G68,G69,G70,G71,G72,G73,G74,G75,G76,G77,G78,G79,G80,G81,G82,G83,G84,G85,G86,G87,G88,G89,G90,G91,G92,G93,G94,G95,G96,G97,G98,G99,GB,GBQ,GDW,GE,GF,GFI,GGR,GIA,GIC,GII,GIP,GJ,GL,GLD,GLI,GLL,GM,GO,GP,GQ,GRM,GRN,GRO,GV,GWH,H03,H04,H05,H06,H07,H08,H09,H10,H11,H12,H13,H14,H15,H16,H18,H19,H20,H21,H22,H23,H24,H25,H26,H27,H28,H29,H30,H31,H32,H33,H34,H35,H36,H37,H38,H39,H40,H41,H42,H43,H44,H45,H46,H47,H48,H49,H50,H51,H52,H53,H54,H55,H56,H57,H58,H59,H60,H61,H62,H63,H64,H65,H66,H67,H68,H69,H70,H71,H72,H73,H74,H75,H76,H77,H79,H80,H81,H82,H83,H84,H85,H87,H88,H89,H90,H91,H92,H93,H94,H95,H96,H98,H99,HA,HAD,HBA,HBX,HC,HDW,HEA,HGM,HH,HIU,HKM,HLT,HM,HMO,HMQ,HMT,HPA,HTZ,HUR,IA,IE,INH,INK,INQ,ISD,IU,IUG,IV,J10,J12,J13,J14,J15,J16,J17,J18,J19,J2,J20,J21,J22,J23,J24,J25,J26,J27,J28,J29,J30,J31,J32,J33,J34,J35,J36,J38,J39,J40,J41,J42,J43,J44,J45,J46,J47,J48,J49,J50,J51,J52,J53,J54,J55,J56,J57,J58,J59,J60,J61,J62,J63,J64,J65,J66,J67,J68,J69,J70,J71,J72,J73,J74,J75,J76,J78,J79,J81,J82,J83,J84,J85,J87,J90,J91,J92,J93,J95,J96,J97,J98,J99,JE,JK,JM,JNT,JOU,JPS,JWL,K1,K10,K11,K12,K13,K14,K15,K16,K17,K18,K19,K2,K20,K21,K22,K23,K26,K27,K28,K3,K30,K31,K32,K33,K34,K35,K36,K37,K38,K39,K40,K41,K42,K43,K45,K46,K47,K48,K49,K50,K51,K52,K53,K54,K55,K58,K59,K6,K60,K61,K62,K63,K64,K65,K66,K67,K68,K69,K70,K71,K73,K74,K75,K76,K77,K78,K79,K80,K81,K82,K83,K84,K85,K86,K87,K88,K89,K90,K91,K92,K93,K94,K95,K96,K97,K98,K99,KA,KAT,KB,KBA,KCC,KDW,KEL,KGM,KGS,KHY,KHZ,KI,KIC,KIP,KJ,KJO,KL,KLK,KLX,KMA,KMH,KMK,KMQ,KMT,KNI,KNM,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KSD,KSH,KT,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWN,KWO,KWS,KWT,KWY,KX,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L2,L20,L21,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54,L55,L56,L57,L58,L59,L60,L63,L64,L65,L66,L67,L68,L69,L70,L71,L72,L73,L74,L75,L76,L77,L78,L79,L80,L81,L82,L83,L84,L85,L86,L87,L88,L89,L90,L91,L92,L93,L94,L95,L96,L98,L99,LA,LAC,LBR,LBT,LD,LEF,LF,LH,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUB,LUM,LUX,LY,M1,M10,M11,M12,M13,M14,M15,M16,M17,M18,M19,M20,M21,M22,M23,M24,M25,M26,M27,M29,M30,M31,M32,M33,M34,M35,M36,M37,M38,M39,M4,M40,M41,M42,M43,M44,M45,M46,M47,M48,M49,M5,M50,M51,M52,M53,M55,M56,M57,M58,M59,M60,M61,M62,M63,M64,M65,M66,M67,M68,M69,M7,M70,M71,M72,M73,M74,M75,M76,M77,M78,M79,M80,M81,M82,M83,M84,M85,M86,M87,M88,M89,M9,M90,M91,M92,M93,M94,M95,M96,M97,M98,M99,MAH,MAL,MAM,MAR,MAW,MBE,MBF,MBR,MC,MCU,MD,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MKD,MKM,MKW,MLD,MLT,MMK,MMQ,MMT,MND,MNJ,MON,MPA,MQD,MQH,MQM,MQS,MQW,MRD,MRM,MRW,MSK,MTK,MTQ,MTR,MTS,MTZ,MVA,MWH,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N3,N30,N31,N32,N33,N34,N35,N36,N37,N38,N39,N40,N41,N42,N43,N44,N45,N46,N47,N48,N49,N50,N51,N52,N53,N54,N55,N56,N57,N58,N59,N60,N61,N62,N63,N64,N65,N66,N67,N68,N69,N70,N71,N72,N73,N74,N75,N76,N77,N78,N79,N80,N81,N82,N83,N84,N85,N86,N87,N88,N89,N90,N91,N92,N93,N94,N95,N96,N97,N98,N99,NA,NAR,NCL,NEW,NF,NIL,NIU,NL,NM3,NMI,NMP,NPT,NT,NTU,NU,NX,OA,ODE,ODG,ODK,ODM,OHM,ON,ONZ,OPM,OT,OZA,OZI,P1,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P2,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P5,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P60,P61,P62,P63,P64,P65,P66,P67,P68,P69,P70,P71,P72,P73,P74,P75,P76,P77,P78,P79,P80,P81,P82,P83,P84,P85,P86,P87,P88,P89,P90,P91,P92,P93,P94,P95,P96,P97,P98,P99,PAL,PD,PFL,PGL,PI,PLA,PO,PQ,PR,PS,PTD,PTI,PTL,PTN,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29,Q30,Q31,Q32,Q33,Q34,Q35,Q36,Q37,Q38,Q39,Q40,Q41,Q42,Q3,QA,QAN,QB,QR,QTD,QTI,QTL,QTR,R1,R9,RH,RM,ROM,RP,RPM,RPS,RT,S3,S4,SAN,SCO,SCR,SEC,SET,SG,SIE,SM3,SMI,SQ,SQR,SR,STC,STI,STK,STL,STN,STW,SW,SX,SYR,T0,T3,TAH,TAN,TI,TIC,TIP,TKM,TMS,TNE,TP,TPI,TPR,TQD,TRL,TST,TTS,U1,U2,UB,UC,VA,VLT,VP,W2,WA,WB,WCD,WE,WEB,WEE,WG,WHR,WM,WSD,WTT,X1,YDK,YDQ,YRD,Z11,Z9,ZP,ZZ,X1A,X1B,X1D,X1F,X1G,X1W,X2C,X3A,X3H,X43,X44,X4A,X4B,X4C,X4D,X4F,X4G,X4H,X5H,X5L,X5M,X6H,X6P,X7A,X7B,X8A,X8B,X8C,XAA,XAB,XAC,XAD,XAE,XAF,XAG,XAH,XAI,XAJ,XAL,XAM,XAP,XAT,XAV,XB4,XBA,XBB,XBC,XBD,XBE,XBF,XBG,XBH,XBI,XBJ,XBK,XBL,XBM,XBN,XBO,XBP,XBQ,XBR,XBS,XBT,XBU,XBV,XBW,XBX,XBY,XBZ,XCA,XCB,XCC,XCD,XCE,XCF,XCG,XCH,XCI,XCJ,XCK,XCL,XCM,XCN,XCO,XCP,XCQ,XCR,XCS,XCT,XCU,XCV,XCW,XCX,XCY,XCZ,XDA,XDB,XDC,XDG,XDH,XDI,XDJ,XDK,XDL,XDM,XDN,XDP,XDR,XDS,XDT,XDU,XDV,XDW,XDX,XDY,XEC,XED,XEE,XEF,XEG,XEH,XEI,XEN,XFB,XFC,XFD,XFE,XFI,XFL,XFO,XFP,XFR,XFT,XFW,XFX,XGB,XGI,XGL,XGR,XGU,XGY,XGZ,XHA,XHB,XHC,XHG,XHN,XHR,XIA,XIB,XIC,XID,XIE,XIF,XIG,XIH,XIK,XIL,XIN,XIZ,XJB,XJC,XJG,XJR,XJT,XJY,XKG,XKI,XLE,XLG,XLT,XLU,XLV,XLZ,XMA,XMB,XMC,XME,XMR,XMS,XMT,XMW,XMX,XNA,XNE,XNF,XNG,XNS,XNT,XNU,XNV,XO1,XO2,XO3,XO4,XO5,XO6,XO7,XO8,XO9,XOA,XOB,XOC,XOD,XOE,XOF,XOG,XOH,XOI,XOK,XOJ,XOL,XOM,XON,XOP,XOQ,XOR,XOS,XOV,XOW,XOT,XOU,XOX,XOY,XOZ,XP1,XP2,XP3,XP4,XPA,XPB,XPC,XPD,XPE,XPF,XPG,XPH,XPI,XPJ,XPK,XPL,XPN,XPO,XPP,XPR,XPT,XPU,XPV,XPX,XPY,XPZ,XQA,XQB,XQC,XQD,XQF,XQG,XQH,XQJ,XQK,XQL,XQM,XQN,XQP,XQQ,XQR,XQS,XRD,XRG,XRJ,XRK,XRL,XRO,XRT,XRZ,XSA,XSB,XSC,XSD,XSE,XSH,XSI,XSK,XSL,XSM,XSO,XSP,XSS,XST,XSU,XSV,XSW,XSX,XSY,XSZ,XT1,XTB,XTC,XTD,XTE,XTG,XTI,XTK,XTL,XTN,XTO,XTR,XTS,XTT,XTU,XTV,XTW,XTY,XTZ,XUC,XUN,XVA,XVG,XVI,XVK,XVL,XVO,XVP,XVQ,XVN,XVR,XVS,XVY,XWA,XWB,XWC,XWD,XWF,XWG,XWH,XWJ,XWK,XWL,XWM,XWN,XWP,XWQ,XWR,XWS,XWT,XWU,XWV,XWW,XWX,XWY,XWZ,XXA,XXB,XXC,XXD,XXF,XXG,XXH,XXJ,XXK,XYA,XYB,XYC,XYD,XYF,XYG,XYH,XYJ,XYK,XYL,XYM,XYN,XYP,XYQ,XYR,XYS,XYT,XYV,XYW,XYX,XYY,XYZ,XZA,XZB,XZC,XZD,XZF,XZG,XZH,XZJ,XZK,XZL,XZM,XZN,XZP,XZQ,XZR,XZS,XZT,XZU,XZV,XZW,XZX,XZY,XZZ', ',')" />
  </pattern>
</schema>
