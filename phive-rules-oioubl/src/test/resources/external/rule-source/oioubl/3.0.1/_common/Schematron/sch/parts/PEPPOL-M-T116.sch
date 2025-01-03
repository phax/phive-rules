<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

    <let name="documentCurrencyCode" value="/ubl:OrderResponse/cbc:DocumentCurrencyCode"/>
    <let name="promisedStartDateDocumentlevel" value="/ubl:OrderResponse/cac:Delivery/cac:PromisedDeliveryPeriod/cbc:StartDate"/>
    <let name="promisedStartDateLinelevel" value="/ubl:OrderResponse/cac:OrderLine/cac:LineItem/cac:Delivery/cac:PromisedDeliveryPeriod/cbc:StartDate"/>


  <!-- CustomzationID -->
	<rule context="cbc:CustomizationID">
			<assert id="PEPPOL-T116-R006"
					test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_response_advanced:3')"
					flag="fatal">Specification identifier MUST start with the value 'urn:fdc:peppol.eu:poacc:trns:order_response_advanced:3'.</assert>
	</rule>

    <!-- Price -->
    <rule context="cbc:PriceAmount">
        <assert id="PEPPOL-T116-R005"
            test="@currencyID = $documentCurrencyCode"
            flag="fatal">An order response MUST be stated in a single currency</assert>

    </rule>

    <!-- Buyer party -->
    <rule context="cac:BuyerCustomerParty/cac:Party">
        <assert id="PEPPOL-T116-R001"
            test="cac:PartyLegalEntity/cbc:RegistrationName or cac:PartyIdentification/cbc:ID"
                flag="fatal">An order response MUST have the buyer party official name or a buyer party identifier</assert>
    </rule>

    <!-- Seller party -->
    <rule context="cac:SellerSupplierParty/cac:Party">
        <assert id="PEPPOL-T116-R002"
                test="cac:PartyLegalEntity/cbc:RegistrationName or cac:PartyIdentification/cbc:ID"
                flag="fatal">An order response MUST have the seller party official name or a seller party identifier</assert>
    </rule>
 
    <!-- Delivery date -->
    <rule context="cac:PromisedDeliveryPeriod | cac:OrderLine/cac:LineItem/cac:PromisedDeliveryPeriod">
        <assert  id="PEPPOL-T116-R004"
                test="(exists(cbc:EndDate) and exists(cbc:StartDate) and (cbc:EndDate) &gt;= (cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate)) "
                flag="fatal">If both delivery period start date and delivery period end date are given then the end date MUST be later or equal to the start date.</assert>
  <!--      <assert  id="PEPPOL-T116-R007"
            test="(exists(cbc:StartDate) and not(exists($promisedStartDateLinelevel))) or (exists($promisedStartDateLinelevel) and not(exists($promisedStartDateDocumentlevel)))"
            flag="fatal">Promised Delivery Period MUST only be stated on document or on line level. </assert> -->
    </rule>

	<rule context="cbc:OrderResponseCode">
		<assert id="PEPPOL-T116-R007"
			 test="(normalize-space(.) = 'CA' and count(../cac:OrderLine) > 0) or normalize-space(.) != 'CA'"
			 flag="warning">An order response with code CA (Conditionally accepted) must provide order lines.</assert>
        <assert id="PEPPOL-T116-R008"
        test="(normalize-space(.) = 'AP' and count(../cac:OrderLine) = 0) or normalize-space(.) != 'AP'"
        flag="warning">An order response with code AP (Accepted) should NOT provide order lines.</assert>
        <assert id="PEPPOL-T116-R009"
        test="(normalize-space(.) = 'RE' and count(../cac:OrderLine) = 0) or normalize-space(.) != 'RE'"
        flag="warning">An order response with code RE (Rejected) should NOT provide order lines.</assert>
        <assert id="PEPPOL-T116-R010"
        test="(normalize-space(.) = 'AB' and count(../cac:OrderLine) = 0) or normalize-space(.) != 'AB'"
        flag="fatal">An order response with code AB (Acknowledged) must NOT provide order lines.</assert>
	</rule>


   <!-- Line level -->
   <rule context="cac:OrderLine/cac:LineItem">
        <assert id="PEPPOL-T116-R003"
                test="count(key('k_lineId',cbc:ID)) = 1"
                flag="fatal">Each order response line MUST have a document line identifier that is unique within the order.</assert>
    </rule>


</pattern>
