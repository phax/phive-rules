# SRBDT (Serbia SEF)

Serbian SEF (Sistem Elektronskih Faktura) EN 16931 CIUS and Extension for domestic
trade in the Republic of Serbia.

Customization identifiers:
* `urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022`
* `urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022`

Validation artefacts source: https://github.com/vasiljevic/en16931-srbdt-va (subfolder `srbdt`, licensed under EUPL v1.2)

Official documentation: https://www.efaktura.gov.rs/

The files in `examples/` are the upstream documentation templates (with Serbian
placeholder text). They are kept for reference only; as-is they intentionally
contain placeholder values (e.g. invalid PIB numbers, non-VATEX exemption codes)
that do not pass validation.

Corrected, passing variants of all four examples - with the placeholder values
replaced by valid sample data - are used as good-case test files under
`src/test/resources/external/test-files/1.0.0/`:
* `faktura.xml` - standard invoice with a standard rated (S) and an exempt (E) line
* `faktura-avansna.xml` - advance/prepayment invoice (type 386), tax point by payment date
* `faktura-jn.xml` - public procurement invoice with two standard rated breakdowns (20% and 10%)
* `faktura-kat-e.xml` - mixed exempt (E) and standard rated (S) categories
