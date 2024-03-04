<?xml version="1.0" encoding="iso-8859-1"?>
<!--

    Copyright (C) 2022 Philip Helger
    philip[at]helger[dot]com

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
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

    History:
      2022-11-14, Muhammet Yildiz, Philip Helger - updates after the first review
      2022-04-15, Philip Helger - initial version
  </p>

  <ns prefix="eusr" uri="urn:fdc:peppol:end-user-statistics-report:1.0"/>

  <pattern id="default">
    <let name="cl_spidtype" value="' CertSubjectCN '"/>

    <rule context="/eusr:EndUserStatisticsReport">
      <let name="total" value="eusr:Total/eusr:SendingEndUsers + eusr:Total/eusr:ReceivingEndUsers"/>
      <let name="empty" value="$total = 0"/>

      <assert id="SCH-EUSR-01" flag="fatal" test="normalize-space(eusr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'"
      >[SCH-EUSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'</assert>
      <assert id="SCH-EUSR-02" flag="fatal" test="normalize-space(eusr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'"
      >[SCH-EUSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'</assert>

      <assert id="SCH-EUSR-03" flag="fatal" test="$empty or eusr:Subtotal/eusr:SendingEndUsers[not(. &lt; ../../eusr:Subtotal/eusr:SendingEndUsers)][1] &lt;= eusr:Total/eusr:SendingEndUsers"
      >[SCH-EUSR-03] The maximum of all subtotals of SendingEndUsers MUST be lower or equal to Totals/SendingEndUsers</assert>
      <assert id="SCH-EUSR-04" flag="fatal" test="$empty or eusr:Subtotal/eusr:ReceivingEndUsers[not(. &lt; ../../eusr:Subtotal/eusr:ReceivingEndUsers)][1] &lt;= eusr:Total/eusr:ReceivingEndUsers"
      >[SCH-EUSR-04] The maximum of all subtotals of ReceivingEndUsers MUST be lower or equal to Totals/ReceivingEndUsers</assert>
      
      <assert id="SCH-EUSR-19" flag="fatal" test="eusr:Total/eusr:DistinctEndUsers &lt;= $total"
      >[SCH-EUSR-19] The total number of total DistinctEndUsers (<value-of select="eusr:Total/eusr:DistinctEndUsers"/>) MUST be lower or equal to the sum of the total SendingEndUsers and total ReceivingEndUsers</assert>
      <assert id="SCH-EUSR-20" flag="fatal" test="eusr:Total/eusr:DistinctEndUsers &gt;= eusr:Total/eusr:SendingEndUsers"
      >[SCH-EUSR-20] The total number of total DistinctEndUsers (<value-of select="eusr:Total/eusr:DistinctEndUsers"/>) MUST be greater or equal to number of total SendingEndUsers (<value-of select="eusr:Total/eusr:SendingEndUsers"/>)</assert>
      <assert id="SCH-EUSR-21" flag="fatal" test="eusr:Total/eusr:DistinctEndUsers &gt;= eusr:Total/eusr:ReceivingEndUsers"
      >[SCH-EUSR-21] The total number of total DistinctEndUsers (<value-of select="eusr:Total/eusr:DistinctEndUsers"/>) MUST be greater or equal to number of total ReceivingEndUsers (<value-of select="eusr:Total/eusr:ReceivingEndUsers"/>)</assert>
        
      <!-- Per Dataset Type -->
      <!-- Check Subtotal existence -->
      <assert id="SCH-EUSR-15" flag="fatal" test="$empty or eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']"
      >[SCH-EUSR-15] The subtotals per 'Dataset Type ID and Process ID' MUST exist</assert>
        
      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUSR-13" flag="fatal" test="every $st in (eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']),
                                                        $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                        $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies
                                                    count(eusr:Subtotal[normalize-space(@type) ='PerDT-PR'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                  $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                                                                            concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                   normalize-space($pr/@schemeID),'::',normalize-space($pr)) =
                                                                                                            concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                   normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1"
      >[SCH-EUSR-13] Each combination of 'Dataset Type ID and Process ID' MUST occur only once.</assert>
        
      <!-- Check that no other types are used -->  
      <assert id="SCH-EUSR-14" flag="fatal" test="count(eusr:Subtotal[normalize-space(@type) !='PerDT-PR']) = 0"
      >[SCH-EUSR-14] Only allowed subtotal types MUST be used.</assert>
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

    <!-- Per Dataset Type and Process ID aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']">
      <let name="name" value="'The subtotal per Dataset Type ID and Process ID'"/>
      
      <assert id="SCH-EUSR-09" flag="fatal" test="count(eusr:Key) = 2"
      >[SCH-EUSR-09] $name MUST have two Key elements</assert>
      <assert id="SCH-EUSR-10" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUSR-10] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUSR-11" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-EUSR-11] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
    </rule>
  </pattern>
</schema>
