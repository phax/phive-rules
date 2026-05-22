<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <title>PINT Oman E-Invoice Validation Rules (IBR-OM)</title>
    <p>

        * Author:    Susheel Kumar (OpenPeppol)
        * Version:   1.0.0
        * Authority: Tax Authority Oman
        * Scope:     Validation of VAT-compliant e-invoices under Oman regulations.
        * Notes:     Includes business rules, tax validations, and calculation consistency checks.

        *** This Schematron has been designed to provide enhanced guidance for each validation error.
        *** In addition to reporting the failure, it includes diagnostic information that helps explain the cause of the error and supports users in resolving it effectively.
        *** Each business rule emits a stable Rule-ID, a structured diagnostic (Why / Found / Expected / Action) and where applicable a `see` link to the controlling specification section.

        ======*****************************************************************************======

        Transaction Type: '<value-of select="$txnType"/>': '<value-of select="$txnTypeLabel"/>'

        ======*****************************************************************************======
    </p>
    <p>
        Change log: see the project history (git log / VERSION.md) for previous
        revisions. This file always documents the current ruleset only.
    </p>
   <xsl:function name="u:vatBase" as="xs:decimal">
    <xsl:param name="cat" as="xs:string"/>
    <xsl:param name="lines" as="element()*"/>
    <xsl:param name="allow" as="element()*"/>
    <xsl:param name="charge" as="element()*"/>
    <xsl:sequence select="           sum($lines [cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $cat]                 /cbc:LineExtensionAmount/xs:decimal(.))         - sum($allow [cac:TaxCategory/cbc:ID = $cat]/cbc:Amount/xs:decimal(.))         + sum($charge[cac:TaxCategory/cbc:ID = $cat]/cbc:Amount/xs:decimal(.))"/>
</xsl:function>

   <xsl:function name="u:to-decimal" as="xs:decimal">
        <xsl:param name="val"/>
        <xsl:sequence select="if (normalize-space(string($val)) castable as xs:decimal)                              then xs:decimal(normalize-space(string($val)))                              else 0.0"/>
    </xsl:function>

    
    <xsl:function name="u:slack" as="xs:boolean">
        <xsl:param name="exp" as="xs:decimal?"/>
        <xsl:param name="val" as="xs:decimal?"/>
        <xsl:param name="slack" as="xs:decimal"/>
        <xsl:sequence select="             if (empty($exp) or empty($val))             then false()             else abs($exp - $val) &lt;= $slack"/>
    </xsl:function>

    
    <xsl:function name="u:isZeroOrEmpty" as="xs:boolean">
        <xsl:param name="n" as="node()*"/>
        <xsl:sequence select="             empty($n)             or normalize-space(string($n[1])) = ''             or (normalize-space(string($n[1])) castable as xs:decimal                 and xs:decimal(normalize-space(string($n[1]))) = 0)"/>
    </xsl:function>

    
    <xsl:function name="u:hasValidDecimal" as="xs:boolean">
        <xsl:param name="n" as="node()*"/>
        <xsl:sequence select="             exists($n)             and normalize-space(string($n[1])) != ''             and normalize-space(string($n[1])) castable as xs:decimal"/>
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
    <let name="isValidBitString" value="matches($txnType, '^[X1]{20}$')"/>
    <let name="txnSafe" value="if ($isValidBitString) then $txnType else 'XXXXXXXXXXXXXXXXXXXX'"/>
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
    

    
    
    
    
    
    
    
    
    <let name="standardVatRate" value="xs:decimal('5')"/>
    <let name="amountTolerance" value="xs:decimal('0.01')"/>
    <let name="sevenDecimalScale" value="xs:decimal('10000000')"/>

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    <let name="debugMode" value="false()"/>

    <phase id="AlignedPhase">
        <active pattern="Aligned-om-rules"/>
    </phase>
    <phase id="AlignedPhaseCode">
        <active pattern="AlignedCodelists"/>
    </phase>
    <phase id="full">
        <active pattern="Aligned-om-rules"/>
        <active pattern="AlignedCodelists"/>
    </phase>
    
    <phase id="debug">
        <active pattern="Aligned-om-rules"/>
        <active pattern="AlignedCodelists"/>
    </phase>
    <pattern id="Aligned-om-rules">
        <title>PINT Oman - business rules and calculation consistency</title>

        
        
        
        
        
        
        
        
        
        
        
        <rule context="/">
            
            <assert id="BTOM-PRE-001" flag="fatal" role="fatal" diagnostics="d-BTOM-PRE-001" test="*[local-name() = ('Invoice','CreditNote')                        and namespace-uri() = (                             'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',                             'urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2')]">
                [BTOM-PRE-001] - Document root MUST be a UBL 2.1 Invoice or CreditNote in the correct namespace. Found '<value-of select="local-name(*[1])"/>' in namespace '<value-of select="namespace-uri(*[1])"/>'.
            </assert>
        </rule>

        
        <rule context="ubl:Invoice | cn:CreditNote">

            
            
            
            
            
            
            
            
            
            <report id="BTOM-META-001" test="true()" role="information" diagnostics="d-BTOM-META-001">
                [PINT-OM-META] Ruleset version 1.0.0 - Authority: Tax Authority Oman.
            </report>

            
            <report test="$debugMode" role="information">
                [DOC-SUMMARY]
                DocType:        <value-of select="local-name($doc)"/>
                Transaction:    <value-of select="$txnType"/> (<value-of select="$txnTypeLabel"/>)
                InvoiceCurr:    <value-of select="$invoiceCurrency"/>
                TaxCurr:        <value-of select="$taxCurrency"/>
                LineCount:      <value-of select="count($lines)"/>
                SumLines:       <value-of select="sum($lines/cbc:LineExtensionAmount/xs:decimal(.))"/>
                SumAllowances:  <value-of select="sum($allowances/cbc:Amount/xs:decimal(.))"/>
                SumCharges:     <value-of select="sum($charges/cbc:Amount/xs:decimal(.))"/>
                TaxExclusive:   <value-of select="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>
                TaxInclusive:   <value-of select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"/>
                Payable:        <value-of select="cac:LegalMonetaryTotal/cbc:PayableAmount"/>
                Subtotals:      <value-of select="                                     string-join(                                         for $c in ('S','Z','E','O')                                         return concat($c, '=', count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID=$c])),                                         ' / ')"/>
            </report>
            
            
            

            <let name="customizationID" value="normalize-space(cbc:CustomizationID)"/>
            <let name="profileID" value="normalize-space(cbc:ProfileID)"/>
            
            <assert id="ALIGNED-IBRP-000-OM" flag="fatal" role="fatal" test="$txnType != '' and $isValidBitString and contains($txnType, '1')" diagnostics="d-000">[ALIGNED-IBRP-000-OM] - Transaction type (BTOM-001) must be present and must be a 20-character bitmap of '1' and '0' with at least one '1' marking an active transaction type.</assert>

            
            
            <assert id="ALIGNED-IBRP-001-OM" flag="fatal" role="fatal" test="starts-with($customizationID, 'urn:peppol:pint:billing-1@om-1')" diagnostics="d-001">[ALIGNED-IBRP-001-OM] - Specification identifier (IBT-024) MUST start with the value 'urn:peppol:pint:billing-1@om-1'.</assert>

            
            
            <assert id="ALIGNED-IBRP-002-OM" flag="fatal" role="fatal" test="starts-with($profileID, 'urn:peppol:bis:billing')" diagnostics="d-002">[ALIGNED-IBRP-002-OM] - Business process (IBT-023) must follow the expected format 'urn:peppol:bis:billing'.</assert>

            
            
            <assert id="ALIGNED-IBRP-003-OM" flag="fatal" role="fatal" test="not($taxCurrency != '') or $taxCurrency = 'OMR'" diagnostics="d-003">[ALIGNED-IBRP-003-OM] - VAT accounting currency (IBT-006) must be 'OMR' for VAT reporting.</assert>

            
            
            <assert id="ALIGNED-IBRP-016-OM" flag="fatal" role="fatal" test="exists(cbc:IssueTime)" diagnostics="d-016">[ALIGNED-IBRP-016-OM] - An invoice must have an Invoice Issue Time (IBT-168).</assert>
            
            <assert id="ALIGNED-IBRP-E-01-OM" flag="fatal" role="fatal" test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='E'] or                          $allowances[cac:TaxCategory/cbc:ID='E'] or                          $charges[cac:TaxCategory/cbc:ID='E']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) &lt;= 1)                     )" diagnostics="d-E-01">[ALIGNED-IBRP-E-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "E" MUST contain exactly one VAT breakdown (IBG-23) with the VAT category code (IBT-118) equal to "E" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "E".</assert>
            
            
            
            
            <assert id="ALIGNED-IBRP-O-01-OM" flag="fatal" role="fatal" test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='O'] or                          $allowances[cac:TaxCategory/cbc:ID='O'] or                          $charges[cac:TaxCategory/cbc:ID='O']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) &lt;= 1)                     )" diagnostics="d-O-01">[ALIGNED-IBRP-O-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "O" MUST contain exactly one VAT breakdown group (IBG-23) with the VAT category code (IBT-118) equal to "O" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "O".</assert>

            
            
            
            
            <assert id="ALIGNED-IBRP-Z-01-OM" flag="fatal" role="fatal" test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z'] or                         $allowances[cac:TaxCategory/cbc:ID='Z'] or                         $charges[cac:TaxCategory/cbc:ID='Z']                     ) or (                         (not($isSimplified) and count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) = 1) or                         ($isSimplified and count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) &lt;= 1)                     )" diagnostics="d-Z-01">[ALIGNED-IBRP-Z-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "Z" MUST contain in the VAT breakdown (IBG-23) exactly one VAT category code (IBT-118) equal with "Z" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "Z".</assert>

            
            
            
            
            <assert id="ALIGNED-IBRP-SR-12" flag="fatal" role="fatal" test="count(                         cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme                         [cac:TaxScheme/cbc:ID = 'VAT']                         /cbc:CompanyID                     ) &lt;= 1" diagnostics="d-SR-12">[ALIGNED-IBRP-SR-12] - Seller VAT Identifier (IBT-031) must occur at most once.</assert>

            
            
            
            <assert id="ALIGNED-IBRP-S-01-OM" flag="fatal" role="fatal" test="every $rate in distinct-values(($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='S']/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent,                                               $allowances[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent,                                               $charges[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent))               satisfies count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='S' and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)]) = 1" diagnostics="d-S-01">[ALIGNED-IBRP-S-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "S" MUST contain in the VAT breakdown (IBG-23) at least one VAT category code (IBT-118) equal with "S".</assert>

            
            <assert id="ALIGNED-IBRP-S-05-OM" flag="fatal" role="fatal" test="not($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S']) or                         (every $line in $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S'] satisfies                         ($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal and                         xs:decimal($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = $standardVatRate))" diagnostics="d-S-05">[ALIGNED-IBRP-S-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "S" the Invoiced item VAT rate (IBT-152) MUST be 5.</assert>
            
            <assert id="IBR-001-OM" flag="fatal" role="fatal" test="string-length($txnType) = 20 and matches($txnType, '^[X1]{20}$')" diagnostics="d-IBR-001">[IBR-001-OM] - Invoice transaction type (BTOM-001) must be a 20-character string consisting only of '1' and '0'.</assert>
                    
            
            <assert id="IBR-002-OM" flag="fatal" role="fatal" test="matches(normalize-space(cbc:UUID),                   '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$')" diagnostics="d-IBR-002">[IBR-002-OM] - The unique identifier (“UUID”) (BTOM-002) must be provided on the invoice and must contain only letters, digits, and dashes.</assert>
            
            <assert id="IBR-004-OM" flag="fatal" role="fatal" test="$invoiceCurrency = 'OMR' or exists($exchangeRate)" diagnostics="d-IBR-004">[IBR-004-OM] - Currency exchange rate (BTOM-003) MUST be provided when the Invoice currency code (IBT-005) is not equal to 'OMR'.</assert>
            
            <assert id="IBR-005-OM" flag="fatal" role="fatal" test="not($taxCurrency='OMR' and $invoiceCurrency!='OMR')                         or (exists($exchangeRate)                             and $exchangeRate = round($exchangeRate * $sevenDecimalScale) div $sevenDecimalScale)" diagnostics="d-IBR-005">[IBR-005-OM] - Currency exchange rate (BTOM-003) should contain the values till maximum of 7 decimal places when the VAT accounting currency (IBT-006) is set to OMR and the invoice currency code (IBT-005) differs from OMR.</assert>
            
            <assert id="IBR-006-OM" flag="fatal" role="fatal" test="$isImportGoods or $isImportRCM or $isProfitMarginSelf                   or cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID" diagnostics="d-IBR-006">[IBR-006-OM] - Seller tax identifier (IBT-031) MUST be mandatory in all cases except when Invoice transaction type (BTOM-001) is an invoice for import of goods (XXXXXXXXXXXX1XXXXXXX), import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX).</assert>
            
            <assert id="IBR-007-OM" flag="fatal" role="fatal" test="not($isImportGoods or $isImportRCM or $isProfitMarginSelf or $isSpecialZone) or cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" diagnostics="d-IBR-007">[IBR-007-OM] - Seller identifier (IBT-029) Scheme identifier (IBT-029-1) must be provided when Invoice transaction type (BTOM-001) is an invoice for import of goods (XXXXXXXXXXXX1XXXXXXX) or import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX) or Special zone supplies (XXXXXXXXXXXXX1XXXXXX).</assert>
            
            <assert id="IBR-010-OM" flag="fatal" role="fatal" test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone                    and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" diagnostics="d-IBR-010">[IBR-010-OM] - In Seller postal address (IBG-05), Seller address line 1 (IBT-035), Seller address line 2 (IBT-036), Seller address line 3 (IBT-162) Seller city (IBT-037) and Seller postal code (IBT-038) must be provided.</assert>
            
            <assert id="IBR-011-OM" flag="fatal" role="fatal" test="cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone" diagnostics="d-IBR-011">[IBR-011-OM] - In Seller Contact (IBG-06), Seller contact telephone number (IBT-042) must be provided.</assert>
            
            <assert id="IBR-012-OM" flag="fatal" role="fatal" test="not($isExport and $lines//cbc:TaxExemptionReasonCode = 'VATZR-OM-09')                   or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode != 'OM'" diagnostics="d-IBR-012">[IBR-012-OM] - Deliver to country code (IBT-080) must not be 'OM' if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and at least one VAT exemption reason code (IBT-121) is 'Export of service (VATZR-OM-09)'.</assert>
            
            <assert id="IBR-013-OM" flag="fatal" role="fatal" test="not($isExport and $lines//cbc:TaxExemptionReasonCode ='VATZR-OM-12')                          or (exists($doc/cac:AdditionalDocumentReference                             [not(cbc:DocumentTypeCode='130')]                             [cbc:ID and cbc:UUID]))" diagnostics="d-IBR-013">[IBR-013-OM] - Supporting document reference (IBT-122) and Supporting document UUID (BTOM-023) must be provided if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and at least one VAT exemption reason code (IBT-121) is 'Re-export of goods (VATZR-OM-12)'.</assert>
            
            <assert id="IBR-014-OM" flag="fatal" role="fatal" test="not($isExport)                   or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode" diagnostics="d-IBR-014">[IBR-014-OM] - Deliver to country code (IBT-080) must be provided if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-015-OM" flag="fatal" role="fatal" test="                 not($isThirdParty)                 or (                     count(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) = 1                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyName/cbc:Name                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:StreetName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:AdditionalStreetName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:AddressLine/cbc:Line                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:CityName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:PostalZone                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)" diagnostics="d-IBR-015">[IBR-015-OM] - Third Party Name (BTOM-005), Third Party VATIN (BTOM-006), VAT Scheme Code (BTOM-06-1), Third Party Address Line 1 (BTOM-007), Third Party Address Line 2 (BTOM-008), Third Party Address Line 3 (BTOM-009), Third party city (BTOM-010), Third party postal code (BTOM-011) and Third Party Country Code (BTOM-13) must be provided when Invoice transaction type (BTOM-001) is Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) and MUST occur only once.</assert>
            
            <assert id="IBR-016-OM" flag="fatal" role="fatal" test="not($isFullTax or $isThirdParty or $isSummary or $isContinuous or $isExport or $isProfitMargin or $isEcommerce)                   or (cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                       or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)" diagnostics="d-IBR-016">[IBR-016-OM] - Either Buyer identifier (IBT-046) or Buyer VATIN (IBT-048) MUST be present when the Invoice transaction type (BTOM-001) is a Full tax invoice (1XXXXXXXXXXXXXXXXXXX) OR Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) OR Summary invoice (XXXX1XXXXXXXXXXXXXXX) OR Continuous supply (XXXXX1XXXXXXXXXXXXXX) OR Export Invoice (XXXXXX1XXXXXXXXXXXXX) OR Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) OR E-commerce supplies (XXXXXXXXXXX1XXXXXXXX).</assert>
            
            <assert id="IBR-017-OM" flag="fatal" role="fatal" test="not($isSelfBilled or $isImportRCM or $isProfitMarginSelf or $isImportGoods)                   or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID" diagnostics="d-IBR-017">[IBR-017-OM] - Buyer VATIN (IBT-048) MUST be present when the Invoice transaction type (BTOM-001) is a Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-019-OM" flag="fatal" role="fatal" test="not($isFullTax or $isThirdParty or $isSelfBilled or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSpecialZone or $isSummary)                   or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)" diagnostics="d-IBR-019">[IBR-019-OM] - Buyer address line 1 (IBT-050), Buyer address line 2 (IBT-051), Buyer address line 3 (IBT-163), Buyer city (IBT-052) and Buyer post code (IBT-053) MUST be present when the Invoice transaction type (BTOM-001) is a Full tax invoice (1XXXXXXXXXXXXXXXXXXX) AND/OR Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), or Profit margin (XXXXXXXXX1XXXXXXXXXX) invoice or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Special zone supplies (XXXXXXXXXXXXX1XXXXXX) or summary invoice (XXXX1XXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-020-OM" flag="fatal" role="fatal" test="not($isSelfBilled or $isImportRCM or $isProfitMarginSelf or $isImportGoods)                   or cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'" diagnostics="d-IBR-020">[IBR-020-OM] - Buyer country code (IBT-055) MUST be 'OM' when the Invoice transaction type (BTOM-001) is a Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-023-OM" flag="fatal" role="fatal" test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261')                   or cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode" diagnostics="d-IBR-023">[IBR-023-OM] - Where the Invoice type code [IBT-003] is '381' or '383' or '261', Credit Note or Debit Note reason code (BTOM-032) MUST be provided.</assert>
            
            <assert id="IBR-032-OM" flag="fatal" role="fatal" test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261')                   or (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID                       and cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate                       and cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)" diagnostics="d-IBR-032">[IBR-032-OM] - If Invoice type code (IBT-003) is '381' or '383' or '261', Preceding Invoice reference (IBT-025), and Preceding Invoice issue date (IBT-026), and Preceding invoice UUID (BTOM-031) MUST be present.</assert>
            
            <assert id="IBR-034-OM" flag="fatal" role="fatal" test="$invoiceCurrency = 'OMR' or ($taxCurrency != '')" diagnostics="d-IBR-034">[IBR-034-OM] - VAT accounting currency (IBT-006) must be provided if invoice currency code (IBT-005) is not equal to 'OMR'.</assert>
            
            <assert id="IBR-036-OM" flag="fatal" role="fatal" test="not($isSummary)                   or (substring(cac:InvoicePeriod/cbc:StartDate,1,7)                       = substring(cac:InvoicePeriod/cbc:EndDate,1,7))" diagnostics="d-IBR-036">[IBR-036-OM] - Invoicing period Start date (IBT-073) and Invoicing period end date (IBT-074) provided must belong to the same calendar month where Invoice transaction type code (BTOM-001) is a summary invoice (XXXX1XXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-037-OM" flag="fatal" role="fatal" test="not($isSummary or $isContinuous)                   or (cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate)" diagnostics="d-IBR-037">[IBR-037-OM] - Invoicing period start date (IBT-073) and the Invoicing period end date (IBT-074) must be provided where Invoice transaction type code (BTOM-001) is a summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-040-OM" flag="fatal" role="fatal" test="not($isEcommerce)                   or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode                        and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line)" diagnostics="d-IBR-040">[IBR-040-OM] - Deliver to address line 1 - Postal code (IBT-075), Deliver to address line 2 - Postal code area (IBT-076), Deliver to address line 3 - Area (IBT-165), Deliver to city (IBT-077), Deliver to post code - PO Box(IBT-078), Deliver to country code (IBT-080) MUST be present when the Invoice transaction type (BTOM-001) is E-commerce supplies (XXXXXXXXXXX1XXXXXXXX).</assert>

            
            
            <assert id="IBR-043-OM" flag="fatal" role="fatal" test="substring($txnType,1,1)='1' or substring($txnType,2,1)='1'" diagnostics="d-IBR-043">[IBR-043-OM] - Either the first or second position of Invoice Transaction type (BTOM-001) must always be 1.</assert>
            
            <assert id="IBR-058-OM" flag="fatal" role="fatal" test="not(exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount))                         or (exists(cac:OriginatorDocumentReference/cbc:ID)                             and exists(cac:OriginatorDocumentReference/cbc:UUID))" diagnostics="d-IBR-058">[IBR-058-OM] - Prepayment invoice number (BTOM-027) and Prepayment invoice UUID (BTOM-014) must be provided if Paid amount (IBT-180) is present.</assert>
            
            <assert id="IBR-059-OM" flag="fatal" role="fatal" test="not($exchangeRate)                   or (cac:TaxExchangeRate/cbc:SourceCurrencyCode=$invoiceCurrency                       and cac:TaxExchangeRate/cbc:TargetCurrencyCode=$taxCurrency)" diagnostics="d-IBR-059">[IBR-059-OM] - The source currency must be designated as the invoice currency code (IBT-005), and the target currency must be specified as the tax accounting currency (IBT-006), provided that the currency exchange rate (BTOM-003) is available.</assert>
            
            <assert id="IBR-065-OM" flag="fatal" role="fatal" test="not($invoiceCurrency != 'OMR' and $taxCurrency = 'OMR')                         or (                             $exchangeRate castable as xs:decimal and                             u:slack(                                 xs:decimal((cac:TaxTotal[cbc:TaxAmount/@currencyID = $taxCurrency]/cbc:TaxAmount)[1]),                                 xs:decimal($exchangeRate * (cac:TaxTotal[cbc:TaxAmount/@currencyID = $invoiceCurrency]/cbc:TaxAmount)[1]),                                 0.01                             )                         )" diagnostics="d-IBR-065">[IBR-065-OM] - When Invoice currency code (IBT-005) is not equal to 'OMR' and Tax accounting currency [IBT-006] is 'OMR', then the value in Invoice total VAT amount in tax accounting currency [IBT-111] MUST be provided and must be Exchange rate (BTOM-003) multiplied by Invoice total tax amount (IBT-110).</assert>

            
            <assert id="IBR-066-OM" flag="fatal" role="fatal" test="                 not($invoiceCurrency != 'OMR'                     and $doc//cac:TaxCategory/cbc:ID = 'S')                 or                 exists(                     $doc/cac:TaxTotal[cbc:TaxAmount/@currencyID = $taxCurrency]                         /cac:TaxSubtotal[                             cbc:TaxAmount/@currencyID = $taxCurrency                             and cac:TaxCategory/cbc:ID = 'S'                             and cbc:TaxAmount                             and cac:TaxCategory/cbc:Percent                         ]                 )                 " diagnostics="d-IBR-066">[IBR-066-OM] - TAX category tax amount in accounting currency (IBT-190), TAX category code for tax category tax amount in accounting currency (IBT-192) and TAX category rate for tax category tax amount in accounting currency (IBT-193) must be provided when Invoice currency code (IBT-005) is not equal to 'OMR' and at least one TAX category code (IBT-118) is equal to 'S'.</assert>
            
            
            <assert id="IBR-082-OM" flag="fatal" role="fatal" test="not($isProfitMargin or $isProfitMarginSelf)                         or (                             cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription castable as xs:decimal                             and u:slack(                                 xs:decimal(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription),                                 xs:decimal(sum($lines/cac:ItemPriceExtension/cbc:Amount/xs:decimal(.))),                                 0.01                             )                         )" diagnostics="d-IBR-082">[IBR-082-OM] - When Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), then Total Amount Due (BTOM-020), should be provided and is mandatory and must be the sum of Total amount including VAT (BTOM-017).</assert>
            
            <assert id="IBR-085-OM" flag="fatal" role="fatal" test="                 not($isImportGoods)                 or                 (                     cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate                     and cac:Delivery/cac:Shipment/cbc:ID                     and cac:Delivery/cac:DeliveryTerms/cbc:ID                 )                 " diagnostics="d-IBR-085">[IBR-085-OM] - If invoice transaction type (BTOM-001) is 'Import of Goods' (XXXXXXXXXXXX1XXXXXXX), then Import date (BTOM-030), Custom Declaration number (BTOM-021) and Incoterms (BTOM-022).MUST be present.</assert>
            
            
            <assert id="IBR-087-OM" flag="fatal" role="fatal" test="not($isProfitMarginSelf)                 or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'" diagnostics="d-IBR-087">[IBR-087-OM] - In case Invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice' (XXXXXXXXXX1XXXXXXXXX), Seller Country Code (IBT-040) MUST be 'OM'.</assert>
            
            
            
            
            
            <assert id="IBR-136-OM" flag="fatal" role="fatal" test="not($taxCurrency != '') or                          (some $total in cac:TaxTotal satisfies                              ($total/cbc:TaxAmount/@currencyID = $taxCurrency and                              (every $sub in $total/cac:TaxSubtotal/cbc:TaxAmount satisfies $sub/@currencyID = $taxCurrency))                         )" diagnostics="d-IBR-136">[IBR-136-OM] - CurrencyID must match VAT accounting currency (IBT-006) for VAT accounting amounts.</assert>
            
            <assert id="IBR-137-OM" flag="fatal" role="fatal" test="not(                             (                               descendant::cbc:TaxExclusiveAmount                             | descendant::cbc:TaxInclusiveAmount                             | descendant::cbc:AllowanceTotalAmount                             | descendant::cbc:ChargeTotalAmount                             | descendant::cbc:PrepaidAmount                             | descendant::cbc:PayableAmount                             | descendant::cbc:Amount                             | descendant::cbc:PriceAmount                             | descendant::cbc:BaseAmount                             | descendant::cbc:Quantity                             | descendant::cbc:BaseQuantity                             | descendant::cbc:InvoicedQuantity                             | descendant::cbc:CreditedQuantity                             | descendant::cbc:TaxAmount                             | descendant::cbc:LineExtensionAmount                             )                             [                                 local-name() != 'PayableRoundingAmount'                                 and normalize-space(.) != ''                                 and . castable as xs:decimal                                 and xs:decimal(.) &lt; 0                             ]                         )" diagnostics="d-IBR-137">
                    [IBR-137-OM] - All invoice amounts and quantities shall be zero or positive, except for rounding amount (IBT-114).
                </assert>
            
            <assert id="IBR-138-OM" flag="fatal" role="fatal" test="not($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-138">[IBR-138-OM] - Invoice transaction type (BTOM-001) cannot be Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-139-OM" flag="fatal" role="fatal" test="not($isThirdParty and $isSelfBilled)" diagnostics="d-IBR-139">[IBR-139-OM] - Invoice transaction type (BTOM-001) cannot be Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-140-OM" flag="fatal" role="fatal" test="not($isSummary and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-140">[IBR-140-OM] - Invoice transaction type (BTOM-001) cannot be Summary invoice (XXXX1XXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-141-OM" flag="fatal" role="fatal" test="not($isContinuous and ($isSummary or $isDeemed or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-141">[IBR-141-OM] - Invoice transaction type (BTOM-001) cannot be Continuous supply (XXXXX1XXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-142-OM" flag="fatal" role="fatal" test="not($isExport and ($isSelfBilled or $isSummary or $isDeemed or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-142">[IBR-142-OM] - Invoice transaction type (BTOM-001) cannot be Export Invoice (XXXXXX1XXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-143-OM" flag="fatal" role="fatal" test="not($isDeemed and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf))" diagnostics="d-IBR-143">[IBR-143-OM] - Invoice transaction type (BTOM-001) cannot be Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX).</assert>
            
            <assert id="IBR-144-OM" flag="fatal" role="fatal" test="not($isImportRCM and ($isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSelfBilled))" diagnostics="d-IBR-144">[IBR-144-OM] - Invoice transaction type (BTOM-001) cannot be Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-145-OM" flag="fatal" role="fatal" test="not($isProfitMargin and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isImportGoods or $isSelfBilled))" diagnostics="d-IBR-145">[IBR-145-OM] - Invoice transaction type (BTOM-001) cannot be Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-146-OM" flag="fatal" role="fatal" test="not($isProfitMarginSelf and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isProfitMargin or $isImportGoods or $isSelfBilled))" diagnostics="d-IBR-146">[IBR-146-OM] - Invoice transaction type (BTOM-001) cannot be Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) if Invoice transaction type (BTOM-001) Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-147-OM" flag="fatal" role="fatal" test="not($isImportGoods and ($isSummary or $isContinuous or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isEcommerce or $isSelfBilled))" diagnostics="d-IBR-147">[IBR-147-OM] - Invoice transaction type (BTOM-001) cannot be Import of Goods (XXXXXXXXXXXX1XXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or E-commerce supplies (XXXXXXXXXXX1XXXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-148-OM" flag="fatal" role="fatal" test="not($isEcommerce and $isProfitMarginSelf)" diagnostics="d-IBR-148">[IBR-148-OM] - Invoice transaction type (BTOM-001) cannot be E-commerce supplies (XXXXXXXXXXX1XXXXXXXX) if Invoice transaction type (BTOM-001) is Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX).</assert>
            
                
            <assert id="IBR-149-OM" flag="fatal" role="fatal" test="not($isSimplified and ($isSelfBilled or $isSummary or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))" diagnostics="d-IBR-149">[IBR-149-OM] - Invoice transaction type (BTOM-001) cannot be Simplified Tax Invoice (X1XXXXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
                
            <assert id="IBR-150-OM" flag="fatal" role="fatal" test="not($isSpecialZone)                   or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)" diagnostics="d-IBR-150">[IBR-150-OM] - If Invoice transaction type (BTOM-001) is Special Zone Supplies (XXXXXXXXXXXXX1XXXXXX) , buyer country subdivision code (BTOM-026) and Seller country subdivision code (BTOM-024) MUST be provided using the codelist for Country Subdivision (CL-13-OM).</assert>
            
            <assert id="IBR-151-OM" flag="fatal" role="fatal" test="                     not($isSpecialZone and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO')                     or                     cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName='SZLN']                     " diagnostics="d-IBR-151">[IBR-151-OM] - Seller identifier (IBT-029) is mandatory with Scheme identifier (IBT-029-1) 'SZLN' (Special Zone License Number) if Invoice transaction type (BTOM-001) is Special zone supplies (XXXXXXXXXXXXX1XXXXXX) and Seller country subdivision code (BTOM-024) is not equal to 'MO'.</assert>
            
            <assert id="IBR-152-OM" flag="fatal" role="fatal" test="                     not($isSpecialZone                         and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO'                         and normalize-space(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID) != '997770000099')                     or                     cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName='SZLN']                     " diagnostics="d-IBR-152">[IBR-152-OM] - Buyer identifier (IBT-046) is mandatory with Scheme identifier (IBT-046-1) 'SZLN' (Special Zone License Number) if Invoice transaction type (BTOM-001) is Special zone supplies (XXXXXXXXXXXXX1XXXXXX) and Buyer country subdivision code (BTOM-026) is not equal to 'MO' except when Buyer electronic address (IBT-049) is '997770000099'.</assert>
            
            <assert id="IBR-153-OM" flag="fatal" role="fatal" test="                     not($isImportGoods)                     or                     cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName='ICID']                     " diagnostics="d-IBR-153">[IBR-153-OM] - Buyer identifier (IBT-046) is mandatory with Scheme identifier (IBT-046-1) 'ICID' (Importer Customs ID) if Invoice transaction type (BTOM-001) is Import of Goods (XXXXXXXXXXXX1XXXXXXX).</assert>
            
            <assert id="IBR-155-OM" flag="fatal" role="fatal" test="not($isExport and $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode ='VATZR-OM-09'])                   or $lines[cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID[@schemeName='MP']]" diagnostics="d-IBR-155">[IBR-155-OM] - If invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and at least one VAT exemption reason code (IBT-121) is 'Export of service' then Service Type (BTOM-034) must be provided from the code list for Type of Services (CL-12-OM).</assert>
            
                
            <assert id="IBR-156-OM" flag="fatal" role="fatal" test="not(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate)                         or (matches(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate,                                     '^\d{4}-\d{2}-\d{2}$')                             and cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate                                 castable as xs:date)" diagnostics="d-IBR-156">[IBR-156-OM] - Import date (BTOM-020) MUST be formatted YYYY-MM-DD and be a valid date.</assert>
            
            <assert id="IBR-160-OM" flag="fatal" role="fatal" test="not($isImportRCM)                   or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'OM'" diagnostics="d-IBR-160">[IBR-160-OM] - Seller country code (IBT-040) MUST not be'OM' if Invoice transaction type (BTOM-001) is Import of services for RCM (XXXXXXXX1XXXXXXXXXXX).</assert>
                
                <assert id="IBR-169-OM" flag="fatal" role="fatal" test="not(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription)                               or cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID = 'OMR'" diagnostics="d-IBR-169">[IBR-169-OM] - Currency of Total amount due (profit margin) (BTOM-020) MUST be 'OMR'.</assert>

            
            
            

            
            <assert id="IBR-171-OM" flag="fatal" role="fatal" test="not(cbc:IssueDate)                     or (cbc:IssueDate castable as xs:date                         and xs:date(cbc:IssueDate)                             &lt;= xs:date(adjust-dateTime-to-timezone(current-dateTime(), xs:dayTimeDuration('PT4H'))))" diagnostics="d-IBR-171">[IBR-171-OM] - Invoice issue date (IBT-002) MUST NOT be a future date (evaluated in Asia/Muscat, UTC+04:00).</assert>
            
            <assert id="IBR-172-OM" flag="fatal" role="fatal" test="not($invoiceCurrency='OMR') or not(cac:TaxExchangeRate/cbc:CalculationRate)" diagnostics="d-IBR-172">[IBR-172-OM] - If Invoice currency code (IBT-005) is "OMR" then Exchange Rate (BTOM-003) MUST NOT be present.</assert>
            
            <assert id="IBR-173-OM" flag="fatal" role="fatal" test="                     not(normalize-space(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID) = '997770000099')                     or                     (                         normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID) != ''                         and                         matches(normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID), '^[A-Za-z0-9-]+$')                     )                     " diagnostics="d-IBR-173">[IBR-173-OM] - If Buyer electronic address (IBT-049) is '997770000099', Seller UUID (BTOM-004) MUST be present.</assert>
                 
                 <assert id="IBR-175-OM" flag="fatal" role="fatal" test="                     not($isProfitMargin)                     or                     exists(                         cac:BillingReference/cac:InvoiceDocumentReference[                             normalize-space(cbc:ID) != ''                             and normalize-space(cbc:UUID) != ''                         ]                     )                     " diagnostics="d-IBR-175">[IBR-175-OM] - If Invoice transaction type (BTOM-001) is Profit margin invoice 'XXXXXXXXX1XXXXXXXXXX', Preceding Invoice reference (IBT-025),  and Preceding invoice UUID (BTOM-031) MUST be present.</assert>
            
            <assert id="IBR-176-OM" flag="fatal" role="fatal" test="not($isPrepayment and ($isSummary or $isDeemed or $isProfitMarginSelf))" diagnostics="d-IBR-176">[IBR-176-OM] - Invoice transaction type (BTOM-001) cannot be Prepayment Invoice (XXXXXXXXXXXXXX1XXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply (XXXXXXX1XXXXXXXXXXXX) or Profit Margin Self Invoice (XXXXXXXXXX1XXXXXXXXX).</assert>
            
            <assert id="IBR-177-OM" flag="fatal" role="fatal" test="not($invoiceType=('261','389'))                   or ($isSelfBilled or $isImportRCM or $isProfitMarginSelf or $isImportGoods)" diagnostics="d-IBR-177">[IBR-177-OM] - If Invoice Type code (IBT-003) is Self billed credit note '261' or Self billed invoice '389' then Invoice transaction type (BTOM-001) MUST be either Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) OR Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) OR Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) OR Import of Goods (XXXXXXXXXXXX1XXXXXXX). </assert>
        </rule>
         <rule context="cbc:ReceivedDate | cbc:InstallmentDueDate">
            <assert id="IBR-171-A-OM" diagnostics="d-IBR-171-A" flag="fatal" role="fatal" test="string-length(text()) = 10 and (string(.) castable as xs:date)">[IBR-171-A-OM] - A date MUST be formatted YYYY-MM-DD in (IBT-177), (IBT-181), (IBT-009).</assert>
        </rule>
       
        
        <rule context="cac:TaxExchangeRate/cbc:CalculationRate">
            <assert id="IBR-DEC-07-OM" flag="fatal" role="fatal" test=". castable as xs:decimal and xs:decimal(.) = round(xs:decimal(.) * 10000000) div 10000000" diagnostics="d-IBR-DEC-07-OM">
                [IBR-DEC-07-OM] - Currency Exchange Rate (BTOM-003) MUST NOT contain more than 7 decimal places.
            </assert>
        </rule>

        <rule context="cbc:Amount              | cbc:BaseAmount              | cbc:PriceAmount              | cbc:LineExtensionAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:TaxExclusiveAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:TaxInclusiveAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:AllowanceTotalAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:ChargeTotalAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:PrepaidAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:PayableRoundingAmount[not(parent::cac:LegalMonetaryTotal)]              | cbc:PayableAmount[not(parent::cac:LegalMonetaryTotal)]              | cac:TaxTotal/cbc:TaxAmount[not(parent::cac:TaxTotal[parent::*[local-name()='Invoice' or local-name()='CreditNote']])]              | cac:TaxTotal/cbc:TaxableAmount              | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount              | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount              | cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription">

            
            <assert id="IBR-DEC-03-OM" flag="fatal" role="fatal" test=". castable as xs:decimal and xs:decimal(.) = round(xs:decimal(.) * 1000) div 1000" diagnostics="d-IBR-DEC-03-OM">
                [IBR-DEC-03-OM] (covering IBR-088-OM, IBR-109-OM..IBR-135-OM) - All amount values (including BTOM-020 Total amount due in Profit Margin) MUST NOT contain more than 3 decimal places and the exchange rate by IBR-DEC-07-OM (7 decimals).
            </assert>

