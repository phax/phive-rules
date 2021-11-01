<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
	
	<rule context="cac:Status[cbc:StatusReasonCode/@listID='OPStatusAction']">
		<assert id="PEPPOL-T111-R006"
				test="((not(contains(normalize-space(cbc:StatusReasonCode), ' ')) and contains(' NOA PIN NIN CNF CNP CNA OTH ', concat(' ', normalize-space(cbc:StatusReasonCode), ' '))))"
				flag="fatal">Clarification Reason code shall exist in the OPStatusAction code lists as identified by listID.</assert>
	</rule>

	<rule context="cac:Status[cbc:StatusReasonCode/@listID='OPStatusReason']">
		<assert id="PEPPOL-T111-R007"
				test="((not(contains(normalize-space(cbc:StatusReasonCode), ' ')) and contains(' NON REF LEG REC QUA DEL PRI QTY ITM PAY PPD UNR FIN OTH ', concat(' ', normalize-space(cbc:StatusReasonCode), ' '))))"
				flag="fatal">Clarification Reason code shall exist in the OPStatusReason code lists as identified by listID.</assert>
	</rule>
	
</pattern>
