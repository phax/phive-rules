# CIUS-HR

Source: https://porezna.gov.hr/fiskalizacija/bezgotovinski-racuni/eracun

# eIzvjestavanje (e-reporting)

`eIzvjestavanjeSchema-2026-02-09.zip` was received as an attachment of
https://github.com/phax/phive-rules/issues/89.
It is byte-identical to the document "eIzvještavanje Schema" (12.02.2026) on
https://porezna.gov.hr/fiskalizacija/bezgotovinski-racuni/fiskalizacija-bezgotovinskih-racuna
(download https://porezna.gov.hr/fiskalizacija/api/dokumenti/187).
It contains the XML Schema and the WSDL of the eIzvjestavanje service.
Only the XML Schema is used for validation; it is copied unmodified to
`src/main/resources/external/schemas/1.0/eIzvjestavanjeSchema.xsd`.
The `xmldsig-core-schema.xsd` imported by it is not part of the ZIP and is taken from `ph-xsds-xmldsig`.
