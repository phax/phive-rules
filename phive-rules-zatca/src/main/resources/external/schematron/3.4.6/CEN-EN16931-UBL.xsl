<?xml version="1.0" encoding="UTF-8"?>
<!--

   This file is based on the CEN/EN 16931:2017 standard and br-licensed under the LGPL v3 in compliance with the terms granted in the EUPL v1.2 under which the original standard has been published.

The copyright of CEN/EN 16931:2017 is owned by CEN and its members - the European National Standards Bodies. A copy of CEN/EN 16931-1:2017 may be obtained from any CEN member.

-->
<xsl:transform xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
               xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
               xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
               xmlns:warning="https://doi.org/10.5281/zenodo.1495494#warning"
               xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
               xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
               xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
   <xsl:variable name="Discount">
      <entry key = "2">Amendment commission</entry>
      <entry key = "3">Acceptance commission</entry>
      <entry key = "4">Commission for obtaining acceptance</entry>
      <entry key = "5">Commission on delivery</entry>
      <entry key = "6">Advising commission</entry>
      <entry key = "7">Confirmation commission</entry>
      <entry key = "8">Deferred payment commission</entry>
   </xsl:variable>
   <xsl:template match="/">
      <xsl:variable name="metadata" as="element()?">
         <svrl:metadata xmlns:dct="http://purl.org/dc/terms/"
                        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                        xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
            <dct:creator>
               <dct:Agent>
                  <skos:prefLabel>
                     <xsl:variable name="prefix" as="xs:string?" select="if (doc-available('')) then in-scope-prefixes(document('')/*[1])[namespace-uri-for-prefix(., document('')/*[1]) eq 'http://www.w3.org/1999/XSL/Transform'][1] else ()"/>
                     <xsl:choose>
                        <xsl:when test="empty($prefix)">Unknown</xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of separator="/" select="(system-property(concat($prefix, ':product-name')), system-property(concat($prefix,':product-version')))"/>
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
         <xsl:sequence select="$metadata"/>
         <xsl:for-each select="$report/schxslt:pattern">
            <xsl:sequence select="node()"/>
            <xsl:sequence select="$report/schxslt:rule[@pattern = current()/@id]/node()"/>
         </xsl:for-each>
      </xsl:variable>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
         <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
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
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="CustomRules_documentCurrency">
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
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule  for context "cac:AdditionalDocumentReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AdditionalDocumentReference</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:ID) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-52">
                     <xsl:attribute name="test">(cbc:ID) != ''</xsl:attribute>
                     <svrl:text>[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</svrl:text>
                     <svrl:message-code>BR-52</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" priority="31" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule  for context "/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:Amount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-31">
                     <xsl:attribute name="test">exists(cbc:Amount)</xsl:attribute>
                     <svrl:text>[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</svrl:text>
                     <svrl:message-code>BR-31</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-32">
                     <xsl:attribute name="test">exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) !=''</xsl:attribute>
                     <svrl:text>[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</svrl:text>
                     <svrl:message-code>BR-32</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:Amount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-01">
                     <xsl:attribute name="test">string-length(substring-after(cbc:Amount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-01</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-02">
                     <xsl:attribute name="test">string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-02</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" priority="31" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule  for context "/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- charge -->
   <xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" priority="31" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]</xsl:attribute>
               </svrl:fired-rule>
               <!-- BR-36 -->
               <xsl:if test="(not (exists(./cbc:Amount)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-36">
                     <xsl:attribute name="test">not(exists((/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()]/exists(cbc:amount) )))</xsl:attribute>
                     <svrl:text>[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</svrl:text>
                     <svrl:message-code>BR-36</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!-- End BR-36 -->
               <!-- BR-37 -->
               <xsl:if test="not(exists(cac:TaxCategory/cbc:ID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-37">
                     <xsl:attribute name="test">not(exists((/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()]/exists(cbc:TaxCategory/cvc:ID) )))</xsl:attribute>
                     <svrl:text>[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</svrl:text>
                     <svrl:message-code>BR-37</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!-- End BR-37 -->
               <!--DEC-06-->
               <xsl:if test="not(string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-06">
                     <xsl:attribute name="test">string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-06</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!--END-DEC-06-->
               <xsl:if test="not(string-length(substring-after(cbc:Amount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-05">
                     <xsl:attribute name="test">string-length(substring-after(cbc:Amount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-05</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- End charge -->
   <xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" priority="31" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]</xsl:attribute>
               </svrl:fired-rule>
               <!-- BR-43 -->
               <xsl:if test="(not (exists(./cbc:Amount)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-43">
                     <xsl:attribute name="test">not(exists((/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]/exists(cbc:amount) )))</xsl:attribute>
                     <svrl:text>[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</svrl:text>
                     <svrl:message-code>BR-43</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!-- End BR-43 -->
               <xsl:if test="not(string-length(substring-after(./cbc:Amount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-27">
                     <xsl:attribute name="test">string-length(substring-after(cbc:Amount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-27</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(./cbc:BaseAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-28">
                     <xsl:attribute name="test">string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-28</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--test2-->
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
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:LegalMonetaryTotal</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:TaxExclusiveAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-13">
                     <xsl:attribute name="test">exists(cbc:TaxExclusiveAmount)</xsl:attribute>
                     <svrl:text>[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</svrl:text>
                     <svrl:message-code>BR-13</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxInclusiveAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-14">
                     <xsl:attribute name="test">exists(cbc:TaxInclusiveAmount)</xsl:attribute>
                     <svrl:text>[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</svrl:text>
                     <svrl:message-code>BR-14</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:PayableAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-15">
                     <xsl:attribute name="test">exists(cbc:PayableAmount)</xsl:attribute>
                     <svrl:text>[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</svrl:text>
                     <svrl:message-code>BR-15</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-10">
                     <xsl:attribute name="test">(xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))</xsl:attribute>
                     <svrl:text>[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</svrl:text>
                     <svrl:message-code>BR-CO-10</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-11">
                     <xsl:attribute name="test">xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))</xsl:attribute>
                     <svrl:text>[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</svrl:text>
                     <svrl:message-code>BR-CO-11</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:choose>
                  <xsl:when test= "exists (cbc:ChargeTotalAmount) and normalize-space(cbc:ChargeTotalAmount)='' ">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-12">
                        <xsl:attribute name="test">xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))</xsl:attribute>
                        <svrl:text>[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</svrl:text>
                        <svrl:message-code>BR-CO-12</svrl:message-code>
                        <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:if test=" not(xs:decimal(cbc:ChargeTotalAmount) = ( round ( sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount))  * 10 * 10)div 100  ) or   (  not(cbc:ChargeTotalAmount)      and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()])))">
                        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-12">
                           <xsl:attribute name="test">xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))</xsl:attribute>
                           <svrl:text>[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</svrl:text>
                           <svrl:message-code>BR-CO-12</svrl:message-code>
                           <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                        </svrl:failed-assert>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>

               <xsl:choose>
                  <xsl:when test= "exists (cbc:ChargeTotalAmount) and normalize-space(cbc:ChargeTotalAmount)='' ">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-13">
                        <xsl:attribute name="test">((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))</xsl:attribute>
                        <svrl:text>[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</svrl:text>
                        <svrl:message-code>BR-CO-13</svrl:message-code>
                        <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:if test="not( ( (cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount)  and (xs:decimal(cbc:TaxExclusiveAmount ) = round (   (  xs:decimal(sum(/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount))   +  xs:decimal(cbc:ChargeTotalAmount)  -      xs:decimal(cbc:AllowanceTotalAmount) ) * 10 * 10 ) div 100  ))or(  not(cbc:ChargeTotalAmount)  and (cbc:AllowanceTotalAmount)  and ( xs:decimal(cbc:TaxExclusiveAmount) =   round  ( ( xs:decimal(sum(/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount)) -  xs:decimal(cbc:AllowanceTotalAmount)  ) * 10 * 10  )  div 100  ))or(  (cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (    xs:decimal(cbc:TaxExclusiveAmount) =    round    (   (    xs:decimal(sum(/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount))  +  xs:decimal(cbc:ChargeTotalAmount)  ) * 10 * 10  )  div 100 ))or ( not(cbc:ChargeTotalAmount) and  not(cbc:AllowanceTotalAmount) and (  xs:decimal(cbc:TaxExclusiveAmount) =xs:decimal((cbc:LineExtensionAmount)) )))">
                        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-13">
                           <xsl:attribute name="test">((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))</xsl:attribute>
                           <svrl:text>[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</svrl:text>
                           <svrl:message-code>BR-CO-13</svrl:message-code>
                           <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                        </svrl:failed-assert>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>

               <xsl:if test=" not(( not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or  (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-16">
                     <xsl:attribute name="test">(exists(cbc:PrepaidAmount) and not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or  (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount)))</xsl:attribute>
                     <svrl:text>[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Pre-Paid amount (BT-113) + Rounding amount (BT-114).</svrl:text>
                     <svrl:message-code>BR-CO-16</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="string-length(substring-after(cbc:LineExtensionAmount,'.')) &gt; 2">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-09">
                     <xsl:attribute name="test">string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-09</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-10">
                     <xsl:attribute name="test">string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-10</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!-- ADD DEC-11-->
               <xsl:if test="not(string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-11">
                     <xsl:attribute name="test">string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-11</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!-- END DEC-11-->
               <xsl:if test="not(string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-12">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-12</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-14">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-14</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-16">
                     <xsl:attribute name="test">string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-16]-The allowed maximum number of decimals for the Pre-Paid amount (BT-113) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-16</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-17">
                     <xsl:attribute name="test">string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-17</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-18">
                     <xsl:attribute name="test">string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.  </svrl:text>
                     <svrl:message-code>BR-DEC-18</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
<!--   <xsl:template match="cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']" priority="29" mode="d7e42">-->
<!--      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>-->
<!--      <xsl:choose>-->
<!--         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">-->
<!--            <schxslt:rule pattern="d7e42">-->
<!--               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']" shadowed by preceding rule</xsl:comment>-->
<!--               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">-->
<!--                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']</xsl:attribute>-->
<!--               </svrl:suppressed-rule>-->
<!--            </schxslt:rule>-->
<!--            <xsl:next-match>-->
<!--               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>-->
<!--            </xsl:next-match>-->
<!--         </xsl:when>-->
<!--         <xsl:otherwise>-->
<!--            <schxslt:rule pattern="d7e42">-->
<!--               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">-->
<!--                  <xsl:attribute name="context">cbc:InvoiceTypeCode[substring(@name, 1, 2) = '01']</xsl:attribute>-->
<!--               </svrl:fired-rule>-->
<!--               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')]) ">-->
<!--                  <xsl:if test="not (string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) &gt; 0 and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) &gt; 0   and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) &gt; 0 and string-length(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) &gt; 0 and exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-10">-->
<!--                     <xsl:attribute name="test">exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone) and         exists(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)</xsl:attribute>-->
<!--                     <svrl:text>[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).Not applicable for simplified tax invoices and associated credit notes and debit notes (KSA-2, position 1 and 2 = 02).</svrl:text>-->
<!--                     <svrl:message-code>BR-10</svrl:message-code>-->
<!--                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>-->
<!--                  </svrl:failed-assert>-->
<!--                  </xsl:if>-->
<!--               </xsl:if>-->
<!--            </schxslt:rule>-->
<!--            <xsl:next-match>-->
<!--               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>-->
<!--            </xsl:next-match>-->
<!--         </xsl:otherwise>-->
<!--      </xsl:choose>-->
<!--   </xsl:template>-->
   <xsl:template match="/ubl:Invoice | /cn:CreditNote" priority="28" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice | /cn:CreditNote" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:ID) and (cbc:ID) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-02">
                     <xsl:attribute name="test">exists(cbc:ID) and (cbc:ID) !=''</xsl:attribute>
                     <svrl:text>[BR-02]-An Invoice shall have an Invoice number (BT-1).</svrl:text>
                     <svrl:message-code>BR-02</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cbc:ID) and string-length(cbc:ID) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C1">
                     <xsl:attribute name="test">exists(cbc:ID) and string-length(cbc:ID) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-KSA-F-06-C1] - Field character limits for Invoice number field (BT-1) have not been met. The minimum limit is 1 character and the maximum limit is 127 characters.</svrl:text>
                     <svrl:message-code>BR-KSA-F-06-C1</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists((/ubl:Invoice/cbc:Note/text()[string-length() > 1000])[1])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C2">
                     <xsl:attribute name="test">exists((//cbc:Note/text()[string-length() > 1000 or string-length() &lt; 0])[1])</xsl:attribute>
                     <svrl:text>[BR-KSA-F-06-C2] - Field character limits for Invoice note field (BT-22) have not been met. The maximum limit is 1000 characters.</svrl:text>
                     <svrl:message-code>BR-KSA-F-06-C2</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:IssueDate) and (cbc:IssueDate) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-03">
                     <xsl:attribute name="test">exists(cbc:IssueDate) and (cbc:IssueDate) !=''</xsl:attribute>
                     <svrl:text>[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</svrl:text>
                     <svrl:message-code>BR-03</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((exists(cbc:InvoiceTypeCode) and (cbc:InvoiceTypeCode) !='') or (exists(cbc:CreditNoteTypeCode) and (cbc:CreditNoteTypeCode) !=''))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-04">
                     <xsl:attribute name="test">(exists(cbc:InvoiceTypeCode) and (cbc:InvoiceTypeCode) !='') or (exists(cbc:CreditNoteTypeCode) and (cbc:CreditNoteTypeCode) !='')</xsl:attribute>
                     <svrl:text>[BR-04]-An Invoice shall have an Invoice type code (BT-3).</svrl:text>
                     <svrl:message-code>BR-04</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:DocumentCurrencyCode) and (cbc:DocumentCurrencyCode) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-05">
                     <xsl:attribute name="test">exists(cbc:DocumentCurrencyCode) and (cbc:DocumentCurrencyCode) !=''</xsl:attribute>
                     <svrl:text>[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</svrl:text>
                     <svrl:message-code>BR-05</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-06">
                     <xsl:attribute name="test">exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''</xsl:attribute>
                     <svrl:text>[BR-06]-An Invoice shall contain the Seller name (BT-27).</svrl:text>
                     <svrl:message-code>BR-06</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)">
                  <xsl:if test=" (string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &gt; 1000 or string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt; 1)">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C10">
                        <xsl:attribute name="test">
                           exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) and (string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &gt; 127 or string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt; 1)
                        </xsl:attribute>
                        <svrl:text>[BR-KSA-F-06-C10] - Field character limits for Seller name field (BT-27) have not been met. The minimum limit is 1 character and the maximum limit is 1000 characters.
                        </svrl:text>
                        <svrl:message-code>BR-KSA-F-06-C10</svrl:message-code>
                        <svrl:message-category>Business rules - length constraints(BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:if>

               <xsl:if test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C8">
                     <xsl:attribute name="test">
                        exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and (string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) &gt; 127 or string-length(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) &lt; 1)
                     </xsl:attribute>
                     <svrl:text>[BR-KSA-F-06-C8] - Field character limits for the Seller Address - Province/State field (BT-39) have not been met. The maximum limit is 127 characters.
                     </svrl:text>
                     <svrl:message-code>BR-KSA-F-06-C8</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) and count(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) &gt;0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-08">
                     <xsl:attribute name="test">exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) and count(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) &gt;0</xsl:attribute>
                     <svrl:text>[BR-08]-An Invoice shall contain the Seller postal address (BG-5) </svrl:text>
                     <svrl:message-code>BR-08</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) and string-length(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)&gt;127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C27">
                     <xsl:attribute name="test">
                        exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and string-length(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) &gt; 127
                     </xsl:attribute>
                     <svrl:text>[BR-KSA-F-06-C27] - Field character limits for the Buyer Address - Province/State field (BT-54) have not been met. The maximum limit is 127 characters.
                     </svrl:text>
                     <svrl:message-code>BR-KSA-F-06-C27</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:InvoiceLine) or exists(cac:CreditNoteLine))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-16">
                     <xsl:attribute name="test">exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)</xsl:attribute>
                     <svrl:text>[BR-16]-An Invoice shall have at least one Invoice line (BG-25)</svrl:text>
                     <svrl:message-code>BR-16</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="(exists(cbc:TaxCurrencyCode) and not(every $taxcurrency in ./cac:TaxTotal[not(cac:TaxSubtotal)]/cbc:TaxAmount/@currencyID satisfies $taxcurrency = cbc:TaxCurrencyCode)) or (exists(cbc:TaxCurrencyCode) and not(every $taxamount in ./cac:TaxTotal[not(cac:TaxSubtotal)] satisfies exists($taxamount/cbc:TaxAmount)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-53">
                     <xsl:attribute name="test">(exists(cbc:TaxCurrencyCode) and not(every $taxcurrency in ./cac:TaxTotal/cbc:TaxAmount/@currencyID satisfies $taxcurrency = cbc:TaxCurrencyCode)) or(exists(cbc:TaxCurrencyCode) and not(every $taxamount in ./cac:TaxTotal satisfies exists($taxamount/cbc:TaxAmount)))</xsl:attribute>
                     <svrl:text>[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</svrl:text>
                     <svrl:message-code>BR-53</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:for-each select="//cac:InvoiceLine">
                  <xsl:if test="exists(cbc:ID) and (string-length(cbc:ID) &gt; 6 or string-length(cbc:ID) &lt; 1)">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-KSA-F-06-C17">
                        <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:ID) and (string-length(cac:InvoiceLine/cbc:ID) &gt; 6 or string-length(cac:InvoiceLine/cbc:ID) &lt; 1)</xsl:attribute>
                        <svrl:text>[BR-KSA-F-06-C17] - Field character limits for Invoice line identifier field (BT-126) have not been met. The minimum limit is 1 character and the maximum limit is 6 characters.</svrl:text>
                        <svrl:message-code>BR-KSA-F-06-C17</svrl:message-code>
                        <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
                  <xsl:if test="exists(cac:Item/cac:BuyersItemIdentification/cbc:ID) and string-length(cac:Item/cac:BuyersItemIdentification/cbc:ID) &gt; 127">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C30">
                        <xsl:attribute name="test">exists(cac:Item/cac:BuyersItemIdentification/cbc:ID) and string-length(cac:Item/cac:BuyersItemIdentification/cbc:ID) &gt; 127</xsl:attribute>
                        <svrl:text>[BR-KSA-F-06-C30] - Field character limits for Item Buyer's identifier field (BT-156) have not been met. The maximum limit is 127 characters.</svrl:text>
                        <svrl:message-code>BR-KSA-F-06-C30</svrl:message-code>
                        <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
                  <xsl:if test="exists(cac:Item/cac:SellersItemIdentification/cbc:ID) and string-length(cac:Item/cac:SellersItemIdentification/cbc:ID) &gt; 127">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C31">
                        <xsl:attribute name="test">exists(cac:Item/cac:SellersItemIdentification/cbc:ID) and string-length(cac:Item/cac:SellersItemIdentification/cbc:ID) &gt; 127</xsl:attribute>
                        <svrl:text>[BR-KSA-F-06-C31] - Field character limits for Item Seller's identifier field (BT-155) have not been met. The maximum limit is 127 characters.</svrl:text>
                        <svrl:message-code>BR-KSA-F-06-C31</svrl:message-code>
                        <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
                  <xsl:if test="exists(cac:Item/cac:StandardItemIdentification/cbc:ID) and string-length(cac:Item/cac:StandardItemIdentification/cbc:ID) &gt; 127">
                     <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C20">
                        <xsl:attribute name="test">exists(cac:Item/cac:StandardItemIdentification/cbc:ID) and string-length(cac:Item/cac:StandardItemIdentification/cbc:ID) &gt; 127</xsl:attribute>
                        <svrl:text>[BR-KSA-F-06-C20] - Field character limits for Item standard identifier field (BT-157) have not been met. The maximum limit is 127 characters.</svrl:text>
                        <svrl:message-code>BR-KSA-F-06-C20</svrl:message-code>
                        <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                     </svrl:failed-assert>
                  </xsl:if>
               </xsl:for-each>
               <xsl:if test="not(every $Currency in cbc:DocumentCurrencyCode satisfies (count(cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) &gt;= 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + sum(cac:TaxTotal/cac:TaxSubtotal/xs:decimal(cbc:TaxAmount))) * 10 * 10) div 100))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-15">
                     <xsl:attribute name="test">every $Currency in cbc:DocumentCurrencyCode satisfies (count(cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) &gt;= 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + sum(cac:TaxTotal/cac:TaxSubtotal/xs:decimal(cbc:TaxAmount))) * 10 * 10) div 100)</xsl:attribute>
                     <svrl:text>[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</svrl:text>
                     <svrl:message-code>BR-CO-15</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxTotal/cac:TaxSubtotal))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-18">
                     <xsl:attribute name="test">exists(cac:TaxTotal/cac:TaxSubtotal)</xsl:attribute>
                     <svrl:text>[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</svrl:text>
                     <svrl:message-code>BR-CO-18</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((exists(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])  &gt; 0)) or (not(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-E-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))</xsl:attribute>
                     <svrl:text>[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151 or BT-95 or BT-102) is "Exempt from VAT" shall contain at least one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</svrl:text>
                     <svrl:message-code>BR-E-01</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!-- Role BR-O-01 -->
               <xsl:if test="not(((exists(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])  &gt; 0)) or (not(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-O-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))</xsl:attribute>
                     <svrl:text>[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151 or BT-95 or BT-102) is "Not subject to VAT" shall contain exactly at least one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</svrl:text>
                     <svrl:message-code>BR-O-01</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!--End Role BR-O-01 -->

               <xsl:if test="not(((exists(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S'])  &gt; 0)) or (not(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']))</xsl:attribute>
                     <svrl:text>[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</svrl:text>
                     <svrl:message-code>BR-S-01</svrl:message-code>
                     <svrl:message-category>Business rules - VAT Standard rated (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] and not(((/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory /cbc:Percent)=0)) ">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-Z-07">
                     <xsl:attribute name="test">cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] and (/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory /cbc:Percent)=0 </xsl:attribute>
                     <svrl:text>[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-07</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] and not(((/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory /cbc:Percent)=0)) ">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-E-07">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-07</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((exists(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])  &gt; 0)) or (not(//cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-Z-01">
                     <xsl:attribute name="test">((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) >= 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))</xsl:attribute>
                     <svrl:text>[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151 or BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Zero rated".</svrl:text>
                     <svrl:message-code>BR-Z-01</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" priority="27" mode="d7e42">
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
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine | cac:CreditNoteLine</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="exists(cbc:InvoicedQuantity/@unitCode) and string-length(cbc:InvoicedQuantity/@unitCode) &gt; 127">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C18">
                     <xsl:attribute name="test">exists(cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode) and string-length(cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode) &gt; 127</xsl:attribute>
                     <svrl:text>[BR-KSA-F-06-C18] - Field character limits for Invoiced quantity unit of measure field (BT-130) have not been met. The maximum limit is 127 characters.</svrl:text>
                     <svrl:message-code>BR-KSA-F-06-C18</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="exists(cac:Item/cbc:Name) and (string-length(cac:Item/cbc:Name) &gt; 1000 or string-length(cac:Item/cbc:Name) &lt; 3)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-KSA-F-06-C19">
                     <xsl:attribute name="test">exists(cac:Item/cbc:Name) and (string-length(cac:Item/cbc:Name) &gt; 1000 or string-length(cac:Item/cbc:Name) &lt; 3)</xsl:attribute>
                     <svrl:text>[BR-KSA-F-06-C19] - Field character limits for Item name field (BT-153) have not been met. The minimum limit is 3 character and the maximum limit is 1000 characters.</svrl:text>
                     <svrl:message-code>BR-KSA-F-06-C19</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="exists(cac:Item/cbc:Name) and
              matches(cac:Item/cbc:Name, '^\d+$') and (
                  matches(cac:Item/cbc:Name, '.*(012|123|234|345|456|567|678|789|890).*') or
                  matches(cac:Item/cbc:Name, '.*(987|876|765|654|543|432|321|210).*') or
                  matches(cac:Item/cbc:Name, '.*(\d)\1{2,}.*') or
                  matches(cac:Item/cbc:Name, '^\d+$')
              )">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-KSA-F-C-01">
                     <svrl:text>[BR-KSA-F-C-01] - Please recheck Item Description (BT-153). Providing unclear description violates the requirements specified in Article 53 of VAT Regulations.</svrl:text>
                     <svrl:message-code>BR-KSA-F-C-01</svrl:message-code>
                     <svrl:message-category>KSA - business rules (BR-KSA)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>


               <xsl:if test="not((cbc:ID) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-21">
                     <xsl:attribute name="test">(cbc:ID) != ''</xsl:attribute>
                     <svrl:text>[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</svrl:text>
                     <svrl:message-code>BR-21</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="(not(exists(cbc:InvoicedQuantity)) or cbc:InvoicedQuantity/text() = '0')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-22">
                     <xsl:attribute name="test">exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)</xsl:attribute>
                     <svrl:text>[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</svrl:text>
                     <svrl:message-code>BR-22</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:LineExtensionAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-24">
                     <xsl:attribute name="test">exists(cbc:LineExtensionAmount)</xsl:attribute>
                     <svrl:text>[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</svrl:text>
                     <svrl:message-code>BR-24</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:Item/cbc:Name) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-25">
                     <xsl:attribute name="test">(cac:Item/cbc:Name) != ''</xsl:attribute>
                     <svrl:text>[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</svrl:text>
                     <svrl:message-code>BR-25</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:Price/cbc:PriceAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-26">
                     <xsl:attribute name="test">exists(cac:Price/cbc:PriceAmount)</xsl:attribute>
                     <svrl:text>[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</svrl:text>
                     <svrl:message-code>BR-26</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-04">
                     <xsl:attribute name="test">(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)</xsl:attribute>
                     <svrl:text>[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</svrl:text>
                     <svrl:message-code>BR-CO-04</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-23">
                     <xsl:attribute name="test">string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-23</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" priority="26" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:Amount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-41">
                     <xsl:attribute name="test">exists(cbc:Amount)</xsl:attribute>
                     <svrl:text>[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</svrl:text>
                     <svrl:message-code>BR-41</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:Amount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-24">
                     <xsl:attribute name="test">string-length(substring-after(cbc:Amount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-24</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-25">
                     <xsl:attribute name="test">string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-25</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//cac:AdditionalItemProperty" priority="25" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "//cac:AdditionalItemProperty" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:AdditionalItemProperty</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//cac:AdditionalItemProperty</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:Name) and exists(cbc:Value))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-54">
                     <xsl:attribute name="test">exists(cbc:Name) and exists(cbc:Value)</xsl:attribute>
                     <svrl:text>[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</svrl:text>
                     <svrl:message-code>BR-54</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:PaymentMeans" priority="24" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:PaymentMeans" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PaymentMeans</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PaymentMeans</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="boolean(//*[matches(@name, '01\d{5}')]) and not(exists(cbc:PaymentMeansCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-49">
                     <xsl:attribute name="test">exists(cbc:PaymentMeansCode)</xsl:attribute>
                     <svrl:text>[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</svrl:text>
                     <svrl:message-code>BR-49</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:BillingReference" priority="23" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:BillingReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:BillingReference</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:BillingReference</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cac:InvoiceDocumentReference/cbc:ID) and (cac:InvoiceDocumentReference/cbc:ID) !='')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-55">
                     <xsl:attribute name="test">exists(cac:InvoiceDocumentReference/cbc:ID) and (cac:InvoiceDocumentReference/cbc:ID) !=''</xsl:attribute>
                     <svrl:text>[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</svrl:text>
                     <svrl:message-code>BR-55</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" priority="22" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cac:Country/cbc:IdentificationCode) != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-09">
                     <xsl:attribute name="test">(cac:Country/cbc:IdentificationCode) != ''</xsl:attribute>
                     <svrl:text>[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</svrl:text>
                     <svrl:message-code>BR-09</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal" priority="21" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CO-14">
                     <xsl:attribute name="test">(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)</xsl:attribute>
                     <svrl:text>[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</svrl:text>
                     <svrl:message-code>BR-CO-14</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" priority="20" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:TaxTotal/cac:TaxSubtotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(exists(cbc:TaxableAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-45">
                     <xsl:attribute name="test">exists(cbc:TaxableAmount)</xsl:attribute>
                     <svrl:text>[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</svrl:text>
                     <svrl:message-code>BR-45</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cbc:TaxAmount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-46">
                     <xsl:attribute name="test">exists(cbc:TaxAmount)</xsl:attribute>
                     <svrl:text>[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</svrl:text>
                     <svrl:message-code>BR-46</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-47">
                     <xsl:attribute name="test">exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)</xsl:attribute>
                     <svrl:text>[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</svrl:text>
                     <svrl:message-code>BR-47</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-48">
                     <xsl:attribute name="test">exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')</xsl:attribute>
                     <svrl:text>[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</svrl:text>
                     <svrl:message-code>BR-48</svrl:message-code>
                     <svrl:message-category>Business rules - integrity constraints (BR)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <!--<xsl:choose>
                  <xsl:when test= "not (./cac:TaxCategory/normalize-space(cbc:ID)='S') and (./cac:TaxCategory/normalize-space(cbc:ID)='O' and not(exists(./cac:TaxCategory/cbc:Percent)) or ./cac:TaxCategory/normalize-space(cbc:ID)='E' or ./cac:TaxCategory/normalize-space(cbc:ID)='Z' or normalize-space(./cac:TaxCategory/cbc:Percent)='')">
                     <xsl:variable name="taxAmount" select="./cbc:TaxAmount" as="xs:float"/>
                     <xsl:variable name="toleranceLimit" select="count(//cac:InvoiceLine) * 0.01" as="xs:float"/>
                     <xsl:variable name="shouldBe" select="round((((xs:decimal(./cbc:TaxableAmount) * (0)) div 100) * 100)) div 100" as="xs:float"/>
                      <xsl:variable name="shouldBe" select="xs:decimal(./cbc:TaxableAmount) * (0)" as="xs:float"/>
                     <xsl:variable name="upperLimit" select="$shouldBe + $toleranceLimit" as="xs:float" />
                     <xsl:variable name="lowerLimit" select="$shouldBe - $toleranceLimit" as="xs:float" />
                     <xsl:if test="not(($taxAmount &gt;= $upperLimit and $taxAmount &lt;= $lowerLimit) or ($taxAmount = $shouldBe))">
                        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-17">
                           <xsl:attribute name="test">(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))</xsl:attribute>
                           <svrl:text>[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                           <svrl:message-code>BR-CO-17</svrl:message-code>
                           <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                        </svrl:failed-assert>
                     </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:variable name="taxAmount" select="./cbc:TaxAmount" as="xs:float"/>
                     <xsl:variable name="taxableAmount" select="./cbc:TaxableAmount" as="xs:float"/>
                     <xsl:variable name="toleranceLimit" select="count(//cac:InvoiceLine) * 0.01" as="xs:float"/>
                     <xsl:variable name="vatCategoryRate" select="./cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:float(cbc:Percent)" as="xs:float"/>
                     <xsl:variable name="shouldBe" select="(round(($taxableAmount * ($vatCategoryRate div 100))*100)) div 100" as="xs:float"/>
                     <xsl:variable name="upperLimit" select="round(($shouldBe + $toleranceLimit)*100) div 100" as="xs:float" />
                     <xsl:variable name="lowerLimit" select="round(($shouldBe - $toleranceLimit)*100) div 100" as="xs:float" />
                     <xsl:variable name="checkOne" select="normalize-space(./cac:TaxCategory/cbc:Percent)=''" as="xs:boolean" />
                     <xsl:variable name="checkTwo" select="($taxAmount &lt;= $upperLimit and $taxAmount &gt;= $lowerLimit or $taxAmount = $shouldBe)" as="xs:boolean" />
                     <xsl:if test="$checkOne or not($checkTwo)">
                        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-17">
                           <xsl:attribute name="test">(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))</xsl:attribute>
                           <svrl:text>[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                           <svrl:message-code>BR-CO-17</svrl:message-code>
                           <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                        </svrl:failed-assert>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>-->

               <xsl:variable name="taxAmount" select="xs:double(./cbc:TaxAmount)"/>
               <xsl:variable name="taxableAmount" select="xs:double(./cbc:TaxableAmount)"/>
               <xsl:variable name="vatCategoryRate" select="xs:double(./cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent)"/>
               <xsl:variable name="toleranceLimit" select="count(//cac:InvoiceLine) * 0.01" as="xs:float"/>
               <xsl:variable name="shouldBe" select="round(xs:double(format-number($taxableAmount * ($vatCategoryRate div 100), '0.00')) * 100) div 100"/>
               <xsl:variable name="upperLimit" select="round(($shouldBe + $toleranceLimit) * 100) div 100"/>
               <xsl:variable name="lowerLimit" select="round(($shouldBe - $toleranceLimit) * 100) div 100"/>
               <xsl:variable name="checkTwo" select="($taxAmount &lt;= $upperLimit and $taxAmount &gt;= $lowerLimit) or ($taxAmount = $shouldBe)" as="xs:boolean"/>
               <xsl:if test="not($checkTwo)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CO-17">
                     <xsl:attribute name="test">(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))</xsl:attribute>
                     <svrl:text>[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                     <svrl:message-code>BR-CO-17</svrl:message-code>
                     <svrl:message-category>Business rules - conditions (BR-CO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>

               <xsl:if test="not(string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-19">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-19</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-20">
                     <xsl:attribute name="test">string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2</xsl:attribute>
                     <svrl:text>[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-20</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="19" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and not(exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']])) or not( (xs:decimal(../cbc:TaxableAmount) =(sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount))  + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) )))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-E-08">
                     <xsl:attribute name="test">count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and (exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']])) or ((xs:decimal(../cbc:TaxableAmount) =(sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:LineExtensionAmount))  + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) )))</xsl:attribute>
                     <svrl:text>[BR-E-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</svrl:text>
                     <svrl:message-code>BR-E-08</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(xs:decimal(../cbc:TaxAmount) = 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-E-09">
                     <xsl:attribute name="test">xs:decimal(../cbc:TaxAmount) = 0</xsl:attribute>
                     <svrl:text>[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-09</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="18" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-E-06">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-06</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="17" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-E-05">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-E-05</svrl:message-code>
                     <svrl:message-category>Business rules - Exempted from VAT (BR-E)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="16" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']

                  </xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and not(exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']])) or not((xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-O-08">
                     <xsl:attribute name="test">count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and (exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']])) or (exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))</xsl:attribute>
                     <svrl:text>[BR-O-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</svrl:text>
                     <svrl:message-code>BR-O-08</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(xs:decimal(../cbc:TaxAmount) = 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-O-09">
                     <xsl:attribute name="test">xs:decimal(../cbc:TaxAmount) = 0</xsl:attribute>
                     <svrl:text>[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-O-09</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="13" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and not(exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']])) or not( sum((../../cac:TaxSubtotal[cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:TaxableAmount)))=(sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:LineExtensionAmount) )  + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-08">
                     <xsl:attribute name="test">count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and (exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'S']])) or ((xs:decimal(../cbc:TaxableAmount) =(sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:LineExtensionAmount))  + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) )))</xsl:attribute>
                     <svrl:text>[BR-S-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Standard rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Standard Rate".</svrl:text>
                     <svrl:message-code>BR-S-08</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <!--<xsl:variable name="taxableAmount" select="../cbc:TaxableAmount" as="xs:float"/>
               <xsl:variable name="taxAmount" select="../cbc:TaxAmount" as="xs:float"/>
               <xsl:variable name="toleranceLimit" select="count(//cac:InvoiceLine) * 0.01" as="xs:float"/>
               <xsl:variable name="vatCategoryRate" select="../cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:float(cbc:Percent)" as="xs:float"/>
               <xsl:variable name="shouldBe" select="(round(($taxableAmount * ($vatCategoryRate div 100))*100)) div 100" as="xs:float"/>
               <xsl:variable name="upperLimit" select="round(($shouldBe + $toleranceLimit)*100) div 100" as="xs:float" />
               <xsl:variable name="lowerLimit" select="round(($shouldBe - $toleranceLimit)*100) div 100"/>
               <xsl:variable name="checkOne" select="normalize-space(./cbc:Percent)=''" as="xs:boolean" />
               <xsl:variable name="checkTwo" select="($taxAmount &lt;= $upperLimit and $taxAmount &gt;= $lowerLimit or $taxAmount = $shouldBe)" as="xs:boolean" />
               <xsl:if test="$checkOne or not($checkTwo)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-09">
                     <xsl:attribute name="test">(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 &gt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )</xsl:attribute>
                     <svrl:text>[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                     <svrl:message-code>BR-S-09</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>-->
               <xsl:variable name="taxAmount" select="xs:double(../cbc:TaxAmount)"/>
               <xsl:variable name="taxableAmount" select="xs:double(../cbc:TaxableAmount)"/>
               <xsl:variable name="vatCategoryRate" select="xs:double(../cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent)"/>
               <xsl:variable name="toleranceLimit" select="count(//cac:InvoiceLine) * 0.01" as="xs:float"/>
               <xsl:variable name="shouldBe" select="round(xs:double(format-number($taxableAmount * ($vatCategoryRate div 100), '0.00')) * 100) div 100"/>
               <xsl:variable name="upperLimit" select="round(($shouldBe + $toleranceLimit) * 100) div 100"/>
               <xsl:variable name="lowerLimit" select="round(($shouldBe - $toleranceLimit) * 100) div 100"/>
               <xsl:variable name="checkOne" select="normalize-space(./cbc:Percent)=''" as="xs:boolean" />
               <xsl:variable name="checkTwo" select="($taxAmount &lt;= $upperLimit and $taxAmount &gt;= $lowerLimit) or ($taxAmount = $shouldBe)" as="xs:boolean"/>
               <xsl:if test="$checkOne or not($checkTwo)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-09">
                     <xsl:attribute name="test">(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))</xsl:attribute>
                     <svrl:text>[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
                     <svrl:message-code>BR-S-09</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID/text() = 'S') and (exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-10">
                     <xsl:attribute name="test">not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)</xsl:attribute>
                     <svrl:text>[BR-S-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
                     <svrl:message-code>BR-S-10</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="12" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:Percent) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-S-06">
                     <xsl:attribute name="test">(cbc:Percent) &gt; 0</xsl:attribute>
                     <svrl:text>[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</svrl:text>
                     <svrl:message-code>BR-S-06</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="12" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:Percent) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-07">
                     <xsl:attribute name="test">(cbc:Percent) &gt; 0</xsl:attribute>
                     <svrl:text>[BR-S-07]--In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.</svrl:text>
                     <svrl:message-code>BR-S-07</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="11" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and not(exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']])) or not( (xs:decimal(../cbc:TaxableAmount) =(sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount))  + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) )))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-Z-08">
                     <xsl:attribute name="test">count(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])&gt; 0 and (exists(../../../cac:AllowanceCharge/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']])) or ((xs:decimal(../cbc:TaxableAmount) =(sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:LineExtensionAmount))  + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S']/xs:decimal(cbc:Amount)) )))</xsl:attribute>
                     <svrl:text>[BR-Z-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero Rated".</svrl:text>
                     <svrl:message-code>BR-Z-08</svrl:message-code>
                     <svrl:message-category>Business rules - Not subject to VAT (BR-OO)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(xs:decimal(../cbc:TaxAmount) = 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-Z-09">
                     <xsl:attribute name="test">xs:decimal(../cbc:TaxAmount) = 0</xsl:attribute>
                     <svrl:text>[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-09</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="10" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-Z-06">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-06</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="9" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((xs:decimal(cbc:Percent) = 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-Z-05">
                     <xsl:attribute name="test">(xs:decimal(cbc:Percent) = 0)</xsl:attribute>
                     <svrl:text>[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
                     <svrl:message-code>BR-Z-05</svrl:message-code>
                     <svrl:message-category>Business rules - VAT zero rate (BR-Z)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl:Invoice/cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]" priority="8" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e353']">
            <schxslt:rule pattern="d7e353">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e353">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:DocumentCurrencyCode]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((string-length(substring-after(.,'.'))&lt;=2))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-13">
                     <xsl:attribute name="test">(string-length(substring-after(.,'.'))&lt;=2)</xsl:attribute>
                     <svrl:text>[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-13</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e353')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl:Invoice/cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]" priority="7" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e362']">
            <schxslt:rule pattern="d7e362">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e362">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:TaxTotal/cbc:TaxAmount[@currencyID = //cbc:TaxCurrencyCode]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((string-length(substring-after(.,'.'))&lt;=2))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-DEC-15">
                     <xsl:attribute name="test">(string-length(substring-after(.,'.'))&lt;=2)</xsl:attribute>
                     <svrl:text>[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</svrl:text>
                     <svrl:message-code>BR-DEC-15</svrl:message-code>
                     <svrl:message-category>Business rules - Decimals (BR-DEC)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e362')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" priority="6" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 381 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 396 420 458 532 ', concat(' ', normalize-space(.), ' '))))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CL-01">
                     <xsl:attribute name="test">(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 381 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))</xsl:attribute>
                     <svrl:text>[BR-CL-01]-The document type code MUST be coded by the invoice and credit note related code lists of UNTDID 1001.</svrl:text>
                     <svrl:message-code>BR-CL-01</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" priority="5" mode="d7e42">
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
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test=" string-length(@currencyID) &gt; 0 and not(((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CL-03">
                     <xsl:attribute name="test">((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-03]-currencyID MUST be coded using ISO code list 4217 alpha-3</svrl:text>
                     <svrl:message-code>BR-CL-03</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:DocumentCurrencyCode" priority="4" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cbc:DocumentCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:DocumentCurrencyCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:DocumentCurrencyCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CL-04">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-04]-Invoice currency code MUST be coded using ISO code list 4217 alpha-3</svrl:text>
                     <svrl:message-code>BR-CL-04</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:TaxCurrencyCode" priority="3" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cbc:TaxCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CL-05">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-05]-Tax currency code MUST be coded using ISO code list 4217 alpha-3</svrl:text>
                     <svrl:message-code>BR-CL-05</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:Country/cbc:IdentificationCode" priority="2" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:Country/cbc:IdentificationCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:Country/cbc:IdentificationCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:Country/cbc:IdentificationCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CL-14">
                     <xsl:attribute name="test">((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))</xsl:attribute>
                     <svrl:text>[BR-CL-14]-Country codes in an invoice MUST be coded using ISO code list 3166-1</svrl:text>
                     <svrl:message-code>BR-CL-14</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:PaymentMeans/cbc:PaymentMeansCode" priority="1" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">warning: Rule for context "cac:PaymentMeans/cbc:PaymentMeansCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:PaymentMeans/cbc:PaymentMeansCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:PaymentMeans/cbc:PaymentMeansCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-CL-16">
                     <xsl:attribute name="test">( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )</xsl:attribute>
                     <svrl:text>[BR-CL-16]-Payment means in an invoice MUST be coded using UNCL4461 code list</svrl:text>
                     <svrl:message-code>BR-CL-16</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice / cac:TaxTotal / cac:TaxSubtotal / cac:TaxCategory / cbc:ID | /ubl:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID | /ubl:Invoice / cac:AllowanceCharge / cac:TaxCategory / cbc:ID   | /ubl:Invoice / cac:InvoiceLine / cac:Item / cac:ClassifiedTaxCategory / cbc:ID" priority="0" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e371']">
            <schxslt:rule pattern="d7e371">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:ClassifiedTaxCategory/cbc:ID | cac:TaxSubtotal/cac:TaxCategory/cbc:ID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:ClassifiedTaxCategory/cbc:ID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e371">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="fatal">
                  <xsl:attribute name="context">cac:ClassifiedTaxCategory/cbc:ID | cac:TaxSubtotal/cac:TaxCategory/cbc:ID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="error" id="BR-CL-18">
                     <xsl:attribute name="test">( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )</xsl:attribute>
                     <svrl:text>[BR-CL-18]-Invoice tax categories MUST be coded using UNCL5305 code list.</svrl:text>
                     <svrl:message-code>BR-CL-18</svrl:message-code>
                     <svrl:message-category>Business rules - Code lists (BR-CL)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e371')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" priority="12" mode="d7e42">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd7e42']">
            <schxslt:rule pattern="d7e42">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">error: Rule for context "cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e42">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cbc:Percent) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}" flag="warning" id="BR-S-05">
                     <xsl:attribute name="test">(cbc:Percent) &gt; 0</xsl:attribute>
                     <svrl:text>[BR-S-05]-For invoice items (BG-25) in which the VAT category code of invoiced items (BT-151) is "Standard rated" the VAT rate of the invoiced item (BT-152) must be greater than zero.</svrl:text>
                     <svrl:message-code>BR-S-05</svrl:message-code>
                     <svrl:message-category>Business rules - VAT standard and reduced rate (BR-S)</svrl:message-category>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched" as="xs:string*" select="($schxslt:patterns-matched, 'd7e42')"/>
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