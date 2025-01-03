<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron">

        <sch:title>Common rules for ApplicationResponse</sch:title>

        <sch:rule context="/">
                <sch:assert id="OIOUBL-AR-001"
                            test="local-name(*) = 'ApplicationResponse'"
                            flag="fatal">
                        Root element must be ApplicationResponse
                </sch:assert>
                <sch:assert id="OIOUBL-AR-002"
                            test="namespace-uri(*) = 'urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2'"
                            flag="fatal">
                        The documenttype does not match an OIOUBL ApplicationResponse and can not be validated by this schematron.
                </sch:assert>
        </sch:rule>
</sch:pattern>
