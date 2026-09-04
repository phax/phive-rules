Sources:
https://fnfe-mpe.org/ressources/
https://fnfe-mpe.org/wp-content/uploads/2025/08/2025_07_31_FNFE_SCHEMATRONS_FR_CTC_V0.1.zip
https://fnfe-mpe.org/wp-content/uploads/2026/07/2026_06_30_FNFE_SCHEMATRONS_FR_CTC_V1.4.0.zip

GitHub:
https://github.com/fnfempe/France_RFE/releases

Starting with 1.4.0.03 the rules are taken from the GitHub repository.
The GitHub releases carry no attached assets - only the auto generated source
archives - so the ZIPs stored here are trimmed copies of the source archives of
https://github.com/fnfempe/France_RFE/releases/tag/v1.4.0.03 and
https://github.com/fnfempe/France_RFE/releases/tag/v1.4.0.04
containing only the "schematron" and "2xslt" folders of CDAR, CII, UBL and
Factur-X, plus the repository README and the FNFE explanatory notes.
The full source archive is ~38 MB, mostly example and XSD material.
The file name date of a stored ZIP is the GitHub release publication date.

The GitHub layout differs slightly from the fnfe-mpe.org ZIPs:
the root folder is "FNFE_RFE_INVOICE", "Factur-X_1.09" is named "Factur-X",
"BASIC WL" is named "BASICWL" and the Factur-X Schematron file names are
fully upper case. The CDAR, CII and UBL folders are unchanged.

The v1.4.0.04 release was re-published on 2026-09-04 (the tag was moved from
commit 5f76380b to 97ba0f3d). This has no effect on the rules stored here: the
only non-example change is the rename of
"Factur-X/EXTENDED/2xslt/Factur-X_EXTENDED.xslt" to "FACTUR-X_EXTENDED.xslt"
with identical content - everything else added is example material below
"Z.example". All CDAR, CII and UBL Schematron files are byte identical to the
ones already stored, so no regeneration is needed.
