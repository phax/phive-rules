<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

    <rule context="/*">
        <assert id="PEPPOL-COMMON-R003"
                test="not(@*:schemaLocation)"
                flag="warning">Document SHOULD not contain schema location.</assert>

    </rule>

    <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
        <assert id="PEPPOL-COMMON-R030"
                test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
    </rule>

    <!-- Validation of ICD -->
    <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
        <assert id="PEPPOL-COMMON-R040"
                test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"
                flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
        <assert id="PEPPOL-COMMON-R041"
                test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"
                flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
      <assert id="PEPPOL-COMMON-R043" test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())" flag="fatal">Belgian enterprise number MUST be stated in the correct format.</assert>
    </rule>	
 <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
      <assert id="PEPPOL-COMMON-R044" test="u:checkCodiceIPA(normalize-space())" flag="warning">IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
      <assert id="PEPPOL-COMMON-R045" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '9907']">
      <assert id="PEPPOL-COMMON-R046" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
      <assert id="PEPPOL-COMMON-R047" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '9906']">
      <assert id="PEPPOL-COMMON-R048" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
      <assert id="PEPPOL-COMMON-R049" test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())" flag="fatal">Swedish organization number MUST be stated in the correct format.</assert>
    </rule>  	
    <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
      <assert id="PEPPOL-COMMON-R050" test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())" flag="fatal">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
    </rule> 
</pattern>
