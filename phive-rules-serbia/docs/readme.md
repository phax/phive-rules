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

# SEO (Serbia eOtpremnica / ePrijemnica)

Serbian SEO (Sistem Elektronskih Otpremnica) logistics documents published by the
Ministry of Finance for the SEO system:

* Despatch Advice (eOtpremnica)
    * Customization ID: `urn:fdc:mfin.gov.rs:logistics:trns:despatch_advice:1:2025.12`
    * Profile ID: `urn:fdc:peppol.eu:logistics:bis:despatch_advice_only:1`
* Receipt Advice (ePrijemnica)
    * Customization ID: `urn:fdc:mfin.gov.rs:logistics:trns:receipt_advice:1:2025.12`
    * Profile ID: `urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1`

**Note:** The Ministry of Finance only publishes UBL 2.1 example documents for SEO -
no Schematron business rules are available (see https://eotpremnica.efaktura.gov.rs/).
The VES coordinates `rs.gov.mfin.logistics:ubl-despatch-advice:1.1.0` and
`rs.gov.mfin.logistics:ubl-receipt-advice:1.1.0` therefore perform **UBL 2.1 XSD
validation only**; they do not enforce the Serbia-specific or Peppol Logistics BIS
business rules.

The good-case test files under `src/test/resources/external/test-files/1.1.0/` are the
official UBL 2.1 example documents (version 1.1.0) downloaded from the SEO portal:
* `eotpremnica-001.xml` to `eotpremnica-004.xml` - Despatch Advice examples
* `eprijemnica-001.xml`, `eprijemnica-002.xml` - Receipt Advice examples

The English-language extraction of the SEO technical rules (Despatch Advice, Receipt
Advice and Application Response) - the basis for writing Schematron business rules -
is in [`seo-business-rules.md`](seo-business-rules.md). It is derived from the MFIN
*Tehničko uputstvo* (Technical Instruction) v1.5.0, section 1, pages 4-37. See
https://github.com/phax/phive-rules/issues/68
