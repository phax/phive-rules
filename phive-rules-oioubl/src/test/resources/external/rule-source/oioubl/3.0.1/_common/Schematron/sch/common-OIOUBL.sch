<pattern
        xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

        <title>Danish OIOUBL 3 - Common</title>


        <rule
                context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0184'] | cbc:EndpointID[@schemeID eq '0184'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0184']">
                <assert id="OIOUBL-COMMON-001" test="matches(normalize-space(), '^\d{8}$')"
                        flag="fatal">The DK:CVR (0184) must be stated in the correct format (8
                        digits) - Value found: '<value-of select="."/>' </assert>
        </rule>

        <rule
                context="cac:AdditionalDocumentReference/cbc:ID[@schemeID eq 'ARR']">
                <assert
                        id="OIOUBL-COMMON-002"
                        flag="fatal"
                        test="(matches(normalize-space(.), '^\d{10}$')) and (../cbc:DocumentTypeCode eq '130')"> When 'cac:AdditionalDocumentReference/cbc:ID schemaID' equals 'ARR' The
                        value in ID must equal 10 digits - Value found: '<value-of
                                select="."/>' The
                        value in DocumentTypeCode must equal '130' - Value found: '<value-of
                                select="../cbc:DocumentTypeCode"/>' </assert>
        </rule>

        <rule
                context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0096'] | cbc:EndpointID[@schemeID eq '0096'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0096']">
                <assert id="OIOUBL-COMMON-003" test="matches(normalize-space(), '^\d{10}$')"
                        flag="fatal">The DK:P (0096) value must be stated in the correct format (10
                        digits) - Value found: '<value-of select="."/>' </assert>
        </rule>


        <rule
                context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0198'] | cbc:EndpointID[@schemeID eq '0198'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0198'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0198']">
                <assert id="OIOUBL-COMMON-004" test="matches(normalize-space(), '^DK\d{8}$')"
                        flag="fatal">The DK:SE (0198) value must be stated in the correct format (DK
                        followed by 8 digits) - Value found: '<value-of select="."/>' </assert>
        </rule>

        <rule
                context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0237'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0237'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0237']">
                <assert id="OIOUBL-COMMON-013" test="matches(normalize-space(), '^\d{10}$')"
                        flag="fatal">The DK:CPR (0237)value must be stated in the correct format (10
                        digits) - Value found: '<value-of select="."/>' </assert>
        </rule>

        <rule
                context="cbc:UUID">
                <assert
                        id="OIOUBL-COMMON-005"
                        test="matches(., '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')"
                        flag="fatal">The element must contain a valid UUID - Value found: '<value-of
                                select="."/>' </assert>

        </rule>

        <rule
                context="ext:UBLExtensions">
                <assert
                        id="OIOUBL-COMMON-006"
                        test="
                                ext:UBLExtension/ext:ExtensionAgencyID = 'ERST'
                                and (number(ext:UBLExtension/cbc:ID) &gt;= 1001 and number(ext:UBLExtension/cbc:ID) &lt;= 1999)"
                        flag="fatal">Invalid UBLExtension/ID when UBLExtension/ExtensionAgencyID is
                        equal to 'ERST'. ID must be an assigned value between '1001' and '1999' -
                        Value found: '<value-of
                                select="ext:UBLExtension/cbc:ID"/>'</assert>
        </rule>

        <rule
                context="cbc:SequenceNumeric">
                <assert
                        id="OIOUBL-COMMON-007"
                        test="not(starts-with(., '-'))"
                        flag="fatal">SequenceNumeric must not be negative - Value found: '<value-of
                                select="."/>' </assert>
        </rule>

        <rule
                context="cac:Address | cac:DespatchAddress | cac:JurisdictionRegionAddress | cac:OriginAddress | cac:PostalAddress | cac:RegistrationAddress | cac:ReturnAddress">
                <assert
                        id="OIOUBL-COMMON-008"
                        test="count(./cbc:CityName) = 1 and count(./cbc:PostalZone) = 1"
                        flag="fatal">CityName AND PostalZone MUST be present.</assert>

                <assert
                        id="OIOUBL-COMMON-009"
                        test="
                                count(./cbc:Postbox) = 1 or
                                (count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)"
                        flag="fatal">IF Postbox does not exist, StreetName AND BuildingNumber MUST be present.</assert>

                <assert
                        id="OIOUBL-COMMON-010"
                        test="
                                count(./cbc:Floor) = 0 or
                                (count(./cbc:Floor) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)"
                        flag="fatal">IF Floor is present, StreetName and BuildingNumber MUST be present.</assert>

                <assert
                        id="OIOUBL-COMMON-011"
                        test="
                                count(./cbc:Room) = 0 or
                                (count(./cbc:Room) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)"
                        flag="fatal">IF Room is present, StreetName and BuildingNumber MUST be present.</assert>

                <assert
                        id="OIOUBL-COMMON-012"
                        test="
                                (count(./cbc:BuildingNumber) = 0 and count(./cbc:StreetName) = 0) or
                                (count(./cbc:BuildingNumber) = 1 and count(./cbc:StreetName) = 1)"
                        flag="fatal">IF BuildingNumber is present, StreetName MUST be present. IF StreetName is present, BuildingNumber MUST be present.</assert>
        </rule>

        <rule
                context="cac:AllowanceCharge">

                <assert
                        id="OIOUBL-COMMON-150"
                        test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or cbc:AllowanceChargeReason"
                        flag="fatal">When AllowanceChargeReasonCode = ZZZ is used, then AllowanceChargeReason must be present</assert>


                <assert
                        id="OIOUBL-COMMON-014"
                        test="
                                not(cbc:AllowanceChargeReasonCode = 'ZZZ') or
                                ((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#')
                                and not(starts-with(cbc:AllowanceChargeReason, '#'))
                                and not(ends-with(cbc:AllowanceChargeReason, '#'))))"
                        flag="fatal">AllowanceChargeReason must include a #, but the # is not allowed as first and last character
                </assert>
        </rule>

        <rule
                context="cac:AccountingSupplierParty">

                <assert
                        id="OIOUBL-COMMON-102"
                        test="
                                not(cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID = '0237'])
                                or (ancestor::*/cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:billing_private_without_response:3')"
                        flag="fatal">SchemaID = '0237' is only allowed when ProfileID='urn:fdc:oioubl.dk:bis:billing_private_without_response:3'</assert>


        </rule>


        <rule
                context="cac:InvoiceLine | cac:CreditNoteLine">

                <assert
                        id="OIOUBL-COMMON-103"
                        test="count(cac:Item/cac:ManufacturersItemIdentification) &lt;= 1"
                        flag="fatal">No more than one ManufacturersItemIdentification class may be present</assert>

                <assert
                        id="OIOUBL-COMMON-104"
                        test="
                        not(cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID) or (some $val in $PackagingMarkedLabelAccreditationCode
                        satisfies (cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID = $val))"
                        flag="fatal">The value of CertificateTypeCode must be one of the PackagingMarkedLabelAccreditationCode from GS1 Global Data Dictionary - Value found: '<value-of
                                select="cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID"/>' </assert>

        </rule>

        <rule
                context="cac:Party">
                <assert
                        id="OIOUBL-COMMON-100"
                        test="cac:PartyLegalEntity"
                        flag="fatal">The element 'PartyLegalEntity' is mandatory in the 'Party'</assert>
                <assert
                        id="OIOUBL-COMMON-101"
                        test="cac:PartyLegalEntity/cbc:CompanyID"
                        flag="fatal">The element 'CompanyID' is mandatory in the 'PartyLegalEntity'</assert>
                <assert
                        id="OIOUBL-COMMON-106"
                        test="count(./cac:PartyName/cbc:Name) = 1"
                        flag="fatal">cac:Party/cac:PartyName/cbc:Name must be present.</assert>
                <assert
                        id="OIOUBL-COMMON-107"
                        test="count(./cac:PartyLegalEntity) = 1"
                        flag="fatal">cac:Party/cac:PartyLegalEntity must be present.</assert>
                <assert
                        id="OIOUBL-COMMON-108"
                        test="count(./cac:PartyLegalEntity/cbc:CompanyID) = 1"
                        flag="fatal">cac:Party/cac:PartyLegalEntity/cbc:CompanyID must be present.</assert>
        </rule>

        <rule
                context="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
                <assert
                        id="OIOUBL-COMMON-105"
                        test="count(./cbc:ID) = 1"
                        flag="fatal">cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID must be present.</assert>
        </rule>

        <rule
                context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme | cac:TaxRepresentativeParty/cac:PartyTaxScheme">
                <assert
                        id="OIOUBL-COMMON-109"
                        test="cbc:CompanyID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')"
                        flag="fatal">cac:PartyTaxScheme/cbc:CompanyID must be present when cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID differ from 'O'.</assert>
                <assert
                        id="OIOUBL-COMMON-110"
                        test="cac:TaxScheme/cbc:ID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')"
                        flag="fatal">cac:PartyTaxScheme/cac:TaxScheme/cbc:ID mmust be present when cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID differ from 'O'.</assert>
        </rule>

        <rule
                context="cac:Party/cbc:EndpointID">
                <assert
                        id="OIOUBL-COMMON-111"
                        test="@schemeID"
                        flag="fatal">cac:Party/cbc:EndpointID must have a @schemeID attribute.</assert>
        </rule>

        <rule
                context="cac:Party/cac:PartyIdentification/cbc:ID">
                <assert
                        id="OIOUBL-COMMON-112"
                        test="@schemeID"
                        flag="fatal">cac:Party/cac:PartyIdentification/cbc:ID must have a @schemeID attribute.</assert>
        </rule>

        <rule
                context="cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
                <assert
                        id="OIOUBL-COMMON-113"
                        test="@schemeID"
                        flag="fatal">cac:Party/cac:PartyLegalEntity/cbc:CompanyID must have a @schemeID attribute.</assert>
        </rule>

        <rule
                context="cac:PartyTaxScheme/cbc:CompanyID">
                <assert
                        id="OIOUBL-COMMON-114"
                        test="@schemeID"
                        flag="fatal">cac:PartyTaxScheme/cbc:CompanyID must have a @schemeID attribute.</assert>
                <assert
                        id="OIOUBL-COMMON-115"
                        test="
                                some $code in $DK-ISO-6523-ICD
                                        satisfies @schemeID = $code"
                        flag="fatal">@schemeID must be in ISO 6523 ICD code list or have the special DK value 'ZZZ'</assert>
        </rule>

        <rule
                context="cac:Signature">
                <assert
                        id="OIOUBL-COMMON-116"
                        test="count(./cac:DigitalSignatureAttachment) = 1"
                        flag="fatal">The element 'DigitalSignatureAttachment' is mandatory in 'Signature'</assert>
                <assert
                        id="OIOUBL-COMMON-117"
                        test="count(./cac:OriginalDocumentReference) = 1"
                        flag="fatal">The element 'OriginalDocumentReference' is mandatory in 'Signature'</assert>
                <assert
                        id="OIOUBL-COMMON-118"
                        test="count(./cac:SignatoryParty) = 1"
                        flag="fatal">The element 'SignatoryParty' is mandatory in 'Signature'</assert>
                <assert
                        id="OIOUBL-COMMON-119"
                        test="count(./cbc:CanonicalizationMethod) = 1"
                        flag="fatal">The element 'CanonicalizationMethod' is mandatory in 'Signature'</assert>
                <assert
                        id="OIOUBL-COMMON-120"
                        test="count(./cbc:SignatureMethod) = 1"
                        flag="fatal">The element 'SignatureMethod' is mandatory in 'Signature'</assert>
        </rule>

        <rule
                context="cac:ActivityPeriod | cac:ApplicablePeriod | cac:ConstitutionPeriod | cac:ContractAcceptancePeriod | cac:ContractFormalizationPeriod | cac:DeliveryPeriod | cac:DocumentAvailabilityPeriod | cac:DurationPeriod | cac:EffectivePeriod | cac:EstimatedDeliveryPeriod | cac:EstimatedDespatchPeriod | cac:EstimatedDurationPeriod | cac:EstimatedTransitPeriod | cac:ExceptionObservationPeriod | cac:ForecastPeriod | cac:FrequencyPeriod | cac:InventoryPeriod | cac:InvitationSubmissionPeriod | cac:InvoicePeriod | cac:LineValidityPeriod | cac:MainPeriod | cac:NominationPeriod | cac:NotificationPeriod | cac:OptionValidityPeriod | cac:ParticipationRequestReceptionPeriod | cac:PaymentReversalPeriod | cac:PenaltyPeriod | cac:Period | cac:PlannedPeriod | cac:PresentationPeriod | cac:PromisedDeliveryPeriod | cac:ReminderPeriod | cac:RequestedDeliveryPeriod | cac:RequestedDespatchPeriod | cac:RequestedStatusPeriod | cac:RequestedValidityPeriod | cac:ServiceEndTimePeriod | cac:ServiceStartTimePeriod | cac:SettlementPeriod | cac:StatementPeriod | cac:StatusPeriod | cac:TenderSubmissionDeadlinePeriod | cac:TenderValidityPeriod | cac:TransitPeriod | cac:TransportServiceProviderResponseDeadlinePeriod | cac:TransportServiceProviderResponseRequiredPeriod | cac:TransportUserResponseRequiredPeriod | cac:UsabilityPeriod | cac:ValidityPeriod | cac:WarrantyValidityPeriod">
                <!-- The first clauses of this test are guards to ensure that we will not
                get a type conversion error when applying the schematron. The test proper is in the last clause. -->
                <assert
                        id="OIOUBL-COMMON-121"
                        test="
                                not(matches(./cbc:StartDate, '^\d{4}-\d{2}-\d{2}$'))
                                or not(matches(./cbc:StartTime, '^\d{2}:\d{2}:\d{2}$'))
                                or not(matches(./cbc:EndDate, '^\d{4}-\d{2}-\d{2}$'))
                                or not(matches(./cbc:EndTime, '^\d{2}:\d{2}:\d{2}$'))
                                or not(xs:dateTime(concat(./cbc:StartDate, 'T', ./cbc:StartTime)) gt xs:dateTime(concat(./cbc:EndDate, 'T', ./cbc:EndTime)))"
                        flag="fatal">StartDate + StartTime must be before or the same as EndDate + EndTime</assert>
                <assert
                        id="OIOUBL-COMMON-122"
                        test="count(./cbc:StartTime) = 0 or (count(./cbc:StartDate) = 1 and count(./cbc:StartTime) = 1)"
                        flag="fatal">If StartTime exists, StartDate must be present</assert>
                <assert
                        id="OIOUBL-COMMON-123"
                        test="count(./cbc:EndTime) = 0 or (count(./cbc:EndDate) = 1 and count(./cbc:EndTime) = 1)"
                        flag="fatal">If EndTime exists, EndDate must be present</assert>
        </rule>

        <rule
                context="cbc:StartTime | cbc:EndTime">
                <assert
                        id="OIOUBL-COMMON-124"
                        test="matches(., '^\d{2}:\d{2}:\d{2}$')"
                        flag="fatal">IF StartTime exists or EndTime exists, format must follow time format (without date format)</assert>
        </rule>

        <rule
                context="cac:Contact">
                <assert
                        id="OIOUBL-COMMON-125"
                        test="not(matches(./cbc:ID, '^\d{6}-?\d{4}$'))"
                        flag="fatal">ID must not be a CPR number (must not have format XXXXXXXXXX or XXXXXX-XXXX)</assert>
                <assert
                        id="OIOUBL-COMMON-126"
                        test="matches(./cbc:Telephone, '^(?:\+|00).*$')"
                        flag="fatal">Telephone must include country code (must start with '+' or '00')</assert>
                <assert
                        id="OIOUBL-COMMON-127"
                        test="matches(./cbc:ElectronicMail, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$')"
                        flag="fatal">ElectronicMail must have valid format (like 'user123@example.com')</assert>
        </rule>

        <rule
                context="cac:Attachment">
                <assert
                        id="OIOUBL-COMMON-128"
                        test="not(count(./cbc:EmbeddedDocumentBinaryObject) = 1 and count(./cac:ExternalReference) = 1)"
                        flag="fatal">Must not have both embedded document and external reference.</assert>
        </rule>

        <rule
                context="cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
                <assert
                        id="OIOUBL-COMMON-129"
                        test="@filename"
                        flag="fatal">EmbeddedDocumentBinaryObject must have filename attribute</assert>
                <assert
                        id="OIOUBL-COMMON-130"
                        test="
                                some $code in $OpenPEPPOL-IANA-MimeCode
                                        satisfies @mimeCode = $code"
                        flag="fatal">Attribute mimeCode must be a value from the code list</assert>
        </rule>

        <rule
                context="cac:Attachment/cac:ExternalReference">
                <assert
                        id="OIOUBL-COMMON-131"
                        test="matches(./cbc:URI, '^.+$')"
                        flag="fatal">When using ExternalReference, URI is mandatory</assert>
                <assert
                        id="OIOUBL-COMMON-132"
                        test="
                                (count(./cbc:DocumentHash) = 1 and count(./cbc:HashAlgorithmMethod) = 1)
                                or (count(./cbc:DocumentHash) = 0 and count(./cbc:HashAlgorithmMethod) = 0)"
                        flag="fatal">If DocumentHash or HashAlgorithmMethod is present, the other must also be present.</assert>
                <assert
                        id="OIOUBL-COMMON-133"
                        test="
                                (count(./cbc:ExpiryTime) = 1 and count(./cbc:ExpiryDate) = 1)
                                or count(./cbc:ExpiryTime) = 0"
                        flag="fatal">If ExpiryTime is present, ExpiryDate MUST be present</assert>
        </rule>

        <rule
                context="cac:DocumentReference">
                <assert
                        id="OIOUBL-COMMON-134"
                        test="
                                (count(./cbc:IssueTime) = 1 and count(./cbc:IssueDate) = 1)
                                or count(./cbc:IssueTime) = 0"
                        flag="fatal">If IssueTime is present, IssueDate must be present</assert>
        </rule>



        <rule
                context="cac:TaxExchangeRate | cac:PricingExchangeRate | cac:PaymentExchangeRate | cac:PaymentAlternativeExchangeRate">

                <assert
                        id="OIOUBL-COMMON-140"
                        test="cbc:CalculationRate &gt; 0 and matches(cbc:CalculationRate, '^[0-9]+(\.[0-9]{4})?$')"
                        flag="fatal">CalculationRate must be greater than zero and have exactly 4 decimal places - Value found:  <value-of select="cbc:CalculationRate"/> </assert>

                <assert
                        id="OIOUBL-COMMON-141"
                        test="cbc:MathematicOperatorCode = 'multiply' or cbc:MathematicOperatorCode = 'divide'"
                        flag="fatal">MathematicOperatorCode must be either 'multiply' or 'divide'</assert>
        </rule>



      
       <!-- *************************************

        Code lists

     *************************************   -->

        <let
                name="PackagingMarkedLabelAccreditationCode"
                value="tokenize('100_PERCENT_CANADIAN_MILK,100_PERCENT_VEGANSKT,3PMSF,ACMI,ADCCPA,AFIA_PET_FOOD_FACILITY,AGENCE_BIO,AGRI_CONFIANCE,AGRI_NATURA,AGRICULTURE_BIOLOGIQUE,AHAM,AISE,AISE_2005,AISE_2010,AISE_2020_BRAND,AISE_2020_COMPANY,AKC_PEACH_KOSHER,ALENTEJO_SUSTAINABILITY_PROGRAMME,ALIMENTATION_DU_TOUT_PETIT,ALIMENTS_BIO_PREPARES_AU_QUEBEC,ALIMENTS_DU_QUEBEC,ALIMENTS_DU_QUEBEC_BIO,ALIMENTS_PREPARES_AU_QUEBEC,ALPINAVERA,ALUMINIUM_GESAMTVERBAND_DER_ALUMINIUMINDUSTRIE,AMA_GENUSSREGION,AMA_ORGANIC_SEAL,AMA_ORGANIC_SEAL_BLACK,AMA_SEAL_OF_APPROVAL,AMERICAN_DENTAL_ASSOCIATION,AMERICAN_HEART_ASSOCIATION_CERTIFIED,ANIMAL_WELFARE_APPROVED_GRASSFED,AOP,APPELLATION_ORIGINE_CONTROLEE,APPROVED_BY_ASTHMA_AND_ALLERGY_ASSOC,AQUA_GAP,AQUACULTURE_STEWARDSHIP_COUNCIL,ARGE_GENTECHNIK_FREI,ARGENCERT,ARLA_FARMER_OWNED,ASCO,ASMI,ASTHMA_AND_ALLERGY_FOUNDATION_OF_AMERICA,ATG,AUS_KAUP_ESTONIA,AUSTRALIAN_CERTIFIED_ORGANIC,AUSTRIA_BIO_GARANTIE,AUSTRIAN_ECO_LABEL,BCARA_ORGANIC,BDIH_LOGO,BEBAT,BEDRE_DYREVELFAERD_1HEART,BEDRE_DYREVELFAERD_2HEART,BEDRE_DYREVELFAERD_3HEART,BEE_FRIENDLY,BELGAQUA,BENOR,BERCHTESGADENER_LAND,BEST_AQUACULTURE_PRACTICES,BEST_AQUACULTURE_PRACTICES_2_STARS,BEST_AQUACULTURE_PRACTICES_3_STARS,BEST_AQUACULTURE_PRACTICES_4_STARS,BETER_LEVEN_1_STER,BETER_LEVEN_2_STER,BETER_LEVEN_3_STER,BETTER_BUSINESS_BUREAU_ACCREDITED,BETTER_COTTON_INITIATIVE,BEVEG,BEWUSST_TIROL,BEWUSTE_KEUZE,BIKO_TIROL,BIO_AUSTRIA_LABEL,BIO_BAYERN_WITH_CERTIFICATE_PROVENANCE,BIO_BAYERN_WITHOUT_CERTIFICATE_PROVENANCE,BIO_BUD_SEAL,BIO_BUD_SEAL_TRANSITION,BIO_CZECH_LABEL,BIO_FISCH,BIO_GOURMET_BUD,BIO_LABEL_BADEN_WURTTENBERG,BIO_LABEL_GERMAN,BIO_LABEL_HESSEN,BIO_PARTENAIRE,BIO_RING_ALLGAEU,BIO_SOLIDAIRE,BIO_SUISSE_BUD_SEAL,BIO_SUISSE_BUD_SEAL_TRANSITION,BIOCHECKED_NON_GLYPHOSATE_CERTIFIED,BIOCHECKED_NON_GMO_VERIFIED,BIODEGRADABLE,BIODEGRADABLE_PRODUCTS_INSTITUTE,BIODYNAMIC_CERTIFICATION,BIODYNAMISCH,BIOGARANTIE,BIOKREIS,BIOLAND,BIOLAND_ENNSTAL,BIOPARK,BIOS_KONTROLLE,BIRD_FRIENDLY_COFFEE_SMITHSONIAN_CERTIFICATION,BK_CHECK_VAAD_HAKASHRUS_OF_BUFFALO,BLEU_BLANC_COEUR,BLUE_ANGEL,BLUE_RIBBON_KOSHER,BLUESIGN,BODEGAS_ARGENTINA_SUSTAINABILITY_PROTOCOL,BONSUCRO,BORD_BIA_APPROVED,BORD_BIA_APPROVED_MEAT,BRA_MILJOVAL_LABEL_SWEDISH,BRC_GLOBAL_STANDARDS,BREATHEWAY,BRITISH_DENTAL_HEALTH,BRITISH_RETAIL_CONSORTIUM_CERTIFICATION,BSCI,BULLFROG,CA_BEEF,CA_BOTH_DOM_IMPORT,CA_BULK,CA_CANNED,CA_DISTILLED,CA_IMPORT,CA_INGREDIENT,CA_MADE,CA_MUSTARD_SEEDS,CA_OATS,CA_PREPARED,CA_PROCESSED,CA_PRODUCT,CA_PROUD,CA_REFINED,CA_ROASTED_BLENDED,CAC_ABSENCE_EGG_MILK,CAC_ABSENCE_EGG_MILK_PEANUTS,CAC_ABSENCE_OF_ALMOND,CAC_ABSENCE_OF_EGG,CAC_ABSENCE_OF_MILK,CAC_ABSENCE_OF_PEANUT,CAC_ABSENCE_PEANUT_ALMOND,CAFE_PRACTICES,CAN_BNQ_CERTIFIED,CANADA_GAP,CANADIAN_AGRICULTURAL_PRODUCTS,CANADIAN_ASSOCIATION_FIRE_CHIEFS_APPROVED,CANADIAN_CERTIFIED_COMPOSTABLE,CANADIAN_DERMATOLOGY_ASSOCIATION_SKIN_HEALTH,CANADIAN_DERMATOLOGY_ASSOCIATION_SUN_PROTECTION,CARBON_FOOTPRINT_STANDARD,CARBON_NEUTRAL,CARBON_NEUTRAL_NCOS_CERTIFIED,CARBON_NEUTRAL_PACKAGING,CARIBBEAN_KOSHER,CCA_GLUTEN_FREE,CCC,CCF_RABBIT,CCOF,CCSW,CEBEC,CEL,CELIAC_SPRUE_ASSOCIATION,CENTRAL_RABBINICAL_CONGRESS_KOSHER,CERTIFIE_TERROIR_CHARLEVOIX,CERTIFIED_ANGUS_BEEF,CERTIFIED_B_CORPORATION,CERTIFIED_CARBON_FREE,CERTIFIED_HUMANE_ORGANISATION,CERTIFIED_NATURALLY_GROWN,CERTIFIED_OE_100,CERTIFIED_ORGANIC_BAYSTATE_ORGANIC_CERTIFIERS,CERTIFIED_ORGANIC_BY_ORGANIC_CERTIFIERS,CERTIFIED_PALEO,CERTIFIED_PALEO_FRIENDLY,CERTIFIED_PLANT_BASED,CERTIFIED_SUSTAINABLE_WINE_CHILE,CERTIFIED_WBENC,CERTIFIED_WILDLIFE_FRIENDLY,CFG_PROCESSED_EGG,CFIA,CFIA_DAIRY,CFIA_FISH,CFIA_GRADE_A,CFIA_GRADE_C,CFIA_ORGANIC,CFIA_UTILITY_POULTRY_EGG,CHASSEURS_DE_FRANCE,CHEESE_WORLD_CHAMPION_CHEESE_CONTEST,CHES_K,CHICAGO_RABBINICAL_COUNCIL,CINCINNATI_KOSHER,CLARO_FAIR_TRADE,CLIMATE_NEUTRAL,CLIMATE_NEUTRAL_PARTNER,CNG,CO2_REDUCERET_EMBALLAGE,CO2LOGIC_CO2_NEUTRAL_CERTIFIED,COCOA_HORIZONS,COCOA_LIFE,COMPOSTABLE_DIN_CERTCO,COMTE_GREEN_BELL,CONFORMITE_EUROPEENNE,CONSUMER_CHOICE_AWARD,COR_DETROIT,COR_KOSHER,CORRUGATED_RECYCLES,COSMEBIO,COSMEBIO_COSMOS_NATURAL,COSMEBIO_COSMOS_ORGANIC,COTTON_MADE_IN_AFRICA,CPE_SCHARREL_EIEREN,CPE_VRIJE_UITLOOP_EIEREN,CRADLE_TO_CRADLE,CROSSED_GRAIN_SYMBOL,CROWN_CHK,CRUELTY_FREE_PETA,CSA_INTERNATIONAL,CSA_NCA_GLUTEN_FREE,CSI,CULINARIUM,CULTIVUP_EXIGENCE,CULTIVUP_RESPONSABLE,CZECH_FOOD,DALLAS_KOSHER,DANSK_IP_KVALITET,DANSK_MAELK,DEBIO,DELINAT,DEMETER_LABEL,DESIGN_FOR_THE_ENVIRONMENT,DESIGN_FROM_FINLAND,DIAMOND_K,DIAMOND_KA_KASHRUT_AUTHORITY_OF_AUSTRALIA_AND_NZ,DIRECT_TRADE,DK_ECO,DLG_AWARD,DLG_CERTIFIED_ALLERGEN_MANAGEMENT ,DNV_BUSINESS_ASSURANCE,DOLPHIN_SAFE,DONAU_SOYA_STANDARD,DRP,DUURZAAM_VARKENSVLEES,DVF_VEGAN,DVF_VEGETARIAN,DYRENES_BESKYTTELSE,DZG_GLUTEN_FREE,EARTHKOSHER_KOSHER,EARTHSURE,ECARF_SEAL,ECO_KREIS,ECO_LABEL_CZECH,ECO_LABEL_LADYBUG,ECO_LOGO,ECOCERT_CERTIFICATE,ECOCERT_COSMOS_NATURAL,ECOCERT_COSMOS_ORGANIC,ECOCERT_ORGANIC,ECOGARANTIE,ECOLAND,ECOLOGO_CERTIFIED,ECOLOGO_CERTIFIED_2,ECOVIN,ECZEMA_SOCIETY_OF_CANADA,EESTI_OKOMARK,EESTI_PARIM_TOIDUAINE,EKO,ENEC,ENERGY_LABEL_A,ENERGY_LABEL_A+,ENERGY_LABEL_A++,ENERGY_LABEL_A+++,ENERGY_LABEL_B,ENERGY_LABEL_C,ENERGY_LABEL_D,ENERGY_LABEL_E,ENERGY_LABEL_F,ENERGY_LABEL_G,ENERGY_STAR,ENTREPRISE_DU_PATRIMOINE_VIVANT,ENTWINE_AUSTRALIA,EPA_DFE,EPEAT_BRONZE,EPEAT_GOLD,EPEAT_SILVER,EQUAL_EXCHANGE_FAIRLY_TRADED,EQUALITAS_SUSTAINABLE_WINE,ERDE_SAAT,ERKEND_STREEK_PRODUCT,ETP,EU_ECO_LABEL,EU_ENERGY_LABEL,EU_ORGANIC_FARMING,EUROPE_SOYA_STANDARD,EUROPEAN_V_LABEL_VEGAN,EUROPEAN_V_LABEL_VEGETARIAN,EUROPEAN_VEGETARIAN_UNION,EWG_VERIFIED,FAIR_FLOWERS_FAIR_PLANTS,FAIR_FOOD_PROGRAM_LABEL,FAIR_FOR_LIFE,FAIR_N_GREEN,FAIR_TRADE_MARK,FAIR_TRADE_USA,FAIR_TRADE_USA,FAIR_TRADE_USA_INGREDIENTS,FAIR_TSA,FAIRTRADE_CASHEW_NUTS,FAIRTRADE_COCOA,FAIRTRADE_COCONUT,FAIRTRADE_COTTON,FAIRTRADE_DRIED_APRICOTS,FAIRTRADE_GREEN_TEA,FAIRTRADE_HONEY,FAIRTRADE_LIME_JUICE,FAIRTRADE_MANGO_JUICE,FAIRTRADE_OLIVE_OIL,FAIRTRADE_PEPPER,FAIRTRADE_QUINOA,FAIRTRADE_RICE,FAIRTRADE_ROSES,FAIRTRADE_SUGAR,FAIRTRADE_TEA,FAIRTRADE_VANILLA,FALKEN,FCC,FEDERALLY_REGISTERED_INSPECTED_CANADA,FIDELIO,FINNISH_HEART_SYMBOL,FISH_WISE_CERTIFCATION,FLAMME_VERTE,FLANDRIA,FLEURS_DE_FRANCE,FODMAP,FODMAP_FRIENDLY,FOOD_ALLIANCE_CERTIFIED,FOOD_JUSTICE_CERTIFIED,FOOD_SAFETY_SYSTEM_CERTIFICATION_22000,FOODLAND_ONTARIO,FOR_LIFE,FOREST_PRODUCTS_Z809,FOREST_STEWARDSHIP_COUNCIL_100_PERCENT,FOREST_STEWARDSHIP_COUNCIL_LABEL,FOREST_STEWARDSHIP_COUNCIL_MIX,FOREST_STEWARDSHIP_COUNCIL_RECYCLED,FOUNDATION_ART,FRAN_SVERIGE,FRANCE_LIMOUSIN_MEAT,FREILAND,FRESHCARE,FRIEND_OF_THE_SEA,FRUITS_ET_LEGUMES_DE_FRANCE,GAEA,GANEDEN_BC30_PROBIOTIC,GAP_1,GAP_2,GAP_3,GAP_4,GAP_5,GAP_5_PLUS,GASKEUR,GASTEC,GCP,GEBANA,GENUSS_REGION_AUSTRIA,GENUSS_REGION_AUSTRIA,GEPRUEFTE_SICHERHEIT,GEZONDERE_KEUZE,GFCO,GFCO,GFCP,GIG_GLUTEN_FREE_FOODSERVICE,GLOBAL_CARE,GLOBAL_GAP,GLOBAL_ORGANIC_LATEX_STANDARD,GLOBAL_ORGANIC_TEXTILE_STANDARD,GLOBAL_RECYCLED_STANDARD,GLYCAMIC_INDEX_FOUNDATION,GLYCAMIC_RESEARCH_INSTITUTE,GMO_GUARD_FROM_NATURAL_FOOD_CERTIFIERS,GMO_MARKED,GMP_CERTIFIED,GMP_ISO_22716,GOA_ORGANIC,GODKAND_FOR_EKOLOGISK_ODLING_KRAV,GOOD_HOUSEKEEPING,GOODS_FROM_FINLAND_BLUE_SWAN,GOODWEAVE,GRASKEURMERK,GRASP,GREEN_AMERICA_CERTIFIED_BUSINESS,GREEN_DOT,GREEN_E_ENERGY_CERT,GREEN_E_ORG,GREEN_RESTAURANT_ASSOCIATION_ENDORSED,GREEN_SEAL,GREEN_SEAL_CERTIFIED,GREEN_SHIELD_CERTIFIED,GREEN_STAR_CERTIFIED,GREENCHOICE,GROEN_LABEL_KAS,GRUYERE_FRANCE,GUARANTEED_IRISH,HALAL_AUSTRALIA,HALAL_CERTIFICATION_SERVICES,HALAL_CERTIFICATION_SERVICES_CH,HALAL_CORRECT,HALAL_FOOD_COUNCIL_OF_SOUTH_EAST_ASIA_THAILAND,HALAL_HIC,HALAL_HPDS,HALAL_INDIA,HALAL_ISLAMIC_FOOD_CANADA,HALAL_ISLAMIC_SOCIETY_OF_NORTH_AMERICA,HALAL_PLUS,HAUTE_VALEUR_ENVIRONNEMENTALE,HAZARD_ANALYSIS_CRITICAL_CONTROL_POINT,HEALTH_CHECK,HEALTH_FOOD_BLUE_HAT_SIGN,HEUMILCH,HFAC_HUMANE,HMCA_HALAL_MONTREAL_CERTIFICATION_AUTHORITY,HOCHSTAMM_SUISSE,HOW_2_RECYCLE,HUMANE_HEARTLAND,HYPERTENSION_CANADA_MEDICAL_DEVICE,ICADA,ICEA,ICELAND_RESPONSIBLE_FISHERIES,ICS_ORGANIC,IFANCA_HALAL,IFOAM,IFS_HPC,IGP,IHTK_SEAL,IKB_EIEREN,IKB_KIP,IKB_VARKEN,INDEKLIMA_MAERKET,INSTITUT_FRESENIUS,INT_PROTECTION,INTEGRITY_AND_SUSTAINABILITY_CERTIFIED,INTERNATIONAL_ALOE_SCIENCE_COUNCIL_CERTIFICATE,INTERNATIONAL_KOSHER_COUNCIL,INTERNATIONAL_TASTE_QUALITY,INTERTEK_CERTIFICATE,INTERTEK_ETL,IP_SUISSE,ISCC,ISCC_SUPPORTING_THE_BIOECONOMY,ISEAL_ALLIANCE,ISO_QUALITY,IVN_NATURAL_LEATHER,IVN_NATURAL_TEXTILES_BEST,IVO_OMEGA3,JAS_ORGANIC,JAY_KOSHER_PAREVE,JODSALZ_BZGA,KABELKEUR,KAGFREILAND,KEHILLA_KOSHER_CALIFORNIA_K,KEHILLA_KOSHER_HEART_K,KEMA_KEUR,KIWA,KLASA,KOF_K_KOSHER,KOMO,KOSHER_AUSTRALIA,KOSHER_BDMC,KOSHER_CERTIFICATION_SERVICE,KOSHER_CHECK,KOSHER_CHICAGO_RABBINICAL_COUNCIL_DAIRY,KOSHER_CHICAGO_RABBINICAL_COUNCIL_PAREVE,KOSHER_COR_DAIRY,KOSHER_COR_DAIRY_EQUIPMENT,KOSHER_COR_FISH,KOSHER_EIDAH_HACHAREIDIS,KOSHER_GRAND_RABBINATE_OF_QUEBEC_PARVE,KOSHER_GREECE,KOSHER_INSPECTION_SERVICE_INDIA,KOSHER_KW_YOUNG_ISRAEL_OF_WEST_HEMPSTEAD,KOSHER_MADRID_SPAIN,KOSHER_OK_DAIRY,KOSHER_ORGANICS,KOSHER_ORTHODOX_JEWISH_CONGREGATION_PARVE,KOSHER_OTTAWA_VAAD_HAKASHRUT_CANADA,KOSHER_PARVE_BKA,KOSHER_PARVE_NATURAL_FOOD_CERTIFIER,KOSHER_PERU,KOSHER_RAV_LANDAU,KOSHER_STAR_K_PARVE,KOSHER_STAR_K_PARVE_PASSOVER,KOSHER_STAR_S_P_KITNIYOT,KOSHERMEX,KOTT_FRAN_SVERIGE,KRAV_MARK,KSA_KOSHER,KSA_KOSHER_DAIRY,KVBG_APPROVED,LAATUVASTUU,LABEL_OF_THE_ALLERGY_AND_ASTHMA_FEDERATION,LABEL_ROUGE,LACON,LAENDLE_QUALITAET,LAIT_COLLECTE_ET_CONDITIONNE_EN_FRANCE,LAIT_COLLECTE_ET_TRANSFORME_EN_FRANCE,LAPIN_DE_FRANCE,LE_PORC_FRANCAIS,LEAPING_BUNNY,LEGUMES_DE_FRANCE,LETIS_ORGANIC,LGA,LOCALIZE,LODI_RULES_CODE,LONDON_BETH_DIN_KOSHER,LOODUSSOBRALIK_TOODE_ESTONIA,LOVE_IRISH_FOOD,LVA,MADE_GREEN_IN_ITALY,MADE_IN_FINLAND_FLAG_WITH_KEY,MADE_OF_PLASTIC_BEVERAGE_CUPS,MADE_WITH_CANADIAN_BEEF,MAITRE_ARTISAN,MARINE_STEWARDSHIP_COUNCIL_LABEL,MAX_HAVELAAR,MCIA_ORGANIC,MEHR_WEG,MIDWEST_KOSHER,MILIEUKEUR,MINNESOTA_KOSHER_COUNCIL,MJOLK_FRAN_SVERIGE,MOMS_CHOICE_AWARD,MONTREAL_VAAD_HAIR_MK_PAREVE,MORTADELLA_BOLOGNA,MPS_A,MUNDUSVINI_GOLD,MUNDUSVINI_SILVER,MUSLIM_JUDICIAL_COUNCIL_HALAAL_TRUST,MY_CLIMATE,NAOOA_CERTIFIED_QUALITY,NASAA_CERTIFIED_ORGANIC,NATRUE_LABEL,NATURA_BEEF,NATURA_VEAL,NATURE_CARE_PRODUCT,NATURE_ET_PROGRES,NATUREPLUS,NATURLAND,NATURLAND_FAIR_TRADE,NATURLAND_WILDFISH,NC_NATURAL_COSMETICS_STANDARD,NC_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NC_VEGAN_NATURAL_COSMETICS,NC_VEGAN_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NCA_GLUTEN_FREE,NDOA,NEA,NEULAND,NEW_ZEALAND_SUSTAINABLE_WINEGROWING,NF_MARQUE,NFCA_GLUTEN_FREE,NIX18,NMX,NOM,NON_GMO_BY_EARTHKOSHER,NON_GMO_PROJECT,NPA,NSF,NSF_CERTIFIED_FOR_SPORT,NSF_GLUTEN_FREE,NSF_NON_GMO_TRUE_NORTH,NSF_SUSTAINABILITY_CERTIFIED,NSM,NYCKELHALET,OCEAN_WISE,OCIA,OCQV_ORGANIC,OECD_BIO_INGREDIENTS,OEKO_CONTROL,OEKO_KREISLAUF,OEKO_QUALITY_GUARANTEE_BAVARIA,OEKO_TEX_LABEL,OEKO_TEX_MADE_IN_GREEN,OEUFS_DE_FRANCE,OFF_ORGANIC,OFFICIAL_ECO_LABEL_SUN,OFG_ORGANIC,OHNE_GEN_TECHNIK,OK_COMPOST_HOME,OK_COMPOST_INDUSTRIAL ,OK_COMPOST_VINCOTTE,OK_KOSHER,OKOTEST,ON_THE_WAY_TO_PLANETPROOF,ONE_PERCENT_FOR_THE_PLANET,ONTARIO_APPROVED,ONTARIO_PORK,ORB,ORBI,OREGON_KOSHER,OREGON_LIVE,OREGON_TILTH,ORGANIC_100_CONTENT_STANDARD,ORGANIC_COTTON,ORGANIC_TRADE_ASSOCIATION,ORIGIN_OF_EGGS,ORIGINE_FRANCE_GARANTIE,ORTHODOX_UNION,OTCO_ORGANIC,OU_KOSHER,OU_KOSHER_DAIRY,OU_KOSHER_FISH,OU_KOSHER_MEAT,OU_KOSHER_PASSOVER,OZONE_FRIENDLY_GENERAL_CLAIM,PACS_ORGANIC,PALEO_APPROVED,PALEO_BY_EARTHKOSHER,PARENT_TESTED_PARENT_APPROVED,PAVILLON_FRANCE,PCO,PEFC,PEFC_CERTIFIED,PEFC_RECYCLED,PET_TO_PET,PGI_CNIPA,PGI_GAQSIQ,PGI_MARA,PGI_TO_SAIC,PLASTIC_FREE_TRUST_MARK,PLASTIC_IN_FILTER_TOBACCO,PLASTIC_IN_PRODUCT_BEVERAGE_CUPS,PLASTIC_IN_PRODUCT_TAMPONS,PLASTIC_IN_PRODUCT_WIPES_SANITARY_PADS,PLASTIC_NEUTRAL,POMMES_DE_TERRES_DE_FRANCE,PREGNANCY_WARNING,PRO_SPECIE_RARA,PRO_TERRA_NON-GMO_CERTIFICATION,PROCERT_ORGANIC,PRODERM,PRODUCT_OF_THE_YEAR_CONSUMER_SURVEY,PRODUIT_EN_BRETAGNE,PROTECTED_DESIGNATION_OF_ORIGIN,PROTECTED_GEOGRAPHICAL_INDICATION,PROTECTED_HARVEST_CERTIFIED,PROVEN_QUALITY_BAVARIA,PUHTAASTI_KOTIMAINEN,QAI,QCS_ORGANIC,QS,QS_PRODUCTION_PERMIT,QUALENVI,QUALITAET_TIROL,QUALITY_CONFORMANCE_MARKING_CN,QUALITY_MARK_IRELAND,QUALITY_RHOEN,RABBINICAL_COUNCIL_OF_BRITISH_COLUMBIA,RABBINICAL_COUNCIL_OF_CALIFORNIA_(RCC),RABBINICAL_COUNCIL_OF_NEW_ENGLAND,RAINFOREST_ALLIANCE,RAINFOREST_ALLIANCE_PEOPLE_NATURE,RAL_QUALITY_CANDLES,REAL_CALIFORNIA_CHEESE,REAL_CALIFORNIA_MILK,REAL_FOOD_SEAL,RECUPEL,RECYCLABLE_GENERAL_CLAIM,REGIONAL_FOOD_CZECH,REGIONALFENSTER,REGIONALTHEKE_FRANKEN,RETURNABLE_PET_BOTTLE_NL,RHP,ROQUEFORT_RED_EWE,ROUNDTABLE_ON_RESPONSIBLE_SOY,RSB,RUP_GUADELOUPE,RUP_GUYANE,RUP_MARTINIQUE,RUP_MAYOTTE,RUP_REUNION,RUP_SAINT_MARTIN,SA8000,SAFE_FEED_SAFE_FOOD,SAFE_QUALITY_FOOD,SAFER_CHOICE,SALMON_SAFE_CERTIFICATION,SALZBURGER_LAND_HERKUNFT,SCHARRELVLEES,SCHLESWIG_HOLSTEIN_QUALITY,SCROLL_K,SCS_RECYCLED_CONTENT_CERTIFICATION,SCS_SUSTAINABLY_GROWN,SEACHOICE,SFC_MEMBER_SEAL,SFC_MEMBER_SEAL_GOLD,SFC_MEMBER_SEAL_PLATINUM,SFC_MEMBER_SEAL_SILVER,SGS_ORGANIC,SHOPPER_ARMY,SIP,SKG_CERTIFICATE,SKG_CERTIFICATE_1_STAR,SKG_CERTIFICATE_2_STAR,SKG_CERTIFICATE_3_STAR,SLG_CHILD_SAFETY,SLG_TYPE_TESTED,SLK_BIO,SOCIETY_PLASTICS_INDUSTRY,SOIL_ASSOCIATION_ORGANIC_SYMBOL,SOIL_COSMOS_NATURAL,SOIL_ORGANIC_COSMOS,SOSTAIN,SPCA_BC,STAR_D_KOSHER,STAR_K_KOSHER,STEEL_RECYCLING,STELLAR_CERTIFICATION_SERVICES,STIFTUNG_WARENTEST,STOP_CLIMATE_CHANGE,STREEKPRODUCT_BE,STRICTLY_KOSHER_NORWAY,SUISSE_GARANTIE,SUNSHINE_STATE_KOSHER,SUOMEN_HAMMASLAAKARILIITTO_SUOSITTELEE_KSYLITOLIA,SUS,SUSTAINABLE_AUSTRALIA_WINEGROWING,SUSTAINABLE_AUSTRIA,SUSTAINABLE_FORESTRY_INITIATIVE,SUSTAINABLE_PALM_OIL_RSPO,SUSTAINABLE_PALM_OIL_RSPO_CREDITS,SUSTAINABLE_PALM_OIL_RSPO_MIXED,SVANEN,SVENSK_FAGEL,SVENSKT_KOTT,SVENSKT_SIGILL_KLIMATCERTIFIERAD,SVENSKT_SIGILL_NATURBETESKOTT,SWEDISH_SEAL_OF_QUALITY,SWISS_ALLERGY_LABEL,SWISS_ALPS_PRODUCT,SWISS_MOUNTAIN_PRODUCT,SWISSGAP,SWISSMILK_GREEN,SWISSPRIMGOURMET,TARNOPOL_KASHRUS_KOSHER,TCO_DEVELOPMENT,TCO_ORGANIC,TERRA_VITIS,TERRACYCLE,THE_FAIR_RUBBER_ASSOCIATION,THE_NATURAL_AND_ORGANIC_AWARDS,THREE_LINE_KOSHER,TIERSCHUTZBUND,TNO_APPROVED,TOOTHFRIENDLY,TRADITIONAL_SPECIALTY_GUARANTEED,TRIANGLE_K,TRIMAN,TRUE_FOODS_CANADA_TRUSTMARK,TRUE_SOURCE_CERTIFIED,TUEV_GEPRUEFT,TUNNUSTATUD_EESTI_MAITSE,TUNNUSTATUD_MAITSE,UDEN_GMO_FODER,UMWELTBAUM,UNDERWRITERS_LABORATORY,UNDERWRITERS_LABORATORY_CERTIFIED_CANADA_US,UNIQUELY_FINNISH,UNITED_EGG_PRODUCERS_CERTIFIED,UNSER_LAND,URDINKEL,USDA,USDA_CERTIFIED_BIOBASED,USDA_GRADE_A,USDA_GRADE_AA,USDA_INSPECTION,USDA_ORGANIC,UTZ_CERTIFIED,UTZ_CERTIFIED_COCOA,VAAD_HOEIR_KOSHER,VAELG_FULDKORN_FORST,VDE,VDS_CERTIFICATE,VEGAN_AWARENESS_FOUNDATION,VEGAN_BY_EARTHKOSHER,VEGAN_NATURAL_FOOD_CERTIFIERS,VEGAN_SOCIETY_VEGAN_LOGO,VEGAPLAN,VEGATARIAN_SOCIETY_V_LOGO,VEGECERT,VEILIG_WONEN_POLITIE_KEURMERK,VERBUND_OEKOHOEFE,VIANDE_AGNEAU_FRANCAIS,VIANDE_BOVINE_FRANCAISE,VIANDE_CHEVALINE_FRANCAISE,VIANDE_DE_CHEVRE_FRANCAISE,VIANDE_DE_CHEVREAU_FRANCAISE,VIANDE_DE_VEAU_FRANCAISE,VIANDE_OVINE_FRANCAISE,VIANDES_DE_FRANCE,VIGNERONS_EN_DEVELOPPEMENT_DURABLE,VIM_CO_JIM,VINATURA,VINHO_VERDE,VITICULTURE_DURABLE_EN_CHAMPAGNE,VIVA,VOLAILLE_FRANCAISE,WARRANT_HOLDER_OF_THE_COURT_OF_BELGIUM,WEIDEMELK,WEIGHT_WATCHERS_ENDORSED,WESTERN_KOSHER,WHOLE_GRAIN_100_PERCENT_STAMP,WHOLE_GRAIN_BASIC_STAMP,WHOLE_GRAIN_COUNCIL_STAMP,WHOLE_GRAINS_50_PERCENT_STAMP,WIETA (Wine and Agricultural Ethical Trading Association),WINERIES_FOR_CLIMATE_PROTECTION,WISCONSIN_K,WQA_TESTED_CERTIFIED_WATER,WSDA,WWF_PANDA_LABEL,ZELDZAAM_LEKKER,ZERO_WASTE_BUSINESS_COUNCIL_CERTIFIED', ',')"/>


        <!-- ISO 6523 ICD code list with added DK value 'ZZZ': -->
        <let
                name="DK-ISO-6523-ICD"
                value="tokenize('ZZZ 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230', '\s')"/>

        <!-- OpenPEPPOL subset of IANA Mime code list -->
        <let
                name="OpenPEPPOL-IANA-MimeCode"
                value="tokenize('text/csv application/pdf image/png image/jpeg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>


</pattern>