</rule>

        
        
        

        
        <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal">

            
            
            

            <let name="vatCategory" value="normalize-space(cac:TaxCategory/cbc:ID)"/>

            <let name="rate" value="if (cac:TaxCategory/cbc:Percent castable as xs:decimal)                         then xs:decimal(cac:TaxCategory/cbc:Percent)                         else ()"/>

            

            
            <let name="isInvoiceCurrency" value="cbc:TaxAmount/@currencyID = $invoiceCurrency"/>

            <let name="isTaxCurrency" value="cbc:TaxAmount/@currencyID = $taxCurrency"/>

            
            
            
            
            <assert id="ALIGNED-IBRP-045" flag="fatal" role="fatal" test="not($isInvoiceCurrency) or cbc:TaxableAmount" diagnostics="d-045">[ALIGNED-IBRP-045] - Each VAT breakdown (IBG-23) MUST have a VAT category taxable amount (IBT-116).</assert>
            
            <assert id="ALIGNED-IBRP-046" flag="fatal" role="fatal" test="not($isInvoiceCurrency) or cbc:TaxAmount" diagnostics="d-046">[ALIGNED-IBRP-046] - Each VAT breakdown (IBG-23) MUST have a VAT category tax amount (IBT-117).</assert>
            
            <assert id="ALIGNED-IBRP-047" flag="fatal" role="fatal" test="not($isInvoiceCurrency) or cac:TaxCategory/cbc:ID" diagnostics="d-047">[ALIGNED-IBRP-047] - Each VAT breakdown (IBG-23) MUST be defined through a VAT category code (IBT-118).</assert>
            
            <assert id="ALIGNED-IBRP-048" flag="fatal" role="fatal" test="not($isInvoiceCurrency)                          or ($vatCategory = ('E', 'O'))                          or exists(cac:TaxCategory/cbc:Percent)" diagnostics="d-048">[ALIGNED-IBRP-048] - Each VAT breakdown (IBG-23) MUST have a VAT category rate (IBT-119), except if the Invoice is not subject to VAT.</assert>

            
            
            

            
            <assert id="ALIGNED-IBRP-E-08-OM" flag="fatal" role="fatal" test="not($isInvoiceCurrency)                     or $isSimplified                     or not($vatCategory = 'E')                     or (                             cbc:TaxableAmount castable as xs:decimal                             and u:slack(                                 xs:decimal(cbc:TaxableAmount),                                 xs:decimal(round(u:vatBase($vatCategory, $lines, $allowances, $charges) * 100) div 100),                                 $amountTolerance                             )                     )" diagnostics="d-E-08">[ALIGNED-IBRP-E-08-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is "E" the VAT category taxable amount (IBT-116) MUST be the VAT category taxable amount (IBT-116) must equal the sum of Invoice line net amounts (IBT-131) minus the sum of Document level allowance amounts (IBT-092) plus the sum of Document level charge amounts (IBT-099) where the VAT category codes (IBT-151,IBT-95, IBT-102) is “E" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "E".</assert>

            
            
            
            <assert id="ALIGNED-IBRP-E-09-OM" flag="fatal" role="fatal" test="$isSimplified                     or not($vatCategory='E')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )" diagnostics="d-E-09">[ALIGNED-IBRP-E-09-OM] - The VAT category tax amount (IBT-117) In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) equals "E" MUST equal 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) I is not required if VAT category code (IBT-118) equal to "E".</assert>

            
            
            

            
            <assert id="ALIGNED-IBRP-O-08-OM" flag="fatal" role="fatal" test="not($isInvoiceCurrency)                     or $isSimplified                     or not($vatCategory = 'O')                     or (                             cbc:TaxableAmount castable as xs:decimal                             and u:slack(                                 xs:decimal(cbc:TaxableAmount),                                 xs:decimal(round(u:vatBase($vatCategory, $lines, $allowances, $charges) * 100) div 100),                                 $amountTolerance                             )                     )" diagnostics="d-O-08">[ALIGNED-IBRP-O-08-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is " O" the VAT category taxable amount (IBT-116) MUST be equal the sum of Invoice line net amounts (IBT-131) minus the sum of Document level allowance amounts (IBT-092) plus the sum of Document level charge amounts (IBT-99) where the VAT category codes (IBT-151, IBT-095, IBT-102) are “O" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "O".</assert>

            
            
            
            <assert id="ALIGNED-IBRP-O-09-OM" flag="fatal" role="fatal" test="$isSimplified                     or not($vatCategory='O')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )" diagnostics="d-O-09">[ALIGNED-IBRP-O-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is "O" MUST be 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) is not required if VAT category code (IBT-118) equal to "O".</assert>

            

            
            
            

            
            <assert id="ALIGNED-IBRP-Z-08-OM" flag="fatal" role="fatal" test="not($isInvoiceCurrency)                     or $isSimplified                     or not($vatCategory = 'Z')                     or (                             cbc:TaxableAmount castable as xs:decimal                             and u:slack(                                 xs:decimal(cbc:TaxableAmount),                                 xs:decimal(round(u:vatBase($vatCategory, $lines, $allowances, $charges) * 100) div 100),                                 $amountTolerance                             )                     )" diagnostics="d-Z-08">[ALIGNED-IBRP-Z-08-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "Z" the VAT category taxable amount (IBT-116) MUST equal the sum of Invoice line net amount (IBT-131) minus the sum of Document level allowance amounts (IBT-92) plus the sum of Document level charge amounts (IBT-99) where the VAT category codes (IBT-151, IBT-95, IBT-102) are "Z" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "Z".</assert>
            
            
            <assert id="ALIGNED-IBRP-Z-09-OM" flag="fatal" role="fatal" test="$isSimplified                     or not($vatCategory='Z')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )" diagnostics="d-Z-09">[ALIGNED-IBRP-Z-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "Z" MUST equal 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) is not required if VAT category code (IBT-118) equal to "Z".</assert>

            
            
            

            
            <assert id="ALIGNED-IBRP-S-08-OM" flag="fatal" role="fatal" test="not($isInvoiceCurrency) or not($vatCategory = 'S') or (                         cbc:TaxableAmount castable as xs:decimal and                         cac:TaxCategory/cbc:Percent castable as xs:decimal and                         u:slack(                             xs:decimal(cbc:TaxableAmount),                             xs:decimal(round((                                 sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:LineExtensionAmount/xs:decimal(.)) +                                 sum($charges[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.)) -                                 sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.))                             ) * 100) div 100),                             $amountTolerance                         ))" diagnostics="d-S-08">[ALIGNED-IBRP-S-08-OM] - For each different value of VAT category rate (IBT-119) where the VAT category code (IBT-118) is "S", the VAT category taxable amount (IBT-116) in a VAT breakdown (IBG-23) MUST equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the VAT category code (IBT-151, IBT-102, IBT-095) is "S" and the VAT rate (IBT-152, IBT-103, IBT-096) equals the VAT category rate (IBT-119).</assert>

            
            
            
            
            <assert id="ALIGNED-IBRP-S-09-OM" flag="fatal" role="fatal" test="not($isInvoiceCurrency) or not($vatCategory = 'S') or (                             cbc:TaxAmount castable as xs:decimal                             and u:slack(                                 xs:decimal(cbc:TaxAmount),                                 xs:decimal(                                     round(                                         (                                             sum($lines[                                                     cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory                                                     and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)                                                         = xs:decimal(current()/cac:TaxCategory/cbc:Percent)                                                 ]/cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount/xs:decimal(.))                                         + sum(for $c in $charges[                                                     cac:TaxCategory/cbc:ID = $vatCategory                                                     and cac:TaxCategory/cbc:Percent castable as xs:decimal                                                     and xs:decimal(cac:TaxCategory/cbc:Percent)                                                         = xs:decimal(current()/cac:TaxCategory/cbc:Percent)                                                 ]                                                 return xs:decimal($c/cbc:Amount)                                                     * xs:decimal($c/cac:TaxCategory/cbc:Percent) div 100)                                         - sum(for $a in $allowances[                                                     cac:TaxCategory/cbc:ID = $vatCategory                                                     and cac:TaxCategory/cbc:Percent castable as xs:decimal                                                     and xs:decimal(cac:TaxCategory/cbc:Percent)                                                         = xs:decimal(current()/cac:TaxCategory/cbc:Percent)                                                 ]                                                 return xs:decimal($a/cbc:Amount)                                                     * xs:decimal($a/cac:TaxCategory/cbc:Percent) div 100)                                         ) * 100                                     ) div 100                                 ),                                 $amountTolerance                             )                         )" diagnostics="d-S-09">[ALIGNED-IBRP-S-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "S" MUST equal the Σ Invoice-line VAT amounts (BTOM-016) plus charges' VAT minus allowances' VAT, grouped by the VAT category rate (IBT-119) of this breakdown.</assert>
            
            
            
            <assert id="ALIGNED-IBRP-S-10-OM" flag="fatal" role="fatal" test="not($vatCategory='S')                     or (not(cac:TaxCategory/cbc:TaxExemptionReasonCode)                         and not(cac:TaxCategory/cbc:TaxExemptionReason))" diagnostics="d-S-10">[ALIGNED-IBRP-S-10-OM] - A VAT breakdown (IBG-23) with VAT Category code (IBT-118) "S" MUST not have a VAT exemption reason code (IBT-121) or VAT exemption reason text (IBT-120).</assert>

            
            
            
            <assert id="IBR-053-OM" flag="fatal" role="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $vatCategory = 'S')                         or (                                 $rate castable as xs:decimal                                 and xs:decimal($rate) = $standardVatRate                             )" diagnostics="d-IBR-053">[IBR-053-OM, IBR-104-OM] - If TAX category code for tax category tax amount in accounting currency (IBT-192) is 'S', TAX category rate for tax category tax amount in accounting currency (IBT-193) MUST be 5.</assert>
            
            <assert id="IBR-061-OM" flag="fatal" role="fatal" test="not($vatCategory='O') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-061">[IBR-061-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'Not Subject to VAT', VAT category tax Rate (IBT-119) shall not be provided.</assert>
            
            <assert id="IBR-067-OM" flag="fatal" role="fatal" test="not($vatCategory='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-067">[IBR-067-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'Exempt from VAT', VAT category VAT Rate (IBT-119) shall not be provided.</assert>
            
            <assert id="IBR-069-OM" flag="fatal" role="fatal" test="not($vatCategory='E' or $vatCategory='Z')                     or cac:TaxCategory/cbc:TaxExemptionReasonCode" diagnostics="d-IBR-069">[IBR-069-OM] - A VAT breakdown (IBG-23) with VAT Category code (IBT-118) "E"  and/or "Z" must have a VAT exemption reason code (IBT-121).</assert>
            
            <assert id="IBR-070-OM" flag="fatal" role="fatal" test="not($vatCategory='O')                     or not(cac:TaxCategory/cbc:TaxExemptionReasonCode)" diagnostics="d-IBR-070">[IBR-070-OM] - A VAT breakdown (IBG-23) with VAT Category code (IBT-118) "O" MUST not have a VAT exemption reason code (IBT-121).</assert>
            

            
            
            
            <assert id="IBR-095-OM" flag="fatal" role="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $vatCategory='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-095">[IBR-095-OM, IBR-101-OM] - If TAX category code for tax category tax amount in accounting currency (IBT-192) is 'E', TAX category rate for tax category tax amount in accounting currency (IBT-193) MUST not be present.</assert>
            
            <assert id="IBR-096-OM" flag="fatal" role="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $vatCategory='O')                     or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-096">[IBR-096-OM, IBR-102-OM] - If the TAX category code for tax category tax amount in accounting currency (IBT-192) is 'O', then the TAX category rate (IBT-193) MUST NOT be present.</assert>
            
            <assert id="IBR-097-OM" flag="fatal" role="fatal" test="not($taxCurrency != '' and $isTaxCurrency and $vatCategory='Z')                     or (cac:TaxCategory/cbc:Percent castable as xs:decimal                         and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)" diagnostics="d-IBR-097">[IBR-097-OM, IBR-103-OM] - If TAX category code for tax category tax amount in accounting currency (IBT-192) is 'Z', TAX category rate for tax category tax amount in accounting currency (IBT-193) MUST be 0.</assert>

        </rule>

         
        
        

        
        <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
            <let name="cat" value="normalize-space(cac:TaxCategory/cbc:ID)"/>
            
            <assert id="ALIGNED-IBRP-058" flag="fatal" role="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-058">[ALIGNED-IBRP-058] - Either both or neither Charge base amount (IBT-100) and percentage (IBT-101) MUST be provided.</assert>
            
            <assert id="IBR-042-OM" flag="fatal" role="fatal" test="cbc:AllowanceChargeReasonCode" diagnostics="d-IBR-042">[IBR-042-OM] - If Document level charge (IBG-21) is present, document level charge reason code MUST be present.</assert>
            
            <assert id="IBR-045-OM" flag="fatal" role="fatal" test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = $standardVatRate)" diagnostics="d-IBR-045">[IBR-045-OM] - If Document level charge TAX category code (IBT-102) is 'S', Document level charge TAX rate (IBT-103) MUST be 5.</assert>
            
            <assert id="IBR-064-OM" flag="fatal" role="fatal" test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode" diagnostics="d-IBR-064">[IBR-064-OM, IBR-106-OM] - Document level charge (IBG-21) with Document level charge VAT category code (IBT-102) as 'E' (Exempt) or 'Z' (Zero rated) MUST have a Document level charge VAT exemption reason code (IBT-198).</assert>

            
            
            <assert id="IBR-098-OM" flag="fatal" role="fatal" test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-098">[IBR-098-OM] - If Document level charge TAX category code (IBT-102) is 'E', Document level charge TAX rate (IBT-103) MUST not be present.</assert>
            
            <assert id="IBR-099-OM" flag="fatal" role="fatal" test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-099">[IBR-099-OM] - If Document level charge TAX category code (IBT-102) is 'O', Document level charge TAX rate (IBT-103) MUST not be present.</assert>
            
            <assert id="IBR-100-OM" flag="fatal" role="fatal" test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)" diagnostics="d-IBR-100">[IBR-100-OM] - If Document level charge TAX category code (IBT-102) is 'Z', Document level charge TAX rate (IBT-103) MUST be 0.</assert>
           
        </rule>

        
        <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']">
            <let name="cat" value="normalize-space(cac:TaxCategory/cbc:ID)"/>
            
            <assert id="ALIGNED-IBRP-057" flag="fatal" role="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-057">[ALIGNED-IBRP-057] - Either both or neither Allowance base amount (IBT-093) and percentage (IBT-094) MUST be provided.</assert>
            
            <assert id="IBR-033-OM" flag="fatal" role="fatal" test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                         or                         (                             cbc:Amount castable as xs:decimal                             and cbc:BaseAmount castable as xs:decimal                             and cbc:MultiplierFactorNumeric castable as xs:decimal                             and                             u:slack(                                 xs:decimal(cbc:Amount),                                  xs:decimal(                                     round(                                         (                                             xs:decimal(cbc:BaseAmount)                                             * xs:decimal(cbc:MultiplierFactorNumeric)                                             div 100                                         ) * 100                                     ) div 100                                 ),                                  0.01                             )                         )" diagnostics="d-IBR-033">[IBR-033-OM] - Allowance amount (IBT-092, IBT-136) must equal base amount (IBT-093, IBT-137) * percentage (IBT-094, IBT-138) /100 if base amount and percentage exists.</assert>
            
            <assert id="IBR-047-OM" flag="fatal" role="fatal" test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = $standardVatRate)" diagnostics="d-IBR-047">[IBR-047-OM] - If Document level allowance TAX category code (IBT-095) is 'S', Document level allowance TAX rate (IBT-096) MUST be 5.</assert>
            
            <assert id="IBR-062-OM" flag="fatal" role="fatal" test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode" diagnostics="d-IBR-062">[IBR-062-OM, IBR-105-OM] - Document level allowances (IBG-20) with Document level allowance VAT category code (IBT-095) as 'E' (Exempt) or 'Z' (Zero rated) MUST have a Document level allowance VAT exemption reason code (IBT-196).</assert>

            
            
            <assert id="IBR-092-OM" flag="fatal" role="fatal" test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-092">[IBR-092-OM] - If Document level allowance TAX category code (IBT-095) is 'E', Document level allowance TAX rate (IBT-096) MUST not be present.</assert>
            
            <assert id="IBR-093-OM" flag="fatal" role="fatal" test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)" diagnostics="d-IBR-093">[IBR-093-OM] - If Document level allowance TAX category code (IBT-095) is 'O', Document level allowance TAX rate (IBT-096) MUST not be present.</assert>
            
            <assert id="IBR-094-OM" flag="fatal" role="fatal" test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)" diagnostics="d-IBR-094">[IBR-094-OM] - If Document level allowance TAX category code (IBT-095) is 'Z', Document level allowance TAX rate (IBT-096) MUST be 0.</assert>
        </rule>

        
        
        <rule context="ubl:Invoice/cac:AllowanceCharge | cn:CreditNote/cac:AllowanceCharge">
            
            <assert id="IBR-041-OM" flag="fatal" role="fatal" test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount" diagnostics="d-IBR-041">[IBR-041-OM] - Document level allowance/charge base amount (IBT-093, IBT-100) must be provided when Invoice line allowance/charge percentage (IBT-094, IBT-101) is provided.</assert>
            
            <assert id="IBR-063-OM" flag="fatal" role="fatal" test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                             or                             (                                 cbc:Amount castable as xs:decimal                                 and cbc:BaseAmount castable as xs:decimal                                 and cbc:MultiplierFactorNumeric castable as xs:decimal                                 and                                 u:slack(                                     xs:decimal(cbc:Amount),                                      xs:decimal(                                         round(                                             (                                                 xs:decimal(cbc:BaseAmount)                                                 * xs:decimal(cbc:MultiplierFactorNumeric)                                                 div 100                                             ) * 100                                         ) div 100                                     ),                                      0.01                                 )                             )" diagnostics="d-IBR-063">[IBR-063-OM] - Charge amount (IBT-099, IBT-141) must equal base amount (IBT-100, IBT-142) * percentage (IBT-101, IBT-143) /100 if base amount and percentage exists</assert>
        </rule>
             
             
              
        
        <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge"> 
             
             <assert id="IBR-035-OM" flag="fatal" role="fatal" test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount" diagnostics="d-IBR-035">[IBR-035-OM] - Invoice line allowance/charge base amount (IBT-137, IBT-142) must be provided when Invoice line allowance/charge percentage (IBT-138, IBT-143) is provided.</assert>
            
            <assert id="IBR-073-OM" flag="fatal" role="fatal" test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                     or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))" diagnostics="d-IBR-073">[IBR-073-OM, IBR-074-OM] - Either both or neither Allowance base amount (IBT-137) and percentage (IBT-138), and either both or neither Charge base amount (IBT-142) and percentage (IBT-143) MUST be provided.</assert>
            </rule>
            
        
        
        
        
        <rule context="cbc:Percent">
            
            <assert id="IBR-046-OM" flag="fatal" role="fatal" test="matches(normalize-space(.), '^\d+(\.\d{1,2})?$')                      and (if (. castable as xs:decimal) then (xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100) else false())" diagnostics="d-IBR-046">[IBR-046-OM] - The VAT rates (IBT-096, IBT-103, IBT-119, IBT-152, IBT-193) if exists MUST only be numeric (without percentage symbol) ranging from 0.00 to 100.00, with maximum of two decimals.</assert>
        </rule>

        
        
        

        
        <rule context="             cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             ">
            <let name="cleanID" value="replace(normalize-space(.), '\s+', '')"/>
            
            <assert id="IBR-003-OM" flag="fatal" role="fatal" test="matches($cleanID, '^OM[0-9]{10}$')" diagnostics="d-IBR-003">[IBR-003-OM] - Seller VATIN (IBT-031), Buyer VATIN (IBT-048) and Third party VATIN (BTOM-006) MUST be 12 characters: 'OM' followed by exactly 10 digits.</assert>

        </rule>

        
        
        

        
        <rule context="cac:ClassifiedTaxCategory | cac:TaxCategory | cac:PartyTaxScheme">
            <let name="isSupplier" value="exists(ancestor::cac:AccountingSupplierParty)"/>
            <let name="isBuyer" value="exists(ancestor::cac:AccountingCustomerParty)"/>
            <let name="fullXPath" value="string-join(for $node in ancestor-or-self::* return local-name($node), '/')"/>
            
            <assert id="IBR-009-OM" flag="fatal" role="fatal" test="if (local-name() = 'TaxCategory')                              then (cac:TaxScheme/cbc:ID = 'VAT')                         else if ($isBuyer)                             then (count(../cac:PartyTaxScheme) = 1 and cac:TaxScheme/cbc:ID = 'VAT')                         else if ($isSupplier)                             then (                                 (cac:TaxScheme/cbc:ID = 'VAT' or ../cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT') and                                 (if (cac:TaxScheme/cbc:ID = 'VAT') then count(../cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']) = 1 else true())                             )                         else (cac:TaxScheme/cbc:ID = 'VAT')" diagnostics="d-IBR-009">[IBR-009-OM] - Tax scheme code, must be provided in IBT-031-1 or BTOM-006-1 or IBT-048-1 or IBT-095-1 or IBT-102-1 or IBT-118-1 or IBT-167 and shall be 'VAT'.</assert>

        </rule>

        
        
        

        
        
        

        
        <rule context="cac:InvoiceLine | cac:CreditNoteLine">
            <let name="vatCategory" value="normalize-space(cac:Item/cac:ClassifiedTaxCategory/cbc:ID)"/>

            <let name="vatRate" value="if (cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)                          else 0"/>

            <let name="lineTaxAmount" value="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>

            
            <assert id="ALIGNED-IBRP-E-05-OM" flag="fatal" role="fatal" test="not($vatCategory='E')                   or not(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)" diagnostics="d-E-05">[ALIGNED-IBRP-E-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "E" MUST not contain an Invoice item VAT rate (IBT-152).</assert>

            
            <assert id="ALIGNED-IBRP-O-05-OM" flag="fatal" role="fatal" test="not($vatCategory='O')                   or not(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)" diagnostics="d-O-05">[ALIGNED-IBRP-O-05-OM] - An Invoice line (IBG-25) where the VAT category code (IBT-151) is "O" MUST not contain an Invoiced item VAT rate (IBT-152).</assert>

            
            <assert id="IBR-039-OM" flag="fatal" role="fatal" test="not($vatCategory='E')                   or u:isZeroOrEmpty($lineTaxAmount)" diagnostics="d-IBR-039">[IBR-039-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Exempt', Line Item VAT Amount (BTOM-016) shall be zero.</assert>
            
            <assert id="IBR-054-OM" flag="fatal" role="fatal" test="not($vatCategory='O')                   or u:isZeroOrEmpty($lineTaxAmount)" diagnostics="d-IBR-054">[IBR-054-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Not Subject to VAT', Line Item VAT Amount (BTOM-016) shall be zero.</assert>
            
                
            

                
                <assert id="IBR-056-OM" flag="fatal" role="fatal" test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode)                           or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = ('HS','MP')" diagnostics="d-IBR-056">[IBR-056-OM] - The scheme identifier (IBT-158-1) MUST be 'HS' or 'MP' when Item classification identifier (IBT-158) is provided. Use 'HS' for goods (Oman HS code list) and 'MP' for services (Service Type code list, CL-12-OM).</assert>

            
            
            <assert id="ALIGNED-IBRP-Z-05-OM" flag="fatal" role="fatal" test="not($vatCategory = 'Z') or xs:decimal($vatRate) = 0" diagnostics="d-Z-05">[ALIGNED-IBRP-Z-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "Zero rated" the Invoiced item VAT rate (IBT-152) MUST be 0 (zero).</assert>

            <let name="lineExtensionAmount" value="if (cbc:LineExtensionAmount/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cbc:LineExtensionAmount)                          else 0"/>

            <let name="quantity" value="if ((cbc:InvoicedQuantity | cbc:CreditedQuantity)/normalize-space(.) castable as xs:decimal)                          then xs:decimal((cbc:InvoicedQuantity | cbc:CreditedQuantity)[1])                          else 1"/>

            <let name="priceAmount" value="if (cac:Price/cbc:PriceAmount/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cac:Price/cbc:PriceAmount)                          else 0"/>

           <let name="baseQuantity" value="                 if (cac:Price/cbc:BaseQuantity/normalize-space(.) castable as xs:decimal                      and xs:decimal(normalize-space(cac:Price/cbc:BaseQuantity)) != 0)                  then xs:decimal(normalize-space(cac:Price/cbc:BaseQuantity))                  else 1"/>

            <let name="allowancesTotal" value="if (cac:AllowanceCharge[cbc:ChargeIndicator = 'false'])                          then round(sum(                             for $amt in cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:Amount                             return if ($amt castable as xs:decimal) then xs:decimal($amt) else 0                         ) * 100) div 100                         else 0"/>

            <let name="chargesTotal" value="if (cac:AllowanceCharge[cbc:ChargeIndicator = 'true'])                          then round(sum(                             for $amt in cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:Amount                             return if ($amt castable as xs:decimal) then xs:decimal($amt) else 0                         ) * 100) div 100                         else 0"/>
            
            <assert id="IBR-071-OM" flag="fatal" role="fatal" test="u:slack(                         u:to-decimal($lineExtensionAmount),                          u:to-decimal(($quantity * (u:to-decimal($priceAmount) div $baseQuantity)) + $chargesTotal - $allowancesTotal),                          0.01)" diagnostics="d-IBR-071">[IBR-071-OM] - Invoice line net amount (IBT-131) MUST equal (Invoiced quantity (IBT-129) * (Item net price (IBT-146)/item price base quantity (IBT-149)) + Sum of invoice line charge amount (IBT-141) - sum of invoice line allowance amount (IBT-136).</assert>
            
             <let name="grossPrice" value="if (cac:Price/cbc:BaseAmount) then xs:decimal(cac:Price/cbc:BaseAmount) else 0"/>

            <let name="discountTotal" value="                 if (cac:Price/cac:AllowanceCharge/cbc:Amount)                 then sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.))                 else 0"/>

            <let name="netPrice" value="if (cac:Price/cbc:PriceAmount) then xs:decimal(cac:Price/cbc:PriceAmount) else 0"/>

            <let name="expectedNetPrice" value="                 if ($grossPrice)                 then round(($grossPrice - $discountTotal) * 100) div 100                 else 0"/>
            
            <assert id="IBR-075-OM" flag="fatal" role="fatal" test="not($grossPrice) or $netPrice = $expectedNetPrice" diagnostics="d-IBR-075">[IBR-075-OM] - Item net price (IBT-146) MUST equal (Gross price (IBT-148) - Price discount (IBT-147)) when gross price is provided.</assert>
            
            <assert id="IBR-076-OM" flag="fatal" role="fatal" test="$vatCategory" diagnostics="d-IBR-076">[IBR-076-OM] - Each Invoice line (IBG-25) MUST be categorized with an Invoiced item tax category code (IBT-151).</assert>

            
            <assert id="IBR-077-OM" flag="fatal" role="fatal" test="not($vatCategory='Z')                   or u:isZeroOrEmpty($lineTaxAmount)" diagnostics="d-IBR-077">[IBR-077-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Zero Rated', Line Item VAT Amount (BTOM-016) shall be zero.</assert>
            
            <assert id="IBR-078-OM" flag="fatal" role="fatal" test="                 $isSimplified                 or                 cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode                 " diagnostics="d-IBR-078">[IBR-078-OM] - Goods or Services identification (BTOM-019) must be provided for each item name (IBT-153) except when Invoice transaction type (BTOM-001) is 'Simplified Tax Invoice' (X1XXXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-079-OM" flag="fatal" role="fatal" test="$isSimplified                   or not(cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode='G')                   or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']" diagnostics="d-IBR-079">[IBR-079-OM] - When Goods or Services identification (BTOM-019) is 'Goods' then Item classification identifier (IBT-158, HS code) must be provided except when Invoice transaction type (BTOM-001) is 'Simplified Tax Invoice' (X1XXXXXXXXXXXXXXXXXX)</assert>
            
            <assert id="IBR-080-OM" flag="fatal" role="fatal" test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS'])                   or string-length(normalize-space(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS'])) = 12" diagnostics="d-IBR-080">[IBR-080-OM] - When Item classification identifier (IBT-158) is provided with @listID='HS', it must be exactly 12 digits (Oman HS code). 6-digit ISIC codes are validated separately under CL-08-OM-ISIC and 8-digit service-type codes under CL-12-OM.</assert>
            
            
                 <assert id="IBR-081-OM" flag="fatal" role="fatal" test="$isSimplified or $isImportGoods or $isImportRCM or $isProfitMarginSelf                   or cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC']" diagnostics="d-IBR-081">[IBR-081-OM] - Industrial Classification Code (BTOM-033) must be provided for each ITEM INFORMATION (IBG-31) except when Invoice transaction type (BTOM-001) is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX) and/or import of goods (XXXXXXXXXXXX1XXXXXXX) or import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self-invoice (XXXXXXXXXX1XXXXXXXXX).</assert>
           
                
            <assert id="IBR-084-OM" flag="fatal" role="fatal" test="not($isImportGoods)                   or cac:Item/cac:OriginCountry/cbc:IdentificationCode" diagnostics="d-IBR-084">[IBR-084-OM] - If invoice transaction type (BTOM-001) is 'Import of Goods' (XXXXXXXXXXXX1XXXXXXX) then Item country of origin (IBT-159) is mandatory.</assert>
            
            
            <assert id="IBR-086-OM" flag="fatal" role="fatal" test="not($isProfitMarginSelf)                   or $vatCategory='O'" diagnostics="d-IBR-086">[IBR-086-OM] - If Invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice ' (XXXXXXXXXX1XXXXXXXXX), Invoiced item VAT category code (IBT-151) MUST be 'O' (Not subject to VAT).</assert>
            
            <assert id="IBR-091-OM" flag="fatal" role="fatal" test="not($isProfitMargin)                   or (every $code in cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']                       satisfies not(                            starts-with(normalize-space($code),'7101')                         or starts-with(normalize-space($code),'7102')                         or starts-with(normalize-space($code),'7103')                         or starts-with(normalize-space($code),'7104')                         or starts-with(normalize-space($code),'01')                         or starts-with(normalize-space($code),'06')))" diagnostics="d-IBR-091">[IBR-091-OM] - When Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Item classification identifier (IBT-158, listID='HS') MUST NOT start with '7101', '7102', '7103', '7104', '01' or '06'.</assert>

            
            <assert id="IBR-057-OM" flag="fatal" role="fatal" test="not($isSummary)                   or (substring(cac:InvoicePeriod/cbc:StartDate,1,7)                       = substring(cac:InvoicePeriod/cbc:EndDate,1,7))" diagnostics="d-IBR-057">[IBR-057-OM] - Invoice line period start date (IBT-134) and Invoice line period end date (IBT-135) when provided must belong to the same calendar month.</assert>
            
            <assert id="IBR-038-OM" flag="fatal" role="fatal" test="$isSimplified or $lineTaxAmount" diagnostics="d-IBR-038">[IBR-038-OM, IBR-068-OM] - An Invoice must contain line Item VAT Amount (BTOM-016) except where invoice transaction type (BTOM-001) is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX).</assert>
            
            <assert id="IBR-072-OM" flag="fatal" role="fatal" test="not($isFullTax and $isSummary)                   or cac:InvoicePeriod/cbc:StartDate                      and cac:InvoicePeriod/cbc:EndDate" diagnostics="d-IBR-072">[IBR-072-OM] - Invoice line period start date (IBT-134) and Invoice line period end date (IBT-135) must be provided when Invoice transaction type (BTOM-001) is a Full Tax Invoice AND Summary invoice (1XXX1XXXXXXXXXXXXXXX - both bit 1 and bit 5 set).</assert>
            
            <assert id="IBR-157-OM" flag="fatal" role="fatal" test="not(cac:Price/cac:AllowanceCharge/cbc:BaseAmount)                     or (                         cac:Price/cbc:PriceAmount castable as xs:decimal and                          cac:Price/cac:AllowanceCharge/cbc:BaseAmount castable as xs:decimal and                         u:slack(                             xs:decimal(cac:Price/cbc:PriceAmount),                             xs:decimal(                                 round(                                     (                                         xs:decimal(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) -                                         sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.))                                     ) * 100                                 ) div 100                             ),                             0.01                         )                     )" diagnostics="d-IBR-157">
                [IBR-157-OM] - Item net price (IBT-146) must be equal to (Item gross price (IBT-148) minus (-) Item price discount (IBT-147)) when item gross price is provided.</assert>
            
            <assert id="IBR-168-OM" flag="fatal" role="fatal" test="                     not($vatRate)                     or                     (                         $lineTaxAmount castable as xs:decimal                         and cbc:LineExtensionAmount castable as xs:decimal                         and $vatRate castable as xs:decimal                         and                         u:slack(                             xs:decimal($lineTaxAmount),                             round(                                 (                                     xs:decimal(cbc:LineExtensionAmount)                                     * xs:decimal($vatRate)                                     div 100                                 ) * 100                             ) div 100,                             0.01                         )                     )                 " diagnostics="d-IBR-168">[IBR-168-OM] - The Line Item VAT amount (BTOM-016) must be Invoiced item VAT rate (IBT-152) multiplied by Invoice Line Net Amount (IBT-131).</assert>
            
            <assert id="IBR-158-OM" flag="fatal" role="fatal" test="$isProfitMargin                         or (                             cac:ItemPriceExtension/cbc:Amount castable as xs:decimal                             and u:slack(                                 xs:decimal(cac:ItemPriceExtension/cbc:Amount),                                 xs:decimal(xs:decimal(cbc:LineExtensionAmount) + xs:decimal($lineTaxAmount)),                                 0.01                             )                         )" diagnostics="d-IBR-158">[IBR-158-OM] - Total amount including VAT (BTOM-017) must be the sum of Invoice line net amount (IBT-131) and Line Item VAT amount (BTOM-016) unless if Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) in which case Total amount including VAT (BTOM-017) must be the total sale value of the item.</assert>
            
            <assert id="IBR-174-OM" flag="fatal" role="fatal" test="not(cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode='G')                       or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']" diagnostics="d-IBR-174">[IBR-174-OM] - Item classification identifier (HS Code) (IBT-158) should be provided from the Harmonized System (HS) Code list published by the Royal Oman Police (Directorate General of Customs) when Goods or Services identification (BTOM-019) is 'G' (Goods).</assert>
        </rule>
        
            
        

    </pattern>
        
            
        
    <pattern id="AlignedCodelists">
        <title>PINT Oman - codelist conformance</title>
        
        
        <rule flag="fatal" role="fatal" context="cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode">
            
            <assert diagnostics="d-CL-02-OM" id="CL-02-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' CAN VAT VAL QTY OTH ', concat(' ', normalize-space(.), ' '))))">[CL-02-OM] - Credit Note or Debit Note reason code (BTOM-032) must be coded using the code list for Codelist for reasons for issuance of credit note or debit note.</assert>
        </rule>
        
        <rule context="cbc:InvoiceTypeCode[@name] | cbc:CreditNoteTypeCode[@name]">
            <let name="t" value="normalize-space(@name)"/>
            
            <assert id="CL-03-OM-1" flag="fatal" role="fatal" test="not(substring($t,1,1)='1' and substring($t,2,1)='1')" diagnostics="d-CL-03-OM">[CL-03-OM-1] - An invoice cannot be both a Full Tax Invoice (Bit 1) and a Simplified Invoice (Bit 2).</assert>
            
            <assert id="CL-03-OM-2" flag="fatal" role="fatal" test="substring($t,1,1)='1' or substring($t,2,1)='1'" diagnostics="d-CL-03-OM">[CL-03-OM-2] - Invoice transaction type (BTOM-001) must indicate either a Full Tax Invoice (bit 1) or a Simplified Invoice (bit 2).</assert>

            </rule>
        
        <rule flag="fatal" role="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
            
            <assert diagnostics="d-CL-04-OM" id="CL-04-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' S E O Z ', concat(' ', normalize-space(.), ' '))))">[CL-04-OM] - Document level allowance TAX category code (IBT-095), Document level charge TAX category code (IBT-102), TAX category code for tax category tax amount in accounting currency (IBT-192), TAX category code (IBT-118), Invoiced item TAX category code (IBT-151), MUST all be coded using the code list for Invoice VAT Categories.</assert>
        </rule>
        
        <rule flag="fatal" role="fatal" context="cac:TaxCategory/cbc:TaxExemptionReasonCode | cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode">
            <let name="catCode" value="normalize-space(../cbc:ID)"/>
            <let name="reason" value="normalize-space(.)"/>
            
            <assert diagnostics="d-CL-05-OM" id="CL-05-OM" flag="fatal" role="fatal" test="not($catCode = 'E')                       or (not(contains($reason, ' ')) and contains(' VATEX-OM-01 VATEX-OM-02 VATEX-OM-03 VATEX-OM-04 VATEX-OM-05 VATEX-OM-06 VATEX-OM-07 VATEX-OM-08 VATEX-OM-09 VATEX-OM-10 VATEX-OM-11 VATEX-OM-12 ', concat(' ', $reason, ' ')))">[CL-05-OM] - When VAT category code (IBT-118 / IBT-151 / IBT-095 / IBT-102 / IBT-192) is 'E' (Exempt), the VAT exemption reason code (IBT-121 / IBT-186 / IBT-196 / IBT-198) MUST be coded using the Exemption reason codelist (VATEX-OM-01..VATEX-OM-12).</assert>
            
            <assert diagnostics="d-CL-10-OM" id="CL-10-OM" flag="fatal" role="fatal" test="not($catCode = 'Z')                       or (not(contains($reason, ' ')) and contains(' VATZR-OM-01 VATZR-OM-02 VATZR-OM-03 VATZR-OM-04 VATZR-OM-05 VATZR-OM-06 VATZR-OM-07 VATZR-OM-08 VATZR-OM-09 VATZR-OM-10 VATZR-OM-11 VATZR-OM-12 VATZR-OM-13 VATZR-OM-14 VATZR-OM-15 VATZR-OM-16 ', concat(' ', $reason, ' ')))">[CL-10-OM] - When VAT category code (IBT-118 / IBT-151 / IBT-095 / IBT-102 / IBT-192) is 'Z' (Zero rated), the VAT exemption reason code (IBT-121 / IBT-186 / IBT-196 / IBT-198) MUST be coded using the Zero rating codelist (VATZR-OM-01..VATZR-OM-16).</assert>
        </rule>
        
        <rule flag="fatal" role="fatal" context="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName] | cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName]">
            
            <assert diagnostics="d-CL-06-OM" id="CL-06-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(@schemeName), ' ')) and contains(' CR TIN CID PASNUM OTHID ICID SZLN ', concat(' ', normalize-space(@schemeName), ' '))))">[CL-06-OM] - If Seller identifier (IBT-029) or Buyer identifier (IBT-046) is provided, then the Seller identifier Scheme identifier (BTOM-015) and Buyer identifier Scheme identifier (BTOM-018) must be coded with the Buyer/Seller Identifier code list.</assert>
        </rule>
        
        
        <rule flag="fatal" role="fatal" context="cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode">
            
            <assert diagnostics="d-CL-07-OM" id="CL-07-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' G S ', concat(' ', normalize-space(.), ' '))))">[CL-07-OM] - Goods or Services identification (BTOM-019) must be provided from the codelist for Item type.</assert>
        </rule>
        
        <rule context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']">
            <let name="hsCode" value="normalize-space(.)"/>
            
            
            
            <let name="codes01" value="' 010121100001 010121100002 010121900001 010121900002 010129100001 010129100002 010129100003 010129100004 010129200001 010129200002 010129900001 010129900002 010129900003 010130000000 010190000000 010221000001 010221000002 010229000003 010229000004 010229009999 010231000001 010231000002 010239000001 010239000002 010239009999 010290110000 010290120000 010290190000 010290900000 010310000000 010391000000 010392000000 010410100001 010410100002 010410900001 010410900002 010410900003 010410909999 010420100001 010420100002 010420900001 010420900002 010420900003 010420909999 010511000000 010512000000 010513000000 010514000000 010515000000 010594100000 010594200000 010594300000 010594900000 010599100000 010599200000 010599900000 010611100001 010611100002 010611100003 010611100004 010611109999 010611900000 010612000001 010612000002 010612000003 010612000004 010612000005 010612000006 010612009999 010613100000 010613200001 010613200002 010613900000 010614000001 010614000002 010619300001 010619300002 010619300003 010619300004 010619300005 010619300006 010619300007 010619309999 010619400001 010619400002 010619409999 010619500001 010619500002 010619500003 010619500004 010619500005 010619500006 010619509999 010619600001 010619600002 010619600003 010619900002 010619900003 010619900004 010619900005 010619900006 010619900007 010619900008 010619900009 010619900011 010619900012 010619900013 010619900014 010619900015 010619900016 010619900017 010619900018 010619900019 010619909999 010620000001 010620000002 010620000003 010620000004 010620000005 010620000006 010620009999 010631000001 010631000002 010631009999 010632100000 010632200000 010632300000 010632400000 010632500000 010632600000 010632900000 010633000000 010639100001 010639100003 010639100005 010639100008 010639100009 010639100010 010639100011 010639100012 010639100013 010639100014 010639200000 010639900001 010639909999 010641000000 010649000001 010649000002 010649000004 010649009999 010690000000 020110000001 020110000002 020110000003 020110000004 020120000000 020130000000 020210000001 020210000002 020220000000 020230100000 020230900000 020311000000 020312000000 020319000000 020321000000 020322000000 020329000000 020410000001 020410000002 020410000003 020410000004 020421000001 020421000002 020421000003 020421000004 020422000000 020423000001 020423000002 020423000003 020423000004 020430000001 020430000002 020441000001 020441000002 020442000000 020443100001 020443100002 020443100003 020443900000 020450110001 020450110002 020450110003 020450110004 020450120001 020450120002 020450210001 020450210003 020450210004 020450210005 020450210006 020450210007 020450210009 020450210010 020450210012 020450220001 020450220003 020450220004 020450220006 020450220007 020450220008 020450310001 020450310002 020450320000 020500100000 020500900000 020610000000 020621000000 020622000000 020629000000 020630000000 020641000000 020649000000 020680100000 020680200000 020680900000 020690110000 020690120000 020690190000 020690910000 020690990000 020711000000 020712000002 020712000003 020712009999 020713000001 020713000002 020713000003 020713000004 020713000008 020713000009 020713000010 020713000011 020713009999 020714000015 020714000016 020714000017 020714000018 020714009999 020724000001 020724000003 020724000004 020724000005 020725000001 020725000002 020726000000 020727000000 020741000001 020741000002 020742000000 020743000001 020743000002 020744000000 020745000000 020751000001 020751000002 020752000000 020753000001 020753000002 020754000000 020755000000 020760100001 020760100002 020760200001 020760200002 020810100000 020810200000 020830000001 020830000002 020830000003 020840100000 020840200000 020840300000 020840400000 020850000000 020860100001 020860100002 020860100010 020860109999 020860200001 020860200002 020860200010 020860209999 020890210001 020890210002 020890220001 020890220002 020890310000 020890320000 020890910000 020890990000 020910000000 020990000000 021011000000 021012000000 021019000000 021020000000 021091000000 021092000000 021093000000 021099000000 030111000000 030119000000 030191000000 030192000000 030193000000 030194000000 030195000000 030199100000 030199900000 030211000000 030213000000 030214000000 030219000000 030221000000 030222000000 030223000000 030224000000 030229000000 030231000000 030232000000 030233000000 030234000000 030235000000 030236000000 030239100000 030239200000 030239910000 030239920000 030239930000 030239940000 030239990000 030241000000 030242000000 030243000000 030244100000 030244200000 030244900000 030245100000 030245200000 030245900000 030246000000 030247000000 030249100000 030249900000 030251000000 030252000000 030253000000 030254000000 030255000000 030256000000 030259000000 030271000000 030272000000 030273000000 030274000000 030279000000 030281000000 030282000000 030283000000 030284000000 030285100000 030285200000 030285300000 030285400000 030285500000 030285600000 030285900000 030289100000 030289200000 030289300000 030289400000 030289500000 030289600000 030289700000 030289800000 030289900000 030291000000 030292000000 030299000000 030311000000 030312000000 030313000000 030314000000 030319000000 030323000000 030324000000 030325000000 030326000000 030329000000 030331000000 030332000000 030333000000 030334000000 030339000000 030341000000 030342000000 030343000000 030344000000 030345000000 030346000000 030349100000 030349200000 030349300000 030349400000 030349500000 030349600000 030349900000 030351000000 030353000000 030354100000 030354200000 030354900000 030355100000 030355200000 030355900000 030356000000 030357000000 030359100000 030359900000 030363000000 030364000000 030365000000 030366000000 030367000000 030368000000 030369000000 030381000000 030382000000 030383000000 030384000000 030389100000 030389200000 030389300000 030389400000 030389510000 030389520000 030389600000 030389700000 030389800000 030389910001 030389910002 030389910003 030389910004 030389910005 030389910006 030389919999 030389990000 030391000000 030392000000 030399000000 030431000000 030432000000 030433000000 030439000000 030441000000 030442000000 030443000000 030444000000 030445000000 030446000000 030447000000 030448000000 030449000000 030451000000 030452000000 030453000000 030454000000 030455000000 030456000000 030457000000 030459100000 030459200000 030459900000 030461000000 030462000000 030463000000 030469000000 030471000000 030472000000 030473000000 030474000000 030475000000 030479000000 030481000000 030482000000 030483000000 030484000000 030485000000 030486000000 030487000000 030488000000 030489100000 030489200000 030489900000 030491000000 030492000000 030493000000 030494000000 030495000000 030496000000 030497000000 030499000000 030520000000 030531000000 030532000000 030539100000 030539900000 030541000000 030542000000 030543000000 030544000000 030549000000 030551000000 030552000000 030553000000 030554000000 030559300000 030559900000 030561000000 030562000000 030563000000 030564000000 030569000000 030571000000 030572000000 030579000000 030611000000 030612000000 030614000000 030615000000 030616000000 030617000000 030619000000 030631000003 030631000004 030632000003 030632000004 030633000003 030633000004 030634000003 030634000004 030635000003 030635000004 030636000003 030636000004 030639000000 030691000000 030692000000 030693000000 030694000000 030695000000 030699000000 030711000001 030711000002 030712000000 030719000000 030721000001 030721000002 030722000000 030729000000 030731000001 030731000002 030732000000 030739000000 030742000001 030742000002 030743000000 030749000000 030751000001 030751000002 030752000000 030759000000 030760000001 030760000002 030760000003 030760009999 030771000001 030771000014 030771000041 030771000053 030772000000 030779000000 030781000001 030781000002 030782000001 030782000002 030783000000 030784000000 030787000000 030788000000 030791000003 030791000004 030792000000 030799000000 030811000002 030811000003 030812000000 030819000000 030821000001 030821000002 030822000000 030829000000 030830000001 030830000002 030830000004 030830009999 030890000000 030910000000 030990100000 030990900000 040110310000 040110320000 040110910000 040110920000 040110930000 040110940000 040120300000 040120910000 040120920000 040140300000 040140910000 040140920000 040150300000 040150910000 040150920000 040150940000 040210110000 040210120002 040210120003 040210120004 040210120005 040210129999 040210190000 040210910000 040210920002 040210920003 040210920004 040210920005 040210929999 040210990000 040221100000 040221900001 040221900002 040221900003 040229110001 040229110002 040229120002 040229120003 040229120004 040229120005 040229129999 040229190000 040229910000 040229920002 040229920003 040229920004 040229920005 040229929999 040229990000 040291110000 040291120000 040291200000 040299110000 040299120001 040299120002 040299120003 040299120004 040299130000 040299140000 040299150000 040299160000 040299200000 040320100000 040320200000 040320300000 040320400000 040320500000 040320600000 040390110000 040390120000 040390130000 040390210000 040390220000 040390230000 040390910000 040390920000 040390930000 040390990000 040410000000 040490000000 040510110001 040510110002 040510120001 040510120002 040510130000 040510190000 040520000001 040520000002 040520000003 040520000004 040590100000 040590200000 040590900000 040610100000 040610200000 040610300000 040610400000 040610500000 040610600000 040610700000 040620000001 040620000004 040630000001 040630000002 040630000010 040630009999 040640100000 040640900000 040690100000 040690210000 040690220000 040690230000 040690240000 040690250000 040690260000 040690290000 040690300000 040690900000 040711000000 040719000000 040721000000 040729000000 040790100000 040790200000 040811000000 040819100000 040819200000 040819300000 040891000000 040899000000 040900110000 040900190000 040900210000 040900290000 041010000000 041090100000 041090200000 041090300000 041090900000 '"/>
            <let name="codes02" value="' 050100000000 050210000000 050290000000 050400110000 050400120000 050400130000 050400140000 050400150000 050400210000 050400220000 050400230000 050400240000 050400250000 050400310000 050400320000 050400330000 050400340000 050400350000 050510100000 050510200000 050590100000 050590200000 050590300000 050590400000 050610000000 050690000000 050710000001 050710000002 050710000003 050710000004 050790100000 050790200000 050800100000 050800200000 050800310000 050800320000 050800330000 050800910000 050800920000 051000100001 051000100004 051000100007 051000100010 051000900000 051110000000 051191100000 051191200000 051191900000 051199100000 051199200000 051199300000 051199400000 051199500000 051199900001 051199900002 051199900003 051199900004 051199900005 051199900006 051199900007 051199900008 051199900009 051199900010 060110000000 060120000000 060210100000 060210200000 060210900000 060220100000 060220200000 060220300000 060220400000 060220500000 060220600000 060220900000 060230100000 060230900000 060240000000 060290000005 060290000006 060290009999 060311000000 060312000000 060313000000 060314000000 060315000000 060319000000 060390100000 060390900000 060420100000 060420200000 060490100000 060490200000 070110000000 070190000000 070200000000 070310110001 070310110002 070310120000 070310200000 070320000000 070390000000 070410000000 070420000000 070490000001 070490000002 070490009999 070511000000 070519000000 070521000000 070529000000 070610100000 070610200000 070690100000 070690200000 070690300000 070690400000 070690900000 070700000000 070810000000 070820000000 070890100000 070890200000 070890300000 070890900000 070920000000 070930000000 070940000000 070951000000 070952000000 070953000000 070954000000 070955000000 070956000000 070959100000 070959900000 070960000000 070970000000 070991000000 070992000000 070993000000 070999100000 070999200000 070999300000 070999400000 070999900001 070999900002 070999900003 070999900004 070999900005 070999909999 071010000000 071021000000 071022000000 071029000000 071030000000 071040000000 071080000000 071090000000 071120000000 071140000000 071151000000 071159000000 071190000000 071220000000 071231000000 071232000000 071233000000 071234000000 071239000000 071290000001 071290000002 071290000003 071310000000 071320000000 071331100000 071331200000 071332100000 071332200000 071333100000 071333200000 071334100000 071334200000 071335100000 071335200000 071339100000 071339200000 071340000001 071340000002 071350000000 071360000001 071360000002 071390100001 071390100002 071390900000 071410000000 071420000000 071430000000 071440000000 071450000000 071490100000 071490200000 071490900000 080111000000 080112000000 080119000000 080121000000 080122000000 080131000000 080132000000 080211000000 080212000000 080221000000 080222000000 080231000000 080232000000 080241000000 080242000000 080251000000 080252000000 080261000000 080262000000 080270100000 080270900000 080280000000 080291000000 080292000000 080299100000 080299910000 080299920000 080310000001 080310000002 080390000001 080390000002 080410100000 080410210000 080410220000 080410290000 080420100000 080420200000 080430000000 080440000000 080450100001 080450100002 080450200001 080450200002 080450300001 080450300002 080510000001 080510000002 080521000000 080522000000 080529000000 080540000001 080540000002 080550100000 080550200000 080590000000 080610000000 080620000000 080711000000 080719100000 080719900000 080720000000 080810000000 080830000000 080840000000 080910000000 080921000000 080929000000 080930000000 080940000000 081010000000 081020000000 081030000000 081040000000 081050000000 081060000000 081070000000 081090100000 081090200000 081090300000 081090900000 081110000000 081120000000 081190000000 081210000000 081290000000 081310000000 081320000000 081330000000 081340100000 081340200000 081340300000 081340900000 081350000000 081400000000 090111000000 090112000000 090121000000 090122000000 090190100000 090190200000 090210000000 090220000000 090230100000 090230900000 090240000000 090300000000 090411000000 090412000000 090421000000 090422000000 090510000000 090520000000 090611000000 090619000000 090620000000 090710000000 090720000000 090811000000 090812000000 090821000000 090822000000 090831000000 090832000000 090921000000 090922000000 090931000000 090932000000 090961000000 090962000000 091011000000 091012000000 091020000000 091030100000 091030200000 091091100000 091091200000 091091300000 091091900000 091099100000 091099210000 091099220000 091099300000 091099900000 100111000000 100119000004 100119009999 100191000000 100199100003 100199100004 100199200005 100199200006 100199300000 100210000000 100290000000 100310000000 100390000000 100410000000 100490100000 100490200000 100510000000 100590100000 100590200000 100590300000 100590900000 100610000000 100620000000 100630000000 100640000000 100710000000 100790000000 100810000000 100821000000 100829000000 100830000000 100840000000 100850000000 100860000000 100890000000 110100100000 110100200000 110220000000 110290100000 110290200000 110290300000 110290400000 110290500000 110290600000 110290900000 110311100000 110311200000 110313100000 110313200000 110319100000 110319200000 110319300000 110319400000 110319500000 110319900000 110320000000 110412000000 110419100000 110419200000 110419300000 110419400000 110419500000 110419600000 110419900000 110422000000 110423000000 110429100000 110429200000 110429300000 110429400000 110429500000 110429900000 110430000000 110510100000 110510200000 110510300000 110520100000 110520200000 110520300000 110610110000 110610120000 110610130000 110610140000 110610150000 110610160000 110610190000 110610210000 110610220000 110610230000 110610240000 110610250000 110610260000 110610290000 110620100000 110620200000 110620310000 110620320000 110620330000 110620340000 110620350000 110620390000 110630100000 110630200000 110630300000 110630400000 110630500000 110630600000 110630700000 110630800000 110630900000 110710000000 110720000000 110811000000 110812000000 110813000000 110814000000 110819100000 110819200000 110819300000 110819900000 110820000000 110900000001 110900000002 120110000000 120190100000 120190200000 120230000000 120241000000 120242000000 120300000000 120400000000 120510000000 120590000000 120600000000 120710000001 120710000002 120721000000 120729000000 120730000000 120740000000 120750000000 120760000000 120770000000 120791000000 120799100000 120799200000 120799300000 120799900000 120810000001 120810000002 120890000000 120910000000 120921000000 120922000000 120923000000 120924000000 120925000000 120929100000 120929900000 120930000000 120991100000 120991200000 120991300000 120991400000 120991500000 120991600000 120991700000 120991800000 120991910000 120991920000 120991930000 120991990000 120999000000 121010000000 121020100000 121020200000 121120000000 121130000000 121140000000 121150000000 121160000000 121190100001 121190100002 121190200000 121190300000 121190400000 121190500000 121190600000 121190700000 121190810000 121190890000 121190910000 121190990001 121190990002 121190990003 121190990004 121190990005 121190990006 121190990009 121190990013 121190990016 121190990017 121190990018 121190990019 121190990020 121190990021 121190990099 121221000000 121229000000 121291000000 121292000000 121293000001 121293000002 121293009999 121294000000 121299100001 121299100002 121299400001 121299400002 121299400003 121299500001 121299500002 121299500003 121299500004 121299900000 121300100006 121300100007 121300100008 121300109999 121300900000 121410000000 121490100000 121490200000 121490900001 121490900002 121490900003 121490900004 121490909999 130120000000 130190100000 130190200000 130190300000 130190400000 130190500000 130190600000 130190700000 130190800000 130190910000 130190920000 130190930000 130190990000 130211000000 130212000000 130213000000 130214000000 130219100000 130219200000 130219300000 130219400000 130219500000 130219600000 130219700000 130219910000 130219920000 130219930000 130219990000 130220000000 130231100000 130231200000 130231900000 130232000000 130239000000 140110000000 140120000000 140190100000 140190200000 140190900000 140420000000 140490100000 140490900000 150110000000 150120000000 150190100000 150190200000 150210000000 150290100000 150290200000 150300110000 150300120000 150300190000 150300210000 150300220000 150300290000 150300910000 150300920000 150300990000 150410000000 150420000000 150430100000 150430200000 150430300000 150430900000 150500000000 150600000000 150710000000 150790000000 150810000000 150890000000 150920000000 150930000000 150940000000 150990000000 151010000000 151090100000 151090900000 151110000000 151190000000 151211000000 151219000000 151221000000 151229000000 151311000000 151319000000 151321000000 151329000000 151411000000 151419000000 151491100000 151491200000 151491300000 151491400000 151491500000 151499100000 151499200000 151499300000 151499400000 151499500000 151511000000 151519000000 151521000000 151529000000 151530000000 151550000000 151560000000 151590000000 151610100000 151610200000 151620100000 151620200000 151630100000 151630200000 151710100000 151710200000 151710900000 151790110000 151790120000 151790190000 151790900000 151800110000 151800120000 151800190000 151800200000 151800900000 152000100000 152000200000 152110000001 152110000002 152110000003 152110000004 152110000005 152110000006 152110000007 152110000008 152110000009 152110000010 152110009999 152190100001 152190100002 152190100003 152190100004 152190200001 152190200002 152190200003 152190200004 152190200005 152190209999 152190400000 152200100001 152200100002 152200200000 '"/>
            <let name="codes03" value="' 160100110000 160100120000 160100200019 160100200020 160100200021 160100209999 160100300013 160100300014 160100300015 160100300016 160100309999 160100900012 160100909999 160210100000 160210900000 160220100000 160220200000 160220300000 160220400000 160220900000 160231000000 160232100000 160232200000 160232300000 160232900000 160239000001 160239000002 160239000003 160239000004 160239000005 160239009999 160241000000 160242000000 160249000000 160250100000 160250200000 160250300000 160250400000 160250900000 160290100000 160290210000 160290290000 160290310000 160290390000 160290900000 160300100000 160300200000 160411000000 160412000000 160413000000 160414000000 160415000000 160416000000 160417000000 160418000000 160419100000 160419200000 160419300000 160419900000 160420000000 160431000000 160432000000 160510000001 160510000002 160510000003 160510009999 160521000000 160529000000 160530000000 160540000000 160551000000 160552000000 160553000000 160554000000 160555000000 160556000000 160557000000 160558000000 160559000000 160561000000 160562000000 160563000000 160569000000 170112100001 170112100002 170112900000 170113100000 170113900000 170114100000 170114900000 170191000000 170199110001 170199110002 170199120001 170199120002 170199130000 170199200001 170199200002 170199200003 170199209999 170199300000 170199900000 170211000000 170219000000 170220000000 170230000001 170230000002 170240000001 170240000002 170250000000 170260000001 170260000002 170290100000 170290200000 170290300000 170290400000 170290500001 170290500002 170290500004 170290509999 170290600001 170290600002 170290700000 170290900000 170310000000 170390000000 170410100000 170410200000 170410300000 170410400000 170490100001 170490100002 170490100003 170490100004 170490100005 170490100006 170490100007 170490100008 170490100009 170490100010 170490100011 170490100012 170490100013 170490100014 170490100015 170490109999 170490200001 170490200002 170490200003 170490300001 170490300002 170490300003 170490300004 170490300005 170490300006 170490300007 170490309999 170490400000 170490500000 170490610000 170490620000 170490690000 170490700000 170490800000 170490900001 170490900002 170490900003 170490900004 170490900005 170490900006 170490900010 170490900011 170490909999 180100000001 180100000002 180100000003 180100000004 180200000001 180200000002 180200000003 180200000004 180310000000 180320000000 180400000001 180400000002 180400000003 180500000000 180610110000 180610110001 180610110002 180610110003 180610110004 180610190000 180610910000 180610910001 180610910002 180610910003 180610910004 180610990000 180620100000 180620200000 180620310000 180620310001 180620310002 180620310003 180620310004 180620390000 180620900001 180620900002 180620900003 180620909999 180631100000 180631900000 180632100000 180632900000 180690100000 180690200000 180690310000 180690390000 180690910000 180690910001 180690910002 180690910003 180690910004 180690990000 190110100000 190110200000 190110900000 190120100000 190120200000 190120900001 190120900002 190120900003 190120900004 190120909999 190190110000 190190120001 190190120002 190190120003 190190120004 190190190000 190190210000 190190220001 190190220002 190190220003 190190220004 190190290000 190190300000 190190400000 190190910001 190190910002 190190920001 190190920003 190190920004 190190920005 190190920006 190190990000 190211100000 190211200000 190211300000 190211900000 190219100000 190219200000 190219300000 190219900000 190220100000 190220200000 190220900000 190230100000 190230200000 190230300000 190230900000 190240000000 190300000000 190410100000 190410910000 190410990000 190420110001 190420110002 190420190001 190420190002 190420190003 190420190004 190420199999 190420210001 190420210002 190420290001 190420290002 190420290003 190420290004 190430100001 190430100002 190430900001 190430900002 190430900003 190430900004 190430909999 190490100001 190490100002 190490900001 190490900002 190490900003 190490909999 190510000000 190520000000 190531000000 190532000000 190540100001 190540100002 190540900000 190590100001 190590100002 190590109999 190590200000 190590300000 190590410000 190590420000 190590490000 190590500001 190590500002 190590509999 190590600000 190590700000 190590800001 190590800002 190590800003 190590809999 190590910001 190590910002 190590919999 190590920000 190590930000 190590990001 190590990002 190590999999 200110000000 200190110000 200190120000 200190130000 200190140001 200190140002 200190140003 200190140004 200190150000 200190190000 200190200000 200210000000 200290100000 200290900000 200310000000 200390100000 200390900000 200410000000 200490100000 200490200000 200490300000 200490400000 200490500000 200490600000 200490700000 200490800000 200490900001 200490900002 200490900003 200490900004 200490900005 200490909999 200510110001 200510110002 200510110003 200510120001 200510120002 200510120003 200510200000 200510900000 200520000000 200540000000 200551000000 200559000000 200560000000 200570000000 200580000000 200591000000 200599110000 200599120000 200599130000 200599190000 200599910000 200599920000 200599930000 200599940000 200599950000 200599960000 200599970000 200599990000 200600000000 200710110001 200710110002 200710110003 200710120001 200710120002 200710120003 200710200000 200710900000 200791100000 200791900000 200799110000 200799120000 200799130000 200799140000 200799150000 200799160000 200799170000 200799190000 200799200000 200799300000 200799900000 200811100000 200811200000 200819110000 200819120000 200819130000 200819140000 200819190000 200819200000 200819900000 200820100000 200820900000 200830100000 200830200000 200830300000 200830900000 200840100000 200840900000 200850100000 200850900000 200860100000 200860900000 200870100000 200870900000 200880100000 200880900000 200891000000 200893100000 200893900000 200897100000 200897900000 200899100000 200899900000 200911100000 200911200001 200911200002 200911200003 200911200004 200912100000 200912200001 200912200002 200912200003 200912200004 200919100000 200919200001 200919200002 200919200003 200919200004 200921100000 200921200001 200921200002 200921200003 200921200004 200921300000 200921400001 200921400002 200921400003 200921400004 200929100000 200929200001 200929200002 200929200003 200929200004 200929300000 200929400001 200929400002 200929400003 200929400004 200931110000 200931120001 200931120002 200931120003 200931120004 200931910000 200931920001 200931920002 200931920003 200931920004 200939100000 200939200001 200939200002 200939200003 200939200004 200941100000 200941200001 200941200002 200941200003 200941200004 200949100000 200949200001 200949200002 200949200003 200949200004 200950100000 200950200001 200950200002 200950200003 200950200004 200961100000 200961200001 200961200002 200961200003 200961200004 200969100000 200969200001 200969200002 200969200003 200969200004 200971100000 200971200001 200971200002 200971200003 200971200004 200979100000 200979200001 200979200002 200979200003 200979200004 200981100000 200981200001 200981200002 200981200003 200981200004 200981300000 200981400001 200981400002 200981400003 200981400004 200989110000 200989120001 200989120002 200989120003 200989120004 200989220000 200989230001 200989230002 200989230003 200989230004 200989240000 200989250001 200989250002 200989250003 200989250004 200989320000 200989330001 200989330002 200989330003 200989330004 200989340000 200989350001 200989350002 200989350003 200989350004 200989420000 200989430001 200989430002 200989430003 200989430004 200989440000 200989450001 200989450002 200989450003 200989450004 200989500000 200989600000 200989700000 200989910002 200989910003 200989920003 200989920004 200989920005 200989920006 200989920007 200989920008 200989920009 200989920010 200990210000 200990220000 200990310001 200990310002 200990310003 200990310004 200990320001 200990320002 200990320003 200990320004 200990410000 200990420000 200990510001 200990510002 200990510003 200990510004 200990520001 200990520002 200990520003 200990520004 210111000001 210111000002 210111000003 210112110000 210112110001 210112110002 210112110003 210112110004 210112190000 210112200001 210112200002 210112200003 210112900000 210120100001 210120100002 210120100003 210120100004 210120100005 210120100006 210120100007 210120109999 210120910000 210120920000 210130100005 210130100006 210130109999 210130200001 210130200002 210130200003 210210000000 210220100000 210220200000 210220900000 210230100000 210230200000 210230900000 210310000000 210320000001 210320000002 210320000003 210330100000 210330200000 210390100001 210390100002 210390100003 210390109999 210390200000 210390300000 210390900000 210410000000 210420000000 210500100000 210500900000 210610000000 210690100000 210690200000 210690300000 210690500001 210690500002 210690500003 210690509999 210690600000 210690700000 210690800001 210690800002 210690910001 210690910002 210690920001 210690920004 210690920005 210690920006 210690920007 210690930000 210690940000 210690940901 210690950000 210690960001 210690960002 210690960003 210690960004 210690980001 210690980002 210690989999 210690990001 210690990901 210690990002 210690990003 210690990004 210690990005 210690990007 210690990902 210690999999 '"/>
            <let name="codes04" value="' 220110100001 220110100002 220110109999 220110200001 220110200002 220110209999 220110300001 220110300002 220110309999 220190100002 220190100003 220190100004 220190109999 220190900001 220190900002 220190909999 220210120000 220210130001 220210130002 220210130003 220210130004 220210140001 220210140002 220210140003 220210140004 220210180001 220210180002 220210180003 220210180004 220210210001 220210210002 220210210003 220210210004 220210220001 220210220002 220210220003 220210220004 220210230001 220210230002 220210230003 220210230004 220210240000 220210250000 220210290001 220210290002 220210290003 220210290004 220210920001 220210920002 220210920003 220210920004 220210990000 220291000004 220291000005 220291000006 220291000007 220291000008 220291000009 220291000010 220291000011 220299130001 220299130002 220299130003 220299130004 220299190000 220299190901 220299230001 220299230002 220299230003 220299230004 220299290000 220299300001 220299300002 220299300003 220299300004 220299930001 220299930002 220299930003 220299930004 220299990000 220300000000 220410000000 220421000000 220422000000 220429000000 220430000000 220510000000 220590000000 220600100000 220600200000 220600900000 220710100000 220710900000 220720110000 220720190000 220720900000 220820000000 220830000000 220840000000 220850000000 220860000000 220870000000 220890110000 220890190001 220890199999 220890900000 220900110000 220900120000 220900130000 220900140000 220900190000 220900200000 230110000000 230120000000 230210100000 230210900000 230230100000 230230200000 230230900000 230240000000 230250100000 230250900000 230310100000 230310900000 230320100000 230320200000 230320900000 230330000000 230400100000 230400200000 230400300000 230400400000 230400900000 230500000000 230610000000 230620000000 230630000000 230641000000 230649000000 230650000000 230660000000 230690100000 230690900000 230700100000 230700200000 230800100000 230800200000 230800300000 230800400000 230800500000 230800900000 230910000000 230990110000 230990120000 230990200000 230990310000 230990390001 230990399999 230990400000 230990500000 230990910000 230990920000 230990930000 230990940001 230990949999 230990990000 240110100000 240110200000 240110300000 240110400000 240110900000 240120100000 240120200000 240120300000 240120400000 240120500000 240120900000 240130100000 240130910000 240130920000 240130990000 240210100000 240210200000 240220000000 240290100000 240290200000 240311000000 240319100000 240319200000 240319300000 240319400000 240319900000 240391000000 240399100000 240399210000 240399220000 240399290000 240399300000 240399400000 240399500000 240399900000 240411100000 240411900000 240412110000 240412120000 240412210000 240412220000 240412310000 240412320000 240419000000 240491100000 240491200000 240491300000 240491910000 240491990000 240492100000 240492910000 240492990000 240499100000 240499200000 240499300000 240499900000 250100100001 250100100002 250100100003 250100100004 250100100007 250100100008 250100100009 250100100010 250100100011 250100100012 250100100013 250100100014 250100100015 250100100016 250100210000 250100220000 250100290000 250100310000 250100320000 250100390000 250100410000 250100490000 250100900001 250100900002 250100900003 250100900004 250100900005 250100909999 250200000001 250200000002 250300000001 250300000002 250300000003 250300000004 250300000005 250300000006 250300000007 250300000008 250300000009 250300000010 250410000001 250410000002 250490000001 250490000002 250490000003 250510000001 250510000002 250510000003 250510000004 250590000001 250590000002 250590000003 250590000004 250590000005 250590009999 250610100000 250610900001 250610900002 250610900003 250610900004 250610909999 250620000001 250620000002 250620000003 250620000004 250700100001 250700100002 250700900001 250700900002 250700900003 250700900004 250700900005 250700909999 250810000001 250810000002 250810000003 250810009999 250830000001 250830000002 250840000001 250840000002 250840000003 250840000004 250850000001 250850000002 250850000003 250850000004 250850000005 250850000006 250860000001 250860000002 250870000001 250870000002 250870000003 250900100001 250900100002 250900900001 250900909999 251010000001 251010000002 251010000003 251020000001 251020000002 251020000003 251110000001 251110000002 251120000001 251120000002 251200000001 251200000002 251200000003 251200000004 251200000005 251200000006 251200009999 251310000001 251310000002 251320100001 251320100002 251320200001 251320200002 251320300001 251320300002 251320400001 251320400002 251320900001 251320909999 251400100000 251400900001 251400900002 251400900003 251400900004 251400909999 251511000001 251511000002 251511000003 251511000004 251512000001 251512000002 251512000003 251512000004 251520100001 251520100002 251520100003 251520100004 251520200001 251520200002 251520200003 251520200004 251611000001 251611000002 251611000003 251611000004 251612000001 251612000002 251612000003 251612000004 251620000001 251620000002 251620000003 251690100001 251690100002 251690100003 251690100004 251690100005 251690100006 251690100007 251690100008 251690100009 251690100010 251690100011 251690100012 251690200000 251710000001 251710000002 251710000003 251710000004 251710000005 251710000006 251710000007 251710000008 251710000009 251710000010 251710009999 251720000001 251720000002 251730000001 251730000002 251741000001 251741000002 251749000001 251749000002 251749000003 251749000004 251749000005 251749000006 251749000007 251749000008 251749000009 251810100001 251810100002 251810100003 251810100004 251810200001 251810200002 251810200003 251810200004 251820100001 251820100002 251820100003 251820100004 251820200001 251820200002 251820200003 251820200004 251910000000 251990100001 251990100002 251990900001 251990900002 251990900003 251990909999 252010100001 252010100002 252010200001 252010200002 252020100000 252020900001 252020900002 252020900003 252020909999 252100000001 252100000002 252100000003 252100000004 252100000005 252100000901 252100000902 252100000904 252100000905 252100000906 252100000907 252100000908 252100000910 252100000911 252100000913 252100000914 252100000915 252210000001 252210000002 252210000901 252210000902 252210000903 252210000904 252220000001 252220000002 252220000901 252220000902 252220000903 252220000904 252230000001 252230000002 252310000001 252310000002 252310000003 252310000004 252321000001 252321000002 252321000003 252321000004 252329100001 252329100002 252329200001 252329200002 252329900000 252330000001 252330000002 252390000001 252390000002 252390000003 252390000004 252410000000 252490100000 252490200000 252490300000 252490400000 252490900000 252510000001 252510000002 252520000000 252530000000 252610100001 252610100002 252610100003 252610200001 252610200002 252620100001 252620100002 252620100003 252620200001 252620200002 252800000001 252800000002 252800000003 252910000000 252921000000 252922000000 252930000001 252930000002 253010000001 253010000002 253010000003 253010000004 253020000001 253020000002 253090110000 253090190001 253090190002 253090199999 253090200000 253090300000 253090400001 253090400002 253090400003 253090400004 253090409999 253090500000 253090900001 253090900002 253090900003 253090900004 253090900005 253090900006 253090900007 253090900008 253090900009 253090900010 253090900011 253090900012 253090900013 253090900014 253090900015 253090900016 253090900017 253090900018 253090900019 253090900020 253090900021 253090909999 260111000001 260111000002 260111000003 260111000004 260111000005 260111000006 260111000007 260111000008 260111000009 260111000010 260111000011 260111000012 260111009999 260112000001 260112000002 260112000003 260112000004 260112000005 260112000006 260112000007 260112000008 260112000009 260112000010 260112000011 260112000012 260112009999 260120000001 260120000002 260120000003 260120000004 260200000001 260200000002 260200000003 260200000004 260200000005 260200000006 260200000007 260200000008 260200000009 260200000010 260200000011 260200000012 260200000013 260200000014 260300000001 260300000002 260300000003 260300000004 260300000005 260300000006 260300000007 260300000008 260300000009 260300000010 260300000011 260300000012 260300000013 260300000014 260300000015 260300000016 260300000017 260300000018 260300000019 260300000020 260300000021 260300000022 260300000023 260300000024 260300000025 260300000026 260300000027 260300000028 260400000001 260400000002 260400000003 260400000004 260400000005 260400000006 260400000007 260400000008 260500000001 260500000002 260500000003 260500000004 260500000005 260500000006 260500000007 260500000008 260600000001 260600000002 260600000003 260600000004 260700000001 260700000002 260700000003 260700000004 260700000005 260700000006 260700000007 260700000008 260800000001 260800000002 260800000003 260800000004 260800000005 260800000006 260800000007 260800000008 260900000001 260900000002 260900000003 260900000004 261000000001 261000000002 261100000001 261100000002 261100000003 261100000004 261100000005 261100000006 261100000007 261100000008 261210000001 261210000002 261210000003 261210000004 261210000005 261210000006 261210000008 261210000009 261210000010 261210000011 261210000012 261210000013 261210000014 261210000015 261210000016 261210000017 261210000018 261210000019 261210000020 261210000021 261210000022 261210009999 261220000001 261220000002 261220000003 261220000004 261220009999 261310000001 261310000002 261310000003 261310000004 261310000005 261390000001 261390000002 261390000003 261390000004 261390009999 261400000001 261400000002 261400000003 261400000004 261510000001 261510000002 261510000003 261510000004 261590000001 261590000002 261590000003 261590000004 261590000005 261590000006 261590000007 261590000008 261590000009 261590000010 261590000011 261590000012 261590009999 261610000001 261610000002 261610000003 261610000004 261610000005 261610000006 261610000007 261610000008 261610000009 261610000010 261610000011 261610000012 261610000013 261610000014 261690000001 261690000002 261690000003 261690000004 261690000005 261690000006 261690000007 261690000008 261690000009 261690000010 261710000001 261710000002 261710000003 261710000004 261710000005 261710000006 261710000007 261710000008 261710000009 261710000010 261790000001 261790000002 261790000003 261790000004 261790000005 261790000006 261790000007 261790000008 261790000009 261790000010 261790000011 261790000012 261790000013 261790000014 261790009999 261800000001 261800000002 261800000003 261900000001 261900000002 261900000003 261900000004 261900000005 261900000006 261900000007 261900000008 261900000009 262011000000 262019000001 262019000002 262019000003 262019000004 262019000005 262019000006 262019009999 262021000001 262021000002 262029000001 262029000002 262029009999 262030000000 262040000000 262060000001 262060000002 262060000003 262091000001 262091000002 262091000003 262091000004 262091000005 262099000001 262099000002 262099000003 262099000004 262099009999 262110000000 262190000001 262190000002 262190000003 262190000004 262190000005 262190000006 262190009999 '"/>
            <let name="codes05" value="' 270111000001 270111000002 270111000003 270111000004 270112000001 270112000002 270119000001 270119000002 270119000003 270119000004 270119000005 270119000006 270119000007 270119000008 270120000001 270120000002 270120000003 270120000004 270120000005 270120000006 270120000007 270120000008 270120000009 270210000001 270210000003 270210000004 270220000001 270220000002 270220000003 270220000004 270300100001 270300100002 270300100003 270300100004 270300900001 270300900002 270300900003 270300900004 270300900005 270300900006 270300900007 270300900008 270300909999 270400100001 270400100002 270400100003 270400100004 270400100005 270400100006 270400100007 270400100008 270400100009 270400100010 270400100011 270400100012 270400200001 270400200002 270400200003 270400200004 270500000001 270500000002 270500000003 270500000004 270500009999 270600000001 270600000002 270600000003 270600000004 270600000005 270600000006 270600000007 270600000008 270600000009 270600000010 270600000011 270600000012 270600000013 270600000014 270600000015 270600000016 270600000017 270600000018 270600000019 270600000020 270600000021 270600000022 270600000023 270600009999 270710000001 270710000002 270710000003 270710000004 270720000000 270730000000 270740000001 270740000002 270740000003 270740000004 270750000000 270791000000 270799000001 270799009999 270810000001 270810000002 270810000003 270820000001 270820000002 270820000003 270900000001 270900000002 270900000003 270900009999 271012110000 271012120000 271012130000 271012140000 271012190002 271012190003 271012190004 271012190005 271012190006 271012190007 271012199999 271012210001 271012210002 271012210003 271012219999 271012220000 271012230000 271012290001 271012290002 271012290004 271012290005 271012299999 271012310000 271012320000 271012330000 271012390002 271012399999 271012410001 271012410002 271012419999 271012420001 271012420002 271012429999 271012490001 271012490002 271012499999 271019110001 271019110002 271019110003 271019110004 271019110005 271019110006 271019110007 271019110008 271019110009 271019110010 271019110011 271019110012 271019110013 271019110014 271019110015 271019119999 271019120001 271019120002 271019120003 271019120004 271019120005 271019120006 271019120007 271019120008 271019120009 271019129999 271019130001 271019130002 271019130003 271019130004 271019130005 271019130006 271019130007 271019130008 271019130009 271019130010 271019130011 271019130012 271019130013 271019130014 271019130015 271019130016 271019130017 271019130018 271019139999 271019140001 271019140002 271019149999 271019150001 271019150002 271019190001 271019190002 271019199999 271019910001 271019910002 271019920001 271019920002 271019920003 271019920004 271019920005 271019920006 271019920007 271019930001 271019930002 271019940000 271019950001 271019950002 271019950003 271019950004 271019950005 271019950006 271019950007 271019950008 271019950009 271019950010 271019950011 271019950012 271019960001 271019960002 271019960003 271019970001 271019970002 271019970003 271019979999 271019980001 271019980002 271019980003 271019980004 271019980005 271019989999 271019990001 271019990002 271019990003 271019990004 271019999999 271020000000 271091100000 271091200000 271091900000 271099000001 271099009999 271111000000 271112000000 271113000000 271114000001 271114000002 271114000003 271114000004 271119000001 271119000002 271119000003 271119000004 271119009999 271121000000 271129000000 271210000000 271220100000 271220200000 271220900001 271220909999 271290000001 271290000002 271290000003 271290000004 271290009999 271311000000 271312000001 271312000002 271312000003 271312000004 271312000005 271312000006 271320000000 271390000001 271390000002 271390000003 271390000004 271390000005 271390009999 271410000001 271410000002 271410000003 271490100001 271490100002 271490900001 271490900002 271490900003 271490900004 271490900005 271490909999 271500000001 271500000002 271500000003 271500000004 271500000005 271500000007 271500000008 271500009999 271600000000 280110000000 280120000000 280130100000 280130200000 280200100000 280200200000 280300000000 280410000000 280410000901 280421000000 280429100000 280429100901 280429200000 280429900001 280429900002 280429909999 280430000000 280440000001 280440009999 280450000001 280450000002 280461000000 280469000000 280470000000 280480000000 280490000000 280511000000 280512000001 280512009999 280519100000 280519200000 280519900001 280519900002 280519900003 280519909999 280530000001 280530000002 280530000003 280530009999 280540000000 280610000000 280620000000 280700100000 280700200000 280800100000 280800200000 280910000000 280920100000 280920200000 281000100000 281000200000 281111000000 281112000000 281119200000 281119900001 281119900002 281119900003 281119900004 281119900005 281119900006 281119900007 281119900008 281119909999 281121000000 281121000901 281122000000 281129100001 281129100002 281129900001 281129900002 281129900003 281129900901 281129909999 281211000000 281212000000 281213000000 281214000000 281215000000 281216000000 281217000000 281219100000 281219900001 281219900002 281219909999 281290000001 281290000002 281290000003 281290000004 281290000005 281290000006 281290009999 281310000000 281390000001 281390000002 281390009999 281410000000 281420000000 281511000000 281512000000 281520000000 281530000001 281530000002 281610000001 281610000002 281640000001 281640000002 281640000003 281640000004 281640000005 281640000006 281700100000 281700200000 281810000000 281820000000 281830000000 281910000000 281990000001 281990009999 282010000000 282090000001 282090000002 282090009999 282110100000 282110900000 282120000000 282200000001 282200000002 282200000003 282200000004 282200009999 282300000001 282300000002 282300009999 282410000000 282490900001 282490909999 282510000001 282510000002 282510000003 282510000004 282520000001 282520000002 282530000001 282530000002 282540000001 282540000002 282550100000 282550200000 282560000001 282560000002 282570000001 282570000002 282580000000 282590100000 282590900001 282590900002 282590900003 282590909999 282612000000 282619000001 282619000002 282619000003 282619000004 282619009999 282630000000 282690000001 282690000002 282690000003 282690000004 282690009999 282710000000 282720000000 282731000000 282732000000 282735000000 282739900001 282739900002 282739900003 282739900004 282739900005 282739909999 282741000001 282741000002 282741000004 282741000006 282741000008 282749000001 282749000002 282749000003 282749009999 282751000001 282751000002 282759000000 282760000001 282760000002 282760000003 282760000004 282760009999 282810000001 282810000002 282890100000 282890200000 282890300001 282890300002 282890400000 282890900001 282890909999 282911000000 282919100000 282919200000 282919300000 282919400000 282919500000 282919600000 282919700000 282919800000 282919900000 282990110000 282990120000 282990130000 282990190001 282990190002 282990199999 282990210000 282990290001 282990290002 282990290003 282990290004 282990290005 282990299999 282990300001 282990300002 282990300003 282990309999 283010000000 283090000001 283090000002 283090000003 283090000004 283090000005 283090000006 283090000007 283090000008 283090000009 283090000010 283090000011 283090000012 283090000013 283090000014 283090000015 283090000016 283090009999 283110000000 283190000001 283190000002 283190000003 283190009999 283210000000 283220000001 283220000002 283220000003 283220000004 283220009999 283230100000 283230200000 283230900001 283230900002 283230900003 283230909999 283311000000 283319000000 283321000000 283322000000 283324000000 283325000000 283327000000 283329900001 283329900002 283329909999 283330000001 283330000002 283330000003 283330009999 283340000001 283340000002 283340000003 283340009999 283410900001 283410909999 283421000000 283429900001 283429900002 283429900003 283429900004 283429900005 283429900006 283429900007 283429900008 283429909999 283510000001 283510000002 283522000001 283522000002 283524000000 283525000000 283526000000 283529900001 283529900002 283529900003 283529909999 283531000000 283539900001 283539909999 283620000000 283630000000 283640000001 283640000002 283650000000 283660000000 283691000000 283692000000 283699200000 283699300000 283699400000 283699910000 283699990000 283711000000 283719000001 283719000002 283719000003 283719000004 283719009999 283720100000 283720200000 283720300000 283720400000 283720900000 283911000000 283919000001 283919000002 283919000003 283919000004 283919000005 283919009999 283990000001 283990000002 283990009999 284011000000 284019000001 284019009999 284020000001 284020000002 284020000003 284020000004 284020009999 284030000001 284030000002 284030000003 284030000004 284030009999 284130000000 284150200000 284150300000 284150400000 284150500000 284161000000 284169000001 284169009999 284170900001 284170909999 284180000001 284180000002 284180000003 284190900001 284190900002 284190900003 284190909999 284210000000 284290000001 284290000002 284290000003 284290009999 284310000001 284310000002 284310000003 284321000000 284329900001 284329900002 284329900003 284329909999 284330000001 284330000002 284330000003 284330000004 284390000001 284390000002 284390000003 284390000004 284390000005 284390000006 284390000007 284390009999 284410110000 284410120000 284410190000 284410900000 284420110000 284420190000 284420900000 284430110000 284430190000 284430900000 284441110000 284441190000 284441900000 284442110000 284442190000 284442900000 284443110001 284443119999 284443190001 284443199999 284443900001 284443900002 284443909999 284444110000 284444190000 284444900001 284444909999 284450000000 284510000000 284520000000 284530000000 284540000000 284590000001 284590009999 284610000001 284610000002 284610000003 284690000001 284690000002 284690009999 284700000000 284910000000 284920000000 284990100001 284990109999 284990900001 284990900002 284990900003 284990900004 284990909999 285000110000 285000120000 285000190000 285000200000 285000300001 285000300002 285000300003 285000300004 285000300005 285000300006 285000300007 285000300008 285000300009 285000300010 285000300011 285000300013 285000300014 285000309999 285000400001 285000400002 285000400003 285000400004 285000400005 285000409999 285000500001 285000500002 285000500003 285000500004 285000500005 285000500006 285000509999 285290100000 285290200000 285290300000 285290900000 '"/>
            <let name="codes06" value="' 290110100000 290110200000 290110300000 290110400000 290110500000 290110600000 290110900000 290121000000 290122000000 290123000000 290124000000 290129100000 290129200000 290129300000 290129400000 290129500000 290129600000 290129900001 290129900002 290129900003 290129900004 290129900005 290129900006 290129900007 290129900008 290129900009 290129900010 290129900011 290129900012 290129909999 290211000000 290219000000 290220000000 290230000000 290241000000 290242000000 290243000000 290244000000 290250000000 290260000000 290270000000 290290100000 290290200000 290290900000 290311000001 290311000002 290312000000 290313000000 290314000000 290315000000 290319100000 290319900001 290319900002 290319909999 290321000000 290322000000 290323000000 290329000000 290341000000 290342000000 290343000001 290343000002 290344000001 290344000002 290345000000 290346000001 290346000002 290347000000 290348000001 290348000002 290349000000 290351000001 290351000002 290359100000 290359900000 290361000000 290362000000 290369000000 290371000000 290372000000 290373000000 290374000000 290375000000 290376000001 290376000002 290376000003 290377100000 290377200000 290377300000 290377400000 290377500000 290377600000 290377700000 290377800000 290377910000 290377920000 290377930000 290377940000 290377950000 290377990003 290377990005 290377999999 290378000000 290379100000 290379200000 290379300000 290379400000 290379900001 290379909999 290381000000 290382000000 290383000000 290389100000 290389900001 290389900002 290389909999 290391000001 290391000002 290391000003 290392000001 290392000002 290393000000 290394000000 290399000001 290399000002 290399000003 290399000004 290399009999 290410000000 290420110000 290420120000 290420130000 290420140000 290420200001 290420200002 290420900001 290420900002 290420900003 290420900004 290420900005 290420900006 290420900007 290420900008 290420900009 290420900010 290420900011 290420900012 290420900013 290420909999 290431000000 290432000000 290433000000 290434000000 290435000000 290436000000 290491000000 290499000000 290511000000 290512000001 290512000002 290513000000 290514000000 290516000000 290517000000 290519100000 290519200000 290519900001 290519900002 290519900003 290519909999 290522000000 290529000001 290529000002 290529000003 290529009999 290531000000 290532000000 290539000001 290539000002 290539000003 290539009999 290541000000 290542000000 290543000000 290544000000 290545000000 290549100000 290549200000 290549300000 290549400000 290549900000 290551000000 290551000901 290559000001 290559009999 290611000000 290612000000 290613000000 290619000001 290619009999 290621000000 290629000001 290629000002 290629009999 290711100000 290711200000 290711900001 290711900002 290711900003 290711909999 290712000000 290713000000 290715000000 290719000000 290721000000 290722000000 290723000000 290729000001 290729000002 290729000003 290729000004 290729009999 290811000000 290819000001 290819000002 290819009999 290891000000 290892000000 290899100000 290899200000 290899900001 290899900002 290899909999 290911000000 290919100000 290919910000 290919920000 290919930000 290919940000 290919990000 290920000000 290930100000 290930900000 290941000000 290943000000 290944000000 290949000000 290950000000 290960100000 290960900000 291010000000 291020000000 291030000000 291040000000 291050000000 291090000001 291090009999 291100000001 291100000002 291100000003 291100009999 291211000000 291212000000 291219000001 291219000002 291219000003 291219000004 291219000005 291219000006 291219000007 291219000008 291219000009 291219000010 291219000011 291219009999 291221000000 291229000001 291229000002 291229000003 291229000004 291229009999 291241000000 291242000000 291249000001 291249000002 291249000003 291249000004 291249009999 291250000000 291260000000 291300000000 291411000000 291412000000 291413000000 291419000001 291419009999 291422000001 291422000002 291423000001 291423000002 291429000000 291431000000 291439000001 291439000002 291439000003 291439000004 291439000005 291439000006 291439000007 291439000008 291439009999 291440000001 291440000002 291450000000 291461000000 291462000000 291469000001 291469000002 291469000003 291469009999 291471000000 291479000001 291479009999 291511000000 291512000001 291512000002 291512000003 291512000004 291512009999 291513000001 291513000002 291513000003 291513000004 291513000005 291513009999 291521100000 291521200000 291524000000 291529000001 291529000002 291529000003 291529000004 291529000005 291529000006 291529000007 291529000008 291529000009 291529000010 291529000011 291529009999 291531000000 291532000000 291533000000 291536000000 291539000001 291539000002 291539000003 291539000004 291539000005 291539000006 291539000007 291539009999 291540000001 291540000002 291540000003 291550000000 291560000001 291560000002 291570110000 291570190000 291570900001 291570900002 291570900003 291570900004 291570900005 291570909999 291590000001 291590000002 291590000003 291590000004 291590000005 291590000006 291590009999 291611000000 291612000000 291613000000 291614000000 291615000001 291615000002 291615000003 291616000000 291619000001 291619000002 291619009999 291620000000 291631100000 291631200001 291631200002 291631200003 291631200004 291631209999 291632000001 291632000002 291634000000 291639000001 291639000002 291639000003 291639000004 291639000005 291639000006 291639000007 291639000008 291639000009 291639000010 291639000011 291639000012 291639000013 291639009999 291711000001 291711000002 291711000003 291711000004 291711000005 291711009999 291712000000 291713000001 291713000002 291714000000 291719000001 291719000002 291719000003 291719009999 291720000000 291732000000 291733000000 291734000000 291735000000 291736000000 291737000000 291739100000 291739900001 291739900002 291739909999 291811000001 291811000002 291811000003 291811000004 291811000005 291811000006 291811000007 291811000008 291811000009 291811000010 291811009999 291812000000 291813000001 291813000002 291813000003 291813000004 291813000005 291813000006 291813000007 291813000008 291813000009 291813000010 291813009999 291814000000 291815100000 291815200000 291815300000 291815900001 291815900002 291815900003 291815900004 291815900005 291815900006 291815909999 291816000001 291816000002 291816009999 291817000000 291818000000 291819000001 291819000002 291819000003 291819000004 291819009999 291821000001 291821000002 291821000003 291821009999 291822000000 291823000001 291823000002 291823000003 291823000004 291823000005 291823000006 291823000007 291823000008 291823009999 291829000001 291829000002 291829000003 291829000004 291829000005 291829000006 291829000007 291829000008 291829000009 291829000010 291829000011 291829000012 291829000013 291829009999 291830100000 291830200000 291830300000 291830400000 291830900000 291891000000 291899100000 291899900001 291899900002 291899900003 291899900004 291899900005 291899900006 291899900007 291899900008 291899900009 291899900010 291899900011 291899909999 291910000000 291990000001 291990000002 291990000003 291990000004 291990000005 291990009999 292011000000 292019000001 292019009999 292021000000 292022000000 292023000000 292024000000 292029000000 292030000000 292090500000 292090600000 292090700000 292090910000 292090990000 292111000001 292111000002 292111000003 292112000000 292113000000 292114000000 292119100000 292119200000 292119200901 292119300000 292119400000 292119520000 292119540000 292119590001 292119599999 292119910000 292119990000 292121000000 292122000000 292129000001 292129009999 292130000000 292141000000 292142000001 292142000901 292142000002 292142000003 292142000004 292142009999 292143000000 292144000000 292145000000 292146000001 292146000002 292146000003 292146000004 292146000005 292146000006 292146000007 292146000008 292146000009 292146000901 292146000902 292146000903 292146000904 292146000905 292146000906 292146000907 292146000908 292149000000 292149000901 292151000000 292159000001 292159000002 292159000003 292159000004 292159009999 292211000000 292212000000 292214000000 292214000901 292215000000 292216000000 292217100000 292217200000 292218000000 292219110000 292219120000 292219190000 292219500000 292219900000 292221000000 292229000001 292229000002 292229009999 292231000000 292231000901 292239000000 292241000000 292242000000 292243000000 292244000000 292244000901 292249000000 292250000001 292250000002 292250009999 292310000000 292320000000 292330000000 292340000000 292390000001 292390000002 292390000003 292390000004 292390009999 292411000000 292411000901 292412000000 292419000001 292419000002 292419000003 292419009999 292421000000 292423000000 292424000000 292424000901 292425000000 292429100000 292429200000 292429300000 292429400000 292429500000 292429900000 292511000000 292512000000 292512000901 292519000000 292521000000 292529110000 292529120000 292529130000 292529140000 292529190000 292529200000 292529300000 292529400000 292529900000 292610000000 292620000000 292630000000 292640000000 292690100000 292690900001 292690900002 292690900003 292690900004 292690900005 292690900006 292690900007 292690900008 292690900009 292690909999 292700000001 292700000002 292700000003 292700000004 292700000005 292700000006 292700000007 292700000008 292700000009 292700000010 292700000011 292700000012 292700000013 292700000014 292700000015 292700000016 292700000017 292700000018 292700000019 292700000020 292700000021 292700009999 292800000001 292800000002 292800000003 292800000004 292800000005 292800000006 292800000007 292800000008 292800000009 292800000010 292800000011 292800000012 292800000013 292800000014 292800000015 292800000016 292800000017 292800000018 292800000019 292800000020 292800000021 292800000022 292800000023 292800000024 292800000025 292800009999 292910000000 292990110000 292990190000 292990200000 292990300000 292990400000 292990900001 292990900002 292990909999 293010000000 293020000001 293020000002 293030000000 293040000000 293060000000 293070000000 293080000000 293090110000 293090120000 293090190001 293090199999 293090210000 293090220000 293090230000 293090240000 293090250000 293090260000 293090270000 293090290000 293090310000 293090320000 293090390000 293090410000 293090420000 293090430000 293090440000 293090490000 293090510000 293090590000 293090610000 293090620000 293090690000 293090720000 293090730000 293090790000 293090910000 293090920000 293090930000 293090940000 293090950000 293090960000 293090970000 293090990000 293110100000 293110200000 293120000000 293141000000 293142000000 293143000000 293144000000 293145000000 293146000000 293147000000 293148000000 293149100000 293149300000 293149400000 293149710000 293149720000 293149730000 293149740000 293149790000 293149910000 293149920000 293149990000 293151000000 293152000000 293153000000 293154000000 293159100001 293159100002 293159100003 293159100004 293159100005 293159100006 293159100007 293159100008 293159100009 293159109999 293159210000 293159220000 293159230000 293159240000 293159290000 293190510000 293190520000 293190530000 293190590000 293190900000 293211000000 293212000000 293213000001 293213000002 293214000000 293219000000 293220100000 293220200000 293220900000 293291000000 293292100000 293292900001 293292909999 293293000000 293294000000 293295000000 293295000901 293296000000 293299000001 293299000002 293299000003 293299000004 293299000005 293299000006 293299000007 293299000008 293299000009 293299000010 293299000011 293299000012 293299000013 293299000014 293299000015 293299009999 293311000000 293311000901 293319000000 293321000001 293321000002 293321000003 293321000004 293321009999 293329000000 293331000000 293332000000 293333000000 293333000901 293334000000 293334000901 293335000000 293336000000 293337000000 293339100000 293339200000 293339300000 293339900001 293339900002 293339900003 293339900004 293339909999 293341000000 293341000901 293349000000 293352000000 293353000001 293353000901 293353000002 293353000003 293353000004 293353000005 293353000006 293353000007 293353000008 293353000009 293353000010 293353000011 293353000012 293354000000 293354000901 293355000001 293355000901 293355000002 293355000003 293355000004 293359000000 293359000901 293361000000 293369000000 293371000000 293372000001 293372000901 293372000002 293379000000 293379000901 293391000001 293391000901 293391000002 293391000003 293391000004 293391000005 293391000006 293391000007 293391000008 293391000009 293391000010 293391000011 293391000012 293391000013 293391000014 293391000015 293391000016 293391000017 293391000018 293391000019 293391000020 293391000021 293391000022 293391000023 293391000024 293391000025 293391000026 293391000027 293391000028 293392000000 293392000901 293399100001 293399100002 293399100003 293399910000 293399920000 293399990000 293410000000 293410000901 293420000000 293420000901 293430000000 293430000901 293491000001 293491000901 293491000002 293491000003 293491000004 293491000005 293491000006 293491000007 293491000008 293491000009 293491000010 293491000011 293491000012 293491000013 293492000000 293492000901 293499100000 293499910000 293499100901 293499920000 293499920901 293499930000 293499930901 293499990000 293499990901 293510000000 293520000000 293530000000 293540000000 293550000000 293590000000 293621000901 293621000902 293622100901 293622100902 293622900901 293622900902 293623000901 293623000902 293624100901 293624100902 293624900901 293624900902 293625100901 293625100902 293625900901 293625900902 293626000901 293626000902 293627000901 293627000902 293628000901 293628000902 293629100901 293629100902 293629200901 293629200902 293629300901 293629300902 293629400901 293629400902 293629500901 293629500902 293629600901 293629600902 293629700901 293629700902 293629910000 293629990000 293629990901 293629990902 293690000000 293690000901 293690000902 293711000000 293712000000 293719000000 293721000001 293721000002 293721000003 293721000004 293722000000 293723000001 293723000002 293729000000 293750000001 293750000002 293790000000 293810000000 293810000901 293890000001 293890000901 293890009999 293911000001 293911000002 293911000003 293911009999 293919000001 293919000002 293919000003 293919000004 293919000005 293919000006 293919009999 293920000001 293920000002 293920009999 293930000000 293941000000 293942000000 293943000000 293944000000 293945000000 293945000901 293949000000 293951000000 293959000001 293959009999 293959009001 293961000000 293962000000 293963000000 293969000000 293972100000 293972200000 293972900000 293979000000 293980100000 293980100901 293980200000 293980200901 293980900000 293980900901 294000000001 294000000002 294000000003 294000000004 294000000005 294000000006 294000000007 294000000008 294000000009 294000000010 294000000011 294000009999 294110000001 294110000002 294110000003 294110000004 294110009999 294120000001 294120000901 294120000002 294120000902 294120000003 294120000903 294120009999 294130000001 294130000002 294130000003 294130009999 294140000001 294140000002 294140000003 294140009999 294150000001 294150000002 294150000003 294150000004 294150000005 294150009999 294190000001 294190000002 294190000003 294190000004 294190000005 294190000006 294190009999 294200000001 294200000002 294200000003 294200000004 294200009999 '"/>
            <let name="codes07" value="' 300120100000 300120200000 300190110000 300190120000 300190130000 300190190000 300190210000 300190290000 300190310000 300190390000 300190900000 300212100000 300212200000 300212910000 300212990000 300213100000 300213200000 300214100000 300214200000 300215100000 300215900000 300241000000 300242000000 300249200001 300249200002 300249200003 300249200004 300249200005 300249200006 300249200007 300249200008 300249200009 300249200010 300249200011 300249200012 300249200013 300249200014 300249200015 300249200016 300249200017 300249200018 300249200019 300249200020 300249200021 300249200022 300249200023 300249200024 300249200025 300249200026 300249200027 300249200028 300249200029 300249200030 300249200031 300249200032 300249200033 300249200034 300249200035 300249200036 300249200037 300249200038 300249200039 300249300001 300249300002 300249300003 300249300004 300249400001 300249400002 300249400003 300249400004 300249400005 300249400006 300249400007 300249400008 300249400009 300249400010 300249400011 300249400012 300249400013 300249400014 300249400015 300249500001 300249500002 300249500003 300249500004 300249500005 300249500006 300249500007 300249500008 300249500009 300249500010 300249500011 300249500012 300249500013 300249600001 300249600002 300249900001 300249900002 300249909999 300251100000 300251200000 300259100000 300259200000 300290000001 300290000002 300290009999 300310000001 300310000002 300310000003 300310000004 300320000001 300320000002 300331100000 300331200000 300339000001 300339000002 300339000003 300339000004 300339000005 300339000006 300339000007 300339000008 300339000009 300339000010 300339000011 300339000012 300339009999 300341100000 300341200000 300342100000 300342200000 300343100000 300343200000 300349100000 300349200000 300360000000 300390000001 300390000002 300410000001 300410000002 300410000003 300410000004 300420000001 300420000002 300431110000 300431120000 300431210000 300431220000 300432100000 300432200000 300439000001 300439000002 300439000003 300439000004 300439000005 300439000006 300439000007 300439000008 300439000009 300439000010 300439000011 300439000012 300439009999 300441100000 300441200000 300442100000 300442200000 300443100000 300443200000 300449100000 300449200000 300450000001 300450000002 300460100000 300460200000 300490110001 300490119999 300490120000 300490910001 300490910002 300490919999 300490920000 300510000000 300590100000 300590210000 300590220001 300590229999 300590900000 300610100000 300610200000 300610300000 300610400000 300630000000 300640100000 300640900000 300650000000 300660100000 300660200000 300670100000 300670200000 300691100000 300691200000 300692000000 300693100000 300693210000 300693220000 000000000000 '"/>
            <let name="codes08" value="' 310100000001 310100000003 310100000005 310100000006 310100000009 310210100000 310210200000 310210300000 310221100000 310221200000 310221900000 310229100000 310229900000 310230100000 310230900000 310240100000 310240900000 310250100000 310250900000 310260100000 310260900000 310280100000 310280900000 310290000001 310290000002 310290000003 310290009999 310311000000 310319000000 310390100000 310390200000 310390300000 310390400000 310390900001 310390909999 310420000001 310420000002 310430000001 310430000002 310490110000 310490190000 310490310000 310490390000 310490410000 310490490000 310510000001 310510000002 310510000003 310510009999 310520000000 310530100000 310530200000 310540000001 310540000002 310551000000 310559000002 310559000003 310559000004 310560000000 310590000001 310590000002 310590000003 310590009999 320110000000 320120000000 320190000000 320210000000 320290000001 320290000002 320290000003 320290009999 320300110000 320300190001 320300190002 320300199999 320300200001 320300200002 320411000000 320412000000 320413000000 320414000000 320415000000 320416000000 320417000000 320418000000 320419000000 320420000000 320490100000 320490900001 320490909999 320500000001 320500000002 320500000003 320611000000 320619000001 320619009999 320620000000 320641000000 320642000000 320649000001 320649000002 320649009999 320650000000 320710000000 320720000000 320730000000 320740000000 320810100000 320810200000 320810900001 320810909999 320820100000 320820200000 320820900001 320820909999 320890100000 320890200000 320890900001 320890900002 320890909999 320910100000 320910200000 320910900001 320910909999 320990100000 320990200000 320990900001 320990900002 320990909999 321000100000 321000200000 321000910000 321000920000 321000930000 321000990000 321100000002 321100009999 321210000000 321290100000 321290900001 321290900002 321290900003 321290909999 321310100000 321310900000 321390000000 321410100000 321410200000 321410300000 321410400000 321410500000 321410600000 321410700000 321410800000 321410910000 321410920000 321410930000 321410940000 321410990001 321410999999 321490000001 321490000002 321490009999 321511000001 321511000002 321511000003 321511000004 321511000005 321511009999 321519000001 321519000002 321519000003 321519000004 321519000005 321519000006 321519009999 321590100000 321590200001 321590200002 321590300000 321590400000 321590500000 321590600000 321590700000 321590800000 321590910000 321590920000 321590990000 330112000000 330113000000 330119000000 330124000000 330125000000 330129000000 330129000901 330130100000 330130900000 330190110000 330190120000 330190130000 330190140000 330190160000 330190170000 330190180000 330190190000 330190190901 330190900000 330210000000 330290000000 330300100001 330300100002 330300100901 330300100902 330300200000 330300900001 330300900002 330300909999 330410000000 330420000000 330430100000 330430200000 330430900000 330491100000 330491900000 330499100000 330499200000 330499310001 330499310002 330499390000 330499390901 330499400000 330499910000 330499920000 330499930000 330499940000 330499950000 330499960000 330499970000 330499990000 330499990901 330510100000 330510200000 330510900000 330520000000 330530000000 330590100000 330590200000 330590300000 330590900000 330590900901 330610110000 330610120000 330610200000 330610910001 330610910002 330610920001 330610920002 330610990001 330610990002 330620000000 330690110000 330690120000 330690200000 330690900000 330710100000 330710900000 330720000000 330730000000 330741100000 330741200000 330741300000 330741900000 330749100000 330749200000 330749900000 330790100000 330790200001 330790200002 330790200003 330790400001 330790400002 330790500000 330790900019 330790909999 340111300000 340111400000 340111500000 340111700000 340111800000 340111800901 340111900000 340119200000 340119300000 340119400000 340119900000 340120100000 340120200000 340120300000 340120900000 340130000000 340130000901 340231000000 340239000000 340241000000 340242000000 340249000000 340250100000 340250210000 340250220000 340250290000 340290000004 340290009999 340311000000 340319100000 340319200000 340319300000 340319400000 340319500000 340319900002 340319909999 340391000000 340399000000 340420000000 340490100000 340490900000 340510000000 340520000000 340530000000 340540000000 340590100000 340590200000 340590900000 340600000000 340700100000 340700200000 340700300000 340700900001 340700900002 340700900003 340700909999 350110000000 350190100000 350190900000 350211000000 350219000000 350220000000 350290000000 350300100000 350300900000 350400100000 350400900000 350510100000 350510200000 350510300000 350510400000 350510900000 350520100000 350520200000 350520300000 350520900000 350610000000 350691000000 350699000005 350699009999 350710100000 350710900000 350790100000 350790200000 350790300000 350790400000 350790500000 350790600000 350790900008 350790909999 360100000002 360100000003 360100000006 360100009999 360200000003 360200000004 360200000005 360200000006 360200009999 360310000000 360320000001 360320009999 360330000000 360340000000 360350000001 360350000002 360350000003 360350009999 360360000000 360410100000 360410200000 360490000000 360500000000 360610000000 360690100000 360690900000 370110000000 370120000000 370130000000 370191000000 370199000000 370210000000 370231000000 370232000000 370239000000 370241000000 370242000000 370243000000 370244000000 370252000000 370253000000 370254000000 370255000000 370256000000 370296000000 370297000000 370298000000 370310000000 370320000000 370390000000 370400000001 370400000002 370400000003 370400000004 370400000005 370500000000 370610100000 370610900000 370690100000 370690900000 370710000000 370790100000 370790200000 370790300000 370790400000 370790500000 370790900000 380110100000 380110200000 380110900000 380120000000 380130000000 380190100000 380190900000 380210000000 380290000000 380300000001 380300000002 380400000000 380510000000 380590000000 380610000000 380620000000 380630000000 380690000000 380700000001 380700000002 380700000003 380700000004 380700000005 380700000006 380700009999 380852000000 380859000000 380861000000 380862000000 380869000000 380891100000 380891910000 380891990001 380891990002 380892100000 380892900000 380893100000 380893900000 380894110000 380894190000 380894200000 380894900000 380899100000 380899900001 380899909999 380910100000 380910900000 380991100000 380991900000 380992000000 380993000000 381010000001 381010000002 381090000001 381090009999 381111000000 381119000000 381121000000 381129000000 381190000004 381190009999 381210000000 381220000000 381231000000 381239000001 381239009999 381300100000 381300200000 381300300000 381300400000 381300900000 381400100000 381400200000 381400300000 381400900001 381400900002 381400900003 381400900004 381400909999 381511000000 381512000001 381512009999 381519000000 381590000001 381590009999 381600000001 381600000002 381600000003 381600000004 381600000005 381600000006 381600009999 381700000001 381700000002 381800000001 381800000002 381900000001 381900000002 382000000001 382000000002 382100100001 382100109999 382100200001 382100209999 382100310001 382100319999 382100390001 382100399999 382100400001 382100409999 382100900001 382100909999 382211000000 382212000000 382213000000 382219110000 382219200000 382219900000 382290000001 382290009999 382311000000 382312000000 382313000000 382319000001 382319009999 382370000000 382410000000 382430000000 382440000000 382450000000 382460000000 382481000000 382482000000 382483000000 382484000000 382485000000 382486000000 382487000000 382488000000 382489000000 382491000000 382492000000 382499100000 382499200000 382499300000 382499400000 382499500000 382499600000 382499700000 382499800000 382499910000 382499920000 382499930000 382499940000 382499950000 382499960000 382499970000 382499980000 382499990001 382499990002 382499990003 382499990004 382499990005 382499990006 382499990007 382499990008 382499990009 382499990010 382499990011 382499990012 382499990013 382499990014 382499990015 382499999999 382510000000 382520000000 382530000000 382541000000 382549000000 382550000000 382561000000 382569000000 382590000000 382600000000 382711000001 382711000002 382711009999 382712000000 382713000000 382714000000 382720000000 382731000000 382732000000 382739000001 382739000002 382739000003 382739000004 382739000005 382739000006 382739009999 382740000000 382751000000 382759000001 382759000002 382759000003 382759000004 382759000005 382759000006 382759000007 382759000008 382759000009 382759000010 382759000011 382759009999 382761000000 382762000000 382763000000 382764000000 382765000000 382768000000 382769000000 382790000000 '"/>
            <let name="codes09" value="' 390110000000 390120000000 390130000000 390140000000 390190000000 390210000000 390220000000 390230000000 390290000001 390290009999 390311000000 390319000000 390320000000 390330000000 390390000001 390390009999 390410000000 390421000000 390422000000 390430000000 390440000000 390450000000 390461000000 390469000000 390490000000 390512000000 390519000000 390521000000 390529000000 390530000000 390591000000 390599000001 390599009999 390610000000 390690100000 390690900000 390710000000 390721000000 390729000000 390730000000 390740000000 390750000000 390761000000 390769000000 390770000000 390791000000 390799000000 390810000000 390890000000 390910000000 390920000000 390931000000 390939000000 390940000001 390940000002 390950000000 391000000001 391000000002 391000009999 391110000000 391120000000 391190000000 391211000000 391212000000 391220000000 391231000000 391239000001 391239000002 391239000003 391239009999 391290000000 391310000000 391390000001 391390000002 391390000003 391390009999 391400100000 391400200000 391400900000 391510000000 391520000000 391530000000 391590000000 391610100000 391610200000 391620100000 391620200000 391690100000 391690200000 391710000001 391710000002 391721000001 391721000002 391721000003 391721009999 391722000001 391722000002 391722000003 391723000001 391723000002 391723000003 391729000001 391729000002 391729000003 391731000001 391731000002 391731000003 391732100000 391732900000 391733000000 391739000000 391740000000 391810000001 391810000002 391890000001 391890000002 391910000000 391990000001 391990009999 392010000000 392020000000 392030000000 392043000000 392049100010 392049100020 392049900000 392051000000 392059000000 392061000000 392062000000 392063000000 392069000000 392071000000 392073000000 392079000000 392091000000 392092000000 392093000000 392094000000 392099000000 392111000000 392112000000 392113000000 392114000000 392119100000 392119900000 392190100000 392190900000 392210000001 392210000002 392210000003 392210000004 392220000000 392290000001 392290000002 392290009999 392310100000 392310200000 392310900001 392310900002 392310909999 392321100901 392321100902 392321100903 392321100904 392321100905 392321100906 392321100907 392321900901 392321900902 392321900903 392321900904 392321900905 392321900906 392321900907 392321900999 392329100901 392329100902 392329100903 392329100904 392329100905 392329100906 392329100907 392329900901 392329900902 392329900903 392329900904 392329900905 392329900906 392329900907 392330000001 392330000002 392330000003 392330009999 392340000000 392350000000 392390000001 392390000002 392390009999 392410100001 392410100002 392410200001 392410200002 392410200003 392410310001 392410310002 392410310003 392410390001 392410390002 392410390003 392410390004 392410400000 392410900001 392410900002 392410900003 392410909999 392490100000 392490300000 392490400000 392490900001 392490900002 392490900003 392490900004 392490900005 392490909999 392510000000 392520110000 392520190000 392520210000 392520290000 392520310000 392520390000 392530000000 392590000001 392590000002 392590000003 392590000004 392590000005 392590000006 392590009999 392610000000 392620100000 392620900001 392620900002 392620909999 392630000001 392630000002 392630009999 392640000000 392690310000 392690320000 392690390001 392690390002 392690390003 392690390004 392690390005 392690399999 392690400000 392690500000 392690610000 392690690001 392690690002 392690690003 392690690004 392690699999 392690700001 392690700002 392690800000 392690910000 392690920000 392690930000 392690990003 392690990004 392690990005 392690990006 392690990007 392690990008 392690990009 392690990010 392690990011 392690990012 392690999999 400110000000 400121000000 400122000000 400129000001 400129000002 400130000000 400211000000 400219000000 400220000001 400220000002 400220000003 400220000004 400220009999 400231000000 400239000000 400241000000 400249000000 400251000000 400259000000 400260000000 400270000000 400280000000 400291000000 400299000000 400300000000 400400000000 400400000901 400400000902 400400000903 400400000904 400400000905 400400000906 400400000907 400400000908 400510000000 400520000000 400591000001 400591000002 400591000003 400599000000 400610000000 400690100000 400690200000 400690300000 400690400001 400690400002 400690400003 400690900001 400690909999 400700000000 400811000001 400811000002 400811000003 400811000004 400819000000 400821000001 400821000002 400821000003 400821000004 400829000000 400911100000 400911900000 400912100000 400912900000 400921110000 400921190000 400921910000 400921990000 400922110000 400922190000 400922910000 400922920000 400922990000 400931110000 400931120000 400931130000 400931140000 400931190000 400931910000 400931920000 400931990000 400932110000 400932120000 400932130000 400932140000 400932190000 400932910000 400932920000 400932990000 400941110000 400941120000 400941130000 400941140000 400941190000 400941910000 400941920000 400941990000 400942110000 400942120000 400942130000 400942140000 400942190000 400942910000 400942920000 400942990000 401011000000 401012000000 401019000000 401031000000 401032000000 401033000000 401034000000 401035000000 401036000000 401039000000 401110100000 401110200000 401120100000 401120200000 401120900000 401130000000 401140000000 401150000000 401170000000 401180000000 401190000000 401211000000 401212000000 401213000000 401219000000 401220000001 401220000002 401220000003 401290000000 401310000000 401320000000 401390000002 401390009999 401410000000 401490100001 401490100002 401490100003 401490100004 401490100005 401490100006 401490100007 401490100008 401490200000 401490900001 401490909999 401512110000 401512120000 401512200000 401519100000 401519900000 401590100001 401590100002 401590200000 401590300000 401590400001 401590400002 401590400003 401590400004 401590400005 401590400006 401590900000 401610000001 401610000002 401610000003 401610009999 401691000000 401692000001 401692000002 401693000001 401693000002 401694000000 401695100000 401695900000 401699100000 401699200000 401699300000 401699400000 401699500000 401699900000 401700100000 401700210000 401700220000 401700300000 401700400000 401700500000 401700600000 401700900001 401700900002 401700900003 401700900004 401700900005 401700909999 410120000000 410150000000 410190000000 410210000000 410221000000 410229000000 410320000000 410330000000 410390000000 410411000000 410419000000 410441000000 410449000000 410510000000 410530000000 410621000000 410622000000 410631000000 410632000000 410640000000 410691000000 410692000000 410711000000 410712000000 410719000000 410791000000 410792000000 410799000000 411200000000 411310000000 411320000000 411330000000 411390000000 411410000000 411420000000 411510000000 411520000000 '"/>
            <let name="codes10" value="' 420100000161 420100000162 420100000163 420211100000 420211200000 420211300000 420211910000 420211990000 420212100001 420212100002 420212100003 420212100004 420212100005 420212100006 420212100007 420212100008 420212109999 420212200001 420212200002 420212200003 420212200004 420212200005 420212200006 420212209999 420212300000 420212900000 420219100000 420219200000 420219900000 420221000000 420222000000 420229000000 420231000000 420232000000 420239000000 420291000000 420292000000 420299000000 420310000000 420321000000 420329000001 420329000002 420330000000 420340000000 420500100000 420500200000 420500300000 420500400001 420500400002 420500500000 420500600001 420500600002 420500600003 420500600004 420500900000 420600000000 430110000000 430130000000 430160000000 430180000000 430190000000 430211000000 430219000000 430220000000 430230000000 430310100000 430310900000 430390000000 430400100000 430400200000 430400900001 430400909999 440111000001 440111000002 440111000003 440111000004 440111009999 440112000001 440112000002 440112000003 440112000004 440112009999 440121000001 440121000002 440121009999 440122000001 440122000002 440122009999 440131000000 440132000000 440139000000 440141000000 440149000000 440210000001 440210000002 440210000003 440210000004 440210000005 440210000006 440210009999 440220000000 440290000001 440290000002 440290009999 440311100000 440311900000 440312100000 440312900001 440312900002 440312900003 440312909999 440321100000 440321900001 440321900002 440321900003 440321909999 440322100000 440322900001 440322900002 440322900003 440322909999 440323100000 440323900001 440323900002 440323900003 440323909999 440324100000 440324900001 440324900002 440324900003 440324909999 440325100000 440325900001 440325900002 440325900003 440325909999 440326100000 440326900001 440326900002 440326900003 440326909999 440341200000 440341900000 440342000000 440349200000 440349900000 440391200000 440391900001 440391900002 440391900005 440391909999 440393000000 440394000000 440395000000 440396000000 440397000000 440398000000 440399200000 440399900001 440399900002 440399900005 440399909999 440410100001 440410100002 440410200001 440410200002 440410200003 440410300000 440410400000 440410500001 440410500002 440410500003 440410500004 440410500005 440410500006 440410500007 440410500008 440410500009 440410509999 440410900000 440420100001 440420100002 440420200001 440420200002 440420200003 440420300000 440420400000 440420500000 440420900000 440500100000 440500200000 440611000000 440612000000 440691000000 440692000000 440711100000 440711200000 440711900000 440712100000 440712200000 440712900000 440713000000 440714000000 440719100000 440719200000 440719900000 440721000000 440722000000 440723000000 440725100000 440725200000 440725900000 440726100000 440726200000 440726900000 440727000000 440728000000 440729000000 440791100000 440791200000 440791900000 440792100000 440792200000 440792900000 440793000000 440794000000 440795000000 440796000000 440797000000 440799100001 440799100002 440799100003 440799100004 440799109999 440799200001 440799200002 440799200003 440799200004 440799209999 440799900001 440799900002 440799900003 440799900004 440799900005 440799900006 440799900007 440799900008 440799909999 440810100000 440810200000 440810900000 440831100000 440831200000 440831900000 440839100000 440839200000 440839900000 440890100000 440890200000 440890900000 440910100000 440910200000 440910300000 440910400001 440910400002 440910500001 440910500002 440910600000 440910700001 440910700002 440910700003 440910709999 440910900000 440921100000 440921900000 440922000000 440929100000 440929900000 441011000001 441011000002 441011000003 441011009999 441012000001 441012000002 441012000003 441012009999 441019000001 441019000002 441019000003 441019009999 441090000001 441090000002 441090000003 441090000004 441090000005 441090000006 441090000007 441090000008 441090000009 441090009999 441112000000 441113000000 441114000000 441192000000 441193000000 441194000000 441210000001 441210000002 441210000003 441231000000 441233000000 441234000000 441239000000 441241000000 441242000000 441249000000 441251000000 441252000000 441259000000 441291000000 441292000000 441299000000 441300000001 441300000002 441300000003 441300000004 441300000005 441410000000 441490000000 441510100001 441510100002 441510100003 441510100004 441510200001 441510200002 441510400001 441510400002 441510900000 441520000001 441520000002 441520000003 441520000004 441600000000 441700100000 441700200000 441700300000 441700400001 441700400002 441700500001 441700500002 441700600000 441700900001 441700900002 441700909999 441811100000 441811200000 441819100000 441819200000 441821100000 441821200000 441829100000 441829200000 441830000000 441840000000 441850000001 441850000002 441873000000 441874000000 441875000000 441879000000 441881000000 441882000000 441883000000 441889000000 441891000000 441892000000 441899100000 441899200000 441899900001 441899909999 441911000000 441912000000 441919000000 441920000000 441990000001 441990000002 441990000003 441990000004 441990000005 441990000006 441990000007 441990000008 441990000009 441990000010 441990000011 441990000012 441990000013 441990000014 441990000015 441990000016 441990009999 442011000000 442019000000 442090100001 442090100002 442090100003 442090109999 442090200000 442090300000 442090400000 442090900001 442090900002 442090900003 442090900004 442090909999 442110000000 442120000000 442191000000 442199100001 442199100002 442199100003 442199200001 442199200002 442199200003 442199200004 442199209999 442199300000 442199400000 442199500000 442199600000 442199700000 442199800000 442199910000 442199920000 442199930000 442199940000 442199950000 442199960000 442199990001 442199999999 450110000001 450110000002 450190000001 450190000002 450190000003 450190000004 450200100001 450200100002 450200100003 450200100004 450200100005 450200100006 450200100007 450200109999 450200200001 450200200002 450200200003 450200200004 450200200005 450200200006 450200200007 450200900000 450310000000 450390100000 450390210000 450390220000 450390300001 450390300002 450390410000 450390420000 450390490000 450390900000 450410100000 450410900000 450490100000 450490210000 450490220000 450490300001 450490300002 450490400001 450490400002 450490900000 460121000001 460121000002 460121000003 460121009999 460122000001 460122000002 460122000003 460122009999 460129000000 460192000000 460193000000 460194000000 460199000000 460211000000 460212000000 460219100000 460219900000 460290110000 460290120001 460290120002 460290130000 460290140001 460290140002 460290140003 460290149999 460290150000 460290160001 460290160002 460290169999 460290170000 460290180001 460290180002 460290189999 460290190000 460290900000 470100000000 470200000000 470311000000 470319000000 470321000000 470329000000 470411000000 470419000000 470421000000 470429000000 470500000000 470610000000 470620000000 470630000000 470691000000 470692000000 470693000000 470710000005 470710000006 470720000000 470730000000 470790100000 470790900000 480100000000 480210000000 480220000000 480240000000 480254000000 480255000000 480256000000 480257000000 480258000000 480261000000 480262000000 480269000000 480300100001 480300100002 480300100003 480300100004 480300100005 480300100006 480300100007 480300900001 480300900002 480300909999 480411000000 480419000000 480421000000 480429000000 480431000000 480439000000 480441000000 480442000000 480449000000 480451000000 480452000000 480459000000 480511000000 480512000000 480519100004 480519100005 480519200000 480519900000 480524000000 480525000000 480530000000 480540000000 480550000000 480591000000 480592000000 480593000000 480610000000 480620000000 480630000000 480640000001 480640000002 480640000003 480640000004 480640000005 480640000006 480700000001 480700000002 480700000003 480700000004 480810000001 480810000002 480840000001 480840000002 480840000003 480840000004 480890000000 480920000001 480920000002 480990000000 481013000000 481014000000 481019000001 481019000002 481022000001 481022000002 481022000003 481022000004 481029000001 481029000002 481029000003 481031000000 481032000000 481039000000 481092000000 481099000000 481110000001 481110000002 481110000003 481141100000 481141900000 481149000000 481151000000 481159000001 481159000901 481159000002 481159000003 481160000000 481190000001 481190000002 481190000003 481190000004 481190000005 481190009999 481200000000 481310000000 481320000000 481390000000 481420000001 481420000002 481420000003 481420000004 481420000005 481420000006 481420000007 481420000008 481420000009 481420000010 481490000001 481490000002 481620000000 481690000001 481690000002 481710000000 481720000001 481720000002 481720000003 481730000001 481730000002 481730000003 481730000004 481730000005 481730000006 481810000000 481820000001 481820000002 481820000003 481830100000 481830900000 481850000000 481890000001 481890000002 481890009999 481910100001 481910100002 481910100003 481910900013 481910900014 481910900015 481910909999 481920100001 481920100002 481920100003 481920900000 481930000000 481940000000 481950000000 481960000001 481960000002 481960000003 481960000004 482010000001 482010000002 482010000003 482010000004 482010000005 482010000006 482010000007 482010000008 482020000001 482020000002 482020000003 482020000004 482020000005 482020000006 482020000007 482020000008 482030100001 482030100002 482030100003 482030900001 482030900002 482030900003 482040000000 482050000000 482090000001 482090000002 482090000003 482090000004 482110000000 482190000000 482210000001 482210000002 482210000003 482210000004 482290000000 482320000000 482340000001 482340000002 482340000003 482361000001 482361000002 482361000003 482361000004 482369000001 482369000002 482369000003 482369000004 482370100000 482370900000 482390100001 482390100002 482390100003 482390100004 482390100005 482390200001 482390200002 482390200003 482390300001 482390300002 482390400001 482390400002 482390400003 482390400004 482390500000 482390600000 482390700001 482390700002 482390700003 482390700004 482390800000 482390910001 482390910002 482390920000 482390930001 482390930002 482390940000 482390990001 482390990002 482390990004 482390990005 482390999999 '"/>
            <let name="codes11" value="' 490110100000 490110900000 490191000001 490191000002 490191000003 490191000004 490191000005 490191000006 490191000007 490191000008 490191000009 490191000010 490191000011 490191000012 490191000014 490191000015 490191000016 490191009999 490199110001 490199110002 490199110003 490199119999 490199190000 490199200000 490199300000 490199400001 490199400002 490199400003 490199400004 490199500000 490199600000 490199900000 490210100001 490210100002 490210100003 490210200001 490210200002 490210200003 490210900000 490290100001 490290100002 490290100003 490290200001 490290200002 490290200003 490290300001 490290300002 490290300003 490290900000 490300100000 490300200000 490300900001 490300900002 490300900003 490300900004 490300900005 490400000000 490520000000 490590100000 490590900000 490600000001 490600000002 490600000003 490600000004 490600000005 490600009999 490700110000 490700120000 490700190000 490700200001 490700200002 490700310001 490700319999 490700320001 490700329999 490700400000 490700500000 490700600001 490700600002 490700600003 490700600004 490700600005 490700600006 490700700001 490700700002 490700700003 490700800000 490700900000 490810000000 490890000001 490890000002 490890000003 490890000004 490890000005 490890000006 490890000007 490890009999 490900100000 490900200001 490900200002 490900200003 490900200004 491000000001 491000000002 491000000003 491000000004 491000000005 491000000006 491000000008 491000000009 491000000010 491000000011 491000000012 491000000013 491000000014 491000009999 491110100000 491110900000 491191100000 491191900000 491199100001 491199100002 491199200001 491199200002 491199300000 491199900000 500100000000 500200000000 500300000001 500300000002 500300000003 500300000004 500300000005 500300000006 500300000007 500300000008 500300009999 500400000000 500500000000 500600000000 500710000000 500720000000 500790000000 510111000000 510119000001 510119000002 510121000000 510129000001 510129000002 510129000003 510129000004 510129000005 510129009999 510130000001 510130000002 510211000000 510219000000 510220000000 510310000000 510320000000 510330000000 510400000000 510510000000 510521000000 510529000000 510531000000 510539000000 510540000000 510610000000 510620000000 510710000000 510720000000 510810000000 510820000000 510910000000 510990000000 511000000000 511111100000 511111900000 511119100000 511119900000 511120100000 511120900000 511130100000 511130900000 511190100000 511190900000 511211100000 511211900000 511219100000 511219900000 511220100000 511220900000 511230100000 511230900000 511290100000 511290900000 511300110000 511300190000 511300200000 520100000000 520210000000 520291000000 520299000000 520300000000 520411000000 520419000000 520420000000 520511000000 520512000000 520513000000 520514000000 520515000000 520521000000 520522000000 520523000000 520524000000 520526000000 520527000000 520528000000 520531000000 520532000000 520533000000 520534000000 520535000000 520541000000 520542000000 520543000000 520544000000 520546000000 520547000000 520548000000 520611000000 520612000000 520613000000 520614000000 520615000000 520621000000 520622000000 520623000000 520624000000 520625000000 520631000000 520632000000 520633000000 520634000000 520635000000 520641000000 520642000000 520643000000 520644000000 520645000000 520710000000 520790000000 520811000000 520812000000 520813000000 520819000000 520821000000 520822000000 520823000000 520829000000 520831000000 520832000000 520833000000 520839000000 520841000000 520842000000 520843000000 520849000000 520851000000 520852000000 520859000000 520911000000 520912000000 520919000000 520921000000 520922000000 520929000000 520931000000 520932000000 520939000000 520941000000 520942000000 520943000000 520949000000 520951000000 520952000000 520959000000 521011000000 521019000000 521021000000 521029000000 521031000000 521032000000 521039000000 521041000000 521049000000 521051000000 521059000000 521111000000 521112000000 521119000000 521120000000 521131000000 521132000000 521139000000 521141000000 521142000000 521143000000 521149000000 521151000000 521152000000 521159000000 521211000000 521212000000 521213000000 521214000000 521215000000 521221000000 521222000000 521223000000 521224000000 521225000000 530110000000 530121000000 530129000000 530130000000 530210000000 530290000000 530310000000 530390000001 530390000002 530390000003 530390000004 530390000005 530390000006 530390000007 530390000008 530390000009 530390000010 530390009999 530500000001 530500000002 530500000003 530500000004 530500000005 530500000006 530500000007 530500000008 530500000009 530500000010 530500000011 530500000012 530500000013 530500000014 530500000015 530500000016 530500000017 530500000018 530500000019 530500000020 530500000021 530610000000 530620000000 530710000000 530720000000 530810000000 530820000000 530890000000 530911000000 530919000001 530919009999 530921000000 530929000001 530929000002 530929000003 530929009999 531010000000 531090000001 531090000002 531090000003 531090009999 531100000000 540110100000 540110900000 540120100000 540120900000 540211000000 540219000000 540220000000 540231000000 540232000000 540233000000 540234000000 540239100000 540239900000 540244000000 540245000000 540246000000 540247000000 540248000000 540249100000 540249200000 540249300000 540249900000 540251000000 540252000000 540253000000 540259100000 540259900000 540261000001 540261000002 540261000003 540261000004 540262000000 540263000000 540269100000 540269900000 540310000000 540331000000 540332000000 540333000000 540339000000 540341000000 540342000000 540349000000 540411000000 540412000000 540419100000 540419200000 540419400000 540419900000 540490000001 540490000002 540490000003 540490000004 540490000005 540490000006 540490000007 540490000008 540490000009 540490009999 540500100001 540500100002 540500100003 540500900001 540500900002 540500900003 540500909999 540600000000 540710000000 540720000000 540730000000 540741000000 540742000000 540743000000 540744000000 540751000000 540752000000 540753000000 540754000000 540761000000 540769000000 540771000000 540772000000 540773000000 540774000000 540781000000 540782000000 540783000000 540784000000 540791000000 540792000000 540793000000 540794000000 540810000000 540821000000 540822000000 540823000000 540824000000 540831000000 540832000000 540833000000 540834000000 550111000001 550111009999 550119000000 550120000000 550130000000 550140000000 550190000000 550210000000 550290000001 550290009999 550311000001 550311009999 550319000000 550320000000 550330000000 550340000000 550390000000 550410000000 550490000000 550510000000 550520000000 550610000000 550620000000 550630000000 550640000000 550690000000 550700000000 550810100000 550810900000 550820100000 550820900000 550911100000 550911900000 550912100000 550912900000 550921000000 550922000000 550931000000 550932000000 550941000000 550942000000 550951000000 550952000000 550953000000 550959000000 550961000000 550962000000 550969000000 550991000000 550992000000 550999000000 551011000000 551012000000 551020000000 551030000000 551090000000 551110000000 551120000000 551130000000 551211000000 551219000001 551219000002 551219000003 551219009999 551221000000 551229000001 551229000002 551229000003 551229009999 551291000000 551299000001 551299000002 551299000003 551299009999 551311000000 551312000000 551313000000 551319000000 551321000000 551323000000 551329000000 551331000000 551339000000 551341000000 551349000000 551411000000 551412000000 551419000000 551421000000 551422000000 551423000000 551429000000 551430000000 551441000000 551442000000 551443000000 551449000000 551511000000 551512000000 551513000000 551519000001 551519000002 551519000003 551519009999 551521000000 551522000000 551529000001 551529000002 551529000003 551529009999 551591000000 551599000001 551599000002 551599009999 551611000000 551612000000 551613000000 551614000000 551621000000 551622000000 551623000000 551624000000 551631000000 551632000000 551633000000 551634000000 551641000000 551642000000 551643000000 551644000000 551691000000 551692000000 551693000000 551694000000 '"/>
            <let name="codes12" value="' 560121100000 560121900001 560121909999 560122000001 560122000002 560129000001 560129000002 560129000003 560129009999 560130000000 560210000000 560221000001 560221000002 560221000003 560221000004 560229000001 560229000002 560229000003 560229000004 560229000005 560290000001 560290000002 560290000003 560290009999 560311000001 560311000002 560311000003 560311000004 560311000005 560312000001 560312000002 560312000003 560312000004 560312000005 560313000001 560313000002 560313000003 560313000004 560313000005 560314000001 560314000002 560314000003 560314000004 560314000005 560391000001 560391000002 560391000003 560391000004 560391000005 560392000001 560392000002 560392000003 560392000004 560392000005 560393000001 560393000002 560393000003 560393000004 560393000005 560394000001 560394000002 560394000003 560394000004 560394000005 560410000001 560410000002 560410000003 560410000004 560490000001 560490000002 560490009999 560500000000 560600100001 560600100002 560600100003 560600100004 560600100005 560600200000 560600300000 560721100000 560721200000 560729100000 560729200000 560741100001 560741100002 560741200001 560741200002 560749100000 560749200000 560750100001 560750100002 560750100003 560750100004 560750200001 560750200002 560750200004 560750200005 560790100001 560790100002 560790210001 560790210002 560790290001 560790290002 560790290003 560790299999 560811000000 560819000001 560819000002 560819009999 560890000001 560890009999 560900100000 560900200000 560900300000 560900900000 570110000001 570110000002 570110000003 570110000004 570190000001 570190000002 570190000003 570190000004 570190000005 570190000006 570190000007 570190000008 570190009999 570210000001 570210000002 570210000003 570210009999 570220000000 570231100001 570231100002 570231100003 570231100004 570231100005 570231200001 570231200002 570231900001 570231909999 570232100001 570232100002 570232100003 570232100004 570232100005 570232100006 570232200001 570232200002 570232900001 570232900002 570232900003 570232909999 570239000001 570239000002 570239000003 570241100001 570241100002 570241200001 570241200002 570241900001 570241909999 570242100001 570242100002 570242100003 570242100004 570242100005 570242100006 570242210001 570242210002 570242290000 570242300000 570242900000 570249110000 570249190001 570249190002 570249190003 570249190004 570249199999 570249900001 570249900002 570249900003 570249900004 570249900005 570249909999 570250000001 570250000002 570250000003 570250000004 570250000005 570250000006 570250000007 570250000008 570250000009 570250000010 570250000011 570250000012 570291100001 570291100002 570291100003 570291100004 570291100005 570291100006 570291200001 570291200002 570291200003 570291200004 570291200005 570291200006 570291900001 570291900002 570291909999 570292100001 570292100002 570292100003 570292100004 570292100005 570292100006 570292200000 570292900001 570292909999 570299110000 570299190001 570299190002 570299190003 570299190004 570299190005 570299199999 570299900001 570299900002 570299900003 570299900004 570299900005 570299909999 570310000001 570310000002 570310000003 570310000004 570321000000 570329000000 570331000000 570339100000 570339200000 570339300000 570339900001 570339909999 570390110000 570390190001 570390190002 570390190003 570390190004 570390190005 570390199999 570390900001 570390900002 570390900003 570390900004 570390909999 570410000000 570420000000 570490000000 570500110000 570500120000 570500190001 570500190002 570500190003 570500190004 570500199999 570500200000 570500300000 570500900000 580110100000 580110900000 580121000000 580122000000 580123000000 580126000000 580127000000 580131000000 580132000000 580133000000 580136000000 580137000000 580190110000 580190190000 580190900000 580210000000 580220000000 580230000000 580300000000 580410000000 580421000000 580429000000 580430000000 580500000000 580610000000 580620000000 580631000000 580632000000 580639000000 580640000000 580710000000 580790000000 580810000000 580890000000 580900000000 581010000000 581091000000 581092000000 581099000000 581100000000 590110000000 590190100000 590190200000 590190300000 590210000000 590220000000 590290000000 590310000000 590320000000 590390000000 590410000000 590490000000 590500100000 590500200000 590500600000 590500900000 590610000000 590691000000 590699000000 590700110000 590700120000 590700130000 590700140000 590700150000 590700190001 590700199999 590700200000 590800000000 590900100000 590900900000 591000000000 591110000000 591120000000 591131000000 591132000000 591140000000 591190000000 600110000001 600110000002 600110000003 600110000004 600121000000 600122000000 600129000000 600191000000 600192000000 600199000000 600240000000 600290000000 600310000001 600310000002 600320000001 600320000002 600330000001 600330000002 600340000001 600340000002 600390000000 600410000000 600490000000 600521000000 600522000000 600523000000 600524000000 600535000000 600536000000 600537000000 600538000000 600539000000 600541000000 600542000000 600543000000 600544000000 600590000000 600610000000 600621000000 600622000000 600623000000 600624000000 600631000000 600632000000 600633000000 600634000000 600641000000 600642000000 600643000000 600644000000 600690000000 610120000000 610130000000 610190000000 610210000000 610220000000 610230000000 610290000000 610310000000 610322000000 610323000000 610329000001 610329000002 610329009999 610331000000 610332000000 610333000000 610339000000 610341000000 610342000001 610342000002 610342000003 610343000001 610343000002 610343000003 610349000001 610349000002 610349000003 610349009999 610413000000 610419000001 610419000002 610419000003 610419009999 610422000000 610423000000 610429000001 610429000002 610429009999 610431000000 610432000000 610433000000 610439000001 610439000002 610441000000 610442000000 610443000000 610444000000 610449000000 610451000000 610452000000 610453000000 610459000000 610461000000 610462000001 610462000002 610462000003 610462000004 610463000001 610463000002 610463000003 610463000004 610469000001 610469000002 610469000003 610469000004 610510000000 610520000000 610590000000 610610000001 610610000002 610610000003 610620000001 610620000002 610620000003 610690000001 610690000002 610690000003 610711000001 610711000002 610711000003 610711000004 610711000005 610712000000 610719000000 610721000000 610722000000 610729000001 610729000002 610729000003 610729000004 610729009999 610791000000 610799000000 610811000000 610819000000 610821000000 610822000000 610829000000 610831000000 610832000001 610832000003 610839000001 610839000002 610891000000 610892000000 610899000001 610899000002 610899009999 610910000001 610910000002 610990000001 610990000002 610990000003 610990000005 610990009999 611011000001 611011000002 611011000003 611011009999 611012000001 611012000002 611012000003 611019000001 611019000002 611019000003 611020000001 611020000002 611020000003 611030000001 611030000002 611030000003 611090000000 611120000000 611130000000 611190000001 611190000002 611190009999 611211000000 611212000000 611219000000 611220000000 611231000000 611239000000 611241000000 611249000000 611300000000 611420000000 611430000000 611490000000 611510000001 611510009999 611594000000 611595000000 611596000000 611599000000 611610000000 611691000000 611692000000 611693000000 611699000000 611710000000 611780000000 611790000000 620120100000 620120900000 620130000000 620140000000 620190000000 620220000000 620230000000 620240100000 620240900000 620290110000 620290190000 620290900000 620311000000 620312000000 620319000001 620319000002 620319000003 620319000005 620319009999 620322000000 620323000000 620329000001 620329000002 620329000003 620329000004 620329009999 620331000000 620332000000 620333000000 620339000001 620339000003 620339009999 620341000001 620341000002 620341000003 620341000004 620341000005 620342000001 620342000002 620342000003 620342000004 620342000005 620343000001 620343000002 620343000003 620343000004 620343000005 620349000001 620349000002 620349000003 620349000004 620349000005 620349000006 620349000007 620349000008 620349000009 620349000010 620349009999 620411000000 620412000000 620413000000 620419000001 620419000002 620419000004 620419009999 620421000000 620422000000 620423000000 620429000001 620429000002 620429000004 620429009999 620431000000 620432000000 620433000000 620439000001 620439000002 620439000004 620439009999 620441000000 620442000000 620443000000 620444000000 620449000000 620451000000 620452000000 620453000000 620459000001 620459000002 620459000004 620459009999 620461000001 620461000002 620461000003 620461000004 620461000005 620462000001 620462000002 620462000003 620462000004 620462000005 620463000001 620463000002 620463000003 620463000004 620463000005 620469000001 620469000002 620469000003 620469000004 620469000005 620469000006 620469000007 620469000008 620469000009 620469000010 620469000016 620469000017 620469000018 620469000019 620469000020 620469009999 620520000000 620530000000 620590000001 620590000002 620590009999 620610000001 620610000002 620610000003 620620000001 620620000002 620620000003 620630000001 620630000002 620630000003 620640000001 620640000002 620640000003 620690000001 620690000002 620690000003 620690000004 620690000005 620690000006 620690009999 620711000000 620719000001 620719000002 620719000004 620719009999 620721000001 620721000002 620722000001 620722000002 620729000001 620729000002 620729000003 620729000004 620729009999 620791000001 620791000002 620791000003 620799000001 620799000002 620799000003 620799000004 620799000005 620799000006 620799000007 620799000008 620799000009 620799009999 620811000001 620811000002 620811000003 620819000001 620819000002 620819000003 620819000004 620819000005 620819000006 620819000007 620819000008 620819000009 620819009999 620821000001 620821000002 620822000001 620822000002 620829000001 620829000002 620829000003 620829000004 620829009999 620891000001 620891000002 620891000003 620891000004 620892000001 620892000002 620892000003 620892000004 620899000001 620899000002 620899000003 620899000004 620899000005 620899000006 620899000007 620899000008 620899009999 620920000001 620920000002 620920000003 620920000004 620920000005 620920000006 620920000007 620920000008 620930000001 620930000002 620930000003 620930000004 620930000005 620930000006 620930000007 620990000001 620990000002 620990000003 620990000004 620990000005 620990000006 620990009999 621010100000 621010900001 621010900002 621010900003 621010900004 621010909999 621020000000 621030000000 621040000000 621050000000 621111000001 621111000002 621112000000 621120000000 621132100000 621132200000 621132900000 621133100000 621133200000 621133900000 621139100000 621139200001 621139200002 621139900000 621142000000 621143000000 621149000000 621210000000 621220000000 621230000000 621290000000 621320000000 621390000000 621410000000 621420100000 621420200000 621420900001 621420900002 621420900003 621420900004 621420909999 621430100000 621430200000 621430300000 621430400000 621430900000 621440100000 621440200000 621440300000 621440400000 621440900000 621490110000 621490120000 621490130000 621490140000 621490190000 621490900000 621510000000 621520000000 621590000000 621600000000 621710100000 621710200000 621710310000 621710390001 621710390002 621710390003 621710399999 621710400000 621710500000 621710600000 621710700000 621710900000 621790100000 621790200000 621790900000 '"/>
            <let name="codes13" value="' 630110000000 630120000000 630130000000 630140000000 630190100000 630190900000 630210000000 630221000000 630222000000 630229000000 630231000000 630232000000 630239000000 630240000000 630251000000 630253000000 630259000000 630260000000 630291100000 630291200000 630291300000 630291400000 630291900000 630293000000 630299000000 630312000000 630319000000 630391100000 630391200000 630391900000 630392100000 630392200000 630392900000 630399000000 630411000000 630419000000 630420000000 630491100000 630491200000 630491900000 630492100000 630492200000 630492300000 630492400000 630492900000 630493100000 630493200000 630493300000 630493400000 630493900000 630499100000 630499200000 630499300000 630499400000 630499900000 630510100000 630510900000 630520000000 630532000000 630533000000 630539000000 630590000000 630612100000 630612200000 630619100000 630619200000 630622100000 630622900000 630629100000 630629900000 630630000000 630640000000 630690000000 630710000001 630710000002 630710000003 630710000004 630720000000 630790100000 630790210000 630790290000 630790300000 630790400000 630790500000 630790600000 630790700000 630790800000 630790910000 630790920000 630790940000 630790950000 630790960000 630790970001 630790970002 630790970003 630790990000 630800000000 630900000000 631010000000 631090000000 640110000001 640110000002 640192000001 640192000002 640199000000 640212000000 640219000001 640219000002 640220000000 640291000000 640299000000 640312000000 640319000000 640320000000 640340000000 640351100000 640351200000 640351300000 640359100000 640359200000 640359300000 640391100000 640391200000 640391300000 640399100000 640399200000 640399300000 640411000000 640419000000 640420000000 640510000001 640510000003 640510000005 640520000001 640520000003 640520000005 640520009999 640590000001 640590000003 640590000005 640590009999 640610000000 640620000000 640690000000 650100000000 650200000000 650400000000 650500100000 650500200000 650500300000 650500410000 650500490000 650500500000 650500600001 650500600002 650500700000 650500800000 650500900000 650610100000 650610200000 650610300000 650610400000 650610500000 650610900000 650691100000 650691900000 650699000001 650699000002 650699000003 650699000004 650699000005 650699000006 650699009999 650700000000 660110000001 660110000002 660191000000 660199000001 660199000002 660199000003 660199000004 660199009999 660200100001 660200100002 660200100003 660200100004 660200100005 660200100006 660200200000 660200900001 660200900002 660200909999 660320000001 660320000002 660320000003 660390000001 660390000002 660390009999 670100100000 670100900001 670100900002 670100909999 670210000000 670290100000 670290200000 670290900000 670300000000 670411000000 670419000001 670419000002 670419000003 670419000004 670419000005 670419009999 670420000000 670490000000 680100100000 680100200000 680100300000 680100400000 680100900000 680210000000 680221000000 680223000000 680229000000 680291100000 680291210000 680291220000 680291230000 680291290000 680291300000 680291400000 680291500000 680291600000 680291700000 680291900000 680292000000 680293000000 680299000000 680300100000 680300900000 680410000000 680421000000 680422000000 680423000000 680430000000 680510000000 680520000000 680530000000 680610000000 680620000000 680690000004 680690009999 680710000001 680710000002 680710000003 680710000004 680790100000 680790200001 680790200002 680790300000 680790400000 680790900000 680800000000 680911000000 680919100000 680919900000 680990100000 680990200000 680990300000 680990910000 680990920000 680990990000 681011000001 681011000002 681011000003 681011000004 681011000005 681019100000 681019210001 681019210002 681019219999 681019220000 681019230000 681019290000 681019900000 681091000000 681099100000 681099900000 681140000000 681181000000 681182000000 681189100000 681189200000 681189300000 681189900001 681189909999 681280000000 681291000001 681291000002 681291000003 681291000004 681299000001 681299000002 681299009999 681320000000 681381000001 681381000002 681389000001 681389000002 681389000003 681389000004 681389000005 681389000006 681389000007 681389009999 681410000000 681490100001 681490100002 681490109999 681490900001 681490909999 681511000001 681511009999 681512000000 681513100001 681513109999 681513200000 681513300000 681513400000 681513500000 681513900000 681519100000 681519200000 681519300000 681519400000 681519500000 681519600000 681519900000 681520100000 681520200000 681520300000 681520900000 681591100000 681591200000 681591900000 681599100000 681599200000 681599300001 681599300002 681599400000 681599500001 681599500002 681599500003 681599900000 690100000000 690210000000 690220000000 690290000000 690310000000 690320000000 690390000000 690390000001 690390000002 690390009999 690410000000 690490000000 690510000000 690590100000 690590200000 690590900000 690600000000 690721000000 690721000901 690721000902 690721000903 690721000905 690721000906 690721000907 690721000908 690721000909 690721000911 690721000912 690722000000 690722000901 690722000902 690722000903 690722000905 690722000906 690722000907 690722000908 690722000909 690722000911 690722000912 690723000000 690723000901 690723000902 690723000903 690723000905 690723000906 690723000907 690723000909 690723000911 690723000912 690740000000 690740000901 690740000902 690740000903 690740000905 690740000906 690740000907 690740000908 690740000909 690740000911 690740000912 690911000000 690912000000 690919000000 690990100000 690990900000 691010000000 691090000000 691110000001 691110000002 691110000003 691110000005 691110000012 691110000013 691110000017 691110009999 691190000000 691200000001 691200000002 691200000004 691200000005 691200000012 691200000013 691200009999 691310100000 691310200000 691310300000 691310400000 691310500000 691310900000 691390100000 691390900000 691410100000 691410200000 691410900000 691490100000 691490200000 691490300000 691490900000 700100000001 700100000002 700100000003 700210000000 700220000000 700231000000 700232000000 700239000000 700312000000 700319000000 700320000000 700330000000 700420000000 700490000000 700510000000 700521000000 700529000000 700530000000 700600000000 700711000000 700719000000 700721000000 700729000000 700800100000 700800900000 700910000000 700991000000 700992000000 701010100000 701010900000 701020000000 701090000001 701090000002 701090009999 701110000000 701120000000 701190000000 701310100000 701310300000 701310410000 701310490000 701310900000 701322000000 701328000000 701333000000 701337000000 701341000000 701342000000 701349000000 701391100000 701391310000 701391390000 701391900000 701399100000 701399200000 701399900000 701400100000 701400900000 701510000000 701590100000 701590200001 701590200002 701590900000 701610000000 701690000003 701690009999 701710100000 701710900000 701720000000 701790000001 701790000002 701790000003 701790000004 701790000005 701790000006 701790000008 701790000009 701790000010 701790009999 701810100000 701810900000 701820000000 701890000000 701911000001 701911009999 701912000001 701912009999 701913000001 701913009999 701914000001 701914009999 701915000001 701915009999 701919000001 701919009999 701961000001 701961009999 701962000000 701963000000 701964000000 701965000000 701966000000 701969000000 701971000000 701972000000 701973000000 701980000000 701990100000 701990200000 701990300000 701990410000 701990420000 701990500000 701990600000 701990700000 701990910000 701990920000 701990930000 701990940000 701990950001 701990950002 701990990001 701990999999 702000100000 702000200000 702000300000 702000400000 702000900001 702000909999 '"/>
            <let name="codes14" value="' 710110000000 710121000000 710122000000 710210000000 710221000000 710229000000 710231000000 710239000000 710310000000 710391000001 710391000002 710391000003 710399000000 710410000000 710421000000 710429000000 710491000000 710499000000 710510000000 710590000000 710610000000 710691100001 710691100002 710691900001 710691900002 710691900003 710691900004 710691900005 710691900006 710691909999 710692000000 710700000000 710811000000 710812100001 710812100002 710812900001 710812900002 710812900003 710812900004 710812909999 710813000000 710820000001 710820000002 710820000003 710820000004 710820000005 710820000006 710820009999 710900000001 710900000002 711011100001 711011100002 711011900001 711011900002 711011900003 711011900004 711011909999 711019000001 711019000002 711019009999 711021000000 711029000000 711031000000 711039000000 711041000000 711049000000 711100000000 711230000000 711291000000 711292000000 711299000000 711311000000 711319100000 711319200000 711320000000 711411000000 711419100000 711419200000 711420000000 711510000001 711510009999 711590000000 711610110000 711610120000 711610910000 711610920000 711620100000 711620200000 711620900000 711711100000 711711900000 711719000000 711790100000 711790200000 711790300000 711790900000 711810000000 711890000000 711890000901 720110000001 720110000002 720110000003 720110009999 720120000001 720120000002 720120000003 720120009999 720150000000 720211000000 720219000000 720221000000 720229000000 720230000000 720241000000 720249000000 720250000000 720260000000 720270000000 720280000000 720291000000 720292000000 720293000000 720299000000 720310000000 720390000000 720410000000 720421000000 720429000000 720430000000 720441000001 720441000002 720441000003 720441000004 720449000000 720450000000 720510000001 720510000002 720510000003 720510000004 720521000000 720529000000 720610000001 720610000002 720690000000 720711000001 720711000002 720712000001 720712000002 720719000001 720719000002 720720000000 720810000003 720810000004 720810000005 720825000003 720825000004 720826000001 720826000002 720827000003 720827000004 720836000003 720836000004 720837000001 720837000002 720838000001 720838000002 720839000003 720839000004 720840000003 720840000004 720840000005 720851000003 720851000004 720852000001 720852000002 720853000001 720853000002 720854000003 720854000004 720890000000 720915000001 720915000002 720916000001 720916000002 720917000001 720917000002 720918000001 720918000002 720925000001 720925000002 720926000001 720926000002 720927000001 720927000002 720928000001 720928000002 720990000000 721011000001 721011000002 721012000001 721012000002 721020000001 721020000002 721030000000 721041000001 721041000002 721049000000 721050000001 721050000002 721061000000 721069000000 721070000001 721070000002 721070000003 721090000000 721113000001 721113000002 721114000001 721114000002 721119000000 721123000001 721123000002 721129000000 721190000000 721210000001 721210000002 721220000001 721220000002 721230000001 721230000002 721240000001 721240000002 721240000003 721250000001 721250000002 721260000000 721310000001 721310000901 721310000002 721310000902 721320000000 721320000901 721391000001 721391000901 721391000002 721391000902 721399000000 721399000901 721410300000 721410300901 721410400000 721410400902 721410900000 721410900901 721420300000 721420300901 721420400000 721420400901 721420900000 721420900901 721430300000 721430300901 721430400000 721430400901 721430900000 721430900901 721491000001 721491000901 721491000002 721491000902 721499000000 721499000901 721510300000 721510400000 721510900000 721550300000 721550400000 721550900000 721590300000 721590400000 721590900000 721610000001 721610000002 721610000003 721610000004 721610000005 721610000006 721621000001 721621000002 721622000001 721622000002 721631100001 721631100002 721631200001 721631200002 721632100001 721632100002 721632200001 721632200002 721633100001 721633100002 721633200001 721633200002 721640100001 721640100002 721640100003 721640100004 721640200001 721640200002 721640200003 721640200004 721650000001 721650000002 721661000001 721661000002 721669000000 721691000001 721691000002 721699000000 721710000001 721710000002 721720000001 721720000002 721730000001 721730000002 721790000000 721810000001 721810000002 721891000000 721899000001 721899000002 721899009999 721911000000 721912000000 721913000000 721914000000 721921000000 721922000000 721923000000 721924000000 721931000000 721932000000 721933000000 721934000000 721935000000 721990000000 722011000000 722012000000 722020000000 722090000000 722100000001 722100000002 722211000001 722211000002 722219000000 722220000001 722220000002 722230000001 722230000002 722240000001 722240000002 722240000003 722300000000 722410100001 722410109999 722410200001 722410209999 722490000000 722511000000 722519000000 722530000000 722540000000 722550000000 722591000000 722592000001 722592000002 722599000001 722599009999 722611000000 722619000000 722620000000 722691000001 722691009999 722692000001 722692009999 722699000001 722699009999 722710000001 722710000002 722720000001 722720000002 722790000000 722810100000 722810200000 722810900000 722820100000 722820200000 722820900000 722830100000 722830200000 722830900000 722840100000 722840200000 722840900000 722850100000 722850200000 722850900000 722860100000 722860200000 722860900000 722870000001 722870000002 722870000003 722880000001 722880000002 722920000000 722990000000 730110000001 730110000002 730110000003 730110000004 730110000005 730110000006 730120000001 730120000002 730120000003 730210000000 730230000001 730230000002 730230000003 730240000000 730290000000 730300000001 730300000002 730411000001 730411000002 730419000000 730422000001 730422000002 730423000000 730424100000 730424900000 730429000000 730431000001 730431000002 730439000000 730441100000 730441200000 730441300000 730449000000 730451100001 730451109999 730451200000 730451300000 730459000001 730459009999 730490000001 730490009999 730511000001 730511000002 730512000001 730512000002 730519000000 730520000001 730520000002 730531000000 730539000000 730590000000 730611000001 730611000002 730619000000 730621000001 730621000002 730629000000 730630000001 730630000002 730640100000 730640200000 730640300000 730650100001 730650109999 730650200001 730650209999 730650300001 730650309999 730661000001 730661000002 730669100000 730669200000 730669300000 730690000001 730690009999 730711000001 730711000002 730711000003 730711009999 730719000000 730721000000 730722000000 730723000000 730729000000 730791000000 730792000000 730793000000 730799000000 730810000001 730810000002 730820000001 730820000002 730830100000 730830210000 730830290000 730830310000 730830390000 730830410000 730830490000 730830510000 730830590000 730830610000 730830690000 730840000001 730840000002 730840000003 730840000004 730890100001 730890100002 730890109999 730890200001 730890200002 730890200003 730890300001 730890300002 730890400001 730890400002 730890500001 730890500002 730890600001 730890600002 730890900001 730890900002 730890900003 730890900004 730890900005 730890900006 730890900007 730890900008 730890900009 730890900010 730890909999 730900100001 730900100002 730900109999 730900910001 730900919999 730900920001 730900929999 730900930001 730900939999 730900990001 730900999999 731010000001 731010009999 731021100001 731021100002 731021200000 731021300000 731021900000 731029000000 731100100000 731100100001 731100109999 731100200000 731100300000 731100900000 731100900001 731100909999 731210100001 731210100002 731210900000 731290100000 731290900000 731300000000 731412000000 731414000000 731419000000 731420000000 731431000001 731431000002 731439000000 731441000000 731442000000 731449000000 731450000000 731511000000 731512000000 731519000000 731520000000 731581000000 731582000000 731589000000 731590000000 731600000001 731600000002 731600000003 731700110000 731700120000 731700200000 731700300000 731700400000 731700900000 731811000000 731812000000 731813000001 731813000002 731814000001 731814000002 731815000000 731816000001 731816000002 731819000000 731821000000 731822000001 731822000002 731823000001 731823000002 731824000000 731829000000 731940000001 731940000002 731990000001 731990000002 731990000003 731990000004 731990009999 732010000000 732020000000 732090000000 732111100001 732111100002 732111200001 732111200002 732111300001 732111300002 732111900001 732111900002 732112100000 732112200000 732112300000 732112900000 732119000000 732181100001 732181100002 732181900000 732182100000 732182900000 732189000000 732190100000 732190200000 732190300000 732190900000 732211000000 732219000000 732290000000 732310000001 732310000002 732310000003 732310000004 732310009999 732391000000 732392000000 732393000000 732394000000 732399000000 732410000001 732410000002 732421000000 732429000000 732490000000 732510100001 732510100002 732510109999 732510200000 732510300001 732510300002 732510400001 732510400002 732510400003 732510400004 732510400005 732510400006 732510900000 732591000001 732591000002 732599100001 732599100002 732599109999 732599200000 732599300001 732599300002 732599400001 732599400002 732599400003 732599400004 732599400005 732599400006 732599900000 732611000001 732611000002 732619000000 732620100000 732620200000 732620300000 732620400000 732620900000 732690100001 732690100002 732690200001 732690200002 732690300001 732690300002 732690400001 732690400002 732690500001 732690500002 732690600000 732690700001 732690700002 732690800001 732690800002 732690910001 732690910002 732690920001 732690920002 732690930001 732690930002 732690940001 732690940002 732690950001 732690950002 732690960001 732690960002 732690960003 732690970001 732690970002 732690980001 732690980002 732690980003 732690980004 732690980005 732690980006 732690990001 732690990002 732690990003 732690990004 732690990005 732690999999 '"/>
            <let name="codes15" value="' 740100000001 740100000002 740200000001 740200000002 740311000001 740311000002 740312000000 740313000000 740319000000 740321000000 740322000000 740329000000 740400000001 740400000002 740500000000 740610000000 740620000000 740710000001 740710000002 740710000003 740721000000 740729000000 740811000001 740811000002 740819000001 740819000002 740819009999 740821000000 740822000000 740829000000 740911000001 740911000002 740911000003 740919000000 740921000001 740921000002 740921000003 740929000000 740931000001 740931000002 740931000003 740939000000 740940000001 740940000002 740990000000 741011000000 741012000000 741021000000 741022000000 741110000000 741121000000 741122000000 741129000000 741210000001 741210000002 741210000003 741210009999 741220000001 741220000002 741220000003 741220009999 741300000001 741300000002 741300000003 741300009999 741510000001 741510000002 741510000003 741510000004 741510009999 741521000001 741521000002 741529000000 741533000001 741533000002 741533000003 741539000000 741810000001 741810000002 741810000006 741810000008 741810000009 741810000011 741810000012 741810009999 741820000001 741820000002 741820000003 741820009999 741920100000 741920200000 741920900000 741980100000 741980200000 741980300000 741980400000 741980500000 741980600000 741980700000 741980800000 741980900000 750110000000 750120000000 750210000000 750220000000 750300000001 750300000002 750400100001 750400109999 750400200000 750511000001 750511000002 750511000003 750512000001 750512000002 750512000003 750521000000 750522000000 750610000001 750610000002 750610000003 750610000004 750610000005 750620000001 750620000002 750620000003 750620000004 750711000000 750712000000 750720000001 750720000002 750720000003 750720009999 750810000001 750810000002 750810000003 750890100000 750890200000 750890300001 750890300002 750890300003 750890300004 750890400000 750890500000 750890600000 750890900000 760110000000 760120000000 760200000001 760200000002 760200000003 760200000005 760200000007 760310000000 760320000000 760410000001 760410000002 760410000003 760421000001 760421009999 760429000000 760511000000 760519000000 760521000000 760529000000 760611000000 760612100002 760612100991 760612200001 760612200002 760612200993 760612300001 760612300002 760612300995 760612400001 760612400002 760612900000 760691000000 760692100001 760692100002 760692200001 760692200002 760692900000 760711100000 760711900000 760719100000 760719900001 760719909999 760720100000 760720900000 760810000000 760820000001 760820009999 760900000001 760900000002 760900000003 760900009999 761010100000 761010900001 761010900002 761010900003 761010900004 761090100001 761090100002 761090200001 761090200002 761090300001 761090300002 761090400000 761090500000 761090600000 761090700000 761090810000 761090820000 761090900001 761090900002 761090900003 761090900005 761090900008 761090900009 761090900010 761090909999 761100000001 761100009999 761210000000 761290100001 761290100002 761290200000 761290300001 761290300002 761290400000 761290900001 761290909999 761300110000 761300190000 761300900001 761300900002 761300909999 761410100001 761410100002 761410900000 761490000000 761510100000 761510200001 761510200002 761510900001 761510900002 761510900003 761510900004 761510900005 761510900006 761510900007 761510900008 761510900009 761510909999 761520000001 761520000002 761520000003 761520009999 761610000001 761610000004 761610000005 761610000006 761610000007 761610000008 761610000009 761610000010 761610009999 761691000001 761691000002 761691000003 761699100000 761699210001 761699210002 761699210003 761699220000 761699290000 761699310000 761699390000 761699400000 761699500001 761699500003 761699500004 761699500005 761699509999 761699600000 761699700000 761699910000 761699920000 761699930000 761699990000 780110000001 780110000002 780110009999 780191000000 780199000000 780200000001 780200000002 780411000001 780411000002 780411000003 780419000000 780420000001 780420000002 780600000000 790111000000 790112000000 790120000001 790120000002 790120009999 790200000001 790200000002 790310000000 790390100000 790390200000 790400100000 790400200000 790400900000 790500100001 790500100002 790500900000 790700100000 790700200000 790700300000 790700400000 790700500000 790700600000 790700700000 790700800000 790700910000 790700920000 790700930000 790700990000 800110000001 800110000002 800110009999 800120000000 800200000001 800200000002 800300100000 800300900000 800700100000 800700200001 800700200002 800700209999 800700300000 800700900000 810110000000 810194000001 810194000002 810194000003 810194000004 810196000000 810197000000 810199000001 810199009999 810210000000 810294100000 810294200000 810294900000 810295000001 810295000002 810295000003 810295000004 810295000005 810295000006 810295000007 810296000000 810297000000 810299000000 810320000001 810320000002 810320000005 810320009999 810330000001 810330000002 810391000000 810399000000 810411000000 810419000001 810419009999 810420000001 810420000002 810430100001 810430109999 810430900000 810490100001 810490100002 810490100003 810490100004 810490100005 810490100007 810490100008 810490200001 810490200002 810490200003 810490300001 810490300002 810490300003 810490300004 810490300005 810490300006 810490309999 810490900001 810490909999 810520000001 810520000002 810520000005 810520000006 810530000001 810530000002 810590000000 810610000001 810610009999 810690000001 810690009999 810820000001 810820000004 810830000001 810830000002 810890000001 810890009999 810921000001 810921009999 810929000000 810931000000 810939000000 810991000000 810991000001 810991009999 810999000000 810999000001 810999009999 811010000001 811010000004 811020000001 811020000002 811090000000 811100000001 811100000002 811100000003 811212000001 811212000004 811213000001 811213000002 811219000000 811221000001 811221000004 811222000001 811222000002 811229000000 811231000000 811239000000 811241000000 811241000001 811241009999 811249000000 811249000001 811249009999 811251000001 811251000004 811252000001 811252000002 811259000000 811261000000 811269000000 811292000000 811299000000 811300000001 811300000002 811300000003 811300000004 820110000000 820130000000 820140000000 820150000000 820160000001 820160000002 820190000000 820210000000 820220000000 820231000000 820239000000 820240000000 820291000000 820299000000 820310000000 820320000001 820320000002 820320000003 820320000004 820320009999 820330000000 820340000000 820411000000 820412000000 820420000000 820510000000 820520000000 820530000000 820540000000 820551000001 820551000002 820551000004 820551000007 820551000011 820551000012 820551000017 820551000018 820551009999 820559100000 820559200000 820559900000 820560000000 820570000000 820590100000 820590200000 820600000000 820713000000 820719000000 820720000000 820730000001 820730000002 820730000003 820740000000 820750000000 820760000000 820770000000 820780000000 820790000000 820810000000 820820000000 820830000000 820840000000 820890000000 820900000000 821000000000 821110000000 821191200000 821191300000 821191900000 821192000000 821193100000 821193900000 821194000000 821195000000 821210100000 821210200000 821210900000 821220000000 821290000000 821300000000 821410100000 821410900000 821420000000 821490100000 821490900000 821510000000 821520000000 821591000000 821599000000 830110000000 830120000000 830130000000 830140100000 830140200000 830140300000 830140400000 830140500000 830140900000 830150000000 830160000000 830170000000 830210100000 830210900000 830220000000 830230000000 830241110000 830241190000 830241200000 830241900000 830242000000 830249000000 830250000000 830260100000 830260900000 830300000001 830300000002 830300000003 830300000004 830300000005 830300000006 830300000007 830300000008 830300009999 830400100000 830400210000 830400290000 830400300000 830400400000 830400900000 830510000000 830520000000 830590000000 830610000001 830610009999 830621000000 830629000001 830629009999 830630000000 830710000000 830790000000 830810000000 830820000000 830890100000 830890200000 830890900000 830910000000 830990100000 830990200000 830990300000 830990400001 830990400002 830990400003 830990500000 830990600000 830990700000 830990900000 831000100001 831000100002 831000100003 831000100004 831000109999 831000200001 831000200002 831000200003 831000300000 831000400000 831000500001 831000500002 831000500003 831000509999 831000600000 831000700000 831000900000 831110000000 831120000000 831130000000 831190000000 '"/>
            <let name="codes16" value="' 840110000000 840120100001 840120100002 840120210001 840120210002 840120210003 840120210004 840120220001 840120230001 840120240001 840120250001 840120250010 840120260001 840120270001 840120280001 840120300001 840120300010 840120300011 840130000000 840140000001 840211000000 840212000000 840219000000 840220000000 840290000000 840310000000 840390000000 840410000000 840420000000 840490000000 840510000000 840590000000 840610000000 840681000000 840682000000 840690000000 840710000000 840721000000 840729000000 840731000000 840732000000 840733000000 840734100000 840734200000 840734300000 840790000000 840810000000 840820000000 840890100000 840890900000 840910000000 840991100000 840991200000 840991300000 840991400000 840991500000 840991900000 840999000001 840999000002 840999000003 840999000004 840999009999 841011000000 841012000000 841013000000 841090000000 841111000000 841112000000 841121000000 841122000000 841181000001 841181009999 841182000001 841182009999 841191000000 841199000000 841210000000 841221000000 841229000000 841231000000 841239000000 841280000001 841280009999 841290000000 841311000001 841311000002 841319100000 841319900001 841319900002 841319900003 841319900004 841319900005 841319909999 841320000000 841330000001 841330000002 841330000003 841340000000 841350000001 841350009999 841360000001 841360009999 841370000001 841370000002 841370000003 841370009999 841381100000 841381200000 841381300000 841381400000 841381900000 841382000001 841382009999 841391000000 841392000000 841410000001 841410000002 841410009999 841420000000 841430000000 841440000000 841451100001 841451100002 841451100003 841451100004 841451100005 841451109999 841451200001 841451200002 841451200003 841451200004 841451200005 841451209999 841459100001 841459100002 841459100003 841459100004 841459100005 841459109999 841459200000 841459300001 841459309999 841459910000 841459990000 841460000000 841470000000 841480100000 841480300000 841480900001 841480900002 841480900003 841480909999 841490000000 841510100001 841510109999 841510200001 841510209999 841520000000 841581200001 841581209999 841581900001 841581909999 841582200001 841582209999 841582900001 841582909999 841583200001 841583209999 841583900001 841583909999 841590000000 841610000000 841620000000 841630000000 841690000000 841710000001 841710000002 841710009999 841720000000 841780100000 841780200001 841780200002 841780300001 841780300002 841780400000 841780900000 841790000000 841810000000 841821000000 841829000000 841830000000 841840000000 841850000001 841850000002 841850000003 841850000004 841850000005 841850000006 841850000007 841850000008 841850009999 841861000000 841869100000 841869200000 841869300000 841869400001 841869400002 841869500000 841869900001 841869900002 841869900003 841869900004 841869900005 841869900901 841869909999 841891000000 841899100000 841899900000 841911000000 841912000000 841919000000 841920000000 841933000000 841934000000 841935000000 841939000000 841940000000 841950000001 841950000002 841950000003 841950000004 841950009999 841960000000 841981000001 841981000002 841981000003 841989000000 841990000001 841990000002 841990000003 841990009999 842010000001 842010000002 842010000003 842010000004 842010000005 842010000006 842010000007 842010000008 842010000009 842010000010 842010009999 842091000000 842099000000 842111000000 842112000001 842112000002 842119000001 842119000002 842119000003 842119000004 842119000005 842119000006 842119009999 842121100001 842121109999 842121900001 842121909999 842122000000 842123000001 842123000002 842129100000 842129900000 842131000000 842132000000 842139000001 842139000002 842139000003 842139009999 842191000000 842199000001 842199009999 842211000000 842219000000 842220000000 842230100000 842230200000 842230300000 842240000000 842290000000 842310000001 842310000002 842310000003 842310000004 842310000006 842320000000 842330000000 842381000000 842382000000 842389000000 842390000000 842410100000 842410210000 842410220000 842410290000 842420100000 842420900000 842430000000 842441100000 842441900000 842449100000 842449900000 842482100000 842482300000 842482900000 842489000000 842490100000 842490200000 842490910000 842490920000 842490930000 842490990000 842511000000 842519000000 842531000001 842531000002 842539000000 842541000000 842542000000 842549000000 842611000000 842612000000 842619000001 842619009999 842620000000 842630000000 842641000000 842649000000 842691000000 842699000000 842710000001 842710009999 842720000001 842720009999 842790000000 842810100000 842810200000 842810300000 842810400000 842810900000 842820000000 842831000000 842832000000 842833000000 842839000000 842840000001 842840000002 842860000000 842870000001 842870009999 842890100000 842890200000 842890300000 842890400000 842890500000 842890900000 842911000000 842919000000 842920000000 842930000000 842940000001 842940000002 842951000000 842952000000 842959000000 843010000000 843020000000 843031100000 843031200000 843039100000 843039200000 843041000000 843049000000 843050000000 843061000000 843069100000 843069900000 843110000001 843110000002 843110000003 843110009999 843120000001 843120000002 843120000003 843120009999 843131100001 843131109999 843131200001 843131209999 843139000001 843139000002 843139009999 843141000001 843141000002 843141000003 843141000004 843142000000 843143100000 843143900000 843149000000 843210000000 843221000000 843229000001 843229000002 843229000003 843229009999 843231000001 843231000002 843231000003 843239000001 843239000002 843239000003 843241000000 843242000000 843280000001 843280000002 843280000003 843280009999 843290000001 843290000002 843290000003 843290000004 843290009999 843311000000 843319000000 843320000000 843330000000 843340000000 843351000000 843352000000 843353000000 843359000000 843360000001 843360000002 843360000003 843360000004 843360000005 843360000006 843360009999 843390000001 843390000002 843390000003 843390000004 843390000005 843390000006 843390000007 843390000008 843390000009 843390000010 843390009999 843410000000 843420000001 843420000002 843420000003 843420009999 843490000001 843490000002 843490009999 843510000001 843510000002 843510009999 843590000001 843590009999 843610000000 843621000001 843621000002 843629000000 843680100000 843680900001 843680900002 843680909999 843691000000 843699000000 843710000001 843710000002 843710000003 843710000004 843710000005 843710000006 843710000007 843710000008 843710000009 843710000010 843710000011 843710000012 843780000001 843780000002 843780000003 843780000004 843780009999 843790000001 843790000002 843790009999 843810000001 843810000002 843810000003 843810000004 843810000005 843810000006 843810000007 843810009999 843820000001 843820000002 843820000003 843820000004 843820000005 843820000006 843820009999 843830000001 843830000002 843830000003 843830009999 843840000000 843850000001 843850000002 843850000004 843850000005 843850000006 843850009999 843860000001 843860000002 843860000003 843860000004 843860009999 843880000001 843880000002 843880000003 843880000004 843880009999 843890000000 843910000001 843910000002 843910000003 843910000004 843910000005 843910000006 843910009999 843920000001 843920009999 843930000001 843930000002 843930000003 843930000004 843930000005 843930009999 843991000000 843999000001 843999000002 844010000001 844010000002 844010000003 844010000004 844010000005 844010000006 844010000007 844010000008 844010000009 844010009999 844090000000 844110000000 844120000001 844120000002 844130000001 844130000002 844130000003 844130000004 844130000005 844130009999 844140000001 844140000002 844140000003 844140000005 844140009999 844180000000 844190000000 844230000000 844240000000 844250000001 844250000002 844250000003 844311000000 844312000000 844313000000 844314000000 844315000000 844316000000 844317000000 844319000000 844331000000 844332100000 844332200000 844332300000 844332900001 844332900002 844332909999 844339100000 844339200000 844339900000 844391000001 844391000002 844391000003 844391000004 844391000005 844391009999 844399200000 844399300000 844399400000 844399500000 844399900000 844400000001 844400000002 844400000003 844400000004 844400009999 844511000000 844512000000 844513000000 844519000000 844520000000 844530000000 844540000000 844590000001 844590009999 844610000000 844621000000 844629000000 844630000000 844711000000 844712000000 844720000000 844790000001 844790000002 844790000003 844790000004 844790000005 844790000006 844790009999 844811000001 844811000002 844811000003 844811000004 844811000005 844811000006 844819000000 844820000000 844831000000 844832000000 844833000000 844839000001 844839009999 844842000001 844842000002 844842000003 844849000000 844851000000 844859000000 844900000001 844900000002 844900000003 844900000004 845011000000 845012000000 845019000000 845020000001 845020000002 845090000000 845110000000 845121000000 845129000001 845129000002 845130000000 845140000000 845150000000 845180000000 845190000000 845210000000 845221000000 845229000000 845230000000 845290000001 845290000002 845290000003 845290009999 845310000001 845310000002 845310000003 845310000004 845310000005 845310000006 845320000000 845380000000 845390000000 845410000000 845420000001 845420000002 845430000000 845490000000 845510000000 845521000000 845522000000 845530000000 845590000000 845611000001 845611009999 845612000000 845620000000 845630000001 845630009999 845640000000 845650000000 845690000001 845690000002 845690000003 845690000004 845690009999 845710000000 845720000000 845730000000 845811000001 845811009999 845819000000 845891000001 845891009999 845899000000 845910000000 845921000000 845929000000 845931000001 845931009999 845939000000 845941000000 845949000000 845951000001 845951009999 845959000000 845961000000 845969000000 845970000001 845970000002 846012000001 846012009999 846019000000 846022000000 846023000000 846024000000 846029000001 846029009999 846031000000 846039000000 846040000001 846040000002 846090000000 846120000000 846130000000 846140000001 846140000002 846140000003 846150000001 846150000002 846190000001 846190009999 846211000000 846219000001 846219009999 846222000000 846223000000 846224000000 846225000000 846226000000 846229000000 846229000001 846229009999 846232000000 846233000000 846239000000 846242000000 846249000000 846251000000 846259000000 846261000000 846262000000 846263000000 846269000000 846290000000 846310000001 846310000002 846310000003 846310009999 846320000000 846330000000 846390000000 846410000000 846420000001 846420000002 846490000000 846510000000 846520000000 846591000000 846592000001 846592000002 846592000003 846593000001 846593000002 846593000003 846594000001 846594000002 846594000003 846594000004 846595000001 846595000002 846596000001 846596000002 846596000003 846599000000 846610000000 846620000000 846630000000 846691000000 846692000000 846693000001 846693000002 846693000003 846693000004 846693000005 846693000006 846694000001 846694000002 846711000000 846719100001 846719100002 846719100003 846719200000 846719300000 846719400000 846719500000 846719600000 846719700000 846719800000 846719900000 846721000000 846722000000 846729000000 846781000000 846789000000 846791000000 846792000000 846799000000 846810000000 846820000000 846880000000 846890000000 847010000000 847021000000 847029000000 847030000000 847050000001 847050009999 847090100000 847090200000 847090900000 847130000002 847130000003 847130009999 847141100000 847141900000 847149000000 847150000000 847160000001 847160000002 847160000003 847160009999 847170000000 847180000000 847190000001 847190000002 847190009999 847210000000 847230000001 847230000002 847230000003 847230000004 847230000005 847230000006 847230000007 847230000008 847290100000 847290200000 847290300000 847290400000 847290500000 847290600000 847290700000 847290800000 847290900001 847290900002 847290900003 847290909999 847321000000 847329000000 847330000001 847330009999 847340000000 847350000000 847410000001 847410000002 847410000003 847410000004 847410009999 847420000000 847431000001 847431000002 847432000000 847439000000 847480000001 847480000002 847480000003 847480000004 847490000000 847510000001 847510000002 847510000003 847510000004 847521000000 847529000001 847529000002 847529000003 847529000004 847529009999 847590000000 847621000001 847621000002 847629000000 847681000001 847681009999 847689000001 847689000002 847689000003 847689009999 847690000000 847710000000 847720000000 847730000000 847740000001 847740000002 847751000001 847751000002 847759000000 847780000001 847780000002 847780000003 847780000004 847780009999 847790000000 847810000000 847890000000 847910100000 847910200001 847910200002 847910300000 847910900001 847910909999 847920000001 847920000002 847920000003 847920000004 847930000000 847940000000 847950000000 847960000000 847971000000 847979000000 847981000000 847982000001 847982000002 847982000003 847982000004 847983000001 847983009999 847989100000 847989200000 847989300000 847989400001 847989400002 847989500000 847989600000 847989700000 847989800000 847989910000 847989920000 847989930000 847989940000 847989950001 847989950002 847989950003 847989950004 847989950005 847989950006 847989950007 847989950008 847989950009 847989960000 847989960001 847989960002 847989990001 847989990002 847989990003 847989990004 847989990005 847989990006 847989990007 847989990008 847989990009 847989990010 847989990011 847989990012 847989990013 847989999999 847990000001 847990000002 847990009999 848010000000 848020000000 848030100000 848030900001 848030900002 848030900003 848030909999 848041000000 848049000000 848050000000 848060000000 848071000000 848079000000 848110000000 848120000000 848130000000 848140000000 848180100000 848180200000 848180300000 848180400000 848180500000 848180600000 848180700000 848180800000 848180900001 848180900002 848180900003 848180909999 848190000001 848190009999 848210000000 848220000000 848230000000 848240000000 848250000000 848280000001 848280000002 848280009999 848291000000 848299000000 848310000001 848310000002 848320000000 848330000000 848340000001 848340000002 848340000003 848340000004 848340000005 848340000006 848340009999 848350000000 848360000000 848390000001 848390000002 848390000003 848390000004 848410000000 848420000001 848420009999 848490000000 848510000000 848520000000 848530000000 848580000000 848590000000 848610100000 848610200000 848610300000 848610400000 848610900000 848620100000 848620200000 848620300000 848620400000 848620500000 848620600001 848620600002 848620600003 848620700000 848620900000 848630100001 848630100002 848630900000 848640100000 848640200000 848640300000 848640910000 848640920000 848640990000 848690100000 848690200000 848690300000 848690400000 848690900000 848710000001 848710000002 848710000003 848790000000 '"/>
            <let name="codes17" value="' 850110000001 850110000002 850120000001 850120009999 850131000000 850132000000 850133000000 850134000000 850140000000 850151000000 850152100000 850152900000 850153110000 850153190000 850153210000 850153290000 850161000000 850162000000 850163000000 850164000000 850171000000 850172000000 850180000000 850211000000 850212000000 850213000000 850220000000 850231000000 850239000000 850240000001 850240000002 850240000003 850240009999 850300000001 850300000002 850300000003 850300000004 850300000005 850300009999 850410000000 850421000000 850422000000 850423000000 850431000000 850432000000 850433000000 850434000000 850440110000 850440120000 850440130000 850440140000 850440190001 850440190002 850440190003 850440190004 850440190005 850440199999 850440900002 850440900003 850440900004 850440900005 850440909999 850450100000 850450900000 850490000000 850511100000 850511900000 850519100000 850519900000 850520000000 850590000001 850590009999 850610100000 850610900000 850630100000 850630900000 850640100000 850640900000 850650100000 850650900000 850660100000 850660900000 850680100000 850680900000 850690000000 850710000002 850710000003 850710000004 850710000005 850710000006 850710000007 850710000008 850710000009 850710000010 850710000011 850710000012 850710000013 850710000014 850710000901 850710000902 850710000903 850710000904 850710000905 850710000906 850710000907 850710000908 850710000909 850710000910 850710000911 850710000912 850710000913 850710000914 850710000915 850710000916 850710000917 850710000918 850710000919 850710000920 850710000921 850710000922 850710000923 850710000924 850710000925 850710000926 850710000927 850710009999 850720000000 850730000000 850750000000 850760000001 850760000002 850760000003 850760009999 850780000000 850790000001 850790000002 850790009999 850811000000 850819100000 850819200000 850819900000 850860000000 850870000000 850940000001 850940000002 850940000003 850940000004 850980100001 850980100002 850980200001 850980200002 850980200003 850980200004 850980200005 850980300000 850980400000 850980900002 850980900007 850980900008 850980909999 850990000001 850990009999 851010000000 851020000000 851030000000 851090000001 851090000002 851090000003 851090009999 851110000000 851120000001 851120000002 851120000003 851130000001 851130000002 851140000000 851150000000 851180000001 851180009999 851190000000 851210000001 851210000002 851220000001 851220000002 851220000003 851220000004 851220000005 851220000006 851220009999 851230000001 851230000002 851230000003 851230000004 851230000005 851230009999 851240000001 851240000002 851240000003 851290000000 851310000001 851310009999 851390000000 851411000001 851411009999 851419000000 851420000001 851420000002 851420000003 851431000000 851431000001 851431009999 851432000000 851432000001 851432000002 851432009999 851439000000 851440000000 851490000001 851490000002 851490000003 851490000004 851490000005 851490000006 851490000007 851490009999 851511000000 851519000000 851521000000 851529000000 851531000000 851539000000 851580000001 851580000002 851580000003 851580009999 851590000001 851590000002 851590000003 851590009999 851610100001 851610100002 851610100003 851610200001 851610200002 851610200003 851621000000 851629100000 851629900000 851631000000 851632000000 851633000000 851640000000 851650000000 851660000001 851660000002 851660000003 851660000004 851660000005 851660000006 851671000000 851672000000 851679100001 851679100002 851679200000 851679900001 851679900002 851679900003 851679909999 851680000000 851690000001 851690009999 851711000000 851713000000 851714100000 851714200000 851714900000 851718000001 851718000002 851718000003 851718009999 851761000000 851762100000 851762200001 851762200002 851762200003 851762200004 851762200005 851762209999 851762300000 851762400000 851762500000 851762600000 851762700000 851762800000 851762900001 851762900002 851762900003 851762900004 851762900005 851762900006 851762900007 851762900008 851762900009 851762909999 851769100000 851769900001 851769900002 851769909999 851771000001 851771000002 851771000003 851771009999 851779000000 851810100000 851810900000 851821000000 851822000000 851829100000 851829900000 851830100000 851830900001 851830900002 851830900003 851830900004 851840100000 851840900000 851850000000 851890100000 851890900000 851920000000 851930000000 851981000000 851989000000 852110000000 852190000000 852210000000 852290000000 852321000000 852329100000 852329900001 852329909999 852341000000 852349000001 852349009999 852351000001 852351000901 852351009999 852352000001 852352000002 852352000003 852352009999 852359000000 852380000000 852411000000 852412000000 852419000000 852491000000 852492000000 852499000000 852550000000 852560000000 852581100000 852581200000 852581300000 852581900001 852581900002 852581900003 852581909999 852582100000 852582200000 852582300000 852582900000 852583100000 852583200000 852583300000 852583900000 852589100000 852589200000 852589300000 852589900000 852610000000 852691100000 852691910000 852691990000 852692000000 852712000000 852713000000 852719000000 852721000000 852729000000 852791000000 852792000000 852799000000 852842000000 852849000000 852852000000 852859000000 852862000000 852869000000 852871100000 852871200000 852871900000 852872200000 852872300000 852872900000 852873000000 852910000000 852990100001 852990100002 852990109999 852990900000 853010000000 853080000001 853080000002 853080009999 853090000000 853110000001 853110000002 853110009999 853120000000 853180100000 853180200000 853180300000 853180900000 853190100000 853190900000 853210000000 853221000000 853222000000 853223000000 853224000000 853225000001 853225000002 853229000000 853229000001 853229000002 853229009999 853230000000 853290000000 853310000000 853321000000 853329000000 853331000000 853339000000 853340000001 853340000002 853340009999 853390000000 853400000001 853400000002 853400000003 853400000004 853400009999 853510000000 853521000000 853529000000 853530000001 853530000002 853540000001 853540000002 853540000003 853590000001 853590000002 853590000003 853590009999 853610000000 853620000000 853630000000 853641000000 853649000000 853650100000 853650100901 853650100902 853650100903 853650100905 853650100906 853650200000 853650200901 853650200902 853650200903 853650200905 853650200906 853650300000 853650300901 853650300902 853650300903 853650300905 853650300906 853650900001 853650900901 853650900902 853650900903 853650900904 853650900905 853650900002 853650900906 853650900907 853650900908 853650900909 853650900910 853650900003 853650900911 853650900912 853650900913 853650900914 853650900915 853650900004 853650900916 853650900917 853650900918 853650900919 853650900920 853650900005 853650900921 853650900922 853650900923 853650900924 853650900925 853650909999 853650900926 853650900927 853650900928 853650900929 853650900930 853661000000 853669100000 853669100901 853669100902 853669100903 853669100904 853669100905 853669200001 853669200901 853669200902 853669200903 853669200904 853669200905 853669200002 853669200906 853669200907 853669200908 853669200909 853669200910 853670000001 853670000002 853670000003 853690100000 853690200000 853690910000 853690990000 853710000001 853710000002 853710000003 853710000004 853710000005 853710000006 853710000007 853710009999 853720000001 853720000002 853720000003 853720000004 853720000005 853720000006 853720000007 853720000008 853720009999 853810000001 853810000002 853810000003 853810009999 853890000000 853910000000 853921100000 853921900001 853921900002 853921909999 853922000000 853929000000 853931000003 853931000004 853931009999 853932000001 853932000002 853932000003 853939000001 853939009999 853941000000 853949000000 853951000001 853951000002 853952000001 853952000002 853990000001 853990000002 853990009999 854011000000 854012000000 854020000001 854020000002 854020000003 854040000000 854060000000 854060000001 854060009999 854071000000 854079000000 854081000000 854089000001 854089009999 854091000000 854099000000 854110000001 854110000002 854110000003 854110000004 854110009999 854121000000 854129000000 854130000000 854141000000 854142000000 854143000000 854149000000 854151000000 854159000000 854160000000 854190000000 854231000000 854232000000 854233000000 854239000000 854290000000 854310000000 854310000001 854310009999 854320000000 854320000001 854320000002 854320009999 854330000000 854330000001 854330009999 854340100000 854340200000 854340300000 854340900000 854370100000 854370200000 854370900001 854370900002 854370900003 854370900004 854370900005 854370900006 854370900007 854370900008 854370900011 854370900012 854370900014 854370900015 854370900016 854370900017 854370909999 854390100000 854390910000 854390920000 854390930000 854390980000 854390990000 854411000000 854419000000 854420100000 854420200000 854420300000 854420900000 854430000001 854430000002 854442110000 854442190000 854442210000 854442210901 854442210902 854442210903 854442210904 854442210905 854442290000 854442300000 854442400000 854442910000 854442910901 854442910902 854442910903 854442910904 854442910905 854442990000 854449100000 854449210000 854449290000 854449310000 854449390000 854449410000 854449490000 854449910001 854449919999 854449990001 854449999999 854460100000 854460200000 854460300000 854460900000 854470000000 854511000000 854519000001 854519000002 854519009999 854520000000 854590000001 854590000002 854590000003 854590009999 854610000000 854620000000 854690000001 854690000002 854690000003 854690009999 854710000000 854720000000 854790000001 854790000002 854790000003 854790009999 854800000000 854911000000 854912000000 854913000000 854914000000 854919000000 854921000000 854929000000 854931000000 854939100000 854939900000 854991000000 854999000000 '"/>
            <let name="codes18" value="' 860110000000 860120000000 860210000000 860290000000 860310000001 860310000002 860310009999 860390000000 860400000001 860400000002 860400000003 860400009999 860500000001 860500000002 860500000003 860500000004 860500009999 860610000000 860630000000 860691000001 860691000002 860691009999 860692000000 860699000001 860699000002 860699009999 860711000000 860712000000 860719000000 860721000000 860729000000 860730000000 860791000000 860799000000 860800000001 860800000002 860800000003 860900000000 870110000000 870121000000 870122000000 870123000000 870124000000 870129000001 870129009999 870130000000 870191000000 870192000000 870193000000 870194000000 870195000000 870210000000 870220000000 870230000000 870240000001 870240000002 870290100000 870290200000 870290900000 870310000001 870310000002 870310000003 870310000004 870310000005 870310009999 870321110000 870321120000 870321310000 870321320000 870321500001 870321500002 870321500003 870321500004 870321509999 870321600000 870321710000 870321790000 870321810000 870321820000 870321900000 870322110000 870322120000 870322310000 870322320000 870322500001 870322500002 870322500003 870322500004 870322509999 870322600000 870322700000 870322810000 870322820000 870322900000 870323110001 870323119999 870323120001 870323129999 870323310001 870323319999 870323320001 870323329999 870323500001 870323500002 870323500003 870323500004 870323509999 870323600000 870323700000 870323810000 870323820000 870323900000 870324110001 870324119999 870324120001 870324129999 870324310001 870324319999 870324320001 870324329999 870324500001 870324500002 870324500003 870324500004 870324509999 870324600000 870324710000 870324720000 870324900000 870331100000 870331200000 870331310000 870331320000 870331910000 870331990000 870332100000 870332200000 870332310000 870332320000 870332910000 870332990000 870333100000 870333200000 870333310000 870333320000 870333910000 870333920000 870333990000 870340000001 870340000002 870340009999 870350000001 870350000002 870350009999 870360000001 870360000002 870360009999 870370000001 870370000002 870370009999 870380000001 870380000002 870380000004 870380000005 870380000006 870380000007 870380000008 870380009999 870380000920 870390000001 870390000002 870390009999 870410000000 870421100001 870421100002 870421200000 870421300000 870421400000 870421500000 870421600000 870421910000 870421920000 870421990000 870422110000 870422120000 870422200000 870422300000 870422400000 870422500000 870422600000 870422700001 870422700002 870422700003 870422910000 870422920000 870422990000 870423100000 870423200000 870423300000 870423400000 870423500000 870423600000 870423700000 870423910000 870423920000 870423990000 870431100000 870431200000 870431300000 870431400000 870431500000 870431600000 870431700000 870431800000 870431900001 870431909999 870432100000 870432200000 870432300000 870432900000 870441000000 870442000000 870443000000 870451000000 870452000000 870460000000 870490000000 870510000000 870520000000 870530000000 870540000000 870590100000 870590200000 870590300000 870590400000 870590500000 870590600000 870590700000 870590800000 870590910000 870590920001 870590920002 870590920003 870590920004 870590930001 870590930002 870590940000 870590990001 870590999999 870600000001 870600000002 870600000003 870600000004 870600000005 870710000000 870790100000 870790200000 870790310000 870790320000 870790330000 870790340000 870790350000 870790360000 870790390000 870790900000 870810000001 870810000002 870810000003 870810000004 870810000005 870821000000 870822100000 870822200000 870829100005 870829109999 870829900001 870829900002 870829900003 870829900004 870829900005 870829900006 870829909999 870830000001 870830000002 870830000003 870830000004 870830009999 870840000001 870840000002 870840000003 870840000004 870840000005 870840000006 870840000007 870840000008 870840009999 870850100001 870850100002 870850109999 870850900000 870870000000 870880000001 870880000002 870880000003 870880000004 870880009999 870891100001 870891100002 870891100003 870891100004 870891100005 870891200000 870892100001 870892100002 870892100003 870892100004 870892100005 870892100006 870892100007 870892200001 870892200002 870892200003 870892200004 870892200005 870892200006 870893000001 870893000002 870893000003 870893000004 870893000005 870894100001 870894100002 870894100003 870894100004 870894100005 870894200000 870895000006 870895009999 870899100001 870899100002 870899100003 870899100004 870899100005 870899900000 870911000000 870919000000 870990000001 870990000002 870990000003 870990000004 870990000005 870990009999 871000000001 871000000002 871000000003 871110000001 871110009999 871120000001 871120009999 871130000000 871140000000 871150000000 871160100000 871160900000 871190000000 871200100001 871200100002 871200100003 871200100004 871200100005 871200100006 871200109999 871200200000 871200900000 871310000000 871390000000 871410000001 871410009999 871420000000 871491000000 871492000000 871493000000 871494000000 871495000000 871496000000 871499000000 871500100000 871500200000 871500900000 871610000000 871620000000 871631000000 871639100000 871639200000 871639300000 871639400000 871639500000 871639600001 871639600002 871639700000 871639900000 871640100000 871640200000 871640300000 871640900000 871680110001 871680110002 871680120000 871680130000 871680140000 871680150000 871680160000 871680170000 871680180000 871680190001 871680190002 871680199999 871680900000 871690100001 871690100002 871690100003 871690900001 871690900002 '"/>
            <let name="codes19" value="' 880100000001 880100000002 880100000003 880100000004 880100000005 880100000006 880100000007 880100000008 880211000001 880211000002 880211000003 880211000004 880211000005 880211009999 880212000001 880212000002 880212000003 880212000004 880212000005 880212009999 880220000001 880220000002 880220000003 880220000004 880220000005 880220000006 880220000007 880220009999 880230000001 880230000002 880230000003 880230000004 880230000005 880230000006 880230000007 880230009999 880240000001 880240000002 880240000003 880240000004 880240000005 880240000006 880240000007 880240009999 880260000000 880400000001 880400000002 880400000003 880400000004 880510000001 880510000002 880510000003 880510000004 880521000001 880521000002 880529000001 880529000002 880529000003 880529000004 880610000000 880621100000 880621900000 880622100000 880622900000 880623100000 880623200000 880623900000 880624100000 880624200000 880624900000 880629100000 880629900000 880691100000 880691900000 880692100000 880692900000 880693100000 880693900000 880694100000 880694900000 880699100000 880699900000 880710000001 880710009999 880720000001 880720009999 880730000001 880730000002 880730000003 880730000004 880730000005 880730009999 880790000000 890110000001 890110000002 890110000003 890110000004 890110009999 890120000000 890130000000 890190000001 890190000002 890200000001 890200000002 890200000003 890311000000 890312000000 890319000000 890321000000 890322000000 890323000000 890331000000 890332000000 890333000000 890393000000 890399100000 890399200000 890399300000 890399900001 890399909999 890400000001 890400000002 890510000000 890520000000 890590100000 890590200000 890590900001 890590900002 890590909999 890610000000 890690100000 890690900001 890690900002 890690900003 890690900004 890690909999 890710000000 890790000001 890790000002 890790000003 890790000004 890790000005 890790000006 890790000007 890790009999 890800000000 900110000001 900110000002 900110000003 900120000000 900130000001 900130000002 900130000003 900130009999 900140000000 900150000000 900190000000 900211000001 900211000002 900211000003 900211000004 900219000001 900219009999 900220000000 900290000000 900311000001 900311000002 900319000001 900319000002 900319009999 900390000000 900410000000 900490100001 900490100002 900490109999 900490200001 900490200002 900490209999 900490900001 900490909999 900510000001 900510000002 900580000001 900580000002 900580000003 900580009999 900590000000 900630000001 900630000002 900630000003 900630000004 900630000005 900640000000 900653000000 900659000000 900661000000 900669000000 900691000001 900691000002 900691000003 900691009999 900699000000 900710000000 900720000000 900791000000 900792000000 900850000000 900890000000 901010000001 901010000002 901050000001 901050000002 901050000003 901060000000 901090000000 901110000000 901120000001 901120000002 901120000003 901180000001 901180009999 901190000000 901210000000 901290000000 901310000001 901310000002 901310000003 901320100001 901320100002 901320900001 901320900002 901320900003 901320900004 901320900005 901320900006 901320900007 901320900008 901320900009 901320900010 901320909999 901380100001 901380100002 901380200001 901380209999 901380300000 901380900000 901390100000 901390900001 901390909999 901410000001 901410000002 901410000003 901410009999 901420000000 901480000000 901490000000 901510000000 901520000001 901520000002 901530000000 901540000000 901580000001 901580000002 901580000003 901580009999 901590000000 901600000000 901710100000 901710900000 901720100001 901720109999 901720900000 901730000000 901780100000 901780200000 901780900000 901790100000 901790900000 901811000000 901812000000 901813000000 901814000000 901819100001 901819100002 901819200001 901819200002 901819200003 901819200004 901819200005 901819209999 901819900001 901819900002 901819900003 901819900004 901820000001 901820009999 901831100000 901831200001 901831200002 901831200003 901831300000 901831400000 901831900000 901832000001 901832000002 901839100001 901839109999 901839200001 901839200002 901839200003 901839200004 901839200005 901839200006 901839300000 901839900000 901841000001 901841000002 901849100000 901849200000 901849300000 901849400000 901849900000 901850100001 901850100002 901850100003 901850200001 901850200002 901850200003 901850910000 901850990000 901890100001 901890100002 901890100003 901890109999 901890200000 901890300000 901890400000 901890500001 901890500002 901890500003 901890600000 901890700000 901890800000 901890900001 901890900002 901890900003 901890909999 901910000001 901910000002 901910000003 901920000001 901920000002 901920000003 901920000004 901920009999 902000000001 902000000002 902000000003 902000000004 902110100001 902110100002 902110100003 902110100004 902110200000 902110300000 902110400001 902110400002 902110500001 902110500002 902110500003 902110600000 902110700000 902110900000 902121000000 902129000000 902131000000 902139100000 902139200001 902139200002 902139200003 902139200005 902139200006 902139200007 902139200008 902139900000 902140000000 902150000000 902190100000 902190200000 902190900001 902190909999 902212000000 902213000000 902214000001 902214000002 902214000003 902214000004 902214000005 902219100000 902219900001 902219900002 902219900003 902219900004 902219909999 902221000001 902221000002 902221000003 902221000004 902221000005 902221000006 902221000007 902221000008 902221000009 902229000000 902230000000 902290000001 902290000002 902290009999 902300000001 902300000002 902300009999 902410000000 902480000001 902480000002 902480000003 902480000004 902480009999 902490000000 902511000000 902511000901 902519000001 902519000901 902519009999 902580100000 902580200000 902580900000 902590000001 902590009999 902610000001 902610000002 902610000003 902610000004 902610000005 902610000006 902610000007 902610000008 902620000001 902620000002 902620000003 902620009999 902680000003 902680000004 902680009999 902690000000 902710000001 902710000002 902720000001 902720000002 902730000001 902730000002 902730000003 902750000000 902781000001 902781009999 902789100000 902789200000 902789900000 902790100001 902790109999 902790900001 902790909999 902810000000 902820100000 902820900000 902830000000 902890000000 902910100000 902910200000 902910900000 902920000001 902920000002 902920000003 902990000000 903010000001 903010000002 903010000003 903020000000 903031000000 903032000000 903033000000 903039000000 903040000001 903040000002 903040000003 903040000004 903040009999 903082000000 903084000000 903089000000 903090100000 903090900000 903110000001 903110000002 903110009999 903120000000 903141000000 903149100000 903149200000 903149300000 903149900000 903180100000 903180200000 903180300000 903180400000 903180900001 903180900002 903180900003 903180900004 903180909999 903190100000 903190200000 903190300000 903190400000 903190500000 903190600000 903190700000 903190800000 903190900000 903210000000 903220000000 903281000000 903289000000 903290000000 903300000000 '"/>
            <let name="codes20" value="' 910111000001 910111000002 910111000003 910111000004 910111000005 910111000006 910111009999 910119000001 910119000002 910119000003 910119000004 910119000005 910119000006 910119009999 910121000001 910121000002 910121000003 910121000004 910121000005 910121000006 910121000007 910129000001 910129000002 910129000003 910129000004 910129009999 910191000001 910191000002 910191000003 910191000004 910191009999 910199000000 910211000001 910211009999 910212000001 910212009999 910219000001 910219009999 910221000001 910221009999 910229000001 910229009999 910291000000 910299000001 910299009999 910310000000 910390000000 910400000001 910400000002 910400000003 910400000004 910400000005 910400000006 910400009999 910511000000 910519000000 910521000000 910529000000 910591000000 910599000000 910610000000 910690000000 910700000001 910700000002 910700000003 910700000004 910700009999 910811000000 910812000000 910819000000 910820000000 910890000000 910910000000 910990000000 911011000000 911012000000 911019000000 911090000000 911110000000 911120000000 911180000000 911190000000 911220000001 911220000002 911220000003 911220000004 911220009999 911290000000 911310000001 911310000002 911310000003 911310000004 911320000001 911320000002 911320000003 911320000004 911390100000 911390200001 911390200002 911390300000 911390400001 911390400002 911390400003 911390400004 911390900000 911430000000 911440000000 911490000000 920110000000 920120000000 920190000000 920210000001 920210000002 920210009999 920290100000 920290900001 920290909999 920510000001 920510000002 920510000003 920510009999 920590000001 920590000002 920590000003 920590000004 920590000005 920590009999 920600100000 920600200000 920600300000 920600400000 920600900000 920710000001 920710000002 920710009999 920790000000 920810000000 920890100000 920890200000 920890300000 920890400000 920890900000 920930000001 920930000002 920930000003 920930009999 920991000000 920992000000 920994000000 920999000000 930110100000 930110200000 930110900000 930120000001 930120000002 930120000003 930120000004 930190100000 930190900000 930200000001 930200000002 930200009999 930310000000 930320000000 930330000000 930390000001 930390000002 930390000003 930390009999 930400100000 930400900001 930400900002 930400900003 930400900004 930400909999 930510000901 930510000902 930520000901 930520000902 930591000901 930591000902 930599000901 930599000902 930621100000 930621900000 930629100000 930629900000 930630100000 930630900001 930630909999 930690000000 930700100001 930700100002 930700100003 930700100004 930700100005 930700109999 930700900001 930700900002 930700900003 930700900004 930700900005 930700900006 930700909999 940110000000 940120000000 940131000000 940139000000 940141000000 940149000000 940152000000 940153000000 940159000001 940159000002 940159000003 940161000001 940161000002 940161000004 940161000012 940161009999 940169000000 940171100000 940171200000 940171900000 940179100000 940179200000 940179900000 940180110000 940180120000 940180190000 940180200001 940180200002 940180200003 940180900000 940191000000 940199000000 940210100001 940210100002 940210100003 940210100004 940210100005 940210109999 940210200000 940210900001 940210900002 940210900003 940210900004 940210900005 940210909999 940290100001 940290100002 940290100003 940290100004 940290100005 940290100006 940290100007 940290100008 940290100009 940290100010 940290100011 940290100012 940290100013 940290100014 940290100015 940290100016 940290109999 940290900001 940290900002 940290900003 940290900004 940290900005 940290900006 940290900007 940290909999 940310100000 940310200000 940310300000 940310900000 940320100000 940320200000 940320300000 940320400000 940320500001 940320500002 940320500003 940320900001 940320900002 940320900003 940320900004 940320900005 940320900006 940320900007 940320900008 940320900019 940320900026 940320900027 940320900028 940320909999 940330100000 940330200000 940330300000 940330900000 940340100000 940340200000 940340900000 940350100000 940350200000 940350900001 940350900002 940350900003 940350900004 940350900005 940350909999 940360100000 940360200000 940360300000 940360400000 940360900001 940360900005 940360909999 940370000007 940370009999 940382000000 940383000000 940389000001 940389000002 940389000003 940389009999 940391000000 940399000000 940410000000 940421100000 940421900006 940421909999 940429100000 940429900000 940430000001 940430000002 940440000000 940490100000 940490200001 940490200002 940490300001 940490300002 940490400000 940490900000 940511000000 940519000000 940521000000 940529000000 940531000000 940539000000 940541000000 940542000000 940549100000 940549200000 940549900000 940550000000 940561100000 940561900000 940569000000 940591000000 940592000000 940599000001 940599000002 940599000003 940599000004 940599000005 940599000006 940599000008 940599000009 940599000010 940599000011 940599000012 940599000013 940599000014 940599000015 940599000016 940599000017 940599000018 940599000019 940599009999 940610100000 940610200000 940610300000 940610400000 940610900000 940620000000 940690110000 940690120000 940690130000 940690140000 940690190001 940690199999 940690210000 940690220000 940690230000 940690240000 940690290000 940690310000 940690320000 940690330000 940690340000 940690390000 940690410000 940690420000 940690430000 940690440000 940690490000 940690900000 950300100001 950300100002 950300100003 950300100004 950300109999 950300200000 950300300000 950300400000 950300900001 950300900002 950300909999 950420100001 950420100002 950420109999 950420900001 950420900002 950420909999 950430000000 950440000001 950440000002 950450000001 950450000002 950450000003 950490000001 950490000002 950490000003 950490000004 950490000005 950490000006 950490000007 950490009999 950510000000 950590000001 950590000002 950590000003 950590000004 950590009999 950611000000 950612000000 950619000000 950621000000 950629000000 950631000000 950632000000 950639000000 950640000001 950640000003 950640000004 950640000005 950640009999 950651000000 950659000000 950661000000 950662000001 950662000002 950662000003 950662009999 950669000000 950670000001 950670000002 950670000003 950670009999 950691000001 950691000002 950691000003 950691000004 950691000005 950691000006 950691000007 950691000008 950691000009 950691000010 950691000011 950691000012 950691000013 950691000014 950691000015 950691000016 950691009999 950699100000 950699900000 950710000000 950720000000 950730000000 950790000000 950810000000 950821000000 950822000000 950823000000 950824000000 950825000000 950826000000 950829000000 950830000000 950840000000 960110000000 960190000000 960200100000 960200200000 960200300001 960200309999 960200400000 960200500000 960200900000 960310000000 960321000000 960329100000 960329200000 960329900000 960330000000 960340000001 960340000002 960340000003 960340009999 960350000000 960390100000 960390200000 960390300000 960390400000 960390500000 960390900000 960400000002 960400000003 960400009999 960500000001 960500000002 960500000003 960500000004 960610000001 960610000002 960610000003 960610000004 960610000006 960610009999 960621000000 960622000000 960629000000 960630000000 960711000000 960719000000 960720000000 960810000000 960820000000 960830100000 960830900000 960840000000 960850000000 960860000000 960891000000 960899000001 960899000002 960899000003 960899000004 960899000005 960899000006 960899009999 960910000000 960920000000 960990100000 960990200000 960990300000 960990400000 960990500000 960990900000 961000100001 961000100002 961000100003 961000100004 961000900001 961000900002 961000900003 961000909999 961100000001 961100000002 961100000003 961210000001 961210000002 961210000003 961210000004 961210000005 961210000006 961210000007 961210000008 961210000009 961210000010 961210009999 961220000000 961310000000 961320000000 961380000002 961380000003 961380000005 961380009999 961390000000 961400100000 961400200001 961400200002 961400200003 961400200004 961400200005 961400200006 961400209999 961400900001 961400900002 961400900003 961400909999 961511000001 961511000002 961511000003 961511000004 961511000005 961511000006 961519000000 961590000001 961590000002 961590009999 961610000001 961610000002 961610000003 961620000001 961620000002 961700100000 961700900000 961800000001 961800000002 961800000003 961800000004 961800000005 961900100000 961900200000 961900300000 961900400000 961900500000 961900900000 962000100000 962000900000 970121000000 970122000000 970129000000 970191000000 970192000000 970199000000 970210000000 970290000000 970310000000 970390000000 970400000001 970400000002 970400000003 970400009999 970510000000 970521000000 970522000000 970529100000 970529900000 970531000000 970539000000 970610000000 970690100000 970690200000 970690300000 970690900000 980100000001 980100000002 980200100001 980200100002 980200109999 980200200000 980300000001 980300000002 980400000000 '"/>
            
            
            <assert diagnostics="d-CL-08-OM-HS" id="CL-08-OM-HS" flag="fatal" role="fatal" test="if (string-length($hsCode) = 0) then true()                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '04') then contains($codes01, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '15') then contains($codes02, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '21') then contains($codes03, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '26') then contains($codes04, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '28') then contains($codes05, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '29') then contains($codes06, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '30') then contains($codes07, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '38') then contains($codes08, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '41') then contains($codes09, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '48') then contains($codes10, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '55') then contains($codes11, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '62') then contains($codes12, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '70') then contains($codes13, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '73') then contains($codes14, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '83') then contains($codes15, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '84') then contains($codes16, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '85') then contains($codes17, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '87') then contains($codes18, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '90') then contains($codes19, concat(' ', $hsCode, ' '))                         else if (string-length($hsCode) = 12 and substring($hsCode, 1, 2) &lt;= '98') then contains($codes20, concat(' ', $hsCode, ' '))                         else false()">[CL-08-OM-HS] - Value of 'cbc:ItemClassificationCode[@listID="HS"]' is not a valid 12-digit Oman HS code (CL-08-OM-HS).</assert>
        </rule>

        
        <rule context="cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC']">
            <let name="isicCode" value="normalize-space(.)"/>
            
            
            
            <let name="isic0" value="' 011101 011301 011302 011901 011902 012100 012201 012202 012203 012300 012400 012501 012503 012601 012602 012801 012802 012900 013001 014101 014102 014201 014202 014301 014302 014303 014401 014402 014601 014602 014603 014901 014902 016101 016102 016103 016105 016200 021000 023001 023002 024000 031101 031201 032101 032102 032103 032201 032202 032203 061000 062000 072901 072902 081001 081002 081003 081005 089101 089102 089103 089104 089301 089302 089303 089901 089902 091001 091002 091003 091004 099005 099006 099009 099010 000000 '"/>
            <let name="isic1" value="' 101001 101002 101003 101004 101005 101006 101007 101008 101009 101010 101011 102001 102002 102003 102004 102005 102006 102007 103001 103002 103003 103004 103005 103006 103007 103008 103009 103010 103011 103012 104001 104002 104003 104004 104005 104006 104007 104008 104009 105001 105002 105003 105004 105005 105006 106101 106102 106103 106104 106105 106106 106201 106202 106203 106204 107101 107102 107103 107104 107105 107106 107107 107108 107109 107201 107202 107203 107301 107302 107303 107304 107305 107306 107401 107402 107403 107500 107901 107902 107903 107904 107905 107906 107907 107908 107909 108001 108002 108003 108004 110302 110401 110402 110403 110404 110405 110406 120000 131101 131102 131103 131104 131200 131301 131302 131303 131304 139101 139201 139202 139203 139204 139205 139206 139207 139208 139301 139302 139303 139401 139402 139403 139901 139902 139903 139904 139905 139906 139907 139908 141001 141002 141003 141004 141005 141006 141007 141008 141009 141010 141011 141012 141013 141014 142001 142002 143001 143002 143003 151101 151102 151103 151104 151105 151201 151202 151203 151204 151205 151206 151207 151208 152001 152002 152003 152004 161001 161002 161003 161004 162101 162102 162103 162201 162202 162203 162204 162205 162206 162207 162301 162302 162303 162901 162902 162903 162904 162905 162906 162907 162908 162909 162910 162911 170101 170102 170103 170104 170105 170106 170201 170202 170203 170204 170205 170206 170901 170902 170903 170904 170905 170906 170907 170908 170909 170910 170911 181101 181102 181103 181104 181105 181106 181107 181108 181109 181110 181201 181202 181203 182001 182002 182003 182004 182005 182006 191000 192001 192002 192003 192004 192005 192006 192007 192008 192009 192010 192011 '"/>
            <let name="isic2" value="' 201101 201102 201103 201104 201105 201106 201107 201108 201109 201110 201111 201201 201202 201203 201204 201205 201206 201301 201302 201303 201304 201305 201306 202101 202102 202103 202104 202201 202202 202203 202204 202205 202206 202207 202208 202301 202302 202303 202304 202305 202306 202307 202308 202309 202310 202901 202902 202903 202904 202905 202906 202907 202908 202909 202910 202911 202912 202913 202914 203001 203002 210001 210002 210003 210004 210005 210006 210007 210008 210009 221101 221102 221103 221104 221105 221901 221902 221903 221904 221905 221906 221907 221908 221909 222001 222002 222003 222004 222005 222006 222007 222008 222009 222010 222011 222013 222014 222015 222016 222017 231001 231002 231003 231004 231005 231006 231007 231008 231009 239101 239102 239103 239104 239105 239201 239202 239203 239204 239205 239206 239207 239208 239301 239302 239303 239304 239305 239306 239401 239402 239403 239404 239405 239501 239502 239503 239504 239505 239506 239507 239508 239509 239601 239602 239603 239604 239605 239901 239902 239903 239904 239905 239906 241001 241002 241003 241004 241005 241006 242001 242002 242003 242004 242005 242006 242007 243101 243102 243201 251101 251102 251103 251104 251105 251106 251201 251202 251203 251301 251302 252000 259101 259102 259201 259202 259203 259301 259302 259303 259304 259305 259306 259307 259308 259309 259310 259311 259312 259313 259901 259902 259903 259904 259905 259906 259907 259908 259910 259911 259912 259913 259914 259915 259916 259917 261001 261002 261003 261004 261005 261006 261007 261009 261010 261011 262000 263001 263002 263003 263004 263005 263006 263007 264001 264002 264003 264004 264005 264006 265101 265102 265103 265104 265105 265106 265107 265108 265109 265110 265111 265201 265202 266001 266002 266003 266004 267001 267002 267003 267004 268000 271001 271002 271003 271004 272001 272002 272003 272004 273101 273102 273200 273301 273302 273303 274001 274002 274003 274004 274005 275001 275002 275003 275004 275005 275006 279001 279002 279003 279004 279006 279007 279008 279009 279010 281101 281102 281103 281104 281105 281106 281107 281108 281109 281110 281111 281201 281202 281203 281301 281302 281303 281401 281402 281403 281501 281502 281503 281504 281505 281506 281601 281602 281603 281604 281605 281606 281607 281701 281702 281703 281704 281705 281706 281707 281708 281800 281901 281902 281903 281904 281905 281906 281907 281908 281909 281910 281911 281912 282101 282102 282103 282104 282105 282106 282201 282202 282203 282204 282205 282206 282207 282208 282301 282302 282401 282402 282403 282404 282405 282406 282407 282501 282502 282503 282504 282505 282506 282507 282601 282602 282603 282604 282605 282606 282607 282608 282609 282901 282902 282903 282904 282905 282906 282907 282908 282909 282910 282911 282912 291001 291002 291003 292001 292002 292003 292004 292005 292006 293001 293002 293003 293004 293005 '"/>
            <let name="isic3" value="' 301101 301102 301103 301104 301105 301106 301201 301202 302001 302002 303001 304000 309100 309201 309202 309203 309204 309901 309902 310001 310002 310003 310004 310005 310006 321101 321102 321103 321104 321105 321201 321202 322001 322002 322003 323001 323002 323003 323004 324001 324002 324003 324004 324005 324006 324007 325001 325002 325003 325004 325005 325006 325007 325008 325009 325010 325011 325012 329001 329002 329003 329004 329005 329006 329007 329008 329009 329010 329011 329012 329013 329014 329015 329016 329017 329018 331101 331102 331103 331104 331105 331106 331107 331108 331201 331202 331203 331204 331205 331206 331207 331208 331209 331210 331211 331212 331213 331214 331215 331216 331217 331218 331219 331220 331221 331301 331302 331303 331304 331305 331306 331307 331308 331401 331402 331403 331404 331405 331406 331407 331408 331409 331410 331411 331412 331413 331501 331502 331503 331504 331505 331506 331507 331508 331509 331510 331511 331901 331902 331903 331904 331905 331906 331907 331909 331910 331911 331912 331913 331914 331915 331916 332001 332002 332003 332004 332005 332006 332007 332008 332009 332010 332011 332012 332013 332014 332015 332016 332017 332018 332019 332020 351001 351002 352001 352002 352003 353001 353002 353003 360001 360002 360003 360004 360005 370001 370002 381101 381102 381103 381201 381202 382101 382102 382103 382201 382202 383001 383002 383003 383004 383005 383006 383007 383008 390001 390002 390003 390004 '"/>
            <let name="isic4" value="' 410001 410002 421001 421002 421003 422001 422002 422003 422004 422005 422006 422007 429001 429002 429003 431100 431201 431202 431203 431204 432101 432102 432103 432104 432201 432202 432203 432204 432205 432206 432207 432901 432902 432903 432904 432905 432906 433001 433002 433003 433004 433005 433006 439001 439002 439003 439004 439005 439006 439007 439008 451001 451002 451003 451004 452001 452002 452003 452004 452005 452006 452007 452008 452009 452010 452011 452012 452013 452014 452015 452016 452017 452018 452019 453001 453002 453003 453004 453005 453006 453007 454001 454002 461001 461002 461003 461004 461006 461007 462001 462002 462003 462004 462005 462006 462007 463001 463002 463003 463004 463005 463006 463007 463008 463009 463010 464101 464102 464103 464104 464105 464106 464107 464901 464902 464903 464904 464905 464906 464907 464908 464909 464910 464911 465101 465102 465201 465202 465203 465204 465205 465300 465901 465902 465903 465904 465905 465906 465907 466101 466102 466103 466104 466105 466106 466108 466201 466202 466203 466301 466302 466303 466304 466305 466306 466307 466308 466309 466310 466311 466901 466902 466903 466904 466905 466906 466907 466908 469001 469002 469003 469004 471101 471102 471103 471104 471105 471106 471901 472101 472102 472103 472104 472105 472106 472107 472108 472109 472110 472201 472202 472203 472300 473001 473002 473003 473004 473005 473006 474101 474102 474103 474104 474105 474106 474107 474108 474109 474201 474202 475101 475102 475201 475202 475203 475204 475205 475206 475207 475208 475209 475210 475211 475301 475302 475303 475901 475902 475903 475904 475905 475906 475907 475908 476101 476102 476103 476104 476200 476301 476302 476303 476304 476305 476306 476307 476308 476400 477101 477102 477103 477104 477105 477106 477107 477201 477202 477203 477204 477206 477207 477301 477302 477303 477304 477305 477306 477307 477308 477309 477310 477311 477312 477313 477314 477315 477316 477317 477318 477319 477321 477322 477323 477324 477325 477326 477327 477328 477329 477330 477331 477332 477333 477334 477335 477336 477337 477338 477339 477340 477341 477342 477343 477344 477345 477346 477347 477348 477349 477350 477351 477352 477353 477354 477355 477356 477357 477358 477359 477360 477361 477362 477363 477364 477365 477401 477402 477403 478100 478200 478901 479101 479102 479901 479902 491100 491200 492100 492201 492202 492203 492204 492205 492206 492207 492208 492209 492210 492211 492301 492302 492303 492304 492305 492306 492307 492308 492309 493001 493002 '"/>
            <let name="isic5" value="' 501100 501201 501202 502101 502102 502200 511001 511002 512000 521001 521002 521003 521004 521005 522101 522102 522103 522104 522105 522106 522107 522108 522201 522202 522203 522204 522205 522206 522207 522208 522209 522210 522211 522212 522213 522214 522215 522216 522217 522301 522302 522401 522402 522403 522901 522902 522903 522904 522907 531000 532001 532003 551001 551002 551003 551004 551005 551006 551007 551008 552001 559001 561001 561002 561003 561004 561005 561006 561007 561008 561009 562101 562102 562901 562902 563001 563002 563003 563004 581101 581102 581103 581201 581202 581301 581302 581303 581304 581901 581902 581903 581904 581905 581906 582001 582002 591101 591102 591201 591202 591300 591400 592001 592002 592003 592004 '"/>
            <let name="isic6" value="' 601001 601002 602001 602002 611001 612001 612002 613001 619001 619003 619004 620101 620102 620103 620104 620105 620106 620201 620202 620203 620204 620205 620206 620207 620208 620209 620900 620901 620902 631101 631102 631103 631104 631105 631200 639100 641901 641902 641903 641904 642000 643001 643002 643003 643004 649201 649202 649203 649204 649901 651101 651102 651200 651201 651202 651203 651204 651205 651206 651207 651208 651209 651210 651211 651212 651213 652001 652002 661101 661102 661201 661202 661203 661204 661205 661901 661902 661903 661904 661905 661906 661907 662101 662102 662103 662201 662202 662901 662902 662903 663002 663003 663004 663005 681001 681002 681003 681004 682001 682002 682003 691001 691003 691004 692001 692002 692003 '"/>
            <let name="isic7" value="' 701001 701002 702001 702002 711001 711002 711003 711004 711005 711006 711007 711008 711009 711010 711011 711012 712001 712002 712003 712004 712006 712007 712008 712009 712010 721001 721002 721003 722001 722002 731001 731002 731003 732000 741001 741002 741003 741004 741005 741006 742001 742002 742003 742004 749003 749004 749005 749006 749007 749008 749009 749010 749011 749012 749013 749014 749015 749016 749017 749018 749019 749020 749021 749022 749023 749024 749025 749026 749027 749028 749029 749030 749031 749032 749033 749034 749035 749036 749037 749038 749039 749040 749041 749042 749043 749044 749045 749046 749047 749048 749049 749050 749051 749052 749053 749054 749055 749056 750001 750002 750003 750004 750005 771001 771002 772101 772102 772103 772104 772105 772106 772107 772200 772901 772902 772903 772904 773001 773002 773003 773004 773005 773006 773007 773008 773009 773010 773011 773012 773013 773014 773015 781001 781002 781003 782002 783000 791100 791101 791200 799002 799003 799004 799005 799006 '"/>
            <let name="isic8" value="' 802001 802002 811000 812100 812901 812902 812903 812904 813001 821101 821102 821901 821902 822000 823001 823002 823003 829101 829102 829201 829202 829203 829204 829205 829901 829902 829903 829904 829905 829906 829907 829908 841101 841102 841200 841301 841302 841303 841304 841305 841306 841307 841308 842300 842301 851001 851002 851003 851004 851005 852100 852201 852202 853001 853002 853003 853004 854101 854102 854103 854104 854201 854203 854901 854902 854903 854904 854905 854907 854909 854910 854911 855001 855002 855003 855004 855006 861001 861002 862001 862002 862003 862004 869001 869002 869003 869004 869005 869006 869007 869008 871000 872001 872002 873002 889002 889003 889004 '"/>
            <let name="isic9" value="' 900001 900002 900003 900005 900006 910201 910202 910203 910301 910303 910304 931101 931102 931201 931202 931203 931901 932100 932901 932902 932903 932904 932905 932906 932907 941201 941202 942000 949101 951100 951200 951201 952101 952102 952103 952201 952300 952401 952402 952901 952902 952903 952904 960101 960102 960103 960104 960201 960202 960203 960204 960301 960901 960902 960903 960904 '"/>
            
            <assert diagnostics="d-CL-08-OM-ISIC" id="CL-08-OM-ISIC" flag="fatal" role="fatal" test="if (string-length($isicCode) = 0) then true()                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '0') then contains($isic0, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '1') then contains($isic1, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '2') then contains($isic2, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '3') then contains($isic3, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '4') then contains($isic4, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '5') then contains($isic5, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '6') then contains($isic6, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '7') then contains($isic7, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '8') then contains($isic8, concat(' ', $isicCode, ' '))                         else if (string-length($isicCode) = 6 and substring($isicCode, 1, 1) = '9') then contains($isic9, concat(' ', $isicCode, ' '))                         else false()">[CL-08-OM-ISIC] - Industrial Classification Code (BTOM-033) must be provided from the International Standard Industrial Classification of All Economic Activities list published by the Omani Ministry of Commerce, Industry and Investment Promotion.</assert>
        </rule>
        
        <rule flag="fatal" role="fatal" context="cac:Delivery/cac:DeliveryTerms/cbc:ID">
            
            <assert diagnostics="d-CL-09-OM" id="CL-09-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' EXW FCA CPT CIP DAP DPU DDP FAS FOB CFR CIF ', concat(' ', normalize-space(.), ' '))))">[CL-09-OM] - Incoterms (BTOM-022) MUST be coded using codelist Incoterms Codelist.</assert>
        </rule>
        
        <rule context="cac:AdditionalItemProperty/cbc:NameCode">
            
            <assert diagnostics="d-CL-11-OM" id="CL-11-OM" flag="fatal" role="fatal" test="                 (not($isProfitMargin or $isProfitMarginSelf))                 or                 (                     normalize-space(.) != ''                     and not(contains(normalize-space(.), ' '))                     and contains(                         ' VATPM-OM-01 VATPM-OM-02 VATPM-OM-03 VATPM-OM-04 VATPM-OM-05 ',                         concat(' ', normalize-space(.), ' ')                     )                 )                 ">[CL-11-OM] - If invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice' (XXXXXXXXXX1XXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Profit margin item reason code (BTOM-025) MUST be present and coded using Profit Margin Items Codelist (CL-11-OM).</assert>
        </rule>
        
        <rule flag="fatal" role="fatal" context="cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID[@schemeName='MP']">
            
            <assert diagnostics="d-CL-12-OM" id="CL-12-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' 64000000 70000000 71000000 72000000 73000000 76000000 77000000 78000000 80000000 81000000 82000000 83000000 84000000 85000000 86000000 90000000 91000000 92000000 93000000 94000000 00000000 ', concat(' ', normalize-space(.), ' '))))">[CL-12-OM] - Service Type classification code must be coded with the service type codelist.</assert>
        </rule>
        
        <rule flag="fatal" role="fatal" context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode | cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode">
            
            <assert diagnostics="d-CL-13-OM" id="CL-13-OM" flag="fatal" role="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' SHRFZ SEZAD SLLFZ AFZ MO OTH ', concat(' ', normalize-space(.), ' '))))">[CL-13-OM] - Buyer/Supplier country subentity code must be coded using the subdivision code list.</assert>
        </rule>
  </pattern>

    
    
    
    
    

    <diagnostics>

        <diagnostic id="d-CL-08-OM-HS">
            The supplied value '<value-of select="$hsCode"/>' is not a valid item classification code under codelist CL-08-OM-HS.
            Expected: a 12-digit Oman HS code from the official Oman HS Codes codelist (e.g. '010121100001').
            Empty values are permitted; cardinality is enforced separately.
            ISIC (6-digit) codes are no longer accepted on this path - move them to
            cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC']
            (validated by CL-08-OM-ISIC).
        </diagnostic>

        <diagnostic id="d-CL-08-OM-ISIC">
            The supplied value '<value-of select="$isicCode"/>' is not a valid item classification code under codelist CL-08-OM-ISIC.
            Expected: a 6-digit ISIC code from the ISIC business activity codelist (e.g. '011101').
            Empty values are permitted; cardinality is enforced separately by IBR-081-OM.
            HS codes belong at
            cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']
            (validated by CL-08-OM).
        </diagnostic>

        <diagnostic id="d-IBR-DEC-02-OM">
            Shared document totals decimal precision validation (BG-22)

            Found:
            - Element: '<value-of select="name()"/>'
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Shared section document totals MUST NOT contain more than 2 decimal places.
            Covered fields: IBT-106 Sum of Invoice line net amount, IBT-109 Invoice total
            amount without VAT, IBT-110 Invoice total TAX amount, IBT-112 Invoice total
            amount with VAT, IBT-113 Paid amount, IBT-114 Rounding amount, IBT-115 Amount
            due for payment.

            Examples of valid values:
            - 100
            - 100.1
            - 100.12

            Invalid examples:
            - 100.123
            - 100.1234

            Action:
            Round the value to a maximum of 2 fractional digits.
        </diagnostic>

        <diagnostic id="d-IBR-DEC-03-OM">
            Amount decimal precision validation (BTOM-Amount)

            Found:
            - Element: '<value-of select="name()"/>'
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Amount (except Shared) must contain no more than 3 decimal places.
            the Exchange rate is validated by IBR-DEC-07-OM at 7 decimals.)

            Examples of valid values:
            - 100
            - 100.1
            - 100.12
            - 100.123

            Invalid examples:
            - 100.1234
            - 10.56789

            Action:
            Reduce the number of fractional digits to a maximum of 3.
        </diagnostic>

        <diagnostic id="d-IBR-DEC-07-OM">
            Currency Exchange Rate decimal precision validation (BTOM-003)

            Found:
            - Element: '<value-of select="name()"/>'
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            The currency exchange rate MUST NOT contain more than 7 decimal places.

            Examples of valid values:
            - 1
            - 0.385
            - 0.3850000
            - 1.2345678

            Invalid examples:
            - 1.23456789
            - 0.38500001234

            Action:
            Round the exchange rate to a maximum of 7 fractional digits.
        </diagnostic>
        <diagnostic id="d-CL-02-OM">
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

        <diagnostic id="d-CL-03-OM">
            Invoice transaction type (BTOM-001) logic error.

            Found: '<value-of select="normalize-space(@name)"/>'

            Requirements:
            - Position 1 (Full Tax) and Position 2 (Simplified) cannot both be '1'.
            - One of the first two positions MUST be '1'.
            - Combinations are allowed (e.g., Full Tax + Export + Continuous).
        </diagnostic>

        <diagnostic id="d-CL-04-OM">
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

        <diagnostic id="d-CL-05-OM">
            VAT exemption reason code (IBT-121 / IBT-186 / IBT-196 / IBT-198)

            Found:
            - VAT category code (parent): '<value-of select="normalize-space(../cbc:ID)"/>'
            - Exemption reason code value: '<value-of select="normalize-space(.)"/>'

            Expected (when VAT category code is 'E' - Exempt):
            Code must be one of the Exemption codelist values:

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
            Provide a valid VATEX-OM-* exemption reason code, or change the
            VAT category code if the supply is not actually exempt.
        </diagnostic>

        <diagnostic id="d-CL-10-OM">
            VAT zero-rating reason code (IBT-121 / IBT-186 / IBT-196 / IBT-198)

            Found:
            - VAT category code (parent): '<value-of select="normalize-space(../cbc:ID)"/>'
            - Zero-rating reason code value: '<value-of select="normalize-space(.)"/>'

            Expected (when VAT category code is 'Z' - Zero rated):
            Code must be one of the Zero rating codelist values:

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

            Action:
            Provide a valid VATZR-OM-* zero-rating reason code, or change the
            VAT category code if the supply is not actually zero rated.
        </diagnostic>

        <diagnostic id="d-CL-06-OM">
            Buyer/Seller identifier scheme (IBT-029-1 / IBT-046-1)

            Found:
            - Value: '<value-of select="normalize-space(@schemeName)"/>'

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

        <diagnostic id="d-CL-07-OM">
            Goods or Services identification (BTOM-019)

            Found:
            - Value: '<value-of select="normalize-space(.)"/>'

            Expected:
            Code must be one of the following:

            - G  (Goods)
            - S  (Services)

            Action:
            Use a valid item type code.
        </diagnostic>

        <diagnostic id="d-CL-09-OM">
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

        <diagnostic id="d-CL-11-OM">
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

        <diagnostic id="d-CL-12-OM">
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
            - 00000000

            Action:
            Use a valid service classification code.
        </diagnostic>

        <diagnostic id="d-CL-13-OM">
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
            - OTH

            Action:
            Use a valid subdivision code.
        </diagnostic>
        <diagnostic id="d-000">
            Transaction type (BTOM-001)

            Found:
            '<value-of select="$txnType"/>'

            Expected:
            A 20-character bitmap of '1' and '0' with at least one '1'
            marking an active transaction type. More than one '1' is allowed
            when several transaction types apply concurrently (subject to
            the mutual-exclusion rules IBR-138..149, IBR-176).

            Action:
            Provide a valid transaction type code.
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
            'urn:peppol:bis:billing'

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

        <diagnostic id="d-058">
            [ALIGNED-IBRP-058]
            Found:    BaseAmount=<value-of select="cbc:BaseAmount"/>,
                    Multiplier=<value-of select="cbc:MultiplierFactorNumeric"/>.
            Expected: Both Charge base amount (IBT-100) AND percentage (IBT-101) must be present, OR neither.
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
            A 20-character string containing only '1' and '0'.

            Action:
            Provide a valid 20-character transaction type using '1' and '0' only.
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
            VAT identifier (IBT-031 / IBT-048 / BTOM-006)

            Found:
            '<value-of select="."/>'

            Expected:
            12 characters: 'OM' followed by exactly 10 digits (regex ^OM[0-9]{10}$).

            Action:
            Provide a valid VAT identifier (e.g., OM1234567890).
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

        <diagnostic id="d-IBR-056">
            Context: Item classification scheme must conform to the required product classification standard.

            Found: Item classification scheme(s) = '<value-of select="string-join(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID, ', ')"/>'.

            Expected: Item classification scheme identifier (IBT-158-1) must be 'HS' (Harmonized System / goods, CL-08-OM) or 'MP' (Service Type, CL-12-OM).

            Action: Update the item classification scheme to 'HS' or 'MP', or ensure correct mapping from product master data. Note: ISIC codes (BTOM-018) now live under cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC'] - they do NOT use cbc:ItemClassificationCode any more.
        </diagnostic>

        <diagnostic id="d-IBR-057">
            [IBR-057-OM]
            Context: line-level invoicing period must fall within a single calendar month.
            Found:    Start=<value-of select="cac:InvoicePeriod/cbc:StartDate"/>,
                    End=<value-of select="cac:InvoicePeriod/cbc:EndDate"/>
            Action:   Adjust the line-level invoicing period so start and end share the same YYYY-MM.
        </diagnostic>

        <diagnostic id="d-IBR-058">
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
            (Quantity * (Price / Base quantity)) + Charges - Allowances,
            within an allowed tolerance of 0.01.

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

            Found: Item type is missing or not provided at invoice line level
                (cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode).

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'

            Expected: Item type ('G' = Goods, 'S' = Service) must be provided for standard invoice types unless the document is explicitly classified as a simplified invoice under applicable billing rules.

            Action: Populate the item type at
                cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode
            or verify that the invoice qualifies as a simplified invoice where item-level classification is not required.
        </diagnostic>

        <diagnostic id="d-IBR-079">
            Missing HS classification code for goods.

            Found:
            - Goods or Services identification: '<value-of select="cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode"/>'.
            - HS ClassificationCode: '<value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']"/>'.

            Expected: Goods items (Goods or Services identification 'G') must include a valid HS classification code (IBT-158, @listID='HS').

            Fix: Provide the appropriate HS classification code for the goods item at
                cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS'].
        </diagnostic>

        <diagnostic id="d-IBR-080">
            Context: HS classification code must comply with the Oman HS code structural requirement.

            Found: HS code length = '<value-of select="string-length(normalize-space(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']))"/>'
            Value: '<value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']"/>'

            Expected: Classification code with @listID='HS' must be exactly 12 digits (the Oman HS code length). 6-digit ISIC codes go under cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC'] (CL-08-OM-ISIC); 8-digit service-type codes use @listID='MP' (CL-12-OM).

            Action: Provide a 12-digit Oman HS code or correct the mapping from the product master data source.
        </diagnostic>

        <diagnostic id="d-IBR-081">
            Context: Industrial classification code (ISIC) is required for item-level product classification.

            Found: Missing industrial classification code at
                cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC'].
            Existing CC entries (if any): '<value-of select="string-join(cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC'], ', ')"/>'

            Expected: Industrial classification code must be provided where applicable according to product classification rules.

            Action: Populate the ISIC code at
                cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeName='CC']
            or verify whether the item is exempt from classification requirements (simplified, import of goods, import of services RCM, or Profit-Margin Self-Invoice).
        </diagnostic>

        <diagnostic id="d-IBR-082">
            Context: Profit-margin Total Amount Due (BTOM-020) integrity check.

            Found:
            - Reported Total Amount Due (BTOM-020):  '<value-of select="cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription"/>'
            - Calculated Σ line totals including VAT (BTOM-017): '<value-of select="sum((cac:InvoiceLine | cac:CreditNoteLine)/cac:ItemPriceExtension/cbc:Amount/xs:decimal(.))"/>'
            - Difference (Calculated - Reported):    '<value-of select="xs:decimal(sum((cac:InvoiceLine | cac:CreditNoteLine)/cac:ItemPriceExtension/cbc:Amount/xs:decimal(.)) - xs:decimal(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription))"/>'

            Expected: Total Amount Due (BTOM-020) must equal the sum of Total amount including VAT (BTOM-017) over all invoice lines, within ±0.01.

            Action: Recalculate the Profit-Margin Total Amount Due value or correct the line totals so the two agree.
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
            Invalid HS item classification code for profit margin invoice.

            Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
            HS classification codes (IBT-158, @listID='HS'): '<value-of select="string-join(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS'], ', ')"/>'

            Expected: For profit margin transactions, the HS classification code must NOT start with any of the following prefixes:
            '7101', '7102', '7103', '7104', '01', '06'.

            Fix: Update the HS classification code so that it does not begin with a prohibited prefix for profit margin invoices.
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

            Found: Service type (MP) is missing or not provided at
                cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID[@schemeName='MP']
            on any invoice line. Existing service-type entries detected on this document:
            '<value-of select="string-join($lines/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID[@schemeName='MP'], ', ')"/>'

            Expected: Service type must be provided for export of services using a valid code from code list CL-12-OM (@schemeName='MP').

            Action: Populate a valid service type code from CL-12-OM at
                cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID[@schemeName='MP']
            or verify correct classification of the exported service.
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

        <diagnostic id="d-IBR-171-A">
            Date format error on a payment / installment date.

            Found:
            - Element: '<value-of select="name()"/>'
            - Value:   '<value-of select="."/>'

            Expected:
            Dates carried in cbc:ReceivedDate (IBT-177), cbc:InstallmentDueDate
            (IBT-181) and the payment-due-date family (IBT-009) MUST be
            formatted YYYY-MM-DD and represent a valid calendar date.

            Fix:
            Reformat the value to a 10-character ISO-8601 date.
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

            Found:
            - Goods or Services identification (BTOM-019): '<value-of select="cac:Item/cac:ItemSpecificationDocumentReference[cbc:ID/@schemeName='MP']/cbc:DocumentTypeCode"/>'
            - HS code (IBT-158, @listID='HS'): '<value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']"/>'

            Expected: When Goods or Services identification is 'G' (Goods), the item classification identifier must be a valid Harmonized System (HS) code as required under Royal Oman Police customs classification rules.

            Action: Provide a valid HS classification code (at cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='HS']) compliant with the Royal Oman Police customs tariff structure or correct the product mapping in the item master data.
        </diagnostic>

        <diagnostic id="d-IBR-175">
            Missing or incomplete preceding invoice reference for profit margin invoice.

            Found:
            - Transaction type (BTOM-001): '<value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>'
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

        
        
        

        <diagnostic id="d-BTOM-PRE-001">
            Why this rule exists:
            Schematron rules only fire when the document root is a UBL Invoice or
            CreditNote. If a different root element is supplied the schematron
            silently produces no asserts, which would let an invalid file pass.

            Found:
            - Root local-name: '<value-of select="local-name(*[1])"/>'
            - Namespace:        '<value-of select="namespace-uri(*[1])"/>'

            Expected:
            Root element 'Invoice' (urn:oasis:names:specification:ubl:schema:xsd:Invoice-2)
            or 'CreditNote' (urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2).

            Action:
            Verify the document is a UBL 2.1 Invoice or CreditNote and that the
            namespace prefix bindings have not been altered.
        </diagnostic>

        <diagnostic id="d-BTOM-META-001">
            Informational diagnostic. Identifies the version of the PINT-OM
            ruleset that produced the SVRL. Not a failure.
        </diagnostic>

        
    </diagnostics>
</schema>