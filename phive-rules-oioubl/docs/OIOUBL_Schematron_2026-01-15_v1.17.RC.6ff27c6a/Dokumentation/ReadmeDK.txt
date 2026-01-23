ReadmeDK.txt
Revideret - 1.17.RC = (15.01.2026).



OIOUBL-2.1 schematron validerings-stylesheets
----------------------------------------------


1.0 Anvendelse
--------------
Anvendes til at validere om XML eksempelfil overholder reglerne i OIOUBL subset.
Følgende OIOUBL dokumenttyper kan valideres:
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

Et dokument, f.eks. en faktura, kan valideres således:
msxsl.exe <XML dokument filnavn> OIOUBL_Invoice_Schematron.xsl -o resultat.xml

Hvis fakturaen validerer OK skrives alene en overskrift til resultat.xml, ellers listes alle fundne fejl.


2.0 Forudsætninger
------------------
Det forudsættes at eksempelfilen er valideret korrekt med det tilhørende UBL-2.1 XSD schema inden schematron stylesheetet anvendes.


3.0 Release Notes
-----------------
Schematron ændringer fra 1.14.2 til 1.15.RC
- UAN-3872: I UTS er der kun tilladt at benytte CustomizationID" = OIOUBL-2.1"
- UAN-2871: Opdatering af validering profile-id version i UTS
- UAN-5080: Opdatering af kodelister for landekoder og valutakoder. Nye værdier tilføjet.
- UAN-4610: Standardisering af OIOUBL 2.1 kodeliste schematron-filer
- UAN-5139: Opstramning af momsvalidering.
            F-LIB400: Validerer om TaxSubtotal/TaxAmount og moms procent på linjer = 0, når der er tale om ZeroRated
            F-LIB401: Validerer om TaxSubtotal/TaxAmount på linjer er korrekt beregnet for moms procent > 0 % og StandardRated (inkl. accepteret tolerance +/- 1.00)
            F-LIB402: Validerer om TaxableAmount på hoved niveau er lig med summen fra linjerne (inkl. accepteret tolerance +/- 1.00)

Schematron ændringer fra 1.15.RC til 1.15.1
- UAN-5554: F-LIB189 er rettet, da den oprindelige test kunne føre til falske positive, hvor ugyldige @schemeID-værdier blev accepteret.

Schematron ændringer fra 1.15.1 til 1.15.2
- NHD-65: F-LIB401 er rettet, så den er 100% XSLT 2.0-kompatibel.

Schematron ændringer fra 1.15.2 til 1.16.RC
- NHD-297: F-LIB403: validerer at Amount/@currencyID er en gyldig valuta.
- NHD-292: Opstramning af emissionsdata (AdditionalItemProperty)
           OIOUBL-Common-GP004: Hvis AdditionalItemProperty/Name = EmissionFactor, skal AdditionalItemProperty/Value være en gyldig numerisk værdi
           OIOUBL-Common-GP005: Hvis AdditionalItemProperty/Name = NetEmissionQuantity, skal Value være lig EmissionFactor × Quantity. Quantity er enten InvoicedQuantity eller CreditedQuantity (afhængigt af hvad der er udfyldt).
           OIOUBL-Common-GP006: Hvis AdditionalItemProperty/Name = EmissionFactorSource, skal Value være 'Database' eller 'Internal'.
           OIOUBL-Common-GP007: Hvis AdditionalItemProperty/Name = EmissionFactor, skal der også findes en anden AdditionalItemProperty med Name = 'EmissionFactorSource'.
           OIOUBL-Common-GP008: Hvis AdditionalItemProperty/Name = EmissionFactorCalculationUnit, skal Value være en gyldig UnitCode fra kodelisten UNECERec20-11e (https://oioubl-demo.nemhandel.dk/oioubl/kodelister/UnitCode-3.0.html).
           OIOUBL-Common-GP009: Hvis AdditionalItemProperty/Name = CalculationRate, skal Value være en gyldig numerisk værdi.

Schematron ændringer fra 1.16.RC til 1.16.1
- NHD-338: OIOUBL-Common-GP008: er rettet til at bruge en ældre version af UN/ECE (urn:un:unece:uncefact:codelist:specification:66411:2001) så den benytter den samme som i W-LIB008.
           W-LIB008: Fejlbeskrivelsen er blevet opdateret, så den nu indeholder navnet på kodelisten: urn:un:unece:uncefact:codelist:specification:66411:2001.

Schematron ændringer fra 1.16.1 til 1.17.RC
- NHD-336: F-LIB404: Validerer at alle afgiftstypekoder (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID) angivet på linjeniveau også eksisterer i dokument-niveau opsummeringen, og vice versa.
- NHD-348: Tilføjer en ny kodeliste: urn:oioubl:id:taxcategoryid-1.4. Den indeholder samme indhold som tidligere version, men med tilføjelserne B,M,L,K,O,G fra kodelisten: UNCL5305
- NHD-364: F-LIB403 opdateres, så den ikke kun validerer cbc:Amount, men i stedet tjekker alle felter, hvor elementnavnet slutter på Amount.

4.0 Revisionslog
----------------
2016.09.15  Version 1.8.0 frigivet.
2017.09.15  Version 1.9.0 frigivet.
2018.09.15  Version 1.10.0 frigivet.
2019.04.08  Version 1.11.1 frigivet.
2022.01.15  Version 1.12.DEV betaversion
2022.03.10  Version 1.12.RC1 ReleaseCandidate
2022.04.06  Version 1.12 frigivet
2022.05.11  Version 1.12.2 frigivet
2022.05.19  Version 1.12.3 frigivet
2022.09.30  Version 1.13.0.RC1 Release Candidate
2022.10.28  Version 1.13.0 frigivet.
2023.01.06  Version 1.13.1 frigivet.
2023.01.18  Version 1.13.2 frigivet.
2024.06.14  Version 1.14.0 frigivet.
2024.06.20  Version 1.14.1 frigivet.
2024.06.21  Version 1.14.2 frigivet.
2025.02.06  Version 1.15.RC Release Candidate.
2025.03.07  Version 1.15.1 frigivet.
2025.03.20  Version 1.15.2 frigivet.
2025.10.14  Version 1.16.RC Release Candidate.
2025.11.10  Version 1.16.1 frigivet.
2026.01.15  Version 1.17.RC Release Candidate.

5.0 Rapportering af fejl og mangler etc.
----------------------------------------
Information om fejl, mangler, og andet relevant, sendes til:
    support@nemhandel.dk

På forhånd tak!
