<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <let name="documentCurrencyCode" value="/ubl:OrderResponse/cbc:DocumentCurrencyCode"/>
    
    <!-- CustomzationID -->
	<rule context="cbc:CustomizationID">
			<assert id="PEPPOL-T76-R006" 
					test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_response:3')"
					flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:order_response:3'.</assert>
	</rule>
    
    <!-- Price -->
    <rule context="cbc:PriceAmount">
        <assert id="PEPPOL-T76-R005"
            test="@currencyID = $documentCurrencyCode"
            flag="fatal">An order response SHALL be stated in a single currency</assert>
       
    </rule>
    
    <!-- Buyer party -->
    <rule context="cac:BuyerCustomerParty/cac:Party">
        <assert id="PEPPOL-T76-R001"
            test="cac:PartyLegalEntity/cbc:RegistrationName or cac:PartyIdentification/cbc:ID"
                flag="fatal">An order response SHALL have the buyer party official name or a buyer party identifier</assert>
    </rule>

    <!-- Seller party -->
    <rule context="cac:SellerSupplierParty/cac:Party">
        <assert id="PEPPOL-T76-R002"
                test="cac:PartyLegalEntity/cbc:RegistrationName or cac:PartyIdentification/cbc:ID"
                flag="fatal">An order response SHALL have the seller party official name or a seller party identifier</assert>
    </rule>

    <!-- Delivery period -->
    <rule context="cac:PromisedDeliveryPeriod | cac:OrderLine/cac:LineItem/cac:PromisedDeliveryPeriod">
        <assert  id="PEPPOL-T76-R004"
                test="(exists(cbc:EndDate) and exists(cbc:StartDate) and (cbc:EndDate) &gt;= (cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate)) "
                flag="fatal">If both delivery period start date and delivery period end date are given then the end date SHALL be later or equal to the start date.</assert>
   </rule>

    <!-- Line level -->
    <rule context="cac:OrderLine/cac:LineItem">
        <assert id="PEPPOL-T76-R003"
                test="count(key('k_lineId',cbc:ID)) = 1"
                flag="fatal">Each order response line SHALL have a document line identifier that is unique within the order.</assert>
    </rule>

 
</pattern>