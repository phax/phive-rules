<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <title>PINT Oman E-Invoice Validation Rules (IBR-OM)</title>
    <p>

        * Author: Susheel Kumar (OpenPeppol)
        * Version: 1.0.0
        * Authority: Tax Authority Oman
        * Scope: Validation of VAT-compliant e-invoices under Oman regulations.
        * Notes: Includes business rules, tax validations, and calculation consistency checks.

        *** This Schematron has been designed to provide enhanced guidance for each validation error. 
        *** In addition to reporting the failure, it includes diagnostic information that helps explain the cause of the error and supports users in resolving it effectively.

        ======*****************************************************************************======

        Transaction Type: '<value-of select="$txnType"/>': '<value-of select="$txnTypeLabel"/>'

        ======*****************************************************************************======
    </p>
    <p>

        Change log:

    </p>
   <xsl:function name="u:to-decimal" as="xs:decimal">
        <xsl:param name="val"/>
        <xsl:sequence select="if (normalize-space(string($val)) castable as xs:decimal)                              then xs:decimal(normalize-space(string($val)))                              else 0.0"/>
    </xsl:function>

    <xsl:function name="u:slack" as="xs:boolean">
        <xsl:param name="exp" as="xs:decimal?"/>
        <xsl:param name="val" as="xs:decimal?"/>
        <xsl:param name="slack" as="xs:decimal"/>
        <xsl:variable name="actualExp" select="if (empty($exp)) then 0.0 else $exp"/>
        <xsl:variable name="actualVal" select="if (empty($val)) then 0.0 else $val"/>
        <xsl:sequence select="abs($actualExp - $actualVal) &lt;= $slack"/>
    </xsl:function>
    
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
    <ns prefix="u" uri="utils"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    
    
    
     
    <let name="doc" value="/*[local-name()='Invoice' or local-name()='CreditNote']"/>
    <let name="lines" value="$doc/cac:InvoiceLine | $doc/cac:CreditNoteLine"/>
    <let name="allowances" value="$doc/cac:AllowanceCharge[cbc:ChargeIndicator='false']"/>
    <let name="charges" value="$doc/cac:AllowanceCharge[cbc:ChargeIndicator='true']"/>
    <let name="invoiceType" value="normalize-space(($doc/cbc:InvoiceTypeCode | $doc/cbc:CreditNoteTypeCode)[1])"/>
    <let name="txnType" value="normalize-space(($doc/cbc:InvoiceTypeCode/@name | $doc/cbc:CreditNoteTypeCode/@name)[1])"/>
    <let name="isValidBitString" value="matches($txnType, '^[01]{20}$')"/>
    <let name="txnSafe" value="if ($isValidBitString) then $txnType else '00000000000000000000'"/>
    <let name="invoiceCurrency" value="normalize-space($doc/cbc:DocumentCurrencyCode)"/>
    <let name="taxCurrency" value="normalize-space($doc/cbc:TaxCurrencyCode)"/>
    <let name="exchangeRate" value="             if ($doc/cac:TaxExchangeRate/cbc:CalculationRate castable as xs:decimal)             then xs:decimal($doc/cac:TaxExchangeRate/cbc:CalculationRate)             else ()"/>
    
        
        
    <let name="isFullTax" value="substring($txnSafe,1,1)='1'"/>
    <let name="isSimplified" value="substring($txnSafe,2,1)='1'"/>
    <let name="isSelfBilled" value="substring($txnSafe,3,1)='1'"/>
    <let name="isThirdParty" value="substring($txnSafe,4,1)='1'"/>
    <let name="isSummary" value="substring($txnSafe,5,1)='1'"/>
    <let name="isContinuous" value="substring($txnSafe,6,1)='1'"/>
    <let name="isExport" value="substring($txnSafe,7,1)='1'"/>
    <let name="isDeemed" value="substring($txnSafe,8,1)='1'"/>
    <let name="isImportRCM" value="substring($txnSafe,9,1)='1'"/>
    <let name="isProfitMargin" value="substring($txnSafe,10,1)='1'"/>
    <let name="isProfitMarginSelf" value="substring($txnSafe,11,1)='1'"/>
    <let name="isEcommerce" value="substring($txnSafe,12,1)='1'"/>
    <let name="isImportGoods" value="substring($txnSafe,13,1)='1'"/>
    <let name="isSpecialZone" value="substring($txnSafe,14,1)='1'"/>
    <let name="isPrepayment" value="substring($txnSafe,15,1)='1'"/>

    <let name="baseType" value="if ($isFullTax) then 'Full Invoice' else if ($isSimplified) then 'Simplified Invoice' else 'Unknown Type'"/>

    <let name="subTypes" value="         string-join((             if ($isSelfBilled) then 'Self-Billed' else (),             if ($isThirdParty) then 'Third Party' else (),             if ($isSummary) then 'Summary' else (),             if ($isContinuous) then 'Continuous Supply' else (),             if ($isExport) then 'Export' else (),             if ($isDeemed) then 'Deemed Supply' else (),             if ($isImportRCM) then 'Import Reverse Charge' else (),             if ($isProfitMargin) then 'Profit Margin' else (),             if ($isProfitMarginSelf) then 'Profit Margin Self-Invoice' else (),             if ($isEcommerce) then 'E-Commerce' else (),             if ($isImportGoods) then 'Import of Goods' else (),             if ($isSpecialZone) then 'Special Zone' else (),             if ($isPrepayment) then 'Prepayment' else ()         ), ', ')     "/>

    <let name="txnTypeLabel" value="concat($baseType, if (normalize-space($subTypes) != '') then concat(' (', $subTypes, ')') else '')"/>
    <let name="invalidTxnCombo" value="             ($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods))             or ($isSummary and ($isContinuous or $isExport or $isProfitMargin))             or ($isExport and ($isSelfBilled or $isSummary or $isImportRCM))         "/>

    <let name="invalidTxnReason" value="             if ($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods))             then 'Self-Billed cannot be combined with Third Party / Export / Import RCM / Profit Margin / Import of Goods'                          else if ($isSummary and ($isContinuous or $isExport or $isProfitMargin))             then 'Summary cannot be combined with Continuous Supply / Export / Profit Margin'                          else if ($isExport and ($isSelfBilled or $isSummary or $isImportRCM))             then 'Export cannot be combined with Self-Billed / Summary / Import RCM'                          else ''         "/>
    <phase id="AlignedPhase">
        <active pattern="Aligned-om-rules"/>
    </phase>
    <phase id="AlignedPhaseCode">
        <active pattern="AlignedCodelists"/>
    </phase>
    <pattern id="Aligned-om-rules">

        <rule context="ubl:Invoice | cn:CreditNote">
            <report test="true()" role="information">
                DEBUG INFO:
                - Root Element Found: <value-of select="local-name($doc)"/>
                
                [TECHNICAL DATA]
                - Status: Diagnostic Log Generated

                    - Transaction ID: [<value-of select="cbc:ID"/>]
                    - Type Code: [<value-of select="$txnType"/>]
                    - Invoice Type Code: [<value-of select="$invoiceType"/>]
                    - Line Count: <value-of select="count($lines)"/>
                    - Invoice Currency: [<value-of select="$invoiceCurrency"/>]
                    - Tax Currency: [<value-of select="$taxCurrency"/>]
                    - Active SubTypes: [<value-of select="$subTypes"/>]
                    - Invalid Combination: [<value-of select="$invalidTxnCombo"/>]
                    - Reason: [<value-of select="$invalidTxnReason"/>]
            </report>
            
            
            

            <let name="customizationID" value="normalize-space(cbc:CustomizationID)"/>
            <let name="profileID" value="normalize-space(cbc:ProfileID)"/>

            <assert id="ALIGNED-IBRP-000-OM" test="$txnType != ''" flag="fatal" diagnostics="d-000">[ALIGNED-IBRP-000-OM] - Transaction type (BTOM-001) must be present.</assert>

            
            <assert id="ALIGNED-IBRP-001-OM" flag="fatal" test="starts-with($customizationID, 'urn:peppol:pint:billing-1@om-1')" diagnostics="d-001">[ALIGNED-IBRP-001-OM] - Specification identifier (IBT-024) MUST start with the value 'urn:peppol:pint:billing-1@om-1'.</assert>

            
            <assert id="ALIGNED-IBRP-002-OM" flag="fatal" test="starts-with($profileID, 'urn:peppol:pint:billing')" diagnostics="d-002">[ALIGNED-IBRP-002-OM] - Business process (IBT-023) must follow the expected format 'urn:peppol:pint:billing'.</assert>

            
            <assert id="ALIGNED-IBRP-003-OM" flag="fatal" test="not($taxCurrency != '') or $taxCurrency = 'OMR'" diagnostics="d-003">[ALIGNED-IBRP-003-OM] - VAT accounting currency (IBT-006) must be 'OMR' for VAT reporting.</assert>

            
            <assert id="ALIGNED-IBRP-016-OM" flag="fatal" test="exists(cbc:IssueTime)" diagnostics="d-016">[ALIGNED-IBRP-016-OM] - An invoice must have an Invoice Issue Time (IBT-168).</assert>

            
            <assert id="ALIGNED-IBRP-028-OM" flag="fatal" test="not($invoiceType = ('381','383','261'))                       or cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" diagnostics="d-028">[ALIGNED-IBRP-028-OM] - Preceding invoice reference (IBG-03) MUST be provided when invoice type code (IBT-003) is 'Credit note' ('381') or 'Debit note' ('383') or 'Self billed credit note' ('261').</assert>

            <assert id="ALIGNED-IBRP-E-01-OM" flag="fatal" test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='E'] or                          $allowances[cac:TaxCategory/cbc:ID='E'] or                          $charges[cac:TaxCategory/cbc:ID='E']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) &lt;= 1)                     )" diagnostics="d-E-01">[ALIGNED-IBRP-E-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "E" MUST contain exactly one VAT breakdown (IBG-23) with the VAT category code (IBT-118) equal to "E" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "E".</assert>
            
            
            
            

            <assert id="ALIGNED-IBRP-O-01-OM" flag="fatal" test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='O'] or                          $allowances[cac:TaxCategory/cbc:ID='O'] or                          $charges[cac:TaxCategory/cbc:ID='O']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) &lt;= 1)                     )" diagnostics="d-O-01">[ALIGNED-IBRP-O-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "O" MUST contain exactly one VAT breakdown group (IBG-23) with the VAT category code (IBT-118) equal to "O" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "O".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-S-01-OM" flag="fatal" test="every $rate in distinct-values(($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='S']/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent,                                               $allowances[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent,                                               $charges[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent))               satisfies count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='S' and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)]) = 1" diagnostics="d-S-01">[ALIGNED-IBRP-S-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "S" MUST contain in the VAT breakdown (IBG-23) at least one VAT category code (IBT-118) equal with "S".</assert>

            <assert id="ALIGNED-IBRP-S-05-OM" flag="fatal" test="not($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S']) or                          (every $line in $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S'] satisfies                          ($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal and                          xs:decimal($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = 5))" diagnostics="d-S-05">[ALIGNED-IBRP-S-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "S" the Invoiced item VAT rate (IBT-152) MUST be 5.</assert>

            
            <assert id="IBR-001-OM" flag="fatal" test="string-length($txnType) = 20 and matches($txnType, '^[01]{20}$')" diagnostics="d-IBR-001">[IBR-001-OM] - Invoice transaction type (BTOM-001) must be a 20-character binary string.</assert>

            
            <assert id="IBR-002-OM" flag="fatal" test="matches(normalize-space(cbc:UUID),'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')" diagnostics="d-IBR-002">[IBR-002-OM] - Invoice UUID (BTOM-002) must contain only letters, digits, and dashes.</assert>

            
            <assert id="IBR-004-OM" flag="fatal" test="$invoiceCurrency = 'OMR' or exists($exchangeRate)" diagnostics="d-IBR-004">[IBR-004-OM] - Currency exchange rate (BTOM-003) MUST be provided when the Invoice currency code (IBT-005) is not equal to 'OMR'.</assert>

            
            <assert id="IBR-005-OM" flag="fatal" test="not($taxCurrency='OMR' and $invoiceCurrency!='OMR')                         or (exists($exchangeRate)                             and $exchangeRate = round($exchangeRate * 10000000) div 10000000)" diagnostics="d-IBR-005">[IBR-005-OM] - Currency exchange rate (BTOM-003) should contain the values till maximum of 7 decimal places when the VAT accounting currency (IBT-006) is set to OMR and the invoice currency code (IBT-005) differs from OMR.</assert>

            
            <assert id="IBR-006-OM" flag="fatal" test="$isImportGoods or $isImportRCM or $isProfitMarginSelf                   or cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID" diagnostics="d-IBR-006">[IBR-006-OM] - Seller tax identifier (IBT-031) MUST be mandatory in all cases except when Invoice transaction type (BTOM-001) is an invoice for import of goods (XXXXXXXXXXXX1XXXXXXX), import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX).</assert>

            
            <assert id="IBR-007-OM" flag="fatal" test="not($isImportGoods or $isImportRCM or $isProfitMarginSelf or $isSpecialZone) or cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" diagnostics="d-IBR-007">[IBR-007-OM] - Seller identifier (IBT-029) Scheme identifier (IBT-029-1) must be provided when Invoice transaction type (BTOM-001) is an invoice for import of goods (XXXXXXXXXXXX1XXXXXXX) or import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX) or Special zone supplies (XXXXXXXXXXXXX1XXXXXX).</assert>

            
            <assert id="IBR-010-OM" flag="fatal" test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone                    and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" diagnostics="d-IBR-010">[IBR-010-OM] - In Seller postal address (IBG-05), Seller address line 1 (IBT-035), Seller address line 2 (IBT-036), Seller address line 3 (IBT-162) Seller city (IBT-037) and Seller postal code (IBT-038) must be provided.</assert>

            
            
            
            <assert id="IBR-011-OM" flag="fatal" test="cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone" diagnostics="d-IBR-011">[IBR-011-OM] - In Seller Contact (IBG-06), Seller contact telephone number (IBT-042) must be provided.</assert>

            
            
            
            <assert id="IBR-012-OM" flag="fatal" test="not($isExport and $lines//cbc:TaxExemptionReasonCode = 'VATZR-OM-09')                   or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode != 'OM'" diagnostics="d-IBR-012">[IBR-012-OM] - Deliver to country code (IBT-080) must not be 'OM' if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and atleast one VAT exemption reason code (IBT-121) is 'Export of service (VATZR-OM-09)'.</assert>

            
            
            
            <assert id="IBR-013-OM" flag="fatal" test="not($isExport and $lines//cbc:TaxExemptionReasonCode ='VATZR-OM-12')                          or (exists($doc/cac:AdditionalDocumentReference[not(cbc:DocumentTypeCode = '130')]/cbc:ID)                              and exists($doc/cac:AdditionalDocumentReference[not(cbc:DocumentTypeCode = '130')]/cbc:UUID))" diagnostics="d-IBR-013">[IBR-013-OM] - Supporting document reference (IBT-122) and Supporting document UUID (BTOM-023) must be provided if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and atleast one VAT exemption reason code (IBT-121) is 'Re-export of goods (VATZR-OM-12)'.</assert>

            
            
            
            <assert id="IBR-014-OM" flag="fatal" test="not($isExport)                   or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode" diagnostics="d-IBR-014">[IBR-014-OM] - Deliver to country code (ibt-080) must be provided if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-015-OM" flag="fatal" test="                 not($isThirdParty)                 or (                     count(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) = 1                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyName/cbc:Name                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:StreetName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:AdditionalStreetName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:AddressLine/cbc:Line                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:CityName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:PostalZone                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)" diagnostics="d-IBR-015">[IBR-015-OM] - Third Party Name (BTOM-005), Third Party VATIN (BTOM-006), VAT Scheme Code (BTOM-06-1), Third Party Address Line 1 (BTOM-007), Third Party Address Line 2 (BTOM-008), Third Party Address Line 3 (BTOM-009), Third party city (BTOM-010), Third party postal code (BTOM-011) and Third Party Country Code (BTOM-13) must be provided when Invoice transaction type (BTOM-001) is Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) and MUST occur only once.</assert>
            
            
            
            <assert id="IBR-016-OM" flag="fatal" test="not($isFullTax or $isThirdParty or $isSummary or $isContinuous or $isExport or $isProfitMargin or $isEcommerce)                   or (cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                       or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)" diagnostics="d-IBR-016">[IBR-016-OM] - Either Buyer identifier (IBT-046) or Buyer VATIN (IBT-048) MUST be present when the Invoice transaction type is (BTOM-001) a Full tax invoice (1XXXXXXXXXXXXXXXXXXX) and a Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin (XXXXXXXXX1XXXXXXXXXX) invoice or E-commerce supplies (XXXXXXXXXXX1XXXXXXXX).</assert>

            
            
            
            <assert id="IBR-017-OM" flag="fatal" test="not($isSelfBilled or $isImportRCM or $isProfitMargin or $isImportGoods)                   or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID" diagnostics="d-IBR-017">[IBR-017-OM] - Buyer VATIN (IBT-048) MUST be present when the Invoice transaction type (BTOM-001) is a Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice ( 00000000001000000000) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-019-OM" flag="fatal" test="not($isFullTax or $isThirdParty or $isSelfBilled or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods or $isSpecialZone or $isSummary)                   or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName                        and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName                        and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)" diagnostics="d-IBR-019">[IBR-019-OM] - Buyer address line 1 (IBT-050), Buyer address line 2 (IBT-051), Buyer address line 3 (IBT-163), Buyer city (IBT-052) and Buyer post code (IBT-053) MUST be present when the Invoice transaction type (BTOM-001) is a Full tax invoice (1XXXXXXXXXXXXXXXXXXX) AND/OR Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), or Profit margin (XXXXXXXXX1XXXXXXXXXX) invoice or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Special zone supplies (XXXXXXXXXXXXX1XXXXXX) or summary invoice (XXXX1XXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-020-OM" flag="fatal" test="not($isSelfBilled or $isImportRCM or $isProfitMargin or $isImportGoods)                   or cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'" diagnostics="d-IBR-020">[IBR-020-OM] - Buyer country code (IBT-055) MUST be 'OM' when the Invoice transaction type (BTOM-001) is a Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice ( 00000000001000000000) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-023-OM" flag="fatal" test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261')                   or cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode" diagnostics="d-IBR-023">[IBR-023-OM] - Where the Invoice type code [IBT-003] is '381' or '383' or '261', Credit Note or Debit Note reason code (BTOM-032) MUST be provided.</assert>

            
            
            
            <assert id="IBR-032-OM" flag="fatal" test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261')                   or (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID                       and cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate                       and cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)" diagnostics="d-IBR-032">[IBR-032-OM] - If Invoice type code (IBT-003) is '381' or '383' or '261', Preceding Invoice reference (IBT-025), and Preceding Invoice issue date (IBT-026), and Preceding invoice UUID (BTOM-031) MUST be present.</assert>

            
            
            
            <assert id="IBR-034-OM" flag="fatal" test="$invoiceCurrency = 'OMR' or ($taxCurrency != '')" diagnostics="d-IBR-034">[IBR-034-OM] - VAT accounting currency (IBT-006) must be provided if invoice currency code (IBT-005) is not equal to 'OMR'.</assert>

            
            
            
            <assert id="IBR-036-OM" flag="fatal" test="not($isSummary)                   or (substring(cac:InvoicePeriod/cbc:StartDate,1,7)                       = substring(cac:InvoicePeriod/cbc:EndDate,1,7))" diagnostics="d-IBR-036">[IBR-036-OM] - Invoicing period Start date (IBT-073) and Invoicing period end date (IBT-074) provided must belong to the same calendar month where Invoice transaction type code (BTOM-001) is a summary invoice (XXXX1XXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-037-OM" flag="fatal" test="not($isSummary or $isContinuous)                   or (cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate)" diagnostics="d-IBR-037">[IBR-037-OM] - Invoicing period start date (IBT-073) and the Invoicing period end date (IBT-074) must be provided where Invoice transaction type code (BTOM-001) is a summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-040-OM" flag="fatal" test="not($isEcommerce)                   or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode                        and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line)" diagnostics="d-IBR-040">[IBR-040-OM] - Deliver to address line 1 - Postal code (IBT-075), Deliver to address line 2 - Postal code area (ibt-076), Deliver to address line 3 - Area (IBT-165), Deliver to city (IBT-077), Deliver to post code - PO Box(IBT-078), Deliver to country code (IBT-080) MUST be present when the Invoice transaction type (BTOM-001) is E-commerce supplies (XXXXXXXXXXX1XXXXXXXX).</assert>

            
            <assert id="IBR-043-OM" flag="fatal" test="substring($txnType,1,1)='1' or substring($txnType,2,1)='1'" diagnostics="d-IBR-043">[IBR-043-OM] - Either the first or second position of Invoice Transaction type (BTOM-001) must always be 1.</assert>

            
            <assert id="IBR-058-OM" flag="fatal" test="not($isPrepayment)                         or                         (                             exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount)                             and                             exists(cac:OriginatorDocumentReference/cbc:ID)                             and                             exists(cac:OriginatorDocumentReference/cbc:UUID)                         )" diagnostics="d-IBR-058">[IBR-058-OM] - Prepayment invoice number (BTOM-027) and Prepayment invoice UUID (BTOM-014) must be provided if Paid amount (IBT-180) is present.</assert>

            
            <assert id="IBR-059-OM" flag="fatal" test="not($exchangeRate)                   or (cac:TaxExchangeRate/cbc:SourceCurrencyCode=$invoiceCurrency                       and cac:TaxExchangeRate/cbc:TargetCurrencyCode=$taxCurrency)" diagnostics="d-IBR-059">[IBR-059-OM] - The source currency must be designated as the invoice currency code (IBT-005), and the target currency must be specified as the tax accounting currency (IBT-006), provided that the currency exchange rate (BTOM-003) is available.</assert>

            
            <assert id="IBR-065-OM" flag="fatal" test="not($invoiceCurrency != 'OMR' and $taxCurrency = 'OMR')                         or (                             $exchangeRate castable as xs:decimal and                             u:slack(                                 xs:decimal((cac:TaxTotal[cbc:TaxAmount/@currencyID = $taxCurrency]/cbc:TaxAmount)[1]),                                 xs:decimal($exchangeRate * (cac:TaxTotal[cbc:TaxAmount/@currencyID = $invoiceCurrency]/cbc:TaxAmount)[1]),                                 0.02                             )                         )" diagnostics="d-IBR-065">[IBR-065-OM] - When Invoice currency code (IBT-005) is not equal to 'OMR' and Tax accounting currency [IBT-006] is 'OMR', then the value in Invoice total VAT amount in tax accounting currency [IBT-111] MUST be provided and must be Exchange rate (BTOM-003) multiplied by Invoice total tax amount (IBT-110).</assert>

            <assert id="IBR-066-OM" flag="fatal" test="                 not($invoiceCurrency != 'OMR'                     and $doc//cac:TaxCategory/cbc:ID = 'S')                 or                 //cac:TaxTotal/cac:TaxSubtotal[                     cac:TaxCategory/cbc:ID = 'S'                     and cac:TaxAmount                     and cac:TaxCategory/cbc:Percent                 ]                 " diagnostics="d-IBR-066">[IBR-066-OM] - TAX category tax amount in accounting currency (IBT-190), TAX category code for tax category tax amount in accounting currency (IBT-192) and TAX category rate for tax category tax amount in accounting currency (IBT-193) must be provided when Invoice currency code [IBT-005] is not equal to 'OMR' and atleast one TAX category code (IBT-118) is equal to 'S'.</assert>
            
            
            <assert id="IBR-082-OM" flag="fatal" test="not($isProfitMargin)                         or (                             cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription castable as xs:decimal                             and u:slack(                                 xs:decimal(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription),                                 xs:decimal(sum($lines/cac:ItemPriceExtension/cbc:Amount/xs:decimal(.))),                                 0.02                             )                         )" diagnostics="d-IBR-082">[IBR-082-OM] - When Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) , then Total Amount Due (BTOM-020), should be provided and is mandatory and must be the sum of Total amount including VAT (BTOM-017).</assert>

            <assert id="IBR-085-OM" flag="fatal" test="                 not($isImportGoods)                 or                 (                     cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate                     and cac:Delivery/cac:Shipment/cbc:ID                     and cac:Delivery/cac:DeliveryTerms/cbc:ID                 )                 " diagnostics="d-IBR-085">[IBR-085-OM] - If invoice transaction type (BTOM-001) is 'Import of Goods' (XXXXXXXXXXXX1XXXXXXX), import details (IBG-33-OM) MUST be present and must contain, Import date (BTOM-020), Custom Declaration number (BTOM-021) and Incoterms (BTOM-022).</assert>
            
            <assert id="IBR-087-OM" flag="fatal" test="not($isProfitMargin)                 or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'" diagnostics="d-IBR-087">[IBR-087-OM] - In case Invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice' (XXXXXXXXXX1XXXXXXXXX), Seller Country Code (IBT-040) MUST be 'OM'.</assert>
            
            
            
            <let name="vatTaxTotals" value="cac:TaxTotal"/>

            <assert id="IBR-136-OM" flag="fatal" test="not($taxCurrency != '') or                          (some $total in cac:TaxTotal satisfies                              ($total/cbc:TaxAmount/@currencyID = $taxCurrency and                              (every $sub in $total/cac:TaxSubtotal/cbc:TaxAmount satisfies $sub/@currencyID = $taxCurrency))                         )" diagnostics="d-IBR-136">[IBR-136-OM] - CurrencyID must match VAT accounting currency (IBT-006) for VAT accounting amounts.</assert>

            
            
            
            <assert id="IBR-137-OM" flag="fatal" test="                 not(                     //*[                         self::cbc:TaxExclusiveAmount or                         self::cbc:TaxInclusiveAmount or                         self::cbc:AllowanceTotalAmount or                         self::cbc:ChargeTotalAmount or                         self::cbc:PrepaidAmount or                         self::cbc:PayableAmount or                         self::cbc:Amount or                         self::cbc:PriceAmount or                         self::cbc:BaseAmount or                         self::cbc:Quantity or                         self::cbc:BaseQuantity or                         self::cbc:CreditedQuantity or                          self::cbc:TaxAmount or                          self::cbc:LineExtensionAmount                     ]                     [                         normalize-space(.) != ''                          and . castable as xs:decimal                          and xs:decimal(.) &lt; 0                     ]                 )             " diagnostics="d-IBR-137">[IBR-137-OM] - All the invoice amounts and quantities must be zero or positive.</assert>

            
            
            
            <assert id="IBR-138-OM" flag="fatal" test="not($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-138">[IBR-138-OM] - Invoice transaction type (BTOM-001) cannot be Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-139-OM" flag="fatal" test="not($isThirdParty and $isSelfBilled)" diagnostics="d-IBR-139">[IBR-139-OM] - Invoice transaction type (BTOM-001) cannot be Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-140-OM" flag="fatal" test="not($isSummary and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-140">[IBR-140-OM] - Invoice transaction type (BTOM-001) cannot be Summary invoice (XXXX1XXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-141-OM" flag="fatal" test="not($isContinuous and ($isSummary or $isDeemed or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-141">[IBR-141-OM] - Invoice transaction type (BTOM-001) cannot be Continuous supply (XXXXX1XXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-142-OM" flag="fatal" test="not($isExport and ($isSelfBilled or $isSummary or $isDeemed or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-142">[IBR-142-OM] - Invoice transaction type (BTOM-001) cannot be Export Invoice (XXXXXX1XXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-143-OM" flag="fatal" test="not($isDeemed and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf))" diagnostics="d-IBR-143">[IBR-143-OM] - Invoice transaction type (BTOM-001) cannot be Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-144-OM" flag="fatal" test="not($isImportRCM and ($isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSelfBilled))" diagnostics="d-IBR-144">[IBR-144-OM] - Invoice transaction type (BTOM-001) cannot be Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-145-OM" flag="fatal" test="not($isProfitMargin and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isImportGoods or $isSelfBilled))" diagnostics="d-IBR-145">[IBR-145-OM] - Invoice transaction type (BTOM-001) cannot be Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-146-OM" flag="fatal" test="not($isProfitMarginSelf and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isProfitMargin or $isImportGoods or $isSelfBilled))" diagnostics="d-IBR-146">[IBR-146-OM] - Invoice transaction type (BTOM-001) cannot be Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) if Invoice transaction type (BTOM-001) Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-147-OM" flag="fatal" test="not($isImportGoods and ($isSummary or $isContinuous or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isEcommerce or $isSelfBilled))" diagnostics="d-IBR-147">[IBR-147-OM] - Invoice transaction type (BTOM-001) cannot be Import of Goods (XXXXXXXXXXXX1XXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or E-commerce supplies (XXXXXXXXXXX1XXXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-148-OM" flag="fatal" test="not($isEcommerce and $isProfitMarginSelf)" diagnostics="d-IBR-148">[IBR-148-OM] - Invoice transaction type (BTOM-001) cannot be E-commerce supplies (XXXXXXXXXXX1XXXXXXXX) if Invoice transaction type (BTOM-001) is Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-149-OM" flag="fatal" test="not($isSimplified and ($isSelfBilled or $isThirdParty or $isSummary or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSpecialZone))" diagnostics="d-IBR-149">[IBR-149-OM] - Invoice transaction type (BTOM-001) cannot be Simplified Tax Invoice (X1XXXXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Special Zone Supplies (XXXXXXXXXXXXX1XXXXXX).</assert>

            
            
            
            <assert id="IBR-150-OM" flag="fatal" test="not($isSpecialZone)                   or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)" diagnostics="d-IBR-150">[IBR-150-OM] - If Invoice transaction type (BTOM-001) is Special Zone Supplies (XXXXXXXXXXXXX1XXXXXX) , buyer country subdivision code (BTOM-026) and Seller country subdivision code (BTOM-024) MUST be provided using the codelist for Country Subdivision (CL-13-OM).</assert>

            
            
            
            <assert id="IBR-151-OM" flag="fatal" test="                     not($isSpecialZone and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO')                     or                     cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID                     " diagnostics="d-IBR-151">[IBR-151-OM] - Seller identifier (IBT-029) is mandatory with Scheme identifier (IBT-029-1) 'Special Zone License Number' if Invoice transaction type (BTOM-001) is Special zone supplies (XXXXXXXXXXXXX1XXXXXX) and Seller country subdivision code (BTOM-024) is not equal to 'MO'.</assert>

            
            
            
            <assert id="IBR-152-OM" flag="fatal" test="                     not($isSpecialZone and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO')                     or                     cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                     " diagnostics="d-IBR-152">[IBR-152-OM] - Buyer identifier (IBT-046) is mandatory with Scheme identifier (IBT-046-1) 'Special Zone License Number' if Invoice transaction type (BTOM-001) is Special zone supplies (XXXXXXXXXXXXX1XXXXXX) and Buyer country subdivision code (BTOM-026) is not equal to 'MO'.</assert>

            
            
            
            <assert id="IBR-153-OM" flag="fatal" test="                     not($isImportGoods)                     or                     cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                     " diagnostics="d-IBR-153">[IBR-153-OM] - Buyer identifier (IBT-046) is mandatory with Scheme identifier (IBT-046-1) 'Importer Customs ID' if Invoice transaction type (BTOM-001) is Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

            
            
            
            <assert id="IBR-155-OM" flag="fatal" test="not($isExport and $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode ='VATZR-OM-09'])                   or $lines[cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode]" diagnostics="d-IBR-155">[IBR-155-OM] - If invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and atleast one VAT exemption reason code (IBT-121) is 'Export of service' then Service Type (BTOM-015) must be provided from the codelist for Type of Services (CL-12-OM).</assert>

            
            
            
            <assert id="IBR-156-OM" flag="fatal" test="not(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate) or matches(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate,'^\d{4}-\d{2}-\d{2}$')" diagnostics="d-IBR-156">[IBR-156-OM] - Import date (BTOM-020) MUST be formatted in YYYY-MM-DD.</assert>

            
            
            
            <assert id="IBR-160-OM" flag="fatal" test="not($isImportRCM)                   or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'OM'" diagnostics="d-IBR-160">[IBR-160-OM] - Seller country code (IBT-040) MUST not be'OM' if Invoice transaction type (BTOM-001) is Import of services for RCM (XXXXXXXX1XXXXXXXXXXX).</assert>

                 
                  
                 
                <assert id="IBR-169-OM" flag="fatal" test="not(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID) or cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID = 'OMR'" diagnostics="d-IBR-169">[IBR-169-OM] - currencyID attribute for Total amount due (profit margin) (BTOM-030) MUST be 'OMR'.</assert>

            
            
            
            <assert id="IBR-171-OM" flag="fatal" test="not(cbc:IssueDate) or                          xs:date(cbc:IssueDate) &lt;= xs:date(substring(string(current-date()), 1, 10))" diagnostics="d-IBR-171">[IBR-171-OM] - Invoice issue date (IBT-002) MUST NOT be a future date.</assert>

            
            
            
            <assert id="IBR-172-OM" flag="fatal" test="not($invoiceCurrency='OMR') or not(cac:TaxExchangeRate/cbc:CalculationRate)" diagnostics="d-IBR-172">[IBR-172-OM] - If Invoice currency code (IBT-005) is "OMR" then Exchange Rate (BTOM-003) MUST NOT be present.</assert>

            
            
            
            <assert id="IBR-173-OM" flag="fatal" test="                     not(normalize-space(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID) = '997770000099')                     or                     (                         normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID) != ''                         and                         matches(normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID), '^[A-Za-z0-9-]+$')                     )                     " diagnostics="d-IBR-173">[IBR-173-OM] - If Buyer electronic address (IBT-049) is '997770000099', Seller UUID (BTOM-004) MUST be present.</assert>
            
                 
                  
                   
                 <assert id="IBR-175-OM" flag="fatal" test="                     not($isProfitMargin)                     or                     exists(                         cac:BillingReference/cac:InvoiceDocumentReference[                             normalize-space(cbc:ID) != ''                             and normalize-space(cbc:UUID) != ''                         ]                     )                     " diagnostics="d-IBR-175">[IBR-175-OM] - If Invoice transaction type (BTOM-003) is Profit margin invoice '00000000010000000000', Preceding Invoice reference (IBT-025), and Preceding invoice UUID (BTOM-031) MUST be present.</assert>

            
            
            
            <assert id="IBR-176-OM" flag="fatal" test="not($isPrepayment and ($isSummary or $isDeemed or $isProfitMarginSelf))" diagnostics="d-IBR-176">[IBR-176-OM] - Invoice transaction type (BTOM-001) cannot be Prepayment Invoice (XXXXXXXXXXXXXXX1XXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply (XXXXXXX1XXXXXXXXXXXX) or Profit Margin Self Invoice (XXXXXXXXXX1XXXXXXXXX).</assert>

            
            
            
            <assert id="IBR-177-OM" flag="fatal" test="not($invoiceType=('261','389'))                   or ($isSelfBilled or $isImportRCM or $isProfitMarginSelf or $isImportGoods)" diagnostics="d-IBR-177">[IBR-177-OM] - If Invoice Type code (IBT-003) is Self billed credit note '261' or Self billed invoice '389' then Invoice transaction type (BTOM-001) MUST be either Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) OR Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) OR Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) OR Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>

        </rule>

        
        
        

        <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal">

            
            
            

            <let name="vatCategory" value="normalize-space(cac:TaxCategory/cbc:ID)"/>

            <let name="rate" value="if (cac:TaxCategory/cbc:Percent castable as xs:decimal)                         then xs:decimal(cac:TaxCategory/cbc:Percent)                         else ()"/>

            <let name="cat" value="normalize-space(cac:TaxCategory/cbc:ID)"/>

            
            <let name="isInvoiceCurrency" value="cbc:TaxAmount/@currencyID = $invoiceCurrency"/>

            <let name="isTaxCurrency" value="cbc:TaxAmount/@currencyID = $taxCurrency"/>

            
            
            
            

            
            <assert id="ALIGNED-IBRP-045" flag="fatal" test="not($isInvoiceCurrency) or cbc:TaxableAmount" diagnostics="d-045">[ALIGNED-IBRP-045] - Each VAT breakdown (IBG-23) MUST have a VAT category taxable amount (IBT-116).</assert>

            
            <assert id="ALIGNED-IBRP-046" flag="fatal" test="not($isInvoiceCurrency) or cbc:TaxAmount" diagnostics="d-046">[ALIGNED-IBRP-046] - Each VAT breakdown (IBG-23) MUST have a VAT category tax amount (IBT-117).</assert>

            
            <assert id="ALIGNED-IBRP-047" flag="fatal" test="not($isInvoiceCurrency) or cac:TaxCategory/cbc:ID" diagnostics="d-047">[ALIGNED-IBRP-047] - Each VAT breakdown (IBG-23) MUST be defined through a VAT category code (IBT-118).</assert>

            
            <assert id="ALIGNED-IBRP-048" flag="fatal" test="not($isInvoiceCurrency)                          or ($vatCategory = ('E', 'O', 'Z'))                          or exists(cac:TaxCategory/cbc:Percent)" diagnostics="d-048">[ALIGNED-IBRP-048] - Each VAT breakdown (IBG-23) MUST have a VAT category rate (IBT-119), except for categories 'E', 'O', or 'Z'.</assert>

            
            
            

            <assert id="ALIGNED-IBRP-E-08-OM" flag="fatal" test="not($isInvoiceCurrency and $vatCategory = 'E')           or           (               cbc:TaxableAmount castable as xs:decimal               and (not(exists($rate)) or $rate castable as xs:decimal)               and u:slack(                   xs:decimal(cbc:TaxableAmount),                    xs:decimal(                       round(                           (                               sum(                                   for $l in $lines[                                       cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory                                       and (if (exists($rate)) then (cac:Item/cac:ClassifiedTaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal($rate)) else true())                                   ]                                   return xs:decimal($l/cbc:LineExtensionAmount)                               )                                -                                sum(                                   for $a in $allowances[                                       cac:TaxCategory/cbc:ID = $vatCategory                                       and (if (exists($rate)) then (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)) else true())                                   ]                                   return xs:decimal($a/cbc:Amount)                               )                                +                                sum(                                   for $c in $charges[                                       cac:TaxCategory/cbc:ID = $vatCategory                                       and (if (exists($rate)) then (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)) else true())                                   ]                                   return xs:decimal($c/cbc:Amount)                               )                           ) * 100                       ) div 100                   ),                    0.02               )           )" diagnostics="d-E-08">[ALIGNED-IBRP-E-08-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is "E" the VAT category taxable amount (IBT-116) MUST be the VAT category taxable amount (IBT-116) must equal the sum of Invoice line net amounts (IBT-131) minus the sum of Document level allowance amounts (IBT-092) plus the sum of Document level charge amounts (IBT-099) where the VAT category codes (IBT-151,IBT-95, IBT-102) is “E" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "E".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-E-09-OM" flag="fatal" test="$isSimplified                     or not($vatCategory='E')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )" diagnostics="d-E-09">[ALIGNED-IBRP-E-09-OM] - The VAT category tax amount (ibt-117) In a VAT breakdown (ibg-23) where the VAT category code (ibt-118) equals "E" MUST equal 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (ibt-117) I is not required if VAT category code (ibt-118) equal to "E".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-O-08-OM" flag="fatal" test="$isSimplified         or not($vatCategory = 'O')         or (                 cbc:TaxableAmount castable as xs:decimal                 and u:slack(                     xs:decimal(cbc:TaxableAmount),                      xs:decimal(                         sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory]/cbc:LineExtensionAmount)                         -                         sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory]/cbc:Amount)                         +                         sum($charges[cac:TaxCategory/cbc:ID = $vatCategory]/cbc:Amount)                     ),                      0.02                 )             )" diagnostics="d-O-08">[ALIGNED-IBRP-O-08-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is " O" the VAT category taxable amount (IBT-116) MUST be equal the sum of Invoice line net amounts (IBT-131) minus the sum of Document level allowance amounts (IBT-092) plus the sum of Document level charge amounts (IBT-99) where the VAT category codes (IBT-151, IBT-095, IBT-102) are “O" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "O".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-O-09-OM" flag="fatal" test="$isSimplified                     or not($vatCategory='O')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )" diagnostics="d-O-09">[ALIGNED-IBRP-O-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is "O" MUST be 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) is not required if VAT category code (IBT-118) equal to "O".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-Z-01-OM" flag="fatal" test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z'] or                          $allowances[cac:TaxCategory/cbc:ID='Z'] or                          $charges[cac:TaxCategory/cbc:ID='Z']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) &lt;= 1)                     )" diagnostics="d-Z-01">[ALIGNED-IBRP-Z-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "Z" MUST contain in the VAT breakdown (IBG-23) exactly one VAT category code (IBT-118) equal with "Z" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "Z".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-SR-12" flag="fatal" test="                     count(                         .//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme                         [cac:TaxScheme/cbc:ID = 'VAT']                         /cbc:CompanyID                     ) &lt;= 1                 " diagnostics="d-SR-12">[ALIGNED-IBRP-SR-12] - Seller VAT Identifier (IBT-031) must occur at most once.</assert>

            
            
            

            <assert id="ALIGNED-IBRP-Z-08-OM" flag="fatal" test="$isSimplified                     or not($vatCategory='Z')                     or cbc:TaxableAmount =                     (                         sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z']/cbc:LineExtensionAmount)                         -                         sum($allowances[cac:TaxCategory/cbc:ID='Z']/cbc:Amount)                         +                         sum($charges[cac:TaxCategory/cbc:ID='Z']/cbc:Amount)                     )" diagnostics="d-Z-08">[ALIGNED-IBRP-Z-08-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "Z" the VAT category taxable amount (IBT-116) MUST equal the sum of Invoice line net amount (IBT-131) minus the sum of Document level allowance amounts (IBT-92) plus the sum of Document level charge amounts (IBT-99) where the VAT category codes (IBT-151, IBT-95, IBT-102) are "Z" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "Z".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-Z-09-OM" flag="fatal" test="$isSimplified                     or not($vatCategory='Z')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )" diagnostics="d-Z-09">[ALIGNED-IBRP-Z-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "Z" MUST equal 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) is not required if VAT category code (IBT-118) equal to "Z".</assert>

            
            
            

            <assert id="ALIGNED-IBRP-S-08-OM" flag="fatal" test="not($vatCategory = 'S') or (                         cbc:TaxableAmount castable as xs:decimal and                          cac:TaxCategory/cbc:Percent castable as xs:decimal and                          u:slack(                             xs:decimal(cbc:TaxableAmount),                              xs:decimal(round((                                 sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:LineExtensionAmount/xs:decimal(.)) +                                  sum($charges[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.)) -                                  sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.))                             ) * 100) div 100),                              0.02                         ))" diagnostics="d-S-08">[ALIGNED-IBRP-S-08-OM] - For each different value of VAT category rate (IBT-119) where the VAT category code (IBT-118) is "S", the VAT category taxable amount (IBT-116) in a VAT breakdown (IBG-23) MUST equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the VAT category code (IBT-151, IBT-102, IBT-095) is "S" and the VAT rate (IBT-152, IBT-103, IBT-096) equals the VAT category rate (IBT-119).</assert>

            
            
            
            <assert id="ALIGNED-IBRP-S-09-OM" flag="fatal" test="not($vatCategory = 'S') or (                         cbc:TaxAmount castable as xs:decimal and                          u:slack(                             xs:decimal(cbc:TaxAmount),                             xs:decimal(round((                                 sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory]/cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount/xs:decimal(.)) +                                  sum(for $c in $charges[cac:TaxCategory/cbc:ID = $vatCategory and cac:TaxCategory/cbc:Percent castable as xs:decimal] return xs:decimal($c/cbc:Amount) * xs:decimal($c/cac:TaxCategory/cbc:Percent) div 100) -                                  sum(for $a in $allowances[cac:TaxCategory/cbc:ID = $vatCategory and cac:TaxCategory/cbc:Percent castable as xs:decimal] return xs:decimal($a/cbc:Amount) * xs:decimal($a/cac:TaxCategory/cbc:Percent) div 100)                             ) * 100) div 100),                             0.02                         ))" diagnostics="d-S-09">[ALIGNED-IBRP-S-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "S" MUST equal the Σ Invoice line VAT amount (BTOM-016) where Invoiced item VAT category code (IBT-151) is "S"</assert>

            
            
            

            <assert id="ALIGNED-IBRP-S-10-OM" flag="fatal" test="not($vatCategory='S')                     or (not(cac:TaxCategory/cbc:TaxExemptionReasonCode)                         and not(cac:TaxCategory/cbc:TaxExemptionReason))" diagnostics="d-S-10">[ALIGNED-IBRP-S-10-OM] - A VAT breakdown (IBG-23) with VAT Category code (IBT-118) "S" MUST not have a VAT exemption reason code (IBT-121) or VAT exemption reason text (IBT-120).</assert>

            
            
            

            <assert id="IBR-053-OM" flag="fatal" test="not($vatCategory='S')                     or (                         $rate castable as xs:decimal                         and xs:decimal($rate) = 5                     )" diagnostics="d-IBR-053">[IBR-053-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is 'S' (Standard rated), the VAT category rate (IBT-119) MUST be 5.</assert>

            <assert id="IBR-061-OM" flag="fatal" test="not($vatCategory='O') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-061">[IBR-061-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'O', VAT category tax Rate (IBT-119) shall not be provided.</assert>

            <assert id="IBR-067-OM" flag="fatal" test="not($vatCategory='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-067">[IBR-067-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'E', VAT category VAT Rate (IBT-119) shall not be provided.</assert>

            <assert id="IBR-069-OM" flag="fatal" test="not($vatCategory='E' or $vatCategory='Z')                     or cac:TaxCategory/cbc:TaxExemptionReasonCode" diagnostics="d-IBR-069">[IBR-069-OM] - A VAT breakdown (IBG-23) with VAT category code (IBT-118) 'E' (Exempt) or 'Z' (Zero rated) MUST have a VAT exemption reason code (IBT-121).</assert>

            <assert id="IBR-070-OM" flag="fatal" test="not($vatCategory='O')                     or not(cac:TaxCategory/cbc:TaxExemptionReasonCode)" diagnostics="d-IBR-070">[IBR-070-OM] - A VAT breakdown (IBG-23) with VAT category code (IBT-118) 'O' (Not subject to VAT) MUST NOT have a VAT exemption reason code (IBT-121).</assert>

            <assert id="IBR-104-OM" flag="fatal" test="not($vatCategory='S')                     or (                         cac:TaxCategory/cbc:Percent castable as xs:decimal                         and xs:decimal(cac:TaxCategory/cbc:Percent) = 5                     )" diagnostics="d-IBR-104">[IBR-104-OM] - In a VAT breakdown (IBG-23) for VAT accounting currency, where the VAT category code (IBT-118) is 'S', the VAT category rate (IBT-119) MUST be 5.</assert>

            
            
            

            <assert id="IBR-095-OM" flag="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $cat='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-095">[IBR-095-OM] - If category is 'E' in accounting currency, rate MUST not be present.</assert>

            <assert id="IBR-096-OM" flag="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $cat='O')                     or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-096">[IBR-096-OM] - If the TAX category code for tax category tax amount in accounting currency (IBT-192) is 'O', then the TAX category rate (IBT-193) MUST NOT be present.</assert>

            <assert id="IBR-097-OM" flag="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $cat='O')                      or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)" diagnostics="d-IBR-097">[IBR-097-OM] - If category is 'Z' in accounting currency, rate MUST be 0.</assert>
        </rule>

         
        
        


        <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
            <let name="cat" value="normalize-space(cac:TaxCategory/cbc:ID)"/>

            <assert id="ALIGNED-IBRP-058" flag="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                       or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-057">[ALIGNED-IBRP-058] - Either both or neither Charge base amount (IBT-100) and percentage (IBT-101) MUST be provided..</assert>

            
            <assert id="IBR-042-OM" flag="fatal" test="cbc:AllowanceChargeReasonCode" diagnostics="d-IBR-042">[IBR-042-OM] - If Document level charge (IBG-21) is present, document level charge reason code MUST be present.</assert>

            
            <assert id="IBR-045-OM" flag="fatal" test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5)" diagnostics="d-IBR-045">[IBR-045-OM] - If Document level charge TAX category code (IBT-102) is 'S', Document level charge TAX rate (IBT-103) MUST be 5.</assert>

            
            <assert id="IBR-064-OM" flag="fatal" test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode" diagnostics="d-IBR-064">[IBR-064-OM] - Document level charge (IBG-21) with Document level charge VAT category code (IBT-102) as 'E' or 'Z' MUST have a Document level charge VAT exemption reason code (IBT-198).</assert>

            
            <assert id="IBR-098-OM" flag="fatal" test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-098">[IBR-098-OM] - If Document level charge TAX category code (IBT-102) is 'E', Document level charge TAX rate (IBT-103) MUST not be present.</assert>
            <assert id="IBR-099-OM" flag="fatal" test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-099">[IBR-099-OM] - If Document level charge TAX category code (IBT-102) is 'O', Document level charge TAX rate (IBT-103) MUST not be present.</assert>
            <assert id="IBR-100-OM" flag="fatal" test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)" diagnostics="d-IBR-100">[IBR-100-OM] - If Document level charge TAX category code (IBT-102) is 'Z', Document level charge TAX rate (IBT-103) MUST be 0.</assert>
            
        </rule>

        <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']">
            <let name="cat" value="normalize-space(cac:TaxCategory/cbc:ID)"/>

            <assert id="ALIGNED-IBRP-057" flag="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-057">[ALIGNED-IBRP-057] - Either both or neither Allowance base amount (IBT-093) and percentage (IBT-094) MUST be provided.</assert>

            
            <assert id="IBR-033-OM" flag="fatal" test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                         or                         (                             cbc:Amount castable as xs:decimal                             and cbc:BaseAmount castable as xs:decimal                             and cbc:MultiplierFactorNumeric castable as xs:decimal                             and                             u:slack(                                 xs:decimal(cbc:Amount),                                  xs:decimal(                                     round(                                         (                                             xs:decimal(cbc:BaseAmount)                                             * xs:decimal(cbc:MultiplierFactorNumeric)                                             div 100                                         ) * 100                                     ) div 100                                 ),                                  0.02                             )                         )" diagnostics="d-IBR-033">[IBR-033-OM] - Allowance amount (IBT-092, IBT-136) must equal base amount (IBT-093, IBT-137) * percentage (IBT-094, IBT-138) /100 if base amount and percentage exists.</assert>
            
            <assert id="IBR-047-OM" flag="fatal" test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5)" diagnostics="d-IBR-047">[IBR-047-OM] - If Document level allowance TAX category code (IBT-095) is 'S', Document level allowance TAX rate (IBT-096) MUST be 5.</assert>

            
            <assert id="IBR-062-OM" flag="fatal" test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode" diagnostics="d-IBR-062">[IBR-062-OM] - Document level allowances (IBG-20) with Document level allowance VAT category code (IBT-095) as 'E' or 'Z' MUST have a Document level allowance VAT exemption reason code (IBT-196)</assert>

            
            <assert id="IBR-092-OM" flag="fatal" test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-092">[IBR-092-OM] - If Document level allowance TAX category code (IBT-095) is 'E', Document level allowance TAX rate (IBT-096) MUST not be present.</assert>

            <assert id="IBR-093-OM" flag="fatal" test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-093">[IBR-093-OM] - If Document level allowance TAX category code (IBT-095) is 'O', Document level allowance TAX rate (IBT-096) MUST not be present.</assert>

            <assert id="IBR-094-OM" flag="fatal" test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)" diagnostics="d-IBR-094">[IBR-094-OM] - If Document level allowance TAX category code (IBT-095) is 'Z', Document level allowance TAX rate (IBT-096) MUST be 0.</assert>

        </rule>

        
        <rule context="ubl:Invoice/cac:AllowanceCharge | cn:CreditNote/cac:AllowanceCharge">

            
            <assert id="IBR-041-OM" flag="fatal" test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount">[IBR-041-OM] - Document level allowance/charge base amount (IBT-093, IBT-100) must be provided when Invoice line allowance/charge percentage (IBT-094, IBT-101) is provided.</assert>

            
            <assert id="IBR-063-OM" flag="fatal" test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                             or                             (                                 cbc:Amount castable as xs:decimal                                 and cbc:BaseAmount castable as xs:decimal                                 and cbc:MultiplierFactorNumeric castable as xs:decimal                                 and                                 u:slack(                                     xs:decimal(cbc:Amount),                                      xs:decimal(                                         round(                                             (                                                 xs:decimal(cbc:BaseAmount)                                                 * xs:decimal(cbc:MultiplierFactorNumeric)                                                 div 100                                             ) * 100                                         ) div 100                                     ),                                      0.02                                 )                             )">[IBR-063-OM] - Charge amount (IBT-099, IBT-141) must equal base amount (IBT-100, IBT-142) * percentage (IBT-101, IBT-143) /100 if base amount and percentage exists</assert>
        </rule>
             
             
              
        <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge"> 
             
             <assert id="IBR-035-OM" flag="fatal" test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount" diagnostics="d-IBR-035">[IBR-035-OM] - Invoice line allowance/charge base amount (IBT-137, IBT-142) must be provided when Invoice line allowance/charge percentage (IBT-138, IBT-143) is provided.</assert>

            <assert id="IBR-074-OM" flag="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                     or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-IBR-074">[IBR-074-OM] - Either both or neither Charge base amount (IBT-142) and percentage (IBT-143) MUST be provided</assert>
            
            
            <assert id="IBR-073-OM" flag="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                     or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-IBR-073">[IBR-073-OM] - Either both or neither Allowance base amount (IBT-137) and percentage (IBT-138) MUST be provided.</assert>
            </rule>

        
        
        
        <rule context="cbc:Percent">

            
            <assert id="IBR-046-OM" flag="fatal" test="matches(normalize-space(.), '^\d+(\.\d{1,2})?$')                      and (if (. castable as xs:decimal) then (xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100) else false())" diagnostics="d-IBR-046">[IBR-046-OM] - The VAT rates (IBT-096, IBT-103, IBT-119, IBT-152, IBT-193) if exists MUST only be numeric (without percentage symbol) ranging from 0.00 to 100.00, with maximum of two decimals.</assert>
        </rule>

        
        
        

        <rule context="             cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             ">
            <let name="cleanID" value="replace(normalize-space(.), '\s+', '')"/>
            <assert id="IBR-003-OM" flag="fatal" test="matches($cleanID, '^OM[0-9]{10}$')" diagnostics="d-IBR-003">VAT identifier must be 12 characters, starting with 'OM' followed by 10 digits.</assert>

        </rule>

        
        
        

        <rule context="cac:ClassifiedTaxCategory | cac:TaxCategory | cac:PartyTaxScheme">
            <let name="isSupplier" value="exists(ancestor::cac:AccountingSupplierParty)"/>
            <let name="isBuyer" value="exists(ancestor::cac:AccountingCustomerParty)"/>
            <let name="fullXPath" value="string-join(for $node in ancestor-or-self::* return local-name($node), '/')"/>
            
            <assert id="IBR-009-OM" flag="fatal" test="if (local-name() = 'TaxCategory')                              then (cac:TaxScheme/cbc:ID = 'VAT')                         else if ($isBuyer)                             then (count(../cac:PartyTaxScheme) = 1 and cac:TaxScheme/cbc:ID = 'VAT')                         else if ($isSupplier)                             then (                                 (cac:TaxScheme/cbc:ID = 'VAT' or ../cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT') and                                 (if (cac:TaxScheme/cbc:ID = 'VAT') then count(../cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']) = 1 else true())                             )                         else (cac:TaxScheme/cbc:ID = 'VAT')" diagnostics="d-IBR-009">[IBR-009-OM] - Tax scheme code, must provided in IBT-031-1 or BTOM-006-1 or IBT-048-1 or IBT-095-1 or IBT-102-1 or IBT-118-1 or IBT-167 and shall be 'VAT'.</assert>

        </rule>

        
        
        

        
        
        

        <rule context="cac:InvoiceLine | cac:CreditNoteLine">
            <let name="vatCategory" value="normalize-space(cac:Item/cac:ClassifiedTaxCategory/cbc:ID)"/>

            <let name="vatRate" value="if (cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)                          else 0"/>

            <let name="lineTaxAmount" value="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>

            
            <assert id="ALIGNED-IBRP-E-05-OM" flag="fatal" test="not($vatCategory='E')                   or not($vatRate)" diagnostics="d-E-05">[ALIGNED-IBRP-E-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "E" MUST not contain an Invoice item VAT rate (IBT-152).</assert>

            
            <assert id="ALIGNED-IBRP-O-05-OM" flag="fatal" test="not($vatCategory='O')                   or not($vatRate)" diagnostics="d-O-05">[ALIGNED-IBRP-O-05-OM] - An Invoice line (IBG-25) where the VAT category code (IBT-151) is "O" MUST not contain an Invoiced item VAT rate (IBT-152).</assert>

            
            <assert id="IBR-039-OM" flag="fatal" test="not($vatCategory='E')                   or $lineTaxAmount = 0" diagnostics="d-IBR-039">[IBR-039-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Exempt', Line Item VAT Amount (BTOM-016) shall be zero.</assert>
            
            <assert id="IBR-054-OM" flag="fatal" test="not($vatCategory='O')                   or $lineTaxAmount=0" diagnostics="d-IBR-054">[IBR-054-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Not Subject to VAT', Line Item VAT Amount (BTOM-016) shall be zero.</assert>
            
                
            

                
                <assert id="IBR-056-OM" flag="fatal" test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID='HS'" diagnostics="d-IBR-056">[IBR-056-OM] - The scheme identifier (ibt-158-1) MUST be 'HS' when Item classification identifier (ibt-158) is provided</assert>

            
            <assert id="IBR-068-OM" flag="fatal" test="$lineTaxAmount" diagnostics="d-IBR-068">[IBR-068-OM] - An Invoice must contain the total amount including VAT (BTOM-017) for each invoice line.</assert>

            <assert id="ALIGNED-IBRP-Z-05-OM" flag="fatal" test="not($vatCategory = 'Z') or xs:decimal($vatRate) = 0" diagnostics="d-Z-05">[ALIGNED-IBRP-Z-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "Zero rated" the Invoiced item VAT rate (IBT-152) MUST be 0 (zero).</assert>

            <let name="lineExtensionAmount" value="if (cbc:LineExtensionAmount/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cbc:LineExtensionAmount)                          else 0"/>

            <let name="quantity" value="if ((cbc:InvoicedQuantity | cbc:CreditedQuantity)/normalize-space(.) castable as xs:decimal)                          then xs:decimal((cbc:InvoicedQuantity | cbc:CreditedQuantity)[1])                          else 1"/>

            <let name="priceAmount" value="if (cac:Price/cbc:PriceAmount/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cac:Price/cbc:PriceAmount)                          else 0"/>

           <let name="baseQuantity" value="                 if (cac:Price/cbc:BaseQuantity/normalize-space(.) castable as xs:decimal                      and xs:decimal(normalize-space(cac:Price/cbc:BaseQuantity)) != 0)                  then xs:decimal(normalize-space(cac:Price/cbc:BaseQuantity))                  else 1"/>

            <let name="allowancesTotal" value="if (cac:AllowanceCharge[cbc:ChargeIndicator = 'false'])                          then round(sum(                             for $amt in cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:Amount                             return if ($amt castable as xs:decimal) then xs:decimal($amt) else 0                         ) * 100) div 100                         else 0"/>

            <let name="chargesTotal" value="if (cac:AllowanceCharge[cbc:ChargeIndicator = 'true'])                          then round(sum(                             for $amt in cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:Amount                             return if ($amt castable as xs:decimal) then xs:decimal($amt) else 0                         ) * 100) div 100                         else 0"/>
            
            <assert id="IBR-071-OM" flag="fatal" test="u:slack(                         u:to-decimal($lineExtensionAmount),                          u:to-decimal(($quantity * (u:to-decimal($priceAmount) div $baseQuantity)) + $chargesTotal - $allowancesTotal),                          0.02)" diagnostics="d-IBR-071">[IBR-071-OM] - Invoice line net amount (IBT-131) MUST equal (Invoiced quantity (IBT-129) * (Item net price (IBT-146)/item price base quantity (IBT-149)) + Sum of invoice line charge amount (IBT-141) - sum of invoice line allowance amount (IBT-136).</assert>
            
             <let name="grossPrice" value="if (cac:Price/cbc:BaseAmount) then xs:decimal(cac:Price/cbc:BaseAmount) else 0"/>

            <let name="discountTotal" value="                 if (cac:Price/cac:AllowanceCharge/cbc:Amount)                 then sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.))                 else 0"/>

            <let name="netPrice" value="if (cac:Price/cbc:PriceAmount) then xs:decimal(cac:Price/cbc:PriceAmount) else 0"/>

            <let name="expectedNetPrice" value="                 if ($grossPrice)                 then round(($grossPrice - $discountTotal) * 100) div 100                 else 0"/>

            <assert id="IBR-075-OM" flag="fatal" test="not($grossPrice) or $netPrice = $expectedNetPrice" diagnostics="d-IBR-075">[IBR-075-OM] - Item net price (IBT-146) MUST equal (Gross price (IBT-148) - Price discount (IBT-147)) when gross price is provided.</assert>

            
            <assert id="IBR-076-OM" flag="fatal" test="$vatCategory" diagnostics="d-IBR-076">[IBR-076-OM] - Each Invoice line (IBG-25) MUST be categorized with an Invoiced item tax category code (IBT-151).</assert>

            
            <assert id="IBR-077-OM" flag="fatal" test="not($vatCategory='Z')                   or $lineTaxAmount=0" diagnostics="d-IBR-077">[IBR-077-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Zero Rated', Line Item VAT Amount (BTOM-016) shall be zero.</assert>

            
            <assert id="IBR-078-OM" flag="fatal" test="                 $isSimplified                 or                 cac:Item/cac:CommodityClassification/cbc:NatureCode                 " diagnostics="d-IBR-078">[IBR-078-OM] - Item Type (BTOM-019) must be provided for each item (IBT-153) except when Invoice transaction type (BTOM-001) is 'Simplified Tax Invoice' (X1XXXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-079-OM" flag="fatal" test="$isSimplified                   or not(cac:Item/cac:CommodityClassification/cbc:NatureCode='GS')                   or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" diagnostics="d-IBR-079">[IBR-079-OM] - When Item type (BTOM-019) is 'Goods' then Item classification identifier (ibt-158) must be provided except when Invoice transaction type (BTOM-001) is 'Simplified Tax Invoice' (X1XXXXXXXXXXXXXXXXXX)</assert>

            
            <assert id="IBR-080-OM" flag="fatal" test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode)                   or string-length(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) &gt;= 12" diagnostics="d-IBR-080">[IBR-080-OM] - The minimum number of digits to be provided should be '12' in Item classification identifier (ibt-158)</assert>

            
            <assert id="IBR-081-OM" flag="fatal" test="$isSimplified or $isImportGoods or $isImportRCM or $isProfitMargin                   or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" diagnostics="d-IBR-081">[IBR-081-OM] - Industrial Classification Code must be provided for each ITEM INFORMATION (IBG-31) except when Invoice transaction type (BTOM-001) is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX) and/or import of goods (XXXXXXXXXXXX1XXXXXXX) or import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX).</assert>

            
            <assert id="IBR-084-OM" flag="fatal" test="not($isImportGoods)                   or cac:Item/cac:OriginCountry/cbc:IdentificationCode" diagnostics="d-IBR-084">[IBR-084-OM] - If invoice transaction type (BTOM-001) is 'Import of Goods' (XXXXXXXXXXXX1XXXXXXX) then Item country of origin (IBT-159) is mandatory.</assert>

            
            <assert id="IBR-086-OM" flag="fatal" test="not($isProfitMargin)                   or $vatCategory='O'" diagnostics="d-IBR-086">[IBR-086-OM] - If Invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice ' (XXXXXXXXXX1XXXXXXXXX), Invoiced item VAT category code (IBT-151) MUST be 'O' (Not subject to VAT).</assert>

            
            <assert id="IBR-091-OM" flag="fatal" test="not($isProfitMargin)                   or not(starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7101') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7102') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7103') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7104') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'01') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'06'))" diagnostics="d-IBR-091">[IBR-091-OM] - When Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Item classification identifier (IBT-158) MUST NOT start with '7101' or '7102' or '7103' or '7104' or '01' or '06'.</assert>

            <assert id="IBR-057-OM" flag="fatal" test="not($isSummary)                   or (substring(cac:InvoicePeriod/cbc:StartDate,1,7)                       = substring(cac:InvoicePeriod/cbc:EndDate,1,7))" diagnostics="d-IBR-036">[IBR-057-OM] - Invoice line period start date (ibt-134) and Invoice line period end date (ibt-135) when provided must belong to the same calendar month.</assert>

            
            
            
            <assert id="IBR-038-OM" flag="fatal" test="$isSimplified or $lineTaxAmount" diagnostics="d-IBR-038">[IBR-038-OM] - Each Invoice/CreditNote line must contain Item VAT Amount (BTOM-016) except where invoice is a simplified tax invoice (BTOM-001).</assert>
            
            <assert id="IBR-072-OM" flag="fatal" test="not($isFullTax and $isSummary)                   or cac:InvoicePeriod/cbc:StartDate                      and cac:InvoicePeriod/cbc:EndDate" diagnostics="d-IBR-072">[IBR-072-OM] - Invoice line period start date (IBT-134) and Invoice line period end date (IBT-135) must be provided if where Invoice transaction type (BTOM-001) is a Full Tax Invoice AND summary invoice (XXXX1XXXXXXXXXXXXXXX).</assert>
            
            
            
            <assert id="IBR-157-OM" flag="fatal" test="not(cac:Price/cac:AllowanceCharge/cbc:BaseAmount)                     or (                         cac:Price/cbc:PriceAmount castable as xs:decimal and                          cac:Price/cac:AllowanceCharge/cbc:BaseAmount castable as xs:decimal and                         u:slack(                             xs:decimal(cac:Price/cbc:PriceAmount),                             xs:decimal(                                 round(                                     (                                         xs:decimal(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) -                                         sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.))                                     ) * 100                                 ) div 100                             ),                             0.02                         )                     )" diagnostics="d-IBR-157">
                [IBR-157-OM] - Item net price (IBT-146) must equal (gross price (IBT-148) minus discount (IBT-147)) when gross price is provided.
            </assert>

            
            
            
            <assert id="IBR-168-OM" flag="fatal" test="                     not($vatRate)                     or                     (                         $lineTaxAmount castable as xs:decimal                         and cbc:LineExtensionAmount castable as xs:decimal                         and $vatRate castable as xs:decimal                         and                         u:slack(                             xs:decimal($lineTaxAmount),                             round(                                 (                                     xs:decimal(cbc:LineExtensionAmount)                                     * xs:decimal($vatRate)                                     div 100                                 ) * 100                             ) div 100,                             0.02                         )                     )                 " diagnostics="d-IBR-168">[IBR-168-OM] - The Line Item VAT amount (BTOM-016) must be Invoiced item VAT rate (IBT-152) multiplied by Invoice Line Net Amount (IBT-131).</assert>

            
            
            
             
            <assert id="IBR-158-OM" flag="fatal" test="$isProfitMargin                         or (                             cac:ItemPriceExtension/cbc:Amount castable as xs:decimal                             and u:slack(                                 xs:decimal(cac:ItemPriceExtension/cbc:Amount),                                 xs:decimal(xs:decimal(cbc:LineExtensionAmount) + xs:decimal($lineTaxAmount)),                                 0.02                             )                         )" diagnostics="d-IBR-158">[IBR-158-OM] - Total amount including VAT (BTOM-017) must be the sum of Invoice line net amount (IBT-131) and Line Item VAT amount (BTOM-016) unless if Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) in which case Total amount including VAT (BTOM-017) must be the total sale value of the item.</assert>

            
            
            
            <assert id="IBR-174-OM" flag="warning" test="not(cac:Item/cbc:ItemClassificationCode)" diagnostics="d-IBR-174">[IBR-174-OM] - Item classification identifier (HS Code) (IBT-158) must be provided from the Harmonized System (HS) Code list published by the Royal Oman Police (Directorate General of Customs).</assert>
        </rule>
        
            
        
    </pattern>
        
            
        
    <pattern id="AlignedCodelists">
        <rule flag="fatal" context="cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode">
            <assert diagnostics="CL-02-OM" id="CL-02-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' CAN VAT VAL QTY OTH ', concat(' ', normalize-space(.), ' '))))">[CL-02-OM] - Credit Note or Debit Note reason code (BTOM-032) must be coded using the code list for Codelist for reasons for issuance of credit note or debit note.</assert>
        </rule>
        <rule context="cbc:InvoiceTypeCode[@name] | cbc:CreditNoteTypeCode[@name]">
            <let name="t" value="normalize-space(@name)"/>
            <assert id="CL-03-OM-1" flag="fatal" test="not(substring($t,1,1)='1' and substring($t,2,1)='1')" diagnostics="CL-03-OM">[CL-03-OM-1] - An invoice cannot be both a Full Tax Invoice (Bit 1) and a Simplified Invoice (Bit 2).</assert>

            <assert id="CL-03-OM-2" flag="fatal" test="substring($t,1,1)='1' or substring($t,2,1)='1'" diagnostics="CL-03-OM">CL-03-OM-2] - Invoice transaction type (BTOM-001) must indicate either a Full Tax Invoice (bit 1) or a Simplified Invoice (bit 2).</assert>
        </rule>
        <rule flag="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
            <assert diagnostics="CL-04-OM" id="CL-04-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' S E O Z ', concat(' ', normalize-space(.), ' '))))">[CL-04-OM] - Document level allowance TAX category code (IBT-095), Document level charge TAX category code (IBT-102), TAX category code for tax category tax amount in accounting currency (IBT-192), TAX category code (IBT-118), Invoiced item TAX category code (IBT-151), MUST all be coded using the code list for Invoice VAT Categories.</assert>
        </rule>
        <rule flag="fatal" context="cac:TaxCategory/cbc:TaxExemptionReasonCode | cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode">
            <assert diagnostics="CL-05-10-OM" id="CL-05-10-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' VATZR-OM-01 VATZR-OM-02 VATZR-OM-03 VATZR-OM-04 VATZR-OM-05 VATZR-OM-06 VATZR-OM-07 VATZR-OM-08 VATZR-OM-09 VATZR-OM-10 VATZR-OM-11 VATZR-OM-12 VATZR-OM-13 VATZR-OM-14 VATZR-OM-15 VATZR-OM-16 VATEX-OM-01 VATEX-OM-02 VATEX-OM-03 VATEX-OM-04 VATEX-OM-05 VATEX-OM-06 VATEX-OM-07 VATEX-OM-08 VATEX-OM-09 VATEX-OM-10 VATEX-OM-11 VATEX-OM-12 ', concat(' ', normalize-space(.), ' '))))">[IBR-CL-05-OM, IBR-CL-10-OM] - If Document level allowance TAX category code (IBT-095) is 'Z/E', Document level allowance TAX exemption reason code (IBT-196) MUST be coded using Zero rating/Exemption reason codelist.</assert>
        </rule>
        <rule flag="fatal" context="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName] | cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName]">
            <assert diagnostics="CL-06-OM" id="CL-06-OM" flag="fatal" test="((not(contains(normalize-space(@schemeName), ' ')) and contains(' CR TIN CID PASNUM OTHID ICID SZLN ', concat(' ', normalize-space(@schemeName), ' '))))">[CL-06-OM] - If provided, the value in the Buyer identifier (IBT-046) Scheme identifier (IBT-046-1) and Seller identifier (IBT-029) Scheme identifier (IBT-029-1) must be coded with Buyer/Seller Identifier codelist.</assert>
        </rule>
        <rule flag="fatal" context="cac:CommodityClassification/cbc:NatureCode">
            <assert diagnostics="CL-07-OM" id="CL-07-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' GS SV ', concat(' ', normalize-space(.), ' '))))">[CL-07-OM] - Item Type (BTOM-019) must be provided from the codelist for Item type.</assert>
        </rule>
        <rule flag="fatal" context="cac:Delivery/cac:DeliveryTerms/cbc:ID">
            <assert diagnostics="CL-09-OM" id="CL-09-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' EXW FCA CPT CIP DAP DPU DDP FAS FOB CFR CIF ', concat(' ', normalize-space(.), ' '))))">[CL-09-OM] - Incoterms (BTOM-022) MUST be coded using codelist Incoterms Codelist.</assert>
        </rule>
        <rule context="cac:AdditionalItemProperty/cbc:NameCode">
            <assert diagnostics="CL-11-OM" id="CL-11-OM" flag="fatal" test="                 (not($isProfitMargin or $isProfitMarginSelf))                 or                 (                     normalize-space(.) != ''                     and not(contains(normalize-space(.), ' '))                     and contains(                         ' VATPM-OM-01 VATPM-OM-02 VATPM-OM-03 VATPM-OM-04 VATPM-OM-05 ',                         concat(' ', normalize-space(.), ' ')                     )                 )                 ">[CL-11-OM] - If invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice' or Profit margin invoice, Profit margin item reason code (BTOM-025) MUST be present and coded using Profit Margin Items Codelist.</assert>
        </rule>
        <rule flag="fatal" context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='MP']">
            <assert diagnostics="CL-12-OM" id="CL-12-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' 64000000 70000000 71000000 72000000 73000000 76000000 77000000 78000000 80000000 81000000 82000000 83000000 84000000 85000000 86000000 90000000 91000000 92000000 93000000 94000000 ', concat(' ', normalize-space(.), ' '))))">[CL-12-OM] - Service Type classification code must coded with the service type codelist.</assert>
        </rule>
        <rule flag="fatal" context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode | cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode">
            <assert diagnostics="CL-13-OM" id="CL-13-OM" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' SHRFZ SEZAD SLLFZ AFZ MO ', concat(' ', normalize-space(.), ' '))))">[CL-13-OM] - Buyer/Supplier country subentity code must be coded using the subdivision code list.</assert>
        </rule>
  </pattern>
    
    
    

    <diagnostics>
        
        <diagnostic id="CL-02-OM">
            Credit/Debit Note reason code (BTOM-032)
            
            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - CAN
            - VAT
            - VAL
            - QTY
            - OTH

            Action:
            Use a valid reason code from the Credit/Debit Note reason codelist.
        </diagnostic>

        <diagnostic id="CL-03-OM">
            Invoice transaction type (BTOM-001) logic error.
            
            Found: '<value-of select="normalize-space(@name)"/>'
            
            Requirements:
            - Position 1 (Full Tax) and Position 2 (Simplified) cannot both be '1'.
            - One of the first two positions MUST be '1'.
            - Combinations are allowed (e.g., Full Tax + Export + Continuous).
        </diagnostic>

        <diagnostic id="CL-04-OM">
            VAT category code

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - S
            - E
            - O
            - Z

            Action:
            Use a valid VAT category code from the Invoice VAT Categories codelist.
        </diagnostic>

        <diagnostic id="CL-05-10-OM">
            VAT exemption / zero rating reason code (IBT-196)

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - VATZR-OM-01
            - VATZR-OM-02
            - VATZR-OM-03
            - VATZR-OM-04
            - VATZR-OM-05
            - VATZR-OM-06
            - VATZR-OM-07
            - VATZR-OM-08
            - VATZR-OM-09
            - VATZR-OM-10
            - VATZR-OM-11
            - VATZR-OM-12
            - VATZR-OM-13
            - VATZR-OM-14
            - VATZR-OM-15
            - VATZR-OM-16
            - VATEX-OM-01
            - VATEX-OM-02
            - VATEX-OM-03
            - VATEX-OM-04
            - VATEX-OM-05
            - VATEX-OM-06
            - VATEX-OM-07
            - VATEX-OM-08
            - VATEX-OM-09
            - VATEX-OM-10
            - VATEX-OM-11
            - VATEX-OM-12

            Action:
            Provide a valid exemption or zero-rating reason code.
        </diagnostic>

        <diagnostic id="CL-06-OM">
            Buyer/Seller identifier scheme (IBT-029-1 / IBT-046-1)

            Found:
            - Value: '<value-of select="normalize-space(@schemeID)"/>'

            Expected:
            Code must be one of the following:

            - CR
            - TIN
            - CID
            - PASNUM
            - OTHID
            - ICID
            - SZLN

            Action:
            Use a valid identifier scheme from the Buyer/Seller Identifier codelist.
        </diagnostic>

        <diagnostic id="CL-07-OM">
            Item type (BTOM-019)

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - GS
            - SV

            Action:
            Use a valid item type code.
        </diagnostic>

        <diagnostic id="CL-09-OM">
            Incoterms (BTOM-022)

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - EXW
            - FCA
            - CPT
            - CIP
            - DAP
            - DPU
            - DDP
            - FAS
            - FOB
            - CFR
            - CIF

            Action:
            Use a valid Incoterms code.
        </diagnostic>

        <diagnostic id="CL-11-OM">
            Profit margin item reason code (BTOM-025)

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - VATPM-OM-01
            - VATPM-OM-02
            - VATPM-OM-03
            - VATPM-OM-04
            - VATPM-OM-05

            Action:
            Provide a valid profit margin item reason code when applicable.
        </diagnostic>

        <diagnostic id="CL-12-OM">
            Service classification code

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - 64000000
            - 70000000
            - 71000000
            - 72000000
            - 73000000
            - 76000000
            - 77000000
            - 78000000
            - 80000000
            - 81000000
            - 82000000
            - 83000000
            - 84000000
            - 85000000
            - 86000000
            - 90000000
            - 91000000
            - 92000000
            - 93000000
            - 94000000

            Action:
            Use a valid service classification code.
        </diagnostic>

        <diagnostic id="CL-13-OM">
            Country subentity code

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - SHRFZ
            - SEZAD
            - SLLFZ
            - AFZ
            - MO

            Action:
            Use a valid subdivision code.
        </diagnostic>
        <diagnostic id="d-000">
            Transaction Type (BTOM-001) is missing.
            
            Expected:
            A 20-digit binary string representing the invoice transaction type.
            
            Action:
            Provide the required transaction type in the Invoice/CreditNote TypeCode name attribute.
        </diagnostic>
        
        <diagnostic id="d-001">
            Customization ID (cbc:CustomizationID)

            Found:
            '<value-of select="cbc:CustomizationID"/>'

            Expected:
            'urn:peppol:pint:billing-1@om-1'

            Action:
            Set CustomizationID to the expected value.
        </diagnostic>

        
        <diagnostic id="d-002">
            Profile ID (cbc:ProfileID)

            Found:
            '<value-of select="cbc:ProfileID"/>'

            Expected:
            'urn:peppol:pint:billing'

            Action:
            Set ProfileID to the expected value.
        </diagnostic>

        
        <diagnostic id="d-003">
            Tax currency (cbc:TaxCurrencyCode)

            Found:
            '<value-of select="cbc:TaxCurrencyCode"/>'

            Expected:
            A valid ISO 4217 currency code.

            Action:
            Provide a valid ISO currency code.
        </diagnostic>

        
        <diagnostic id="d-016">
            Issue time (cbc:IssueTime) is not present.

            Found:
            '<value-of select="cbc:IssueTime"/>'

            Expected:
            Issue time should be provided.

            Action:
            Provide IssueTime with a valid value.
        </diagnostic>

        
        <diagnostic id="d-028">
            Document type code (cbc:InvoiceTypeCode / cbc:CreditNoteTypeCode)

            Found:
            '<value-of select="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>'

            Expected:
            A valid code from UNCL1001.

            Action:
            Use a valid UNCL1001 document type code.
        </diagnostic>

        
        <diagnostic id="d-045">
            VAT breakdown (IBG-23)

            Found:
            - Taxable amount (IBT-116): '<value-of select="cbc:TaxableAmount"/>'
            - VAT category (IBT-118): '<value-of select="cac:TaxCategory/cbc:ID"/>'
            - VAT rate (IBT-119): '<value-of select="cac:TaxCategory/cbc:Percent"/>'
            - VAT amount (IBT-117): '<value-of select="cbc:TaxAmount"/>'
            - Currency: '<value-of select="cbc:TaxAmount/@currencyID"/>'

            Expected:
            VAT breakdown must be complete and consistent.

            Action:
            Verify VAT category, rate, taxable amount, and VAT amount.
        </diagnostic>

        
        <diagnostic id="d-046">
            VAT amount (IBT-117) is missing or invalid.

            Found:
            - VAT category: '<value-of select="cac:TaxCategory/cbc:ID"/>'
            - Taxable amount: '<value-of select="cbc:TaxableAmount"/>'

            Expected:
            VAT amount must be present and correctly calculated.

            Action:
            Provide a valid VAT amount.
        </diagnostic>
        
        <diagnostic id="d-047">
            Context: VAT category (IBT-118) is required for tax classification of each applicable element.

            Found: VAT category (IBT-118) = '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: A valid VAT category code must be provided according to the VAT code list (e.g., S, Z, E, O, etc.).

            Action: Provide a valid VAT category code or correct the missing/invalid classification.
        </diagnostic>

        
        <diagnostic id="d-048">
            Context: VAT category and VAT rate must be consistent to ensure correct tax calculation.

            Found:
            - VAT category (IBT-118) = '<value-of select="cac:TaxCategory/cbc:ID"/>'
            - VAT rate (IBT-119) = '<value-of select="cac:TaxCategory/cbc:Percent"/>'

            Expected: VAT rate must align with the defined rules for the specified VAT category.

            Action: Correct the VAT rate or adjust the VAT category to match applicable tax rules.
        </diagnostic>

        
        <diagnostic id="d-057">
            Context: Allowance/Charge calculation requires consistent parameters for correct invoice computation.

            Found:
            - Base amount (IBT-093) = '<value-of select="cbc:BaseAmount"/>'
            - Percentage (IBT-094) = '<value-of select="cbc:MultiplierFactorNumeric"/>'

            Expected: Either both base amount and percentage must be provided, or both must be absent.

            Action: Provide both values for calculation or remove both to avoid inconsistent allowance/charge logic.
        </diagnostic>

        
        <diagnostic id="d-E-01">
            VAT Breakdown Error - Category 'E' (Exempt)

            Context:
            An invoice containing lines, allowances, or charges with VAT category 'E' must have exactly one VAT breakdown (IBG-23) for that category.

            Found:
            - Breakdown Count: '<value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E'])"/>'
            - Invoice Type: '<value-of select="$txnTypeLabel"/>'

            Expected:
            - Full Invoice: Exactly 1 breakdown.
            - Simplified Invoice: 0 or 1 breakdown (Must be unique).

            Action:
            If this is a Full Invoice, ensure a VAT breakdown for category 'E' is provided. If you provided multiple breakdowns for 'E', merge them into a single unique block.
        </diagnostic>

        <diagnostic id="d-O-01">
            VAT Breakdown Error - Category 'O' (Out of Scope)

            Context:
            Supplies classified as 'O' require a unique VAT breakdown entry to summarize the non-taxable taxable amounts.

            Found:
            - Breakdown Count: '<value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O'])"/>'
            - Invoice Type: '<value-of select="$txnTypeLabel"/>'

            Expected:
            Exactly 1 unique breakdown (except for Simplified Invoices where it is optional).

            Action:
            Verify that category 'O' is represented by exactly one unique subtotal block. Remove any duplicate 'O' breakdown entries.
        </diagnostic>

        <diagnostic id="d-Z-01">
            VAT Breakdown Error - Category 'Z' (Zero Rated)

            Context:
            Zero-rated supplies must be summarized in exactly one VAT breakdown (IBG-23) to satisfy Oman Tax Authority reporting requirements.

            Found:
            - Breakdown Count: '<value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z'])"/>'

            Expected:
            Exactly 1 breakdown for category 'Z' if zero-rated items exist in the lines.

            Action:
            Ensure a single VAT breakdown with Category 'Z' and Percent '0' is present. If duplicates exist, consolidate the amounts into one block.
        </diagnostic>

        <diagnostic id="d-S-01">
            VAT Breakdown Error - Category 'S' (Standard Rated)

            Context:
            Standard-rated items (5%) require a corresponding VAT breakdown. Each unique VAT rate used in the lines MUST have exactly one unique breakdown block.

            Found:
            - Breakdown Count for 'S': '<value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='S'])"/>'

            Expected:
            For each distinct VAT rate (IBT-119), exactly one breakdown MUST exist.

            Action:
            Check for missing or duplicate 'S' category breakdowns. If you have multiple lines at the same 5% rate, they must all be summed into a single 'S' breakdown block.
        </diagnostic>

        
        <diagnostic id="d-E-05">
            Context: VAT category 'E' (Exempt) must not carry any VAT percentage at line level.

            Found:
            Invoice line ID: '<value-of select="cbc:ID"/>'
            VAT category (IBT-151): '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>'
            VAT rate (IBT-152): '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>'

            Expected: VAT rate must be absent for VAT category 'E'.

            Action: Remove VAT rate for VAT category 'E' or correct VAT classification if rate is required.
        </diagnostic>

        <diagnostic id="d-O-05">
            Context: VAT category 'O' (Out of scope) must not include a VAT percentage at line level.

            Found: VAT rate (IBT-152) = '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>'.

            Expected: No VAT rate must be provided for VAT category 'O'.

            Action: Remove VAT rate for VAT category 'O' or reclassify VAT category if taxable.
        </diagnostic>

        <diagnostic id="d-S-05">
            Invoice line '<value-of select="cbc:ID"/>'

            VAT category (IBT-151): 'S' (Standard rated)

            Found:
            VAT rate (IBT-152): '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>'

            Expected:
            VAT rate must be 5.

            Action:
            Set VAT rate to 5.
        </diagnostic>

        <diagnostic id="d-Z-05">
            Context: VAT category 'Z' (Zero-rated) requires strict consistency between VAT category and VAT rate.

            Found: VAT rate (IBT-152) = '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>' while VAT category (IBT-151) = 'Z'.

            Expected: When VAT category is 'Z' (Zero-rated), the VAT rate must be 0.

            Action: Set VAT rate to 0 or verify whether the VAT category has been incorrectly classified as zero-rated.
        </diagnostic>

        <diagnostic id="d-SR-12">
            Seller VAT Identifier (IBT-031): 
            found <value-of select="                 count(                     .//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme                     [cac:TaxScheme/cbc:ID = 'VAT']                     /cbc:CompanyID                 )             "/> occurrence(s). 
            Expected: at most 1 occurrence. 
            Action: ensure only one VAT identifier is provided for the seller.
        </diagnostic>

        
        <diagnostic id="d-E-08">
            VAT breakdown (IBG-23) – Category 'E' (Exempt)

            Found:
            - Taxable amount (IBT-116): '<value-of select="cbc:TaxableAmount"/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'E'.

            Action:
            Verify that all invoice lines with VAT category 'E' are correctly aggregated into the VAT breakdown.
        </diagnostic>

        <diagnostic id="d-E-09">
            VAT breakdown (IBG-23) – Category 'E' (Exempt)

            Found:
            - VAT amount (IBT-117): '<value-of select="cbc:TaxAmount"/>'

            Expected:
            VAT amount must be 0 for exempt supplies.

            Action:
            Set VAT amount to 0 for VAT category 'E'.
        </diagnostic>

        <diagnostic id="d-O-08">
            VAT breakdown (IBG-23) – Category 'O' (Out of scope)

            Found:
            - Taxable amount (IBT-116): '<value-of select="cbc:TaxableAmount"/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'O'.

            Action:
            Verify that all invoice lines with VAT category 'O' are correctly aggregated into the VAT breakdown.
        </diagnostic>

        <diagnostic id="d-O-09">
            VAT breakdown (IBG-23) – Category 'O' (Out of scope)

            Found:
            - VAT amount (IBT-117): '<value-of select="cbc:TaxAmount"/>'

            Expected:
            VAT amount must be 0 for out-of-scope supplies.

            Action:
            Set VAT amount to 0 for VAT category 'O'.
        </diagnostic>

        <diagnostic id="d-Z-08">
            VAT breakdown (IBG-23) – Category 'Z' (Zero rated)

            Found:
            - Taxable amount (IBT-116): '<value-of select="cbc:TaxableAmount"/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'Z'.

            Action:
            Verify that all invoice lines with VAT category 'Z' are correctly aggregated into the VAT breakdown.
        </diagnostic>

        <diagnostic id="d-Z-09">
            VAT breakdown (IBG-23) – Category 'Z' (Zero rated)

            Found:
            - VAT amount (IBT-117): '<value-of select="cbc:TaxAmount"/>'

            Expected:
            VAT amount must be 0 for zero-rated supplies.

            Action:
            Set VAT amount to 0 for VAT category 'Z'.
        </diagnostic>

        <diagnostic id="d-S-08">
            VAT breakdown (IBG-23) – Category 'S' (Standard rated)

            Found:
            - Taxable amount (IBT-116): '<value-of select="cbc:TaxableAmount"/>'
            - VAT rate (IBT-119): '<value-of select="cac:TaxCategory/cbc:Percent"/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'S'.

            Action:
            Verify that all invoice lines with VAT category 'S' are correctly aggregated into the VAT breakdown.
        </diagnostic>

        <diagnostic id="d-S-09">
            VAT breakdown (IBG-23) – Category 'S' (Standard rated)

            Found:
            - VAT amount (IBT-117): '<value-of select="cbc:TaxAmount"/>'
            - VAT rate (IBT-119): '<value-of select="cac:TaxCategory/cbc:Percent"/>'

            Expected:
            VAT amount must equal taxable amount multiplied by VAT rate, including correct rounding.

            Action:
            Recalculate VAT amount using (Taxable Amount × VAT Rate ÷ 100) and apply correct rounding.
        </diagnostic>

        <diagnostic id="d-S-10">
            VAT category (IBT-118) – 'S' (Standard rated)

            Found:
            - VAT exemption reason: '<value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/>'

            Expected:
            VAT exemption reason must not be provided for standard-rated supplies.

            Action:
            Remove the VAT exemption reason for VAT category 'S'.
        </diagnostic>


        <diagnostic id="d-IBR-001">
            Invoice transaction type (BTOM-001)

            Found:
            '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected:
            A 20-character binary string (only 0 and 1).

            Action:
            Provide a valid 20-character binary transaction type.
        </diagnostic>

        <diagnostic id="d-IBR-002">
            Invoice UUID (BTOM-002)

            Found:
            '<value-of select="cbc:UUID"/>'

            Expected:
            A valid identifier containing only letters, digits, and hyphens.

            Action:
            Correct the UUID format to include only allowed characters.
        </diagnostic>

        <diagnostic id="d-IBR-003">
            VAT identifier (IBT-031)

            Found:
            '<value-of select="."/>'

            Expected:
            12 alphanumeric characters starting with 'OM'.

            Action:
            Provide a valid VAT identifier (e.g., OMXXXXXXXXXX).
        </diagnostic>

        <diagnostic id="d-IBR-004">
            Currency exchange rate (BTOM-003)

            Found:
            - Invoice currency: '<value-of select="cbc:DocumentCurrencyCode"/>'

            Expected:
            Exchange rate must be provided when invoice currency differs from 'OMR'.

            Action:
            Provide the currency exchange rate when using a non-OMR invoice currency.
        </diagnostic>

        <diagnostic id="d-IBR-005">
            Currency exchange rate (BTOM-003)

            Found:
            '<value-of select="cac:TaxExchangeRate/cbc:CalculationRate"/>'

            Expected:
            Maximum of 7 decimal places.

            Action:
            Round or truncate the exchange rate to 7 decimal places.
        </diagnostic>

        <diagnostic id="d-IBR-006">
            Seller VAT identifier (IBT-031)

            Found:
            - Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected:
            VAT identifier must be provided unless exempted by the transaction type.

        </diagnostic>

        <diagnostic id="d-IBR-007">
            TxnType: '<value-of select="$txnType"/>'

            Match result: '<value-of select="matches(normalize-space(string($txnType)),'00000000000010000000|00000000100000000000|00000000001000000000|00000000000001000000')"/>'

            Supplier ID exists: '<value-of select="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID)"/>'

            Supplier ID with scheme: '<value-of select="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID])"/>'

        </diagnostic>

        <diagnostic id="d-IBR-009">
            Tax Scheme Validation Error.
            
            Exact Path: /<value-of select="$fullXPath"/>
            Scheme Found: '<value-of select="cac:TaxScheme/cbc:ID"/>'
            
            Context:
            - If Supplier: One VAT scheme is mandatory; duplicates are forbidden.
            - If Buyer: Exactly one scheme is allowed, and it must be VAT.
            - If Category: Must be VAT.
        </diagnostic>

        <diagnostic id="d-IBR-010">
            Seller postal address (IBG-05) is incomplete. 

            Found: 
            - address line 1: '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>',
            - address line 2: '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>', 
            - address line 3: '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>', 
            - city: '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>', 
            - postal code: '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>'. 

            Expected: address lines, city, and postal code must be provided. 

            Action: complete seller postal address.
        </diagnostic>

        <diagnostic id="d-IBR-011">
            Expected:
            Seller Telephone number must be provided, always.

            Action:
            Provide a Seller Telephone number.
        </diagnostic>

        <diagnostic id="d-IBR-012">
            Deliver-to Country Code (IBT-080) conflict.
            
            Found: '<value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"/>'
            Transaction Type: Export with Export of Service reason.
            
            Expected:
            Deliver-to country must not be 'OM' (Oman) for export of services.
            
            Action:
            Provide a valid destination country code other than 'OM'.
        </diagnostic>

        <diagnostic id="d-IBR-013">
            Supporting document reference (IBT-122) and UUID (BTOM-023)

            Found:
            Missing supporting document reference and/or UUID

            Expected:
            Both IBT-122 (Document reference) and BTOM-023 (UUID) must be provided for re-export of goods.

            Action:
            Include both document reference and UUID for the re-export transaction.
        </diagnostic>

        <diagnostic id="d-IBR-014">
            Deliver-to country code (IBT-080)

            Found:
            Not provided

            Expected:
            Deliver-to country code must be provided for export transactions.

            Action:
            Populate IBT-080 with the applicable country code.
        </diagnostic>

        <diagnostic id="d-IBR-015">
            Third-party invoice configuration.

            Found:
            None or multiple third-party party structures

            Expected:
            Exactly one set of third-party details must be provided.
            Location: cac:AccountingSupplierParty/cac:Party/cac:AgentParty
            UBL 2.1 Spec: https://www.datypic.com/sc/ubl21/e-cac_Party.html or see PINT OM Web Spec.

            Action:
            Ensure one and only one third-party party structure is present.
        </diagnostic>

        <diagnostic id="d-IBR-016">
            Buyer identification (IBT-046 / IBT-048)

            Found:
            - Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            - Buyer identifier (IBT-046): '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>'
            - Buyer VATIN (IBT-048): '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>'

            Expected:
            At least one of the following must be provided:
            - Buyer identifier (IBT-046)
            - Buyer VATIN (IBT-048)

            Action:
            Provide either IBT-046 or IBT-048.
        </diagnostic>

        <diagnostic id="d-IBR-017">
            Buyer VATIN (IBT-048)

            Found:
            - Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            - Buyer VATIN (IBT-048): '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>'

            Expected:
            Buyer VATIN (IBT-048) must be provided for this transaction type.

            Action:
            Populate IBT-048 with a valid VAT identification number.
        </diagnostic>

        <diagnostic id="d-IBR-019">
            Buyer postal address (IBG-08)

            Found:
            - Address line 1: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>'
            - Address line 2: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>'
            - Address line 3: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>'
            - City: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>'
            - Postal code: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>'

            Expected:
            Buyer postal address must include at minimum: address lines, city, and postal code.

            Action:
            Complete the buyer postal address with all mandatory components.
        </diagnostic>

        <diagnostic id="d-IBR-020">
            Buyer country validation

            Found:
            '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>'

            Expected:
            Buyer country must be 'OM'.

            Action:
            Set the buyer country code to 'OM'.
        </diagnostic>

        <diagnostic id="d-IBR-023">
            Credit/Debit note reason (BTOM-032)

            Found:
            Invoice type: '<value-of select="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>'

            Expected:
            A valid adjustment reason must be provided for all credit and debit notes.

            Action:
            Populate BTOM-032 with a valid credit/debit note reason.
        </diagnostic>

        <diagnostic id="d-IBR-030">
            Invoice type code validation

            Found:
            '<value-of select="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>'

            Expected:
            Value must be from UNTDID 1001 code list subset.

            Action:
            Use a valid invoice or credit note type code.
        </diagnostic>

        <diagnostic id="d-IBR-032">
            Preceding invoice reference (IBG-03)

            Found:
            Missing one or more preceding invoice reference components

            Expected:
            IBT-025 (reference), IBT-026 (issue date), and BTOM-031 (UUID) must all be present.

            Action:
            Provide complete preceding invoice reference details.
        </diagnostic>

        <diagnostic id="d-IBR-033">
            Allowance calculation validation

            Found:
            - Base: '<value-of select="cbc:BaseAmount"/>'
            - Percentage: '<value-of select="cbc:MultiplierFactorNumeric"/>'
            - Amount: '<value-of select="cbc:Amount"/>'

            Expected:
            Amount must equal Base × (Percentage / 100).

            Action:
            Recalculate allowance/charge amount using correct formula and rounding rules.
        </diagnostic>

        <diagnostic id="d-IBR-034">
            VAT accounting currency (IBT-006)

            Found:
            '<value-of select="cbc:TaxCurrencyCode"/>'

            Expected:
            VAT accounting currency must be provided when invoice currency is not 'OMR'.

            Action:
            Populate IBT-006 with the correct VAT accounting currency.
        </diagnostic>

        <diagnostic id="d-IBR-035">
            Conditional base amount requirement

            Found:
            Percentage: '<value-of select="cbc:MultiplierFactorNumeric"/>'

            Expected:
            Base amount must be present when a percentage is provided.

            Action:
            Provide cbc:BaseAmount when cbc:MultiplierFactorNumeric is used.
        </diagnostic>

        <diagnostic id="d-IBR-036">
            Invoicing period validation

            Found:
            - Start: '<value-of select="cac:InvoicePeriod/cbc:StartDate"/>'
            - End: '<value-of select="cac:InvoicePeriod/cbc:EndDate"/>'

            Expected:
            Start and end dates must be within the same calendar month.

            Action:
            Adjust invoicing period to a single month.
        </diagnostic>

        <diagnostic id="d-IBR-037">
            Invoicing period completeness

            Found:
            Missing start and/or end date

            Expected:
            Both start and end dates must be provided.

            Action:
            Populate cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate.
        </diagnostic>

        <diagnostic id="d-IBR-038">
            Line-level VAT validation

            Found:
            - VAT amount missing at line level

            Expected:
            VAT amount must be present unless invoice qualifies as simplified.

            Action:
            Provide VAT amount for each invoice line.
        </diagnostic>

        <diagnostic id="d-IBR-039">
            Exempt VAT validation

            Found:
            - VAT amount: '<value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>'
            - Category: '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>'

            Expected:
            VAT amount must be 0 for exempt supplies.

            Action:
            Set VAT amount to 0 for exempt items.
        </diagnostic>

        <diagnostic id="d-IBR-040">
            Delivery address validation (e-commerce supply)

            Found:
            - Address line 1: '<value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"/>'
            - Address line 2: '<value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"/>'
            - Address line 3: '<value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"/>'
            - City: '<value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"/>'
            - Postal code: '<value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"/>'

            Expected:
            Delivery address must include address lines, city, and postal code.

            Action:
            Complete the delivery postal address.
        </diagnostic>

        <diagnostic id="d-IBR-041">
            Context: Percentage-based charge or allowance requires a base amount for calculation.

            Found: Base amount is missing while percentage is provided.

            Expected: If a percentage value is present, the corresponding base amount must also be present and non-empty.

            Action: Provide the base amount used for percentage calculation to ensure correct computation of the charge/allowance.
        </diagnostic>

        <diagnostic id="d-IBR-042">
            Context: Charge reason classification requires a valid code from the UNCL7161 code list.

            Found: Missing charge reason code.

            Expected: A valid charge reason code must be present and conform to UNCL7161.

            Action: Populate the charge reason code using an appropriate value from UNCL7161 code list.
        </diagnostic>

        <diagnostic id="d-IBR-043">
            Context: Transaction type encoding must follow BTOM bit pattern rules.

            Found: Transaction type = '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: The transaction type bit pattern must have either the first or second bit set to '1'.

            Action: Correct the transaction type value to comply with BTOM-001 bit-level encoding rules.
        </diagnostic>

        <diagnostic id="d-IBR-045">
            Context: Standard-rated VAT charges must use a fixed VAT rate.

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'

            Expected: VAT rate must be exactly 5% for standard-rated charges.

            Action: Set VAT rate to 5% or revise tax category if misclassified.
        </diagnostic>

        <diagnostic id="d-IBR-046">
            Context: VAT rate value validation for all tax categories.

            Found: '<value-of select="."/>' is not a valid VAT rate.

            Expected: VAT rate must be numeric between 0 and 100 with up to two decimal places.

            Action: Provide a valid numeric VAT rate within allowed range and precision constraints.
        </diagnostic>

        <diagnostic id="d-IBR-047">
            Context: Standard-rated allowances must follow VAT rate consistency rules.

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'

            Expected: VAT rate must be exactly 5% for standard-rated allowances.

            Action: Set VAT rate to 5% or ensure allowance is correctly classified.
        </diagnostic>

        <diagnostic id="d-IBR-053">
            Invalid VAT rate for standard VAT breakdown.

            Found: 
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be 5 for standard VAT breakdown.

            Fix: Set the VAT rate to 5%.
        </diagnostic>

        <diagnostic id="d-IBR-054">
            Invalid VAT amount for 'Not subject to VAT'.

            Found: 
            - VAT amount: '<value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>'.
            - Category code: '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>'.

            Expected: VAT amount must be zero for items not subject to VAT.

            Fix: Set the VAT amount to 0.
        </diagnostic>

        <diagnostic id="d-IBR-055">
            Context: Tax scheme validation for taxable items or transactions.

            Found: Tax scheme is not equal to 'VAT'.

            Expected: Tax scheme identifier must be 'VAT' as per supported tax scheme code list.

            Action: Set the tax scheme identifier to 'VAT' or correct the tax scheme mapping in the source system.
        </diagnostic>

        <diagnostic id="d-IBR-056">
            Context: Item classification scheme must conform to the required product classification standard.

            Found: Item classification scheme = '<value-of select="cbc:ItemClassificationCode/@listID"/>'.

            Expected: Item classification scheme identifier must be 'HS' (Harmonized System classification).

            Action: Update the item classification scheme to 'HS' or ensure correct mapping from product master data.
        </diagnostic>

        <diagnostic id="d-IBR-058">
            Prepayment flag: '<value-of select="$isPrepayment"/>'

            Prepaid amount present: '<value-of select="exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount)"/>'
            Value: '<value-of select="cac:LegalMonetaryTotal/cbc:PrepaidAmount"/>'

            Originator ID present: '<value-of select="exists(cac:OriginatorDocumentReference/cbc:ID)"/>'
            Value: '<value-of select="cac:OriginatorDocumentReference/cbc:ID"/>'

            Originator UUID present: '<value-of select="exists(cac:OriginatorDocumentReference/cbc:UUID)"/>'
            Value: '<value-of select="cac:OriginatorDocumentReference/cbc:UUID"/>'
        </diagnostic>

        <diagnostic id="d-IBR-059">
            Exchange rate currency mismatch.

            Found:
            - TaxExchangeSourceCurrency: '<value-of select="cac:TaxExchangeRate/cbc:SourceCurrencyCode"/>'.
            - TaxExchangeTargetCurrency:  '<value-of select="cac:TaxExchangeRate/cbc:TargetCurrencyCode"/>'.
            - Invoice Currency:   '<value-of select="$invoiceCurrency"/>'.
            - Tax Currency:    '<value-of select="$taxCurrency"/>'.

            Expected: Source and target currencies must align with invoice and accounting currencies.

            Fix: Correct the exchange rate currencies to match the invoice and VAT accounting currencies.
        </diagnostic>

        <diagnostic id="d-IBR-061">
            Context: VAT category 'Not subject to VAT' must not carry a VAT rate.

            Found: VAT rate is present for VAT category 'Not subject to VAT'.

            Expected: VAT rate must be absent when VAT category indicates 'Not subject to VAT'.

            Action: Remove the VAT rate value or correct the VAT category if the transaction is taxable.
        </diagnostic>

        <diagnostic id="d-IBR-062">
            Context: VAT exemption justification is mandatory for exempt or zero-rated transactions.

            Found: Missing VAT exemption reason for allowance.

            Expected: VAT exemption reason must be provided when VAT category is 'E' (Exempt) or 'Z' (Zero-rated).

            Action: Populate a valid VAT exemption reason code or description for the allowance.
        </diagnostic>

        <diagnostic id="d-IBR-063">
            Context: Charge amount must be mathematically consistent with base amount and percentage.

            Found: Charge amount does not match calculated value using base and percentage.

            Expected: Charge amount must equal Base Amount × (Percentage / 100), where percentage-based calculation applies.

            Action: Recalculate and correct the charge amount to ensure consistency with base and percentage values, applying required rounding rules.
        </diagnostic>

        <diagnostic id="d-IBR-064">
            Context: VAT exemption justification is required for exempt or zero-rated charges.

            Found: Missing VAT exemption reason for charge.

            Expected: VAT exemption reason must be provided when VAT category is 'E' (Exempt) or 'Z' (Zero-rated).

            Action: Populate a valid VAT exemption reason code or description for the charge.
        </diagnostic>

        <diagnostic id="d-IBR-065">
            Context: Tax amount must be correctly converted into accounting currency using exchange rate rules.

            Found: Tax amount in accounting currency is inconsistent or incorrectly calculated.

            Expected: Tax amount must be derived using the applicable exchange rate and compliant rounding rules.

            Action: Recalculate tax amount using the correct exchange rate and ensure rounding aligns with accounting currency precision rules.
        </diagnostic>

        <diagnostic id="d-IBR-066">
            Missing VAT breakdown details for foreign currency invoice.

            VAT Category: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: When invoice currency is not 'OMR' and VAT category is 'S', the VAT breakdown must include:
            - Tax amount in accounting currency
            - VAT category code
            - VAT rate

            Fix: Provide all required VAT breakdown elements for the applicable category.
        </diagnostic>

        <diagnostic id="d-IBR-067">
            VAT rate must not be provided for exempt VAT category.

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be absent when VAT category is 'E' (Exempt).

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-068">
            Context: Line-level VAT amount validation for taxable invoice lines.

            Found: Missing VAT amount at line level (cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount).

            Expected: VAT amount must be provided at line level when VAT is applicable to the invoice line.

            Action: Populate the VAT amount for the invoice line, or ensure the VAT category indicates that VAT is not applicable if no VAT amount is required.
        </diagnostic>

        <diagnostic id="d-IBR-069">
            Missing VAT exemption reason.

            Found:
            - ExemptionReasonCode: '<value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT exemption reason must be provided for categories 'E' (Exempt) or 'Z' (Zero-rated).

            Fix: Populate the exemption reason field.
        </diagnostic>

        <diagnostic id="d-IBR-070">
            Invalid VAT exemption for category 'O'.

            Found:
            - ExemptionReasonCode: '<value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT exemption details must not be provided for category 'O' (Outside scope).

            Fix: Remove any VAT exemption reason or code.
        </diagnostic>

        <diagnostic id="d-IBR-071">
            Line net amount calculation mismatch.

            Provided (IBT-131): '<value-of select="$lineExtensionAmount"/>'
            Calculated: '<value-of select="($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal"/>'

            Details:
            - Quantity (IBT-129): '<value-of select="$quantity"/>'
            - Price (IBT-146): '<value-of select="$priceAmount"/>'
            - Base quantity (IBT-149): '<value-of select="$baseQuantity"/>'
            - Charges total (IBT-141): '<value-of select="$chargesTotal"/>'
            - Allowances total (IBT-136): '<value-of select="$allowancesTotal"/>'

            Expected: Line net amount must equal
            (Quantity * (Price + Base quantity)) + Charges - Allowances,
            within an allowed tolerance of 0.02.

            Fix: Recalculate the line net amount (IBT-131) using the above components and ensure it matches the expected value.
        </diagnostic>

        <diagnostic id="d-IBR-072">
            Context: Invoice line period (IBG-26) validation for full and summary invoices.

            Found: Missing invoice line period (IBG-26).  
            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Invoice line period (IBG-26) must be provided for full and summary invoice types, including start date (IBT-134) and end date (IBT-135) for each applicable invoice line.

            Action: Populate invoice line period (start and end dates) for each invoice line where required based on invoice type.
        </diagnostic>

        <diagnostic id="d-IBR-073">
            Context: Allowance calculation parameter consistency validation.

            Found: Incomplete or inconsistent allowance calculation parameters.

            Expected: Base amount (cbc:BaseAmount) and percentage (cbc:MultiplierFactorNumeric) must either both be present or both be absent.

            Action: Ensure consistency by either providing both base amount and percentage for allowance calculation, or removing both to indicate non-calculated allowance.
        </diagnostic>

        <diagnostic id="d-IBR-074">
            Context: Allowance calculation parameter consistency validation (duplicate rule of IBR-073).

            Found: Incomplete or inconsistent allowance calculation parameters.

            Expected: Base amount (cbc:BaseAmount) and percentage (cbc:MultiplierFactorNumeric) must either both be present or both be absent.

            Action: Ensure consistency by either providing both base amount and percentage for allowance calculation, or removing both to indicate non-calculated allowance.
        </diagnostic>

        <diagnostic id="d-IBR-075">
            Item net price calculation mismatch.

            Provided net price (IBT-146): '<value-of select="$netPrice"/>'
            Calculated net price: '<value-of select="$expectedNetPrice"/>'

            Details:
            - Gross price (IBT-148): '<value-of select="$grossPrice"/>'
            - Price discount total (IBT-147): '<value-of select="$discountTotal"/>'

            Expected: Net price must equal (Gross price − Discount),
            rounded to 2 decimal places.

            Fix: Recalculate IBT-146 using:
            (IBT-148 − IBT-147), and apply rounding to 2 decimals.
        </diagnostic>

        <diagnostic id="d-IBR-076">
            Context: VAT category classification is required for invoice line taxation determination.

            Found: Missing VAT category code at invoice line level (cac:Item/cac:ClassifiedTaxCategory/cbc:ID).

            Expected: Each invoice line must include a VAT category code unless explicitly defined as out-of-scope or non-taxable under applicable VAT rules.

            Action: Populate the VAT category code for the invoice line or correct the tax treatment classification if the line is not subject to VAT.
        </diagnostic>

        <diagnostic id="d-IBR-077">
            Invalid VAT amount for zero-rated item.

            Found:
            - VAT amount: '<value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>'.
            - Category code: '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>'.

            Expected: VAT amount must be zero for zero-rated supplies.

            Fix: Set the VAT amount to 0.
        </diagnostic>

        <diagnostic id="d-IBR-078">
            Context: Item type classification is required for proper invoice line-level product identification.

            Found: Item type is missing or not provided at invoice line level (cac:Item/cac:CommodityClassification/cbc:NatureCode).

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Item type must be provided for standard invoice types unless the document is explicitly classified as a simplified invoice under applicable billing rules.

            Action: Populate the item type (commodity classification nature code) or verify that the invoice qualifies as a simplified invoice where item-level classification is not required.
        </diagnostic>

        <diagnostic id="d-IBR-079">
            Missing classification code for goods.

            Found:
            - Item type: '<value-of select="cac:Item/cac:CommodityClassification/cbc:NatureCode"/>'.
            - ClassificationCode: '<value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>'.

            Expected: Goods items must include a valid classification code.

            Fix: Provide the appropriate classification code for the goods item.
        </diagnostic>

        <diagnostic id="d-IBR-080">
            Context: Commodity classification code must comply with minimum structural requirements.

            Found: Classification code length = '<value-of select="string-length(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode)"/>'

            Expected: Classification code must be at least 12 digits in length and conform to the required industrial classification standard.

            Action: Provide a valid classification code with a minimum length of 12 digits or correct the mapping from the product master data source.
        </diagnostic>

        <diagnostic id="d-IBR-081">
            Context: Industrial classification code is required for item-level product classification.

            Found: Missing industrial classification code (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode).

            Expected: Industrial classification code must be provided where applicable according to product classification rules.

            Action: Populate the industrial classification code or verify whether the item is exempt from classification requirements.
        </diagnostic>

        <diagnostic id="d-IBR-082">
            Context: Invoice total consistency validation across all monetary components.

            Found: Total amount due does not match expected calculation.

            Value observed: '<value-of select="cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription"/>'
            Our Calculation: '<value-of select="sum((cac:InvoiceLine | cac:CreditNoteLine)/cac:ItemPriceExtension/cbc:Amount)"/>'
            Difference: '<value-of select="xs:decimal(sum((cac:InvoiceLine | cac:CreditNoteLine)/cac:ItemPriceExtension/cbc:Amount) - cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription)"/>'

            Expected: Total amount due (BTOM-020) must equal Total amount including VAT (BTOM-017) adjusted for all applicable charges, allowances, and rounding rules.

            Action: Recalculate the total payable amount ensuring consistency across VAT, charges, allowances, and rounding rules.
        </diagnostic>

        <diagnostic id="d-IBR-084">
            Context: Country of origin is mandatory for import transactions involving goods.

            Found: Country of origin missing or empty (cac:Item/cac:OriginCountry/cbc:IdentificationCode = '<value-of select="cac:Item/cac:OriginCountry/cbc:IdentificationCode"/>').

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Country of origin (IBT-159) must be provided for import-related transactions.

            Action: Populate the country of origin for the goods or verify whether the transaction is correctly classified as an import.
        </diagnostic>

        <diagnostic id="d-IBR-085">
            Import Goods flag: '<value-of select="$isImportGoods"/>'

            Shipment present: '<value-of select="exists(cac:Delivery/cac:Shipment)"/>'

            Import date (ActualDeliveryDate): '<value-of select="exists(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate)"/>'
            Value: '<value-of select="cac:Delivery/cac:Shipment/cbc:ActualDeliveryDate"/>'

            Customs Declaration number (Shipment ID): '<value-of select="exists(cac:Delivery/cac:Shipment/cbc:ID)"/>'
            Value: '<value-of select="cac:Delivery/cac:Shipment/cbc:ID"/>'

            Incoterms (DeliveryTerms ID): '<value-of select="exists(cac:Delivery/cac:DeliveryTerms/cbc:ID)"/>'
            Value: '<value-of select="cac:Delivery/cac:DeliveryTerms/cbc:ID"/>'
        </diagnostic>

        <diagnostic id="d-IBR-086">
            Context: VAT category validation for profit margin scheme self-invoices.

            Found: VAT category = '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>'

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: VAT category must be 'O' (Outside scope) for profit margin self-invoices.

            Action: Set VAT category code to 'O' or verify whether the transaction qualifies under profit margin scheme rules.
        </diagnostic>

        <diagnostic id="d-IBR-087">
            Context: Seller country validation for profit margin self-invoices.

            Found: Seller country code = '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>'

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Seller country code (IBT-040) must be 'OM' for profit margin self-invoice scenarios.

            Action: Correct the seller country code to 'OM' or verify transaction eligibility under profit margin self-invoice rules.
        </diagnostic>

        <diagnostic id="d-IBR-091">
            Invalid item classification code for profit margin invoice.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            Classification code (IBT-158): '<value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>'

            Expected: For profit margin transactions, the classification code must NOT start with any of the following prefixes:
            '7101', '7102', '7103', '7104', '01', '06'.

            Fix: Update the classification code so that it does not begin with a prohibited prefix for profit margin invoices.
        </diagnostic>

        <diagnostic id="d-IBR-092">
            Invalid VAT rate for allowance (VAT category 'E' – Exempt).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for exempt allowances.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-093">
            Invalid VAT rate for allowance (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for allowances outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-094">
            Invalid VAT rate for allowance (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be 0 for zero-rated allowances.

            Fix: Set the VAT rate to 0.
        </diagnostic>

        <diagnostic id="d-IBR-095">
            Invalid VAT rate in accounting currency (VAT category 'E' – Exempt).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for exempt VAT breakdown entries.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-096">
            Invalid VAT rate in accounting currency (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for VAT breakdown entries outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-097">
            Invalid VAT rate in accounting currency (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be 0 for zero-rated VAT breakdown entries.

            Fix: Set the VAT rate to 0.
        </diagnostic>

        <diagnostic id="d-IBR-098">
            Invalid VAT rate for charge (VAT category 'E' – Exempt).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for exempt charges.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-099">
            Invalid VAT rate for charge (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for charges outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-100">
            Invalid VAT rate for charge (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be 0 for zero-rated charges.

            Fix: Set the VAT rate to 0.
        </diagnostic>

        <diagnostic id="d-IBR-101">
            Invalid VAT rate in accounting currency (VAT category 'E' – Exempt).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for exempt VAT breakdown entries.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-102">
            Invalid VAT rate in accounting currency (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must not be provided for VAT breakdown entries outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </diagnostic>

        <diagnostic id="d-IBR-103">
            Invalid VAT rate in accounting currency (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be 0 for zero-rated VAT breakdown entries.

            Fix: Set the VAT rate to 0.
        </diagnostic>

        <diagnostic id="d-IBR-104">
            Invalid VAT rate for standard-rated VAT category.

            Found:
            - Percent: '<value-of select="cac:TaxCategory/cbc:Percent"/>'.
            - Category code: '<value-of select="cac:TaxCategory/cbc:ID"/>'.

            Expected: VAT rate must be 5 when VAT category is 'S' (Standard-rated).

            Fix: Set the VAT rate to 5%.
        </diagnostic>

        <diagnostic id="d-IBR-136">
            Invalid currency for VAT accounting amounts.

            VAT accounting currency (IBT-006): '<value-of select="cbc:TaxCurrencyCode"/>'

            Found VAT totals:
            - All TaxTotal currencies: '<value-of select="string-join(cac:TaxTotal/cbc:TaxAmount/@currencyID, ', ')"/>'
            - VAT breakdown currencies: '<value-of select="string-join(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/@currencyID, ', ')"/>'

            Expected: One TaxTotal must use the VAT accounting currency (IBT-006), and all its VAT amounts must use the same currency.

            Fix:
            - Ensure a TaxTotal exists with currencyID = IBT-006
            - Ensure all related VAT breakdown amounts use the same currency.
        </diagnostic>

        <diagnostic id="d-IBR-137">
            Negative value not allowed.

            Found negative values:
            '<value-of select="string-join(//*[                  self::cbc:TaxExclusiveAmount or                 self::cbc:TaxInclusiveAmount or                 self::cbc:AllowanceTotalAmount or                 self::cbc:ChargeTotalAmount or                 self::cbc:PrepaidAmount or                 self::cbc:PayableAmount or                 self::cbc:Amount or                 self::cbc:PriceAmount or                 self::cbc:BaseAmount or                 self::cbc:Quantity or                 self::cbc:BaseQuantity or                 self::cbc:CreditedQuantity or                  self::cbc:TaxAmount or                  self::cbc:LineExtensionAmount             ][                 normalize-space(.) != ''                  and . castable as xs:decimal                  and xs:decimal(.) &lt; 0             ], ', ')"/>'

            Expected: Amounts and quantities must be zero or positive.

            Fix: Ensure all monetary amounts and quantities are non-negative.
        </diagnostic>

        <diagnostic id="d-IBR-138">
            Context: Self-billed invoices must follow strict transaction type isolation rules.

            Found: Self-billed invoice is combined with additional transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Self-billed invoices must not be combined with any other transaction classification or transaction modifier.

            Action: Use only the self-billed transaction type and remove all conflicting transaction flags.
        </diagnostic>

        <diagnostic id="d-IBR-139">
            Context: Transaction type classification must be mutually exclusive at invoice level.

            Found: Invoice contains both self-billed and third-party indicators.

            Expected: An invoice must be classified as either self-billed or third-party, but not both.

            Action: Remove conflicting classification and retain only one valid transaction type.
        </diagnostic>

        <diagnostic id="d-IBR-140">
            Context: Summary invoices must not be combined with incompatible transaction categories.

            Found: Summary invoice combined with additional transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Summary invoices must not be combined with continuous supply, export, profit margin, or import of goods transaction types.

            Action: Remove incompatible transaction types and ensure summary invoice is used in isolation.
        </diagnostic>

        <diagnostic id="d-IBR-141">
            Context: Continuous supply invoices require strict transaction type separation.

            Found: Continuous supply invoice combined with incompatible transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Continuous supply invoices must not be combined with summary invoices, deemed supply, or profit margin transaction types.

            Action: Remove incompatible transaction classifications and retain only valid continuous supply designation.
        </diagnostic>

        <diagnostic id="d-IBR-142">
            Context: Export invoices must comply with defined transaction compatibility rules.

            Found: Export invoice combined with potentially incompatible transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Export invoices must only be used with transaction types that are explicitly compatible under export processing rules.

            Action: Ensure only valid export-compatible transaction classifications are applied.
        </diagnostic>

        <diagnostic id="d-IBR-143">
            Context: Deemed supply transactions must follow strict transaction-type isolation rules.

            Found: Deemed supply transaction combined with additional transaction classifications.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Deemed supply must not be combined with any incompatible transaction types.

            Action: Ensure deemed supply is used as a standalone transaction classification without additional conflicting types.
        </diagnostic>

        <diagnostic id="d-IBR-144">
            Context: Import of services (reverse charge mechanism) requires exclusive transaction classification.

            Found: Import of services (RCM) combined with other transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Import of services (RCM) must not be combined with incompatible transaction types.

            Action: Ensure RCM import of services is used as a standalone classification or correctly separated from other transaction types.
        </diagnostic>

        <diagnostic id="d-IBR-145">
            Context: Profit margin invoices require isolated transaction classification.

            Found: Profit margin invoice combined with other transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Profit margin invoices must not be combined with incompatible transaction types.

            Action: Ensure profit margin invoice is used as a standalone transaction classification.
        </diagnostic>

        <diagnostic id="d-IBR-146">
            Context: Profit margin self-invoices must follow strict exclusivity rules.

            Found: Profit margin self-invoice combined with additional transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Profit margin self-invoices must not be combined with any incompatible transaction types.

            Action: Ensure profit margin self-invoice is used as a standalone transaction classification.
        </diagnostic>

        <diagnostic id="d-IBR-147">
            Context: Import of goods transactions require strict classification isolation.

            Found: Import of goods combined with other transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Import of goods must not be combined with incompatible transaction types.

            Action: Ensure import of goods is used as a standalone transaction classification.
        </diagnostic>

        <diagnostic id="d-IBR-148">
            Context: E-commerce supplies have strict incompatibility rules with profit margin self-invoices.

            Found: E-commerce supply combined with profit margin self-invoice classification.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: E-commerce supplies must not be combined with profit margin self-invoice transaction types.

            Action: Remove conflicting classification and retain a single valid transaction type.
        </diagnostic>

        <diagnostic id="d-IBR-149">
            Context: Simplified tax invoices must remain a standalone transaction classification.

            Found: Simplified tax invoice combined with additional transaction types.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Simplified tax invoices must not be combined with any other transaction types.

            Action: Use only the simplified tax invoice type and remove all conflicting classifications.
        </diagnostic>

        <diagnostic id="d-IBR-150">
            Missing subdivision codes for special zone supply.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            Buyer subdivision (BTOM-026): '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>'
            Seller subdivision (BTOM-024): '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>'

            Expected: When transaction type is Special Zone supply, both buyer and seller subdivision codes must be provided from code list CL-13-OM.

            Fix: Populate valid subdivision codes for both buyer and seller.
        </diagnostic>

        <diagnostic id="d-IBR-151">
            Missing or invalid seller special zone identifier.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            Seller subdivision (BTOM-024): '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>'
            Found scheme: '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/>'

            Expected: When special zone applies and seller subdivision is not 'MO', seller identifier must use scheme 'Special Zone License Number'.

            Fix: Provide seller identifier with scheme 'Special Zone License Number'.
        </diagnostic>

        <diagnostic id="d-IBR-152">
            Missing or invalid buyer special zone identifier.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'.
            Buyer subdivision (BTOM-026): '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>'.
            Found scheme: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/>'.

            Expected: When special zone applies and buyer subdivision is not 'MO', buyer identifier must use scheme 'Special Zone License Number'.

            Fix: Provide buyer identifier with scheme 'Special Zone License Number'.
        </diagnostic>

       <diagnostic id="d-IBR-153">
            Missing or invalid buyer importer identifier.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'.
            Found scheme: '<value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/>'.

            Expected: For import of goods, buyer identifier must use scheme 'Importer Customs ID'.

            Fix: Provide buyer identifier with scheme 'Importer Customs ID'.
        </diagnostic>

        <diagnostic id="d-IBR-155">
            Context: Export of services requires mandatory service type classification for regulatory reporting.

            Found: Service type is missing or not provided (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '<value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>').

            Expected: Service type must be provided for export of services using a valid code from code list CL-12-OM.

            Action: Populate a valid service type code from CL-12-OM or verify correct classification of the exported service.
        </diagnostic>

        <diagnostic id="d-IBR-156">
            Context: Delivery date must comply with standardized ISO date format requirements.

            Found: Invalid date format in ActualDeliveryDate = '<value-of select="cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate"/>'

            Expected: Date must conform to ISO 8601 format (YYYY-MM-DD).

            Action: Correct the date format to comply with ISO 8601 standard.
        </diagnostic>

        <diagnostic id="d-IBR-157">
            Net price calculation mismatch.

            Found:
            - Gross price (IBT-148): '<value-of select="cac:Price/cac:AllowanceCharge/cbc:BaseAmount"/>'
            - Discount (IBT-147): '<value-of select="sum(cac:Price/cac:AllowanceCharge/cbc:Amount)"/>'
            - Net price (IBT-146): '<value-of select="cac:Price/cbc:PriceAmount"/>'

            Expected:
            Net price = Gross price - Discount

            Fix:
            Recalculate the net price to ensure:
            IBT-146 = IBT-148 - IBT-147
        </diagnostic>

        <diagnostic id="d-IBR-158">
            Total amount including VAT mismatch.

            Found:
            - Total including VAT (BTOM-017): '<value-of select="cac:ItemPriceExtension/cbc:Amount"/>'
            - Line net amount (IBT-131): '<value-of select="cbc:LineExtensionAmount"/>'
            - VAT amount (BTOM-016): '<value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>'

            Expected:
            Total including VAT = Line net amount + VAT amount

            Exception:
            This rule does not apply for profit margin invoices.

            Fix:
            Recalculate the total to ensure:
            BTOM-017 = IBT-131 + BTOM-016
        </diagnostic>

        <diagnostic id="d-IBR-160">
            Context: Seller country validation for import of services under reverse charge mechanism (RCM).

            Found: Seller country code = '<value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>'

            Expected: For import of services (RCM), the seller country must not be 'OM' as per jurisdictional classification rules.

            Action: Correct the seller country code to a valid non-'OM' country of establishment or verify whether the transaction is incorrectly classified as an import of services.
        </diagnostic>

        <diagnostic id="d-IBR-168">
            Line VAT amount calculation mismatch.

            Found:
            - Line net amount (IBT-131): '<value-of select="cbc:LineExtensionAmount"/>'.
            - VAT rate (IBT-152): '<value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>'.
            - VAT amount (BTOM-016): '<value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>'.

            Expected:
            VAT amount = Line net amount × VAT rate ÷ 100

            Fix:
            Recalculate VAT amount to ensure:
            BTOM-016 = IBT-131 × IBT-152 ÷ 100
        </diagnostic>

        <diagnostic id="d-IBR-169">
            Context: Profit margin invoices require a fixed accounting currency to ensure regulatory consistency and correct tax computation.

            Found: Currency value = '<value-of select="cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID"/>'.

            Expected: Total amount due currency must be 'OMR' for profit margin invoices.

            Action: Set the invoice currency (BT-5 / total amount due currency) to 'OMR' or correct the profit margin classification if a different currency is intended.
        </diagnostic>

        <diagnostic id="d-IBR-171">
            Invoice issue date is in the future.

            Found:
            - Issue date (IBT-002): '<value-of select="cbc:IssueDate"/>'
            - Current date: '<value-of select="current-date()"/>'

            Expected:
            Issue date must be less than or equal to the current date.

            Fix:
            Ensure the invoice issue date is not set in the future.
        </diagnostic>

        <diagnostic id="d-IBR-172">
            Invalid exchange rate usage.
            Found:
            - Invoice currency: '<value-of select="$invoiceCurrency"/>'
            - Exchange rate: '<value-of select="cac:TaxExchangeRate/cbc:CalculationRate"/>'
            Expected: Exchange rate must not be provided when invoice currency is 'OMR'.

            Fix: Remove the exchange rate.
        </diagnostic>

        <diagnostic id="d-IBR-173">
            Missing seller UUID.

            Found:
            - Buyer electronic address (IBT-049): '<value-of select="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>'
            - Seller UUID (BTOM-004): '<value-of select="cac:AccountingSupplierParty/cbc:AdditionalAccountID"/>'

            Expected:
            When buyer electronic address is '997770000099', seller UUID must be provided.

            Fix:
            Populate Seller UUID (BTOM-004) under cac:AccountingSupplierParty/cbc:AdditionalAccountID.
        </diagnostic>

        <diagnostic id="d-IBR-174">
            Context: Item classification must comply with customs tariff classification requirements for import/export declarations.

            Found: Item classification code = '<value-of select="cac:Item/cbc:ItemClassificationCode"/>'

            Expected: Item classification identifier must be a valid Harmonized System (HS) code as required under Royal Oman Police customs classification rules.

            Action: Provide a valid HS classification code compliant with Royal Oman Police customs tariff structure or correct the product mapping in the item master data.
        </diagnostic>

        <diagnostic id="d-IBR-175">
            Missing or incomplete preceding invoice reference for profit margin invoice.

            Found:
            - Transaction type (BTOM-003): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            - Preceding invoice reference (IBT-025): '<value-of select="string-join(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID, ', ')"/>'
            - Preceding invoice UUID (BTOM-031): '<value-of select="string-join(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID, ', ')"/>'

            Expected:
            When transaction type is Profit margin invoice, at least one preceding invoice reference must include both:
            - IBT-025 (Invoice reference)
            - BTOM-031 (Invoice UUID)

            Fix:
            Provide a complete preceding invoice reference with both ID and UUID.
        </diagnostic>

        <diagnostic id="d-IBR-176">
            Context: Prepayment invoice must follow strict transaction type isolation rules.

            Found: Prepayment invoice combined with incompatible transaction types.

            Expected: Prepayment invoices must not be combined with summary invoices, deemed supply transactions, or profit margin self-invoice classifications.

            Action: Remove incompatible transaction types and ensure prepayment invoice is used as a standalone or correctly scoped transaction classification.
        </diagnostic>

        <diagnostic id="d-IBR-177">
            Context: Invoice type and transaction type must follow a validated compatibility matrix.

            Found: Invoice type is not aligned with the configured transaction type classification rules.

            Expected: Invoice type must be compatible with its associated transaction types, such as self-billed, import of services (RCM), profit margin self-invoice, or import of goods.

            Action: Adjust either the invoice type or transaction classification to ensure compliance with the allowed compatibility matrix.
        </diagnostic>
    </diagnostics>
</schema>