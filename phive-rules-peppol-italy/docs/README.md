Source:
https://peppol.agid.gov.it/en/technical-specifications/
https://peppol-docs.agid.gov.it/docs/my_index_fatt-ENG.jsp
https://www.agenziaentrate.gov.it/portale/web/guest/normativa-e-prassi/provvedimenti/2019/aprile-2019-provvedimenti/provvedimento-18042019-fatturazione-elettronica-europea

Download files: https://peppol-docs.agid.gov.it/docs/attachments/

# Note on the 3.2.1 package (2026-08-03 snapshot)

AGID updated the Schematron content **in place** under the same package version `3.2.1`
(via the Peppol November 2025 release, mandatory from 2026-02-23) without bumping the version
number. The `*-3.2.1-2026-08-03.zip` files are the snapshot downloaded on 2026-08-03; the
plain `*-3.2.1.zip` files are the earlier 3.2.1 content that the currently committed XSLT under
`src/main/resources/external/schematron/peppol-italy/3.2.1/` was generated from.

Differences of the 2026-08-03 Schematron-Billing snapshot vs. the earlier committed 3.2.1
(peppolbis-en16931-ubl-3.0-invoice rules):
* New file `OPENPEPPOL/12-PEPPOL-EN16931-UBL-germany.inc` (German country rules `DE-R-001` ff.)
* New file `OPENPEPPOL/13-PEPPOL-EN16931-UBL-codelists.inc`
* Core `OPENPEPPOL/3-...-general.inc` grew from 75 to 81 assertions; added
  `PEPPOL-COMMON-R052`, `PEPPOL-COMMON-R053`, `PEPPOL-EN16931-R100-NA`
* `UBL-CR-631` removed from one rule file
* Numerous other `.sch`/`.inc` files changed (ENG and ITA)

This snapshot was never integrated.

# Note on the 3.2.1 package (2026-08-17 re-publication)

AGID re-published the 3.2.1 packages again on 2026-08-17 (HTTP Last-Modified), now based on Peppol
BIS Billing 3.0.21 (the AGID page shows "Peppol BIS Billing 3.0.21.1(IT)"). These are stored as
`*-3.2.1-2026-08-17.zip`, and the rule sources under `src/test/resources/external/rule-source/3.2.1/`
(invoice from `AGID-PEPPOL-Schematron-Billing`, the other document types from
`AGID-PEPPOL-Schematron-Others`) were replaced with them; the VES coordinates stay at 3.2.1 (see
https://github.com/phax/phive-rules/issues/92).

* The ITA invoice folder of the package no longer contains the wrapper `AGID-EN16931-UBL.sch`
  (the ENG folder still has it). The previous ITA wrapper is kept, as it only includes
  `AGID/AGID-EN16931-CIUS-UBL.inc` and `AGID/AGID-EN16931-EXT-UBL.inc`, which are part of the package.
  The ITA AGID invoice rules are content-identical to the previous 3.2.1 (line endings only).
* The `<phase>` elements of the invoice Schematrons activate the pattern IDs `OP-transaction-rules`,
  `OP-Germany-rules` and `OP-cl-formatting-rules`, which are not declared in the included files
  (they are called `UBL-general`, `german-rules` and `codelists`). As no `defaultPhase` is set, all
  patterns are evaluated and this has no effect on the validation result.
