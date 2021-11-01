<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
        
        <let name="CatalogueValidityStart" value="if(exists(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate)) then number(translate(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate,'-','')) else 0"/>
        <let name="CatalogueValidityEnd" value="if(exists(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) then number(translate(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate,'-','')) else 99999999"/>



    <rule context="cbc:ProfileID">
        <assert id="PEPPOL-T19-R017"
            test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:catalogue_only:3 urn:fdc:peppol.eu:poacc:bis:catalogue_wo_response:3', '\s') satisfies $p = normalize-space(.)"
            flag="fatal">An order transaction SHALL use profile catalogue only or catalogue without response.</assert>
    </rule>

	<rule context="cbc:CustomizationID">
			<assert id="PEPPOL-T19-R018" 
					test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:catalogue:3')"
					flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:catalogue:3'.</assert>
	</rule>    
    
    <rule context="/ubl:Catalogue/cac:ValidityPeriod">
        <assert id="PEPPOL-T19-R001"
                test="$CatalogueValidityEnd &gt;= $CatalogueValidityStart"
                flag="fatal">A validity period end date SHALL be later or equal to a validity period start date</assert>
    </rule>

    <rule context="cac:SellerSupplierParty">
        <assert id="PEPPOL-T19-R004"
                test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue supplier SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:ContractorCustomerParty">
        <assert id="PEPPOL-T19-R005"
                test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue customer SHALL contain the full name or an identifier</assert>
    </rule>

	
    <rule context="cac:CatalogueLine">
        
        <let name="CatalogueLineValidityStart" value="if(exists(cac:LineValidityPeriod/cbc:StartDate)) then number(translate(cac:LineValidityPeriod/cbc:StartDate,'-','')) else $CatalogueValidityStart"/>
        <let name="CatalogueLineValidityEnd" value="if(exists(cac:LineValidityPeriod/cbc:EndDate)) then number(translate(cac:LineValidityPeriod/cbc:EndDate,'-','')) else $CatalogueValidityEnd"/>
        
        <assert id="PEPPOL-T19-R008"
                test="not(cbc:MaximumOrderQuantity) or number(cbc:MaximumOrderQuantity) &gt;= 0"
                flag="fatal">Maximum quantity SHALL be greater than zero</assert>

        <assert id="PEPPOL-T19-R009"
                test="not(cbc:MinimumOrderQuantity) or number(cbc:MinimumOrderQuantity) &gt;= 0"
                flag="fatal">Minimum quantity SHALL be greater than zero</assert>

        <assert id="PEPPOL-T19-R010"
                test="not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity) or number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity)"
                flag="fatal">Maximum quantity SHALL be greater or equal to the Minimum quantity</assert>
               
        <assert id="PEPPOL-T19-R007"
            test="($CatalogueLineValidityStart &gt;= $CatalogueValidityStart) and ($CatalogueLineValidityStart &lt;= $CatalogueValidityEnd) 
            and ($CatalogueLineValidityEnd &lt;= $CatalogueValidityEnd) and ($CatalogueLineValidityEnd &gt;= $CatalogueValidityStart)"        
            flag="fatal">Catalogue line validity period SHALL be within the range of the whole catalogue validity period</assert>
        <assert id="PEPPOL-T19-R013"
            test="($CatalogueLineValidityStart &lt;= $CatalogueLineValidityEnd)"
            flag="fatal">A line validity period end date SHALL be later or equal to the line validity period start date
        </assert>
    </rule>
    
    <rule context="cac:RequiredItemLocationQuantity">
        
        <let name="CatalogueLineValidityStart" value="if(exists(../cac:LineValidityPeriod/cbc:StartDate)) then number(translate(../cac:LineValidityPeriod/cbc:StartDate,'-','')) else $CatalogueValidityStart"/>
        <let name="CatalogueLineValidityEnd" value="if(exists(../cac:LineValidityPeriod/cbc:EndDate)) then number(translate(../cac:LineValidityPeriod/cbc:EndDate,'-','')) else $CatalogueValidityEnd"/>
        <let name="CataloguePriceValidityStart" value="if(exists(cac:Price/cac:ValidityPeriod/cbc:StartDate)) then number(translate(cac:Price/cac:ValidityPeriod/cbc:StartDate,'-','')) else $CatalogueLineValidityStart"/>
        <let name="CataloguePriceValidityEnd" value="if(exists(cac:Price/cac:ValidityPeriod/cbc:EndDate)) then number(translate(cac:Price/cac:ValidityPeriod/cbc:EndDate,'-','')) else $CatalogueLineValidityEnd"/>

        <assert id="PEPPOL-T19-R006"
                test="number(cac:Price/cbc:PriceAmount) &gt;=0"
                flag="fatal">Prices of items SHALL not be negative</assert>
        
        <assert id="PEPPOL-T19-R011"
            test="($CataloguePriceValidityStart &gt;= $CatalogueLineValidityStart) and ($CataloguePriceValidityStart &lt;= $CatalogueLineValidityEnd) 
            and ($CataloguePriceValidityEnd &lt;= $CatalogueLineValidityEnd) and ($CataloguePriceValidityEnd &gt;= $CatalogueLineValidityStart)"        
            flag="fatal">Price validity start date SHALL be within the range of the catalogue line or catalogue validity period</assert>
        <assert id="PEPPOL-T19-R016"
            test="($CataloguePriceValidityStart &lt;= $CataloguePriceValidityEnd)"
            flag="fatal">A price validity period end date SHALL be later or equal to the price validity period start date
        </assert>
    </rule>

    <rule context="cac:ClassifiedTaxCategory">
        <assert id="PEPPOL-T19-R014"
            test="cbc:Percent or (normalize-space(cbc:ID)='O')"
            flag="fatal">Each Tax Category SHALL have a TAX category rate, except if the catalogue line is not subject to TAX.</assert>
        <assert id="PEPPOL-T19-R015"
            test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) &gt; 0"
            flag="fatal">When TAX category code is "Standard rated" (S) the TAX rate SHALL be greater than zero.</assert>
    </rule>

    <rule context="cac:Item">
        <assert id="PEPPOL-T19-R012"
                test="(cac:StandardItemIdentification/cbc:ID) or (cac:SellersItemIdentification/cbc:ID)"
                flag="fatal">Each item in a Catalogue line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
    </rule>



</pattern>