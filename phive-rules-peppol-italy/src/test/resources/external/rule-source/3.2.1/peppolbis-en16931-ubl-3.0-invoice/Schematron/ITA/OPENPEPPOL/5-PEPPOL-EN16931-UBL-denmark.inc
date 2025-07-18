  <pattern id="denmark-rules" xmlns="http://purl.oclc.org/dsdl/schematron">
    <let name="DKSupplierCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
    <let name="DKCustomerCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
    <!-- Document level -->
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK'] | ubl-invoice:Invoice[$DKSupplierCountry = 'DK']">
      <assert id="DK-R-002-NA" test="(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/text()) != '')" flag="warning">Danish suppliers MUST provide legal entity (CVR-number) (not applied in the Italian context).</assert>
      <assert id="DK-R-014-NA" test="not(((boolean(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))
							   and (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184'))
						)" flag="warning">For Danish Suppliers it is mandatory to specify schemeID as "0184" (DK CVR-number) when PartyLegalEntity/CompanyID is used for AccountingSupplierParty (not applied in the Italian context).</assert>
      <assert id="DK-R-016-NA" test="not((boolean(/ubl-creditnote:CreditNote) and ($DKCustomerCountry = 'DK'))
						and (number(cac:LegalMonetaryTotal/cbc:PayableAmount/text()) &lt; 0)
						)" flag="warning">For Danish Suppliers, a Credit note cannot have a negative total (PayableAmount) (not applied in the Italian context).</assert>
    </rule>
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
      <assert id="DK-R-013-NA" test="not((boolean(cbc:ID))
						 and (normalize-space(cbc:ID/@schemeID) = '')
						)" flag="warning">For Danish Suppliers it is mandatory to use schemeID when PartyIdentification/ID is used for AccountingCustomerParty or AccountingSupplierParty (not applied in the Italian context).</assert>
    </rule>
    <rule context="ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans">
      <assert id="DK-R-005-NA" test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))" flag="warning">For Danish suppliers the following Payment means codes are allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97 (not applied in the Italian context).</assert>
      <assert id="DK-R-006-NA" test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))
						and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))
						)" flag="warning">For Danish suppliers bank account and registration account is mandatory if payment means is 31 or 42 (not applied in the Italian context).</assert>
      <assert id="DK-R-007-NA" test="not((cbc:PaymentMeansCode = '49')
						and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '')
							   and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != ''))
						)" flag="warning">For Danish suppliers PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when payment means is 49 (not applied in the Italian context).</assert>
      <assert id="DK-R-008-NA" test="not((cbc:PaymentMeansCode = '50')
						and not(((substring(cbc:PaymentID, 1, 3) = '01#')
								  or (substring(cbc:PaymentID, 1, 3) = '04#')
								  or (substring(cbc:PaymentID, 1, 3) = '15#'))
								and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 7)
								)
						)" flag="warning">For Danish Suppliers PaymentID is mandatory and MUST start with 01#, 04# or 15# (kortartkode), and PayeeFinancialAccount/ID (Giro kontonummer) is mandatory and must be 7 characters long, when payment means equals 50 (Giro) (not applied in the Italian context).</assert>
      <assert id="DK-R-009-NA" test="not((cbc:PaymentMeansCode = '50')
						and ((substring(cbc:PaymentID, 1, 3) = '04#')
							  or (substring(cbc:PaymentID, 1, 3)  = '15#'))
						and not(string-length(cbc:PaymentID) = 19)
						)" flag="warning">For Danish Suppliers if the PaymentID is prefixed with 04# or 15# the 16 digits instruction Id must be added to the PaymentID eg. "04#1234567890123456" when Payment means equals 50 (Giro) (not applied in the Italian context).</assert>
      <assert id="DK-R-010-NA" test="not((cbc:PaymentMeansCode = '93')
						and not(((substring(cbc:PaymentID, 1, 3) = '71#')
								  or (substring(cbc:PaymentID, 1, 3) = '73#')
								  or (substring(cbc:PaymentID, 1, 3) = '75#'))
								and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8)
								)
						)" flag="warning">For Danish Suppliers the PaymentID is mandatory and MUST start with 71#, 73# or 75# (kortartkode) and PayeeFinancialAccount/ID (Kreditornummer) is mandatory and must be exactly 8 characters long, when Payment means equals 93 (FIK) (not applied in the Italian context).</assert>
      <assert id="DK-R-011-NA" test="not((cbc:PaymentMeansCode = '93')
						and ((substring(cbc:PaymentID, 1, 3) = '71#')
							  or (substring(cbc:PaymentID, 1, 3)  = '75#'))
						and not((string-length(cbc:PaymentID) = 18)
							  or (string-length(cbc:PaymentID) = 19))
						)" flag="warning">For Danish Suppliers if the PaymentID is prefixed with 71# or 75# the 15-16 digits instruction Id must be added to the PaymentID eg. "71#1234567890123456" when payment Method equals 93 (FIK) (not applied in the Italian context).</assert>
    </rule>
    <!-- Line level -->
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:CreditNoteLine | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:InvoiceLine">
      <assert id="DK-R-003-NA" test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST')
						and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01')
							   or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501')
							   )
						)" flag="warning">If ItemClassification is provided from Danish suppliers, UNSPSC version 19.0501 should be used. (not applied in the Italian context).</assert>
    </rule>
    <!-- Mix level -->
    <rule context="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']">
      <assert id="DK-R-004-NA" test="not((cbc:AllowanceChargeReasonCode = 'ZZZ')
						and not((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4)
								and (number(cbc:AllowanceChargeReason) &gt;= 0)
								and (number(cbc:AllowanceChargeReason) &lt;= 9999))
						)" flag="warning">When specifying non-VAT Taxes for Danish customers, Danish suppliers MUST use the AllowanceChargeReasonCode="ZZZ" and the 4-digit Tax category MUST be specified in AllowanceChargeReason (not applied in the Italian context).</assert>
    </rule>
  </pattern>