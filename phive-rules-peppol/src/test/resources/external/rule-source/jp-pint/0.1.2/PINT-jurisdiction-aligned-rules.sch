<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
    <xsl:param name="exp" as="xs:decimal"/>
    <xsl:param name="val" as="xs:decimal"/>
    <xsl:param name="slack" as="xs:decimal"/>
    <xsl:value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
  </xsl:function>
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="u" uri="utils"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <phase id="PINTmodelaligned_phase">
    <active pattern="UBL-modelaligned"/>
  </phase>
  <phase id="codelistaligned_phase">
    <active pattern="Codesmodelaligned"/>
  </phase>
  <pattern id="UBL-modelaligned">
    <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="aligned-ibrp-032-jp" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent)">[aligned-ibrp-032jp]-Each Document level allowance (ibg-20) MUST have a Document level allowance tax category code (ibt-095) and Document level allowance tax rate (ibt-096).</assert>
    </rule>
    <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="aligned-ibrp-037-jp" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent)">[aligned-ibrp-037-jp]-Each Document level charge (ibg-21) MUST have a Document level charge tax category code (ibt-102) and Document level charge tax rate (ibt-103).</assert>
    </rule>
    <rule context="/ubl:InvoiceLine | /cn:CreditNoteLine">
      <assert id="aligned-ibrp-050-jp" flag="fatal" test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID) and (cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:Percent)">[aligned-ibrp-050-jp]-Each Invoice line (ibg-25) MUST be categorized with an Invoiced item tax category code (ibt-151) and Invoiced item tax rate (ibt-152).</assert>
    </rule>
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="aligned-ibrp-001-jp" flag="fatal" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:fdc:peppol:jp:billing:3.0')">[aligned-ibrp-001-jp]-Specification identifier MUST start with the value 'urn:fdc:peppol:jp:billing:3.0'.</assert>
      <assert id="aligned-ibrp-002-jp" flag="fatal" test="/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0')">[aligned-ibrp-002-jp]-Business process MUST be in the format 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0'.</assert>
      <assert id="aligned-ibrp-008" flag="fatal" test="(count(cac:PaymentTerms/cbc:Note) &lt;= 1)">[aligned-ibrp-008]-Payment terms (ibt-020) MUST occur maximum once.</assert>
      <assert id="aligned-ibrp-009" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">[aligned-ibrp-009]-Seller tax identifier (ibt-031) MUST occur maximum once.</assert>
      <assert id="aligned-ibrp-014" flag="fatal" test="count(//cbc:PaymentID[not(preceding::cbc:PaymentID/. = .)]) &lt;= 1">[aligned-ibrp-014]-Remittance information (ibt-083) MUST occur maximum once.</assert>
      <assert id="aligned-ibrp-052" flag="fatal" test="exists(//cac:InvoicePeriod)">[aligned-ibrp-052]-An Invoice MUST have an invoice period (ibg-14) or an Invoice line period (ibg-26).</assert>
      <assert id="aligned-ibrp-e-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))">[aligned-ibrp-e-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-95 or ibt-102) is "Exempt from tax" MUST contain exactly one tax breakdown (ibg-23) with the tax category code (ibt-118) equal to "Exempt from tax".</assert>
      <assert id="aligned-ibrp-g-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))">[aligned-ibrp-g-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-95 or ibt-102) is "Export" MUST contain in the tax breakdown (ibg-23) exactly one tax category code (ibt-118) equal with "Export".</assert>
      <assert id="aligned-ibrp-o-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">[aligned-ibrp-o-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-95 or ibt-102) is "Not subject to tax" MUST contain exactly one tax breakdown group (ibg-23) with the tax category code (ibt-118) equal to "Not subject to tax".</assert>
      <assert id="aligned-ibrp-sr-12" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">[aligned-ibrp-sr-12]-Seller VAT identifier (ibt-031) MUST occur maximum once</assert>
      <assert id="aligned-ibrp-sr-13" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='VAT']/cbc:CompanyID) &lt;= 1)">[aligned-ibrp-sr-13]-Seller tax registration (ibt-032) MUST occur maximum once</assert>
      <assert id="aligned-ibr-jp-04" flag="fatal" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)">[aligned-ibr-jp-04]-An Invoice shall have the Seller tax identifier (ibt-031).</assert>
      <assert id="aligned-ibr-jp-05" flag="fatal" test="not(exists(cbc:TaxCurrencyCode)) or cbc:TaxCurrencyCode = 'JPY'">[aligned-ibr-jp-05]-If Tax accounting currency (ibt-006) is present, it shall be coded using JPY in ISO code list of 4217 a-3.</assert>
    </rule>
    <rule context="cac:TaxSubtotal[cbc:TaxAmount/@currencyID=/ubl:Invoice/cbc:DocumentCurrencyCode/text()]">
      <assert id="aligned-ibrp-045" flag="fatal" test="exists(cbc:TaxableAmount)">[aligned-ibrp-045]-Each tax breakdown (ibg-23) MUST have a tax category taxable amount (ibt-116).</assert>
      <assert id="aligned-ibrp-051-jp" flag="fatal" test="((cac:TaxCategory/normalize-space(upper-case(cbc:ID)) != 'O') and ((round(cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and ( xs:decimal(cbc:TaxAmount) &gt;= floor(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100))) and ( xs:decimal(cbc:TaxAmount) &lt;= ceiling(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))) or (round(cac:TaxCategory/xs:decimal(cbc:Percent)) = 0 and (xs:decimal(cbc:TaxAmount) = 0)))) or (not(cac:TaxCategory/cbc:Percent) and (cac:TaxCategory/normalize-space(upper-case(cbc:ID)) = 'O') and  (xs:decimal(cbc:TaxAmount) = 0))">[aligned-ibrp-051-jp]-Tax category tax amount (ibt-117) = tax category taxable amount (ibt-116) x (tax category rate (ibt-119) / 100), rounded to integer. The rounded result amount shall be between the floor and the ceiling.</assert>
    </rule>
    <rule context="cac:TaxSubtotal">
      <assert id="aligned-ibrp-046" flag="fatal" test="exists(cbc:TaxAmount)">[aligned-ibrp-046]-Each tax breakdown (ibg-23) MUST have a tax category tax amount (ibt-117).</assert>
      <assert id="aligned-ibrp-047" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">[aligned-ibrp-047]-Each tax breakdown (ibg-23) MUST be defined through a tax category code (ibt-118).</assert>
      <assert id="aligned-ibrp-048" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')">[aligned-ibrp-048]-Each tax breakdown (ibg-23) MUST have a tax category rate (ibt-119), except if the Invoice is not subject to tax.</assert>
      <assert id="aligned-ibr-jp-06" flag="fatal" test="not(contains(cbc:TaxAmount[@currencyID='JPY'], '.'))">[aligned-ibr-jp-06]-Tax category tax amount (ibt-117) with currency code JPY and tax category tax amount in accounting currency (ibt-190) shall not have decimal.</assert>
    </rule>
    <rule context="cac:TaxRepresentativeParty">
      <assert id="aligned-ibrp-010" flag="fatal" test="(count(cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)">[aligned-ibrp-010]-Seller tax representative tax identifier (ibt-063) MUST occur maximum once, if the Seller has a tax representative (ibg-11).</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount">
      <assert id="aligned-ibrp-016" flag="fatal" test="(cbc:ID) != ''">[aligned-ibrp-016]-A Payment account identifier (ibt-84) MUST be present if Credit transfer (ibg-17) information is provided in the invoice.</assert>
    </rule>
    <rule context="cac:PaymentMeans/cac:CardAccount">
      <assert id="aligned-ibrp-017" flag="fatal" test="string-length(cbc:PrimaryAccountNumberID)&gt;=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6">[aligned-ibrp-017]-The last 4 to 6 digits of the Payment card primary account number (ibt-87) MUST be present if Payment card information (ibg-18) is provided in the Invoice.</assert>
    </rule>
    <rule context="cac:PaymentMeans">
      <assert id="aligned-ibrp-049" flag="fatal" test="exists(cbc:PaymentMeansCode)">[aligned-ibrp-049]-A Payment instruction (ibg-16) MUST specify the Payment means type code (ibt-81).</assert>
    </rule>
    <rule context="cac:PaymentMeans[(cbc:PaymentMeansCode='49' or cbc:PaymentMeansCode='59')]">
      <assert id="aligned-ibrp-019" flag="fatal" test="cac:PaymentMandate/cbc:ID">[aligned-ibrp-019]-Mandate reference (ibt-089) MUST be provided for direct debit.</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-e-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-e-05]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Exempt from tax", the Invoiced item tax rate (ibt-152) MUST be 0 (zero). </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-e-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-e-06]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-95) is "Exempt from tax", the Document level allowance tax rate (ibt-96) MUST be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-e-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-e-07]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Exempt from tax", the Document level charge tax rate (ibt-103) MUST be 0 (zero).</assert>
    </rule>
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-e-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[aligned-ibrp-e-09]-The tax category tax amount (ibt-117) In a tax breakdown (ibg-23) where the tax category code (ibt-118) equals "Exempt from tax" MUST equal 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-g-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-g-05]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Export" the Invoiced item tax rate (ibt-152) MUST be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-g-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-g-06]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-95) is "Export" the Document level allowance tax rate (ibt-96) MUST be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-g-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-g-07]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Export" the Document level charge tax rate (ibt-103) MUST be 0 (zero).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-g-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[aligned-ibrp-g-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Export" MUST be 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-o-05" flag="fatal" test="not(cbc:Percent)">[aligned-ibrp-o-05]-An Invoice line (ibg-25) where the tax category code (ibt-151) is "Not subject to tax" MUST not contain an Invoiced item tax rate (ibt-152).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-o-06" flag="fatal" test="not(cbc:Percent)">[aligned-ibrp-o-06]-A Document level allowance (ibg-20) where tax category code (ibt-95) is "Not subject to tax" MUST not contain a Document level allowance tax rate (ibt-96).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-o-07" flag="fatal" test="not(cbc:Percent)">[aligned-ibrp-o-07]-A Document level charge (ibg-21) where the tax category code (ibt-102) is "Not subject to tax" MUST not contain a Document level charge tax rate (ibt-103).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-o-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[aligned-ibrp-o-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Not subject to tax" MUST be 0 (zero).</assert>
    </rule>
    <rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibr-jp-01" flag="fatal" test="(((//cbc:StartDate &gt;= '2023-10-01') or (//cbc:EndDate &gt;= '2023-10-01'))  and matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')) or not((//cbc:StartDate &gt;= '2023-10-01') or (//cbc:EndDate &gt;= '2023-10-01'))">[aligned-ibr-jp-01]-If a date of an invoice period (ibg-14) or an invoice line period (ibg-26) is on and after October 1st 2023, Seller Tax Identifier shall be coded by using a Registration Number for Qualified Invoice purpose in Japan, which consists of 14 digits that start with T.</assert>
    </rule>
    <rule context="cac:TaxCategory/cac:TaxScheme/cbc:ID | cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID">
      <assert id="aligned-ibr-jp-03" flag="fatal" test="matches(normalize-space(.),'VAT')">[aligned-ibr-jp-03]-Tax scheme shall use VAT from UNECE 5153 code list. VAT means Consumption Tax in Japan.</assert>
    </rule>
  </pattern>
  <pattern id="Codesmodelaligned">
    <rule flag="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
      <assert id="aligned-ibrp-cl-01-jp" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E S G O ',concat(' ',normalize-space(.),' ') ) ) )">[aligned-ibrp-cl-01-jp]-Japanese invoice tax categories MUST be coded using UNCL5305 code list.</assert>
    </rule>
  </pattern>
</schema>