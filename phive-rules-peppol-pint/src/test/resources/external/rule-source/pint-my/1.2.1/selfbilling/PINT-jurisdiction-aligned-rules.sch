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
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="aligned-ibrp-001-my" flag="fatal" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:selfbilling-1@my-1')">[aligned-ibrp-001-my]-Specification identifier (ibt-024) MUST start with the value 'urn:peppol:pint:selfbilling-1@my-1'.</assert>
      <assert id="aligned-ibrp-002" flag="fatal" test="/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:selfbilling')">[aligned-ibrp-002]-Business process (ibt-023) MUST be in the format 'urn:peppol:bis:selfbilling'.</assert>
      <assert id="ibr-02-my" flag="fatal" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">[ibr-02-my]-An Invoice shall have the Supplier’s Registration / Identification Number / Passport Number  (ibt-030).</assert>
      <assert id="ibr-03-my" flag="fatal" test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">[ibr-03-my]-An Invoice shall have the Buyer's Registration / Identification Number / Passport Number  (ibt-047).</assert>
      <assert id="ibr-04-my" flag="fatal" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID != 'VAT']/cbc:CompanyID)">[ibr-04-my]-An Invoice shall have the Supplier’s TIN (ibt-032).</assert>
    </rule>
    <rule context="cac:TaxSubtotal">
      <assert id="aligned-ibrp-046" flag="fatal" test="exists(cbc:TaxAmount)">[aligned-ibrp-046]-Each tax breakdown (ibg-23) MUST have a tax category tax amount (ibt-117).</assert>
      <assert id="aligned-ibrp-047" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">[aligned-ibrp-047]-Each tax breakdown (ibg-23) MUST be defined through a tax category code (ibt-118).</assert>
      <assert id="aligned-ibrp-048" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')">[aligned-ibrp-048]-Each tax breakdown (ibg-23) MUST have a tax category rate (ibt-119), except if the Invoice is not subject to tax.</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'T'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-t-08" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'T'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='T'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='T'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='T'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='T'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'T'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='T'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='T'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='T'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='T'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),0.02))))">[aligned-ibrp-t-08]-For each different value of tax category rate (ibt-119) where the tax category code (ibt-118) is "Standard rated", the tax category taxable amount (ibt-116) in a tax breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the tax category code (ibt-151, ibt-102, ibt-95) is "Standard rated" and the tax rate (ibt-152, ibt-103, ibt-96) equals the tax category rate (ibt-119).</assert>
      <assert id="aligned-ibrp-t-09" flag="fatal" test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ,0.02 )">[aligned-ibrp-t-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "Standard rated" MUST equal the tax category taxable amount (ibt-116) multiplied by the tax category rate (ibt-119).</assert>
      <assert id="aligned-ibrp-t-10" flag="fatal" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[aligned-ibrp-t-10]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "Standard rate" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</assert>
    </rule>
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-e-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">[aligned-ibrp-e-08]-In a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Exempt from tax" the tax category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-92) plus the sum of Document level charge amounts (ibt-99) where the tax category codes (ibt-151, ibt-95, ibt-102) are "Exempt from tax".</assert>
      <assert id="aligned-ibrp-e-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[aligned-ibrp-e-09]-The tax category tax amount (ibt-117) In a tax breakdown (ibg-23) where the tax category code (ibt-118) equals "Exempt from tax" MUST equal 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-e-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[aligned-ibrp-e-05]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Exempt from tax", the Invoiced item tax rate (ibt-152) MUST be 0 (zero). </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="aligned-ibrp-o-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[aligned-ibrp-o-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Not subject to tax" MUST be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern id="Codesmodelaligned">
    <rule flag="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
      <assert id="aligned-ibrp-cl-01-my" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' SA SE HVG LVG T E O ',concat(' ',normalize-space(.),' ') ) ) )">[aligned-ibrp-cl-01-my]-Malaysian invoice tax categories MUST be coded using Malaysian codes.</assert>
    </rule>
    <rule flag="fatal" context="cbc:TaxCurrencyCode">
      <assert id="ibr-cl-05-my" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' MYR ',concat(' ',normalize-space(.),' ') ) ) )">[ibr-cl-05-my]-If Tax accounting currency (ibt-006) is present, it shall be coded using MYR in ISO code list of 4217.</assert>
    </rule>
  </pattern>
</schema>