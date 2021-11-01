<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cac:Response[contains( ' CA UQ RE ',concat(' ',normalize-space(cbc:ResponseCode),' '))]">
		<assert id="PEPPOL-T111-R001"
			test="exists(cac:Status/cbc:StatusReasonCode)"
				flag="fatal">If status code is one of: CA, UQ or RE then there SHALL be at a clarification code in Invoice Response.</assert>
	</rule>

	<rule context="cac:Status[cbc:StatusReasonCode='OTH']">
		<assert id="PEPPOL-T111-R002"
				test="exists(cbc:StatusReason)"
				flag="warning">If Clarification code is OTH then Clarification reason SHOULD be provided.</assert>
	</rule>
	
	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T111-R003" 
				test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:invoice_response:3')"
				flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:invoice_response:3'.</assert>
	</rule>

	<rule context="cac:Status[cbc:StatusReasonCode='PPD']">
		<assert id="PEPPOL-T111-R004"
				test="exists(cbc:StatusReason)"
				flag="fatal">If Clarification code is PPD, indicating partial payment, then Clarification reason SHALL be provided.</assert>
				<assert id="PEPPOL-T111-R005"
				test="exists(/cbc:ResponseCode='PD')"
				flag="fatal">Clarification Reason "PPD" SHALL only be used in compination with Status "PD".</assert>
	</rule>

</pattern>
