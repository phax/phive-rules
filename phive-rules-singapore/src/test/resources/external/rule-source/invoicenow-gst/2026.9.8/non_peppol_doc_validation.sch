<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt2">
  <title>Data submission to IRAS under InvoiceNow GST requirements v0.3.4</title>
  <!-- last update 13/01/2025 -->
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="dh" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" />

  <pattern>
    <rule context="dh:StandardBusinessDocumentHeader">
      <assert id="IRASC5-001" flag="fatal" test="normalize-space(dh:Sender/dh:Identifier) != ''">
      [IRASC5-001]-The SBDH envelope MUST have a Sender identifier.</assert>
      <assert id="IRASC5-002" flag="fatal" test="normalize-space(dh:Receiver/dh:Identifier) != ''">
      [IRASC5-002]-The SBDH envelope MUST have a Receiver identifier.
      </assert>
      <assert id="IRASC5-003" flag="fatal" test="normalize-space(dh:DocumentIdentification/dh:InstanceIdentifier) != ''">
        [IRASC5-003]-The SBDH envelope MUST have an Instance identifier.
      </assert>
      <assert id="IRASC5-004" flag="fatal" test="normalize-space(dh:DocumentIdentification/dh:CreationDateAndTime) != ''">
        [IRASC5-004]-The SBDH envelope MUST have a Creation date and time.
      </assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="ubl:Invoice | cn:CreditNote">
       <assert id="IRASC5-005" test="normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:international:sg:3.0' or normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:LocalTaxInvoice:sg:1.0' or normalize-space(cbc:CustomizationID) = 'urn:peppol:pint:billing-1@sg-1' or normalize-space(cbc:CustomizationID) = 'urn:peppol:pint:billing-1@sg-1:LocalTaxInvoice:sg:1.0'" flag="fatal">[IRASC5-005]-An Invoice MUST have a valid Specification identifier (IBT-024).</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="ubl:Invoice | cn:CreditNote">
      <assert id="IRASC5-006" flag="fatal" test="normalize-space(lower-case(cbc:ProfileID)) = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:fdc:peppol.eu:2017:poacc:payables:01:1.0' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:peppol:bis:billing' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:peppol:bis:payables'">[IRASC5-006]-An Invoice MUST have a valid Business process type (IBT-023).</assert>
      <assert id="IRASC5-007" flag="fatal" test="exists(cbc:ID)">[IRASC5-007]-An Invoice MUST have an Invoice number (IBT-001).</assert>
      <assert id="IRASC5-008" flag="fatal" test="exists(cbc:UUID)">[IRASC5-008]-An Invoice MUST have a UUID value (BT-SG-003).</assert>
      <assert id="IRASC5-009" flag="fatal" test="exists(cbc:IssueDate)">[IRASC5-009]-An Invoice MUST have an Invoice issue date (IBT-002).</assert>
      <assert id="IRASC5-010" flag="fatal" test="exists(cbc:InvoiceTypeCode) or normalize-space(cbc:CreditNoteTypeCode) !=''">[IRASC5-010]-An Invoice MUST have an Invoice type code (IBT-003).</assert>
    </rule>

    <rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
      <assert id="IRASC5-011" flag="fatal" test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 380 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 381 ', concat(' ', normalize-space(.), ' ')))))">[IRASC5-011]-The Invoice type code (IBT-003) MUST be coded using valid code values.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="ubl:Invoice | cn:CreditNote">
      <assert id="IRASC5-012" flag="fatal" test="exists(cbc:DocumentCurrencyCode)">[IRASC5-012]-An Invoice MUST have an Invoice currency code (IBT-005).</assert> 
    </rule>
    <rule flag="fatal" context="cbc:DocumentCurrencyCode">
      <assert id="IRASC5-013" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">[IRASC5-013]-Invoice currency code  (IBT-005) MUST be coded using ISO code list 4217 alpha-3</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="ubl:Invoice | cn:CreditNote">
      <assert flag="fatal" id="IRASC5-014" test="(normalize-space(cbc:DocumentCurrencyCode) = 'SGD' and not(cbc:TaxCurrencyCode)) or (normalize-space(cbc:DocumentCurrencyCode) != 'SGD' and normalize-space(cbc:TaxCurrencyCode) = 'SGD')">[IRASC5-014]-An Invoice MUST have an Accounting currency code (IBT-006) with value 'SGD', if the Invoice currency code (IBT-005) is not 'SGD'. Otherwise, the Accounting currency code (IBT-006) MUST NOT be provided.</assert>
      <assert flag="fatal" id="IRASC5-015" test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (count(cac:AdditionalDocumentReference/cbc:DocumentTypeCode = 'sgdtotal-excl-gst') = 1 and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-excl-gst'] / cbc:ID) = 'SGD' and  normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-excl-gst'] / cbc:DocumentDescription) != '' )">[IRASC5-015]-If the Invoice currency code (IBT-005) is not 'SGD', the Invoice MUST have exactly one Additional Supporting Document as follows: Document type code (BT-SG-001) MUST be 'sgdtotal-excl-gst', Supporting document description MUST be provided, Invoiced object identifier MUST be 'SGD'.</assert>
      <assert flag="fatal" id="IRASC5-016" test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (count(cac:AdditionalDocumentReference/cbc:DocumentTypeCode = 'sgdtotal-incl-gst') = 1 and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-incl-gst'] / cbc:ID) = 'SGD' and  normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-incl-gst'] / cbc:DocumentDescription) != '' )">[IRASC5-016]-If the Invoice currency code (IBT-005) is not 'SGD', the Invoice MUST have exactly one Additional Supporting Document as follows: Document type code (BT-SG-002) MUST be 'sgdtotal-incl-gst', Supporting document description MUST be provided, Invoiced object identifier MUST be 'SGD'.</assert>
    </rule>

    <rule context="cac:AccountingSupplierParty/cac:Party">
      <assert id="IRASC5-017" flag="fatal" test="cbc:EndpointID">[IRASC5-017]-The Seller electronic address (IBT-049) MUST be provided.</assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
      <assert id="IRASC5-018" flag="fatal" test="exists(@schemeID)">[IRASC5-018]-The Seller electronic address (IBT-034) MUST have a Scheme identifier.</assert>
    </rule>

    <rule flag="fatal" context="cbc:EndpointID[@schemeID]">
      <assert id="IRASC5-019" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0221 0230 9901 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 ', concat(' ', normalize-space(@schemeID), ' '))))">[IRASC5-019]-Endpoint identifier scheme identifier (IBT-034-1), (IBT-049-1) MUST belong to the CEF EAS code list</assert>
    </rule>

    <rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
      <assert id="IRASC5-020" flag="fatal" test="normalize-space(cbc:StreetName) != ''">[IRASC5-020]-The Seller address line 1 (IBT-035) MUST be provided.</assert>
      <assert id="IRASC5-021" flag="fatal" test="normalize-space(cbc:PostalZone) != ''">[IRASC5-021]-The Seller post code (IBT-038) MUST be provided.</assert>
      <assert id="IRASC5-022" flag="fatal" test="normalize-space(cac:Country/cbc:IdentificationCode) != ''">[IRASC5-022]-The Seller postal address (IBG-05) MUST contain a Seller country code (IBT-040).</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="ubl:Invoice | cn:CreditNote">
      <assert id="IRASC5-023" flag="fatal" test="count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'GST'])=1 and normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) ='GST']/cbc:CompanyID) != ''">[IRASC5-023]-The Seller GST identifier (IBT-031) MUST be provided.</assert>
      <assert id="IRASC5-024" flag="fatal" test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID ) = 'GST'">
        [IRASC5-024]-The tax scheme identifier (IBT-031-1) of the Seller GST identifier (IBT-031) MUST be 'GST'.
      </assert>
      <assert id="IRASC5-025" flag="fatal" test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">[IRASC5-025]-An Invoice MUST contain the Seller name (IBT-027).</assert>
      <assert id="IRASC5-026" flag="fatal" test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) !=''">[IRASC5-026]-The Seller legal registration identifier (IBT-030) MUST be provided.</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party">
        <assert id="IRASC5-027" flag="fatal" test="cbc:EndpointID">[IRASC5-027]-The Buyer electronic address (IBT-049) MUST be provided.</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
        <assert id="IRASC5-028" flag="fatal" test="exists(@schemeID)">[IRASC5-028]-The Buyer electronic address (IBT-049) MUST have a Scheme identifier.</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
        <assert id="IRASC5-029" flag="fatal" test="normalize-space(cbc:StreetName) != ''">[IRASC5-029]-The Buyer address line 1 (IBT-050) MUST be provided.</assert>
        <assert id="IRASC5-030" flag="fatal" test="normalize-space(cbc:PostalZone) != ''">[IRASC5-030]-The Buyer post code (IBT-053) MUST be provided.</assert>
        <assert id="IRASC5-031" flag="fatal" test="normalize-space(cac:Country/cbc:IdentificationCode) != ''">[IRASC5-031]-The Buyer postal address (IBG-08) MUST contain a Buyer country code (IBT-055).</assert>
      </rule>
  </pattern>

  <pattern>
      <rule context="ubl:Invoice | cn:CreditNote">
        <assert id="IRASC5-033" flag="fatal" test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">[IRASC5-033]-An Invoice MUST contain the Buyer name (IBT-044).</assert>
        <assert id="IRASC5-034" flag="fatal" test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) !=''">[IRASC5-034]-The Seller legal registration identifier (IBT-047) MUST be provided.</assert>
        <assert id="IRASC5-035" flag="fatal" test="every $Currency in cbc:DocumentCurrencyCode satisfies (cac:TaxTotal/cbc:TaxAmount[@currencyID = $Currency])">[IRASC5-035]-An Invoice MUST have an Invoice total GST amount (IBT-110).</assert>
        <assert id="IRASC5-037" flag="fatal" test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency]))">[IRASC5-037]-An Invoice MUST have an Invoice total GST amount in accounting currency (IBT-111), if the Invoice currency code (IBT-005) is not 'SGD'.</assert>
        <assert id="IRASC5-039" flag="fatal" test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0)">[IRASC5-039]-Invoice total tax amount (IBT-110) and Invoice total tax amount in accounting currency (IBT-111) MUST have the same operational sign.</assert>
      </rule>
      <rule context="ubl:Invoice | cn:CreditNote">
          <assert id="IRASC5-036" flag="fatal" test="normalize-space(cac:TaxTotal/cbc:TaxAmount/@currencyID) != ''">[IRASC5-036]-The currency code MUST be provided for the Invoice total GST amount (IBT-110).</assert>
      </rule>
      <rule context="ubl:Invoice | cn:CreditNote">
        <assert id="IRASC5-038" flag="fatal" test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (normalize-space(cac:TaxTotal/cbc:TaxAmount/@currencyID) = 'SGD' and normalize-space(cbc:DocumentCurrencyCode) != 'SGD')">[IRASC5-038]-The currency code for the Invoice total GST amount in accounting currency (IBT-111) MUST be 'SGD', if the Invoice currency code (IBT-005) is not 'SGD'.</assert>
      </rule>

    <rule context="cac:TaxTotal/cac:TaxSubtotal">
      <assert test="exists(cbc:TaxableAmount)" flag="fatal" id="IRASC5-040">[IRASC5-040]-Each GST Breakdown (IBG-23) shall have a GST category taxable amount (BT-116-GST).</assert>
      <assert id="IRASC5-041" flag="fatal" test="normalize-space(cbc:TaxableAmount/@currencyID) != ''">[IRASC5-041]-The currency code MUST be provided for the GST category taxable amount (IBT-116).</assert>
      <assert test="exists(cbc:TaxAmount)" flag="fatal" id="IRASC5-042">[IRASC5-042]-Each GST Breakdown (IBG-23) shall have a GST category tax amount (IBT-117).</assert>
      <assert id="IRASC5-043" flag="fatal" test="normalize-space(cbc:TaxAmount/@currencyID) != ''">[IRASC5-043]-The currency code MUST be provided for the GST category tax amount (IBT-117).</assert>
      <assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" flag="fatal" id="IRASC5-044">[IRASC5-044]-Each GST Breakdown (IBG-23) shall be defined through a GST category code (IBT-118).</assert>
      <assert id="IRASC5-045" flag="fatal" test="exists(contains( ' SR SRCA-S SRCA-C SRLVG NA ZR TX TXCA TX-RE ', concat(' ',upper-case(normalize-space(cac:TaxCategory/cbc:ID)),' ')))">[IRASC5-045]-At least one GST category code (IBT-118) within the GST Breakdown (IBG-23) MUST be within the scope of the GST InvoiceNow Requirement.</assert>
      <assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent)" flag="fatal" id="IRASC5-046">[IRASC5-046]-Each GST Breakdown (IBG-23) MUST have a GST category rate (IBT-119).</assert>
      <assert id="IRASC5-047" flag="fatal" test="normalize-space(cac:TaxCategory/cac:TaxScheme/cbc:ID) = 'GST'">[IRASC5-047]-Each GST Breakdown (IBG-23) MUST have a GST category tax scheme identifier (IBT-118-1) with value 'GST'.</assert>
      <assert id="IRASC5-048" flag="fatal" test="every $taxCategoryCode in cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID satisfies (count (cac:TaxCategory/cbc:ID = $taxCategoryCode) = 1) ">[IRASC5-048]-All distinct values of the Invoiced item GST category codes (IBT-151) MUST tally with the values of the GST category codes (IBT-118).</assert>
      <assert test="(contains(normalize-space(lower-case(../../cbc:ProfileID)), 'payable' ) and contains( ' BL EP IGDS IM IM-ESS IM-N33 IM-RE ME NR OP TX TX-N33 TX-RE TXCA TXNA TX-ESS TXRC-TS TXRC-ESS TXRC-N33 TXRC-RE ZP ', concat(' ',upper-case(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)),' '))) or (  contains(normalize-space(lower-case(../../cbc:ProfileID)), 'billing' )  and contains( ' SR SRCA-S SRCA-C SRRC SROVR-RS SROVR-LVG SRLVG ZR ES33 ESN33 DS OS NG NA ', concat(' ',upper-case(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)),' ')))" flag="fatal" id="IRASC5-049">[IRASC5-049]-The GST category codes (IBT-118) on an Invoice MUST be valid values for the Business process type (IBT-023).</assert>
   </rule>

    <rule context="cac:LegalMonetaryTotal">
      <assert id="IRASC5-050" flag="fatal" test="exists(cbc:LineExtensionAmount)">[IRASC5-050]-An Invoice MUST have the Sum of Invoice line net amount (IBT-106).</assert>
      <assert id="IRASC5-051" flag="fatal" test="normalize-space(cbc:LineExtensionAmount/@currencyID ) != ''">[IRASC5-051]-The currency code MUST be provided for the Sum of Invoice line net amount (IBT-106).</assert>
      <assert id="IRASC5-052" flag="fatal" test="exists(cbc:TaxExclusiveAmount)">[IRASC5-052]-An Invoice MUST have the Invoice total amount without Tax (IBT-109).</assert>
      <assert id="IRASC5-053" flag="fatal" test="normalize-space(cbc:TaxExclusiveAmount) != ''">[IRASC5-053]-The currency code MUST be provided for the Invoice total amount without GST (IBT-109)</assert>
      <assert id="IRASC5-054" flag="fatal" test="exists(cbc:TaxInclusiveAmount)">[IRASC5-054]-An Invoice MUST have the Invoice total amount with Tax (IBT-112).</assert>
      <assert id="IRASC5-055" flag="fatal" test="number(cbc:TaxInclusiveAmount)>=0">[IRASC5-055]-The Invoice total amount with GST (IBT-112) MUST not be negative.</assert>
      <assert id="IRASC5-056" flag="fatal" test="normalize-space(cbc:TaxInclusiveAmount ) != ''">[IRASC5-056]-The currency code MUST be provided for the Invoice total amount with GST (IBT-112).</assert>
      <assert id="IRASC5-057" flag="fatal" test="exists(cbc:PayableAmount)">[IRASC5-057]-An Invoice MUST have the Amount due for payment (IBT-115).</assert>
      <assert id="IRASC5-058" flag="fatal" test="normalize-space(cbc:PayableAmount) != ''">[IRASC5-058]-The currency code MUST be provided for the Amount due for payment (IBT-115).</assert>
    </rule>

    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="IRASC5-059" flag="fatal" test="normalize-space(cbc:ID) != ''">[IRASC5-059]-Each Invoice line (ibg-25) MUST have an Invoice line identifier (IBT-126).</assert>
      <assert id="IRASC5-060" flag="fatal" test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)">[IRASC5-060]-Each Invoice line (ibg-25) MUST have an invoiced quantity (IBT-129)..</assert>
      <assert id="IRASC5-061" flag="fatal" test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)">[IRASC5-061]-An Invoice line (ibg-25) MUST have an Invoiced quantity unit of measure code (IBT-130).</assert>
      <assert id="IRASC5-062" flag="fatal" test="exists(cbc:LineExtensionAmount)">[IRASC5-062]-Each Invoice line (ibg-25) MUST have an Invoice line net amount (IBT-131).</assert>
      <assert id="IRASC5-063" flag="fatal" test="normalize-space(cbc:LineExtensionAmount) != ''">[IRASC5-063]-The currency code MUST be provided for each Invoice line net amount (IBT-131).</assert>
      <assert id="IRASC5-064" flag="fatal" test="normalize-space(cac:Item/cbc:Name) != ''">[IRASC5-064]-Each Invoice line (ibg-25) MUST contain the Item name (IBT-153).</assert>
      <assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" flag="fatal" id="IRASC5-065">[IRASC5-065]-Each Invoice line (BG-25) shall be categorized with an Invoiced item GST category code (BT-151-GST).</assert>
    </rule>
    <rule context="cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
      <assert test="(( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C SRRC SROVR-RS SROVR-LVG SRLVG ZR ES33 ESN33 DS OS NG NA TX TXCA TXNA ZP IM ME IGDS BL NR EP OP TXR-TS TX-ESS TXRC-ESS IM-ESS TX-N33 TXRC-N33 IM-N33 TX-RE TXRC-RE IM-RE ',concat(' ',normalize-space(.),' ') ) ) )" id="IRASC5-066" flag="fatal">[IRASC5-066]-Invoice tax categories MUST be coded using valid Singapore code values</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent)" flag="fatal" id="IRASC5-067">[IRASC5-067]-The Invoiced item GST rate (IBT-152) MUST be provided for each Line GST Information (IBG-30).</assert>
      <assert id="IRASC5-068" flag="fatal" test="normalize-space(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) = 'GST' or normalize-space(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) = 'GST' ">[IRASC5-068]-The tax scheme identifier (IBT-167) MUST be provided for each Line GST Information (IBG-30).</assert>
      <assert id="IRASC5-069" flag="fatal" test="exists(cac:Price/cbc:PriceAmount)">[IRASC5-069]-Each Invoice line (ibg-25) MUST contain the Item net price (IBT-146).</assert>
      <assert id="IRASC5-070" flag="fatal" test="(cac:Price/cbc:PriceAmount) >= 0">[IRASC5-070]-The Item net price (IBT-146) MUST NOT be negative.</assert>
      <assert id="IRASC5-071" flag="fatal" test="normalize-space(cac:Price/cbc:PriceAmount/@currencyID) != '' or normalize-space(cac:Price/cbc:PriceAmount/@currencyID) != ''">[IRASC5-071]-The currency code MUST be provided for each Item net price (IBT-146).</assert>
    </rule>
  </pattern>

  <pattern id="credit_only">
    <rule context="cn:CreditNote">
      <assert id="IRASC5-072" flag="fatal" test="normalize-space(cbc:Note) !=''">[IRASC5-072]-An Invoice MUST have an Invoice note (IBT-022), if it is a Credit Note.</assert>
    </rule>
  </pattern>

  <pattern> 
    <rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cbc:TaxAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cac:TaxSubtotal/cbc:TaxAmount">
      <assert id="IRASC5-075" flag="fatal" test="@currencyID = //cbc:DocumentCurrencyCode">[IRASC5-075]- All currencyID attributes must have the same value as the Invoice currency code (IBT-005), except for amounts expected to be in Tax accounting currency (IBT-006).</assert>
    </rule>

    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="IRASC5-076"
              flag="fatal"
              test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[IRASC5-076]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</assert>

    </rule>

    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="IRASC5-077"
              flag="fatal"
              test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[IRASC5-077]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</assert>     
       <assert id="IRASC5-078"
              flag="fatal"
              test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[IRASC5-078]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</assert>
      <assert id="IRASC5-079"
              flag="fatal"
              test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[IRASC5-079]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</assert>
    </rule>

    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="IRASC5-080" flag="fatal" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">[IRASC5-080]-The allowed maximum number of decimals for the Invoice total GST amount (BT-110-GST) is 2.</assert>
      <assert id="IRASC5-081"
      flag="fatal"
      test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">[IRASC5-081]-The allowed maximum number of decimals for the Invoice total GST amount in accounting currency (BT-111-GST) is 2.</assert>
    </rule>

    <rule context="cac:TaxTotal/cac:TaxSubtotal">
      <assert id="IRASC5-082" flag="fatal" test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">[IRASC5-082]-The allowed maximum number of decimals for the GST category taxable amount (BT-116-GST) is 2.</assert>
      <assert id="IRASC5-083" flag="fatal" test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">[IRASC5-083]-The allowed maximum number of decimals for the GST category tax amount (IBT-117) is 2.</assert>
    </rule>

    <rule context="cac:LegalMonetaryTotal">
      <assert id="IRASC5-084"
               flag="fatal"
               test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">[IRASC5-084]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</assert>
      <assert id="IRASC5-085" flag="fatal" test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">[IRASC5-085]-The allowed maximum number of decimals for the Invoice total amount without GST (BT-109-GST) is 2.</assert>
      <assert id="IRASC5-086" flag="fatal" test="string-length(substring-after(cbc:TaxInclusiveAmount, '.')) &lt;= 2">[IRASC5-086]- Invoice total amount with TAX (IBT-112) MUST have no more than 2 decimals.</assert>
      <assert id="IRASC5-087" flag="fatal" test="string-length(substring-after(cbc:AllowanceTotalAmount, '.')) &lt;= 2">[IRASC5-087]-Document level allowance amount (IBT-107) MUST have no more than 2 decimals.</assert>
      <assert id="IRASC5-088" flag="fatal" test="string-length(substring-after(cbc:ChargeTotalAmount, '.')) &lt;= 2">[IRASC5-088]-Document level charge amount (IBT-108) MUST have no more than 2 decimals.</assert>
      <assert id="IRASC5-089"
               flag="fatal"
               test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">[IRASC5-089]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</assert>
      <assert id="IRASC5-090" flag="fatal" test="string-length(substring-after(cbc:PayableRoundingAmount, '.')) &lt;= 2">[IRASC5-090]-The Rounding amount (IBT-114), if provided, MUST have no more than 2 decimals.</assert>
      <assert id="IRASC5-091" flag="fatal" test="string-length(substring-after(cbc:PayableAmount, '.')) &lt;= 2">[IRASC5-091]-Invoice amount due for payment (IBT-115) MUST have no more than 2 decimals.</assert>
    </rule>
  </pattern>

  <pattern>

    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="IRASC5-092" flag="fatal" test="string-length(substring-after(cbc:LineExtensionAmount, '.')) &lt;= 2">
      [IRASC5-092]-The Invoice line net amount (IBT-131) MUST have no more than 2 decimals.</assert>
  </rule>
  </pattern>

  <pattern>
    <rule context="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      
      <assert id="IRASC5-094" flag="fatal" test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2">[IRASC5-094]-The Line level charge amount (IBT-141), if provided, MUST have no more than 2 decimals.</assert>
      <assert id="IRASC5-096" flag="fatal" test="string-length(substring-after(cbc:BaseAmount, '.')) &lt;= 2">[IRASC5-096]-The Line level charge base amount (IBT-142), if provided, MUST have no more than 2 decimals.</assert>

    </rule>
    <rule context="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="IRASC5-093" flag="fatal" test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2">[IRASC5-093]-The Line level allowance amount (IBT-136), if provided, MUST have no more than 2 decimals.</assert>
      <assert id="IRASC5-095" flag="fatal" test="string-length(substring-after(cbc:BaseAmount, '.')) &lt;= 2">[IRASC5-095]-The Line level allowance base amount (IBT-137), if provided, MUST have no more than 2 decimals.</assert>
    </rule>

    <rule context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode]">
      <assert id="IRASC5-100" flag="fatal" test="(cbc:DocumentTypeCode='sgdtotal-excl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-excl-gst' ">[IRASC5-100]- Total Amount excluding GST in SGD must be numeric and have maximum of 2 decimals</assert>
      <assert id="IRASC5-101" flag="fatal" test="(cbc:DocumentTypeCode='sgdtotal-incl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-incl-gst' ">[IRASC5-101]- Total Amount including GST in SGD must be numeric and have maximum of 2 decimals</assert>
   </rule>
  </pattern>
</schema>