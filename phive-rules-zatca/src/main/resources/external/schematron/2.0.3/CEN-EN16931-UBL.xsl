<?xml version="1.0" encoding="UTF-8"?>
<!--

   This file is based on the CEN/EN 16931:2017 standard and licensed under the LGPL v3 in compliance with the terms granted in the EUPL v1.2 under which the original standard has been published.

The copyright of CEN/EN 16931:2017 is owned by CEN and its members - the European National Standards Bodies. A copy of CEN/EN 16931-1:2017 may be obtained from any CEN member.

-->
<xsl:transform xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
               xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
               xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
               xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
               xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
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
      <dct:created>2021-08-31T19:20:00.249319615+02:00</dct:created>
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
                  <dct:created>2021-08-31T19:20:00.249319615+02:00</dct:created>
               </rdf:Description>
            </dct:source>
         </svrl:metadata>
      </xsl:variable>
      <xsl:variable name="report" as="element(schxslt:report)">
         <schxslt:report>
            <xsl:call-template name="d7e42"/>
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
         <svrl:ns-prefix-in-attribute-values prefix="qdt"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="udt"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cn"
                                             uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
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
   <xsl:template name="d7e42">
      <schxslt:pattern id="d7e42">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="UBL-model">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e353">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 id="CustomRules_documentCurrency">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e362">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_taxCurrency">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <schxslt:pattern id="d7e371">
         <xsl:if test="exists(base-uri(/))">
            <xsl:attribute name="documents" select="base-uri(/)"/>
         </xsl:if>
         <xsl:for-each select="/">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="Codesmodel">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </xsl:for-each>
      </schxslt:pattern>
      <xsl:apply-templates mode="d7e42" select="/"/>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference" priority="32" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:AdditionalDocumentReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:ID) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-52">
                     <xsl:attribute name="test">(cbc:ID) != ''</xsl:attribute>
                     <svrl:text>[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</svrl:text>
                     <svrl:message-code>BR-52</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]"
                 priority="31"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:Amount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-31">
                     <xsl:attribute name="test">exists(cbc:Amount)</xsl:attribute>
                     <svrl:text>[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</svrl:text>
                     <svrl:message-code>BR-31</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-32">
                     <xsl:attribute name="test">exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) !=''</xsl:attribute>
                     <svrl:text>[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</svrl:text>
                     <svrl:message-code>BR-32</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:Amount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-01">
                     <xsl:attribute name="test">string-length(substring-after(cbc:Amount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-01</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-02">
                     <xsl:attribute name="test">string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-02</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:LegalMonetaryTotal" priority="30" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:LegalMonetaryTotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:LegalMonetaryTotal</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:LegalMonetaryTotal</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:TaxExclusiveAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-13">
                     <xsl:attribute name="test">exists(cbc:TaxExclusiveAmount)</xsl:attribute>
                     <svrl:text>[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</svrl:text>
                     <svrl:message-code>BR-13</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxInclusiveAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-14">
                     <xsl:attribute name="test">exists(cbc:TaxInclusiveAmount)</xsl:attribute>
                     <svrl:text>[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</svrl:text>
                     <svrl:message-code>BR-14</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:PayableAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-15">
                     <xsl:attribute name="test">exists(cbc:PayableAmount)</xsl:attribute>
                     <svrl:text>[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</svrl:text>
                     <svrl:message-code>BR-15</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-10">
                     <xsl:attribute name="test">(xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))</xsl:attribute>
                     <svrl:text>[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</svrl:text>
                     <svrl:message-code>BR-CO-10</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-11">
                     <xsl:attribute name="test">xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))</xsl:attribute>
                     <svrl:text>[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</svrl:text>
                     <svrl:message-code>BR-CO-11</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-13">
                     <xsl:attribute name="test">((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))</xsl:attribute>
                     <svrl:text>[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</svrl:text>
                     <svrl:message-code>BR-CO-13</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length(cbc:PrepaidAmount) &gt; 0 and not((exists(cbc:PrepaidAmount) and not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or  (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-16">
                     <xsl:attribute name="test">(exists(cbc:PrepaidAmount) and not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or  (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount)))</xsl:attribute>
                     <svrl:text>[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</svrl:text>
                     <svrl:message-code>BR-CO-16</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length(substring-after(cbc:LineExtensionAmount,'.')) &gt; 2">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-09">
                     <xsl:attribute name="test">string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-09</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-10">
                     <xsl:attribute name="test">string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-10</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-12">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-12</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-14">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-14</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-16">
                     <xsl:attribute name="test">string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-16</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-18">
                     <xsl:attribute name="test">string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.  </svrl:text>
                     <svrl:message-code>BR-DEC-18</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']"
                 priority="29"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
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
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >

                  <xsl:if test="not(exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-10">
                        <xsl:attribute name="test">exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)</xsl:attribute>
                        <svrl:text>[BR-10]-An Invoice shall contain the Buyer postal address (BG-8). Not applicable for simplified tax invoices and associated credit notes and debit notes (KSA-2, position 1 and 2 = 02).
                        </svrl:text>
                        <svrl:message-code>BR-10</svrl:message-code>
                        <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>

               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice | /cn:CreditNote" priority="28" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/ubl:Invoice | /cn:CreditNote" shadowed by preceding rule</xsl:comment>
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
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:ID) and (cbc:ID) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-02">
                     <xsl:attribute name="test">exists(cbc:ID) and (cbc:ID) !=''</xsl:attribute>
                     <svrl:text>[BR-02]-An Invoice shall have an Invoice number (BT-1).</svrl:text>
                     <svrl:message-code>BR-02</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists((//cac:InvoiceLine//cac:Item/cac:ClassifiedTaxCategory/cbc:ID/text()[string-length() > 1])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-151">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID) and string-length(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID) &gt; 1</xsl:attribute>
                     <svrl:text>[BT-151]-Field character limit for Invoiced item VAT category code field has been exceeded. The maximum limit for this field is 1.</svrl:text>
                     <svrl:message-code>BT-CL-151</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:DocumentCurrencyCode) and string-length(cbc:DocumentCurrencyCode) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-500">
                     <xsl:attribute name="test">exists(cbc:DocumentCurrencyCode) and string-length(cbc:DocumentCurrencyCode) &gt; 3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency Code field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>BR-CL-500</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists((//cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-98">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount/@currencyID) and string-length(cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for VAT line amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-98</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount/@curencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-100">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount/@curencyID) and string-length(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount/@curencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for line amount inclusive VAT field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-100</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:InvoiceLine/cac:Price/cbc:PriceAmount/@schemeID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-106">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Price/cbc:PriceAmount/@schemeID) and string-length(cac:InvoiceLine/cac:Price/cbc:PriceAmount/@schemeID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for item net price field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-106</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="exists((//cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-114">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount/@currencyID) and string-length(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for item price discount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-114</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-116">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount/@currencyID) and string-length(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for item gross prices field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-116</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount/@currencyID) and string-length(cac:LegalMonetaryTotal/cbc:PrepaidAmount/@currencyID)&gt;3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-74">
                     <xsl:attribute name="test">exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount/@currencyID) and string-length(cac:LegalMonetaryTotal/cbc:PrepaidAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for paid amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-74</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-78">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/@currencyID) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for VAT category taxable amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-78</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID) and string-length(cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID)&gt;3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-76">
                     <xsl:attribute name="test">exists(cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID) and string-length(cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for amount due for payment field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-76</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-80">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/@currencyID) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for category tax amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-80</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:InvoiceLine/cbc:LineExtensionAmount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-90">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:LineExtensionAmount/@currencyID) and string-length(cac:InvoiceLine/cbc:LineExtensionAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for invoice line net amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-90</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-94">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount/@currencyID) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for line allowance amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-94</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists((//cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount/@currencyID/text()[string-length() > 3])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05-96">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount/@currencyID) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency for invoice line allowance base amount field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05-96</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:InvoiceTypeCode) and string-length(cbc:InvoiceTypeCode) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-400">
                     <xsl:attribute name="test">exists(cbc:InvoiceTypeCode) and string-length(cbc:InvoiceTypeCode) &gt; 3</xsl:attribute>
                     <svrl:text>[BR-04]-Field character limit for Invoice Type Code field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>BR-CL-400</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID) and string-length(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID)&gt;3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-05">
                     <xsl:attribute name="test">exists(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID) and string-length(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID)&gt;3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for invoice total amount with VAT field has been exceeded. The maximum limit for this field is 3. </svrl:text>
                     <svrl:message-code>BT-CL-05</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:IssueDate) and string-length(cbc:IssueDate) &gt; 10">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-300">
                     <xsl:attribute name="test">exists(cbc:IssueDate) and string-length(cbc:IssueDate) &gt; 10</xsl:attribute>
                     <svrl:text>[BR-03]-Field character limit for Issue Date field has been exceeded. The maximum limit for this field is 10.</svrl:text>
                     <svrl:message-code>BR-CL-300</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cbc:ID) and string-length(cbc:ID) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-02">
                     <xsl:attribute name="test">exists(cbc:ID) and string-length(cbc:ID) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-02]-Field character limit for Invoice identifier field has been exceeded. The maximum limit for this field is 127 (BT-1).</svrl:text>
                     <svrl:message-code>BR-CL-02</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists((//cbc:Note/text()[string-length() > 1000])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-22">
                     <xsl:attribute name="test">exists(cbc:Note) and string-length(cbc:Note) &gt; 1000</xsl:attribute>
                     <svrl:text>[BT-22]-Field character limit for Invoice Note field has been exceeded. The maximum limit for this field is 1000.</svrl:text>
                     <svrl:message-code>BR-CL-22</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:IssueDate) and (cbc:IssueDate) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-03">
                     <xsl:attribute name="test">exists(cbc:IssueDate) and (cbc:IssueDate) !=''</xsl:attribute>
                     <svrl:text>[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</svrl:text>
                     <svrl:message-code>BR-03</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:IssueDate) and string-length(cbc:IssueDate) &gt; 10">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-03">
                     <xsl:attribute name="test">exists(cbc:IssueDate) and string-length(cbc:IssueDate) &gt; 10</xsl:attribute>
                     <svrl:text>[BR-03]-Field character limit for Issue Date field has been exceeded. The maximum limit for this field is 10.</svrl:text>
                     <svrl:message-code>BR-CL-03</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:InvoiceTypeCode) and string-length(cbc:InvoiceTypeCode) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-04">
                     <xsl:attribute name="test">exists(cbc:InvoiceTypeCode) and string-length(cbc:InvoiceTypeCode) &gt; 3</xsl:attribute>
                     <svrl:text>[BR-04]-Field character limit for Invoice Type Code field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>BR-CL-04</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cbc:DocumentCurrencyCode) and string-length(cbc:DocumentCurrencyCode) &gt; 3">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-05">
                     <xsl:attribute name="test">exists(cbc:DocumentCurrencyCode) and string-length(cbc:DocumentCurrencyCode) &gt; 3</xsl:attribute>
                     <svrl:text>[BT-05]-Field character limit for Currency Code field has been exceeded. The maximum limit for this field is 3.</svrl:text>
                     <svrl:message-code>BR-CL-05</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="not((exists(cbc:InvoiceTypeCode) and (cbc:InvoiceTypeCode) !='') or (exists(cbc:CreditNoteTypeCode) and (cbc:CreditNoteTypeCode) !=''))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-04">
                     <xsl:attribute name="test">(exists(cbc:InvoiceTypeCode) and (cbc:InvoiceTypeCode) !='') or (exists(cbc:CreditNoteTypeCode) and (cbc:CreditNoteTypeCode) !='')</xsl:attribute>
                     <svrl:text>[BR-04]-An Invoice shall have an Invoice type code (BT-3).</svrl:text>
                     <svrl:message-code>BR-04</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:DocumentCurrencyCode) and (cbc:DocumentCurrencyCode) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-05">
                     <xsl:attribute name="test">exists(cbc:DocumentCurrencyCode) and (cbc:DocumentCurrencyCode) !=''</xsl:attribute>
                     <svrl:text>[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</svrl:text>
                     <svrl:message-code>BR-05</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-06">
                     <xsl:attribute name="test">exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''</xsl:attribute>
                     <svrl:text>[BR-06]-An Invoice shall contain the Seller name (BT-27).</svrl:text>
                     <svrl:message-code>BR-06</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-27">
                     <xsl:attribute name="test">
                        exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-27]-Field character limit for Seller name field has been exceeded. The maximum
                        limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-27</svrl:message-code>
                     <svrl:message-category>Business rules - length constraints(BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)&gt;127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-39">
                     <xsl:attribute name="test">
                        not(exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-39]-Field character limit for city name field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-39</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) and count(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) &gt;0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-08">
                     <xsl:attribute name="test">exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) and count(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) &gt;0</xsl:attribute>
                     <svrl:text>[BR-08]-An Invoice shall contain the Seller postal address (BG-5) </svrl:text>
                     <svrl:message-code>BR-08</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and string-length(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)&gt;127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-54">
                     <xsl:attribute name="test">
                        exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and string-length(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BT-54]-Field character limit for city name field has been exceeded. The maximum limit for this field is 127.
                     </svrl:text>
                     <svrl:message-code>BT-CL-54</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:InvoiceLine) or exists(cac:CreditNoteLine))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-16">
                     <xsl:attribute name="test">exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)</xsl:attribute>
                     <svrl:text>[BR-16]-An Invoice shall have at least one Invoice line (BG-25)</svrl:text>
                     <svrl:message-code>BR-16</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency]))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-53">
                     <xsl:attribute name="test">every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])</xsl:attribute>
                     <svrl:text>[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</svrl:text>
                     <svrl:message-code>BR-53</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $Currency in cbc:DocumentCurrencyCode satisfies (count(cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) &gt;= 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + sum(cac:TaxTotal/cac:TaxSubtotal/xs:decimal(cbc:TaxAmount))) * 10 * 10) div 100))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-15">
                     <xsl:attribute name="test">every $Currency in cbc:DocumentCurrencyCode satisfies (count(cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) &gt;= 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + sum(cac:TaxTotal/cac:TaxSubtotal/xs:decimal(cbc:TaxAmount))) * 10 * 10) div 100)</xsl:attribute>
                     <svrl:text>[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</svrl:text>
                     <svrl:message-code>BR-CO-15</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxTotal/cac:TaxSubtotal))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-18">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal)</xsl:attribute>
                     <svrl:text>[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</svrl:text>
                     <svrl:message-code>BR-CO-18</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-E-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))</xsl:attribute>
                     <svrl:text>[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) where the  VAT category code (BT-151 or BT-95) is "Exempt from VAT" shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</svrl:text>
                     <svrl:message-code>BR-E-01</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))</xsl:attribute>
                     <svrl:text>[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) where the VAT category code (BT-151 or BT-95) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</svrl:text>
                     <svrl:message-code>BR-O-01</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-02">
                     <xsl:attribute name="test">(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])</xsl:attribute>
                     <svrl:text>[BR-O-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Not subject to VAT"" shall not contain the Seller VAT registration number (BT-31), or the Buyer VAT registration number (BT-48).</svrl:text>
                     <svrl:message-code>BR-O-02</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge/cbc:ChargeIndicator) &gt; 0 and not((exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-03">
                     <xsl:attribute name="test">(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))</xsl:attribute>
                     <svrl:text>[BR-O-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Not subject to VAT" shall not contain the Seller VAT registration number (BT-31), or the Buyer VAT registration number (BT-48).</svrl:text>
                     <svrl:message-code>BR-O-03</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-11">
                     <xsl:attribute name="test">(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])</xsl:attribute>
                     <svrl:text>[BR-O-11]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain other VAT breakdown groups (BG-23).</svrl:text>
                     <svrl:message-code>BR-O-11</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and string-length(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) &gt; 15">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-310">
                     <xsl:attribute name="test">exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and string-length(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) &gt; 15</xsl:attribute>
                     <svrl:text>The buyer VAT registration number (BT-48) must contain 15 digits. The first digit and the last digit is “3”</svrl:text>
                     <svrl:message-code>BR-CL-310</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &gt; 15">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-31">
                     <xsl:attribute name="test">exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &gt; 15</xsl:attribute>
                     <svrl:text>[BT-31]-Field character limit for VAT number (registered) field has been exceeded. The maximum limit for this field is 15.</svrl:text>
                     <svrl:message-code>BT-CL-31</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="not((exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-12">
                     <xsl:attribute name="test">(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])</xsl:attribute>
                     <svrl:text>[BR-O-12]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is not "Not subject to VAT".</svrl:text>
                     <svrl:message-code>BR-O-12</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-13">
                     <xsl:attribute name="test">(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])</xsl:attribute>
                     <svrl:text>[BR-O-13]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level allowances (BG-20) where Document level allowance VAT category code (BT-95) is not "Not subject to VAT".</svrl:text>
                     <svrl:message-code>BR-O-13</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-Z-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))</xsl:attribute>
                     <svrl:text>[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) where the VAT category code (BT-151 or BT-95) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</svrl:text>
                     <svrl:message-code>BR-Z-01</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine | cac:CreditNoteLine"
                 priority="27"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine | cac:CreditNoteLine" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine | cac:CreditNoteLine</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine | cac:CreditNoteLine</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(cac:InvoiceLine/cbc:ID) and string-length(cac:InvoiceLine/cbc:ID) &gt; 4">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-126">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:ID) and string-length(cac:InvoiceLine/cbc:ID) &gt; 4</xsl:attribute>
                     <svrl:text>[BT-126]-Field character limit for Invoice line identifier field has been exceeded. The maximum limit for this field is 4.</svrl:text>
                     <svrl:message-code>BT-CL-126</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:InvoiceLine/cbc:InvoicedQuantity) and string-length(cac:InvoiceLine/cbc:InvoicedQuantity) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-129">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:InvoicedQuantity) and string-length(cac:InvoiceLine/cbc:InvoicedQuantity) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-129]-Field character limit for Invoiced quantity field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-129</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode) and string-length(cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-130">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode) and string-length(cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-130]-Field character limit for Invoiced quantity unit of measure field has been exceeded. The maximum limit for this field is 127.</svrl:text>
                     <svrl:message-code>BT-CL-130</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:Item/cbc:Name) and string-length(cac:Item/cbc:Name) &gt; 1000">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-153">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Item/cbc:Name) and string-length(cac:InvoiceLine/cac:Item/cbc:Name) &gt; 1000</xsl:attribute>
                     <svrl:text>[BT-153]-Field character limit for Item name field has been exceeded. The maximum limit for this field is 14.BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-153</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="not((cbc:ID) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-21">
                     <xsl:attribute name="test">(cbc:ID) != ''</xsl:attribute>
                     <svrl:text>[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</svrl:text>
                     <svrl:message-code>BR-21</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="(not(exists(cbc:InvoicedQuantity)) or cbc:InvoicedQuantity/text() = '0')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-22">
                     <xsl:attribute name="test">exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)</xsl:attribute>
                     <svrl:text>[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</svrl:text>
                     <svrl:message-code>BR-22</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:LineExtensionAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-24">
                     <xsl:attribute name="test">exists(cbc:LineExtensionAmount)</xsl:attribute>
                     <svrl:text>[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</svrl:text>
                     <svrl:message-code>BR-24</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:Item/cbc:Name) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-25">
                     <xsl:attribute name="test">(cac:Item/cbc:Name) != ''</xsl:attribute>
                     <svrl:text>[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</svrl:text>
                     <svrl:message-code>BR-25</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:Price/cbc:PriceAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-26">
                     <xsl:attribute name="test">exists(cac:Price/cbc:PriceAmount)</xsl:attribute>
                     <svrl:text>[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</svrl:text>
                     <svrl:message-code>BR-26</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-04">
                     <xsl:attribute name="test">(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)</xsl:attribute>
                     <svrl:text>[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</svrl:text>
                     <svrl:message-code>BR-CO-04</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-23">
                     <xsl:attribute name="test">string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-23</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]"
                 priority="26"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:Amount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-41">
                     <xsl:attribute name="test">exists(cbc:Amount)</xsl:attribute>
                     <svrl:text>[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</svrl:text>
                     <svrl:message-code>BR-41</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length(cbc:AllowanceChargeReasonCode) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-136">
                     <xsl:attribute name="test">string-length(cbc:AllowanceChargeReasonCode) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-136]-Field character limit for Invoice line allowance amount (discount or rebate amount) field has been exceeded. The maximum limit for this field is 14.BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-136</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-137">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and string-length(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-137]-Field character limit for Invoice line allowance base amount field has been exceeded. The maximum limit for this field is 14.BT-131]-Field character limit for Invoice line net amount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-137</svrl:message-code>
                     <svrl:message-category>KSA – EN16931 (BR-KSA-EN16931)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="not((exists(cbc:AllowanceChargeReason) and (cbc:AllowanceChargeReason) !='')  or (exists(cbc:AllowanceChargeReasonCode) and (cbc:AllowanceChargeReasonCode) !=''))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-42">
                     <xsl:attribute name="test">(exists(cbc:AllowanceChargeReason) and (cbc:AllowanceChargeReason) !='')  or (exists(cbc:AllowanceChargeReasonCode) and (cbc:AllowanceChargeReasonCode) !='')</xsl:attribute>
                     <svrl:text>[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</svrl:text>
                     <svrl:message-code>BR-42</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:Amount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-24">
                     <xsl:attribute name="test">string-length(substring-after(cbc:Amount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-24</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-25">
                     <xsl:attribute name="test">string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-25</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//cac:AdditionalItemProperty" priority="25" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "//cac:AdditionalItemProperty" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:AdditionalItemProperty</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:AdditionalItemProperty</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:Name) and exists(cbc:Value))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-54">
                     <xsl:attribute name="test">exists(cbc:Name) and exists(cbc:Value)</xsl:attribute>
                     <svrl:text>[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</svrl:text>
                     <svrl:message-code>BR-54</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:PaymentMeans" priority="24" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:PaymentMeans" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PaymentMeans</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PaymentMeans</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')])" >
                  <xsl:if test="not(exists(cbc:PaymentMeansCode))">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                         location="{schxslt:location(.)}"
                                         flag="error"
                                         id="BR-49">
                        <xsl:attribute name="test">exists(cbc:PaymentMeansCode)</xsl:attribute>
                        <svrl:text>[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</svrl:text>
                        <svrl:message-code>BR-49</svrl:message-code>
                        <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:BillingReference" priority="23" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:BillingReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:BillingReference</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:BillingReference</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cac:InvoiceDocumentReference/cbc:ID) and (cac:InvoiceDocumentReference/cbc:ID) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-55">
                     <xsl:attribute name="test">exists(cac:InvoiceDocumentReference/cbc:ID) and (cac:InvoiceDocumentReference/cbc:ID) !=''</xsl:attribute>
                     <svrl:text>[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</svrl:text>
                     <svrl:message-code>BR-55</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress"
                 priority="22"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
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
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cac:Country/cbc:IdentificationCode) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-09">
                     <xsl:attribute name="test">(cac:Country/cbc:IdentificationCode) != ''</xsl:attribute>
                     <svrl:text>[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</svrl:text>
                     <svrl:message-code>BR-09</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) &gt; 2">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-40">
                     <xsl:attribute name="test">exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) &gt; 2</xsl:attribute>
                     <svrl:text>[BT-40]-Field character limit for Address - Country code field has been exceeded. The maximum limit for this field is 2.</svrl:text>
                     <svrl:message-code>BT-CL-40</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal"
                 priority="21"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-14">
                     <xsl:attribute name="test">(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)</xsl:attribute>
                     <svrl:text>[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</svrl:text>
                     <svrl:message-code>BR-CO-14</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:TaxTotal/cac:TaxSubtotal" priority="20" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:TaxTotal/cac:TaxSubtotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:TaxableAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-45">
                     <xsl:attribute name="test">exists(cbc:TaxableAmount)</xsl:attribute>
                     <svrl:text>[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</svrl:text>
                     <svrl:message-code>BR-45</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-46">
                     <xsl:attribute name="test">exists(cbc:TaxAmount)</xsl:attribute>
                     <svrl:text>[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</svrl:text>
                     <svrl:message-code>BR-46</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-47">
                     <xsl:attribute name="test">exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)</xsl:attribute>
                     <svrl:text>[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</svrl:text>
                     <svrl:message-code>BR-47</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:ID) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:ID) &gt; 1">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-118">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:ID) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:ID) &gt; 1</xsl:attribute>
                     <svrl:text>[BT-118]-Field character limit for VAT category code field has been exceeded. The maximum limit for this field is 1.</svrl:text>
                     <svrl:message-code>BT-CL-118</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent) &gt; 6">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-119">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/cac:TaxCategory/cbc:Percent) &gt; 6</xsl:attribute>
                     <svrl:text>[BT-119]-Field character limit for VAT category rate field has been exceeded. The maximum limit for this field is 6.</svrl:text>
                     <svrl:message-code>BT-CL-119</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt; 14">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-117">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) and string-length(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt; 14</xsl:attribute>
                     <svrl:text>[BT-117]-Field character limit for VAT category tax amount field has been exceeded. The maximum limit for this field is 14.</svrl:text>
                     <svrl:message-code>BT-CL-117</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-48">
                     <xsl:attribute name="test">exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')</xsl:attribute>
                     <svrl:text>[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</svrl:text>
                     <svrl:message-code>BR-48</svrl:message-code>
                     <svrl:message-category>Business rules – integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CO-17">
                     <xsl:attribute name="test">(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))</xsl:attribute>
                     <svrl:text>[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                     <svrl:message-code>BR-CO-17</svrl:message-code>
                     <svrl:message-category>Business rules – conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-19">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-19</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-20">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-20</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="19"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(xs:decimal(../cbc:TaxAmount) = 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-E-09">
                     <xsl:attribute name="test">xs:decimal(../cbc:TaxAmount) = 0</xsl:attribute>
                     <svrl:text>[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-09</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-E-10">
                     <xsl:attribute name="test">exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)</xsl:attribute>
                     <svrl:text>[BR-E-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</svrl:text>
                     <svrl:message-code>BR-E-10</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="18"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-E-06">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-06</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="17"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) and string-length(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) &gt; 6">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BT-CL-152">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) and string-length(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) &gt; 6</xsl:attribute>
                     <svrl:text>[BT-152]-Field character limit for Invoiced item VAT rate field has been exceeded. The maximum limit for this field is 6.</svrl:text>
                     <svrl:message-code>BT-CL-152</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-E-05">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-05</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="16"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-08">
                     <xsl:attribute name="test">(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))</xsl:attribute>
                     <svrl:text>[BR-O-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) where the VAT category codes (BT-151, BT-95) are "Not subject to VAT".</svrl:text>
                     <svrl:message-code>BR-O-08</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(xs:decimal(../cbc:TaxAmount) = 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-09">
                     <xsl:attribute name="test">xs:decimal(../cbc:TaxAmount) = 0</xsl:attribute>
                     <svrl:text>[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-O-09</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((exists(cbc:TaxExemptionReason) and (cbc:TaxExemptionReason) !='') or (exists(cbc:TaxExemptionReasonCode) and (cbc:TaxExemptionReasonCode) !=''))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-10">
                     <xsl:attribute name="test">(exists(cbc:TaxExemptionReason) and (cbc:TaxExemptionReason) !='') or (exists(cbc:TaxExemptionReasonCode) and (cbc:TaxExemptionReasonCode) !='')</xsl:attribute>
                     <svrl:text>[BR-O-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</svrl:text>
                     <svrl:message-code>BR-O-10</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="15"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(not(cbc:Percent))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-06">
                     <xsl:attribute name="test">not(cbc:Percent)</xsl:attribute>
                     <svrl:text>[BR-O-06]-A Document level allowance (BG-2020) where VAT category code (BT-9595) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</svrl:text>
                     <svrl:message-code>BR-O-06</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="14"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(not(cbc:Percent))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-O-05">
                     <xsl:attribute name="test">not(cbc:Percent)</xsl:attribute>
                     <svrl:text>[BR-O-05]-An Invoice line (BG-2525) where the VAT category code (BT-151151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152152).</svrl:text>
                     <svrl:message-code>BR-O-05</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="13"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 &gt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-S-09">
                     <xsl:attribute name="test">(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 &gt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )</xsl:attribute>
                     <svrl:text>[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                     <svrl:message-code>BR-S-09</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>

                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID/text() = 'S') and (exists(//cbc:TaxExemptionReason) or exists(//cbc:TaxExemptionReasonCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-S-10">
                     <xsl:attribute name="test">not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)</xsl:attribute>
                     <svrl:text>[BR-S-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
                     <svrl:message-code>BR-S-10</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="12"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:Percent) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-S-06">
                     <xsl:attribute name="test">(cbc:Percent) &gt; 0</xsl:attribute>
                     <svrl:text>[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</svrl:text>
                     <svrl:message-code>BR-S-06</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="11"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
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
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(xs:decimal(../cbc:TaxAmount) = 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-Z-09">
                     <xsl:attribute name="test">xs:decimal(../cbc:TaxAmount) = 0</xsl:attribute>
                     <svrl:text>[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-09</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="10"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-Z-06">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-06</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"
                 priority="9"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-Z-05">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-05</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]"
                 priority="8"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e353']">
            <schxslt:rule pattern="d7e353">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e353">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((string-length(substring-after(.,'.'))&lt;=2))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-13">
                     <xsl:attribute name="test">(string-length(substring-after(.,'.'))&lt;=2)</xsl:attribute>
                     <svrl:text>[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-13</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e353')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]"
                 priority="7"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e362']">
            <schxslt:rule pattern="d7e362">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e362">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((string-length(substring-after(.,'.'))&lt;=2))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-DEC-15">
                     <xsl:attribute name="test">(string-length(substring-after(.,'.'))&lt;=2)</xsl:attribute>
                     <svrl:text>[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-15</svrl:message-code>
                     <svrl:message-category>Business rules – Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e362')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"
                 priority="6"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if
                       test="not((self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 381 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 396 420 458 532 ', concat(' ', normalize-space(.), ' '))))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-01">
                     <xsl:attribute name="test">(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 381 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))</xsl:attribute>
                     <svrl:text>[BR-CL-01]-The document type code MUST be coded by the invoice and credit note related code lists of UNTDID 1001.</svrl:text>
                     <svrl:message-code>BR-CL-01</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount"
                 priority="5"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test=" string-length(@currencyID) &gt; 0 and not(((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-03">
                     <xsl:attribute name="test">((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-03]-currencyID MUST be coded using ISO code list 4217 alpha-3</svrl:text>
                     <svrl:message-code>BR-CL-03</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:DocumentCurrencyCode" priority="4" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:DocumentCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
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
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:DocumentCurrencyCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-04">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-04]-Invoice currency code MUST be coded using ISO code list 4217 alpha-3</svrl:text>
                     <svrl:message-code>BR-CL-04</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:TaxCurrencyCode" priority="3" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cbc:TaxCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
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
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-05">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-05]-Tax currency code MUST be coded using ISO code list 4217 alpha-3</svrl:text>
                     <svrl:message-code>BR-CL-05</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:Country/cbc:IdentificationCode"
                 priority="2"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:Country/cbc:IdentificationCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:Country/cbc:IdentificationCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:Country/cbc:IdentificationCode</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-14">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-14]-Country codes in an invoice MUST be coded using ISO code list 3166-1</svrl:text>
                     <svrl:message-code>BR-CL-14</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:PaymentMeans/cbc:PaymentMeansCode"
                 priority="1"
                 mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:PaymentMeans/cbc:PaymentMeansCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:PaymentMeans/cbc:PaymentMeansCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:PaymentMeans/cbc:PaymentMeansCode</xsl:attribute>
               </svrl:fired-rule>

               <xsl:if test="not(( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-16">
                     <xsl:attribute name="test">( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )</xsl:attribute>
                     <svrl:text>[BR-CL-16]-Payment means in an invoice MUST be coded using UNCL4461 code list</svrl:text>
                     <svrl:message-code>BR-CL-16</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:ClassifiedTaxCategory/cbc:ID" priority="0" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:ClassifiedTaxCategory/cbc:ID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:ClassifiedTaxCategory/cbc:ID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:ClassifiedTaxCategory/cbc:ID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="error"
                                      id="BR-CL-18">
                     <xsl:attribute name="test">( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )</xsl:attribute>
                     <svrl:text>[BR-CL-18]-Invoice tax categories MUST be coded using UNCL5305 code list</svrl:text>
                     <svrl:message-code>BR-CL-18</svrl:message-code>
                     <svrl:message-category>Business rules – Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd7e371')"/>
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