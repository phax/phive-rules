<?xml version="1.0" encoding="iso-8859-1"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding='xslt2'
        schemaVersion="ISO19757-3">
  <title>OpenPeppol End User Statistics Report</title>

  <p id="about">
    This is the Schematron for the Peppol End User Statistics Reports.
    This is based on the "Internal Regulations" document,
      chapter 4.3 "Service Provider Reporting about End Users"

    Author:
      Philip Helger
      Muhammet Yildiz

    History
      EUSR 1.1.0
      * 2023-09-18, Philip Helger - Using function "max" in rules 03, 04, 22 to fix an issue if the same value appears more then once
                                    Explicitly added "xs:integer" casts where necessary
      * 2023-06-29, Muhammet Yildiz - Updates related to changing "PerDTPRCC" to "PerDTPREUC". Rules 28,31,32 removed. Rules 14, 23, 26, 27, 29, 30 modified
      EUSR 1.0.1
      * 2023-06-23, Philip Helger - hotfix for new subsets "PerEUC" and "PerDT-EUC". Added new rules SCH-EUSR-37 to SCH-EUSR-47
      EUSR 1.0.0
      * 2023-03-06, Philip Helger - updates after second review
      EUSR RC2
      * 2022-11-14, Muhammet Yildiz, Philip Helger - updates after the first review
      EUR RC1
      * 2022-04-15, Philip Helger - initial version
  </p>

  <ns prefix="eusr" uri="urn:fdc:peppol:end-user-statistics-report:1.1"/>

  <pattern id="default">
    <let name="cl_iso3166" value="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI XK YE YT ZA ZM ZW '"/>
    <let name="cl_spidtype" value="' CertSubjectCN '"/>

    <rule context="/eusr:EndUserStatisticsReport">
      <let name="total" value="xs:integer(eusr:FullSet/eusr:SendingEndUsers) + xs:integer(eusr:FullSet/eusr:ReceivingEndUsers)"/>
      <let name="empty" value="$total = 0"/>

      <!-- Customization ID and Profile ID -->
      <assert id="SCH-EUSR-01" flag="fatal" test="normalize-space(eusr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.1'"
      >[SCH-EUSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.1'</assert>
      <assert id="SCH-EUSR-02" flag="fatal" test="normalize-space(eusr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'"
      >[SCH-EUSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'</assert>

      <!-- Check Subset count vs. FullSet count -->
      <assert id="SCH-EUSR-03" flag="fatal" test="$empty or max(eusr:Subset/eusr:SendingEndUsers) le xs:integer(eusr:FullSet/eusr:SendingEndUsers)"
      >[SCH-EUSR-03] The maximum of all subsets of SendingEndUsers (<value-of select="max(eusr:Subset/eusr:SendingEndUsers)"/>) MUST be lower or equal to FullSet/SendingEndUsers (<value-of select="xs:integer(eusr:FullSet/eusr:SendingEndUsers)" />)</assert>
      <assert id="SCH-EUSR-04" flag="fatal" test="$empty or max(eusr:Subset/eusr:ReceivingEndUsers) le xs:integer(eusr:FullSet/eusr:ReceivingEndUsers)"
      >[SCH-EUSR-04] The maximum of all subsets of ReceivingEndUsers (<value-of select="max(eusr:Subset/eusr:ReceivingEndUsers)"/>) MUST be lower or equal to FullSet/ReceivingEndUsers (<value-of select="xs:integer(eusr:FullSet/eusr:ReceivingEndUsers)" />)</assert>
      <assert id="SCH-EUSR-22" flag="fatal" test="$empty or max(eusr:Subset/eusr:SendingOrReceivingEndUsers) le xs:integer(eusr:FullSet/eusr:SendingOrReceivingEndUsers)"
      >[SCH-EUSR-22] The maximum of all subsets of SendingOrReceivingEndUsers (<value-of select="max(eusr:Subset/eusr:SendingOrReceivingEndUsers)"/>) MUST be lower or equal to FullSet/SendingOrReceivingEndUsers (<value-of select="xs:integer(eusr:FullSet/eusr:SendingOrReceivingEndUsers)"/>)</assert>

      <!-- Check consistency inside FullSet -->  
      <assert id="SCH-EUSR-19" flag="fatal" test="xs:integer(eusr:FullSet/eusr:SendingOrReceivingEndUsers) &lt;= $total"
      >[SCH-EUSR-19] The number of SendingOrReceivingEndUsers (<value-of select="eusr:FullSet/eusr:SendingOrReceivingEndUsers"/>) MUST be lower or equal to the sum of the SendingEndUsers and ReceivingEndUsers (<value-of select="$total"/>)</assert>
      <assert id="SCH-EUSR-20" flag="fatal" test="xs:integer(eusr:FullSet/eusr:SendingOrReceivingEndUsers) &gt;= xs:integer(eusr:FullSet/eusr:SendingEndUsers)"
      >[SCH-EUSR-20] The number of SendingOrReceivingEndUsers (<value-of select="eusr:FullSet/eusr:SendingOrReceivingEndUsers"/>) MUST be greater or equal to the number of SendingEndUsers (<value-of select="eusr:FullSet/eusr:SendingEndUsers"/>)</assert>
      <assert id="SCH-EUSR-21" flag="fatal" test="xs:integer(eusr:FullSet/eusr:SendingOrReceivingEndUsers) &gt;= xs:integer(eusr:FullSet/eusr:ReceivingEndUsers)"
      >[SCH-EUSR-21] The number of SendingOrReceivingEndUsers (<value-of select="eusr:FullSet/eusr:SendingOrReceivingEndUsers"/>) MUST be greater or equal to the number of ReceivingEndUsers (<value-of select="eusr:FullSet/eusr:ReceivingEndUsers"/>)</assert>

      <!-- Per Dataset Type -->

      <!-- Check Subset existence -->
      <assert id="SCH-EUSR-15" flag="fatal" test="$empty or eusr:Subset[normalize-space(@type) = 'PerDT-PR']"
      >[SCH-EUSR-15] At least one subset per 'Dataset Type ID and Process ID' MUST exist</assert>
        
      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUSR-13" flag="fatal" test="every $st in (eusr:Subset[normalize-space(@type) = 'PerDT-PR']),
                                                        $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                        $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                    count(eusr:Subset[normalize-space(@type) ='PerDT-PR'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                                                                          concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                 normalize-space($pr/@schemeID),'::',normalize-space($pr)) =
                                                                                                          concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                 normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1"
      >[SCH-EUSR-13] Each combination of 'Dataset Type ID and Process ID' MUST occur only once.</assert>
      
      <!-- Per Dataset Type ID, Process ID and End User Country -->

      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUSR-29" flag="fatal" test="every $st in (eusr:Subset[normalize-space(@type) = 'PerDT-PR-EUC']),
                                                        $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                        $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                        $stuc in ($st/eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']) satisfies
                                                    count(eusr:Subset[normalize-space(@type) ='PerDT-PR-EUC'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                   $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                                                                                   $uc in (eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']) satisfies
                                                                                                             concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                    normalize-space($pr/@schemeID),'::',normalize-space($pr),'::',
                                                                                                                    normalize-space($uc)) =
                                                                                                             concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                    normalize-space($stpr/@schemeID),'::',normalize-space($stpr),'::',
                                                                                                                    normalize-space($stuc))]) = 1"
      >[SCH-EUSR-29] Each combination of 'Dataset Type ID, Process ID and End User Country' MUST occur only once.</assert>


      <!-- Per Dataset Type ID and End User Country -->

      <!-- Check Subset existence -->
      <assert id="SCH-EUSR-37" flag="fatal" test="$empty or eusr:Subset[normalize-space(@type) = 'PerDT-EUC']"
      >[SCH-EUSR-37] At least one subset per 'Dataset Type ID and End User Country' MUST exist</assert>

      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUSR-38" flag="fatal" test="every $st in (eusr:Subset[normalize-space(@type) = 'PerDT-EUC']),
                                                        $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                        $steuc in ($st/eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']) satisfies
                                                    count(eusr:Subset[normalize-space(@type) ='PerDT-EUC'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                 $euc in (eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']) satisfies
                                                                                                           concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                  normalize-space($euc)) =
                                                                                                           concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                  normalize-space($steuc))]) = 1"
      >[SCH-EUSR-38] Each combination of 'Dataset Type ID and End User Country' MUST occur only once.</assert>
        
      <!-- Per End User Country -->

      <assert id="SCH-EUSR-39" flag="fatal" test="$empty or eusr:Subset[normalize-space(@type) = 'PerEUC']"
      >[SCH-EUSR-39] At least one subset per 'End User Country' MUST exist</assert>

      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUSR-40" flag="fatal" test="every $st in (eusr:Subset[normalize-space(@type) = 'PerEUC']),
                                                        $steuc in ($st/eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']) satisfies
                                                    count(eusr:Subset[normalize-space(@type) ='PerEUC'][every $euc in (eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']) satisfies
                                                                                                        normalize-space($euc) = normalize-space($steuc)]) = 1"
      >[SCH-EUSR-40] Each 'End User Country' MUST occur only once.</assert>
        
      <!-- Check that no other Subset types are used -->  
      <assert id="SCH-EUSR-14" flag="fatal" test="count(eusr:Subset[normalize-space(@type) !='PerDT-PR' and 
                                                                    normalize-space(@type) !='PerDT-PR-EUC' and
                                                                    normalize-space(@type) !='PerDT-EUC' and 
                                                                    normalize-space(@type) !='PerEUC']) = 0"
      >[SCH-EUSR-14] Only allowed subset types MUST be used.</assert>
      
      <!-- Check generic Subset cardinality against FullSet cardinality -->
      <assert id="SCH-EUSR-33" flag="fatal" test="every $st in (eusr:Subset) satisfies
                                                        xs:integer($st/eusr:SendingOrReceivingEndUsers) &lt;= xs:integer($st/eusr:SendingEndUsers + $st/eusr:ReceivingEndUsers)"
      >[SCH-EUSR-33] The number of each Subset/SendingOrReceivingEndUsers MUST be lower or equal to the sum of the Subset/SendingEndUsers plus Subset/ReceivingEndUsers</assert>
      <assert id="SCH-EUSR-34" flag="fatal" test="every $st in (eusr:Subset) satisfies
                                                        xs:integer($st/eusr:SendingOrReceivingEndUsers) &gt;= xs:integer($st/eusr:SendingEndUsers)"
      >[SCH-EUSR-34] The number of each Subset/SendingOrReceivingEndUsers MUST be greater or equal to the number of Subset/SendingEndUsers (<value-of select="eusr:Subset/eusr:SendingEndUsers"/>)</assert>
      <assert id="SCH-EUSR-35" flag="fatal" test="every $st in (eusr:Subset) satisfies
                                                        xs:integer($st/eusr:SendingOrReceivingEndUsers) &gt;= xs:integer($st/eusr:ReceivingEndUsers)"
      >[SCH-EUSR-35] The number of each Subset/SendingOrReceivingEndUsers MUST be greater or equal to the number of Subset/ReceivingEndUsers (<value-of select="eusr:Subset/eusr:ReceivingEndUsers"/>)</assert>
      <assert id="SCH-EUSR-36" flag="fatal" test="every $st in (eusr:Subset) satisfies
                                                        xs:integer($st/eusr:SendingOrReceivingEndUsers) &gt; 0"
      >[SCH-EUSR-36] The number of each Subset/SendingOrReceivingEndUsers MUST be greater then zero, otherwise it MUST be omitted</assert>
    </rule>

    <rule context="/eusr:EndUserStatisticsReport/eusr:Header">
      <assert id="SCH-EUSR-16" flag="fatal" test="matches(normalize-space(eusr:ReportPeriod/eusr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')"
      >[SCH-EUSR-16] The reporting period start date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:StartDate)"/>) MUST NOT contain timezone information</assert>
      <assert id="SCH-EUSR-17" flag="fatal" test="matches(normalize-space(eusr:ReportPeriod/eusr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')"
      >[SCH-EUSR-17] The reporting period end date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:EndDate)"/>) MUST NOT contain timezone information</assert>
      <!-- Note: the effective report period length is checked somewhere else -->
      <assert id="SCH-EUSR-18" flag="fatal" test="eusr:ReportPeriod/eusr:EndDate &gt;= eusr:ReportPeriod/eusr:StartDate"
      >[SCH-EUSR-18] The report period start date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:StartDate)"/>) MUST NOT be after the report period end date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:EndDate)"/>)</assert>
    </rule>

    <rule context="/eusr:EndUserStatisticsReport/eusr:Header/eusr:ReporterID">
      <assert id="SCH-EUSR-06" flag="fatal" test="normalize-space(.) != ''"
      >[SCH-EUSR-06] The Reporter ID MUST be present</assert>
      <assert id="SCH-EUSR-07" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and
                                                  contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
      >[SCH-EUSR-07] The Reporter ID scheme ID (<value-of select="normalize-space(@schemeID)"/>) MUST be coded according to the code list</assert>
      <assert id="SCH-EUSR-08" flag="fatal" test="(@schemeID='CertSubjectCN' and
                                                   matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or 
                                                  not(@schemeID='CertSubjectCN')"
      >[SCH-EUSR-08] The layout of the certificate subject CN (<value-of select="normalize-space(.)"/>) is not a valid Peppol Seat ID</assert>
    </rule>
    
    <!-- Make this check outside to ensure it works for different subsets -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset/eusr:Key[normalize-space(@schemeID) = 'EndUserCountry']">
      <assert id="SCH-EUSR-30" flag="fatal" test="not(contains(normalize-space(.), ' ')) and 
                                                  contains($cl_iso3166, concat(' ', normalize-space(.), ' '))"
      >[SCH-EUSR-30] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK' or '1A'.</assert>
    </rule>

    <!-- Per Dataset Type and Process ID aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset[normalize-space(@type) = 'PerDT-PR']">
      <let name="name" value="'The subset per Dataset Type ID and Process ID'"/>
      
      <assert id="SCH-EUSR-09" flag="fatal" test="count(eusr:Key) = 2"
      >[SCH-EUSR-09] $name MUST have two Key elements</assert>
      <assert id="SCH-EUSR-10" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUSR-10] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUSR-11" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-EUSR-11] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
    </rule>

    <!-- Per Dataset Type, Process ID and End User Country aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset[normalize-space(@type) = 'PerDT-PR-EUC']">
      <let name="name" value="'The subset per Dataset Type ID, Process ID and End User Country'"/>
      
      <assert id="SCH-EUSR-23" flag="fatal" test="count(eusr:Key) = 3"
      >[SCH-EUSR-23] $name MUST have three Key elements</assert>
      <assert id="SCH-EUSR-24" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUSR-24] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUSR-25" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-EUSR-25] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
      <assert id="SCH-EUSR-26" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC']) = 1"
      >[SCH-EUSR-26] $name MUST have one Key element with the meta scheme ID 'CC'</assert>
      <assert id="SCH-EUSR-27" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'EndUserCountry']) = 1"
      >[SCH-EUSR-27] $name MUST have one CC Key element with the scheme ID 'EndUserCountry'</assert>
    </rule>

    <!-- Per Dataset Type and End User Country aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset[normalize-space(@type) = 'PerDT-EUC']">
      <let name="name" value="'The subset per Dataset Type ID and End User Country'"/>
      
      <assert id="SCH-EUSR-41" flag="fatal" test="count(eusr:Key) = 2"
      >[SCH-EUSR-41] $name MUST have two Key elements</assert>
      <assert id="SCH-EUSR-42" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUSR-42] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUSR-43" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC']) = 1"
      >[SCH-EUSR-43] $name MUST have one Key element with the meta scheme ID 'CC'</assert>
      <assert id="SCH-EUSR-44" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'EndUserCountry']) = 1"
      >[SCH-EUSR-44] $name MUST have one CC Key element with the scheme ID 'EndUserCountry'</assert>
    </rule>

    <!-- Per End User Country aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset[normalize-space(@type) = 'PerEUC']">
      <let name="name" value="'The subset per End User Country'"/>
      
      <assert id="SCH-EUSR-45" flag="fatal" test="count(eusr:Key) = 1"
      >[SCH-EUSR-45] $name MUST have one Key element</assert>
      <assert id="SCH-EUSR-46" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC']) = 1"
      >[SCH-EUSR-46] $name MUST have one Key element with the meta scheme ID 'CC'</assert>
      <assert id="SCH-EUSR-47" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'EndUserCountry']) = 1"
      >[SCH-EUSR-47] $name MUST have one CC Key element with the scheme ID 'EndUserCountry'</assert>
    </rule>
  </pattern>
</schema>
