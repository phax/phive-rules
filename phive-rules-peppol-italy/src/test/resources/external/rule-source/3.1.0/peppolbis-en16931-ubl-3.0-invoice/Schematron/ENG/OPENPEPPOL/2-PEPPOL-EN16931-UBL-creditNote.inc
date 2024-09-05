<pattern id="UBL-creditNote" xmlns="http://purl.oclc.org/dsdl/schematron">
	<rule context="ubl-creditnote:CreditNote">
		<assert id="PEPPOL-EN16931-R080" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='50']) &lt;= 1)" flag="fatal">Only one project reference is allowed on document level</assert>
	</rule>
</pattern>