ReadmeUK.txt
Revision - 1.17.RC = (15.01.2026).



OIOUBL-2.1 schematron stylesheet
----------------------------------


1.0 Purpose and usage
---------------------
Validation of OIOUBL instances.
The following OIOUBL document types are currently supported:
    ApplicationResponse.xml
    Catalogue.xml
    CatalogueDeletion.xml
    CatalogueItemSpecificationUpdate.xml
    CataloguePricingUpdate.xml
    CatalogueRequest.xml
    CreditNote.xml
    Invoice.xml
    Order.xml
    OrderCancellation.xml
    OrderChange.xml
    OrderResponse.xml
    OrderResponseSimple.xml
    Reminder.xml
    Statement.xml
    UtilityStatement.xml


To validate, execute the following command (shown for Invoice):
msxsl.exe <XML document filename> OIOUBL_Invoice_Schematron.xsl -o result.xml

If the validation is successful, only the title is written to result.xml; otherwise the errors are listed.



2.0 Prerequisites
-----------------
The instance file must validate OK with the UBL-2.1 XSD schema.


3.0 Release Notes
---------------------
Changes from version  1.14.2 til 1.15.RC
- UAN-3872: For UTS it's only allowed to use CustomizationID" = OIOUBL-2.1"
- UAN-2871: Update of validation of profile-id version in UTS
- UAN-5080: Update of code listes for country codes and currency codes. New values added.
- UAN-4610: Standardisation of OIOUBL 2.1 codelist schematron files
- UAN-5139: Stronger VAT validation
            F-LIB400: Validate if TaxSubtotal/TaxAmount on line-level for ZeroRated (VAT percent = 0)
            F-LIB401: Validate if TaxSubtotal/TaxAmount on line-level is correctly calculated for StandardRated (VAT percent > 0) (incl. accepted tolerance +/- 1.00).
            F-LIB402: Validate if TaxableAmount on header-level = sum of line-level (incl. accepted tolerance +/- 1.00)

Changes from version 1.15.RC til 1.15.1
- UAN-5554: F-LIB189 has been corrected, as the original test could lead to false positives where invalid @schemeID values were accepted.

Changes from version 1.15.1 til 1.15.2
NHD-65: F-LIB401 has been corrected to be 100% XSLT 2.0 compatible.

Changes from version 1.15.2 to 1.16.RC
- NHD-297: F-LIB403: validates that Amount/@currencyID is a valid currency.
- NHD-292: Tightening of emissions data (AdditionalItemProperty)
           OIOUBL-Common-GP004: If AdditionalItemProperty/Name = EmissionFactor, then AdditionalItemProperty/Value must be a valid numeric value.
           OIOUBL-Common-GP005: If AdditionalItemProperty/Name = NetEmissionQuantity, then Value must equal EmissionFactor × Quantity. Quantity is either InvoicedQuantity or CreditedQuantity (depending on which is provided).
           OIOUBL-Common-GP006: If AdditionalItemProperty/Name = EmissionFactorSource, then Value must be 'Database' or 'Internal'.
           OIOUBL-Common-GP007: If AdditionalItemProperty/Name = EmissionFactor, then another AdditionalItemProperty with Name = 'EmissionFactorSource' must also exist.
           OIOUBL-Common-GP008: If AdditionalItemProperty/Name = EmissionFactorCalculationUnit, then Value must be a valid UnitCode from the UNECERec20-11e codelist (https://oioubl-demo.nemhandel.dk/oioubl/kodelister/UnitCode-3.0.html).
           OIOUBL-Common-GP009: If AdditionalItemProperty/Name = CalculationRate, then Value must be a valid numeric value.

Changes from version 1.16.RC to 1.16.1
- NHD-338: OIOUBL-Common-GP008 has been changed to use an older version of  UN/ECE UNECE_7_04 (urn:un:unece:uncefact:codelist:specification:66411:2001) so it uses the same as in W-LIB008.
           W-LIB008: The error description has been updated to include the code list name: urn:un:unece:uncefact:codelist:specification:66411:2001

Changes from version fra 1.16.1 til 1.17.RC
- NHD-336: F-LIB404: validates that each cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID present on the line level is also present in the document level summary (and vice versa).
- NHD-348: Adds a new codelist: urn:oioubl:id:taxcategoryid-1.4. The codelist contains the same codes as former iterations, and also adds: B,M,L,K,O,G from codelist: UNCL5305
- NHD-364: F-LIB403 is updated so it no longer validates only cbc:Amount, but instead checks all elements whose name ends with Amount.

4.0 Revision log
----------------
2016.09.15  Version 1.8.0 released.
2017.09.15  Version 1.9.0 released.
2018.09.15  Version 1.10.0 released.
2019.04.08  Version 1.11.1 released.
2022.01.15  Version 1.12.DEV betaversion
2022.03.10  Version 1.12.RC1 ReleaseCandidate
2022.04.06  Version 1.12 released
2022.05.11  Version 1.12.2 released
2022.05.19  Version 1.12.3 released
2022.09.30  Version 1.13.0 ReleaseCandidate
2022.10.28  Version 1.13.0 Released
2023.01.06  Version 1.13.1 Released
2024.06.14  Version 1.14.0 Released
2024.06.20  Version 1.14.1 Released
2024.06.21  Version 1.14.2 Released
2025.02.06  Version 1.15.RC ReleaseCandidate
2025.03.07  Version 1.15.1 Released.
2025.03.20  Version 1.15.2 Released.
2025.10.14  Version 1.16.RC ReleaseCandidate.
2025.11.10  Version 1.16.1 Released.
2026.01.15  Version 1.17.RC ReleaseCandidate.



5.0 Your feedback
-----------------
Please post your comments and feedback to:
    support@nemhandel.dk

Thanks!
