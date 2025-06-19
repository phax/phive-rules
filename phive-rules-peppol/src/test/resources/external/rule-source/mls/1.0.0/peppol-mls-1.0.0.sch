<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
  <title>OpenPeppol eDEC MLS</title>

  <p id="about">
    This is the Schematron for the Peppol Message Level Status (MLS).

    Author:
      Philip Helger

    History
      v1.0.0 RC1
        2025-03-12, Philip Helger - initial version
  </p>

  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>

  <pattern id="default">
    <let name="cl_rc" value="' AP AB RE '"/>
    <let name="cl_src" value="' BV BW FD SV '"/>
    <let name="regex_spis" value="'^[0-9]{6}(-[0-9A-Z_]{3,12}(\.[0-9A-Z\-._~]{3,24})?)?$'"/>

    <rule context="/ubl:ApplicationResponse">
      <assert id="SCH-MLS-01" flag="fatal" test="normalize-space(cbc:CustomizationID) = 'urn:peppol:edec:mls:1.0'">[SCH-MLS-01] The customization ID MUST use the value 'urn:peppol:edec:mls:1.0'</assert>

      <assert id="SCH-MLS-02" flag="fatal" test="normalize-space(cbc:ProfileID) = 'urn:peppol:edec:mls'">[SCH-MLS-02] The profile ID MUST use the value 'urn:peppol:edec:mls'</assert>

      
      <assert id="SCH-MLS-03" flag="fatal" test="normalize-space(cbc:ID) != ''">[SCH-MLS-03] The ID MUST NOT be empty</assert>

      
      <assert id="SCH-MLS-04" flag="fatal" test="string-length(normalize-space(cbc:IssueDate)) = 10">[SCH-MLS-04] The Issue Date MUST NOT contain timezone information</assert>

      <assert id="SCH-MLS-05" flag="fatal" test="exists(cbc:IssueTime)">[SCH-MLS-05] The Issue Time MUST be present</assert>
      <assert id="SCH-MLS-06" flag="fatal" test="matches(normalize-space(cbc:IssueTime), '([+-]\d{2}:\d{2}|Z)$')">[SCH-MLS-06] The Issue Time MUST contain timezone information</assert>
      
      
      <assert id="SCH-MLS-07" flag="fatal" test="exists(cac:SenderParty/cbc:EndpointID)">[SCH-MLS-07] The Sender Party Endpoint ID MUST be present</assert>
      <assert id="SCH-MLS-08" flag="fatal" test="normalize-space(cac:SenderParty/cbc:EndpointID) != ''">[SCH-MLS-08] The Sender Party Endpoint ID MUST NOT be empty</assert>
      <assert id="SCH-MLS-09" flag="fatal" test="matches(normalize-space(cac:SenderParty/cbc:EndpointID), $regex_spis)">[SCH-MLS-09] The Sender Party Endpoint ID (<value-of select="normalize-space(cac:SenderParty/cbc:EndpointID)"/>) MUST be a valid Peppol Service Provider ID</assert>
      <assert id="SCH-MLS-10" flag="fatal" test="exists(cac:SenderParty/cbc:EndpointID/@schemeID)">[SCH-MLS-10] The Sender Party Endpoint ID scheme ID MUST be present</assert>
      
      <assert id="SCH-MLS-11" flag="fatal" test="matches(normalize-space(cac:SenderParty/cbc:EndpointID/@schemeID), '^[0-9]{4}$')">[SCH-MLS-11] The Sender Party Endpoint ID scheme ID MUST be a valid Participant Identifier Scheme</assert>

      <assert id="SCH-MLS-12" flag="fatal" test="exists(cac:ReceiverParty/cbc:EndpointID)">[SCH-MLS-12] The Receiver Party Endpoint ID MUST be present</assert>
      <assert id="SCH-MLS-13" flag="fatal" test="normalize-space(cac:ReceiverParty/cbc:EndpointID) != ''">[SCH-MLS-13] The Receiver Party Endpoint ID MUST NOT be empty</assert>
      <assert id="SCH-MLS-14" flag="fatal" test="matches(normalize-space(cac:ReceiverParty/cbc:EndpointID), $regex_spis)">[SCH-MLS-14] The Receiver Party Endpoint ID (<value-of select="normalize-space(cac:ReceiverParty/cbc:EndpointID)"/>) MUST be a valid Peppol Service Provider ID</assert>
      <assert id="SCH-MLS-15" flag="fatal" test="exists(cac:ReceiverParty/cbc:EndpointID/@schemeID)">[SCH-MLS-15] The Receiver Party Endpoint ID scheme ID MUST be present</assert>
      
      <assert id="SCH-MLS-16" flag="fatal" test="matches(normalize-space(cac:ReceiverParty/cbc:EndpointID/@schemeID), '^[0-9]{4}$')">[SCH-MLS-16] The Receiver Party Endpoint ID scheme ID MUST be a valid Participant Identifier Scheme</assert>
      
      <assert id="SCH-MLS-17" flag="fatal" test="count(cac:DocumentResponse) = 1">[SCH-MLS-17] Exactly one Document Response MUST be present</assert>
    </rule>

    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse">
      <let name="rc" value="normalize-space(cac:Response/cbc:ResponseCode)"/>
      <let name="has_bv" value="exists(cac:LineResponse[cac:Response[normalize-space(cac:Status/cbc:StatusReasonCode) = 'BV']])"/>
      <let name="has_fd" value="exists(cac:LineResponse[cac:Response[normalize-space(cac:Status/cbc:StatusReasonCode) = 'FD']])"/>
      <let name="has_sv" value="exists(cac:LineResponse[cac:Response[normalize-space(cac:Status/cbc:StatusReasonCode) = 'SV']])"/>
      <let name="has_failure" value="$has_bv or $has_fd or $has_sv"/>

      
      <assert id="SCH-MLS-18" flag="fatal" test="exists(cac:Response/cbc:ResponseCode)">[SCH-MLS-18] The Overall Response Code MUST be present</assert>
      <assert id="SCH-MLS-19" flag="fatal" test="not(contains($rc, ' ')) and contains($cl_rc, concat(' ', $rc, ' '))">[SCH-MLS-19] The Response Code (<value-of select="$rc"/>) MUST be coded according to the code list</assert>

      <assert id="SCH-MLS-20" flag="fatal" test="$rc != 'RE' or                                                  exists(cac:Response/cbc:Description)">[SCH-MLS-20] A negative MLS MUST contain a Description</assert>
      <assert id="SCH-MLS-21" flag="fatal" test="$rc != 'RE' or                                                  normalize-space(cac:Response/cbc:Description) != ''">[SCH-MLS-21] A negative MLS MUST contain a non-empty Description</assert>
      
      
      <assert id="SCH-MLS-22" flag="fatal" test="count(cac:DocumentReference) = 1">[SCH-MLS-22] Exactly one Document Reference MUST be present</assert>
      
      <assert id="SCH-MLS-23" flag="fatal" test="$rc != 'RE' or                                                   exists(cac:LineResponse)">[SCH-MLS-23] A negative MLS MUST contain at least one Issue</assert>
      
      <assert id="SCH-MLS-24" flag="fatal" test="$rc != 'RE' or $has_failure">[SCH-MLS-24] A negative MLS MUST contain at least one Issue with a failure</assert>

      
      <assert id="SCH-MLS-25" flag="fatal" test="$rc = 'RE' or not($has_failure)">[SCH-MLS-25] A positive MLS MUST NOT contain Issues with failures</assert>
    </rule>

    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference">
      
      <assert id="SCH-MLS-26" flag="fatal" test="normalize-space(cbc:ID) != ''">[SCH-MLS-26] The Referenced Document ID MUST NOT be empty</assert>
    </rule>

    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse">
      
      
      <assert id="SCH-MLS-27" flag="fatal" test="normalize-space(cac:LineReference/cbc:LineID) != ''">[SCH-MLS-27] The Issue Location MUST NOT be empty</assert>

      
    </rule>

    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response">
      <assert id="SCH-MLS-28" flag="fatal" test="exists(cbc:Description)">[SCH-MLS-28] The Issue Description MUST be present</assert>

      <assert id="SCH-MLS-29" flag="fatal" test="normalize-space(cbc:Description) != ''">[SCH-MLS-29] The Issue Description MUST NOT be empty</assert>

      <assert id="SCH-MLS-30" flag="fatal" test="exists(cac:Status)">[SCH-MLS-30] The Status element MUST be present</assert>
    </rule>

    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status">
      <let name="src" value="normalize-space(cbc:StatusReasonCode)"/>
      
      <assert id="SCH-MLS-31" flag="fatal" test="not(contains($src, ' ')) and contains($cl_src, concat(' ', $src, ' '))">[SCH-MLS-31] The Status Reason Code (<value-of select="$src"/>) MUST be coded according to the code list</assert>
    </rule>
  </pattern>
</schema>