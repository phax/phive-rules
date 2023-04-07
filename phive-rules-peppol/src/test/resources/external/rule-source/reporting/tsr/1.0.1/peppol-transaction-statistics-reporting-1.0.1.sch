<?xml version="1.0" encoding="iso-8859-1"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding='xslt2'
        schemaVersion="ISO19757-3">
  <title>OpenPeppol Transaction Statistics Reporting</title>

  <p id="about">
    This is the Schematron for the Peppol Transaction Statistics Reporting
    This is based on the "Internal Regulations" document,
      chapter 4.4 "Service Provider Reporting on Transaction Statistics"

    Author:
      Philip Helger

    History:
      v1.0.1
        2023-03-14, Philip Helger - removed rule SCH-TSR-13; added rule SCH-TSR-43 
      v1.0.0
        2022-11-14, Muhammet Yildiz, Philip Helger - updates after the review
        2022-04-21, Philip Helger - initial version
  </p>

  <ns prefix="tsr" uri="urn:fdc:peppol:transaction-statistics-report:1.0"/>

  <pattern id="default">
    <let name="cl_iso3166" value="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI XK YE YT ZA ZM ZW '"/>
    <let name="cl_spidtype" value="' CertSubjectCN '"/>
    <let name="cl_subtotalType" value="' PerTP PerSP-DT-PR PerSP-DT-PR-CC '"/>
    <let name="re_seatid" value="'^P[A-Z]{2}[0-9]{6}$'"/>

    <rule context="/tsr:TransactionStatisticsReport">
      <let name="total" value="tsr:Total/tsr:Incoming + tsr:Total/tsr:Outgoing"/>
      <let name="empty" value="$total = 0"/>

      <assert id="SCH-TSR-01" flag="fatal" test="normalize-space(tsr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:transaction-statistics-reporting:1.0'"
      >[SCH-TSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:edec:trns:transaction-statistics-reporting:1.0'</assert>
      <assert id="SCH-TSR-02" flag="fatal" test="normalize-space(tsr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'"
      >[SCH-TSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'</assert>

      <!-- Per Transport Protocol -->
      <!-- Check Subtotal existence -->
      <let name="name_tp" value="'Transport Protocol ID'"/>
      <assert id="SCH-TSR-03" flag="fatal" test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerTP']"
      >[SCH-TSR-03] The subtotals per $name_tp MUST exist</assert>

      <!-- Check Subtotal sums -->
      <assert id="SCH-TSR-04" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Incoming) = tsr:Total/tsr:Incoming"
      >[SCH-TSR-04] The sum of all subtotals per $name_tp incoming MUST match the total incoming count</assert>
      <assert id="SCH-TSR-05" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
      >[SCH-TSR-05] The sum of all subtotals per $name_tp outgoing MUST match the total outgoing count</assert>

      <!-- Global uniqueness check per Key -->
      <assert id="SCH-TSR-06" flag="fatal" test="every $key in (tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key) satisfies 
                                                   count(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) = 
                                                                                                                concat(normalize-space($key/@schemeID),'::',normalize-space($key))]) = 1"
      >[SCH-TSR-06] Each $name_tp MUST occur only once.</assert>

      <!-- Per Service Provider and Dataset Type -->
      <let name="name_spdtpr" value="'Service Provider ID, Dataset Type ID and Process ID'"/>
      <assert id="SCH-TSR-07" flag="fatal" test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']"
      >[SCH-TSR-07] The subtotals per $name_spdtpr MUST exist</assert>
      <assert id="SCH-TSR-08" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Incoming) = tsr:Total/tsr:Incoming"
      >[SCH-TSR-08] The sum of all subtotals per $name_spdtpr incoming MUST match the total incoming count</assert>
      <assert id="SCH-TSR-09" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
      >[SCH-TSR-09] The sum of all subtotals per $name_spdtpr outgoing MUST match the total outgoing count</assert>
      <assert id="SCH-TSR-10" flag="fatal" test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']),
                                                       $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                       $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                       $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies
                                                   count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                                                                                   $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                   $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                                                                             concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::',
                                                                                                                    normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                    normalize-space($pr/@schemeID),'::',normalize-space($pr)) =
                                                                                                             concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::',
                                                                                                                    normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                    normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1"
      >[SCH-TSR-10] Each combination of $name_spdtpr MUST occur only once.</assert>

      <!-- Per Service Provider and Dataset Type and Country to Country-->
      <let name="name_spdtprcc" value="'Service Provider ID, Dataset Type ID, Process ID, Sender Country and Receiver Country'"/>
      <let name="cc_exists" value="tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']"/>
      <!-- TSR-11 was removed late in the process -->
      <assert id="SCH-TSR-12" flag="warning" test="not($cc_exists) or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Incoming) = tsr:Total/tsr:Incoming"
      >[SCH-TSR-12] The sum of all subtotals per $name_spdtprcc incoming MUST match the total incoming count</assert>
      <!-- SCH-TSR-13 was removed in v1.0.1 -->
      <!-- 
      <assert id="SCH-TSR-13" flag="warning" test="not($cc_exists) or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
      >[SCH-TSR-13] The sum of all subtotals per $name_spdtprcc outgoing MUST match the total outgoing count</assert>
       -->
      <assert id="SCH-TSR-14" flag="fatal" test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']),
                                                       $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                       $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                       $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                       $stsc in ($st/tsr:Key[normalize-space(@schemeID) = 'SenderCountry']),
                                                       $strc in ($st/tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies 
                                                   count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR-CC'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                                                                                      $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                      $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                                                                                      $sc in (tsr:Key[normalize-space(@schemeID) = 'SenderCountry']),
                                                                                                                      $rc in (tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies
                                                                                                                concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::',
                                                                                                                       normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                       normalize-space($pr/@schemeID),'::',normalize-space($pr),'::',
                                                                                                                       normalize-space($sc),'::',
                                                                                                                       normalize-space($rc)) = 
                                                                                                                concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::',
                                                                                                                       normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                       normalize-space($stpr/@schemeID),'::',normalize-space($stpr),'::',
                                                                                                                       normalize-space($stsc),'::',
                                                                                                                       normalize-space($strc))]) = 1"
      >[SCH-TSR-14] Each combination of $name_spdtprcc MUST occur only once.</assert>

      <assert id="SCH-TSR-39" flag="fatal" test="count(tsr:Subtotal[normalize-space(@type) !='PerTP' and 
                                                                    normalize-space(@type) !='PerSP-DT-PR' and 
                                                                    normalize-space(@type) !='PerSP-DT-PR-CC']) = 0"
      >[SCH-TSR-39] Only allowed subtotal types MUST be used.</assert>
    </rule>

    <rule context="/tsr:TransactionStatisticsReport/tsr:Header">
      <assert id="SCH-TSR-40" flag="fatal" test="matches(normalize-space(tsr:ReportPeriod/tsr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')"
      >[SCH-TSR-40] The report period start date (<value-of select="normalize-space(tsr:ReportPeriod/tsr:StartDate)"/>) MUST NOT contain timezone information</assert>
      <assert id="SCH-TSR-41" flag="fatal" test="matches(normalize-space(tsr:ReportPeriod/tsr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')"
      >[SCH-TSR-41] The report period end date (<value-of select="normalize-space(tsr:ReportPeriod/tsr:EndDate)"/>) MUST NOT contain timezone information</assert>
      <!-- Note: the effective report period length is checked somewhere else -->
      <assert id="SCH-TSR-42" flag="fatal" test="tsr:ReportPeriod/tsr:EndDate &gt;= tsr:ReportPeriod/tsr:StartDate"
      >[SCH-TSR-42] The report period start date (<value-of select="normalize-space(tsr:ReportPeriod/tsr:StartDate)"/>) MUST NOT be after the report period end date (<value-of select="normalize-space(tsr:ReportPeriod/tsr:EndDate)"/>)</assert>
    </rule>

    <rule context="/tsr:TransactionStatisticsReport/tsr:Header/tsr:ReporterID">
      <assert id="SCH-TSR-16" flag="fatal" test="normalize-space(.) != ''"
      >[SCH-TSR-16] The reporter ID MUST be present</assert>
      <assert id="SCH-TSR-17" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and 
                                             contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
      >[SCH-TSR-17] The Reporter ID scheme (<value-of select="normalize-space(@schemeID)"/>) MUST be coded according to the code list</assert>
      <assert id="SCH-TSR-18" flag="fatal" test="(@schemeID='CertSubjectCN' and 
                                                  matches(normalize-space(.), $re_seatid)) or 
                                                 not(@schemeID='CertSubjectCN')"
      >[SCH-TSR-18] The layout of the certificate subject CN (<value-of select="normalize-space(.)"/>) is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Make this check outside to ensure it works for different subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'CertSubjectCN']">
      <assert id="SCH-TSR-19" flag="fatal" test="matches(normalize-space(.), $re_seatid)"
      >[SCH-TSR-19] The layout of the certificate subject CN is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Make this check outside to ensure it works for different subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'SenderCountry' or 
                                                                         normalize-space(@schemeID) = 'ReceiverCountry']">
      <assert id="SCH-TSR-20" flag="fatal" test="not(contains(normalize-space(.), ' ')) and 
                                                    contains($cl_iso3166, concat(' ', normalize-space(.), ' '))"
      >[SCH-TSR-20] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK' or '1A'.</assert>
    </rule>

    <!-- Per Transport Protocol aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerTP']">
      <let name="name" value="'The subtotal per Transport Protocol ID'"/>
      <assert id="SCH-TSR-21" flag="fatal" test="count(tsr:Key) = 1"
      >[SCH-TSR-21] $name MUST have one Key element</assert>
      <assert id="SCH-TSR-22" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'TP']) = 1"
      >[SCH-TSR-22] $name MUST have one Key element with the meta scheme ID 'TP'</assert>
      <assert id="SCH-TSR-23" flag="fatal" test="count(tsr:Key[normalize-space(@schemeID) = 'Peppol']) = 1"
      >[SCH-TSR-23] $name MUST have one Key element with the scheme ID 'Peppol'</assert>
    </rule>

    <!-- Per Service Provider and DatasetType aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']">
      <let name="name" value="'The subtotal per Service Provider ID, Dataset Type ID and Process ID'"/>
      <assert id="SCH-TSR-24" flag="fatal" test="count(tsr:Key) = 3"
      >[SCH-TSR-24] $name MUST have three Key elements</assert>
      <assert id="SCH-TSR-25" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1"
      >[SCH-TSR-25] $name MUST have one Key element with the meta scheme ID 'SP'</assert>
      <assert id="SCH-TSR-26" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-TSR-26] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-TSR-27" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-TSR-27] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
      <assert id="SCH-TSR-28" flag="fatal" test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies
                                                   not(contains(normalize-space($x/@schemeID), ' ')) and 
                                                   contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))"
      >[SCH-TSR-28] $name MUST have one SP Key element with the scheme ID coded according to the code list</assert>
    </rule>

    <!-- Per Service Provider and DatasetType and Countries aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']">
      <let name="name" value="'The subtotal per Service Provider ID, Dataset Type ID, Sender Country and Receiver Country'"/>
      <assert id="SCH-TSR-29" flag="fatal" test="count(tsr:Key) = 5"
      >[SCH-TSR-29] $name MUST have five Key elements</assert>
      <assert id="SCH-TSR-30" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1"
      >[SCH-TSR-30] $name MUST have one Key element with the meta scheme ID 'SP'</assert>
      <assert id="SCH-TSR-31" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-TSR-31] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-TSR-32" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-TSR-32] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
      <assert id="SCH-TSR-33" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC']) = 2"
      >[SCH-TSR-33] $name MUST have two Key elements with the meta scheme ID 'CC'</assert>
      <assert id="SCH-TSR-34" flag="fatal" test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies
                                                   not(contains(normalize-space($x/@schemeID), ' ')) and 
                                                   contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))"
      >[SCH-TSR-34] $name MUST have one SP Key element with the scheme ID coded according to the code list</assert>
      <assert id="SCH-TSR-35" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'SenderCountry']) = 1"
      >[SCH-TSR-35] $name MUST have one CC Key element with the scheme ID 'SenderCountry'</assert>
      <assert id="SCH-TSR-36" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'ReceiverCountry']) = 1"
      >[SCH-TSR-36] $name MUST have one CC Key element with the scheme ID 'ReceiverCountry'</assert>
      <!-- Added in v1.0.1 --> 
      <assert id="SCH-TSR-43" flag="fatal" test="tsr:Outgoing = 0"
      >[SCH-TSR-43] $name MUST have a 'Outgoing' value of '0' because that data cannot be gathered</assert>
    </rule>

    <!-- After all the specific Subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal">
      <assert id="SCH-TSR-37" flag="fatal" test="not(contains(normalize-space(@type), ' ')) and
                                                 contains($cl_subtotalType, concat(' ', normalize-space(@type), ' '))"
      >[SCH-TSR-37] The Subtotal type (<value-of select="normalize-space(@type)"/>) MUST be coded according to the code list</assert>
    </rule>
  </pattern>
</schema>
