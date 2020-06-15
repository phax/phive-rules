<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
        xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
        xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:Order-2"
        queryBinding="xslt2">
  <title>BIIRULES  T01 bound to UBL</title>
  <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <phase id="BIIRULEST01_phase">
      <active pattern="UBL-T01"/>
  </phase>
  <phase id="codelist_phase">
      <active pattern="CodesT01"/>
  </phase>
  
  
  <!--Suppressed abstract pattern T01 was here-->
  
  
  <!--Start pattern based on abstract T01--><pattern id="UBL-T01">
      <rule context="/ubl:Order/cac:AllowanceCharge">
         <assert test="(cbc:AllowanceChargeReason)" flag="fatal" id="BII2-T01-R007">[BII2-T01-R007]-Allowances and charges MUST have a reason</assert>
      </rule>
      <rule context="//cac:BuyerCustomerParty">
         <assert test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal"
                 id="BII2-T01-R021">[BII2-T01-R021]-An order MUST have the buyer party name or a buyer party identifier</assert>
      </rule>
      <rule context="//cac:AnticipatedMonetaryTotal">
         <assert test="(cbc:PayableAmount) &gt;= 0" flag="fatal" id="BII2-T01-R012">[BII2-T01-R012]-Expected total amount for payment MUST NOT be negative, if expected total amount for payment is provided</assert>
         <assert test="(cbc:LineExtensionAmount) &gt;= 0"
                 flag="fatal"
                 id="BII2-T01-R013">[BII2-T01-R013]-Expected total sum of line amounts MUST NOT be negative, if expected total sum of line amounts is provided</assert>
         <assert test="(xs:decimal(cbc:LineExtensionAmount)) = (round(xs:decimal(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount)) * 10 * 10) div 100)"
                 flag="fatal"
                 id="BII2-T01-R014">[BII2-T01-R014]-Expected total sum of line amounts MUST equal the sum of the order line amounts at order line level, if expected total sum of line amounts is provided</assert>
         <assert test="(cbc:AllowanceTotalAmount and (xs:decimal(cbc:AllowanceTotalAmount)) = (round(xs:decimal(sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=&#34;false&#34;]/cbc:Amount)) * 10 * 10) div 100)) or not(cbc:AllowanceTotalAmount)"
                 flag="fatal"
                 id="BII2-T01-R015">[BII2-T01-R015]-Expected total sum of allowance at document level MUST be equal to the sum of allowance amounts at document level, if expected total sum of allowance at document level is provided</assert>
         <assert test="(cbc:ChargeTotalAmount and (xs:decimal(cbc:ChargeTotalAmount)) = (round(xs:decimal(sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=&#34;true&#34;]/cbc:Amount)) * 10 * 10) div 100)) or not(cbc:ChargeTotalAmount)"
                 flag="fatal"
                 id="BII2-T01-R016">[BII2-T01-R016]-Expected total sum of charges at document level MUST be equal to the sum of charges at document level, if expected total sum of charges at document level is provided</assert>
         <assert test="((/ubl:Order/cac:TaxTotal/cbc:TaxAmount)  and  (((cbc:ChargeTotalAmount) and  (cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount + /ubl:Order/cac:TaxTotal/cbc:TaxAmount + cbc:ChargeTotalAmount - cbc:AllowanceTotalAmount) * 10 * 10) div 100))) or  (not(cbc:ChargeTotalAmount) and  (cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount + /ubl:Order/cac:TaxTotal/cbc:TaxAmount - cbc:AllowanceTotalAmount) * 10 * 10) div 100))) or  ((cbc:ChargeTotalAmount) and  not(cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount + /ubl:Order/cac:TaxTotal/cbc:TaxAmount + cbc:ChargeTotalAmount) * 10 * 10) div 100)))  or  (not(cbc:ChargeTotalAmount) and  not(cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount + /ubl:Order/cac:TaxTotal/cbc:TaxAmount ) * 10 * 10) div 100)))))  or  ( not(/ubl:Order/cac:TaxTotal/cbc:TaxAmount)  and  (((cbc:ChargeTotalAmount) and  (cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount + cbc:ChargeTotalAmount - cbc:AllowanceTotalAmount) * 10 * 10) div 100))) or  (not(cbc:ChargeTotalAmount) and  (cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount - cbc:AllowanceTotalAmount) * 10 * 10) div 100))) or  ((cbc:ChargeTotalAmount) and  not(cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount + cbc:ChargeTotalAmount) * 10 * 10) div 100)))  or  (not(cbc:ChargeTotalAmount) and  not(cbc:AllowanceTotalAmount) and  (cbc:PayableAmount = (round((cbc:LineExtensionAmount ) * 10 * 10) div 100)))))"
                 flag="fatal"
                 id="BII2-T01-R017">[BII2-T01-R017]-Expected total amount for payment MUST be equal to the sum of line amounts minus sum of allowances at document level plus sum of charges at document level  and VAT total amount, if expected total amount for payment is provided</assert>
      </rule>
      <rule context="//cac:AdditionalItemProperty">
         <assert test="(cbc:Name)" flag="fatal" id="BII2-T01-R019">[BII2-T01-R019]-Each item property MUST have a data name, if item property is provided</assert>
         <assert test="(cbc:Value)" flag="fatal" id="BII2-T01-R020">[BII2-T01-R020]-Each item property MUST have a data value, if item property is provided</assert>
      </rule>
      <rule context="/ubl:Order">
         <assert test="(cbc:CustomizationID)" flag="fatal" id="BII2-T01-R001">[BII2-T01-R001]-An order MUST have a customization identifier</assert>
         <assert test="(cbc:ProfileID)" flag="fatal" id="BII2-T01-R002">[BII2-T01-R002]-An order MUST have a profile identifier</assert>
         <assert test="(cbc:IssueDate)" flag="fatal" id="BII2-T01-R004">[BII2-T01-R004]-An order MUST have a document issue date</assert>
         <assert test="(cac:ValidityPeriod/cbc:EndDate)"
                 flag="warning"
                 id="BII2-T01-R005">[BII2-T01-R005]-An order SHOULD provide information about its validity end date</assert>
         <assert test="(cbc:ID)" flag="fatal" id="BII2-T01-R006">[BII2-T01-R006]-An order MUST have a document identifier</assert>
         <assert test="(cbc:DocumentCurrencyCode)" flag="fatal" id="BII2-T01-R009">[BII2-T01-R009]-An order MUST be stated in a single currency</assert>
         <assert test="(cac:TaxTotal and (xs:decimal(cac:TaxTotal/cbc:TaxAmount)) = (round(xs:decimal(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount)) * 10 * 10) div 100)) or not(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount)"
                 flag="warning"
                 id="BII2-T01-R018">[BII2-T01-R018]-VAT total amount SHOULD be the sum of order line tax amounts, if order line tax amounts are provided</assert>
      </rule>
      <rule context="//cac:OrderLine">
         <assert test="(cac:LineItem/cbc:ID)" flag="fatal" id="BII2-T01-R003">[BII2-T01-R003]-Each order line MUST have a document line identifier that is unique within the order</assert>
         <assert test="(cac:LineItem/cbc:Quantity) &gt;= 0"
                 flag="fatal"
                 id="BII2-T01-R010">[BII2-T01-R010]-Each order line ordered quantity MUST not be negative</assert>
         <assert test="((cac:LineItem/cac:Price/cbc:PriceAmount) &gt;= 0) or (not(cac:LineItem/cac:Price))"
                 flag="fatal"
                 id="BII2-T01-R011">[BII2-T01-R011]-Each order line item net price MUST not be negative</assert>
         <assert test="(cac:LineItem/cbc:Quantity)"
                 flag="warning"
                 id="BII2-T01-R029">[BII2-T01-R029]-Each order line SHOULD have an ordered quantity</assert>
         <assert test="(cac:LineItem/cbc:Quantity/@unitCode)"
                 flag="fatal"
                 id="BII2-T01-R030">[BII2-T01-R030]-Each order line ordered quantity  MUST have an associated unit of measure</assert>
         <assert test="(cac:LineItem/cac:Item/cbc:Name) or (cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID)"
                 flag="fatal"
                 id="BII2-T01-R031">[BII2-T01-R031]-Each order line MUST have an item identifier and/or an item name</assert>
      </rule>
      <rule context="//cac:SellerSupplierParty">
         <assert test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal"
                 id="BII2-T01-R022">[BII2-T01-R022]-An order MUST have the seller party name or a seller party identifier</assert>
      </rule>
   </pattern>
  
  
  <pattern id="CodesT01">



      <rule context="cac:TaxCategory/cbc:ID" flag="warning">
         <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE E S Z AA H ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="warning">[CL-001-001]-Tax categories MUST be coded using UN/ECE 5305 code list</assert>
      </rule>

   </pattern>
</schema>
