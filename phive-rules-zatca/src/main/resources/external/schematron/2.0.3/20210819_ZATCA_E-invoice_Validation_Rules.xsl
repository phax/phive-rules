<?xml version="1.0" encoding="UTF-8"?>
<!--

This file is part of Zakat, Tax and Customs Authority "ZATCA" e-Invoicing toolkit SDK.

Copyright 2021 ZATCA licensed under the GNU LGPL v3.

The License text is included within the LICENSE.txt file in the root folder.

-->
<xsl:transform xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
               xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
               xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
               xmlns:dn="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"
               xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
               xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:sac="urn:oasis:names:specification:ubl:schema:xsd:SignatureAggregateComponents-2"
               xmlns:sbc="urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:sig="urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2"
               xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
               xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="2.0">
   <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/"
                    xmlns:dct="http://purl.org/dc/terms/"
                    xmlns:skos="http://www.w3.org/2004/02/skos/core#">
      <dct:creator>
         <dct:Agent>
            <skos:prefLabel>SchXslt/${project.version} SAXON/HE 10.5</skos:prefLabel>
            <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
         </dct:Agent>
      </dct:creator>
      <dct:created>2021-08-31T19:22:55.011988533+02:00</dct:created>
   </rdf:Description>
   <xsl:output indent="yes"/>
   <xsl:template match="/">
      <xsl:variable name="metadata" as="element()?">
         <svrl:metadata xmlns:dct="http://purl.org/dc/terms/"
                        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                        xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
            <dct:creator>
               <dct:Agent>
                  <skos:prefLabel>
                     <xsl:variable name="prefix"
                                   as="xs:string?"
                                   select="if (doc-available('')) then in-scope-prefixes(document('')/*[1])[namespace-uri-for-prefix(., document('')/*[1]) eq 'http://www.w3.org/1999/XSL/Transform'][1] else ()"/>
                     <xsl:choose>
                        <xsl:when test="empty($prefix)">Unknown</xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of separator="/"
                                         select="(system-property(concat($prefix, ':product-name')), system-property(concat($prefix,':product-version')))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </skos:prefLabel>
               </dct:Agent>
            </dct:creator>
            <dct:created>
               <xsl:value-of select="current-dateTime()"/>
            </dct:created>
            <dct:source>
               <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/">
                  <dct:creator>
                     <dct:Agent>
                        <skos:prefLabel>SchXslt/${project.version} SAXON/HE 10.5</skos:prefLabel>
                        <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
                     </dct:Agent>
                  </dct:creator>
                  <dct:created>2021-08-31T19:22:55.011988533+02:00</dct:created>
               </rdf:Description>
            </dct:source>
         </svrl:metadata>
      </xsl:variable>
      <xsl:variable name="report" as="element(schxslt:report)">
         <schxslt:report>
            <xsl:call-template name="d7e29"/>
         </schxslt:report>
      </xsl:variable>
      <xsl:variable name="schxslt:report" as="node()*">
         <!-- PH disabled metadata
         <xsl:sequence select="$metadata"/>
         -->
         <xsl:for-each select="$report/schxslt:pattern">
            <xsl:sequence select="node()"/>
            <xsl:sequence select="$report/schxslt:rule[@pattern = current()/@id]/node()"/>
         </xsl:for-each>
      </xsl:variable>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
         <svrl:ns-prefix-in-attribute-values prefix="ext"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cbc"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cac"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="sig"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="sac"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:SignatureAggregateComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="sbc"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="qdt"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="udt"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cn"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="dn"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="ubl"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
         <xsl:sequence select="$schxslt:report"/>
      </svrl:schematron-output>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template name="d7e29">
      <schxslt:pattern id="d7e29">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e185">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_Attachment_QR_binary">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e194">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_customerParty_HQ">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e203">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_companyId_HQ">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e212">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_customerParty_SA">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e225">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_typeCode_01">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e246">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_typeCode_01_388">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e255">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_typeCode_01_Registration">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e264">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_Code_383_381">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e276">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_typeCode_02">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e291">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_typeCode_5">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e301">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_typeCode_5_0_Company">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e310">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_typeCode_5__HQ">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e319">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_typeCode_5_0_HQ">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e328">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="Decimals">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e355">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CodeList">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e385">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="Formats_allfields">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e395">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="Formats">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e416">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="EN16931">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e474">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="EN16931_baseAmount">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <xsl:apply-templates mode="d7e29" select="/"/>
   </xsl:template>
   <xsl:template match="/ubl:Invoice | /cn:CreditNote" priority="49" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice | /cn:CreditNote" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReasonCode) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReasonCode) &gt; 13">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-121">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReasonCode) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReasonCode) &gt; 13</xsl:attribute>
                     <svrl:text>[BT-121]-Field character limit for VAT exemption reason code field has been exceeded. The maximum limit for this field is 13.</svrl:text>
                     <svrl:message-code>BT-CL-121</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:UUID) and string-length(cbc:UUID) &gt; 36">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-KSA-03">
                     <xsl:attribute name="test">exists(cbc:UUID) and string-length(cbc:UUID) &gt; 36</xsl:attribute>
                     <svrl:text>[BR-KSA-03]-Field character limit for UUID field has been exceeded. The maximum limit for this field is 36.</svrl:text>
                     <svrl:message-code>BR-CL-KSA-03</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:OrderReference) and string-length(cac:OrderReference) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-13">
                     <xsl:attribute name="test">exists(cac:OrderReference) and string-length(cac:OrderReference) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-13]-Field character limit for Order Reference field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BR-CL-13</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:BillingReference) and string-length(cac:BillingReference) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-25">
                     <xsl:attribute name="test">exists(cac:BillingReference) and string-length(cac:BillingReference) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-25]-Field character limit for Billing Reference field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BR-CL-25</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:ContractDocumentReference) and string-length(cac:ContractDocumentReference) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-12">
                     <xsl:attribute name="test">exists(cac:ContractDocumentReference) and string-length(cac:ContractDocumentReference) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-12]-Field character limit for Contract Document Reference field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BR-CL-12</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:UUID) and (cbc:UUID) != '' and matches(cbc:UUID, '^[\w.-]+'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-03">
                     <xsl:attribute name="test">exists(cbc:UUID) and (cbc:UUID) != '' and matches(cbc:UUID, '^[\w.-]+')</xsl:attribute>
                     <svrl:text>[BR-KSA-03]-The invoice must contain a unique identifier ("UUID") (KSA-1) given by the unit that issued the document (unique message identifier for interchange process). This value must contain only letters, digits, and dashes.</svrl:text>
                     <svrl:message-code>BR-KSA-03</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
               <xsl:if test="not((cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR'] and exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and (cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) != '' and (cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject[normalize-space(@mimeCode) = 'text/plain'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-27">
                     <xsl:attribute name="test">(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR'] and exists(cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and (cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) != '' and (cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject[normalize-space(@mimeCode) = 'text/plain']))</xsl:attribute>
                     <svrl:text>[BR-KSA-27]-The document must contain aa QR code (KSA-14), and this code must be base64Binary.
                        Please refer to the Security Features Implementation Standards for more details.</svrl:text>
                     <svrl:message-code>BR-KSA-27</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               </xsl:if>

               <xsl:if test="exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']) and exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and string-length(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) &gt; 255">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-KSA-13">
                     <xsl:attribute name="test">exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']) and exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and string-length(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) &gt; 64</xsl:attribute>
                     <svrl:text>[KSA-13]-Field character limit for Previous invoice hash field has been exceeded. The maximum limit for this field is 64.</svrl:text>
                     <svrl:message-code>BR-CL-KSA-13</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:TaxCurrencyCode) and string-length(cbc:TaxCurrencyCode) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-06">
                     <xsl:attribute name="test">exists(cbc:TaxCurrencyCode) and string-length(cbc:TaxCurrencyCode) &gt; 3</xsl:attribute>
                     <svrl:text>[BT-06]-Field character limit for Tax Currency Code field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>BR-CL-06</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:IssueTime) and string-length(cbc:IssueTime) &gt; 24">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-70">
                     <xsl:attribute name="test">exists(cbc:IssueTime) and string-length(cbc:IssueTime) &gt; 24</xsl:attribute>
                     <svrl:text>[BR-KSA-70]-Field character limit for Issue Time field has been exceeded. The maximum limit for this field is 24.</svrl:text>
                     <svrl:message-code>BR-KSA-CL-70</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AdditionalDocumentReference/cbc:UUID) and string-length(cac:AdditionalDocumentReference/cbc:UUID) &gt; 19">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-KSA-16">
                     <xsl:attribute name="test">exists(cac:AdditionalDocumentReference/cbc:UUID) and string-length(cac:AdditionalDocumentReference/cbc:UUID) &gt; 19</xsl:attribute>
                     <svrl:text>[KSA-16]-Field character limit for Invoice Counter Value field has been exceeded. The maximum limit for this field is 19.</svrl:text>
                     <svrl:message-code>BR-CL-KSA-16</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and string-length(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) &gt; 500">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-KSA-14">
                     <xsl:attribute name="test">exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and string-length(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'QR']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) &gt; 500.</xsl:attribute>
                     <svrl:text>[KSA-14]-Field character limit for QR field has been exceeded. The maximum limit for this field is 500.</svrl:text>
                     <svrl:message-code>BR-CL-KSA-14</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'ICV'] and (cac:AdditionalDocumentReference/cbc:UUID) != ''))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-33">
                     <xsl:attribute name="test">(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'ICV'] and (cac:AdditionalDocumentReference/cbc:UUID) != '')</xsl:attribute>
                     <svrl:text>[BR-KSA-33]-Each invoice must have an invoice counter value (KSA-16).</svrl:text>
                     <svrl:message-code>BR-KSA-33</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(matches(cac:AdditionalDocumentReference/cbc:UUID, '^[0-9]*$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-34">
                     <xsl:attribute name="test">matches(cac:AdditionalDocumentReference/cbc:UUID, '^[0-9]*$')</xsl:attribute>
                     <svrl:text>[BR-KSA-34]-The invoice counter value (KSA-16) contains only digits.</svrl:text>
                     <svrl:message-code>BR-KSA-34</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) != '' and (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID = 'HQ'])) or ((cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) != '' and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[normalize-space(cbc:ID) = 'VAT'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-39">
                     <xsl:attribute name="test">((cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) != '' and (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID = 'HQ'])) or ((cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) != '' and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[normalize-space(cbc:ID) = 'VAT']))</xsl:attribute>
                     <svrl:text>[BR-KSA-39]-The invoice must contain the seller VAT registration number (BT-31) and/or seller group VAT registration number (KSA-18).</svrl:text>
                     <svrl:message-code>BR-KSA-39</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH'] and exists(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and (cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) != '' and (cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject[normalize-space(@mimeCode) = 'text/plain'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-61">
                     <xsl:attribute name="test">(cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH'] and exists(cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and (cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) != '' and (cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject[normalize-space(@mimeCode) = 'text/plain']))</xsl:attribute>
                     <svrl:text>[BR-KSA-61]-Previous invoice hash (KSA-13) must exist in an invoice.</svrl:text>
                     <svrl:message-code>BR-KSA-61</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxCurrencyCode) and (cbc:TaxCurrencyCode) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-68">
                     <xsl:attribute name="test">exists(cbc:TaxCurrencyCode) and (cbc:TaxCurrencyCode) != ''</xsl:attribute>
                     <svrl:text>[BR-KSA-68]-Tax currency code (BT-6) must exist in an invoice.</svrl:text>
                     <svrl:message-code>BR-KSA-68</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-EDU'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-HEA']"
                 priority="48"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-EDU'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-HEA']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-EDU'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-HEA']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-EDU'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReasonCode = 'VATEX-SA-HEA']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) and (//cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) = 'NAT')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-49">
                     <xsl:attribute name="test">exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) and (//cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) = 'NAT'</xsl:attribute>
                     <svrl:text>[BR-KSA-49]-If the tax exemption reason code (BT-121) is equal to VATEX-SA-EDU or VATEX-SA-HEA, then the other buyer ID (BT-46) is mandatory  and must be national ID (BT-46-1 = NAT).</svrl:text>
                     <svrl:message-code>BR-KSA-49</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:IssueDate" priority="47" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:IssueDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(xs:date(.) &lt;= current-date())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-04">
                     <xsl:attribute name="test">xs:date(.) &lt;= current-date()</xsl:attribute>
                     <svrl:text>[BR-KSA-04]-The document issue date (BT-2) must be less or equal to the current date.</svrl:text>
                     <svrl:message-code>BR-KSA-04</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode" priority="46" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(not(contains(normalize-space(.), ' ')) and contains(' 388 383 381 ', concat(' ', normalize-space(.), ' ')))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-05">
                     <xsl:attribute name="test">not(contains(normalize-space(.), ' ')) and contains(' 388 383 381 ', concat(' ', normalize-space(.), ' '))</xsl:attribute>
                     <svrl:text>[BR-KSA-05]-The invoice type code (BT-3) must be equal to one of value from the subset of UN/CEFACT code list 1001, D.16B agreed for KSA electronic invoices.</svrl:text>
                     <svrl:message-code>BR-KSA-05</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((substring(@name,1,2) = '01') or (substring(@name,1,2) = '02'))                 and ((substring(@name,3,1) = '0') or (substring(@name,3,1) = '1'))                 and ((substring(@name,4,1) = '0') or (substring(@name,4,1) = '1'))                 and ((substring(@name,5,1) = '0') or (substring(@name,5,1) = '1'))                 and ((substring(@name,6,1) = '0') or (substring(@name,6,1) = '1'))                 and ((substring(@name,7,1) = '0') or (substring(@name,7,1) = '1')))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-06">
                     <xsl:attribute name="test">((substring(@name,1,2) = '01') or (substring(@name,1,2) = '02'))                 and ((substring(@name,3,1) = '0') or (substring(@name,3,1) = '1'))                 and ((substring(@name,4,1) = '0') or (substring(@name,4,1) = '1'))                 and ((substring(@name,5,1) = '0') or (substring(@name,5,1) = '1'))                 and ((substring(@name,6,1) = '0') or (substring(@name,6,1) = '1'))                 and ((substring(@name,7,1) = '0') or (substring(@name,7,1) = '1'))</xsl:attribute>
                     <svrl:text>[BR-KSA-06]-The invoice transaction code (KSA-2) must exist and respect the following structure:
                        NNPNESB
                        where
                        NN (positions 1 and 2) = invoice subtype:
                        - 01 for tax invoice
                        - 02 for simplified tax invoice
                        P (position 3) = 3rd Party invoice transaction, 0 for false, 1 for true
                        N (position 4) = Nominal invoice transaction, 0 for false, 1 for true
                        E (position 5) = Exports invoice transaction, 0 for false, 1 for true
                        S (position 6) = Summary invoice transaction, 0 for false, 1 for true
                        B (position 7) = Self billed invoice
                     </svrl:text>
                     <svrl:message-code>BR-KSA-06</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"
                 priority="45"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(.) and string-length(.) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-155">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ID) and string-length(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ID) &gt; 127</xsl:attribute>
                     <svrl:text>[BT-155]-Field character limit for Item Seller's identifier field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BT-CL-155</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(.) and string-length(.) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-157">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID) and string-length(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID) &gt; 127</xsl:attribute>
                     <svrl:text>[BT-157]-Field character limit for Item standard identifier field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BT-CL-157</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not( string-length(./@schemeID) &gt; 0 and contains(' CRN MOM MLS SAG OTH ', ./@schemeID)                 and (matches((.), '^[a-zA-Z0-9]*$')))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-08">
                     <xsl:attribute name="test">contains(' CRN MOM MLS SAG OTH ', ./@schemeID)                 and (matches((.), '^[a-zA-Z0-9]*$'))</xsl:attribute>
                     <svrl:text>[BR-KSA-08]-The seller identification (BT-29) must exist only once with one of the scheme ID (BT-29-1) (CRN, MOM, MLS, SAG, OTH) and  must contain only alphanumeric characters.
                        - Commercial Registration number with "CRN" as schemeID
                        - Momra license with "MOM" as schemeID
                        - MLSD license with "MLS" as schemeID
                        - Sagia license with "SAG" as schemeID
                        - Other OD with "OTH" as schemeID.
                     </svrl:text>
                     <svrl:message-code>BR-KSA-08</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(matches((.), '^[a-zA-Z0-9]*$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-19">
                     <xsl:attribute name="test">matches((.), '^[a-zA-Z0-9]*$')</xsl:attribute>
                     <svrl:text>[BR-KSA-19]-If seller identification (BT-29) has scheme ID (BT-29-1) equal to one of the values VD, seller identification (BT-29) must contain only alphanumeric characters.</svrl:text>
                     <svrl:message-code>BR-KSA-19</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(.) and string-length(.) &gt; 15">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-29">
                     <xsl:attribute name="test">exists(.) and string-length(.) &gt; 15</xsl:attribute>
                     <svrl:text>[BR-29]-Field character limit for Other seller ID field has been exceeded. The maximum limit for this field is 15.</svrl:text>
                     <svrl:message-code>BR-CL-29</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                 priority="44"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not( string-length(./@schemeID) &gt; 0 and contains(' NAT TIN IQA PAS CRN MOM MLS SAG GCC OTH ', ./@schemeID)                 and (matches((.), '^[a-zA-Z0-9]*$')))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-14">
                     <xsl:attribute name="test">contains(' NAT TIN IQA PAS CRN MOM MLS SAG GCC OTH ', ./@schemeID)                 and (matches((.), '^[a-zA-Z0-9]*$'))</xsl:attribute>
                     <svrl:text>[BR-KSA-14]-The buyer identification (BT-46) must exist only once with one of the scheme ID (BT-46-1) (NAT, IQA, PAS, CRN, MOM, MLS, SAG, GCC, OTH) and  must contain only alphanumeric characters.
                        - National ID with "NAT" as schemeID
                        - Tax Identification Number "TIN" as schemeID
                        - Iqama Number with "IQA" as schemeID
                        - Passport ID with "PAS" as schemeID
                        - Commercial registration number with "CRN" as schemeID
                        - Momra license with "MOM" as schemeID
                        - MLSD license with "MLS" as schemeID
                        - Sagia license with "SAG" as schemeID
                        - GCC ID with "GCC" as schemeID
                        - Other ID with "OTH" as schemeID
                     </svrl:text>
                     <svrl:message-code>BR-KSA-14</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(.) and string-length(.) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-156">
                     <xsl:attribute name="test">exists(.) and string-length(.) &gt; 127</xsl:attribute>
                     <svrl:text>[BT-156]-Field character limit for Item Buyer's identifier field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BT-CL-156</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress"
                 priority="43"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(cbc:StreetName) and string-length(cbc:StreetName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-35">
                     <xsl:attribute name="test">exists(cbc:StreetName) and string-length(cbc:StreetName) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-35]-Field character limit for Street Name field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BR-CL-35</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cbc:BuildingNumber) and string-length(cbc:BuildingNumber) &gt; 4">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-KSA-17">
                     <xsl:attribute name="test">exists(cbc:BuildingNumber) and string-length(cbc:BuildingNumber) &gt; 4</xsl:attribute>
                     <svrl:text>[KSA-17]-Field character limit for Building Number field has been exceeded. The maximum limit for this field is 4.</svrl:text>
                     <svrl:message-code>BR-CL-KSA-17</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:StreetName) and                 exists(cbc:BuildingNumber) and                 exists(cbc:PlotIdentification) and                 exists(cbc:CityName) and                 exists(cbc:PostalZone) and                 exists(cbc:CitySubdivisionName) and                 exists(cac:Country/cbc:IdentificationCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-KSA-09">
                     <xsl:attribute name="test">exists(cbc:StreetName) and                 exists(cbc:BuildingNumber) and                 exists(cbc:PlotIdentification) and                 exists(cbc:CityName) and                 exists(cbc:PostalZone) and                 exists(cbc:CitySubdivisionName) and                 exists(cac:Country/cbc:IdentificationCode)</xsl:attribute>
                     <svrl:text>[BR-KSA-09]-Seller address must contain additional number (KSA-23), street name (BT-35), building number (KSA-17), postal code (BT-38), city (BT-37), Neighborhood (KSA-3), country code (BT-40).

                        For more information please access this link: https://www.address.gov.sa/en/address-format/overview
                     </svrl:text>
                     <svrl:message-code>BR-KSA-09</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-51">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-51]-Field character limit for Additional Street Name field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-51</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-37">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-37]-Field character limit for city name field has been exceeded. The maximum
                        limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-37</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:AdditionalStreetName) and string-length(cbc:AdditionalStreetName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-36">
                     <xsl:attribute name="test">exists(cbc:AdditionalStreetName) and string-length(cbc:AdditionalStreetName) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-36]-Field character limit for Addtional Street Name field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BR-CL-36</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <!--               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >-->
               <!--                  <xsl:if test="not(exists(cbc:StreetName) and                 exists(cbc:BuildingNumber) and                 exists(cbc:PlotIdentification) and                 exists(cbc:CityName) and                 exists(cbc:PostalZone) and                 exists(cbc:CitySubdivisionName) and                 exists(cac:Country/cbc:IdentificationCode))">-->

               <!--                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"-->
               <!--                                         location="{schxslt:location(.)}"-->
               <!--                                         flag="error"-->
               <!--                                         id="BR-KSA-09">-->
               <!--                        <xsl:attribute name="test">exists(cbc:StreetName) and                 exists(cbc:BuildingNumber) and                 exists(cbc:PlotIdentification) and                 exists(cbc:CityName) and                 exists(cbc:PostalZone) and                 exists(cbc:CitySubdivisionName) and                 exists(cac:Country/cbc:IdentificationCode)</xsl:attribute>-->
               <!--                        <svrl:text>[BR-KSA-09]-Seller address must contain additional number (KSA-23), street name (BT-35), building number (KSA-17), postal code (BT-38), city (BT-37), Neighborhood (KSA-3), country code (BT-40).-->

               <!--                           For more information please access this link: https://www.address.gov.sa/en/address-format/overview-->
               <!--                        </svrl:text>-->
               <!--                        <svrl:message-code>BR-KSA-09</svrl:message-code>-->
               <!--                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>-->
               <!--                     </svrl:failed-assert>-->
               <!--                  </xsl:if>-->
               <!--               </xsl:if>-->

               <xsl:if test="not(exists(cbc:PlotIdentification) and matches(cbc:PlotIdentification, '^[0-9]{4}$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-64">
                     <xsl:attribute name="test">exists(cbc:PlotIdentification) and matches(cbc:PlotIdentification, '^[0-9]{4}$')</xsl:attribute>
                     <svrl:text>[BR-KSA-64]-Seller Address Additional number (KSA-23) must be 4 digits.</svrl:text>
                     <svrl:message-code>BR-KSA-64</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:PostalZone) and matches(cbc:PostalZone, '^[0-9]{5}$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-66">
                     <xsl:attribute name="test">exists(cbc:PostalZone) and matches(cbc:PostalZone, '^[0-9]{5}$')</xsl:attribute>
                     <svrl:text>[BR-KSA-66]-Seller postal code (BT-38) must be 5 digits.</svrl:text>
                     <svrl:message-code>BR-KSA-66</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment"
                 priority="41"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference[normalize-space(cbc:ID) = 'PIH']/cac:Attachment</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (cbc:EmbeddedDocumentBinaryObject[normalize-space(@mimeCode) = 'text/plain']))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-26">
                     <xsl:attribute name="test">exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (cbc:EmbeddedDocumentBinaryObject[normalize-space(@mimeCode) = 'text/plain'])</xsl:attribute>
                     <svrl:text>[BR-KSA-26]-If the invoiceinvoice contains the previous invoice hash (KSA-13), this hashmust be base64 encoded SHA256.
                        This hash will be computed from all the elements of the previous invoice:
                        - UBL invoice
                        - hash of the previous invoice (of the previous invoice)
                        - QR code
                        - cryptographic stamp</svrl:text>
                     <svrl:message-code>BR-KSA-26</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference/cac:Attachment"
                 priority="40"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AdditionalDocumentReference/cac:Attachment" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference/cac:Attachment</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference/cac:Attachment</xsl:attribute>
               </svrl:fired-rule>


               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
                  <xsl:if test="not(exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/sig:UBLDocumentSignatures/sac:SignatureInformation/cbc:ID) = 'urn:oasis:names:specification:ubl:signature:1')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-28">
                        <xsl:attribute name="test">exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/sig:UBLDocumentSignatures/sac:SignatureInformation/cbc:ID) = 'urn:oasis:names:specification:ubl:signature:1'</xsl:attribute>
                        <svrl:text>[BR-KSA-28]-If the cryptographic stamp (KSA-15) exists in the invoice, this cryptographic stamp (KSA-15) must contain the exact  "urn:oasis:names:specification:ubl:signature:1" value for signature information ID.</svrl:text>
                        <svrl:message-code>BR-KSA-28</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
                  <xsl:if test="not(exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (//cac:Signature/cbc:ID) = 'urn:oasis:names:specification:ubl:signature:Invoice')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-29">
                        <xsl:attribute name="test">exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (//cac:Signature/cbc:ID) = 'urn:oasis:names:specification:ubl:signature:Invoice'</xsl:attribute>
                        <svrl:text>[BR-KSA-29]-If the cryptographic stamp (KSA-15) exists in the invoice, this  cryptographic stamp (KSA-15) must contain the exact  "urn:oasis:names:specification:ubl:signature:Invoice" value for referenced signature ID and signature ID.</svrl:text>
                        <svrl:message-code>BR-KSA-29</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>


               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
                  <xsl:if test="not(exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (//cac:Signature/cbc:SignatureMethod) = 'urn:oasis:names:specification:ubl:dsig:enveloped:xades')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-30">
                        <xsl:attribute name="test">exists(cbc:EmbeddedDocumentBinaryObject) and (cbc:EmbeddedDocumentBinaryObject) != '' and (//cac:Signature/cbc:SignatureMethod) = 'urn:oasis:names:specification:ubl:dsig:enveloped:xades'</xsl:attribute>
                        <svrl:text>[BR-KSA-30]-The document cryptographic stamp (KSA-15) must contain the exact  "urn:oasis:names:specification:ubl:dsig:enveloped:xades" value for signature method.</svrl:text>
                        <svrl:message-code>BR-KSA-30</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:Delivery/cbc:LatestDeliveryDate"
                 priority="39"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:Delivery/cbc:LatestDeliveryDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:Delivery/cbc:LatestDeliveryDate</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:Delivery/cbc:LatestDeliveryDate</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(../cbc:ActualDeliveryDate) and (../cbc:ActualDeliveryDate) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-35">
                     <xsl:attribute name="test">exists(../cbc:ActualDeliveryDate) and (../cbc:ActualDeliveryDate) != ''</xsl:attribute>
                     <svrl:text>[BR-KSA-35]-If the invoice contains a supply end date (KSA-2424), then the invoice must contain a supply date (KSA-5).</svrl:text>
                     <svrl:message-code>BR-KSA-35</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length(.) &gt; 0 and not(xs:date(.) &gt; xs:date(../cbc:ActualDeliveryDate) )">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-36">
                     <xsl:attribute name="test">xs:date(.) &gt; xs:date(../cbc:ActualDeliveryDate) </xsl:attribute>
                     <svrl:text>[BR-KSA-36]-If the invoice contains a supply end date (KSA-24), then this date must be greater than the supply date (KSA-5).</svrl:text>
                     <svrl:message-code>BR-KSA-36</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party"
                 priority="38"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingSupplierParty/cac:Party" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(cac:PostalAddress/cbc:BuildingNumber, '^[0-9]{4}$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-37">
                     <xsl:attribute name="test">matches(cac:PostalAddress/cbc:BuildingNumber, '^[0-9]{4}$')</xsl:attribute>
                     <svrl:text>[BR-KSA-37]-The seller address building number must contain 4 digits.</svrl:text>
                     <svrl:message-code>BR-KSA-37</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'SA')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-38">
                     <xsl:attribute name="test">(cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'SA'</xsl:attribute>
                     <svrl:text>[BR-KSA-38]-The seller address country code (BT-40) must be "SA".</svrl:text>
                     <svrl:message-code>BR-KSA-38</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[cbc:ID = 'VAT'][//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]"
                 priority="37"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[cbc:ID = 'VAT'][//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[cbc:ID = 'VAT'][//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[cbc:ID = 'VAT'][//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '^[0-9]{15}$') and starts-with(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3') and ends-with(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-40">
                     <xsl:attribute name="test">matches(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '^[0-9]{15}$') and starts-with(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3') and ends-with(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3')</xsl:attribute>
                     <svrl:text>[BR-KSA-40]-If it exists in the invoice, the seller VAT registration number (BT-31) must contain 15 digits. The first and the last digits are "3".</svrl:text>
                     <svrl:message-code>BR-KSA-40</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party"
                 priority="36"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingCustomerParty/cac:Party" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >

                  <xsl:if test="not((cac:PartyLegalEntity/cbc:RegistrationName) != '')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-42">
                        <xsl:attribute name="test">(cac:PartyLegalEntity/cbc:RegistrationName) != ''</xsl:attribute>
                        <svrl:text>[BR-42]-The buyer name (BT-44) must be present in the tax invoice and associated credit notes and debit notes (KSA-2, position 1 and 2 = 01). </svrl:text>
                        <svrl:message-code>BR-KSA-42</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:TaxTotal" priority="35" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:TaxTotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:TaxTotal</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:TaxTotal</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="exists(cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount) and  string-length(cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="Error"
                                      id="KSA-CL-11">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount) and  string-length(cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount) &gt; 14</xsl:attribute>
                     <svrl:text>[KSA-11]-Field character limit for VAT line amount field has been exceeded. The maximum limit for this field is 14.BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 14..</svrl:text>
                     <svrl:message-code>KSA-CL-11</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="exists(cac:InvoiceLine/cbc:LineExtensionAmount) and string-length(cac:InvoiceLine/cbc:LineExtensionAmount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="Error"
                                      id="BT-CL-131">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:LineExtensionAmount) and string-length(cac:InvoiceLine/cbc:LineExtensionAmount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-131</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
                  <xsl:if test="not((cbc:TaxAmount) = (../cbc:LineExtensionAmount) * (../cac:Item/cac:ClassifiedTaxCategory/cbc:Percent div 100))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-50">
                        <xsl:attribute name="test">(cbc:TaxAmount) = (../cbc:LineExtensionAmount) * (../cac:Item/cac:ClassifiedTaxCategory/cbc:Percent div 100)</xsl:attribute>
                        <svrl:text>[BR-KSA-50]-The line VAT amount (KSA-11) must be Invoice line net amount (BT-131) x (Line VAT rate (BT-152)/100).</svrl:text>
                        <svrl:message-code>BR-KSA-50</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
                  <xsl:if test="not((cbc:RoundingAmount) = (../cbc:LineExtensionAmount) + (cbc:TaxAmount))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-51">
                        <xsl:attribute name="test">(cbc:RoundingAmount) = (../cbc:LineExtensionAmount) + (cbc:TaxAmount)</xsl:attribute>
                        <svrl:text>[BR-KSA-51]-The  line amount with VAT (KSA-12) must be Invoice line net amount (BT-131) + Line VAT amount (KSA-11).</svrl:text>
                        <svrl:message-code>BR-KSA-51</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"
                 priority="34"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >
                  <xsl:if test="not(((substring(//cbc:InvoiceTypeCode/@name, 5,1) = '1') and (.) != 'SA')                 or ((substring(//cbc:InvoiceTypeCode/@name, 5,1) = '0') and (.) = 'SA'))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-62">
                        <xsl:attribute name="test">((substring(//cbc:InvoiceTypeCode/@name, 5,1) = '1') and (.) != 'SA')                 or ((substring(//cbc:InvoiceTypeCode/@name, 5,1) = '0') and (.) = 'SA')</xsl:attribute>
                        <svrl:text> If the buyer country code (BT-55) exists in the invoice, and If it is not an export invoice (KSA-2, position 5 is false), then the country code (BT-55) must be "SA"  </svrl:text>
                        <svrl:message-code>BR-KSA-62</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="33"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e29']">
            <schxslt:rule pattern="d7e29">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e29">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:TaxExemptionReason) and (cbc:TaxExemptionReason) != '' and exists(cbc:TaxExemptionReasonCode) and (cbc:TaxExemptionReasonCode) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-69">
                     <xsl:attribute name="test">exists(cbc:TaxExemptionReason) and (cbc:TaxExemptionReason) != '' and exists(cbc:TaxExemptionReasonCode) and (cbc:TaxExemptionReasonCode) != ''</xsl:attribute>
                     <svrl:text>[BR-KSA-69]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall have a VAT exception reason code (BT-121) and VAT exception reason text (BT-120).</svrl:text>
                     <svrl:message-code>BR-KSA-69</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReason) and  string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReason) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-120">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReason) and  string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:TaxExemptionReason) &gt; 127</xsl:attribute>
                     <svrl:text>[BT-120]-Field character limit for VAT exemption reason text field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BT-CL-120</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID) and  string-length(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-21">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID) and  string-length(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID) &gt; 3</xsl:attribute>
                     <svrl:text>[KSA-21]-Field character limit for Tax scheme ID field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>KSA-CL-21</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="exists(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) and  string-length(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-21-109">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) and  string-length(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) &gt; 3</xsl:attribute>
                     <svrl:text>[KSA-21]-Field character limit for Tax scheme ID field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>KSA-CL-21-109</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e29')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[normalize-space(@schemeID) = 'HQ']"
                 priority="31"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e194']">
            <schxslt:rule pattern="d7e194">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[normalize-space(@schemeID) = 'HQ']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[normalize-space(@schemeID) = 'HQ']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e194">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[normalize-space(@schemeID) = 'HQ']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches((.), '^[0-9]*$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-21">
                     <xsl:attribute name="test">matches((.), '^[0-9]*$')</xsl:attribute>
                     <svrl:text>[BR-KSA-21]-If buyer identification (BT-46) has scheme ID (BT-46-1) equal to HQ, buyer identification (BT-46) must contain only digits.</svrl:text>
                     <svrl:message-code>BR-KSA-21</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e194')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']"
                 priority="30"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e203']">
            <schxslt:rule pattern="d7e203">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e203">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(., '^[0-9]{15}$') and starts-with(., '3') and ends-with(., '3') and substring(., 11,1) = '1')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-41">
                     <xsl:attribute name="test">matches(., '^[0-9]{15}$') and starts-with(., '3') and ends-with(., '3') and substring(., 11,1) = '1'</xsl:attribute>
                     <svrl:text>[BR-KSA-41]-If it exists in the invoice, the seller group VAT registration number (KSA-18) must contain 15 digits. The first and the last digits are "3". The eleventh digit must be "1".</svrl:text>
                     <svrl:message-code>BR-KSA-41</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e203')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country[cbc:IdentificationCode = 'SA']"
                 priority="29"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e212']">
            <schxslt:rule pattern="d7e212">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country[cbc:IdentificationCode = 'SA']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country[cbc:IdentificationCode = 'SA']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e212">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country[cbc:IdentificationCode = 'SA']</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >
                  <xsl:if test="not((exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-63">
                        <xsl:attribute name="test">(exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))</xsl:attribute>
                        <svrl:text>[BR-KSA-63]-If the buyer country code (BT-55) is "SA", then these fields are mandatory:additional number (KSA-19), street name (BT-35), building number (KSA-17),postal code (BT-38),  city (BT-37), Neighborhood (KSA-3), country code (BT-40).</svrl:text>
                        <svrl:message-code>BR-KSA-63</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>
               <xsl:if test="exists(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and string-length(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)&gt;127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-3">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and string-length(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)&gt;127
                     </xsl:attribute>
                     <svrl:text>[KSA-3]-Field character limit for Neighborhood field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>KSA-CL-3</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) &gt; 4">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-19">
                     <xsl:attribute name="test">
                        string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) &gt; 4
                     </xsl:attribute>
                     <svrl:text>[KSA-19]-Field character limit for Additional number field has been exceeded. The maximum limit for this field is 4.
                     </svrl:text>
                     <svrl:message-code>KSA-CL-19</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'SA' and not(matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone, '^[0-9]{5}$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-67">
                     <xsl:attribute name="test">matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone, '^[0-9]{5}$')</xsl:attribute>
                     <svrl:text>[BR-KSA-67]-If the buyer country code (BT-55) is "SA", then the Buyer postal code  (BT-53) must be 5 digits.</svrl:text>
                     <svrl:message-code>BR-KSA-67</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '02\d{3}6\d')])">
                  <xsl:if test="not(exists(//cac:AccountingCustomerParty/cac:Party//cac:PartyLegalEntity/cbc:RegistrationName) and //cac:AccountingCustomerParty/cac:Party//cac:PartyLegalEntity/cbc:RegistrationName != '')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-71">
                        <xsl:attribute name="test">not(exists(//cac:AccountingCustomerParty/cac:Party//cac:PartyLegalEntity/cbc:RegistrationName) and //cac:AccountingCustomerParty/cac:Party//cac:PartyLegalEntity/cbc:RegistrationName != '')</xsl:attribute>
                        <svrl:text>If the Invoice is a simplified invoice type and is a summary invoice (KSA-2, position 1 and 2 = 02, position 6 = 1), then the buyer name must be present
                        </svrl:text>
                        <svrl:message-code>BR-KSA-71</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>

               <!--               <xsl:if test="boolean(//*[matches(@name, '^02\d{3}1\d$')])">-->
               <!--                  <xsl:if test="not(//cbc:ActualDeliveryDate and //cbc:LatestDeliveryDate)">-->
               <!--                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"-->
               <!--                                         location="{schxslt:location(.)}"-->
               <!--                                         flag="error"-->
               <!--                                         id="BR-KSA-72">-->
               <!--                        <xsl:attribute name="test">not(exists(/Invoice/cac:Delivery/cbc:ActualDeliveryDate)) or not(exists(/Invoice/cac:Delivery/cbc:LatestDeliveryDate))</xsl:attribute>-->
               <!--                        <svrl:text>If the Invoice is a simplified invoice type and is a summary invoice (KSA-2, position 1 and 2 = 02, position 6 = 1), then a supply date (KSA-5) and supply end date (KSA-24) must be present-->
               <!--                        </svrl:text>-->
               <!--                        <svrl:message-code>BR-KSA-72</svrl:message-code>-->
               <!--                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>-->
               <!--                     </svrl:failed-assert>-->
               <!--                  </xsl:if>-->

               <!--               </xsl:if>-->


               <xsl:if test="(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'SA' and not(matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone, '^[0-9]{5}$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-67">
                     <xsl:attribute name="test">matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone, '^[0-9]{5}$')</xsl:attribute>
                     <svrl:text>[BR-KSA-67]-If the buyer country code (BT-55) is "SA", then the Buyer postal code  (BT-53) must be 5 digits.</svrl:text>
                     <svrl:message-code>BR-KSA-67</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e212')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']"
                 priority="28"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e225']">
            <schxslt:rule pattern="d7e225">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e225">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >
                  <xsl:if test="not(every $line in //cac:InvoiceLine satisfies exists($line/cac:TaxTotal/cbc:TaxAmount) and ($line/cac:TaxTotal/cbc:TaxAmount) != '')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-52">
                        <xsl:attribute name="test">every $line in //cac:InvoiceLine satisfies exists($line/cac:TaxTotal/cbc:TaxAmount) and ($line/cac:TaxTotal/cbc:TaxAmount) != ''</xsl:attribute>
                        <svrl:text>[BR-KSA-52]-The line VAT amount (KSA-11) is mandatory for tax invoice and associated credit notes and debit notes (KSA-2, position 1 and 2 = 01).</svrl:text>
                        <svrl:message-code>BR-KSA-52</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >
                  <xsl:if test="not(every $line in //cac:InvoiceLine satisfies exists($line/cac:TaxTotal/cbc:RoundingAmount) and ($line/cac:TaxTotal/cbc:RoundingAmount) != '')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-53">
                        <xsl:attribute name="test">every $line in //cac:InvoiceLine satisfies exists($line/cac:TaxTotal/cbc:RoundingAmount) and ($line/cac:TaxTotal/cbc:RoundingAmount) != ''</xsl:attribute>
                        <svrl:text>[BR-KSA-53]-The line amount with VAT (KSA-12) is mandatory for tax invoice and associated credit notes and debit notes (KSA-2, position 1 and 2 = 01).</svrl:text>
                        <svrl:message-code>BR-KSA-53</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>
               <xsl:if test="exists(//cac:PaymentMeans/cbc:PaymentMeansCode) and string-length(//cac:PaymentMeans/cbc:PaymentMeansCode) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-81">
                     <xsl:attribute name="test">
                        exists(//cac:PaymentMeans/cbc:PaymentMeansCode) and string-length(//cac:PaymentMeans/cbc:PaymentMeansCode) &gt; 3
                     </xsl:attribute>
                     <svrl:text>[BT-81]-Field character limit for Payment means type code field has been exceeded. The maximum limit for this field is 3.
                     </svrl:text>
                     <svrl:message-code>BT-CL-81</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) &gt; 2">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-55">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) &gt; 2
                     </xsl:attribute>
                     <svrl:text>[BT-55]-Field character limit for Country code field has been exceeded. The maximum limit for this field is 2.
                     </svrl:text>
                     <svrl:message-code>BT-CL-55</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-50">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-50]-Field character limit for Street Name field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-50</svrl:message-code>
                     <svrl:message-category>Business rules - length constraints(BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-52">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-52]-Field character limit for City Name field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-52</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="not(exists(//cac:PaymentMeans) and exists(//cac:PaymentMeans/cbc:PaymentMeansCode) and contains(' 10 30 42 48 1 ', //cac:PaymentMeans/cbc:PaymentMeansCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-16">
                     <xsl:attribute name="test">exists(//cac:PaymentMeans) and exists(//cac:PaymentMeans/cbc:PaymentMeansCode) and contains(' 10 30 42 48 1 ', //cac:PaymentMeans/cbc:PaymentMeansCode)</xsl:attribute>
                     <svrl:text>[BR-KSA-16]-Payment means code (BT-81) in an invoice must contain one of the values (10, 30, 42, 48, 1). In the simplified tax invoice and associated credit notes and debit notes (KSA-2, position 1 and 2 = 02) this value is optional.</svrl:text>
                     <svrl:message-code>BR-KSA-16</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="not(                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-10">
                     <xsl:attribute name="test">                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and                 exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)</xsl:attribute>
                     <svrl:text>[BR-KSA-10]-Buyer address must contain a street (BT-50), city (BT-52), postal code (BT-53), country code (BT-55). This rule does not apply on the simplified tax invoices and associated credit notes and debit notes (KSA-2, position 1 and 2 = 02).
                     </svrl:text>
                     <svrl:message-code>BR-KSA-10</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >
                  <xsl:if test="not(every $line in //cac:InvoiceLine satisfies exists($line/cac:TaxTotal/cbc:TaxAmount) and ($line/cac:TaxTotal/cbc:TaxAmount) != '')">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-54">
                        <xsl:attribute name="test">every $line in //cac:InvoiceLine satisfies exists($line/cac:TaxTotal/cbc:TaxAmount) and ($line/cac:TaxTotal/cbc:TaxAmount) != ''</xsl:attribute>
                        <svrl:text>[BR-KSA-54]-The line VAT amount (KSA-11) is mandatory for tax invoice and associated credit notes and debit notes (KSA-2, position 1 and 2 = 01).</svrl:text>
                        <svrl:message-code>BR-KSA-54</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e225')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice[cbc:InvoiceTypeCode ='388']]"
                 priority="27"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e246']">
            <schxslt:rule pattern="d7e246">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice[cbc:InvoiceTypeCode ='388']]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice[cbc:InvoiceTypeCode ='388']]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e246">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice[cbc:InvoiceTypeCode ='388']]</xsl:attribute>
               </svrl:fired-rule>


                  <xsl:if test="not(exists(//cac:Delivery/cbc:ActualDeliveryDate))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-15">
                        <xsl:attribute name="test">exists(//cac:Delivery/cbc:ActualDeliveryDate)</xsl:attribute>
                        <svrl:text>[BR-KSA-15]-The tax invoice ((invoice type code (BT-30) = 388) and (invoice transaction code (KSA-2) has "01" as first 2 digits)) must contain the supply date (KSA-5). </svrl:text>
                        <svrl:message-code>BR-KSA-15</svrl:message-code>
                        <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               <xsl:if test="exists(//cac:PaymentMeans/cbc:InstructionNote) and string-length(//cac:PaymentMeans/cbc:InstructionNote) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-10">
                     <xsl:attribute name="test">
                        exists(//cac:PaymentMeans/cbc:InstructionNote) and string-length(//cac:PaymentMeans/cbc:InstructionNote) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[KSA-10]-Field character limit for Reasons for issuance of credit / debit note field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>KSA-CL-10</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(//cac:Delivery/cbc:ActualDeliveryDate) and string-length(//cac:Delivery/cbc:ActualDeliveryDate) &gt; 10">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-5">
                     <xsl:attribute name="test">
                        exists(//cac:Delivery/cbc:ActualDeliveryDate) and string-length(//cac:Delivery/cbc:ActualDeliveryDate) &gt; 10
                     </xsl:attribute>
                     <svrl:text>[KSA-5]-Field character limit for Supply date (gregorian calendar) field has been exceeded. The maximum limit for this field is 10.
                     </svrl:text>
                     <svrl:message-code>KSA-CL-5</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e246')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice/cac:AccountingCustomerParty/cac:Party]"
                 priority="26"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e255']">
            <schxslt:rule pattern="d7e255">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice/cac:AccountingCustomerParty/cac:Party]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice/cac:AccountingCustomerParty/cac:Party]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e255">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01'][/ubl:Invoice/cac:AccountingCustomerParty/cac:Party]</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >

                  <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">
                     <xsl:if test="not(matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification, '^[0-9]{4}$'))">
                        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                            location="{schxslt:location(.)}"
                                            flag="error"
                                            id="BR-KSA-65">
                           <xsl:attribute name="test">exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification, '^[0-9]{4}$')</xsl:attribute>
                           <svrl:text>[BR-KSA-65]-Seller Address Additional number (KSA-23) must be 4 digits.</svrl:text>
                           <svrl:message-code>BR-KSA-65</svrl:message-code>
                           <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                        </svrl:failed-assert>
                     </xsl:if>

                  </xsl:if>

               </xsl:if>

               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >
                  <xsl:if test="not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification))">
                     <xsl:if test="not(matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification, '^[0-9]{4}$'))">
                        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                            location="{schxslt:location(.)}"
                                            flag="error"
                                            id="BR-KSA-65">
                           <xsl:attribute name="test">exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and matches(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification, '^[0-9]{4}$')</xsl:attribute>
                           <svrl:text>[BR-KSA-65]-Seller Address Additional number (KSA-23) must be 4 digits.</svrl:text>
                           <svrl:message-code>BR-KSA-65</svrl:message-code>
                           <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                        </svrl:failed-assert>
                     </xsl:if>
                  </xsl:if>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e255')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice[cbc:InvoiceTypeCode = '381'] | /ubl:Invoice[cbc:InvoiceTypeCode = '383']"
                 priority="25"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e264']">
            <schxslt:rule pattern="d7e264">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/ubl:Invoice[cbc:InvoiceTypeCode = '381'] | /ubl:Invoice[cbc:InvoiceTypeCode = '383']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice[cbc:InvoiceTypeCode = '381'] | /ubl:Invoice[cbc:InvoiceTypeCode = '383']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e264">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice[cbc:InvoiceTypeCode = '381'] | /ubl:Invoice[cbc:InvoiceTypeCode = '383']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(//cac:PaymentMeans/cbc:InstructionNote))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-17">
                     <xsl:attribute name="test">exists(//cac:PaymentMeans/cbc:InstructionNote)</xsl:attribute>
                     <svrl:text>[BR-KSA-17]-Debit and credit note (invoice type code (BT-3) is equal to 383 or 381) must contain the reason (KSA-10) for this invoice type issuing.</svrl:text>
                     <svrl:message-code>BR-KSA-17</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) and (//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-56">
                     <xsl:attribute name="test">exists(//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) and (//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) != ''</xsl:attribute>
                     <svrl:text>[BR-KSA-56]-For credit notes ((BT-3) has the value of 381) and debit notes ((BT-3) has the value of 383), the billing reference ID (BT-25) is  mandatory.</svrl:text>
                     <svrl:message-code>BR-KSA-56</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e264')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 1, 2) = '02']"
                 priority="24"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e276']">
            <schxslt:rule pattern="d7e276">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 1, 2) = '02']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '02']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e276">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '02']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((every $taxreasoncode in //cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode satisfies contains(' VATEX-SA-HEA VATEX-SA-EDU ', $taxreasoncode) and exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) != '') or not(every $taxreasoncode in //cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode satisfies contains(' VATEX-SA-HEA VATEX-SA-EDU ', $taxreasoncode)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-25">
                     <xsl:attribute name="test">(every $taxreasoncode in //cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode satisfies contains(' VATEX-SA-HEA VATEX-SA-EDU ', $taxreasoncode) and exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) != '') or not(every $taxreasoncode in //cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode satisfies contains(' VATEX-SA-HEA VATEX-SA-EDU ', $taxreasoncode))</xsl:attribute>
                     <svrl:text>[BR-KSA-25]-If it is a simplified tax invoice or an associated credit note or a debit note (KSA-2, position 1 and 2 = 02) and the tax exemption reason code (BT-121) is equal with VATEX-SA-EDU or VATEX-SA-HEA, then buyer name (BT-44) is mandatory.</svrl:text>
                     <svrl:message-code>BR-KSA-25</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-44">
                     <xsl:attribute name="test">
                        exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-44]-Field character limit for Buyer name field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-44</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(                 (substring(./@name, 3,1) = '1' or substring(./@name, 3,1) = '0') and                  (substring(./@name, 4,1) = '1' or substring(./@name, 4,1) = '0') and                 (substring(./@name, 5,1) = '0') and                 (substring(./@name, 6,1) = '1' or substring(./@name, 6,1) = '0') and                  (substring(./@name, 7,1) = '0'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-31">
                     <xsl:attribute name="test">                 (substring(./@name, 3,1) = '1' or substring(./@name, 3,1) = '0') and                  (substring(./@name, 4,1) = '1' or substring(./@name, 4,1) = '0') and                 (substring(./@name, 5,1) = '0') and                 (substring(./@name, 6,1) = '1' or substring(./@name, 6,1) = '0') and                  (substring(./@name, 7,1) = '0')</xsl:attribute>
                     <svrl:text>
                        [BR-KSA-31]-For simplified tax invoices and associated credit notes and debit notes  (KSA-2, position 1 and 2 = 02),  only the following are accepted:
                        third party (KSA-2, position 3 = 1),
                        nominal supply (KSA-2, position 4 = 1) and
                        summary transactions (KSA-2,, position 6 = 1).</svrl:text>
                     <svrl:message-code>BR-KSA-31</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(//cac:Signature) and (//cac:Signature) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-60">
                     <xsl:attribute name="test">exists(//cac:Signature) and (//cac:Signature) != ''</xsl:attribute>
                     <svrl:text>[BR-KSA-60]-Cryptographic stamp (KSA-15) must exist in simplified tax invoices and associated credit notes and debit notes (KSA-2, position 1 and 2 = 02).</svrl:text>
                     <svrl:message-code>BR-KSA-60</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e276')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1']"
                 priority="23"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e291']">
            <schxslt:rule pattern="d7e291">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e291">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(substring(./@name,7,1) != '1')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-07">
                     <xsl:attribute name="test">substring(./@name,7,1) != '1'</xsl:attribute>
                     <svrl:text>[BR-KSA-07]-Self billing is not allowed (KSA-2, position 7 cannot be "1") for export invoices (KSA-2, position 5 = 1).</svrl:text>
                     <svrl:message-code>BR-KSA-07</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(./@name) and string-length(./@name) &gt; 7">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-0222">
                     <xsl:attribute name="test">exists(./@name) and string-length(./@name) &gt; 7</xsl:attribute>
                     <svrl:text>[BR-KSA-02]-Field character limit for Invoice Transactions Type field has been exceeded. The maximum limit for this field is 7.</svrl:text>
                     <svrl:message-code>BR-KSA-CL-0222</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e291')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]"
                 priority="22"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e301']">
            <schxslt:rule pattern="d7e301">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e301">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="string-length(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &gt; 0 and not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) and matches(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '^[0-9]{15}$') and starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3') and ends-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-44">
                     <xsl:attribute name="test">matches(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '^[0-9]{15}$') and starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3') and ends-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '3')</xsl:attribute>
                     <svrl:text>[BR-KSA-44]-If it exists in the invoice, and If it is not an export invoice (KSA-2, position 5 is false), the buyer VAT registration number (BT-48) must contain 15 digits. The first digit and the last digit is "3".</svrl:text>
                     <svrl:message-code>BR-KSA-44</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e301')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]"
                 priority="21"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e310']">
            <schxslt:rule pattern="d7e310">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e310">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '1'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme)) and not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-46">
                     <xsl:attribute name="test">not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme)) and not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID))</xsl:attribute>
                     <svrl:text>[BR-KSA-46]-If it is an export invoice (KSA-2, position 5 is true), the buyer VAT registration number (BT-48) and the buyer group VAT registration number (KSA-20) must not exist in the invoice.</svrl:text>
                     <svrl:message-code>BR-KSA-46</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e310')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']]"
                 priority="20"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e319']">
            <schxslt:rule pattern="d7e319">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e319">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 5, 1) = '0'][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID][//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'HQ']]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &gt; 0 and matches(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '^[0-9]{15}$') and substring(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, 1, 1) = '3' and substring(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, 15, 1) = '3' and substring(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, 11,1) = '1')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-45">
                     <xsl:attribute name="test">matches(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, '^[0-9]{15}$') and substring(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, 1, 1) = '3' and substring(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, 15, 1) = '3' and substring(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID, 11,1) = '1'</xsl:attribute>
                     <svrl:text>[BR-KSA-45]-If it exists in the invoice, and If it is not an export invoice (KSA-2, position 5 is false) ,the seller group VAT registration number (KSA-20) must contain 15 digits. The first digit and the last digit is "3". The eleventh digit must be "1".</svrl:text>
                     <svrl:message-code>BR-KSA-45</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e319')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"
                 priority="19"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e328']">
            <schxslt:rule pattern="d7e328">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e328">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(//cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID) and string-length(//cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="KSA-CL-210">
                     <xsl:attribute name="test">exists(//cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID) and string-length(//cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID) &gt; 3</xsl:attribute>
                     <svrl:text>[KSA-21]-Field character limit for Tax scheme ID field has been exceeded The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>KSA-CL-210</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length(.) &gt; 0 and not(xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100 and string-length(substring-after(.,'.')) &lt;=6)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-DEC-01">
                     <xsl:attribute name="test">xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100 and string-length(substring-after(.,'.')) &lt;=6</xsl:attribute>
                     <svrl:text>[BR-KSA-DEC-01]-The allowance percentage values (BT-94, BT-138) must be from 0.00 to 100.00, with maximum six decimals. Only numerals are accepted, the percentage symbol (%) is not allowed.</svrl:text>
                     <svrl:message-code>BR-KSA-DEC-01</svrl:message-code>
                     <svrl:message-category> KSA – decimals rules (BR-KSA-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) &gt;=6">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-138">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) &gt;=6</xsl:attribute>
                     <svrl:text>[BT-138] -Field character limit for Invoice line allowance percentage field has been exceeded. The maximum limit for this field is 14.BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 6.</svrl:text>
                     <svrl:message-code>BT-CL-138</svrl:message-code>
                     <svrl:message-category> KSA – decimals rules (BR-KSA-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e328')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge/cac:TaxCategory/cbc:Percent | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent | cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"
                 priority="18"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e328']">
            <schxslt:rule pattern="d7e328">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge/cac:TaxCategory/cbc:Percent | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent | cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cac:TaxCategory/cbc:Percent | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent | cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e328">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cac:TaxCategory/cbc:Percent | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent | cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100 and string-length(substring-after(.,'.')) &lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-DEC-02">
                     <xsl:attribute name="test">xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100 and string-length(substring-after(.,'.')) &lt;=2</xsl:attribute>
                     <svrl:text>[BR-KSA-DEC-02]-The VAT rates (BT-96119, BT-152) must be from 0.00 to 100.00, with maximum two decimals. Only numerals are accepted, the percentage symbol (%) is not allowed.</svrl:text>
                     <svrl:message-code>BR-KSA-DEC-02</svrl:message-code>
                     <svrl:message-category> KSA – decimals rules (BR-KSA-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e328')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine" priority="17" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e328']">
            <schxslt:rule pattern="d7e328">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e328">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(string-length(substring-after(cac:TaxTotal/cbc:TaxAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-DEC-03">
                     <xsl:attribute name="test">string-length(substring-after(cac:TaxTotal/cbc:TaxAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-KSA-DEC-03]-VAT amount at line level (KSA-11) must have a maximum two decimals.</svrl:text>
                     <svrl:message-code>BR-KSA-DEC-03</svrl:message-code>
                     <svrl:message-category> KSA – decimals rules (BR-KSA-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cac:TaxTotal/cbc:RoundingAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-DEC-04">
                     <xsl:attribute name="test">string-length(substring-after(cac:TaxTotal/cbc:RoundingAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-KSA-DEC-04]-Amount with VAT at line level (KSA-12) must have a maximum two decimals.</svrl:text>
                     <svrl:message-code>BR-KSA-DEC-04</svrl:message-code>
                     <svrl:message-category> KSA – decimals rules (BR-KSA-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cac:Price/cbc:PriceAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-DEC-05">
                     <xsl:attribute name="test">string-length(substring-after(cac:Price/cbc:PriceAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-KSA-DEC-05]-Item net price (BT-146) must have a maximum two decimals.</svrl:text>
                     <svrl:message-code>BR-KSA-DEC-05</svrl:message-code>
                     <svrl:message-category> KSA – decimals rules (BR-KSA-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e328')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:DocumentCurrencyCode" priority="16" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e355']">
            <schxslt:rule pattern="d7e355">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:DocumentCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cbc:DocumentCurrencyCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e355">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cbc:DocumentCurrencyCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-01">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-KSA-CL-01]-Currency code (BT-5) must be according to ISO 4217:2005.</svrl:text>
                     <svrl:message-code>BR-KSA-CL-01</svrl:message-code>
                     <svrl:message-category>KSA – code list (BR-KSA-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e355')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount"
                 priority="15"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e355']">
            <schxslt:rule pattern="d7e355">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e355">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test=" exists(//cbc:DocumentCurrencyCode/@currencyID) and  not(matches(normalize-space(//cbc:DocumentCurrencyCode), @currencyID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-02">
                     <xsl:attribute name="test">matches(normalize-space(//cbc:DocumentCurrencyCode), @currencyID)</xsl:attribute>
                     <svrl:text>[BR-KSA-CL-02]-All currencyID attributes (BT-5) must have the same value as the invoice currency code (BT-5), except for the invoice total VAT amount in accounting currency (BT-111).</svrl:text>
                     <svrl:message-code>BR-KSA-CL-02</svrl:message-code>
                     <svrl:message-category>KSA – code list (BR-KSA-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e355')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject"
                 priority="14"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e355']">
            <schxslt:rule pattern="d7e355">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e355">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@mimeCode), ' ')) and contains(' text/csv text/plain application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet ', concat(' ', normalize-space(@mimeCode), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-03">
                     <xsl:attribute name="test">((not(contains(normalize-space(@mimeCode), ' ')) and contains(' text/csv text/plain application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet ', concat(' ', normalize-space(@mimeCode), ' '))))</xsl:attribute>
                     <svrl:text>[BR-KSA-CL-03]-Mime code must be according to subset of IANA code list.</svrl:text>
                     <svrl:message-code>BR-KSA-CL-03</svrl:message-code>
                     <svrl:message-category>KSA – code list (BR-KSA-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e355')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E']"
                 priority="13"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e355']">
            <schxslt:rule pattern="d7e355">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e355">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="error">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'] | cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:TaxExemptionReasonCode) and ((not(contains(normalize-space(cbc:TaxExemptionReasonCode), ' ')) and contains(' VATEX-SA-29 VATEX-SA-29-7 VATEX-SA-30 VATEX-SA-32 VATEX-SA-33 VATEX-SA-34-1 VATEX-SA-34-2 VATEX-SA-34-3 VATEX-SA-34-4 VATEX-SA-34-5 VATEX-SA-35 VATEX-SA-36 VATEX-SA-EDU VATEX-SA-HEA ', concat(' ', normalize-space(cbc:TaxExemptionReasonCode), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-04">
                     <xsl:attribute name="test">exists(cbc:TaxExemptionReasonCode) and ((not(contains(normalize-space(cbc:TaxExemptionReasonCode), ' ')) and contains(' VATEX-SA-29 VATEX-SA-29-7 VATEX-SA-30 VATEX-SA-32 VATEX-SA-33 VATEX-SA-34-1 VATEX-SA-34-2 VATEX-SA-34-3 VATEX-SA-34-4 VATEX-SA-34-5 VATEX-SA-35 VATEX-SA-36 VATEX-SA-EDU VATEX-SA-HEA ', concat(' ', normalize-space(cbc:TaxExemptionReasonCode), ' '))))</xsl:attribute>
                     <svrl:text>[BR-KSA-CL-04]-VAT exemption reason code (BT-121) must exists in the invoice, the codes Z, E must have Tax exemption (or exceptions) reason code and text - specific to Saudi Arabia</svrl:text>
                     <svrl:message-code>BR-KSA-CL-04</svrl:message-code>
                     <svrl:message-category>KSA – code list (BR-KSA-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxExemptionReason) and  (cbc:TaxExemptionReason) != '' and matches(normalize-space(cbc:TaxExemptionReason),'Financial services mentioned in Article 29 of the VAT Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Life insurance services mentioned in Article 29 of the VAT Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Real estate transactions mentioned in Article 30 of the VAT Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Export of goods')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Export of services')                 or matches(normalize-space(cbc:TaxExemptionReason), 'The international transport of goods')                 or matches(normalize-space(cbc:TaxExemptionReason), 'International transport of passengers')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Services directly connected and incidental to a Supply of international passenger transport')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Supply of a qualifying means of transport')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Any services relating to Goods or passenger transportation, as defined in article twenty five of these Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Medicines and medical equipment')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Qualifying metals')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Private education to citizen')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Private healthcare to citizen'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-CL-05">
                     <xsl:attribute name="test">exists(cbc:TaxExemptionReason) and  (cbc:TaxExemptionReason) != '' and matches(normalize-space(cbc:TaxExemptionReason),'Financial services mentioned in Article 29 of the VAT Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Life insurance services mentioned in Article 29 of the VAT Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Real estate transactions mentioned in Article 30 of the VAT Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Export of goods')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Export of services')                 or matches(normalize-space(cbc:TaxExemptionReason), 'The international transport of goods')                 or matches(normalize-space(cbc:TaxExemptionReason), 'International transport of passengers')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Services directly connected and incidental to a Supply of international passenger transport')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Supply of a qualifying means of transport')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Any services relating to Goods or passenger transportation, as defined in article twenty five of these Regulations')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Medicines and medical equipment')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Qualifying metals')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Private education to citizen')                 or matches(normalize-space(cbc:TaxExemptionReason), 'Private healthcare to citizen')</xsl:attribute>
                     <svrl:text>[BR-KSA-CL-05]-If VAT exemption reason code (BT-121) is the codes "Z" or "E", then VAT exemption reason text (BT-120) must exist with one of the values from Tax exemption (or exception) reason code and text - specific to Saudi Arabia.</svrl:text>
                     <svrl:message-code>BR-KSA-CL-05</svrl:message-code>
                     <svrl:message-category>KSA – code list (BR-KSA-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e355')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:* | cbc:*" priority="12" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e385']">
            <schxslt:rule pattern="d7e385">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:* | cbc:*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:* | cbc:*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>

            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e385')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:IssueDate | cbc:DueDate | cac:Delivery/cbc:ActualDeliveryDate | cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate"
                 priority="11"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e395']">
            <schxslt:rule pattern="d7e395">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:IssueDate | cbc:DueDate | cac:Delivery/cbc:ActualDeliveryDate | cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate | cbc:DueDate | cac:Delivery/cbc:ActualDeliveryDate | cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e395">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate | cbc:DueDate | cac:Delivery/cbc:ActualDeliveryDate | cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '02\d{5}')])" >

                  <xsl:if test="not((string-length(.) = 10 and (string(.) castable as xs:date)))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-KSA-F-01">
                        <xsl:attribute name="test">(string-length(.) = 10 and (string(.) castable as xs:date))</xsl:attribute>
                        <svrl:text>[BR-KSA-F-01]-A date MUST be formatted YYYY-MM-DD.</svrl:text>
                        <svrl:message-code>BR-KSA-F-01</svrl:message-code>
                        <svrl:message-category>KSA – formats (BR-KSA-F)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e395')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge/cbc:ChargeIndicator | cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator"
                 priority="10"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e395']">
            <schxslt:rule pattern="d7e395">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge/cbc:ChargeIndicator | cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:ChargeIndicator | cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e395">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:ChargeIndicator | cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((.) = false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-F-02">
                     <xsl:attribute name="test">(.) = false()</xsl:attribute>
                     <svrl:text>[BR-KSA-F-02]-Allowance Indicator value MUST equal to 'false'.</svrl:text>
                     <svrl:message-code>BR-KSA-F-02</svrl:message-code>
                     <svrl:message-category>KSA – formats (BR-KSA-F)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e395')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge/cbc:BaseAmount | cac:TaxTotal/cbc:TaxAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount | cac:LegalMonetaryTotal/cbc:LineExtensionAmount             | cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount | cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount | cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount             | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount             | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:InvoiceLine/cbc:LineExtensionAmount | cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount             | cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount | cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount | cac:InvoiceLine/cac:Price/cbc:PriceAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount             | cac:InvoiceLine/cbc:InvoicedQuantity"
                 priority="9"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e395']">
            <schxslt:rule pattern="d7e395">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge/cbc:BaseAmount | cac:TaxTotal/cbc:TaxAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount | cac:LegalMonetaryTotal/cbc:LineExtensionAmount | cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount | cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount | cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:InvoiceLine/cbc:LineExtensionAmount | cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount | cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount | cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount | cac:InvoiceLine/cac:Price/cbc:PriceAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount | cac:InvoiceLine/cbc:InvoicedQuantity" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:BaseAmount | cac:TaxTotal/cbc:TaxAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount | cac:LegalMonetaryTotal/cbc:LineExtensionAmount             | cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount | cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount | cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount             | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount             | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:InvoiceLine/cbc:LineExtensionAmount | cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount             | cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount | cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount | cac:InvoiceLine/cac:Price/cbc:PriceAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount             | cac:InvoiceLine/cbc:InvoicedQuantity</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e395">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:BaseAmount | cac:TaxTotal/cbc:TaxAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount | cac:LegalMonetaryTotal/cbc:LineExtensionAmount             | cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount | cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount | cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount             | cac:LegalMonetaryTotal/cbc:ChargeTotalAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:LegalMonetaryTotal/cbc:PrepaidAmount             | cac:LegalMonetaryTotal/cbc:PayableRoundingAmount | cac:LegalMonetaryTotal/cbc:PayableAmount | cac:InvoiceLine/cbc:LineExtensionAmount | cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount             | cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount | cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount | cac:InvoiceLine/cac:Price/cbc:PriceAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount             | cac:InvoiceLine/cbc:InvoicedQuantity</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="string-length(.) &gt; 0 and not(number(.) &gt;= 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-F-04">
                     <xsl:attribute name="test">number(.) &gt;= 0</xsl:attribute>
                     <svrl:text>[BR-KSA-F-04]-All the document amounts and quantities must be positive.</svrl:text>
                     <svrl:message-code>BR-KSA-F-04</svrl:message-code>
                     <svrl:message-category>KSA – formats (BR-KSA-F)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e395')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice" priority="8" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/ubl:Invoice" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(./cbc:ProfileID) and (normalize-space(./cbc:ProfileID)) = 'reporting:1.0')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-01">
                     <xsl:attribute name="test">exists(./cbc:ProfileID) and (normalize-space(./cbc:ProfileID)) = 'reporting:1.0'</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-01]-Business process (BT-23) must be "reporting:1.0".</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-01</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(count(./cac:TaxTotal) &gt;= 1 and count(./cac:TaxTotal/cac:TaxSubtotal) &gt;= 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-08">
                     <xsl:attribute name="test">count(./cac:TaxTotal) &gt;= 1 and count(./cac:TaxTotal/cac:TaxSubtotal) &gt;= 1</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-08]-Only one tax total (BG-22) with tax subtotals must be provided.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-08</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-KSA-CL-136">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-136]-Field character limit for Invoice line allowance amount (discount or rebate amount) field has been exceeded. The maximum limit for this field is 14.BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-KSA-CL-136</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:TaxCurrencyCode" priority="7" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:TaxCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((normalize-space(upper-case(.))) = 'SAR')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-02">
                     <xsl:attribute name="test">(normalize-space(upper-case(.))) = 'SAR'</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-02]-VAT accounting currency code (BT-6) must be SAR.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-02</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(count(../cac:TaxTotal) &gt;= 2 and count(../cac:TaxTotal) &lt;= 2 and count(../cac:TaxTotal/cac:TaxSubtotal) &gt;= 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-09">
                     <xsl:attribute name="test">count(../cac:TaxTotal) &gt;= 2 and count(../cac:TaxTotal) &lt;= 2 and count(../cac:TaxTotal/cac:TaxSubtotal) &gt;= 1</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-09]-Only one tax total (BG-22) without tax subtotals must be provided when tax currency code is provided.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-09</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:AllowanceCharge[cbc:Amount]] | /ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:Amount]]"
                 priority="6"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/ubl:Invoice/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:AllowanceCharge[cbc:Amount]] | /ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:Amount]]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:AllowanceCharge[cbc:Amount]] | /ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:Amount]]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:AllowanceCharge[cbc:Amount]] | /ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:BaseAmount][/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:Amount]]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="string-length(./cbc:Amount) &gt; 0 and string-length(./cbc:BaseAmount) &gt; 0 and not(xs:decimal(./cbc:Amount) = (xs:decimal(./cbc:BaseAmount) * xs:decimal(./cbc:MultiplierFactorNumeric) div 100))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-03">
                     <xsl:attribute name="test">xs:decimal(./cbc:Amount) = (xs:decimal(./cbc:BaseAmount) * xs:decimal(./cbc:MultiplierFactorNumeric) div 100)</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-03]-Allowance amount (BT-92, BT-136) must equal base amount (BT-93, BT-137) * percentage (BT-94, BT-138) / 100 if base amount and percentage exists.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-03</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge/cbc:BaseAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount"
                 priority="5"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge/cbc:BaseAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:BaseAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:BaseAmount | cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(../cbc:MultiplierFactorNumeric))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-05">
                     <xsl:attribute name="test">exists(../cbc:MultiplierFactorNumeric)</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-04]-Allowance base amount (BT-93, BT-137) must be provided when allowance percentage (BT-94, BT-138) is provided.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-04</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"
                 priority="4"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge/cbc:MultiplierFactorNumeric | cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(../cbc:BaseAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-04">
                     <xsl:attribute name="test">exists(../cbc:BaseAmount)</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-05]-Allowance percentage (BT-94, BT-138) must be provided when the allowance base amount (BT-93, BT-137) is provided.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-05</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Price/cac:AllowanceCharge"
                 priority="3"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Price/cac:AllowanceCharge" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Price/cac:AllowanceCharge</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Price/cac:AllowanceCharge</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:ChargeIndicator) = false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-06">
                     <xsl:attribute name="test">(cbc:ChargeIndicator) = false()</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-06]-Charge on price level (BG-29) is NOT allowed. Only value 'false' allowed.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-06</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount) and string-length(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-148">
                     <xsl:attribute name="test">string-length(../cbc:Amount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-148]-Field character limit for Item gross price field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-148</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount) and string-length(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-147">
                     <xsl:attribute name="test">sexists(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount) and string-length(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-147]-Field character limit for Item price discount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-147</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine" priority="2" mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="number((.)) &gt; 0 and not(((exists(cac:Price/cbc:BaseQuantity) and xs:decimal(cbc:LineExtensionAmount) = xs:decimal(cbc:InvoicedQuantity) * ((xs:decimal(cac:Price/cbc:PriceAmount) div                 xs:decimal(cac:Price/cbc:BaseQuantity)) - xs:decimal(sum(cac:Price/cac:AllowanceCharge/cbc:Amount))))) or ((not(exists(cac:Price/cbc:BaseQuantity)) and xs:decimal(cbc:LineExtensionAmount) = xs:decimal(cbc:InvoicedQuantity) * xs:decimal(cac:Price/cbc:PriceAmount) - xs:decimal(sum(cac:Price/cac:AllowanceCharge/cbc:Amount)))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-11">
                     <xsl:attribute name="test">((exists(cac:Price/cbc:BaseQuantity) and xs:decimal(cbc:LineExtensionAmount) = xs:decimal(cbc:InvoicedQuantity) * ((xs:decimal(cac:Price/cbc:PriceAmount) div                 xs:decimal(cac:Price/cbc:BaseQuantity)) - xs:decimal(sum(cac:Price/cac:AllowanceCharge/cbc:Amount))))) or ((not(exists(cac:Price/cbc:BaseQuantity)) and xs:decimal(cbc:LineExtensionAmount) = xs:decimal(cbc:InvoicedQuantity) * xs:decimal(cac:Price/cbc:PriceAmount) - xs:decimal(sum(cac:Price/cac:AllowanceCharge/cbc:Amount))))</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-11]-nvoice line net amount (BT-131) must equal (Invoiced quantity (BT-129) * (Item net price (BT-146) / item price base quantity (BT-149))-))- Sum of invoice line allowance amount (BT-136)</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-11</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:InvoiceLine/cac:Price/cbc:BaseQuantity) and string-length(cac:InvoiceLine/cac:Price/cbc:BaseQuantity) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-149">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Price/cbc:BaseQuantity) and string-length(cac:InvoiceLine/cac:Price/cbc:BaseQuantity) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-149]-Field character limit for Item price base quantity field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-149</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:InvoiceLine/cac:Price/cbc:BaseQuantity/@unitCode) and string-length(cac:InvoiceLine/cac:Price/cbc:BaseQuantity/@unitCode) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-150">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Price/cbc:BaseQuantity/@unitCode) and string-length(cac:InvoiceLine/cac:Price/cbc:BaseQuantity/@unitCode) &gt; 127</xsl:attribute>
                     <svrl:text>[BT-150]-Field character limit for Item price base quantity unit code field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BT-CL-150</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:Price/cbc:PriceAmount) and string-length(cac:Price/cbc:PriceAmount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-146">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Price/cbc:PriceAmount) and string-length(cac:InvoiceLine/cac:Price/cbc:PriceAmount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-146]-Field character limit for Item net price field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-146</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Price/cbc:BaseQuantity"
                 priority="1"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e416']">
            <schxslt:rule pattern="d7e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Price/cbc:BaseQuantity" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Price/cbc:BaseQuantity</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Price/cbc:BaseQuantity</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="string-length(.) &gt; 0 and not(number((.)) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-12">
                     <xsl:attribute name="test">number((.)) &gt; 0</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-12]-Base quantity (BT-149) must be a positive number above zero.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-12</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount"
                 priority="0"
                 mode="d7e29">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e474']">
            <schxslt:rule pattern="d7e474">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e474">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(xs:decimal(../../cbc:PriceAmount) = xs:decimal(.) - xs:decimal(../cbc:Amount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-KSA-EN16931-07">
                     <xsl:attribute name="test">xs:decimal(../../cbc:PriceAmount) = xs:decimal(.) - xs:decimal(../cbc:Amount)</xsl:attribute>
                     <svrl:text>[BR-KSA-EN16931-07]-Item net price (BT-146) must equal (Gross price (BT-148) - Allowance amount (BT-147)) when gross price is provided.</svrl:text>
                     <svrl:message-code>BR-KSA-EN16931-07</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e474')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:function name="schxslt:location" as="xs:string">
      <xsl:param name="node" as="node()"/>
      <xsl:variable name="segments" as="xs:string*">
         <xsl:for-each select="($node/ancestor-or-self::node())">
            <xsl:variable name="position">
               <xsl:number level="single"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test=". instance of element()">
                  <xsl:value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of attribute()">
                  <xsl:value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))"/>
               </xsl:when>
               <xsl:when test=". instance of processing-instruction()">
                  <xsl:value-of select="concat('processing-instruction(&#34;', name(.), '&#34;)[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of comment()">
                  <xsl:value-of select="concat('comment()[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of text()">
                  <xsl:value-of select="concat('text()[', $position, ']')"/>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="concat('/', string-join($segments, '/'))"/>
   </xsl:function>
</xsl:transform>