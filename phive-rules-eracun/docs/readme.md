# CIUS-HR

Source: https://porezna.gov.hr/fiskalizacija/bezgotovinski-racuni/eracun

# eIzvjestavanje (e-reporting)

`eIzvjestavanjeSchema-2026-02-09.zip` was received as an attachment of
https://github.com/phax/phive-rules/issues/89 - the official download location on porezna.gov.hr is not known.
It contains the XML Schema and the WSDL of the eIzvjestavanje service.
Only the XML Schema is used for validation; it is copied unmodified to
`src/main/resources/external/schemas/1.0/eIzvjestavanjeSchema.xsd`.
The `xmldsig-core-schema.xsd` imported by it is not part of the ZIP and is taken from `ph-xsds-xmldsig`.
