<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

        <title>Danish OIOUBL 3 - Common</title>

        <rule context="//*[not(*) and not(normalize-space())]">
                <assert id="PEPPOL-EN16931-R008" test="false()" flag="fatal">Document MUST not
                        contain empty elements.</assert>
        </rule>
        

        <rule
                context="ubl-creditnote:CreditNote/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
                
                <assert
                        id="OIOUBL-BIL-099"
                        test="number(text()) &gt;= 0 or /*/cac:AdditionalDocumentReference/cbc:DocumentTypeCode[@listAgencyName = 'ERST'] = 'PEPPOLBIS32OIOUBL'"
                        flag="fatal">The value of TaxInclusiveAmount must not be negative unless
                        DocumentTypeCode is 'PEPPOLBIS32OIOUBL' with listAgencyName 'ERST' - Value
                        found: '<value-of
                                select="."/>' </assert>
        </rule>

</pattern>
