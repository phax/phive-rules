<pattern id="OP-Denmark-rules" xmlns="http://purl.oclc.org/dsdl/schematron">
<let name="DKSupplierCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)" />
    <let name="DKCustomerCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)" />
    <!-- Document level -->
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK'] | ubl-invoice:Invoice[$DKSupplierCountry = 'DK']">
      <assert id="DK-R-002" test="(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/text()) != '')" flag="fatal">[DK-R-002]-Danish suppliers MUST provide legal entity (CVR-number)</assert>
      <assert id="DK-R-014" test="not(((boolean(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))
							   and (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184'))
						)" flag="fatal">[DK-R-014]-For Danish Suppliers it is mandatory to specify schemeID as "0184" (DK CVR-number) when PartyLegalEntity/CompanyID is used for AccountingSupplierParty</assert>
      <assert id="DK-R-016" test="not((boolean(/ubl-creditnote:CreditNote) and ($DKCustomerCountry = 'DK'))
						and (number(cac:LegalMonetaryTotal/cbc:PayableAmount/text()) &lt; 0)
						)" flag="fatal">[DK-R-016]-For Danish Suppliers, a Credit note cannot have a negative total (PayableAmount)</assert>
    </rule>
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
      <assert id="DK-R-013" test="not((boolean(cbc:ID))
						 and (normalize-space(cbc:ID/@schemeID) = '')
						)" flag="fatal">[DK-R-013]-For Danish Suppliers it is mandatory to use schemeID when PartyIdentification/ID is used for AccountingCustomerParty or AccountingSupplierParty</assert>
    </rule>
    <rule context="ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans">
      <assert id="DK-R-005" test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))" flag="fatal">[DK-R-005]-For Danish suppliers the following Payment means codes are allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97</assert>
      <assert id="DK-R-006" test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))
						and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))
						)" flag="fatal">[DK-R-006]-For Danish suppliers bank account and registration account is mandatory if payment means is 31 or 42</assert>
      <assert id="DK-R-007" test="not((cbc:PaymentMeansCode = '49')
						and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '')
							   and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != ''))
						)" flag="fatal">[DK-R-007]-For Danish suppliers PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when payment means is 49</assert>
      <assert id="DK-R-008" test="not((cbc:PaymentMeansCode = '50')
						and not(((substring(cbc:PaymentID, 1, 3) = '01#')
								  or (substring(cbc:PaymentID, 1, 3) = '04#')
								  or (substring(cbc:PaymentID, 1, 3) = '15#'))
								and matches(cac:PayeeFinancialAccount/cbc:ID, '^[0-9]{7,8}$')
								)
						)" flag="fatal">[DK-R-008]-For Danish Suppliers PaymentID is mandatory and MUST start with 01#, 04# or 15# (kortartkode), and PayeeFinancialAccount/ID (Giro kontonummer) is mandatory and must be 7 or 8 numerical characters long, when payment means equals 50 (Giro)</assert>
      <assert id="DK-R-009" test="not((cbc:PaymentMeansCode = '50')
						and ((substring(cbc:PaymentID, 1, 3) = '04#')
							  or (substring(cbc:PaymentID, 1, 3)  = '15#'))
						and not(string-length(cbc:PaymentID) = 19)
						)" flag="fatal">[DK-R-009]-For Danish Suppliers if the PaymentID is prefixed with 04# or 15# the 16 digits instruction Id must be added to the PaymentID eg. "04#1234567890123456" when Payment means equals 50 (Giro)</assert>
      <assert id="DK-R-010" test="not((cbc:PaymentMeansCode = '93')
						and not(((substring(cbc:PaymentID, 1, 3) = '71#')
								  or (substring(cbc:PaymentID, 1, 3) = '73#')
								  or (substring(cbc:PaymentID, 1, 3) = '75#'))
								and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8)
								)
						)" flag="fatal">[DK-R-010]-For Danish Suppliers using PaymentMeansCode 93, PaymentID is mandatory. The first three characters of the PaymentID MUST be 71#, 73# or 75# (kortartskode), and PayeeFinancialAccount/ID MUST be exactly 8 characters long.</assert>
      <assert id="DK-R-011" test="not((cbc:PaymentMeansCode = '93')
						and ((substring(cbc:PaymentID, 1, 3) = '71#')
							  or (substring(cbc:PaymentID, 1, 3)  = '75#'))
						and not((string-length(cbc:PaymentID) = 18)
							  or (string-length(cbc:PaymentID) = 19))
						)" flag="fatal">[DK-R-011]-For Danish Suppliers if the PaymentID is prefixed with 71# or 75# the 15-16 digits instruction Id must be added to the PaymentID eg. "71#1234567890123456" when payment Method equals 93 (FIK)</assert>
    </rule>
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party">
      <assert id="DK-R-017" test="not(((boolean(cac:PartyLegalEntity/cbc:CompanyID)) and (normalize-space(cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184')))" flag="fatal">[DK-R-017]-For Danish Customers it is mandatory to specify schemeID as "0184" (DK CVR-number) when PartyLegalEntity/CompanyID is used for AccountingCustomerParty</assert>
    </rule>
    <!-- Line level -->
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:CreditNoteLine | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:InvoiceLine">
      <assert id="DK-R-003" test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST')
						and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01')
							   or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501')
                               or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.08.01')
                               or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.0801')
							   )
						)" flag="fatal">[DK-R-003]-If ItemClassification is provided from Danish suppliers, UNSPSC version 19.05.01 or 26.08.01 should be used.</assert>
    </rule>
    <!-- Mix level -->
    <rule context="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']">
      <assert id="DK-R-004" test="not((cbc:AllowanceChargeReasonCode = 'ZZZ')
						and not(((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4)
								and (number(cbc:AllowanceChargeReason) &gt;= 0)
								and (number(cbc:AllowanceChargeReason) &lt;= 9999)) or
								(((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#')
                                  and not(starts-with(cbc:AllowanceChargeReason, '#'))
                                  and not(ends-with(cbc:AllowanceChargeReason, '#')))) )
                               )
				 )" flag="fatal">[DK-R-004]-When specifying non-VAT Taxes for Danish customers, Danish suppliers MUST use the AllowanceChargeReasonCode="ZZZ" and MUST be specified in AllowanceChargeReason; Either as the 4-digit Tax category or must include a #, but the # is not allowed as first and last character</assert>
    </rule>
</pattern>
