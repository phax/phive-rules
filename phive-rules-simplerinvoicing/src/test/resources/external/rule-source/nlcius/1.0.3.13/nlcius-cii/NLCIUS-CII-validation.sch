<!--
    These are the NLCIUS-specific validation rules for UN/CEFACT CII D16B documents

    Authors:
    - Wouter van den Berg (TNO)
    - Robin de Veer (TNO)
    
    Additional changes written by
    - Jelte Jansen (Simplerinvoicing) 
    
    Changelog: see Changelog file in repository root

    Licensed under the European Union Public License (EUPL) version 1.2
-->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="false" id="nlcius">  
    <!-- A few definitions to make later statements more readable -->
    <!-- These rules are generally only for NLCIUS --> 
    <let name="specificationID" value="normalize-space(//ram:GuidelineSpecifiedDocumentContextParameter/ram:ID)" />
    <let name="is_NLCIUS" value="$specificationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0'" />
    <let name="is_NLCIUS-ext-gaccount" value="$specificationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0#conformant#urn:fdc:nen.nl:gaccount:v1.0'" />
    <!-- A number of rules only apply when the supplier is in the Netherlands -->
    <let name="supplierCountry" value="if (//ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID) then upper-case(normalize-space(//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID)) else 'XX'" />
    <let name="supplierIsNL" value="$supplierCountry = 'NL'" />
    <!--    We generally divide these rules into two cases, depending on
            whether the supplier is from the Netherlands.
            Since all rules fall under one of these two, we make two general
            context shortcuts:
            1. '$si' for any supplier
            2. '$s' for suppliers in the netherlands
    -->
    <let name="si" value="($is_NLCIUS or $is_NLCIUS-ext-gaccount)" />
    <let name="s" value="$supplierIsNL and ($is_NLCIUS or $is_NLCIUS-ext-gaccount)" />
    
    <rule context="ram:SellerTradeParty/ram:SpecifiedLegalOrganization[$s]" id="BR-NL-1">
        <assert id="BR-NL-1" test="(contains(concat(' ', string-join(ram:ID/@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(ram:ID/@schemeID, ' '), ' '), ' 0190 ')) and (ram:ID/normalize-space(.) != '')" flag="fatal">[BR-NL-1] For suppliers in the Netherlands the supplier MUST provide either a KVK or OIN number for its legal entity identifier (ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID with schemeID 0106 or 0190)</assert>
    </rule>
    <rule context="ram:ApplicableHeaderTradeAgreement[$s]" id="BR-NL-2">
        <assert id="BR-NL-2" test="(ram:BuyerReference) or (ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID)" flag="fatal">[BR-NL-2] For suppliers in the Netherlands, the invoice MUST contain either the buyer reference (ram:BuyerReference) or the order reference (ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID)</assert>
    </rule>

    <rule context="ram:SellerTradeParty/ram:PostalTradeAddress[$s]" id="BR-NL-3">
        <assert id="BR-NL-3" test="ram:LineOne and ram:CityName and ram:PostcodeCode" flag="fatal">[BR-NL-3] For suppliers in the Netherlands the supplier's address (ram:SellerTradeParty/PostalTradeAddres) MUST contain street name (ram:LineOne), city (ram:CityName) and postal zone (ram:PostcodeCode)</assert>
    </rule>

    <rule context="ram:BuyerTradeParty/ram:PostalTradeAddress[$s]" id="BR-NL-4">
        <assert id="BR-NL-4" test="ram:CountryID != 'NL' or (
        ram:LineOne and
        ram:CityName and
        ram:PostcodeCode)" flag="fatal">[BR-NL-4] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer address (ram:BuyerTradeParty/PostalTradeAddres) MUST contain street name (ram:LineOne), city (ram:CityName) and postal zone (ram:PostcodeCode)</assert>
        </rule>

    <rule context="ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress[$s]" id="BR-NL-5">
        <assert id="BR-NL-5" test="ram:CountryID != 'NL'  or (
        ram:LineOne and
        ram:CityName and
        ram:PostcodeCode)" flag="fatal">[BR-NL-5] For suppliers in the Netherlands, if the fiscal representative is in the Netherlands, the representative's address (ram:SellerTaxRepresentativeTradeParty) MUST contain street name (ram:LineOne), city (ram:CityName) and postal zone </assert>
    </rule>

    <!-- BR-NL-6 is not specified in NLCIUS -->

    <rule context="/*/rsm:ExchangedDocument/ram:TypeCode[$si]" id="BR-NL-7">
        <assert id="BR-NL-7" test=". = 380 or
                        . = 381 or
                        . = 384 or
                        . = 389" flag="fatal">[BR-NL-7] The invoice type code (ram:TypeCode) MUST have one of the following values: 380, 381, 384, 389</assert>
    </rule>

    <!-- BR-NL-8 is excluded here since this NLCIUS rule is only applicable to the UBL syntax binding and not to the UN/CEFACT syntax binding. Reason: the former has two mappings (one to UBL invoice, another to UBL Credit Note) whereas the latter has one (invoice ony, no credit note). -->
    
    <rule context="/*/rsm:ExchangedDocument/ram:TypeCode[$si]" id="BR-NL-9">  
        <assert id="BR-NL-9" test="not($s) or
        (. != 384) or 
        ../rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" flag="fatal">[BR-NL-9] For suppliers in the Netherlands, if the document is a corrective invoice (rsm:ExchangedDocument/ram:TypeCode = 384), the document MUST contain an invoice reference (/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID)</assert>
    </rule>

    <rule context="ram:BuyerTradeParty[$s]" id="BR-NL-10">
        <assert id="BR-NL-10" test="
            (not(ram:PostalTradeAddress/ram:CountryID = 'NL')
            or
            contains(concat(' ', string-join(ram:SpecifiedLegalOrganization/ram:ID/@schemeID, ' '), ' '), ' 0106 ')
            or
            contains(concat(' ', string-join(ram:SpecifiedLegalOrganization/ram:ID/@schemeID, ' '), ' '), ' 0190 ')
            ) and 
            (ram:SpecifiedLegalOrganization/ram:ID/normalize-space(.) != '')" 
            flag="fatal">[BR-NL-10] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer's legal entity identifier (/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID) MUST be either a KVK (schemeID=0106) or OIN number (schemeID=0190)</assert>
    </rule>

    <rule context="ram:SpecifiedTradeSettlementHeaderMonetarySummation[$s]" id="BR-NL-11">
        <assert id="BR-NL-11" test="xs:decimal(./ram:DuePayableAmount) &lt;= 0.0 or (/*/rsm:ExchangedDocument/ram:TypeCode[$si] = 381) or (../ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode)" flag="fatal">[BR-NL-11] For suppliers in the Netherlands, the supplier MUST provide a means of payment (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans) if the payment is from customer to supplier</assert>
    </rule>

    <rule context="ram:SpecifiedTradeSettlementPaymentMeans[$s]" id="BR-NL-12">
        <assert id="BR-NL-12" test="ram:TypeCode = 30 or
        ram:TypeCode = 48 or
        ram:TypeCode = 49 or
        ram:TypeCode = 57 or
        ram:TypeCode = 58 or
        ram:TypeCode = 59" flag="fatal">[BR-NL-12] For suppliers in the Netherlands, the payment means code (ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode) MUST be one of 30, 48, 49, 57, 58 or 59</assert>
    </rule>

    <rule context="ram:SpecifiedTradeSettlementPaymentMeans[$s]" id="BR-NL-31">
        <assert id="BR-NL-31" test="not((ram:TypeCode = 58 or ram:TypeCode = 59)) or not(ram:PayerSpecifiedDebtorFinancialInstitution/ram:BICID or ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID)" flag="warning">[BR-NL-31] The use of a payment service provider identifier (ram:PayerSpecifiedDebtorFinancialInstitution/ram:BICID or ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID) is not recommended for SEPA payments (ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode = 58 or 59)</assert>
    </rule>

    <rule context="ram:BuyerOrderReferencedDocument/ram:LineID[$si]" id="BR-NL-13">
        <assert id="BR-NL-13" test="exists(//ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID)" flag="fatal">[BR-NL-13] If an order line reference (BT-132) is used, there must be an order reference on the document level (BT-13)</assert>
    </rule>

    <rule context="ram:TaxCurrencyCode[$s]" id="BR-NL-19">
        <assert id="BR-NL-19" test="false" flag="warning">[BR-NL-19] The use of a tax currency code (/*/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) is not recommended</assert>
    </rule>

    <rule context="ram:TaxPointDate/udt:DateString[$s]" id="BR-NL-20">
        <assert id="BR-NL-20" test="false" flag="warning">[BR-NL-20] The use of a tax point date (/*/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString) is not recommended, and its value will be ignored</assert>
    </rule>

    <rule context="ram:DueDateTypeCode[$s]" id="BR-NL-21">
        <assert id="BR-NL-21" test="false" flag="warning">[BR-NL-21] The use of a tax point date code (/*/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode) is not recommended, and its value will be ignored</assert>
    </rule>

    <rule context="ram:SubjectCode[$s]" id="BR-NL-22">
        <assert id="BR-NL-22" test="false" flag="warning">[BR-NL-22] The use of an invoice note subject code (/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode) is not recommended. If deemed necessary the code shall be agreed upon with the receiving party.</assert>
    </rule>

    <rule context="ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[$s]" id="BR-NL-23">
        <assert id="BR-NL-23" test="false" flag="warning">[BR-NL-23] The use of an invoice note subject code (/*/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID) is not recommended, unless desired by a particular network (such as PEPPOL)</assert>
    </rule>

    <rule context="ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString[$s]" id="BR-NL-24">
        <assert id="BR-NL-24" test="false" flag="warning">[BR-NL-24] The use of a preceding invoice issue date (/*/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString) is not recommended</assert>
    </rule>

    <rule context="ram:SellerTradeParty/ram:SpecifiedTaxRegistration[$s]" id="BR-NL-25">
        <assert id="BR-NL-25" test="not(ram:ID) or ram:ID/@schemeID = 'VA'" flag="warning">[BR-NL-25] The use of a seller tax registration identifier (/*/*/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID) is not recommended when the tax scheme is not VAT (VA), since this is not applicable to suppliers in the Netherlands</assert>
    </rule>

    <rule context="ram:SellerTradeParty/ram:Description[$s]" id="BR-NL-26">
        <assert id="BR-NL-26" test="false" flag="warning">[BR-NL-26] The use of the seller additional legal information field (/*/*/am:SellerTradeParty/ram:Description) is not recommended, since this is not applicable for suppliers in the Netherlands</assert>
    </rule>

    <rule context="ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineThree[$s]" id="BR-NL-27-1">
        <assert id="BR-NL-27-1" test="false" flag="warning">[BR-NL-27] The use of the seller address line 3 (/*/*/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineThree) is not recommended, but allowed</assert>
    </rule>
    <rule context="ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineThree[$s]" id="BR-NL-27-2">
        <assert id="BR-NL-27-2" test="false" flag="warning">[BR-NL-27] The use of the customer address line 3 (/*/*/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineThree) is not recommended, but allowed</assert>
    </rule>
    <rule context="ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineThree[$s]" id="BR-NL-27-3">
        <assert id="BR-NL-27-3" test="false" flag="warning">[BR-NL-27] The use of the tax representative address line 3 (/*/*/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineThree) is not recommended, but allowed</assert>
    </rule>
    <rule context="ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineThree[$s]" id="BR-NL-27-4">
        <assert id="BR-NL-27-4" test="false" flag="warning">[BR-NL-27] The use of the delivery address line 3 (/*/*/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineThree) is not recommended, but allowed</assert>
    </rule>

    <rule context="ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[$s]" id="BR-NL-28-1">
        <assert id="BR-NL-28-1" test="false" flag="warning">[BR-NL-28] The use of a country subdivision (/*/*/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName) is not recommended, but allowed</assert>
    </rule>
    <rule context="ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[$s]" id="BR-NL-28-2">
        <assert id="BR-NL-28-2" test="false" flag="warning">[BR-NL-28] The use of a country subdivision (/*/*/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName) is not recommended, but allowed</assert>
    </rule>
    <rule context="ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[$s]" id="BR-NL-28-3">
        <assert id="BR-NL-28-3" test="false" flag="warning">[BR-NL-28] The use of a country subdivision (/*/*/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName) is not recommended, but allowed</assert>
    </rule>
    <rule context="ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[$s]" id="BR-NL-28-4">
        <assert id="BR-NL-28-4" test="false" flag="warning">[BR-NL-28] The use of a country subdivision (/*/*/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName) is not recommended, but allowed</assert>
    </rule>

    <rule context="ram:SpecifiedTradeSettlementPaymentMeans/ram:Information[$s]" id="BR-NL-29">
        <assert id="BR-NL-29" test="false" flag="warning">[BR-NL-29] The use of a payment means text (/*/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:Information) is not recommended</assert>
    </rule>

    <rule context="ram:PayeePartyCreditorFinancialAccount/ram:AccountName[$s]" id="BR-NL-30">
        <assert id="BR-NL-30" test="false" flag="warning">[BR-NL-30] The use of a payment account name (/*/*/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:AccountName) is not recommended</assert>
    </rule>

    <rule context="ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode[$s]" id="BR-NL-32-and-34">
        <assert id="BR-NL-32-and-34" test="false" flag="warning">[BR-NL-32] / [BR-NL-34] The use of an allowance reason code or charge reason code (ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode) are not recommended, both on document level and on line level.</assert>
    </rule>

    <rule context="ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[$s]" id="BR-NL-33">
        <assert id="BR-NL-33" test="@currencyID = ../../ram:InvoiceCurrencyCode" flag="warning">[BR-NL-33] The use of a tax total in accounting currency (ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount@currencyID different than InvoiceCurrencyCode) is not recommended</assert>
    </rule>

    <rule context="ram:ApplicableTradeTax/ram:ExemptionReasonCode[$s]" id="BR-NL-35">
        <assert id="BR-NL-35" test="false" flag="warning">[BR-NL-35] The use of a tax exemption reason code (/*/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) is not recommended</assert>
    </rule>



    <rule context="//*[not(*) and not(normalize-space())]" id="empty-element-check">
        <assert id="empty-element-check" test="false()" flag="warning">Document should not contain empty elements.</assert>
    </rule>

</pattern>
