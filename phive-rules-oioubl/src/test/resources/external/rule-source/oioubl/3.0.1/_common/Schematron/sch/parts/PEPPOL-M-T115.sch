<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

    <rule context="cbc:ProfileID">
        <assert id="PEPPOL-T115-R031"
            test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3', '\s') satisfies $p = normalize-space(.)"
            flag="fatal">An order cancellation transaction MUST use profile advanced_ordering.</assert>
    </rule>

		<rule context="cbc:CustomizationID">
				<assert id="PEPPOL-T115-R034"
						test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_cancellation:3')"
						flag="fatal">Specification identifier MUST start with the value 'urn:fdc:peppol.eu:poacc:trns:order_cancellation:3'.</assert>
		</rule>

</pattern>
