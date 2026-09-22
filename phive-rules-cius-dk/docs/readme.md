# CIUS-DK

The Danish Peppol CIUS package ("PEPPOL_DK_CIUS") is published by Nemhandel /
Erhvervsstyrelsen (Danish Business Authority).

News:    https://nemhandel.dk/opdateringer-releases
Release: https://rep.erst.dk/git/openebusiness/common/-/tree/master/released/peppol

The stored ZIP is the official release package. Only `Schematron/SCH/DK-EN16931-UBL.sch`
is taken from it - the CEN and Peppol Schematrons it also contains are the ones already
provided by `phive-rules-peppol`, on which the CIUS-DK rules are based.

The Danish BIS3-Other package ("PEPPOL_BIS3-Other") is not used here: it only
redistributes the Peppol BIS3 Schematrons for the non-Billing documents, which are
already covered by `phive-rules-peppol`.
