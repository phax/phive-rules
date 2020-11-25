<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Modified 6.11.2012 10:46 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" version="4.01" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<!-- InvoiceDetails/DefinitionDetails -tietojen tulostuspaikan valinta: 1=yl�s, 2=alas-->
	<xsl:variable name="InvoiceDetails_DefinitionDetails_paikka" select="1"/>
	<!-- Tekstit alkavat -->
	<xsl:variable name="txtINVOICE">INVOICE</xsl:variable>
	<xsl:variable name="txtCREDITNOTE">CREDIT NOTE</xsl:variable>
	<xsl:variable name="txtDIRECTPAYMENT">DIRECT PAYMENT</xsl:variable>
	<xsl:variable name="txtCONFIDENTIAL">CONFIDENTIAL</xsl:variable>
	<xsl:variable name="txtCOPY">COPY</xsl:variable>
	<xsl:variable name="txtCANCEL">CANCELLATION</xsl:variable>
	<xsl:variable name="txtSeller">Seller</xsl:variable>
	<xsl:variable name="txtTaxCode">VAT number</xsl:variable>
	<xsl:variable name="txtBuyerOrganisationName">Buyer</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientContact">Invoice recipient information</xsl:variable>
	<xsl:variable name="txtInvoiceDate">Invoice date</xsl:variable>
	<xsl:variable name="txtInvoiceNumber">Invoice No.</xsl:variable>
	<xsl:variable name="txtSellerReferenceIdentifier">Seller order No.</xsl:variable>
	<xsl:variable name="txtOrderIdentifier">Order No.</xsl:variable>
	<xsl:variable name="txtAgreement">Contract</xsl:variable>
	<xsl:variable name="txtAgreementDate">Contract date</xsl:variable>
	<xsl:variable name="txtPartyIdentifier">Business ID</xsl:variable>
	<xsl:variable name="txtInvoiceDueDate">Due date</xsl:variable>
	<xsl:variable name="txtEpiInstructedAmount">Payable</xsl:variable>
	<xsl:variable name="txtEpiAccountID">IBAN</xsl:variable>
	<xsl:variable name="txtEpiNameAddressDetails">Recipient name</xsl:variable>
	<xsl:variable name="txtEpiRemittanceInfoIdentifier">Reference number</xsl:variable>
	<xsl:variable name="txtEpiPaymentInstructionId">Payment instruction</xsl:variable>
	<xsl:variable name="txtPaymentStatusCode">Payment status</xsl:variable>
	<xsl:variable name="txtPaymentMethodText">Payment method</xsl:variable>
	<xsl:variable name="txtPaymentTermsFreeText">Payment terms</xsl:variable>
	<xsl:variable name="txtPaymentOverDueFineDetails">Delay information</xsl:variable>
	<xsl:variable name="txtPaymentOverDueFine">Delay penalty interest</xsl:variable>
	<xsl:variable name="txtDeliveryParty">Delivery address</xsl:variable>
	<xsl:variable name="txtDeliveryDate">Delivery date</xsl:variable>
	<xsl:variable name="txtDeliveryPeriodDetails">Period</xsl:variable>
	<xsl:variable name="txtDeliveryMethod">Delivery method</xsl:variable>
	<xsl:variable name="txtDeliveryTerms">Delivery terms</xsl:variable>
	<xsl:variable name="txtModeOfTransportIdentifier">Delivery method</xsl:variable>
	<xsl:variable name="txtTerminalAddress">Destination</xsl:variable>
	<xsl:variable name="txtWaybillIdentifier">Consignment note</xsl:variable>
	<xsl:variable name="txtWaybillMaker">Freight note writer</xsl:variable>
	<xsl:variable name="txtWaybillTypeCode">Freight note type</xsl:variable>
	<xsl:variable name="txtTransportInformationDate">Freight date</xsl:variable>
	<xsl:variable name="txtPaymentStatusNotPaid">Outstanding</xsl:variable>
	<xsl:variable name="txtPaymentStatusPartlyPaid">Partly paid</xsl:variable>
	<xsl:variable name="txtPaymentStatusPaid">Paid</xsl:variable>
	<xsl:variable name="txtArticleName">Description</xsl:variable>
	<xsl:variable name="txtRowIdentifier">Buyer order No.</xsl:variable>
	<xsl:variable name="txtRowIdentifierDate">Order date</xsl:variable>
	<xsl:variable name="txtArticleIdentifier">Product code</xsl:variable>
	<xsl:variable name="txtBuyerArticleIdentifier">Buyer product code</xsl:variable>
	<xsl:variable name="txtRowQuotationIdentifier">Quotation reference</xsl:variable>
	<xsl:variable name="txtDeliveredQuantity">Quantity delivered</xsl:variable>
	<xsl:variable name="txtOrderedQuantity">Quantity ordered</xsl:variable>
	<xsl:variable name="txtConfirmedQuantity">Quantity confirmed </xsl:variable>
	<xsl:variable name="txtUnitPriceAmount">Vat excluded unit price</xsl:variable>
	<xsl:variable name="txtUnitPriceAndAmount">Vat excluded unit price and amount</xsl:variable>
	<xsl:variable name="txtUnitPriceVatIncludedAmount">Vat included unit price</xsl:variable>
	<xsl:variable name="txtRowDeliveryDates">Delivery date (delivered)</xsl:variable>
	<xsl:variable name="txtRowDeliveryIdentifier">Delivery No.</xsl:variable>
	<xsl:variable name="txtRowDiscount">Discount</xsl:variable>
	<xsl:variable name="txtVat">Vat</xsl:variable>
	<xsl:variable name="txtVatAmount">Vat amount</xsl:variable>
	<xsl:variable name="txtVatExcludedAmount">Vat excluded</xsl:variable>
	<xsl:variable name="txtRowAmount">Total</xsl:variable>
	<xsl:variable name="txtRowOtherCurrencyAmount">Source amount total</xsl:variable>
	<xsl:variable name="txtINVOICETOTAL">INVOICE TOTAL</xsl:variable>
	<xsl:variable name="txtVatSpecification">Vat specification</xsl:variable>
	<xsl:variable name="txtShortProposedAccountIdentifier">Proposed account coding </xsl:variable>
	<xsl:variable name="txtNormalProposedAccountIdentifier">Proposed account coding </xsl:variable>
	<xsl:variable name="txtAccountDimension">Reporting Code</xsl:variable>
	<xsl:variable name="txtVirtualBankBarcode">Virtual bank bar code</xsl:variable>
	<xsl:variable name="txtPartialPaymentDetails">Partial payment instalment</xsl:variable>
	<xsl:variable name="txtPaidAmount">Paid amount</xsl:variable>
	<xsl:variable name="txtUnPaidAmount">Unpaid amount</xsl:variable>
	<xsl:variable name="txtInterestPercent">Interest rate</xsl:variable>
	<xsl:variable name="txtProsessingCostsAmount">Processing costs</xsl:variable>
	<xsl:variable name="txtPartialPaymentDueDate">Due date</xsl:variable>
	<xsl:variable name="txtVatIncludedAmount">Vat included amount</xsl:variable>
	<xsl:variable name="txtPartialPaymentReferenceIdentifier">Reference number</xsl:variable>
	<xsl:variable name="txtPhoneNumber">Phone</xsl:variable>
	<xsl:variable name="txtFaxNumber">Fax</xsl:variable>
	<xsl:variable name="txtWebaddressIdentifier">Web address</xsl:variable>
	<xsl:variable name="txtEmailaddressIdentifier">Email</xsl:variable>
	<xsl:variable name="txtHomeTownName">Home town</xsl:variable>
	<xsl:variable name="txtEur">euro</xsl:variable>
	<xsl:variable name="txtLink">Link</xsl:variable>
	<xsl:variable name="txtAgreementIdentifier">Agreement </xsl:variable>
	<xsl:variable name="txtProposedAccountIdentifier">Proposed account coding</xsl:variable>
	<xsl:variable name="txtEpiBfiIdentifier">BIC</xsl:variable>
	<xsl:variable name="txtDeliverer">Deliverer</xsl:variable>
	<xsl:variable name="txtManufacturer">Manufacturer</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientAddress">Recipient address</xsl:variable>
	<xsl:variable name="txtCashDiscountDate">Cash discount date</xsl:variable>
	<xsl:variable name="txtCashDiscountPercent">%</xsl:variable>
	<xsl:variable name="txtBaseAmount">of</xsl:variable>
	<xsl:variable name="txtCashDiscountExlVat">Cash discount excl. VAT</xsl:variable>
	<xsl:variable name="txtCashDiscountVat">VAT included in cash discount</xsl:variable>
	<xsl:variable name="txtCashDiscountAmount">Cash discount amount</xsl:variable>
	<xsl:variable name="txtInvoiceSender">Invoice sender</xsl:variable>
	<xsl:variable name="txtOriginalInvoice">Original Invoice no.</xsl:variable>
	<xsl:variable name="txtPriceListIdentifier">Price list</xsl:variable>
	<xsl:variable name="txtRequestOfQuotationIdentifier">Quotation request identifier</xsl:variable>
	<xsl:variable name="txtDeliveryInfo">Delivery info</xsl:variable>
	<xsl:variable name="txtInvoicingPeriod">Period</xsl:variable>
	<xsl:variable name="txtOrdererName">Orderer </xsl:variable>
	<xsl:variable name="txtAgreementType">Agreement type</xsl:variable>
	<xsl:variable name="txtBuyersSellerId">Buyer's seller No.</xsl:variable>
	<xsl:variable name="txtSellersBuyerIdentifier">Customer No.</xsl:variable>
	<xsl:variable name="txtBuyerReference">Buyer reference</xsl:variable>
	<xsl:variable name="txtNotificationId">Notification identifier</xsl:variable>
	<xsl:variable name="txtNotificationDate">Notification date</xsl:variable>
	<xsl:variable name="txtRegNumberId">Registration number</xsl:variable>
	<xsl:variable name="txtProjectRefId">Project</xsl:variable>
	<xsl:variable name="txtCreditLimit">Credit limit</xsl:variable>
	<xsl:variable name="txtCreditInterest">Credit line interest rate</xsl:variable>
	<xsl:variable name="txtOperationLimit">Line amount</xsl:variable>
	<xsl:variable name="txtFactoringPartyName">Factoring company </xsl:variable>
	<xsl:variable name="txtFactoringFreeText">Factoring clause</xsl:variable>
	<xsl:variable name="txtSalesPersonName">Seller </xsl:variable>
	<xsl:variable name="txtAnyPartyOrgName">Name</xsl:variable>
	<xsl:variable name="txtAnyPartyOrgDep">Department</xsl:variable>
	<xsl:variable name="txtSiteCode">Site code</xsl:variable>
	<xsl:variable name="txtAddress">Address</xsl:variable>
	<xsl:variable name="txtAveragePrice">Average price</xsl:variable>
	<xsl:variable name="txtArticleGroupIdentifier">Product group</xsl:variable>
	<xsl:variable name="txtEanCode">EAN code</xsl:variable>
	<xsl:variable name="txtRegistrationNumberId">Registration number</xsl:variable>
	<xsl:variable name="txtSerialNumberId">Serial number</xsl:variable>
	<xsl:variable name="txtRowActionCode">Action code</xsl:variable>
	<xsl:variable name="txtClearanceId">Authorization for home clearance</xsl:variable>
	<xsl:variable name="txtDeliveryNoteId">Delivery note code</xsl:variable>
	<xsl:variable name="txtPlaceOfDischarge">Place of discharge</xsl:variable>
	<xsl:variable name="txtFinalDestination">Destination</xsl:variable>
	<xsl:variable name="txtManufacturerArticleId">Manufacturer's product code</xsl:variable>
	<xsl:variable name="txtManufacturerOrderId">Manufacturer's order reference</xsl:variable>
	<xsl:variable name="txtPackageLength">Length</xsl:variable>
	<xsl:variable name="txtPackageWidth">Width</xsl:variable>
	<xsl:variable name="txtPackageHeight">Hight</xsl:variable>
	<xsl:variable name="txtPackageWeight">Weight</xsl:variable>
	<xsl:variable name="txtPackageNetWeight">Net weight</xsl:variable>
	<xsl:variable name="txtPackageVolume">Volume</xsl:variable>
	<xsl:variable name="txtTransportCarriageQuantity">Transport carriage quantity</xsl:variable>
	<xsl:variable name="txtDiscounts">Discounts</xsl:variable>
	<xsl:variable name="txtInvoiceRow">Invoice row</xsl:variable>
	<xsl:variable name="txtRounding">Rounding</xsl:variable>
	<xsl:variable name="txtTargetCurrency">Target currency</xsl:variable>
	<xsl:variable name="txtExchangeRate">Exchange rate</xsl:variable>
	<xsl:variable name="txtExchangeDate">Rate date</xsl:variable>
	<xsl:variable name="txtOtherCurrencyAmountVatIncludedAmount">Source amount VAT inc.</xsl:variable>
	<xsl:variable name="txtShipmentOrg">Shipped by</xsl:variable>
	<xsl:variable name="txtSourceCurrency">Source currency</xsl:variable>
	<xsl:variable name="txtReducedAmount">Reduced amount</xsl:variable>
	<xsl:variable name="txtOfferedQuantity">Offered</xsl:variable>
	<xsl:variable name="txtPostDeliveredQuantity">Quantity delivered later</xsl:variable>
	<xsl:variable name="txtInvoicedQuantity">Quantity invoiced</xsl:variable>
	<xsl:variable name="txtRowUsedQuantity">Quantity used</xsl:variable>
	<xsl:variable name="txtRowPreviousMeterReadingDate">Previous meter reading date</xsl:variable>
	<xsl:variable name="txtRowLatestMeterReadingDate">Latest meter reading date</xsl:variable>
	<xsl:variable name="txtRowCalculatedQuantity">Quantity calculated</xsl:variable>
	<xsl:variable name="txtOriginalInvoiceIdentifier">Original invoice No.</xsl:variable>
	<xsl:variable name="txtOriginalInvoiceDate">Original invoice date</xsl:variable>
	<xsl:variable name="txtOriginalDueDate">Original due date</xsl:variable>
	<xsl:variable name="txtOriginalInvoiceTotalAmount">Original amount due</xsl:variable>
	<xsl:variable name="txtOriginalEpiRemittanceInfoIdentifier">Original invoice reference</xsl:variable>
	<xsl:variable name="txtPaidDate">Date of payment</xsl:variable>
	<xsl:variable name="txtCollectionDate">Collection date</xsl:variable>
	<xsl:variable name="txtCollectionQuantity">Number of collection attempts</xsl:variable>
	<xsl:variable name="txtCollectionChargeAmount">Collection charges</xsl:variable>
	<xsl:variable name="txtInterestRate">Penalty interest rate</xsl:variable>
	<xsl:variable name="txtInterestStartDate">Start date of interest</xsl:variable>
	<xsl:variable name="txtInterestEndDate">End date of interest</xsl:variable>
	<xsl:variable name="txtInterestPeriodText">Interest period</xsl:variable>
	<xsl:variable name="txtInterestDateNumber">Number of interest days</xsl:variable>
	<xsl:variable name="txtInterestChargeAmount">Interest</xsl:variable>
	<xsl:variable name="txtInterestChargeVatAmount">Amount of VAT included in interest</xsl:variable>
	<xsl:variable name="txtControllerIdentifier">Controller identifier</xsl:variable>
	<xsl:variable name="txtControllerName">Controller name</xsl:variable>
	<xsl:variable name="txtControlDate">Control date</xsl:variable>
	<xsl:variable name="txtContact">Contact information</xsl:variable>
	<xsl:variable name="txtFreeText">Messages</xsl:variable>
	<xsl:variable name="txtVatCode_AB">Exempt for resale</xsl:variable>
	<xsl:variable name="txtVatCode_AE">VAT Reverse Charge</xsl:variable>
	<xsl:variable name="txtVatCode_E">Exempt from tax</xsl:variable>
	<xsl:variable name="txtVatCode_G">Free export item, tax not charged</xsl:variable>
	<xsl:variable name="txtVatCode_O">Services outside scope of tax</xsl:variable>
	<xsl:variable name="txtVatCode_S">Standard rate</xsl:variable>
	<xsl:variable name="txtVatCode_Z">Zero rated goods</xsl:variable>
	<xsl:variable name="txtVatCode_ZEG">Tax charged from goods bought from other EU countries</xsl:variable>
	<xsl:variable name="txtVatCode_ZES">Tax charged from services bought from other EU countries</xsl:variable>
	<xsl:variable name="txtOrganisationUnitNumber">EDI-code</xsl:variable>
	<xsl:variable name="txtCountryOfOrigin">Country of origin</xsl:variable>
	<xsl:variable name="txtCountryOfDestinationName">Destination</xsl:variable>
	<xsl:variable name="txtOrderConfirmationIdentifier">Order confirmation</xsl:variable>
	<xsl:variable name="txtOrderConfirmationDate">Order confirmation date</xsl:variable>
	<xsl:variable name="txtInvoiceTotalVatAmount">Vat</xsl:variable>
	<xsl:variable name="txtOtherCurrencyAmountVatExcludedAmount">Source amount</xsl:variable>
	<xsl:variable name="txtMonthlyAmount">Installment</xsl:variable>
	<xsl:variable name="txtSellerAccountText">Seller accounting info</xsl:variable>
	<xsl:variable name="txtDiscountDetails">Discount details</xsl:variable>
	<xsl:variable name="txtPaidVatExcludedAmount">Paid amount vat excl.</xsl:variable>
	<xsl:variable name="txtUnPaidVatExcludedAmount">Unpaid amount vat excl.</xsl:variable>
	<xsl:variable name="txtFactoringAgreementIdentifier">Factoring agreement</xsl:variable>
	<xsl:variable name="txtTransmissionListIdentifier">Transmission list</xsl:variable>
	<xsl:variable name="txtCreditRequestedQuantity">Credit requested</xsl:variable>
	<xsl:variable name="txtReturnedQuantity">Returned</xsl:variable>
	<xsl:variable name="txtRowOrderPositionIdentifier">Orderposition</xsl:variable>
	<xsl:variable name="txtRowCustomsInfo">Customs info</xsl:variable>
	<xsl:variable name="txtCNCode">CN code</xsl:variable>
	<xsl:variable name="txtCNOriginCountryName">CN country of origin</xsl:variable>
	<xsl:variable name="txtControlStampText">Control stamp</xsl:variable>
	<xsl:variable name="txtAcceptanceStampText">Acceptance stamp</xsl:variable>
	<xsl:variable name="txtAttachments">The invoice has attachments.</xsl:variable>
	<!-- Tekstit loppuivat -->
	<xsl:template match="Finvoice">
		<html>
			<head>
				<link rel="stylesheet" type="text/css" href="Finvoice.css" />
				<title>
					<xsl:call-template name="OutputTitle">
						<xsl:with-param name="invoiceTypeText" select="InvoiceDetails/InvoiceTypeText"/>
						<xsl:with-param name="originCode" select="InvoiceDetails/OriginCode"/>
						<xsl:with-param name="originText" select="InvoiceDetails/OriginText"/>
					</xsl:call-template>
					<xsl:text> - </xsl:text>
					<xsl:value-of select="SellerPartyDetails/SellerOrganisationName"/>
					<xsl:text> - </xsl:text>
					<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/InvoiceDate"/></xsl:call-template>
				</title>
			</head>
			<body>
				<div class="InvoiceTypeText">
					<xsl:call-template name="OutputTitle">
						<xsl:with-param name="invoiceTypeText" select="InvoiceDetails/InvoiceTypeText"/>
						<xsl:with-param name="originCode" select="InvoiceDetails/OriginCode"/>
						<xsl:with-param name="originText" select="InvoiceDetails/OriginText"/>
					</xsl:call-template>
				</div>
				<table class="invoiceTop">
						<tbody>
							<tr>
								<td class="invoiceTopLeft">
									<div class="SellerPartyDetails">
										<div class="title"><xsl:value-of select="$txtSeller"/>:</div>
										<div class="data">
											<xsl:choose>
												<xsl:when test="string-length(SellerPartyDetails/SellerPartyIdentifierUrlText) != 0">
													<xsl:value-of select="$txtPartyIdentifier"/>:
													<xsl:call-template name="FormatLink">
														<xsl:with-param name="link" select="SellerPartyDetails/SellerPartyIdentifierUrlText"/>
														<xsl:with-param name="text" select="SellerPartyDetails/SellerPartyIdentifier"/>
													</xsl:call-template>
													<br/>
												</xsl:when>
												<xsl:when test="string-length(SellerPartyDetails/SellerPartyIdentifier) != 0">
													<xsl:value-of select="$txtPartyIdentifier"/>: <xsl:value-of select="SellerPartyDetails/SellerPartyIdentifier"/>
													<br/>
												</xsl:when>
											</xsl:choose>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="txtTitle" select="SellerPartyDetails/SellerCode/@IdentifierType"/>
												<xsl:with-param name="txtText" select="SellerPartyDetails/SellerCode"/>
											</xsl:call-template>
											<xsl:for-each select="SellerPartyDetails/SellerOrganisationName">
												<xsl:call-template name="OutputCurrentTextBR"/>
											</xsl:for-each>
											<xsl:for-each select="SellerPartyDetails/SellerOrganisationDepartment">
												<xsl:call-template name="OutputCurrentTextBR"/>
											</xsl:for-each>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtText" select="SellerPartyDetails/SellerPostalAddressDetails/SellerPostOfficeBoxIdentifier"/>
											</xsl:call-template>
											<xsl:for-each select="SellerPartyDetails/SellerPostalAddressDetails/SellerStreetName">
												<xsl:call-template name="OutputCurrentTextBR"/>
											</xsl:for-each>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtText">
													<xsl:call-template name="BuildString">
														<xsl:with-param name="txtText" select="SellerPartyDetails/SellerPostalAddressDetails/SellerPostCodeIdentifier"/>
														<xsl:with-param name="txtText2" select="SellerPartyDetails/SellerPostalAddressDetails/SellerTownName"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtText">
													<xsl:call-template name="BuildCountryString">
														<xsl:with-param name="theCountryCode" select="SellerPartyDetails/SellerPostalAddressDetails/CountryCode"/>
														<xsl:with-param name="theCountryName" select="SellerPartyDetails/SellerPostalAddressDetails/CountryName"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtTitle" select="$txtSiteCode"/>
												<xsl:with-param name="txtText" select="SellerSiteCode"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtText" select="SellerContactPersonName"/>
											</xsl:call-template>
											<xsl:for-each select="SellerContactPersonFunction">
												<xsl:call-template name="OutputCurrentTextBR"/>
											</xsl:for-each>
											<xsl:for-each select="SellerContactPersonDepartment">
												<xsl:call-template name="OutputCurrentTextBR"/>
											</xsl:for-each>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtTextCopy">
													<xsl:call-template name="FormatEmail">
														<xsl:with-param name="email" select="SellerCommunicationDetails/SellerEmailaddressIdentifier"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTextBR">
												<xsl:with-param name="txtText" select="SellerCommunicationDetails/SellerPhoneNumberIdentifier"/>
											</xsl:call-template>
										</div>
									</div>
									<xsl:variable name="irpDetails">
										<xsl:if test="count(InvoiceRecipientPartyDetails) != 0">
											<div class="InvoiceRecipientPartyDetails">
												<div class="data">
													<xsl:for-each select="InvoiceRecipientPartyDetails/InvoiceRecipientOrganisationName">
														<xsl:call-template name="OutputCurrentTextBR"/>
													</xsl:for-each>
													<xsl:for-each select="InvoiceRecipientPartyDetails/InvoiceRecipientDepartment">
														<xsl:call-template name="OutputCurrentTextBR">
															<xsl:with-param name="isNewVersion" select="'1'"/>
														</xsl:call-template>
													</xsl:for-each>
													<xsl:call-template name="OutputTextBR">
														<xsl:with-param name="txtText" select="InvoiceRecipientPartyDetails/InvoiceRecipientPostalAddressDetails/InvoiceRecipientPostOfficeBoxIdentifier"/>
													</xsl:call-template>
													<xsl:for-each select="InvoiceRecipientPartyDetails/InvoiceRecipientPostalAddressDetails/InvoiceRecipientStreetName">
														<xsl:call-template name="OutputCurrentTextBR"/>
													</xsl:for-each>
													<xsl:call-template name="OutputTextBR">
														<xsl:with-param name="txtText">
															<xsl:call-template name="BuildString">
																<xsl:with-param name="txtText" select="InvoiceRecipientPartyDetails/InvoiceRecipientPostalAddressDetails/InvoiceRecipientPostCodeIdentifier"/>
																<xsl:with-param name="txtText2" select="InvoiceRecipientPartyDetails/InvoiceRecipientPostalAddressDetails/InvoiceRecipientTownName"/>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:call-template name="OutputTextBR">
														<xsl:with-param name="txtText">
															<xsl:call-template name="BuildCountryString">
																<xsl:with-param name="theCountryCode" select="InvoiceRecipientPartyDetails/InvoiceRecipientPostalAddressDetails/CountryCode"/>
																<xsl:with-param name="theCountryName" select="InvoiceRecipientPartyDetails/InvoiceRecipientPostalAddressDetails/CountryName"/>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
												</div>
											</div>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="bpDetails">
										<div class="BuyerPartyDetails">
											<div class="title">
												<xsl:value-of select="$txtBuyerOrganisationName"/>:
											</div>
											<div class="data">
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="txtTitle" select="$txtPartyIdentifier"/>
													<xsl:with-param name="txtText" select="BuyerPartyDetails/BuyerPartyIdentifier"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="txtTitle" select="BuyerPartyDetails/BuyerCode/@IdentifierType"/>
													<xsl:with-param name="txtText" select="BuyerPartyDetails/BuyerCode"/>
												</xsl:call-template>
												<xsl:for-each select="BuyerPartyDetails/BuyerOrganisationName">
													<xsl:call-template name="OutputCurrentTextBR"/>
												</xsl:for-each>
												<xsl:for-each select="BuyerPartyDetails/BuyerOrganisationDepartment">
													<xsl:call-template name="OutputCurrentTextBR"/>
												</xsl:for-each>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtText" select="BuyerPartyDetails/BuyerPostalAddressDetails/BuyerPostOfficeBoxIdentifier"/>
												</xsl:call-template>
												<xsl:for-each select="BuyerPartyDetails/BuyerPostalAddressDetails/BuyerStreetName">
													<xsl:call-template name="OutputCurrentTextBR"/>
												</xsl:for-each>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtText">
														<xsl:call-template name="BuildString">
															<xsl:with-param name="txtText" select="BuyerPartyDetails/BuyerPostalAddressDetails/BuyerPostCodeIdentifier"/>
															<xsl:with-param name="txtText2" select="BuyerPartyDetails/BuyerPostalAddressDetails/BuyerTownName"/>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtText">
														<xsl:call-template name="BuildCountryString">
															<xsl:with-param name="theCountryCode" select="BuyerPartyDetails/BuyerPostalAddressDetails/CountryCode"/>
															<xsl:with-param name="theCountryName" select="BuyerPartyDetails/BuyerPostalAddressDetails/CountryName"/>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
												<br/>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtText" select="BuyerContactPersonName"/>
												</xsl:call-template>
												<xsl:for-each select="BuyerContactPersonFunction">
													<xsl:call-template name="OutputCurrentTextBR"/>
												</xsl:for-each>
												<xsl:for-each select="BuyerContactPersonDepartment">
													<xsl:call-template name="OutputCurrentTextBR"/>
												</xsl:for-each>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtTextCopy">
														<xsl:call-template name="FormatEmail">
															<xsl:with-param name="email" select="BuyerCommunicationDetails/BuyerEmailaddressIdentifier"/>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtText" select="BuyerCommunicationDetails/BuyerPhoneNumberIdentifier"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtTitle" select="$txtTaxCode"/>
													<xsl:with-param name="txtText" select="BuyerPartyDetails/BuyerOrganisationTaxCode"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtTitle" select="$txtOrganisationUnitNumber"/>
													<xsl:with-param name="txtText" select="BuyerOrganisationUnitNumber"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtTitle" select="$txtSiteCode"/>
													<xsl:with-param name="txtText" select="BuyerSiteCode"/>
												</xsl:call-template>
											</div>
										</div>
									</xsl:variable>
									<div class="InvoiceRecipient">
										<xsl:choose>
											<xsl:when test="string-length($irpDetails) != 0">
												<xsl:copy-of select="$irpDetails"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:copy-of select="$bpDetails"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
									<xsl:if test="string-length($irpDetails) != 0">
										<xsl:copy-of select="$bpDetails"/>
									</xsl:if>
									<xsl:variable name="irContact">
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtText" select="InvoiceRecipientContactPersonName"/>
										</xsl:call-template>
										<xsl:for-each select="InvoiceRecipientContactPersonFunction">
											<xsl:call-template name="OutputCurrentTextBR"/>
										</xsl:for-each>
										<xsl:for-each select="InvoiceRecipientContactPersonDepartment">
											<xsl:call-template name="OutputCurrentTextBR"/>
										</xsl:for-each>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTextCopy">
												<xsl:call-template name="FormatEmail">
													<xsl:with-param name="email" select="InvoiceRecipientCommunicationDetails/InvoiceRecipientEmailaddressIdentifier"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtText" select="InvoiceRecipientCommunicationDetails/InvoiceRecipientPhoneNumberIdentifier"/>
										</xsl:call-template>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTitle" select="$txtPartyIdentifier"/>
											<xsl:with-param name="txtText" select="InvoiceRecipientPartyDetails/InvoiceRecipientPartyIdentifier"/>
										</xsl:call-template>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="isNewVersion" select="'1'"/>
											<xsl:with-param name="txtTitle" select="InvoiceRecipientPartyDetails/InvoiceRecipientCode/@IdentifierType"/>
											<xsl:with-param name="txtText" select="InvoiceRecipientPartyDetails/InvoiceRecipientCode"/>
										</xsl:call-template>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTitle" select="$txtTaxCode"/>
											<xsl:with-param name="txtText" select="InvoiceRecipientPartyDetails/InvoiceRecipientOrganisationTaxCode"/>
										</xsl:call-template>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTitle" select="$txtOrganisationUnitNumber"/>
											<xsl:with-param name="txtText" select="InvoiceRecipientOrganisationUnitNumber"/>
										</xsl:call-template>
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTitle" select="$txtSiteCode"/>
											<xsl:with-param name="txtText" select="InvoiceRecipientSiteCode"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:if test="string-length($irContact) != 0">
										<div class="InvoiceRecipientContact">
											<div class="title">
												<xsl:value-of select="$txtInvoiceRecipientContact"/>:
											</div>
											<div class="data">
												<xsl:copy-of select="$irContact"/>
											</div>
										</div>
									</xsl:if>
								</td>
								<td class="invoiceTopRight">
									<table class="invoiceTopRight">
										<tbody>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtEpiPaymentInstructionId"/>
												<xsl:with-param name="theData" select="string(EpiDetails/EpiPaymentInstructionDetails/EpiPaymentInstructionId)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtInvoiceDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/InvoiceDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtInvoiceNumber"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/InvoiceNumber)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtOriginalInvoice"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/OriginalInvoiceNumber)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtInvoicingPeriod"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDatePeriod">
														<xsl:with-param name="theStartDate" select="InvoiceDetails/InvoicingPeriodStartDate"/>
														<xsl:with-param name="theEndDate" select="InvoiceDetails/InvoicingPeriodEndDate"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtSellerReferenceIdentifier"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="FormatLink">
														<xsl:with-param name="link" select="InvoiceDetails/SellerReferenceIdentifierUrlText"/>
														<xsl:with-param name="text" select="InvoiceDetails/SellerReferenceIdentifier"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtOrderIdentifier"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="FormatLink">
														<xsl:with-param name="link" select="InvoiceDetails/OrderIdentifierUrlText"/>
														<xsl:with-param name="text" select="InvoiceDetails/OrderIdentifier"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtRowIdentifierDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/OrderDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtOrdererName"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/OrdererName)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtOrderConfirmationIdentifier"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/OrderConfirmationIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtOrderConfirmationDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/OrderConfirmationDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtSalesPersonName"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/SalesPersonName)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtAgreement"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="FormatLink">
														<xsl:with-param name="link" select="InvoiceDetails/AgreementIdentifierUrlText"/>
														<xsl:with-param name="text" select="InvoiceDetails/AgreementIdentifier"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtAgreementType"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/AgreementTypeText)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtAgreementDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/AgreementDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<!--
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtPartyIdentifier"/>
												<xsl:with-param name="theData" select="string(BuyerPartyDetails/BuyerPartyIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="string(BuyerPartyDetails/BuyerCode/@IdentifierType)"/>
												<xsl:with-param name="theData" select="string(BuyerPartyDetails/BuyerCode)"/>
											</xsl:call-template>
											-->
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtBuyersSellerId"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/BuyersSellerIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtBuyerReference"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/BuyerReferenceIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtSellersBuyerIdentifier"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/SellersBuyerIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtNotificationId"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/NotificationIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtNotificationDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/NotificationDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtRegNumberId"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/RegistrationNumberIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtControllerIdentifier"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/ControllerIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtControllerName"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/ControllerName)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtControlDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDetails/ControlDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtProjectRefId"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/ProjectReferenceIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRowSeparator"/>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theClass" select="'EpiInstructedAmount'"/>
												<xsl:with-param name="theTitle" select="$txtEpiInstructedAmount"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="EpiDetails/EpiPaymentInstructionDetails/EpiInstructedAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theClass" select="'EpiDateOptionDate'"/>
												<xsl:with-param name="theTitle" select="$txtInvoiceDueDate"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="EpiDetails/EpiPaymentInstructionDetails/EpiDateOptionDate"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theClass" select="'EpiNameAddressDetails'"/>
												<xsl:with-param name="theTitle" select="$txtEpiNameAddressDetails"/>
												<xsl:with-param name="theData" select="string(EpiDetails/EpiPartyDetails/EpiBeneficiaryPartyDetails/EpiNameAddressDetails)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theClass" select="'EpiAccountID'"/>
												<xsl:with-param name="theTitle" select="$txtEpiAccountID"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputEpiAccountID">
														<xsl:with-param name="theAccount" select="EpiDetails/EpiPartyDetails/EpiBeneficiaryPartyDetails/EpiAccountID"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theClass" select="'EpiBfiIdentifier'"/>
												<xsl:with-param name="theTitle" select="$txtEpiBfiIdentifier"/>
												<xsl:with-param name="theData" select="string(EpiDetails/EpiPartyDetails/EpiBfiPartyDetails/EpiBfiIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theClass" select="'EpiRemittanceInfoIdentifier'"/>
												<xsl:with-param name="theTitle" select="$txtEpiRemittanceInfoIdentifier"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputEpiRemittanceInfoIdentifier">
														<xsl:with-param name="erii" select="EpiDetails/EpiPaymentInstructionDetails/EpiRemittanceInfoIdentifier"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRowSeparator"/>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtCreditLimit"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/CreditLimitAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtCreditInterest"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputPercentage">
														<xsl:with-param name="thePercentage" select="InvoiceDetails/CreditInterestPercent"/>
														<xsl:with-param name="suppressZero" select="'1'"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtOperationLimit"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/OperationLimitAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtMonthlyAmount"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/MonthlyAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:if test="string-length(PaymentStatusDetails/PaymentStatusCode) != 0">
												<xsl:call-template name="OutputTitleDataRowSeparator"/>
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="theTitle" select="$txtPaymentStatusCode"/>
													<xsl:with-param name="theData">
														<xsl:choose>
															<xsl:when test="PaymentStatusDetails/PaymentStatusCode = 'NOTPAID'">
																<xsl:value-of select="$txtPaymentStatusNotPaid"/>
															</xsl:when>
															<xsl:when test="PaymentStatusDetails/PaymentStatusCode = 'PARTLYPAID'">
																<xsl:value-of select="$txtPaymentStatusPartlyPaid"/>
															</xsl:when>
															<xsl:when test="PaymentStatusDetails/PaymentStatusCode = 'PAID'">
																<xsl:value-of select="$txtPaymentStatusPaid"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="PaymentStatusDetails/PaymentStatusCode"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="string-length(PaymentStatusDetails/PaymentMethodText) != 0">
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="theTitle" select="$txtPaymentMethodText"/>
													<xsl:with-param name="theData" select="string(PaymentStatusDetails/PaymentMethodText)"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:for-each select="InvoiceDetails/PaymentTermsDetails">
												<xsl:variable name="ptDetails">
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtPaymentOverDueFineDetails"/>
														<xsl:with-param name="theData">
															<xsl:for-each select="PaymentOverDueFineDetails/PaymentOverDueFineFreeText">
																<xsl:if test="position() != 1"><br/></xsl:if><xsl:value-of select="."/>
															</xsl:for-each>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtPaymentOverDueFine"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputPercentage">
																<xsl:with-param name="thePercentage" select="PaymentOverDueFineDetails/PaymentOverDueFinePercent"/>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtPaymentOverDueFine"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputAmount">
																<xsl:with-param name="theAmount" select="PaymentOverDueFineDetails/PaymentOverDueFixedAmount"/>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:for-each select="PaymentTermsFreeText">
														<xsl:call-template name="OutputTitleDataRow">
															<xsl:with-param name="theTitle" select="$txtPaymentTermsFreeText"/>
															<xsl:with-param name="theData" select="string(.)"/>
														</xsl:call-template>
													</xsl:for-each>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="isNewVersion" select="'1'"/>
														<xsl:with-param name="theTitle" select="$txtInvoiceDueDate"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="InvoiceDueDate"/></xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtCashDiscountDate"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="CashDiscountDate"/></xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtCashDiscountPercent"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputPercentage">
																<xsl:with-param name="thePercentage" select="CashDiscountPercent"/>
																<xsl:with-param name="suppressZero" select="'1'"/>
																<xsl:with-param name="theBaseAmount" select="CashDiscountBaseAmount"/>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<!--<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtCashDiscountBaseAmount"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="CashDiscountBaseAmount"/></xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>-->
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtCashDiscountAmount"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="CashDiscountAmount"/></xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtCashDiscountExlVat"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="CashDiscountExcludingVatAmount"/></xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:for-each select="CashDiscountVatDetails">
														<xsl:call-template name="OutputTitleDataRow">
															<xsl:with-param name="theTitle" select="$txtCashDiscountVat"/>
															<xsl:with-param name="theData">
																<xsl:call-template name="OutputPercentage"><xsl:with-param name="thePercentage" select="CashDiscountVatPercent"/></xsl:call-template>
																<xsl:text>: </xsl:text>
																<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="CashDiscountVatAmount"/></xsl:call-template>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:for-each>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtReducedAmount"/>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="ReducedInvoiceVatIncludedAmount"/></xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:variable>
												<xsl:if test="string-length($ptDetails) != 0">
													<xsl:call-template name="OutputTitleDataRowSeparator"/>
													<xsl:copy-of select="$ptDetails"/>
												</xsl:if>
											</xsl:for-each>
											<xsl:variable name="invSender">
												<xsl:for-each select="InvoiceSenderPartyDetails/InvoiceSenderOrganisationName">
													<xsl:call-template name="OutputCurrentTextBR"/>
												</xsl:for-each>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="txtTitle" select="$txtPartyIdentifier"/>
													<xsl:with-param name="txtText" select="InvoiceSenderPartyDetails/InvoiceSenderPartyIdentifier"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="txtTitle" select="InvoiceSenderPartyDetails/InvoiceSenderCode/@IdentifierType"/>
													<xsl:with-param name="txtText" select="InvoiceSenderPartyDetails/InvoiceSenderCode"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTextBR">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="txtTitle" select="$txtTaxCode"/>
													<xsl:with-param name="txtText" select="InvoiceSenderPartyDetails/InvoiceSenderOrganisationTaxCode"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:if test="string-length($invSender) != 0">
												<xsl:call-template name="OutputTitleDataRowSeparator"/>
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="theTitle" select="$txtInvoiceSender"/>
													<xsl:with-param name="theData"><xsl:copy-of select="$invSender"/></xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:variable name="factoringInfo">
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="theTitle" select="$txtFactoringPartyName"/>
													<xsl:with-param name="theData" select="string(FactoringAgreementDetails/FactoringPartyName)"/>
												</xsl:call-template>
												<xsl:if test="FactoringAgreementDetails/FactoringPartyPostalAddressDetails">
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputTextBR">
																<xsl:with-param name="txtText" select="FactoringAgreementDetails/FactoringPartyPostalAddressDetails/FactoringPartyPostOfficeBoxIdentifier"/>
															</xsl:call-template>
															<xsl:for-each select="FactoringAgreementDetails/FactoringPartyPostalAddressDetails/FactoringPartyStreetName">
																<xsl:call-template name="OutputCurrentTextBR"/>
															</xsl:for-each>
															<xsl:call-template name="OutputTextBR">
																<xsl:with-param name="txtText">
																	<xsl:call-template name="BuildString">
																		<xsl:with-param name="txtText" select="FactoringAgreementDetails/FactoringPartyPostalAddressDetails/FactoringPartyPostCodeIdentifier"/>
																		<xsl:with-param name="txtText2" select="FactoringAgreementDetails/FactoringPartyPostalAddressDetails/FactoringPartyTownName"/>
																	</xsl:call-template>
																</xsl:with-param>
															</xsl:call-template>
															<xsl:call-template name="OutputTextBR">
																<xsl:with-param name="txtText">
																	<xsl:call-template name="BuildCountryString">
																		<xsl:with-param name="theCountryCode" select="FactoringAgreementDetails/FactoringPartyPostalAddressDetails/CountryCode"/>
																		<xsl:with-param name="theCountryName" select="FactoringAgreementDetails/FactoringPartyPostalAddressDetails/CountryName"/>
																	</xsl:call-template>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="theTitle" select="$txtPartyIdentifier"/>
													<xsl:with-param name="theData" select="string(FactoringAgreementDetails/FactoringPartyIdentifier)"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="theTitle" select="$txtFactoringAgreementIdentifier"/>
													<xsl:with-param name="theData" select="string(FactoringAgreementDetails/FactoringAgreementIdentifier)"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="theTitle" select="$txtTransmissionListIdentifier"/>
													<xsl:with-param name="theData" select="string(FactoringAgreementDetails/TransmissionListIdentifier)"/>
												</xsl:call-template>
												<xsl:call-template name="OutputTitleDataRow">
													<xsl:with-param name="isNewVersion" select="'1'"/>
													<xsl:with-param name="theTitle" select="$txtFactoringFreeText"/>
													<xsl:with-param name="theData" select="string(FactoringAgreementDetails/EndorsementClauseCode)"/>
												</xsl:call-template>
												<xsl:variable name="fftxt">
													<xsl:for-each select="FactoringAgreementDetails/FactoringFreeText">
														<xsl:call-template name="OutputCurrentTextBR"/>
													</xsl:for-each>
												</xsl:variable>
												<xsl:if test="string-length($fftxt) != 0">
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle" select="$txtFactoringFreeText"/>
														<xsl:with-param name="emptyDataAlso" select="'1'"/>
													</xsl:call-template>
													<tr>
														<td class="data" colspan="2"><xsl:copy-of select="$fftxt"/></td>
													</tr>
												</xsl:if>
											</xsl:variable>
											<xsl:if test="string-length($factoringInfo) != 0">
												<xsl:call-template name="OutputTitleDataRowSeparator"/>
												<xsl:copy-of select="$factoringInfo"/>
											</xsl:if>
											<xsl:if test="string-length(AttachmentMessageDetails/AttachmentMessageIdentifier) != 0">
												<xsl:call-template name="OutputTitleDataRowSeparator"/>
												<tr>
													<td class="title" colspan="2"><xsl:value-of select="$txtAttachments"/></td>
												</tr>
											</xsl:if>
										</tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				<xsl:if test="$InvoiceDetails_DefinitionDetails_paikka = 1">
					<xsl:call-template name="OutputDefinitionDetails"/>
				</xsl:if>
				<xsl:if test="string-length(normalize-space(InvoiceDetails/InvoiceFreeText)) != 0">
					<div class="InvoiceFreeText">
						<xsl:for-each select="InvoiceDetails/InvoiceFreeText">
							<xsl:call-template name="OutputDataDiv">
								<xsl:with-param name="theData" select="string(.)"/>
							</xsl:call-template>
						</xsl:for-each>
					</div>
				</xsl:if>
				<xsl:if test="string-length(normalize-space(InvoiceDetails/InvoiceVatFreeText)) != 0">
					<div class="InvoiceFreeText">
						<xsl:call-template name="OutputDataDiv">
							<xsl:with-param name="isNewVersion" select="'1'"/>
							<xsl:with-param name="theData" select="string(InvoiceDetails/InvoiceVatFreeText)"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<table class="invoiceRows">
					<tbody>
						<xsl:for-each select="InvoiceRow">
							<xsl:choose>
								<xsl:when test="SubInvoiceRow">
									<xsl:call-template name="OutputSubInvoiceRows">
										<xsl:with-param name="invoiceRowPos" select="position()"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="OutputInvoiceRow">
										<xsl:with-param name="invoiceRowPos" select="position()"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tbody>
				</table>
				<table class="InvoiceDetails">
					<tbody>
						<xsl:if test="(//InvoiceDetails/DiscountDetails)">
							<table class="DiscountDetails">
								<tbody>
									<xsl:call-template name="OutputTitleDataRow">
										<xsl:with-param name="isNewVersion" select="'1'"/>
										<xsl:with-param name="theTitle" select="$txtDiscountDetails"/>
										<xsl:with-param name="emptyDataAlso" select="'1'"/>
									</xsl:call-template>
									<xsl:for-each select="//InvoiceDetails/DiscountDetails">
										<tr>
											<td><xsl:value-of select="FreeText"/></td>
											<td><xsl:call-template name="OutputPercentage"><xsl:with-param name="thePercentage" select="Percent"/></xsl:call-template></td>
											<td><xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="Amount"/></xsl:call-template></td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<xsl:call-template name="OutputTitleDataRowSeparator"/>
						</xsl:if>
						<tr>
							<td>
								<xsl:if test="(//InvoiceDetails/VatSpecificationDetails)">
									<table class="VatSpecificationDetails">
										<tbody>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtVatSpecification"/>
												<xsl:with-param name="emptyDataAlso" select="'1'"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtVatExcludedAmount"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/InvoiceTotalVatExcludedAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtInvoiceTotalVatAmount"/>
												<xsl:with-param name="theData">
													<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/InvoiceTotalVatAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:for-each select="InvoiceDetails/VatSpecificationDetails">
												<xsl:if test="(string-length(VatRatePercent) != 0) or (string-length(VatRateAmount) != 0)">
													<xsl:variable name="theBaseAmount">
														<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="VatBaseAmount"/></xsl:call-template>
													</xsl:variable>
													<xsl:call-template name="OutputTitleDataRow">
														<xsl:with-param name="theTitle">
															<xsl:value-of select="$txtVat"/><xsl:text> </xsl:text>
															<xsl:call-template name="OutputPercentage"><xsl:with-param name="thePercentage" select="VatRatePercent"/></xsl:call-template>
															<xsl:text> </xsl:text><xsl:value-of select="VatCode"/>
														</xsl:with-param>
														<xsl:with-param name="theData">
															<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="VatRateAmount"/></xsl:call-template>
															<xsl:if test="string-length($theBaseAmount)!=0"><xsl:text> </xsl:text>(<xsl:copy-of select="$theBaseAmount"/>)</xsl:if>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
												<xsl:for-each select="VatFreeText">
													<xsl:if test="string-length(.) != 0">
														<tr>
															<td colspan="2" class="data VatFreeText">
																<xsl:value-of select="."/>
															</td>
														</tr>
													</xsl:if>
												</xsl:for-each>
											</xsl:for-each>
										</tbody>
									</table>
								</xsl:if>
							</td>
							<td>
								<table class="invoiceTotal">
									<tbody>
										<xsl:call-template name="OutputTitleDataRow">
											<xsl:with-param name="theTitle" select="$txtRounding"/>
											<xsl:with-param name="theData">
												<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/InvoiceTotalRoundoffAmount"/></xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="OutputTitleDataRow">
											<xsl:with-param name="theClass" select="'InvoiceTotalVatIncludedAmount'"/>
											<xsl:with-param name="theTitle" select="$txtINVOICETOTAL"/>
											<xsl:with-param name="theData">
												<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/InvoiceTotalVatIncludedAmount"/></xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="OutputTitleDataRow">
											<xsl:with-param name="theTitle" select="$txtExchangeRate"/>
											<xsl:with-param name="theData">
												<xsl:call-template name="OutputAmount">
													<xsl:with-param name="theAmount" select="InvoiceDetails/ExchangeRate"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="OutputTitleDataRow">
											<xsl:with-param name="isNewVersion" select="'1'"/>
											<xsl:with-param name="theTitle" select="$txtOtherCurrencyAmountVatExcludedAmount"/>
											<xsl:with-param name="theData">
												<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/OtherCurrencyAmountVatExcludedAmount"/></xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="OutputTitleDataRow">
											<xsl:with-param name="theTitle" select="$txtOtherCurrencyAmountVatIncludedAmount"/>
											<xsl:with-param name="theData">
												<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="InvoiceDetails/OtherCurrencyAmountVatIncludedAmount"/></xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="(string-length(InvoiceDetails/ShortProposedAccountIdentifier) != 0) or (string-length(InvoiceDetails/NormalProposedAccountIdentifier) != 0) or (string-length(InvoiceDetails/AccountDimensionText) != 0) or (string-length(InvoiceDetails/ProposedAccountText) != 0) or (string-length(InvoiceDetails/SellerAccountText) != 0)">
							<tr>
								<td>
									<table class="accounting">
										<tbody>
											<xsl:call-template name="OutputTitleDataRowSeparator"/>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtShortProposedAccountIdentifier"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/ShortProposedAccountIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtNormalProposedAccountIdentifier"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/NormalProposedAccountIdentifier)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtProposedAccountIdentifier"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/ProposedAccountText)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="theTitle" select="$txtAccountDimension"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/AccountDimensionText)"/>
											</xsl:call-template>
											<xsl:call-template name="OutputTitleDataRow">
												<xsl:with-param name="isNewVersion" select="'1'"/>
												<xsl:with-param name="theTitle" select="$txtSellerAccountText"/>
												<xsl:with-param name="theData" select="string(InvoiceDetails/SellerAccountText)"/>
											</xsl:call-template>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
					</tbody>
				</table>
				<div class="InvoiceUrlText">
					<xsl:for-each select="InvoiceUrlText">
						<xsl:if test="position() != 1"><br/></xsl:if>
						<xsl:call-template name="OutputInvoiceUrl">
							<xsl:with-param name="pos" select="position()"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>
				<xsl:if test="string-length(VirtualBankBarcode) != 0">
					<div class="virtualBankBarcodeBlock">
						<div class="title"><xsl:value-of select="$txtVirtualBankBarcode"/>:</div>
						<div class="VirtualBankBarcode"><xsl:value-of select="VirtualBankBarcode"/></div>
					</div>
				</xsl:if>
				<xsl:if test="$InvoiceDetails_DefinitionDetails_paikka = 2">
					<xsl:call-template name="OutputDefinitionDetails"/>
				</xsl:if>
				<xsl:variable name="deliveryCol1">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveryParty"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="DeliveryPartyDetails/DeliveryOrganisationName">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:for-each select="DeliveryPartyDetails/DeliveryOrganisationDepartment">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="DeliveryPartyDetails/DeliveryPostalAddressDetails/DeliveryPostofficeBoxIdentifier"/>
							</xsl:call-template>
							<xsl:for-each select="DeliveryPartyDetails/DeliveryPostalAddressDetails/DeliveryStreetName">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText">
									<xsl:call-template name="BuildString">
										<xsl:with-param name="txtText" select="DeliveryPartyDetails/DeliveryPostalAddressDetails/DeliveryPostCodeIdentifier"/>
										<xsl:with-param name="txtText2" select="DeliveryPartyDetails/DeliveryPostalAddressDetails/DeliveryTownName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText">
									<xsl:call-template name="BuildCountryString">
										<xsl:with-param name="theCountryCode" select="DeliveryPartyDetails/DeliveryPostalAddressDetails/CountryCode"/>
										<xsl:with-param name="theCountryName" select="DeliveryPartyDetails/DeliveryPostalAddressDetails/CountryName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="DeliveryContactPersonName"/>
							</xsl:call-template>
							<xsl:for-each select="DeliveryContactPersonFunction">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:for-each select="DeliveryContactPersonDepartment">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="DeliveryCommunicationDetails/DeliveryEmailaddressIdentifier"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="DeliveryCommunicationDetails/DeliveryPhoneNumberIdentifier"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtTitle" select="$txtPartyIdentifier"/>
								<xsl:with-param name="txtText" select="DeliveryPartyDetails/DeliveryPartyIdentifier"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtTitle" select="DeliveryPartyDetails/DeliveryCode/@IdentifierType"/>
								<xsl:with-param name="txtText" select="DeliveryPartyDetails/DeliveryCode"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtTitle" select="$txtTaxCode"/>
								<xsl:with-param name="txtText" select="DeliveryPartyDetails/DeliveryOrganisationTaxCode"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtTitle" select="$txtOrganisationUnitNumber"/>
								<xsl:with-param name="txtText" select="DeliveryOrganisationUnitNumber"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtTitle" select="$txtSiteCode"/>
								<xsl:with-param name="txtText" select="DeliverySiteCode"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliverer"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="DeliveryDetails/DelivererName">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="DeliveryDetails/DelivererIdentifier"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText">
									<xsl:call-template name="BuildCountryString">
										<xsl:with-param name="theCountryCode" select="DeliveryDetails/DelivererCountryCode"/>
										<xsl:with-param name="theCountryName" select="DeliveryDetails/DelivererCountryName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="deliveryCol2">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveryDate"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="DeliveryDetails/DeliveryDate"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:if test="DeliveryDetails/DeliveryPeriodDetails">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle" select="$txtDeliveryPeriodDetails"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputDatePeriod">
									<xsl:with-param name="theStartDate" select="DeliveryDetails/DeliveryPeriodDetails/StartDate"/>
									<xsl:with-param name="theEndDate" select="DeliveryDetails/DeliveryPeriodDetails/EndDate"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveryMethod"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/DeliveryMethodText)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveryTerms"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/DeliveryTermsText)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtTerminalAddress"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/TerminalAddressText)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtWaybillIdentifier"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/WaybillIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtWaybillTypeCode"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/WaybillTypeCode)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtClearanceId"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/ClearanceIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveryNoteId"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/DeliveryNoteIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtCountryOfOrigin"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/CountryOfOrigin)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPlaceOfDischarge"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="DeliveryDetails/PlaceOfDischarge">
								<xsl:if test="position() != 1"><br/></xsl:if><xsl:value-of select="."/>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtCountryOfDestinationName"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/CountryOfDestinationName)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtFinalDestination"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="DeliveryDetails/FinalDestinationName">
								<xsl:if test="position() != 1"><br/></xsl:if><xsl:value-of select="."/>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="deliveryCol3">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtShipmentOrg"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="DeliveryDetails/ShipmentPartyDetails/ShipmentOrganisationName">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:for-each select="DeliveryDetails/ShipmentPartyDetails/ShipmentOrganisationDepartment">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtText" select="DeliveryDetails/ShipmentPartyDetails/ShipmentPostalAddressDetails/ShipmentPostOfficeBoxIdentifier"/>
							</xsl:call-template>
							<xsl:for-each select="DeliveryDetails/ShipmentPartyDetails/ShipmentPostalAddressDetails/ShipmentStreetName">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText">
									<xsl:call-template name="BuildString">
										<xsl:with-param name="txtText" select="DeliveryDetails/ShipmentPartyDetails/ShipmentPostalAddressDetails/ShipmentPostCodeIdentifier"/>
										<xsl:with-param name="txtText2" select="DeliveryDetails/ShipmentPartyDetails/ShipmentPostalAddressDetails/ShipmentTownName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtText">
									<xsl:call-template name="BuildCountryString">
										<xsl:with-param name="theCountryCode" select="DeliveryDetails/ShipmentPartyDetails/ShipmentPostalAddressDetails/CountryCode"/>
										<xsl:with-param name="theCountryName" select="DeliveryDetails/ShipmentPartyDetails/ShipmentPostalAddressDetails/CountryName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtTitle" select="$txtPartyIdentifier"/>
								<xsl:with-param name="txtText" select="DeliveryDetails/ShipmentPartyDetails/ShipmentPartyIdentifier"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtTitle" select="DeliveryDetails/ShipmentPartyDetails/ShipmentCode/@IdentifierType"/>
								<xsl:with-param name="txtText" select="DeliveryDetails/ShipmentPartyDetails/ShipmentCode"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtTitle" select="$txtTaxCode"/>
								<xsl:with-param name="txtText" select="DeliveryDetails/ShipmentPartyDetails/ShipmentOrganisationTaxCode"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtTitle" select="$txtSiteCode"/>
								<xsl:with-param name="txtText" select="DeliveryDetails/ShipmentPartyDetails/ShipmentSiteCode"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtManufacturer"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="isNewVersion" select="'1'"/>
								<xsl:with-param name="txtTitle" select="$txtPartyIdentifier"/>
								<xsl:with-param name="txtText" select="DeliveryDetails/ManufacturerIdentifier"/>
							</xsl:call-template>
							<xsl:for-each select="DeliveryDetails/ManufacturerName">
								<xsl:call-template name="OutputCurrentTextBR"/>
							</xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText">
									<xsl:call-template name="BuildCountryString">
										<xsl:with-param name="theCountryCode" select="DeliveryDetails/ManufacturerCountryCode"/>
										<xsl:with-param name="theCountryName" select="DeliveryDetails/ManufacturerCountryName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtManufacturerOrderId"/>
						<xsl:with-param name="theData" select="string(DeliveryDetails/ManufacturerOrderIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageLength"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/PackageLength"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageWidth"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/PackageWidth"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageHeight"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/PackageHeight"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageWeight"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/PackageWeight"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageNetWeight"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/PackageNetWeight"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageVolume"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/PackageVolume"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtTransportCarriageQuantity"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DeliveryDetails/PackageDetails/TransportCarriageQuantity"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="(string-length($deliveryCol1)!=0) or (string-length($deliveryCol2)!=0) or (string-length($deliveryCol3)!=0)">
					<table class="deliveryDetails">
						<tbody>
							<tr>
								<xsl:if test="string-length($deliveryCol1)!=0">
									<td class="multiData"><xsl:copy-of select="$deliveryCol1"/></td>
								</xsl:if>
								<xsl:if test="string-length($deliveryCol2)!=0">
									<td class="multiData"><xsl:copy-of select="$deliveryCol2"/></td>
								</xsl:if>
								<xsl:if test="string-length($deliveryCol3)!=0">
									<td class="multiData"><xsl:copy-of select="$deliveryCol3"/></td>
								</xsl:if>
							</tr>
						</tbody>
					</table>
				</xsl:if>
				<xsl:variable name="countSFT" select="count(SpecificationDetails/SpecificationFreeText)"/>
				<xsl:if test="$countSFT != 0">
					<div class="SpecificationDetails">
						<xsl:for-each select="SpecificationDetails/SpecificationFreeText">
							<xsl:if test="position() != 1"><br/></xsl:if><xsl:value-of select="."/>
						</xsl:for-each>
					</div>
				</xsl:if>
				<xsl:variable name="countAPD" select="count(AnyPartyDetails)"/>
				<xsl:if test="$countAPD != 0">
					<div class="invoiceAnyPartyDetails">
						<table class="AnyPartyDetails">
							<xsl:for-each select="AnyPartyDetails">
								<xsl:if test="position() mod 2 != 0">
									<xsl:if test="position() != 1">
										<xsl:call-template name="OutputTitleDataRowSeparator"/>
									</xsl:if>
									<tr>
										<td>
											<xsl:call-template name="OutputInvoiceAnyPartyDetails"/>
										</td>
										<td>
											<xsl:variable name="possu" select="position()"/>
											<xsl:if test="$possu &lt; $countAPD">
												<xsl:for-each select="../AnyPartyDetails[position() = $possu + 1]">
													<xsl:call-template name="OutputInvoiceAnyPartyDetails"/>
												</xsl:for-each>
											</xsl:if>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</table>
					</div>
				</xsl:if>
				<!-- Sitten tulostetaan mahdolliset osamaksutiedot. -->
				<xsl:variable name="countPPD" select="count(PartialPaymentDetails)"/>
				<xsl:if test="$countPPD != 0">
					<div class="PartialPaymentDetails">
						<xsl:for-each select="PartialPaymentDetails">
							<xsl:if test="position() != 1">
								<div class="partialPaymentDetailsSeparator"></div>
							</xsl:if>
							<table class="PartialPaymentDetails">
								<tbody>
									<tr>
										<td colspan="4" class="title"><xsl:value-of select="$txtPartialPaymentDetails"/>:</td>
									</tr>
									<tr>
										<td class="data">
											<table class="PartialPaymentDetail">
												<tbody>
													<xsl:if test="PaidVatExcludedAmount">
														<tr class="isNewVersion">
															<td class="data titlePad"><xsl:value-of select="$txtPaidVatExcludedAmount"/>:</td>
															<td class="data alignRight"><xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="PaidVatExcludedAmount"/></xsl:call-template></td>
														</tr>
													</xsl:if>
													<tr>
														<td class="data titlePad"><xsl:value-of select="$txtPaidAmount"/>:</td>
														<td class="data alignRight"><xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="PaidAmount"/></xsl:call-template></td>
													</tr>
												</tbody>
											</table>
										</td>
										<td class="data alignRight">
											<table class="PartialPaymentDetail">
												<tbody>
													<xsl:if test="UnPaidVatExcludedAmount">
														<tr class="isNewVersion">
															<td class="data titlePad"><xsl:value-of select="$txtUnPaidVatExcludedAmount"/>:</td>
															<td class="data alignRight"><xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="UnPaidVatExcludedAmount"/></xsl:call-template></td>
														</tr>
													</xsl:if>
													<tr>
														<td class="data titlePad"><xsl:value-of select="$txtUnPaidAmount"/>:</td>
														<td class="data alignRight"><xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="UnPaidAmount"/></xsl:call-template></td>
													</tr>
												</tbody>
											</table>
										</td>
										<td class="data alignRight">
											<xsl:call-template name="BuildString">
												<xsl:with-param name="txtTitle" select="$txtInterestPercent"/>
												<!--<xsl:with-param name="txtText" select="InterestPercent"/>-->
												<xsl:with-param name="txtText">
													<xsl:call-template name="OutputPercentage">
														<xsl:with-param name="thePercentage" select="InterestPercent"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</td>
										<td class="data alignRight">
											<xsl:call-template name="BuildString">
												<xsl:with-param name="txtTitle" select="$txtProsessingCostsAmount"/>
												<xsl:with-param name="txtText">
													<xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="ProsessingCostsAmount"/></xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</td>
									</tr>
									<tr>
										<td class="title">
											<xsl:value-of select="$txtPartialPaymentDueDate"/>
										</td>
										<td class="title alignRight">
											<xsl:value-of select="$txtVatIncludedAmount"/>
										</td>
										<td class="title alignRight">
											<xsl:value-of select="$txtVatExcludedAmount"/>
										</td>
										<td class="title alignRight">
											<xsl:value-of select="$txtPartialPaymentReferenceIdentifier"/>
										</td>
									</tr>
									<tr>
										<td class="data">
											<xsl:for-each select="PartialPaymentDueDate">
												<xsl:if test="position() != 1"><br/></xsl:if><xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="."/></xsl:call-template>
											</xsl:for-each>
										</td>
										<td class="data alignRight">
											<xsl:for-each select="PartialPaymentVatIncludedAmount">
												<xsl:if test="position() != 1"><br/></xsl:if><xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="."/></xsl:call-template>
											</xsl:for-each>
										</td>
										<td class="data alignRight">
											<xsl:for-each select="PartialPaymentVatExcludedAmount">
												<xsl:if test="position() != 1"><br/></xsl:if><xsl:call-template name="OutputAmountWithoutCurrency"><xsl:with-param name="theAmount" select="."/></xsl:call-template>
											</xsl:for-each>
										</td>
										<td class="data alignRight">
											<xsl:for-each select="PartialPaymentReferenceIdentifier">
												<xsl:value-of select="."/><br/>
											</xsl:for-each>
										</td>
									</tr>
								</tbody>
							</table>
						</xsl:for-each>
					</div>
				</xsl:if>
				<!-- Tarkistus- ja hyv�ksymismerkinn�t. -->
				<xsl:if test="(string-length(ControlStampText)!=0) or (string-length(AcceptanceStampText)!=0)">
					<div class="stamps">
						<xsl:if test="string-length(ControlStampText) != 0">
							<span class="colTitle"><xsl:value-of select="$txtControlStampText"/>:</span><br/>
							<xsl:value-of select="ControlStampText"/>
							<xsl:if test="string-length(AcceptanceStampText) != 0">
								<br/><br/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="string-length(AcceptanceStampText) != 0">
							<span class="colTitle"><xsl:value-of select="$txtAcceptanceStampText"/>:</span><br/>
							<xsl:value-of select="AcceptanceStampText"/>
						</xsl:if>
					</div>
				</xsl:if>
				<!-- Loppuun tulostetaan myyj�n yhteys- ja muita tietoja. -->
				<xsl:variable name="sellerDetailsClass">
					sellerDetails<xsl:if test="($countSFT != 0) and ($countAPD = 0) and ($countPPD = 0)"><xsl:text> afterSpecificationDetails</xsl:text></xsl:if>
				</xsl:variable>
				<div>
					<xsl:attribute name="class"><xsl:value-of select="$sellerDetailsClass"/></xsl:attribute>
					<table>
						<xsl:attribute name="class"><xsl:value-of select="$sellerDetailsClass"/></xsl:attribute>
						<tbody>
							<tr>
								<td>
									<xsl:value-of select="SellerPartyDetails/SellerOrganisationName"/>
									<br/>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtText" select="SellerInformationDetails/SellerOfficialPostalAddressDetails/SellerOfficialStreetName"/>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtText">
											<xsl:call-template name="BuildString">
												<xsl:with-param name="txtText" select="SellerInformationDetails/SellerOfficialPostalAddressDetails/SellerOfficialPostCodeIdentifier"/>
												<xsl:with-param name="txtText2" select="SellerInformationDetails/SellerOfficialPostalAddressDetails/SellerOfficialTownName"/>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtText">
											<xsl:call-template name="BuildCountryString">
												<xsl:with-param name="theCountryCode" select="SellerInformationDetails/SellerOfficialPostalAddressDetails/CountryCode"/>
												<xsl:with-param name="theCountryName" select="SellerInformationDetails/SellerOfficialPostalAddressDetails/CountryName"/>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtText" select="SellerInformationDetails/SellerFreeText"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTitle" select="$txtPhoneNumber"/>
										<xsl:with-param name="txtText" select="SellerInformationDetails/SellerPhoneNumber"/>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTitle" select="$txtFaxNumber"/>
										<xsl:with-param name="txtText" select="SellerInformationDetails/SellerFaxNumber"/>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTitle" select="$txtWebaddressIdentifier"/>
										<xsl:with-param name="txtTextCopy">
											<xsl:call-template name="BuildString">
													<xsl:with-param name="txtText" select="SellerInformationDetails/SellerWebaddressIdentifier"/>
													<xsl:with-param name="txtTextUrl" select="SellerInformationDetails/SellerWebaddressIdentifier"/>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTitle" select="$txtEmailaddressIdentifier"/>
										<xsl:with-param name="txtTextCopy">
											<xsl:call-template name="FormatEmail">
												<xsl:with-param name="email" select="SellerInformationDetails/SellerCommonEmailaddressIdentifier"/>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:for-each select="SellerInformationDetails/InvoiceRecipientDetails">
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTitle" select="$txtInvoiceRecipientAddress"/>
											<xsl:with-param name="txtTextCopy">
												<xsl:call-template name="BuildString">
														<xsl:with-param name="txtText" select="InvoiceRecipientAddress"/>
														<xsl:with-param name="txtTextDelimiter">/</xsl:with-param>
														<xsl:with-param name="txtText2" select="InvoiceRecipientIntermediatorAddress"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</td>
								<td>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTitle" select="$txtHomeTownName"/>
										<xsl:with-param name="txtText" select="SellerInformationDetails/SellerHomeTownName"/>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTitle" select="$txtTaxCode"/>
										<xsl:with-param name="txtTextCopy">
											<xsl:call-template name="BuildString">
													<xsl:with-param name="txtText" select="SellerPartyDetails/SellerOrganisationTaxCode"/>
													<xsl:with-param name="txtTextUrl" select="SellerPartyDetails/SellerOrganisationTaxCodeUrlText"/>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="txtTextCopy">
											<xsl:call-template name="BuildString">
													<xsl:with-param name="txtText" select="SellerInformationDetails/SellerVatRegistrationText"/>
													<xsl:with-param name="txtText2">
														<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="SellerInformationDetails/SellerVatRegistrationDate"/></xsl:call-template>
													</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="isNewVersion" select="'1'"/>
										<xsl:with-param name="txtText" select="SellerInformationDetails/SellerTaxRegistrationText"/>
									</xsl:call-template>
									<xsl:call-template name="OutputTextBR">
										<xsl:with-param name="isNewVersion" select="'1'"/>
										<xsl:with-param name="txtTitle" select="$txtOrganisationUnitNumber"/>
										<xsl:with-param name="txtText" select="SellerOrganisationUnitNumber"/>
									</xsl:call-template>
									<xsl:for-each select="SellerInformationDetails/SellerAccountDetails">
										<xsl:call-template name="OutputTextBR">
											<xsl:with-param name="txtTextCopy">
												<xsl:call-template name="BuildString">
														<xsl:with-param name="txtText">
															<xsl:call-template name="OutputEpiAccountID">
																<xsl:with-param name="theAccount" select="SellerAccountID"/>
															</xsl:call-template>
														</xsl:with-param>
														<xsl:with-param name="txtTextDelimiter">/</xsl:with-param>
														<xsl:with-param name="txtText2" select="SellerBic"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- Template, joka tulostaa yhteen kuuluvat linkin ja tekstin. -->
	<xsl:template name="OutputInvoiceUrl">
		<xsl:param name="pos"/>
		<xsl:call-template name="FormatLink">
			<xsl:with-param name="link" select="/Finvoice/InvoiceUrlText[position()=$pos]"/>
			<xsl:with-param name="text" select="/Finvoice/InvoiceUrlNameText[position()=$pos]"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template, joka tulostaa yhden tai kahden p�iv�yksen aikajakson. -->
	<xsl:template name="OutputDatePeriod">
		<xsl:param name="theDate"/>
		<xsl:param name="theStartDate"/>
		<xsl:param name="theEndDate"/>
		<xsl:choose>
			<xsl:when test="string-length($theDate) != 0">
				<xsl:call-template name="OutputDate">
					<xsl:with-param name="theDate" select="$theDate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="string-length($theStartDate) != 0">
				<xsl:call-template name="OutputDate">
					<xsl:with-param name="theDate" select="$theStartDate"/>
				</xsl:call-template>
				<xsl:if test="string-length($theEndDate) != 0">
					-
					<xsl:call-template name="OutputDate">
						<xsl:with-param name="theDate" select="$theEndDate"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka tulostaa p�iv�m��ri�. -->
	<xsl:template name="OutputDate">
		<xsl:param name="theDate"/>
		<xsl:variable name="strDate" select="string($theDate)"/>
		<xsl:if test="string-length($strDate) != 0">
			<xsl:variable name="strFormat" select="string($theDate/@Format)"/>
			<xsl:choose>
				<xsl:when test="substring($strDate,7,1)='0'">
					<xsl:value-of select="substring($strDate,8,1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($strDate,7,2)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>.</xsl:text>
			<xsl:choose>
				<xsl:when test="substring($strDate,5,1)='0'">
					<xsl:value-of select="substring($strDate,6,1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($strDate,5,2)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="substring($strDate,1,4)"/>
			<xsl:if test="$strFormat = 'CCYYMMDDHHMMSS'">
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring($strDate,9,2)"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="substring($strDate,11,2)"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="substring($strDate,13,2)"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Template, joka tulostaa tilinumeroita (IBAN ryhmiteltyn� ja muut sellaisenaan). -->
	<xsl:template name="OutputEpiAccountID">
		<xsl:param name="theAccount"/>
		<xsl:variable name="strAccount" select="string($theAccount)"/>
		<xsl:variable name="strScheme" select="string($theAccount/@IdentificationSchemeName)"/>
		<xsl:variable name="lenAccount" select="string-length($strAccount)"/>
		<xsl:choose>
			<xsl:when test="$strScheme = 'IBAN'">
				<xsl:choose>
					<xsl:when test="$lenAccount &lt; 5">
						<xsl:value-of select="$strAccount"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($strAccount, 1, 4)"/>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="$lenAccount &lt; 9">
								<xsl:value-of select="substring($strAccount, 5, $lenAccount - 4)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring($strAccount, 5, 4)"/>
								<xsl:text> </xsl:text>
								<xsl:choose>
									<xsl:when test="$lenAccount &lt; 13">
										<xsl:value-of select="substring($strAccount, 9, $lenAccount - 8)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring($strAccount, 9, 4)"/>
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when test="$lenAccount &lt; 17">
												<xsl:value-of select="substring($strAccount, 13, $lenAccount - 12)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring($strAccount, 13, 4)"/>
												<xsl:text> </xsl:text>
												<xsl:choose>
													<xsl:when test="$lenAccount &lt; 21">
														<xsl:value-of select="substring($strAccount, 17, $lenAccount - 16)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring($strAccount, 17, 4)"/>
														<xsl:text> </xsl:text>
														<xsl:value-of select="substring($strAccount, 21, $lenAccount - 20)"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="($strScheme = 'BBAN') and ($lenAccount = 14) and (string-length(translate($strAccount, '0123456789', '')) = 0)">
				<xsl:value-of select="substring($strAccount, 1, 6)"/>-<xsl:value-of select="substring($strAccount, 7, 8)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$strAccount"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka tulostaa rahasumman rahayksik�n kera. -->
	<xsl:template name="OutputAmount">
		<xsl:param name="theAmount"/>
		<xsl:param name="suppressCurrency"/>
		<xsl:variable name="strAmount" select="string($theAmount)"/>
		<xsl:if test="string-length($strAmount) != 0">
			<xsl:value-of select="$strAmount"/>
			<xsl:if test="string-length($suppressCurrency) = 0">
				<xsl:variable name="strCurrency" select="string($theAmount/@AmountCurrencyIdentifier)"/>
				<xsl:if test="string-length($strCurrency) != 0">
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="$strCurrency = 'EUR'">
							<xsl:value-of select="$txtEur"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$strCurrency"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputAmountWithoutCurrency">
		<xsl:param name="theAmount"/>
		<xsl:call-template name="OutputAmount">
			<xsl:with-param name="theAmount" select="$theAmount"/>
			<xsl:with-param name="suppressCurrency" select="'1'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="OutputUnitAmountWithoutCurrency">
		<xsl:param name="theAmount"/>
		<xsl:variable name="strAmount">
			<xsl:call-template name="OutputAmount">
				<xsl:with-param name="theAmount" select="$theAmount"/>
				<xsl:with-param name="suppressCurrency" select="'1'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="string-length($strAmount) != 0">
			<xsl:value-of select="$strAmount"/>
			<xsl:variable name="strUnitCode" select="string($theAmount/@UnitPriceUnitCode)"/>
			<xsl:if test="string-length($strUnitCode) != 0">
				<xsl:text> / </xsl:text><xsl:value-of select="$strUnitCode"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputPercentage">
		<xsl:param name="thePercentage"/>
		<xsl:param name="suppressZero"/>
		<xsl:param name="theBaseAmount"/>
		<xsl:if test="string-length($thePercentage) != 0">
			<xsl:variable name="theOutput">
				<xsl:choose>
					<xsl:when test="string-length($suppressZero) = 0">
						<xsl:value-of select="$thePercentage"/><xsl:text> %</xsl:text>
					</xsl:when>
					<xsl:when test="string-length(translate($thePercentage, '0,. ', '')) != 0">
						<xsl:value-of select="$thePercentage"/><xsl:text> %</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="string-length($theOutput) != 0">
				<xsl:value-of select="$theOutput"/><xsl:if test="string-length($theBaseAmount)!=0"><xsl:text> </xsl:text>(<xsl:value-of select="$txtBaseAmount"/><xsl:text> </xsl:text><xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$theBaseAmount"/></xsl:call-template>)</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputQuantity">
		<xsl:param name="theQuantity"/>
		<xsl:call-template name="BuildString">
			<xsl:with-param name="txtText" select="string($theQuantity)"/>
			<xsl:with-param name="txtText2" select="string($theQuantity/@QuantityUnitCode)"/>
			<xsl:with-param name="txtText2NotAlone" select="'1'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template, joka osaa muokata s�hk�postiosoitetta -->
	<xsl:template name="FormatEmail">
		<xsl:param name="email"/>
		<xsl:variable name="email_lc" select="translate($email,'MAILTO','mailto')"/>
		<xsl:choose>
			<xsl:when test="(starts-with($email_lc,'mailto:')=true())">
				<xsl:call-template name="OutputEmail">
					<xsl:with-param name="email_a" select="$email"/>
					<xsl:with-param name="email_d" select="substring-after($email,':')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="OutputEmail">
					<xsl:with-param name="email_a" select="concat('mailto:',$email)"/>
					<xsl:with-param name="email_d" select="$email"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka osaa tulostaa s�hk�postiosoitteen linkkin�. -->
	<xsl:template name="OutputEmail">
		<xsl:param name="email_a"/>
		<xsl:param name="email_d"/>
		<xsl:if test="string-length(normalize-space($email_d)) != 0">
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:value-of select="$email_a"/></xsl:attribute>
				<xsl:value-of select="$email_d"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- Template, joka osaa muokata webbiosoitetta -->
	<xsl:template name="FormatLink">
		<xsl:param name="link"/>
		<xsl:param name="text"/>
		<xsl:variable name="link_lc" select="translate($link,'HTTPS','https')"/>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($link)) = 0">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:when test="(starts-with($link_lc,'http:')=true() or starts-with($link_lc,'https:')=true())">
				<xsl:call-template name="OutputLink">
					<xsl:with-param name="link_a" select="$link"/>
					<xsl:with-param name="text" select="$text"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="OutputLink">
					<xsl:with-param name="link_a" select="concat('http://',$link)"/>
					<xsl:with-param name="text" select="$text"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka osaa tulostaa webbisivun linkkin�. -->
	<xsl:template name="OutputLink">
		<xsl:param name="link_a"/>
		<xsl:param name="text"/>
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="$link_a"/></xsl:attribute>
			<xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
			<xsl:choose>
				<xsl:when test="string-length($text) != 0">
					<xsl:value-of select="$text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$txtLink"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- Template, joka osaa tulostaa tekstin nelj�n merkin ryhmin�. -->
	<xsl:template name="OutputGrouped4">
		<xsl:param name="theText"/>
		<xsl:param name="isFirst"/>
		<xsl:variable name="len" select="string-length($theText)"/>
		<xsl:choose>
			<xsl:when test="$len &lt; 5">
				<xsl:value-of select="$theText"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($theText, 1, 4)"/><xsl:text> </xsl:text>
				<xsl:call-template name="OutputGrouped4">
					<xsl:with-param name="theText" select="substring($theText, 5)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka osaa tulostaa blankottoman ja etunollattoman viitenumeron ryhmiteltyn�. -->
	<xsl:template name="OutputEpiRemittanceInfoIdentifierGrouped">
		<xsl:param name="erii"/>
		<xsl:param name="isFirst"/>
		<xsl:variable name="len" select="string-length($erii)"/>
		<xsl:choose>
			<xsl:when test="($len &lt; 5) or (($len = 5) and (isFirst != 0))">
				<xsl:value-of select="$erii"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($erii, 1, 1)"/>
				<xsl:if test="(($len - 1) mod 5) = 0">
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:call-template name="OutputEpiRemittanceInfoIdentifierGrouped">
					<xsl:with-param name="erii" select="substring($erii, 2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka osaa tulostaa blankottoman viitenumeron (etunollilla tai ilman). -->
	<xsl:template name="OutputSpacelessEpiRemittanceInfoIdentifier">
		<xsl:param name="erii"/>
		<xsl:choose>
			<xsl:when test="starts-with($erii,'0')=true()">
				<xsl:call-template name="OutputEpiRemittanceInfoIdentifier">
					<xsl:with-param name="erii" select="substring($erii, 2)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($erii,'RF')=true()">
				<xsl:call-template name="OutputGrouped4">
					<xsl:with-param name="theText" select="$erii"/>
					<xsl:with-param name="isFirst">1</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="OutputEpiRemittanceInfoIdentifierGrouped">
					<xsl:with-param name="erii" select="$erii"/>
					<xsl:with-param name="isFirst">1</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template, joka osaa tulostaa viitenumeron (etunollilla tai ilman). -->
	<xsl:template name="OutputEpiRemittanceInfoIdentifier">
		<xsl:param name="erii"/>
		<xsl:call-template name="OutputSpacelessEpiRemittanceInfoIdentifier">
			<xsl:with-param name="erii" select="translate($erii, ' ', '')"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template, joka tulostaa otsikkotiedon. -->
	<xsl:template name="OutputTitle">
		<xsl:param name="invoiceTypeText"/>
		<xsl:param name="originCode"/>
		<xsl:param name="originText"/>
		<xsl:variable name="theTypeText">
			<xsl:choose>
				<xsl:when test="($invoiceTypeText = 'LASKU') or
											($invoiceTypeText = 'Lasku') or
											($invoiceTypeText = 'lasku') or
											($invoiceTypeText = 'FAKTURA') or
											($invoiceTypeText = 'Faktura') or
											($invoiceTypeText = 'faktura') or
											($invoiceTypeText = 'INVOICE') or
											($invoiceTypeText = 'Invoice') or
											($invoiceTypeText = 'invoice')">
					<xsl:value-of select="$txtINVOICE"/>
				</xsl:when>
				<xsl:when test="($invoiceTypeText = 'HYVITYSLASKU') or
											($invoiceTypeText = 'Hyvityslasku') or
											($invoiceTypeText = 'hyvityslasku') or
											($invoiceTypeText = 'KREDITERING') or
											($invoiceTypeText = 'Kreditering') or
											($invoiceTypeText = 'kreditering') or
											($invoiceTypeText = 'CREDIT NOTE') or
											($invoiceTypeText = 'Credit Note') or
											($invoiceTypeText = 'Credit note') or
											($invoiceTypeText = 'credit note')">
					<xsl:value-of select="$txtCREDITNOTE"/>
				</xsl:when>
				<xsl:when test="($invoiceTypeText = 'SUORAMAKSU') or
											($invoiceTypeText = 'Suoramaksu') or
											($invoiceTypeText = 'suoramaksu') or
											($invoiceTypeText = 'DIREKTBETALNING') or
											($invoiceTypeText = 'Direktbetalning') or
											($invoiceTypeText = 'direktbetalning') or
											($invoiceTypeText = 'DIRECT PAYMENT') or
											($invoiceTypeText = 'Direct Payment') or
											($invoiceTypeText = 'Direct payment') or
											($invoiceTypeText = 'direct payment')">
					<xsl:value-of select="$txtDIRECTPAYMENT"/>
				</xsl:when>
				<xsl:when test="($invoiceTypeText = 'LUOTTAMUKSELLINEN') or
											($invoiceTypeText = 'Luottamuksellinen') or
											($invoiceTypeText = 'luottamuksellinen') or
											($invoiceTypeText = 'KONFIDENTIELL') or
											($invoiceTypeText = 'Konfidentiell') or
											($invoiceTypeText = 'konfidentiell') or
											($invoiceTypeText = 'CONFIDENTIAL') or
											($invoiceTypeText = 'Confidential') or
											($invoiceTypeText = 'confidential')">
					<xsl:value-of select="$txtCONFIDENTIAL"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$invoiceTypeText"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="theOriginText">
			<xsl:if test="($originCode = 'Copy') or ($originCode = 'Cancel')">
				<xsl:choose>
					<xsl:when test="($originText = 'KOPIO') or
												($originText = 'Kopio') or
												($originText = 'kopio') or
												($originText = 'KOPIA') or
												($originText = 'Kopia') or
												($originText = 'kopia') or
												($originText = 'COPY')  or
												($originText = 'Copy')  or
												($originText = 'copy')">
						<xsl:value-of select="$txtCOPY"/>
					</xsl:when>
					<xsl:when test="($originText = 'PERUUTUS') or
												($originText = 'Peruutus') or
												($originText = 'peruutus') or
												($originText = 'ANNULLERING') or
												($originText = 'Annullering') or
												($originText = 'annullering') or
												($originText = 'CANCELLATION')  or
												($originText = 'Cancellation')  or
												($originText = 'cancellation') or
												($originText = 'CANCEL')  or
												($originText = 'Cancel')  or
												($originText = 'cancel')">
						<xsl:value-of select="$txtCANCEL"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$originText"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="$theTypeText"/>
		<xsl:if test="string-length($theOriginText) != 0">
			(<xsl:value-of select="$theOriginText"/>)
		</xsl:if>
	</xsl:template>
	<!-- Template, joka tulostaa laskurivin (InvoiceRow tai SubInvoiceRow) tietoja. -->
	<xsl:template name="OutputRow">
		<xsl:param name="styleName"/>
		<xsl:param name="addEmptyRow"/>
		<xsl:param name="articleIdentifier"/>
		<xsl:param name="articleGroupIdentifier"/>
		<xsl:param name="articleName"/>
		<xsl:param name="articleInfoUrlText"/>
		<xsl:param name="buyerArticleIdentifier"/>
		<xsl:param name="eanCode"/>
		<xsl:param name="rowRegistrationNumberIdentifier"/>
		<xsl:param name="serialNumberIdentifier"/>
		<xsl:param name="rowActionCode"/>
		<xsl:param name="rowDefinitions"/>
		<xsl:param name="offeredQuantity"/>
		<xsl:param name="deliveredQuantity"/>
		<xsl:param name="orderedQuantity"/>
		<xsl:param name="confirmedQuantity"/>
		<xsl:param name="postDeliveredQuantity"/>
		<xsl:param name="invoicedQuantity"/>
		<xsl:param name="creditRequestedQuantity"/>
		<xsl:param name="returnedQuantity"/>
		<xsl:param name="startDate"/>
		<xsl:param name="endDate"/>
		<xsl:param name="unitPriceAmount"/>
		<xsl:param name="unitPriceVatIncludedAmount"/>
		<xsl:param name="unitPriceBaseQuantity"/>
		<xsl:param name="rowIdentifier"/>
		<xsl:param name="rowIdentifierUrlText"/>
		<xsl:param name="rowOrderPositionIdentifier"/>
		<xsl:param name="rowIdentifierDate"/>
		<xsl:param name="originalInvoiceNumber"/>
		<xsl:param name="rowOrdererName"/>
		<xsl:param name="rowSalesPersonName"/>
		<xsl:param name="rowOrderConfirmationIdentifier"/>
		<xsl:param name="rowOrderConfirmationDate"/>
		<xsl:param name="rowDeliveryIdentifier"/>
		<xsl:param name="rowDeliveryIdentifierUrlText"/>
		<xsl:param name="rowDeliveryDate"/>
		<xsl:param name="rowQuotationIdentifier"/>
		<xsl:param name="rowQuotationIdentifierUrlText"/>
		<xsl:param name="rowAgreementIdentifier"/>
		<xsl:param name="rowAgreementIdentifierUrlText"/>
		<xsl:param name="rowRequestOfQuotationIdentifier"/>
		<xsl:param name="rowRequestOfQuotationIdentifierUrlText"/>
		<xsl:param name="rowPriceListIdentifier"/>
		<xsl:param name="rowPriceListIdentifierUrlText"/>
		<xsl:param name="rowProjectReferenceIdentifier"/>
		<xsl:param name="rowModeOfTransportIdentifier"/>
		<xsl:param name="rowTerminalAddressText"/>
		<xsl:param name="rowTransportInformationDate"/>
		<xsl:param name="rowWaybillIdentifier"/>
		<xsl:param name="rowWaybillTypeCode"/>
		<xsl:param name="rowWaybillMakerText"/>
		<xsl:param name="rowClearanceIdentifier"/>
		<xsl:param name="rowDeliveryNoteIdentifier"/>
		<xsl:param name="rowDelivererIdentifier"/>
		<xsl:param name="rowDelivererName"/>
		<xsl:param name="rowDelivererCountryCode"/>
		<xsl:param name="rowDelivererCountryName"/>
		<xsl:param name="rowCountryOfOrigin"/>
		<xsl:param name="rowPlaceOfDischarge"/>
		<xsl:param name="rowCountryOfDestinationName"/>
		<xsl:param name="rowFinalDestinationName"/>
		<xsl:param name="rowCustomsInfo"/>
		<xsl:param name="rowManufacturerArticleIdentifier"/>
		<xsl:param name="rowManufacturerIdentifier"/>
		<xsl:param name="rowManufacturerName"/>
		<xsl:param name="rowManufacturerCountryCode"/>
		<xsl:param name="rowManufacturerCountryName"/>
		<xsl:param name="rowManufacturerOrderIdentifier"/>
		<xsl:param name="rowPackageLength"/>
		<xsl:param name="rowPackageWidth"/>
		<xsl:param name="rowPackageHeight"/>
		<xsl:param name="rowPackageWeight"/>
		<xsl:param name="rowPackageNetWeight"/>
		<xsl:param name="rowPackageVolume"/>
		<xsl:param name="rowTransportCarriageQuantity"/>
		<xsl:param name="rowShortProposedAccountIdentifier"/>
		<xsl:param name="rowNormalProposedAccountIdentifier"/>
		<xsl:param name="rowProposedAccountText"/>
		<xsl:param name="rowAccountDimensionText"/>
		<xsl:param name="rowSellerAccountText"/>
		<xsl:param name="rowUsedQuantity"/>
		<xsl:param name="rowPreviousMeterReadingDate"/>
		<xsl:param name="rowLatestMeterReadingDate"/>
		<xsl:param name="rowCalculatedQuantity"/>
		<xsl:param name="rowAveragePriceAmount"/>
		<xsl:param name="rowDiscounts"/>
		<xsl:param name="rowVatRatePercent"/>
		<xsl:param name="rowVatCode"/>
		<xsl:param name="rowVatAmount"/>
		<xsl:param name="rowVatExcludedAmount"/>
		<xsl:param name="rowAmount"/>
		<xsl:param name="rowTransactionDetails"/>
		<xsl:if test="string-length($addEmptyRow) != 0">
			<xsl:element name="tr">
				<xsl:attribute name="class"><xsl:value-of select="$styleName"/> rowSeparator</xsl:attribute>
				<td colspan="8"></td>
			</xsl:element>
		</xsl:if>
		<xsl:variable name="RowPartHTML">
			<xsl:element name="tr">
				<xsl:attribute name="class"><xsl:value-of select="$styleName"/> details</xsl:attribute>
				<td class="multiData">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtArticleName"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="FormatLink">
								<xsl:with-param name="link" select="$articleInfoUrlText"/>
								<xsl:with-param name="text" select="$articleName"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowIdentifier"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="BuildString">
								<xsl:with-param name="txtText" select="$rowIdentifier"/>
								<xsl:with-param name="txtTextUrl" select="$rowIdentifierUrlText"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtRowOrderPositionIdentifier"/>
						<xsl:with-param name="theData" select="string($rowOrderPositionIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowIdentifierDate"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputDate">
								<xsl:with-param name="theDate" select="$rowIdentifierDate"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtOfferedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$offeredQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtOrderedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$orderedQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtConfirmedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$confirmedQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:variable name="rowOrderCIdDate">
						<xsl:choose>
							<xsl:when test="(string-length(normalize-space($rowOrderConfirmationIdentifier)) != 0) and (string-length(normalize-space($rowOrderConfirmationDate)) != 0)">2</xsl:when>
							<xsl:when test="(string-length(normalize-space($rowOrderConfirmationIdentifier)) != 0) or (string-length(normalize-space($rowOrderConfirmationDate)) != 0)">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$rowOrderCIdDate != '0'">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="isNewVersion" select="'1'"/>
							<xsl:with-param name="theTitle" select="$txtOrderConfirmationIdentifier"/>
							<xsl:with-param name="theData">
								<xsl:value-of select="$rowOrderConfirmationIdentifier"/>
								<xsl:if test="$rowOrderCIdDate = '2'"><br/></xsl:if><xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$rowOrderConfirmationDate"/></xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPostDeliveredQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$postDeliveredQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtInvoicedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$invoicedQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtCreditRequestedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$creditRequestedQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtReturnedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$returnedQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtAgreementIdentifier"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="BuildString">
								<xsl:with-param name="txtText" select="$rowAgreementIdentifier"/>
								<xsl:with-param name="txtTextUrl" select="$rowAgreementIdentifierUrlText"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtOrdererName"/>
						<xsl:with-param name="theData" select="string($rowOrdererName)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtSalesPersonName"/>
						<xsl:with-param name="theData" select="string($rowSalesPersonName)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtOriginalInvoice"/>
						<xsl:with-param name="theData" select="string($originalInvoiceNumber)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtManufacturer"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$rowManufacturerName"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="string($rowManufacturerIdentifier)"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtTextCopy">
									<xsl:call-template name="BuildCountryString">
										<xsl:with-param name="theCountryCode" select="$rowManufacturerCountryCode"/>
										<xsl:with-param name="theCountryName" select="$rowManufacturerCountryName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtManufacturerArticleId"/>
						<xsl:with-param name="theData" select="string($rowManufacturerArticleIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtManufacturerOrderId"/>
						<xsl:with-param name="theData" select="string($rowManufacturerOrderIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageLength"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowPackageLength"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageWidth"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowPackageWidth"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageHeight"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowPackageHeight"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageWeight"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowPackageWeight"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageNetWeight"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowPackageNetWeight"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPackageVolume"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowPackageVolume"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtTransportCarriageQuantity"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowTransportCarriageQuantity"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td class="multiData">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtArticleIdentifier"/>
						<xsl:with-param name="theData" select="string($articleIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtBuyerArticleIdentifier"/>
						<xsl:with-param name="theData" select="string($buyerArticleIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowQuotationIdentifier"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="FormatLink">
								<xsl:with-param name="link" select="$rowQuotationIdentifierUrlText"/>
								<xsl:with-param name="text" select="$rowQuotationIdentifier"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowUsedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowUsedQuantity"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowPreviousMeterReadingDate"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$rowPreviousMeterReadingDate"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowLatestMeterReadingDate"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$rowLatestMeterReadingDate"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowCalculatedQuantity"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$rowCalculatedQuantity"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPriceListIdentifier"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="BuildString">
								<xsl:with-param name="txtText" select="$rowPriceListIdentifier"/>
								<xsl:with-param name="txtTextUrl" select="$rowPriceListIdentifierUrlText"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRequestOfQuotationIdentifier"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="BuildString">
								<xsl:with-param name="txtText" select="$rowRequestOfQuotationIdentifier"/>
								<xsl:with-param name="txtTextUrl" select="$rowRequestOfQuotationIdentifierUrlText"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtProjectRefId"/>
						<xsl:with-param name="theData" select="string($rowProjectReferenceIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowActionCode"/>
						<xsl:with-param name="theData" select="string($rowActionCode)"/>
					</xsl:call-template>
					<xsl:if test="string-length(normalize-space($rowDefinitions)) != 0">
						<xsl:copy-of select="$rowDefinitions"/>
					</xsl:if>
				</td>
				<td class="multiData">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveredQuantity"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$deliveredQuantity">
								<xsl:if test="position()!=1"><br/></xsl:if><xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="."/></xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowDeliveryDates"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputDatePeriod">
								<xsl:with-param name="theDate" select="$rowDeliveryDate"/>
								<xsl:with-param name="theStartDate" select="$startDate"/>
								<xsl:with-param name="theEndDate" select="$endDate"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowDeliveryIdentifier"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="FormatLink">
								<xsl:with-param name="link" select="$rowDeliveryIdentifierUrlText"/>
								<xsl:with-param name="text" select="$rowDeliveryIdentifier"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtArticleGroupIdentifier"/>
						<xsl:with-param name="theData" select="string($articleGroupIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtEanCode"/>
						<xsl:with-param name="theData" select="string($eanCode)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRegistrationNumberId"/>
						<xsl:with-param name="theData" select="string($rowRegistrationNumberIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtSerialNumberId"/>
						<xsl:with-param name="theData" select="string($serialNumberIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliverer"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$rowDelivererName"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtText" select="string($rowDelivererIdentifier)"/>
							</xsl:call-template>
							<xsl:call-template name="OutputTextBR">
								<xsl:with-param name="txtTextCopy">
									<xsl:call-template name="BuildCountryString">
										<xsl:with-param name="theCountryCode" select="$rowDelivererCountryCode"/>
										<xsl:with-param name="theCountryName" select="$rowDelivererCountryName"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtModeOfTransportIdentifier"/>
						<xsl:with-param name="theData" select="string($rowModeOfTransportIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtTerminalAddress"/>
						<xsl:with-param name="theData" select="string($rowTerminalAddressText)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtTransportInformationDate"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputDate">
								<xsl:with-param name="theDate" select="$rowTransportInformationDate"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtWaybillIdentifier"/>
						<xsl:with-param name="theData" select="string($rowWaybillIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtWaybillTypeCode"/>
						<xsl:with-param name="theData" select="string($rowWaybillTypeCode)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtClearanceId"/>
						<xsl:with-param name="theData" select="string($rowClearanceIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtDeliveryNoteId"/>
						<xsl:with-param name="theData" select="string($rowDeliveryNoteIdentifier)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtCountryOfOrigin"/>
						<xsl:with-param name="theData" select="string($rowCountryOfOrigin)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtPlaceOfDischarge"/>
						<xsl:with-param name="theData" select="string($rowPlaceOfDischarge)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtCountryOfDestinationName"/>
						<xsl:with-param name="theData" select="string($rowCountryOfDestinationName)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtFinalDestination"/>
						<xsl:with-param name="theData">
							<xsl:for-each select="$rowFinalDestinationName"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:for-each select="$rowCustomsInfo">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="isNewVersion" select="'1'"/>
							<xsl:with-param name="theTitle" select="$txtRowCustomsInfo"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputTextBR">
									<xsl:with-param name="txtText" select="CNName"/>
								</xsl:call-template>
								<xsl:call-template name="OutputTextBR">
									<xsl:with-param name="txtTitle" select="$txtCNCode"/>
									<xsl:with-param name="txtText" select="CNCode"/>
								</xsl:call-template>
								<xsl:call-template name="OutputTextBR">
									<xsl:with-param name="txtTitle" select="$txtCNOriginCountryName"/>
									<xsl:with-param name="txtTextCopy">
										<xsl:call-template name="BuildCountryString">
											<xsl:with-param name="theCountryCode" select="CNOriginCountryCode"/>
											<xsl:with-param name="theCountryName" select="CNOriginCountryName"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</td>
				<td class="multiData">
					<xsl:variable name="formUnitPriceAmount">
						<xsl:if test="string-length(normalize-space($unitPriceAmount)) != 0">
							<xsl:call-template name="BuildString">
								<xsl:with-param name="txtText">
									<xsl:call-template name="OutputUnitAmountWithoutCurrency">
										<xsl:with-param name="theAmount" select="$unitPriceAmount"/>
									</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="txtText2">
									<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$unitPriceBaseQuantity"/></xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="formRowVatExcludedAmount">
						<xsl:call-template name="OutputAmountWithoutCurrency">
							<xsl:with-param name="theAmount" select="$rowVatExcludedAmount"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="(string-length($formUnitPriceAmount) != 0) and (string-length($formRowVatExcludedAmount) != 0)">
							<xsl:call-template name="OutputColContent">
								<xsl:with-param name="theTitle" select="$txtUnitPriceAndAmount"/>
								<xsl:with-param name="theData">
									<xsl:call-template name="BuildString">
										<xsl:with-param name="txtText" select="$formUnitPriceAmount"/>
										<xsl:with-param name="txtText2">
											<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$unitPriceBaseQuantity"/></xsl:call-template><xsl:text> =&gt; </xsl:text><xsl:value-of select="$formRowVatExcludedAmount"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="string-length($formUnitPriceAmount) != 0">
							<xsl:call-template name="OutputColContent">
								<xsl:with-param name="theTitle" select="$txtUnitPriceAmount"/>
								<xsl:with-param name="theData">
									<xsl:call-template name="BuildString">
										<xsl:with-param name="txtText" select="$formUnitPriceAmount"/>
										<xsl:with-param name="txtText2">
											<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$unitPriceBaseQuantity"/></xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="string-length($formRowVatExcludedAmount) != 0">
							<xsl:call-template name="OutputColContent">
								<xsl:with-param name="theTitle" select="$txtVatExcludedAmount"/>
								<xsl:with-param name="theData" select="$formRowVatExcludedAmount"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="string-length(normalize-space($unitPriceVatIncludedAmount)) != 0">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle" select="$txtUnitPriceVatIncludedAmount"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="BuildString">
									<xsl:with-param name="txtText">
										<xsl:call-template name="OutputUnitAmountWithoutCurrency">
											<xsl:with-param name="theAmount" select="$unitPriceVatIncludedAmount"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="txtText2">
										<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$unitPriceBaseQuantity"/></xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtAveragePrice"/>
						<xsl:with-param name="theData" select="string($rowAveragePriceAmount)"/>
					</xsl:call-template>
					<xsl:if test="string-length(normalize-space($rowDiscounts)) != 0">
						<xsl:copy-of select="$rowDiscounts"/>
					</xsl:if>
					<xsl:if test="(string-length($rowShortProposedAccountIdentifier) != 0) or (string-length($rowNormalProposedAccountIdentifier) != 0) or (string-length($rowAccountDimensionText) != 0) or (string-length($rowSellerAccountText) != 0)">
						<xsl:variable name="accounts">
							<xsl:if test="string-length($rowShortProposedAccountIdentifier) != 0">
								<xsl:value-of select="$rowShortProposedAccountIdentifier"/>
								<xsl:if test="(string-length($rowNormalProposedAccountIdentifier) != 0) or (string-length($rowAccountDimensionText) != 0)">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>
							<xsl:if test="string-length($rowNormalProposedAccountIdentifier) != 0">
								<xsl:value-of select="$rowNormalProposedAccountIdentifier"/>
								<xsl:if test="string-length($rowAccountDimensionText) != 0">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:if>
							<xsl:if test="string-length($rowAccountDimensionText) != 0">
								<xsl:value-of select="$rowAccountDimensionText"/>
							</xsl:if>
						</xsl:variable>
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle" select="$txtProposedAccountIdentifier"/>
							<xsl:with-param name="theData" select="$accounts"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtProposedAccountIdentifier"/>
						<xsl:with-param name="theData" select="string($rowProposedAccountText)"/>
					</xsl:call-template>
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="$txtSellerAccountText"/>
						<xsl:with-param name="theData" select="string($rowSellerAccountText)"/>
					</xsl:call-template>
				</td>
				<td class="multiData">
					<xsl:if test="string-length($rowVatRatePercent)!=0">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle">
								<xsl:value-of select="$txtVat"/><xsl:if test="string-length($rowVatCode)!=0"><xsl:text> </xsl:text>(<xsl:value-of select="$rowVatCode"/>)</xsl:if>
							</xsl:with-param>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputVatCodeText">
									<xsl:with-param name="vatCode" select="$rowVatCode"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle" select="$txtVatAmount"/>
							<xsl:with-param name="theData">
								<xsl:value-of select="$rowVatAmount"/><xsl:text> (</xsl:text><xsl:value-of select="$rowVatRatePercent"/><xsl:text> %)</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</td>
				<td class="RowAmount">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="$txtRowAmount"/>
						<xsl:with-param name="theData" select="string($rowAmount)"/>
					</xsl:call-template>
					<xsl:if test="$rowTransactionDetails">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="isNewVersion" select="'1'"/>
							<xsl:with-param name="theTitle" select="$txtRowOtherCurrencyAmount"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$rowTransactionDetails/OtherCurrencyAmount"/></xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="isNewVersion" select="'1'"/>
							<xsl:with-param name="theTitle" select="$txtExchangeRate"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$rowTransactionDetails/ExchangeRate"/></xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="isNewVersion" select="'1'"/>
							<xsl:with-param name="theTitle" select="$txtExchangeDate"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$rowTransactionDetails/ExchangeDate"/></xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</td>
			</xsl:element>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($RowPartHTML)) != 0">
			<xsl:copy-of select="$RowPartHTML"/>
		</xsl:if>
	</xsl:template>
	<!-- Template, joka tulostaa laskurivin alennustiedot. -->
	<xsl:template name="OutputRowDiscount">
		<xsl:param name="discountNumber"/>
		<xsl:param name="rowDiscountTypeText"/>
		<xsl:param name="rowDiscountTypeCode"/>
		<xsl:param name="rowDiscountPercent"/>
		<xsl:param name="rowDiscountAmount"/>
		<xsl:variable name="strPercentage">
			<xsl:call-template name="OutputPercentage"><xsl:with-param name="thePercentage" select="$rowDiscountPercent"/><xsl:with-param name="suppressZero" select="'1'"/></xsl:call-template>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($rowDiscountTypeText)) + string-length($strPercentage) + string-length(normalize-space($rowDiscountAmount)) != 0">
			<xsl:variable name="theTypecode"><xsl:if test="string-length($rowDiscountTypeCode) != 0"><xsl:text> (</xsl:text><xsl:value-of select="$rowDiscountTypeCode"/><xsl:text>)</xsl:text></xsl:if></xsl:variable>
			<xsl:call-template name="OutputColContent">
				<xsl:with-param name="theTitle">
					<xsl:choose>
						<xsl:when test="string-length(normalize-space($rowDiscountTypeText)) != 0">
							<xsl:value-of select="$rowDiscountTypeText"/><xsl:value-of select="$theTypecode"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$txtRowDiscount"/><xsl:value-of select="$discountNumber"/><xsl:value-of select="$theTypecode"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="theData">
					<xsl:if test="string-length($strPercentage) != 0">
						<xsl:value-of select="$strPercentage"/><xsl:text>:  </xsl:text>
					</xsl:if>
					<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$rowDiscountAmount"/></xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- Template, joka kokoaa merkkijonon. -->
	<xsl:template name="BuildString">
		<xsl:param name="txtTitle"/>
		<xsl:param name="txtText"/>
		<xsl:param name="txtTextUrl"/>
		<xsl:param name="txtTextDelimiter"/>
		<xsl:param name="txtText2"/>
		<xsl:param name="txtText2NotAlone"/>
		<xsl:if test="(string-length(normalize-space($txtText)) != 0) or ((string-length(normalize-space($txtText2))  != 0) and (string-length($txtText2NotAlone) = 0))">
			<xsl:if test="string-length(normalize-space($txtTitle)) != 0">
				<xsl:value-of select="$txtTitle"/><xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:if test="string-length(normalize-space($txtText)) != 0">
				<xsl:call-template name="FormatLink">
					<xsl:with-param name="link" select="$txtTextUrl"/>
					<xsl:with-param name="text" select="$txtText"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="string-length(normalize-space($txtText2)) != 0">
				<xsl:if test="string-length(normalize-space($txtText)) != 0">
					<xsl:text> </xsl:text>
					<xsl:if test="string-length($txtTextDelimiter) != 0">
						<xsl:value-of select="$txtTextDelimiter"/>
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:value-of select="$txtText2"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="BuildCountryString">
		<xsl:param name="theCountryCode"/>
		<xsl:param name="theCountryName"/>
		<xsl:param name="buildFinland"/>
		<xsl:variable name="ccode" select="string($theCountryCode)"/>
		<xsl:if test="($ccode != 'FI') or (string-length($buildFinland) != 0)">
			<xsl:value-of select="$theCountryName"/>
			<!--
			<xsl:call-template name="BuildString">
				<xsl:with-param name="txtText" select="$theCountryCode"/>
				<xsl:with-param name="txtTextDelimiter">/</xsl:with-param>
				<xsl:with-param name="txtText2" select="$theCountryName"/>
			</xsl:call-template>
			-->
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputSomething">
		<xsl:param name="isNewVersion"/>
		<xsl:param name="theDataCopy"/>
		<xsl:param name="appendBR"/>
		<xsl:if test="string-length($theDataCopy) != 0">
			<xsl:choose>
				<xsl:when test="string-length($isNewVersion) != 0">
					<xsl:element name="span">
						<xsl:attribute name="class">isNewVersion</xsl:attribute>
						<xsl:copy-of select="$theDataCopy"/>
					</xsl:element>
					<xsl:if test="string-length($appendBR) != 0">
						<br/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$theDataCopy"/>
					<xsl:if test="string-length($appendBR) != 0">
						<br/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- Template, joka tulostaa tekstin ja rivinvaihdon. -->
	<xsl:template name="OutputCurrentTextBR">
		<xsl:param name="isNewVersion"/>
		<xsl:call-template name="OutputSomething">
			<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
			<xsl:with-param name="theDataCopy" select="string(.)"/>
			<xsl:with-param name="appendBR" select="'1'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="OutputTextBR">
		<xsl:param name="isNewVersion"/>
		<xsl:param name="txtTitle"/>
		<xsl:param name="txtText"/>
		<xsl:param name="txtTextCopy"/>
		<xsl:variable name="theText">
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($txtText)) != 0">
					<xsl:if test="string-length(normalize-space($txtTitle)) != 0">
						<xsl:value-of select="$txtTitle"/><xsl:text>: </xsl:text>
					</xsl:if>
					<xsl:value-of select="$txtText"/>
				</xsl:when>
				<xsl:when test="string-length(normalize-space($txtTextCopy)) != 0">
					<xsl:if test="string-length(normalize-space($txtTitle)) != 0">
						<xsl:value-of select="$txtTitle"/><xsl:text>: </xsl:text>
					</xsl:if>
					<xsl:copy-of select="$txtTextCopy"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="OutputSomething">
			<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
			<xsl:with-param name="theDataCopy" select="string($theText)"/>
			<xsl:with-param name="appendBR" select="'1'"/>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="OutputTextBR">
		<xsl:param name="txtTitle"/>
		<xsl:param name="txtText"/>
		<xsl:param name="txtTextCopy"/>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($txtText)) != 0">
				<xsl:if test="string-length(normalize-space($txtTitle)) != 0">
					<xsl:value-of select="$txtTitle"/><xsl:text>: </xsl:text>
				</xsl:if>
				<xsl:value-of select="$txtText"/><br/>
			</xsl:when>
			<xsl:when test="string-length(normalize-space($txtTextCopy)) != 0">
				<xsl:if test="string-length(normalize-space($txtTitle)) != 0">
					<xsl:value-of select="$txtTitle"/><xsl:text>: </xsl:text>
				</xsl:if>
				<xsl:copy-of select="$txtTextCopy"/><br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	-->
	<!-- Template, joka tulostaa dataa sis�lt�v�n DIVin. -->
	<xsl:template name="OutputDataDiv">
		<xsl:param name="isNewVersion"/>
		<xsl:param name="theData"/>
		<xsl:if test="string-length(normalize-space($theData)) != 0">
			<div class="data">
				<xsl:call-template name="OutputSomething">
					<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
					<xsl:with-param name="theDataCopy" select="$theData"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- Template, joka tulostaa AnyParty-tiedot. -->
	<xsl:template name="OutputAnyPartyDetails">
		<xsl:param name="info"/>
		<xsl:param name="anyPartyText"/>
		<xsl:param name="anyPartyTextAnyPartyCode"/>
		<xsl:param name="anyPartyIdentifier"/>
		<xsl:param name="anyPartyOrganisationName"/>
		<xsl:param name="anyPartyOrganisationDepartment"/>
		<xsl:param name="anyPartyOrganisationTaxCode"/>
		<xsl:param name="anyPartyCode"/>
		<xsl:param name="anyPartyOrganisationUnitNumber"/>
		<xsl:param name="anyPartySiteCode"/>
		<xsl:param name="anyPartyStreetName"/>
		<xsl:param name="anyPartyTownName"/>
		<xsl:param name="anyPartyPostCodeIdentifier"/>
		<xsl:param name="countryCode"/>
		<xsl:param name="countryName"/>
		<xsl:param name="anyPartyPostOfficeBoxIdentifier"/>
		<xsl:param name="anyPartyContactPersonName"/>
		<xsl:param name="anyPartyContactPersonFunction"/>
		<xsl:param name="anyPartyContactPersonDepartment"/>
		<xsl:param name="anyPartyEmailaddressIdentifier"/>
		<xsl:param name="anyPartyPhoneNumberIdentifier"/>
		<table class="AnyParty">
			<tbody>
				<xsl:element name="tr">
					<td class="title" colspan="2">
						<xsl:value-of select="$anyPartyText"/>
						<xsl:if test="string-length(normalize-space($anyPartyTextAnyPartyCode)) != 0">
							<xsl:text> </xsl:text>(<xsl:value-of select="$anyPartyTextAnyPartyCode"/>)
						</xsl:if>
						<xsl:if test="string-length(normalize-space($info)) != 0">
							<xsl:text> </xsl:text>(<xsl:value-of select="$info"/>)
						</xsl:if>
						:
					</td>
				</xsl:element>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtPartyIdentifier"/>
					<xsl:with-param name="theData" select="string($anyPartyIdentifier)"/>
				</xsl:call-template>
				<xsl:if test="string-length($anyPartyCode) != 0">
					<xsl:call-template name="OutputTitleDataRow">
						<xsl:with-param name="isNewVersion" select="'1'"/>
						<xsl:with-param name="theTitle" select="string($anyPartyCode/@IdentifierType)"/>
						<xsl:with-param name="theData" select="string($anyPartyCode)"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="isNewVersion" select="'1'"/>
					<xsl:with-param name="theTitle" select="$txtTaxCode"/>
					<xsl:with-param name="theData" select="string($anyPartyOrganisationTaxCode)"/>
				</xsl:call-template>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtAnyPartyOrgName"/>
					<xsl:with-param name="theData">
						<xsl:for-each select="$anyPartyOrganisationName"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtAnyPartyOrgDep"/>
					<xsl:with-param name="theData">
						<xsl:for-each select="$anyPartyOrganisationDepartment"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtAddress"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputTextBR">
							<xsl:with-param name="txtText" select="$anyPartyPostOfficeBoxIdentifier"/>
						</xsl:call-template>
						<xsl:for-each select="$anyPartyStreetName"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
						<xsl:call-template name="OutputTextBR">
							<xsl:with-param name="txtTextCopy">
								<xsl:call-template name="BuildString">
									<xsl:with-param name="txtText" select="$anyPartyPostCodeIdentifier"/>
									<xsl:with-param name="txtTextDelimiter">/</xsl:with-param>
									<xsl:with-param name="txtText2" select="$anyPartyTownName"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputTextBR">
							<xsl:with-param name="txtTextCopy">
								<xsl:call-template name="BuildCountryString">
									<xsl:with-param name="theCountryCode" select="$countryCode"/>
									<xsl:with-param name="theCountryName" select="$countryName"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtContact"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputTextBR">
							<xsl:with-param name="txtText" select="$anyPartyContactPersonName"/>
						</xsl:call-template>
						<xsl:if test="$anyPartyContactPersonFunction">
							<xsl:for-each select="$anyPartyContactPersonFunction"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
						</xsl:if>
						<xsl:if test="$anyPartyContactPersonDepartment">
							<xsl:for-each select="$anyPartyContactPersonDepartment"><xsl:call-template name="OutputCurrentTextBR"/></xsl:for-each>
						</xsl:if>
						<xsl:call-template name="OutputTextBR">
							<xsl:with-param name="txtTextCopy">
								<xsl:call-template name="FormatEmail">
									<xsl:with-param name="email" select="$anyPartyEmailaddressIdentifier"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputTextBR">
							<xsl:with-param name="txtText" select="$anyPartyPhoneNumberIdentifier"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtOrganisationUnitNumber"/>
					<xsl:with-param name="theData" select="string($anyPartyOrganisationUnitNumber)"/>
				</xsl:call-template>
				<xsl:call-template name="OutputTitleDataRow">
					<xsl:with-param name="theTitle" select="$txtSiteCode"/>
					<xsl:with-param name="theData" select="string($anyPartySiteCode)"/>
				</xsl:call-template>
			</tbody>
		</table>
	</xsl:template>
	<!-- Template, joka tulostaa laskutason AnyPartyDetails-tiedot. -->
	<xsl:template name="OutputInvoiceAnyPartyDetails">
		<xsl:call-template name="OutputAnyPartyDetails">
			<xsl:with-param name="info"/>
			<xsl:with-param name="anyPartyText" select="AnyPartyText"/>
			<xsl:with-param name="anyPartyTextAnyPartyCode" select="AnyPartyText/@AnyPartyCode"/>
			<xsl:with-param name="anyPartyIdentifier" select="AnyPartyIdentifier"/>
			<xsl:with-param name="anyPartyOrganisationName" select="AnyPartyOrganisationName"/>
			<xsl:with-param name="anyPartyOrganisationDepartment" select="AnyPartyOrganisationDepartment"/>
			<xsl:with-param name="anyPartyOrganisationTaxCode" select="AnyPartyOrganisationTaxCode"/>
			<xsl:with-param name="anyPartyCode" select="AnyPartyCode"/>
			<xsl:with-param name="anyPartyOrganisationUnitNumber" select="AnyPartyOrganisationUnitNumber"/>
			<xsl:with-param name="anyPartySiteCode" select="AnyPartySiteCode"/>
			<xsl:with-param name="anyPartyStreetName" select="AnyPartyPostalAddressDetails/AnyPartyStreetName"/>
			<xsl:with-param name="anyPartyTownName" select="AnyPartyPostalAddressDetails/AnyPartyTownName"/>
			<xsl:with-param name="anyPartyPostCodeIdentifier" select="AnyPartyPostalAddressDetails/AnyPartyPostCodeIdentifier"/>
			<xsl:with-param name="countryCode" select="AnyPartyPostalAddressDetails/CountryCode"/>
			<xsl:with-param name="countryName" select="AnyPartyPostalAddressDetails/CountryName"/>
			<xsl:with-param name="anyPartyPostOfficeBoxIdentifier" select="AnyPartyPostalAddressDetails/AnyPartyPostOfficeBoxIdentifier"/>
			<xsl:with-param name="anyPartyContactPersonName" select="AnyPartyContactPersonName"/>
			<xsl:with-param name="anyPartyContactPersonFunction" select="AnyPartyContactPersonFunction"/>
			<xsl:with-param name="anyPartyContactPersonDepartment" select="AnyPartyContactPersonDepartment"/>
			<xsl:with-param name="anyPartyEmailaddressIdentifier" select="AnyPartyCommunicationDetails/AnyPartyEmailaddressIdentifier"/>
			<xsl:with-param name="anyPartyPhoneNumberIdentifier" select="AnyPartyCommunicationDetails/AnyPartyPhoneNumberIdentifier"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template, joka tulostaa RowAnyPartyDetails-tiedot. -->
	<xsl:template name="OutputRowAnyPartyDetails">
		<xsl:call-template name="OutputAnyPartyDetails">
			<xsl:with-param name="info" select="$txtInvoiceRow"/>
			<xsl:with-param name="anyPartyText" select="RowAnyPartyText"/>
			<xsl:with-param name="anyPartyTextAnyPartyCode" select="RowAnyPartyText/@AnyPartyCode"/>
			<xsl:with-param name="anyPartyIdentifier" select="RowAnyPartyIdentifier"/>
			<xsl:with-param name="anyPartyOrganisationName" select="RowAnyPartyOrganisationName"/>
			<xsl:with-param name="anyPartyOrganisationDepartment" select="RowAnyPartyOrganisationDepartment"/>
			<xsl:with-param name="anyPartyOrganisationTaxCode" select="RowAnyPartyOrganisationTaxCode"/>
			<xsl:with-param name="anyPartyOrganisationUnitNumber" select="RowAnyPartyOrganisationUnitNumber"/>
			<xsl:with-param name="anyPartySiteCode" select="RowAnyPartySiteCode"/>
			<xsl:with-param name="anyPartyStreetName" select="RowAnyPartyPostalAddressDetails/RowAnyPartyStreetName"/>
			<xsl:with-param name="anyPartyTownName" select="RowAnyPartyPostalAddressDetails/RowAnyPartyTownName"/>
			<xsl:with-param name="anyPartyPostCodeIdentifier" select="RowAnyPartyPostalAddressDetails/RowAnyPartyPostCodeIdentifier"/>
			<xsl:with-param name="countryCode" select="RowAnyPartyPostalAddressDetails/CountryCode"/>
			<xsl:with-param name="countryName" select="RowAnyPartyPostalAddressDetails/CountryName"/>
			<xsl:with-param name="anyPartyPostOfficeBoxIdentifier" select="RowAnyPartyPostalAddressDetails/RowAnyPartyPostOfficeBoxIdentifier"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template, joka tulostaa SubRowAnyPartyDetails-tiedot. -->
	<xsl:template name="OutputSubRowAnyPartyDetails">
		<xsl:call-template name="OutputAnyPartyDetails">
			<xsl:with-param name="info"/>
			<xsl:with-param name="anyPartyText" select="SubRowAnyPartyText"/>
			<xsl:with-param name="anyPartyTextAnyPartyCode" select="SubRowAnyPartyText/@AnyPartyCode"/>
			<xsl:with-param name="anyPartyIdentifier" select="SubRowAnyPartyIdentifier"/>
			<xsl:with-param name="anyPartyOrganisationName" select="SubRowAnyPartyOrganisationName"/>
			<xsl:with-param name="anyPartyOrganisationDepartment" select="SubRowAnyPartyOrganisationDepartment"/>
			<xsl:with-param name="anyPartyOrganisationTaxCode" select="SubRowAnyPartyOrganisationTaxCode"/>
			<xsl:with-param name="anyPartyOrganisationUnitNumber" select="SubRowAnyPartyOrganisationUnitNumber"/>
			<xsl:with-param name="anyPartySiteCode" select="SubRowAnyPartySiteCode"/>
			<xsl:with-param name="anyPartyStreetName" select="SubRowAnyPartyPostalAddressDetails/SubRowAnyPartyStreetName"/>
			<xsl:with-param name="anyPartyTownName" select="SubRowAnyPartyPostalAddressDetails/SubRowAnyPartyTownName"/>
			<xsl:with-param name="anyPartyPostCodeIdentifier" select="SubRowAnyPartyPostalAddressDetails/SubRowAnyPartyPostCodeIdentifier"/>
			<xsl:with-param name="countryCode" select="SubRowAnyPartyPostalAddressDetails/CountryCode"/>
			<xsl:with-param name="countryName" select="SubRowAnyPartyPostalAddressDetails/CountryName"/>
			<xsl:with-param name="anyPartyPostOfficeBoxIdentifier" select="SubRowAnyPartyPostalAddressDetails/SubRowAnyPartyPostOfficeBoxIdentifier"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template, joka tulostaa korkolaskun tiedot. -->
	<xsl:template name="OutputRowOverDuePaymentDetails">
		<xsl:param name="styleName"/>
		<xsl:param name="addEmptyRow"/>
		<xsl:param name="rowOriginalInvoiceIdentifier"/>
		<xsl:param name="originalInvoiceDate"/>
		<xsl:param name="originalDueDate"/>
		<xsl:param name="originalInvoiceTotalAmount"/>
		<xsl:param name="rowOriginalEpiRemittanceInfoIdentifier"/>
		<xsl:param name="paidVatIncludedAmount"/>
		<xsl:param name="paidVatExcludedAmount"/>
		<xsl:param name="paidDate"/>
		<xsl:param name="unPaidVatIncludedAmount"/>
		<xsl:param name="unPaidVatExcludedAmount"/>
		<xsl:param name="collectionDate"/>
		<xsl:param name="collectionQuantity"/>
		<xsl:param name="collectionChargeAmount"/>
		<xsl:param name="rowInterestRate"/>
		<xsl:param name="interestStartDate"/>
		<xsl:param name="interestEndDate"/>
		<xsl:param name="rowInterestPeriodText"/>
		<xsl:param name="rowInterestDateNumber"/>
		<xsl:param name="interestChargeAmount"/>
		<xsl:param name="interestChargeVatAmount"/>
		<xsl:if test="string-length($addEmptyRow) != 0">
			<xsl:element name="tr">
				<xsl:attribute name="class"><xsl:value-of select="$styleName"/> rowSeparator</xsl:attribute>
				<td colspan="6"></td>
			</xsl:element>
		</xsl:if>
		<xsl:element name="tr">
			<xsl:attribute name="class"><xsl:value-of select="$styleName"/></xsl:attribute>
			<td class="multiData">
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtOriginalInvoiceIdentifier"/>
					<xsl:with-param name="theData" select="string($rowOriginalInvoiceIdentifier)"/>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtOriginalInvoiceDate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$originalInvoiceDate"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtOriginalDueDate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$originalDueDate"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtOriginalInvoiceTotalAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$originalInvoiceTotalAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtOriginalEpiRemittanceInfoIdentifier"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputEpiRemittanceInfoIdentifier">
							<xsl:with-param name="erii" select="$rowOriginalEpiRemittanceInfoIdentifier"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td class="multiData">
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="isNewVersion" select="'1'"/>
					<xsl:with-param name="theTitle" select="$txtPaidVatExcludedAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$paidVatExcludedAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtPaidAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$paidVatIncludedAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtPaidDate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$paidDate"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="isNewVersion" select="'1'"/>
					<xsl:with-param name="theTitle" select="$txtUnPaidVatExcludedAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$unPaidVatExcludedAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtUnPaidAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$unPaidVatIncludedAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td class="multiData">
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtCollectionDate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$collectionDate"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtCollectionQuantity"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="$collectionQuantity"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtCollectionChargeAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$collectionChargeAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td class="multiData">
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestRate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputPercentage">
							<xsl:with-param name="thePercentage" select="$rowInterestRate"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestStartDate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$interestStartDate"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestEndDate"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputDate"><xsl:with-param name="theDate" select="$interestEndDate"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestPeriodText"/>
					<xsl:with-param name="theData" select="string($rowInterestPeriodText)"/>
				</xsl:call-template>
			</td>
			<td class="multiData">
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestDateNumber"/>
					<xsl:with-param name="theData" select="string($rowInterestDateNumber)"/>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestChargeAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$interestChargeAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="$txtInterestChargeVatAmount"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputAmount"><xsl:with-param name="theAmount" select="$interestChargeVatAmount"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td class="multiData"></td>
		</xsl:element>
	</xsl:template>
	<xsl:template name="OutputColContent">
		<xsl:param name="isNewVersion"/>
		<xsl:param name="theTitle"/>
		<xsl:param name="theData"/>
		<xsl:if test="string-length($theData)!=0">
			<xsl:element name="div">
				<xsl:attribute name="class">title</xsl:attribute>
				<!--<xsl:copy-of select="$theTitle"/>-->
				<xsl:call-template name="OutputSomething">
					<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
					<xsl:with-param name="theDataCopy" select="$theTitle"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="div">
				<xsl:attribute name="class">data</xsl:attribute>
				<!--<xsl:copy-of select="$theData"/>-->
				<xsl:call-template name="OutputSomething">
					<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
					<xsl:with-param name="theDataCopy" select="$theData"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputVatCodeText">
		<xsl:param name="vatCode"/>
		<xsl:variable name="theText">
			<xsl:choose>
				<xsl:when test="$vatCode='AB'"><xsl:value-of select="$txtVatCode_AB"/></xsl:when>
				<xsl:when test="$vatCode='AE'"><xsl:value-of select="$txtVatCode_AE"/></xsl:when>
				<xsl:when test="$vatCode='E'"><xsl:value-of select="$txtVatCode_E"/></xsl:when>
				<xsl:when test="$vatCode='G'"><xsl:value-of select="$txtVatCode_G"/></xsl:when>
				<xsl:when test="$vatCode='O'"><xsl:value-of select="$txtVatCode_O"/></xsl:when>
				<xsl:when test="$vatCode='S'"><xsl:value-of select="$txtVatCode_S"/></xsl:when>
				<xsl:when test="$vatCode='Z'"><xsl:value-of select="$txtVatCode_Z"/></xsl:when>
				<xsl:when test="$vatCode='ZEG'"><xsl:value-of select="$txtVatCode_ZEG"/></xsl:when>
				<xsl:when test="$vatCode='ZES'"><xsl:value-of select="$txtVatCode_ZES"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($theText)!=0">
			<xsl:element name="div">
				<xsl:attribute name="class">VatCodeText</xsl:attribute>
				<xsl:value-of select="$theText"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputTitleDataRow">
		<xsl:param name="isNewVersion"/>
		<xsl:param name="theClass"/>
		<xsl:param name="theTitle"/>
		<xsl:param name="theTitleSeparator" select="':'"/>
		<xsl:param name="theData"/>
		<xsl:param name="emptyDataAlso"/>
		<xsl:if test="(string-length($theData)!=0) or (string-length($emptyDataAlso)!=0)">
			<xsl:element name="tr">
				<xsl:if test="string-length($theClass)!=0">
					<xsl:attribute name="class">
						<xsl:value-of select="$theClass"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:element name="td">
					<xsl:attribute name="class">title</xsl:attribute>
					<!--<xsl:if test="string-length($theTitle)!=0"><xsl:copy-of select="$theTitle"/><xsl:copy-of select="$theTitleSeparator"/></xsl:if>-->
					<xsl:if test="string-length($theTitle)!=0">
						<xsl:call-template name="OutputSomething">
							<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
							<xsl:with-param name="theDataCopy"><xsl:copy-of select="$theTitle"/><xsl:copy-of select="$theTitleSeparator"/></xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:element>
				<xsl:element name="td">
					<xsl:attribute name="class">data</xsl:attribute>
					<!--<xsl:copy-of select="$theData"/>-->
					<xsl:call-template name="OutputSomething">
						<xsl:with-param name="isNewVersion" select="$isNewVersion"/>
						<xsl:with-param name="theDataCopy" select="$theData"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputTitleDataRowSeparator">
		<xsl:param name="theClass" select="'groupSeparator'"/>
		<xsl:element name="tr">
			<xsl:attribute name="class">
				<xsl:value-of select="$theClass"/>
			</xsl:attribute>
			<xsl:element name="td"></xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="OutputDefinitionDetails">
		<xsl:variable name="countDD" select="count(InvoiceDetails/DefinitionDetails)"/>
		<xsl:if test="$countDD != 0">
			<xsl:variable name="nDDCol1" select="$countDD - floor($countDD div 2)"/>
			<xsl:variable name="definitionDetailsCol1">
				<xsl:for-each select="InvoiceDetails/DefinitionDetails">
					<xsl:if test="position() &lt;= $nDDCol1">
						<xsl:call-template name="OutputTitleDataRow">
							<xsl:with-param name="theTitle" select="string(DefinitionHeaderText)"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DefinitionValue"/></xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="definitionDetailsCol2">
				<xsl:for-each select="InvoiceDetails/DefinitionDetails">
					<xsl:if test="position() &gt; $nDDCol1">
						<xsl:call-template name="OutputTitleDataRow">
							<xsl:with-param name="theTitle" select="string(DefinitionHeaderText)"/>
							<xsl:with-param name="theData">
								<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="DefinitionValue"/></xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="(string-length($definitionDetailsCol1) != 0) or (string-length($definitionDetailsCol2) != 0)">
				<div class="DefinitionDetails">
					<table class="DefinitionDetails">
						<tr>
							<xsl:if test="string-length($definitionDetailsCol1) != 0">
								<td class="DefinitionValue">
									<table class="DefinitionValue">
										<xsl:copy-of select="$definitionDetailsCol1"/>
									</table>
								</td>
							</xsl:if>
							<xsl:if test="string-length($definitionDetailsCol2) != 0">
								<td class="DefinitionValue">
									<table class="DefinitionValue">
										<xsl:copy-of select="$definitionDetailsCol2"/>
									</table>
								</td>
							</xsl:if>
						</tr>
					</table>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputInvoiceRow">
		<xsl:param name="invoiceRowPos"/>
		<xsl:variable name="hasOverDue">
			<xsl:choose>
				<xsl:when test="RowOverDuePaymentDetails">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$hasOverDue = 1">
			<xsl:call-template name="OutputRowOverDuePaymentDetails">
				<xsl:with-param name="styleName" select="'InvoiceRow'"/>
				<xsl:with-param name="addEmptyRow">
					<xsl:if test="$invoiceRowPos != 1">1</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="rowOriginalInvoiceIdentifier" select="RowOverDuePaymentDetails/RowOriginalInvoiceIdentifier"/>
				<xsl:with-param name="originalInvoiceDate" select="RowOverDuePaymentDetails/RowOriginalInvoiceDate"/>
				<xsl:with-param name="originalDueDate" select="RowOverDuePaymentDetails/RowOriginalDueDate"/>
				<xsl:with-param name="originalInvoiceTotalAmount" select="RowOverDuePaymentDetails/RowOriginalInvoiceTotalAmount"/>
				<xsl:with-param name="rowOriginalEpiRemittanceInfoIdentifier" select="RowOverDuePaymentDetails/RowOriginalEpiRemittanceInfoIdentifier"/>
				<xsl:with-param name="paidVatIncludedAmount" select="RowOverDuePaymentDetails/RowPaidVatIncludedAmount"/>
				<xsl:with-param name="paidVatExcludedAmount" select="RowOverDuePaymentDetails/RowPaidVatExcludedAmount"/>
				<xsl:with-param name="paidDate" select="RowOverDuePaymentDetails/RowPaidDate"/>
				<xsl:with-param name="unPaidVatIncludedAmount" select="RowOverDuePaymentDetails/RowUnPaidVatIncludedAmount"/>
				<xsl:with-param name="unPaidVatExcludedAmount" select="RowOverDuePaymentDetails/RowUnPaidVatExcludedAmount"/>
				<xsl:with-param name="collectionDate" select="RowOverDuePaymentDetails/RowCollectionDate"/>
				<xsl:with-param name="collectionQuantity" select="RowOverDuePaymentDetails/RowCollectionQuantity" />
				<xsl:with-param name="collectionChargeAmount" select="RowOverDuePaymentDetails/RowCollectionChargeAmount"/>
				<xsl:with-param name="rowInterestRate" select="RowOverDuePaymentDetails/RowInterestRate"/>
				<xsl:with-param name="interestStartDate" select="RowOverDuePaymentDetails/RowInterestStartDate"/>
				<xsl:with-param name="interestEndDate" select="RowOverDuePaymentDetails/RowInterestEndDate"/>
				<xsl:with-param name="rowInterestPeriodText" select="RowOverDuePaymentDetails/RowInterestPeriodText"/>
				<xsl:with-param name="rowInterestDateNumber" select="RowOverDuePaymentDetails/RowInterestDateNumber"/>
				<xsl:with-param name="interestChargeAmount" select="RowOverDuePaymentDetails/RowInterestChargeAmount"/>
				<xsl:with-param name="interestChargeVatAmount" select="RowOverDuePaymentDetails/RowInterestChargeVatAmount"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:variable name="rowDefinitions">
			<xsl:for-each select="RowDefinitionDetails">
				<xsl:call-template name="OutputColContent">
					<xsl:with-param name="theTitle" select="string(RowDefinitionHeaderText)"/>
					<xsl:with-param name="theData">
						<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="RowDefinitionValue"/></xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="discount1">
			<xsl:call-template name="OutputRowDiscount">
				<xsl:with-param name="discountNumber">1</xsl:with-param>
				<xsl:with-param name="rowDiscountTypeText" select="RowDiscountTypeText"/>
				<xsl:with-param name="rowDiscountTypeCode" select="RowDiscountTypeCode"/>
				<xsl:with-param name="rowDiscountPercent" select="RowDiscountPercent"/>
				<xsl:with-param name="rowDiscountAmount" select="RowDiscountAmount"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="discountOffset">
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($discount1)) = 0">0</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="discounts">
			<xsl:if test="$discountOffset = 1"><xsl:copy-of select="$discount1"/></xsl:if>
			<xsl:for-each select="RowProgressiveDiscountDetails">
				<xsl:call-template name="OutputRowDiscount">
					<xsl:with-param name="discountNumber" select="position() + $discountOffset"/>
					<xsl:with-param name="rowDiscountTypeText" select="RowDiscountTypeText"/>
					<xsl:with-param name="rowDiscountTypeCode" select="RowDiscountTypeCode"/>
					<xsl:with-param name="rowDiscountPercent" select="RowDiscountPercent"/>
					<xsl:with-param name="rowDiscountAmount" select="RowDiscountAmount"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="invoiceRowHTML">
			<xsl:call-template name="OutputRow">
				<xsl:with-param name="styleName">InvoiceRow</xsl:with-param>
				<xsl:with-param name="addEmptyRow">
					<xsl:if test="(position() != 1) or ($hasOverDue = 1)">1</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="articleIdentifier" select="ArticleIdentifier"/>
				<xsl:with-param name="articleGroupIdentifier" select="ArticleGroupIdentifier"/>
				<xsl:with-param name="articleName" select="ArticleName"/>
				<xsl:with-param name="articleInfoUrlText" select="ArticleInfoUrlText"/>
				<xsl:with-param name="buyerArticleIdentifier" select="BuyerArticleIdentifier"/>
				<xsl:with-param name="eanCode" select="EanCode"/>
				<xsl:with-param name="rowRegistrationNumberIdentifier" select="RowRegistrationNumberIdentifier"/>
				<xsl:with-param name="serialNumberIdentifier" select="SerialNumberIdentifier"/>
				<xsl:with-param name="rowActionCode" select="RowActionCode"/>
				<xsl:with-param name="rowDefinitions" select="$rowDefinitions"/>
				<xsl:with-param name="offeredQuantity" select="OfferedQuantity"/>
				<xsl:with-param name="deliveredQuantity" select="DeliveredQuantity"/>
				<xsl:with-param name="orderedQuantity" select="OrderedQuantity"/>
				<xsl:with-param name="confirmedQuantity" select="ConfirmedQuantity"/>
				<xsl:with-param name="postDeliveredQuantity" select="PostDeliveredQuantity"/>
				<xsl:with-param name="invoicedQuantity" select="InvoicedQuantity"/>
				<xsl:with-param name="creditRequestedQuantity" select="CreditRequestedQuantity"/>
				<xsl:with-param name="returnedQuantity" select="ReturnedQuantity"/>
				<xsl:with-param name="startDate" select="StartDate"/>
				<xsl:with-param name="endDate" select="EndDate"/>
				<xsl:with-param name="unitPriceAmount" select="UnitPriceAmount"/>
				<xsl:with-param name="unitPriceVatIncludedAmount" select="UnitPriceVatIncludedAmount"/>
				<xsl:with-param name="unitPriceBaseQuantity" select="UnitPriceBaseQuantity"/>
				<xsl:with-param name="rowIdentifier" select="RowIdentifier"/>
				<xsl:with-param name="rowIdentifierUrlText" select="RowIdentifierUrlText"/>
				<xsl:with-param name="rowOrderPositionIdentifier" select="RowOrderPositionIdentifier"/>
				<xsl:with-param name="rowIdentifierDate" select="RowIdentifierDate"/>
				<xsl:with-param name="originalInvoiceNumber" select="OriginalInvoiceNumber"/>
				<xsl:with-param name="rowOrdererName" select="RowOrdererName"/>
				<xsl:with-param name="rowSalesPersonName" select="RowSalesPersonName"/>
				<xsl:with-param name="rowOrderConfirmationIdentifier" select="RowOrderConfirmationIdentifier"/>
				<xsl:with-param name="rowOrderConfirmationDate" select="RowOrderConfirmationDate"/>
				<xsl:with-param name="rowDeliveryIdentifier" select="RowDeliveryIdentifier"/>
				<xsl:with-param name="rowDeliveryIdentifierUrlText" select="RowDeliveryIdentifierUrlText"/>
				<xsl:with-param name="rowDeliveryDate" select="RowDeliveryDate"/>
				<xsl:with-param name="rowQuotationIdentifier" select="RowQuotationIdentifier"/>
				<xsl:with-param name="rowQuotationIdentifierUrlText" select="RowQuotationIdentifierUrlText"/>
				<xsl:with-param name="rowAgreementIdentifier" select="RowAgreementIdentifier"/>
				<xsl:with-param name="rowAgreementIdentifierUrlText" select="RowAgreementIdentifierUrlText"/>
				<xsl:with-param name="rowRequestOfQuotationIdentifier" select="RowRequestOfQuotationIdentifier"/>
				<xsl:with-param name="rowRequestOfQuotationIdentifierUrlText" select="RowRequestOfQuotationIdentifierUrlText"/>
				<xsl:with-param name="rowPriceListIdentifier" select="RowPriceListIdentifier"/>
				<xsl:with-param name="rowPriceListIdentifierUrlText" select="RowPriceListIdentifierUrlText"/>
				<xsl:with-param name="rowProjectReferenceIdentifier" select="RowProjectReferenceIdentifier"/>
				<xsl:with-param name="rowModeOfTransportIdentifier" select="RowDeliveryDetails/RowModeOfTransportIdentifier"/>
				<xsl:with-param name="rowTerminalAddressText" select="RowDeliveryDetails/RowTerminalAddressText"/>
				<xsl:with-param name="rowTransportInformationDate" select="RowDeliveryDetails/RowTransportInformationDate"/>
				<xsl:with-param name="rowWaybillIdentifier" select="RowDeliveryDetails/RowWaybillIdentifier"/>
				<xsl:with-param name="rowWaybillTypeCode" select="RowDeliveryDetails/RowWaybillTypeCode"/>
				<xsl:with-param name="rowWaybillMakerText" select="RowDeliveryDetails/RowWaybillMakerText"/>
				<xsl:with-param name="rowClearanceIdentifier" select="RowDeliveryDetails/RowClearanceIdentifier"/>
				<xsl:with-param name="rowDeliveryNoteIdentifier" select="RowDeliveryDetails/RowDeliveryNoteIdentifier"/>
				<xsl:with-param name="rowDelivererIdentifier" select="RowDeliveryDetails/RowDelivererIdentifier"/>
				<xsl:with-param name="rowDelivererName" select="RowDeliveryDetails/RowDelivererName"/>
				<xsl:with-param name="rowDelivererCountryCode" select="RowDeliveryDetails/RowDelivererCountryCode"/>
				<xsl:with-param name="rowDelivererCountryName" select="RowDeliveryDetails/RowDelivererCountryName"/>
				<xsl:with-param name="rowCountryOfOrigin" select="RowDeliveryDetails/RowCountryOfOrigin"/>
				<xsl:with-param name="rowPlaceOfDischarge" select="RowDeliveryDetails/RowPlaceOfDischarge"/>
				<xsl:with-param name="rowCountryOfDestinationName" select="RowDeliveryDetails/RowCountryOfDestinationName"/>
				<xsl:with-param name="rowFinalDestinationName" select="RowDeliveryDetails/RowFinalDestinationName"/>
				<xsl:with-param name="rowCustomsInfo" select="RowDeliveryDetails/RowCustomsInfo"/>
				<xsl:with-param name="rowManufacturerArticleIdentifier" select="RowDeliveryDetails/RowManufacturerArticleIdentifier"/>
				<xsl:with-param name="rowManufacturerIdentifier" select="RowDeliveryDetails/RowManufacturerIdentifier"/>
				<xsl:with-param name="rowManufacturerName" select="RowDeliveryDetails/RowManufacturerName"/>
				<xsl:with-param name="rowManufacturerCountryCode" select="RowDeliveryDetails/RowManufacturerCountryCode"/>
				<xsl:with-param name="rowManufacturerCountryName" select="RowDeliveryDetails/RowManufacturerCountryName"/>
				<xsl:with-param name="rowManufacturerOrderIdentifier" select="RowDeliveryDetails/RowManufacturerOrderIdentifier"/>
				<xsl:with-param name="rowPackageLength" select="RowDeliveryDetails/RowPackageDetails/RowPackageLength"/>
				<xsl:with-param name="rowPackageWidth" select="RowDeliveryDetails/RowPackageDetails/RowPackageWidth"/>
				<xsl:with-param name="rowPackageHeight" select="RowDeliveryDetails/RowPackageDetails/RowPackageHeight"/>
				<xsl:with-param name="rowPackageWeight" select="RowDeliveryDetails/RowPackageDetails/RowPackageWeight"/>
				<xsl:with-param name="rowPackageNetWeight" select="RowDeliveryDetails/RowPackageDetails/RowPackageNetWeight"/>
				<xsl:with-param name="rowPackageVolume" select="RowDeliveryDetails/RowPackageDetails/RowPackageVolume"/>
				<xsl:with-param name="rowTransportCarriageQuantity" select="RowDeliveryDetails/RowPackageDetails/RowTransportCarriageQuantity"/>
				<xsl:with-param name="rowShortProposedAccountIdentifier" select="RowShortProposedAccountIdentifier"/>
				<xsl:with-param name="rowNormalProposedAccountIdentifier" select="RowNormalProposedAccountIdentifier"/>
				<xsl:with-param name="rowProposedAccountText" select="RowProposedAccountText"/>
				<xsl:with-param name="rowSellerAccountText" select="RowSellerAccountText"/>
				<xsl:with-param name="rowAccountDimensionText" select="RowAccountDimensionText"/>
				<xsl:with-param name="rowUsedQuantity" select="RowUsedQuantity"/>
				<xsl:with-param name="rowPreviousMeterReadingDate" select="RowPreviousMeterReadingDate"/>
				<xsl:with-param name="rowLatestMeterReadingDate" select="RowLatestMeterReadingDate"/>
				<xsl:with-param name="rowCalculatedQuantity" select="RowCalculatedQuantity"/>
				<xsl:with-param name="rowAveragePriceAmount" select="RowAveragePriceAmount"/>
				<xsl:with-param name="rowDiscounts" select="$discounts"/>
				<xsl:with-param name="rowVatRatePercent" select="RowVatRatePercent"/>
				<xsl:with-param name="rowVatCode" select="RowVatCode"/>
				<xsl:with-param name="rowVatAmount" select="RowVatAmount"/>
				<xsl:with-param name="rowVatExcludedAmount" select="RowVatExcludedAmount"/>
				<xsl:with-param name="rowAmount" select="RowAmount"/>
				<xsl:with-param name="rowTransactionDetails" select="RowTransactionDetails"/>
			</xsl:call-template>
			<xsl:variable name="freeText">
				<xsl:for-each select="RowFreeText">
					<xsl:if test="position() != 1"><br/></xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="string-length(normalize-space($freeText)) != 0">
				<tr class="InvoiceRow freeText">
					<td class="multiData" colspan="8">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle" select="$txtFreeText"/>
							<xsl:with-param name="theData" select="$freeText"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($invoiceRowHTML)) != 0">
			<xsl:copy-of select="$invoiceRowHTML"/>
		</xsl:if>
		<xsl:variable name="countAPD" select="count(RowAnyPartyDetails)"/>
		<xsl:if test="$countAPD != 0">
			<tr class="InvoiceRow AnyPartyDetails">
				<td colspan="8">
					<table class="AnyPartyDetails">
						<xsl:for-each select="RowAnyPartyDetails">
							<xsl:if test="position() mod 2 != 0">
								<xsl:if test="position() != 1">
									<xsl:call-template name="OutputTitleDataRowSeparator"/>
								</xsl:if>
								<tr>
									<td>
										<xsl:call-template name="OutputRowAnyPartyDetails"/>
									</td>
									<td>
										<xsl:variable name="possu" select="position()"/>
										<xsl:if test="$possu &lt; $countAPD">
											<xsl:for-each select="../RowAnyPartyDetails[position() = $possu + 1]">
												<xsl:call-template name="OutputRowAnyPartyDetails"/>
											</xsl:for-each>
										</xsl:if>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</table>
				</td>
			</tr>
		</xsl:if>
		<tr class="InvoiceRow rowBottom">
			<td colspan="8"></td>
		</tr>
	</xsl:template>
	<xsl:template name="OutputSubInvoiceRows">
		<xsl:param name="invoiceRowPos"/>
		<xsl:for-each select="SubInvoiceRow">
			<xsl:variable name="hasOverDue">
				<xsl:choose>
					<xsl:when test="SubRowOverDuePaymentDetails">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$hasOverDue = 1">
				<xsl:call-template name="OutputRowOverDuePaymentDetails">
					<xsl:with-param name="styleName" select="'SubInvoiceRow'"/>
					<xsl:with-param name="addEmptyRow">
						<xsl:if test="($invoiceRowPos != 1) or (position() != 1) or ($hasOverDue = 1)">1</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="rowOriginalInvoiceIdentifier" select="SubRowOverDuePaymentDetails/SubRowOriginalInvoiceIdentifier"/>
					<xsl:with-param name="originalInvoiceDate" select="SubRowOverDuePaymentDetails/SubRowOriginalInvoiceDate"/>
					<xsl:with-param name="originalDueDate" select="SubRowOverDuePaymentDetails/SubRowOriginalDueDate"/>
					<xsl:with-param name="originalInvoiceTotalAmount" select="SubRowOverDuePaymentDetails/SubRowOriginalInvoiceTotalAmount"/>
					<xsl:with-param name="rowOriginalEpiRemittanceInfoIdentifier" select="SubRowOverDuePaymentDetails/SubRowOriginalEpiRemittanceInfoIdentifier"/>
					<xsl:with-param name="paidVatIncludedAmount" select="SubRowOverDuePaymentDetails/SubRowPaidVatIncludedAmount"/>
					<xsl:with-param name="paidVatExcludedAmount" select="SubRowOverDuePaymentDetails/SubRowPaidVatExcludedAmount"/>
					<xsl:with-param name="paidDate" select="SubRowOverDuePaymentDetails/SubRowPaidDate"/>
					<xsl:with-param name="unPaidVatIncludedAmount" select="SubRowOverDuePaymentDetails/SubRowUnPaidVatIncludedAmount"/>
					<xsl:with-param name="unPaidVatExcludedAmount" select="SubRowOverDuePaymentDetails/SubRowUnPaidVatExcludedAmount"/>
					<xsl:with-param name="collectionDate" select="SubRowOverDuePaymentDetails/SubRowCollectionDate"/>
					<xsl:with-param name="collectionQuantity" select="SubRowOverDuePaymentDetails/SubRowCollectionQuantity" />
					<xsl:with-param name="collectionChargeAmount" select="SubRowOverDuePaymentDetails/SubRowCollectionChargeAmount"/>
					<xsl:with-param name="rowInterestRate" select="SubRowOverDuePaymentDetails/SubRowInterestRate"/>
					<xsl:with-param name="interestStartDate" select="SubRowOverDuePaymentDetails/SubRowInterestStartDate"/>
					<xsl:with-param name="interestEndDate" select="SubRowOverDuePaymentDetails/SubRowInterestEndDate"/>
					<xsl:with-param name="rowInterestPeriodText" select="SubRowOverDuePaymentDetails/SubRowInterestPeriodText"/>
					<xsl:with-param name="rowInterestDateNumber" select="SubRowOverDuePaymentDetails/SubRowInterestDateNumber"/>
					<xsl:with-param name="interestChargeAmount" select="SubRowOverDuePaymentDetails/SubRowInterestChargeAmount"/>
					<xsl:with-param name="interestChargeVatAmount" select="SubRowOverDuePaymentDetails/SubRowInterestChargeVatAmount"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:variable name="subRowDefinitions">
				<xsl:for-each select="SubRowDefinitionDetails">
					<xsl:call-template name="OutputColContent">
						<xsl:with-param name="theTitle" select="string(SubRowDefinitionHeaderText)"/>
						<xsl:with-param name="theData">
							<xsl:call-template name="OutputQuantity"><xsl:with-param name="theQuantity" select="SubRowDefinitionValue"/></xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="subDiscount1">
				<xsl:call-template name="OutputRowDiscount">
					<xsl:with-param name="discountNumber">1</xsl:with-param>
					<xsl:with-param name="rowDiscountTypeText" select="SubRowDiscountTypeText"/>
					<xsl:with-param name="rowDiscountTypeCode" select="SubRowDiscountTypeCode"/>
					<xsl:with-param name="rowDiscountPercent" select="SubRowDiscountPercent"/>
					<xsl:with-param name="rowDiscountAmount" select="SubRowDiscountAmount"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="subDiscountOffset">
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($subDiscount1)) = 0">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="subDiscounts">
				<xsl:if test="$subDiscountOffset = 1"><xsl:copy-of select="$subDiscount1"/></xsl:if>
				<xsl:for-each select="SubRowProgressiveDiscountDetails">
					<xsl:call-template name="OutputRowDiscount">
						<xsl:with-param name="discountNumber" select="position() + $subDiscountOffset"/>
						<xsl:with-param name="rowDiscountTypeText" select="SubRowDiscountTypeText"/>
						<xsl:with-param name="rowDiscountTypeCode" select="SubRowDiscountTypeCode"/>
						<xsl:with-param name="rowDiscountPercent" select="SubRowDiscountPercent"/>
						<xsl:with-param name="rowDiscountAmount" select="SubRowDiscountAmount"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="OutputRow">
				<xsl:with-param name="styleName">SubInvoiceRow</xsl:with-param>
				<xsl:with-param name="addEmptyRow" select="'1'"/>
				<xsl:with-param name="articleIdentifier" select="SubArticleIdentifier"/>
				<xsl:with-param name="articleGroupIdentifier" select="SubArticleGroupIdentifier"/>
				<xsl:with-param name="articleName" select="SubArticleName"/>
				<xsl:with-param name="articleInfoUrlText" select="SubArticleInfoUrlText"/>
				<xsl:with-param name="buyerArticleIdentifier" select="SubBuyerArticleIdentifier"/>
				<xsl:with-param name="eanCode" select="SubEanCode"/>
				<xsl:with-param name="rowRegistrationNumberIdentifier" select="SubRowRegistrationNumberIdentifier"/>
				<xsl:with-param name="serialNumberIdentifier" select="SubSerialNumberIdentifier"/>
				<xsl:with-param name="rowActionCode" select="SubRowActionCode"/>
				<xsl:with-param name="rowDefinitions" select="$subRowDefinitions"/>
				<xsl:with-param name="offeredQuantity" select="SubOfferedQuantity"/>
				<xsl:with-param name="deliveredQuantity" select="SubDeliveredQuantity"/>
				<xsl:with-param name="orderedQuantity" select="SubOrderedQuantity"/>
				<xsl:with-param name="confirmedQuantity" select="SubConfirmedQuantity"/>
				<xsl:with-param name="postDeliveredQuantity" select="SubPostDeliveredQuantity"/>
				<xsl:with-param name="invoicedQuantity" select="SubInvoicedQuantity"/>
				<xsl:with-param name="creditRequestedQuantity" select="SubCreditRequestedQuantity"/>
				<xsl:with-param name="returnedQuantity" select="SubReturnedQuantity"/>
				<xsl:with-param name="startDate" select="SubStartDate"/>
				<xsl:with-param name="endDate" select="SubEndDate"/>
				<xsl:with-param name="unitPriceAmount" select="SubUnitPriceAmount"/>
				<xsl:with-param name="unitPriceVatIncludedAmount" select="SubUnitPriceVatIncludedAmount"/>
				<xsl:with-param name="unitPriceBaseQuantity" select="SubUnitPriceBaseQuantity"/>
				<xsl:with-param name="rowIdentifier" select="SubRowIdentifier"/>
				<xsl:with-param name="rowIdentifierUrlText" select="SubRowIdentifierUrlText"/>
				<xsl:with-param name="rowIdentifierDate" select="SubRowIdentifierDate"/>
				<xsl:with-param name="originalInvoiceNumber" select="SubOriginalInvoiceNumber"/>
				<xsl:with-param name="rowOrdererName" select="SubRowOrdererName"/>
				<xsl:with-param name="rowSalesPersonName" select="SubRowSalesPersonName"/>
				<xsl:with-param name="rowOrderConfirmationIdentifier" select="SubRowOrderConfirmationIdentifier"/>
				<xsl:with-param name="rowOrderConfirmationDate" select="SubRowOrderConfirmationDate"/>
				<xsl:with-param name="rowDeliveryIdentifier" select="SubRowDeliveryIdentifier"/>
				<xsl:with-param name="rowDeliveryIdentifierUrlText" select="SubRowDeliveryIdentifierUrlText"/>
				<xsl:with-param name="rowDeliveryDate" select="SubRowDeliveryDate"/>
				<xsl:with-param name="rowQuotationIdentifier" select="SubRowQuotationIdentifier"/>
				<xsl:with-param name="rowQuotationIdentifierUrlText" select="SubRowQuotationIdentifierUrlText"/>
				<xsl:with-param name="rowAgreementIdentifier" select="SubRowAgreementIdentifier"/>
				<xsl:with-param name="rowAgreementIdentifierUrlText" select="SubRowAgreementIdentifierUrlText"/>
				<xsl:with-param name="rowRequestOfQuotationIdentifier" select="SubRowRequestOfQuotationIdentifier"/>
				<xsl:with-param name="rowRequestOfQuotationIdentifierUrlText" select="SubRowRequestOfQuotationIdentifierUrlText"/>
				<xsl:with-param name="rowPriceListIdentifier" select="SubRowPriceListIdentifier"/>
				<xsl:with-param name="rowPriceListIdentifierUrlText" select="SubRowPriceListIdentifierUrlText"/>
				<xsl:with-param name="rowProjectReferenceIdentifier" select="SubRowProjectReferenceIdentifier"/>
				<xsl:with-param name="rowTerminalAddressText" select="SubRowDeliveryDetails/SubRowTerminalAddressText"/>
				<xsl:with-param name="rowWaybillIdentifier" select="SubRowDeliveryDetails/SubRowWaybillIdentifier"/>
				<xsl:with-param name="rowWaybillTypeCode" select="SubRowDeliveryDetails/SubRowWaybillTypeCode"/>
				<xsl:with-param name="rowWaybillMakerText" select="SubRowDeliveryDetails/SubRowWaybillMakerText"/>
				<xsl:with-param name="rowClearanceIdentifier" select="SubRowDeliveryDetails/SubRowClearanceIdentifier"/>
				<xsl:with-param name="rowDeliveryNoteIdentifier" select="SubRowDeliveryDetails/SubRowDeliveryNoteIdentifier"/>
				<xsl:with-param name="rowDelivererIdentifier" select="SubRowDeliveryDetails/SubRowDelivererIdentifier"/>
				<xsl:with-param name="rowDelivererName" select="SubRowDeliveryDetails/SubRowDelivererName"/>
				<xsl:with-param name="rowDelivererCountryCode" select="SubRowDeliveryDetails/SubRowDelivererCountryCode"/>
				<xsl:with-param name="rowDelivererCountryName" select="SubRowDeliveryDetails/SubRowDelivererCountryName"/>
				<xsl:with-param name="rowPlaceOfDischarge" select="SubRowDeliveryDetails/SubRowPlaceOfDischarge"/>
				<xsl:with-param name="rowFinalDestinationName" select="SubRowDeliveryDetails/SubRowFinalDestinationName"/>
				<xsl:with-param name="rowCustomsInfo" select="SubRowDeliveryDetails/SubRowCustomsInfo"/>
				<xsl:with-param name="rowManufacturerArticleIdentifier" select="SubRowDeliveryDetails/SubRowManufacturerArticleIdentifier"/>
				<xsl:with-param name="rowManufacturerIdentifier" select="SubRowDeliveryDetails/SubRowManufacturerIdentifier"/>
				<xsl:with-param name="rowManufacturerName" select="SubRowDeliveryDetails/SubRowManufacturerName"/>
				<xsl:with-param name="rowManufacturerCountryCode" select="SubRowDeliveryDetails/SubRowManufacturerCountryCode"/>
				<xsl:with-param name="rowManufacturerCountryName" select="SubRowDeliveryDetails/SubRowManufacturerCountryName"/>
				<xsl:with-param name="rowManufacturerOrderIdentifier" select="SubRowDeliveryDetails/SubRowManufacturerOrderIdentifier"/>
				<xsl:with-param name="rowPackageLength" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowPackageLength"/>
				<xsl:with-param name="rowPackageWidth" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowPackageWidth"/>
				<xsl:with-param name="rowPackageHeight" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowPackageHeight"/>
				<xsl:with-param name="rowPackageWeight" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowPackageWeight"/>
				<xsl:with-param name="rowPackageNetWeight" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowPackageNetWeight"/>
				<xsl:with-param name="rowPackageVolume" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowPackageVolume"/>
				<xsl:with-param name="rowTransportCarriageQuantity" select="SubRowDeliveryDetails/SubRowPackageDetails/SubRowTransportCarriageQuantity"/>
				<xsl:with-param name="rowShortProposedAccountIdentifier" select="SubRowShortProposedAccountIdentifier"/>
				<xsl:with-param name="rowNormalProposedAccountIdentifier" select="SubRowNormalProposedAccountIdentifier"/>
				<xsl:with-param name="rowProposedAccountText" select="SubRowProposedAccountText"/>
				<xsl:with-param name="rowSellerAccountText" select="SubRowSellerAccountText"/>
				<xsl:with-param name="rowAccountDimensionText" select="SubRowAccountDimensionText"/>
				<xsl:with-param name="rowUsedQuantity" select="SubRowUsedQuantity"/>
				<xsl:with-param name="rowPreviousMeterReadingDate" select="SubRowPreviousMeterReadingDate"/>
				<xsl:with-param name="rowLatestMeterReadingDate" select="SubRowLatestMeterReadingDate"/>
				<xsl:with-param name="rowCalculatedQuantity" select="SubRowCalculatedQuantity"/>
				<xsl:with-param name="rowAveragePriceAmount" select="SubRowAveragePriceAmount"/>
				<xsl:with-param name="rowDiscounts" select="$subDiscounts"/>
				<xsl:with-param name="rowVatRatePercent" select="SubRowVatRatePercent"/>
				<xsl:with-param name="rowVatCode" select="SubRowVatCode"/>
				<xsl:with-param name="rowVatAmount" select="SubRowVatAmount"/>
				<xsl:with-param name="rowVatExcludedAmount" select="SubRowVatExcludedAmount"/>
				<xsl:with-param name="rowAmount" select="SubRowAmount"/>
				<xsl:with-param name="rowTransactionDetails" select="SubRowTransactionDetails"/>
			</xsl:call-template>
			<xsl:variable name="freeText">
				<xsl:for-each select="SubRowFreeText">
					<xsl:if test="position() != 1"><br/></xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="string-length(normalize-space($freeText)) != 0">
				<tr class="SubInvoiceRow freeText">
					<td class="multiData" colspan="8">
						<xsl:call-template name="OutputColContent">
							<xsl:with-param name="theTitle" select="$txtFreeText"/>
							<xsl:with-param name="theData" select="$freeText"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:variable name="countAPD" select="count(SubRowAnyPartyDetails)"/>
			<xsl:if test="$countAPD != 0">
				<tr class="SubInvoiceRow AnyPartyDetails">
					<td colspan="8">
						<table class="AnyPartyDetails">
							<xsl:for-each select="SubRowAnyPartyDetails">
								<xsl:if test="position() mod 2 != 0">
									<xsl:if test="position() != 1">
										<xsl:call-template name="OutputTitleDataRowSeparator"/>
									</xsl:if>
									<tr>
										<td>
											<xsl:call-template name="OutputSubRowAnyPartyDetails"/>
										</td>
										<td>
											<xsl:variable name="possu" select="position()"/>
											<xsl:if test="$possu &lt; $countAPD">
												<xsl:for-each select="../SubRowAnyPartyDetails[position() = $possu + 1]">
													<xsl:call-template name="OutputSubRowAnyPartyDetails"/>
												</xsl:for-each>
											</xsl:if>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</table>
					</td>
				</tr>
			</xsl:if>
			<tr class="SubInvoiceRow rowBottom">
				<td colspan="8"></td>
			</tr>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
