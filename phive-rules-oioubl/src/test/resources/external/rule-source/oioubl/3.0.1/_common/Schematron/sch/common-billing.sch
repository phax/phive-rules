<sch:pattern
        xmlns:sch="http://purl.oclc.org/dsdl/schematron">

        <sch:title>Common rules BIS Billing</sch:title>


        <sch:rule
                context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
                <sch:assert
                        id="PEPPOL-EN16931-CL001"
                        test="
                                some $code in $MIMECODE
                                        satisfies @mimeCode = $code"
                        flag="fatal"> Mime code must be according to subset of IANA code list."/>'
                </sch:assert>
        </sch:rule>


        <sch:rule
                context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode">
                <sch:assert
                        id="PEPPOL-EN16931-CL002"
                        test="
                                some $code in $UNCL5189
                                        satisfies normalize-space(text()) = $code"
                        flag="fatal"> Reason code MUST be according to subset of UNCL 5189
                        D.16B."/>' </sch:assert>
        </sch:rule>


        <sch:rule
                context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode">
                <sch:assert
                        id="PEPPOL-EN16931-CL003"
                        test="
                                some $code in $UNCL7161
                                        satisfies normalize-space(text()) = $code"
                        flag="fatal"> Reason code MUST be according to UNCL 7161 D.16B."/>'
                </sch:assert>
        </sch:rule>


        <sch:rule
                context="cac:InvoicePeriod/cbc:DescriptionCode">
                <sch:assert
                        id="PEPPOL-EN16931-CL006"
                        test="
                                some $code in $UNCL2005
                                        satisfies normalize-space(text()) = $code"
                        flag="fatal"> Invoice period description code must be according to UNCL 2005
                        D.16B."/>' </sch:assert>
        </sch:rule>


        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-G']">
                <sch:assert
                        id="PEPPOL-EN16931-P0104"
                        test="
                                normalize-space(cbc:ID) = 'G'"
                        flag="fatal"> Tax Category G MUST be used when exemption reason code is
                        VATEX-EU-G"/>' </sch:assert>
        </sch:rule>


        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-O']">
                <sch:assert
                        id="PEPPOL-EN16931-P0105"
                        test="
                                normalize-space(cbc:ID) = 'O'"
                        flag="fatal"> Tax Category O MUST be used when exemption reason code is
                        VATEX-EU-O"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-IC']">
                <sch:assert
                        id="PEPPOL-EN16931-P0106"
                        test="
                                normalize-space(cbc:ID) = 'K'"
                        flag="fatal"> Tax Category K MUST be used when exemption reason code is
                        VATEX-EU-IC"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-AE']">
                <sch:assert
                        id="PEPPOL-EN16931-P0107"
                        test="
                                normalize-space(cbc:ID) = 'AE'"
                        flag="fatal"> Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-AE"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-D']">
                <sch:assert
                        id="PEPPOL-EN16931-P0108"
                        test="
                                normalize-space(cbc:ID) = 'E'"
                        flag="fatal"> Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-D"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-F']">
                <sch:assert
                        id="PEPPOL-EN16931-P0109"
                        test="
                                normalize-space(cbc:ID) = 'E'"
                        flag="fatal"> Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-F"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-I']">
                <sch:assert
                        id="PEPPOL-EN16931-P0110"
                        test="
                                normalize-space(cbc:ID) = 'E'"
                        flag="fatal"> Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-I"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode) = 'VATEX-EU-J']">
                <sch:assert
                        id="PEPPOL-EN16931-P0111"
                        test="
                                normalize-space(cbc:ID) = 'E'"
                        flag="fatal"> Tax Category AE MUST be used when exemption reason code is
                        VATEX-EU-J"/>' </sch:assert>
        </sch:rule>

        <sch:rule
                context="doc:CreditNote | doc:Invoice">
                <sch:assert
                        id="PEPPOL-EN16931-R001"
                        test="cbc:ProfileID"
                        flag="fatal">Business process MUST be provided.</sch:assert>
                <sch:assert
                        id="PEPPOL-EN16931-R002"
                        test="count(cbc:Note) &lt;= 1"
                        flag="fatal">No more than one note is allowed on document
                        level.</sch:assert>
                <sch:assert
                        id="PEPPOL-EN16931-R003"
                        test="cbc:BuyerReference or cac:OrderReference/cbc:ID"
                        flag="fatal">A buyer reference or purchase order reference MUST be
                        provided.</sch:assert>
        </sch:rule>




        <!-- *************************************
        
        Code lists
        
     *************************************   -->

        <sch:let
                name="ISO3166"
                value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW', '\s')"/>
        <sch:let
                name="ISO4217"
                value="tokenize('AFN EUR ALL DZD USD AOA XCD XCD ARS AMD AWG AUD AZN BSD BHD BDT BBD BYN BZD XOF BMD INR BTN BOB BOV USD BAM BWP NOK BRL USD BND BGN XOF BIF CVE KHR XAF CAD KYD XAF XAF CLP CLF CNY AUD AUD COP COU KMF CDF XAF NZD CRC XOF HRK CUP CUC ANG CZK DKK DJF XCD DOP USD EGP SVC USD XAF ERN ETB FKP DKK FJD XPF XAF GMD GEL GHS GIP DKK XCD USD GTQ GBP GNF XOF GYD HTG USD AUD HNL HKD HUF ISK INR IDR XDR IRR IQD GBP ILS JMD JPY GBP JOD KZT KES AUD KPW KRW KWD KGS LAK LBP LSL ZAR LRD LYD CHF MOP MKD MGA MWK MYR MVR XOF USD MRO MUR XUA MXN MXV USD MDL MNT XCD MAD MZN MMK NAD ZAR AUD NPR XPF NZD NIO XOF NGN NZD AUD USD NOK OMR PKR USD PAB USD PGK PYG PEN PHP NZD PLN USD QAR RON RUB RWF SHP XCD XCD XCD WST STD SAR XOF RSD SCR SLL SGD ANG XSU SBD SOS ZAR SSP LKR SDG SRD NOK SZL SEK CHF CHE CHW SYP TWD TJS TZS THB USD XOF NZD TOP TTD TND TRY TMT USD AUD UGX UAH AED GBP USD USD USN UYU UYI UZS VUV VEF VND USD USD XPF MAD YER ZMW ZWL XBA XBB XBC XBD XTS XXX XAU XPD XPT XAG', '\s')"/>
        <sch:let
                name="MIMECODE"
                value="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
        <sch:let
                name="UNCL2005"
                value="tokenize('3 35 432', '\s')"/>
        <sch:let
                name="UNCL5189"
                value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
        <sch:let
                name="UNCL7161"
                value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CD CG CS CT DAB DAD DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
        <sch:let
                name="UNCL5305"
                value="tokenize('AE E S Z G O K L M', '\s')"/>


</sch:pattern>
