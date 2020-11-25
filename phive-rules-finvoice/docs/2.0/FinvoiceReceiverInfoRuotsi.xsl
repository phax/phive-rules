<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" version="4.01" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<!-- Tekstit alkavat -->
	<xsl:variable name="txtOtsikko">Finvoice-mottagningsmeddelande</xsl:variable>
	<xsl:variable name="txtMessageDate">Datum</xsl:variable>
	<xsl:variable name="txtTimeStamp">Tidst�mpel</xsl:variable>
	<xsl:variable name="txtMessageTypeCode">Typkod</xsl:variable>
	<xsl:variable name="txtMessageTypeText">Meddelandetyp</xsl:variable>
	<xsl:variable name="txtActionCode">�tg�rd</xsl:variable>
	<xsl:variable name="txtADD">Till�gg</xsl:variable>
	<xsl:variable name="txtCHANGE">�ndring</xsl:variable>
	<xsl:variable name="txtDELETE">Radering</xsl:variable>
	<xsl:variable name="txtSenderInfoIdentifier">Fakturarmeddelandets identifierare</xsl:variable>
	<xsl:variable name="txtInvoiceSender">Fakturautst�llarens uppgifter</xsl:variable>
	<xsl:variable name="txtInvoiceSenderAddress">S�ndningsadress</xsl:variable>
	<xsl:variable name="txtInvoiceSenderIntermediatorAddress">F�rmedlarens kod</xsl:variable>
	<xsl:variable name="txtSellerPartyIdentifier">Fakturerarens FO-nummer</xsl:variable>
	<xsl:variable name="txtSellerOrganisationName">Fakturerarens namn</xsl:variable>
	<xsl:variable name="txtSellerOrganisationBankName">Fakturerarens namn i banken</xsl:variable>
	<xsl:variable name="txtKatuosoite">Gatuadress</xsl:variable>
	<xsl:variable name="txtPostiosoite">Postadress</xsl:variable>
	<xsl:variable name="txtPostilokero">Postbox</xsl:variable>
	<xsl:variable name="txtMaa">Land</xsl:variable>
	<xsl:variable name="txtOrganisationUnitNumber">Organisationsenhet</xsl:variable>
	<xsl:variable name="txtWebaddressNameText">Webbplatsens namn</xsl:variable>
	<xsl:variable name="txtWebaddressText">Webbplatsens URL-adress</xsl:variable>
	<xsl:variable name="txtInvoiceDetails">Fakturainformation</xsl:variable>
	<xsl:variable name="txtPaymentInstructionIdentifier">Kod f�r faktureringsgrund</xsl:variable>
	<xsl:variable name="txtSellerInstructionFreeText">Anvisning till mottagaren</xsl:variable>
	<xsl:variable name="txtSellerInvoiceTypeText">Fakturagrund</xsl:variable>
	<xsl:variable name="txtSellerInvoiceIdentifierText">Identifieraruppgift</xsl:variable>
	<xsl:variable name="txtProposedDueDate">F�reslagen f�rfallodag</xsl:variable>
	<xsl:variable name="txtProposedInvoicePeriod">F�reslagen faktureringsperiod</xsl:variable>
	<xsl:variable name="txtProposedInvoicePeriodInfo">(g�nger per �r)</xsl:variable>
	<xsl:variable name="txtSellerDirectDebitIdentifier">Direktdebiteringskod</xsl:variable>
	<xsl:variable name="txtSellerDirectPaymentIdentifier">Direktfakturakod</xsl:variable>
	<xsl:variable name="txtSellerAccountDetails">Fakturerarens bankf�rbindelse</xsl:variable>
	<xsl:variable name="txtTilinumeroJaBIC">Kontonummer och kontobankens BIC</xsl:variable>
	<xsl:variable name="txtTilinumero">Kontonummer</xsl:variable>
	<xsl:variable name="txtBuyerPartyDetails">K�parens uppgifter</xsl:variable>
	<xsl:variable name="txtBuyerPartyIdentifier">FO-nummer / Personbeteckning</xsl:variable>
	<xsl:variable name="txtBuyerOrganisationName">Namn</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientDetails">Fakturamottagarens uppgifter</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientAddress">Mottagningsadress</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientIntermediatorAddress">F�rmedlarens kod</xsl:variable>
	<xsl:variable name="txtSellerInvoiceIdentifier">Identifieraruppgift hos faktureraren</xsl:variable>
	<xsl:variable name="txtEpiRemittanceIdentifier">Betalningens referensnummer</xsl:variable>
	<xsl:variable name="txtViestinTiedot">Meddelandets uppgifter</xsl:variable>
	<xsl:variable name="txtIdConversion">konversion</xsl:variable>
	<xsl:variable name="txtIdMaintenance">underh�ll</xsl:variable>
	<xsl:variable name="txtLanguage">Spr�k</xsl:variable>
	<xsl:variable name="txtSuomi">Finska</xsl:variable>
	<xsl:variable name="txtRuotsi">Svenska</xsl:variable>
	<xsl:variable name="txtEnglanti">Engelska</xsl:variable>
	<xsl:variable name="txtBuyerServiceCode">Tj�nst</xsl:variable>
	<xsl:variable name="txtELasku">E-faktura</xsl:variable>
	<xsl:variable name="txtSuoramaksu">Direktbetalning</xsl:variable>
	<!-- Tekstit loppuivat -->
	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="$txtOtsikko"/></title>
				<style type="text/css">
					.ryhmanOtsikko { font-weight:bold; background-color:#ccccee; color:#000}
					.varitausta { background-color:#eaedff; color:#000; border:1px solid #000}
					.sisennetty { padding-left:10px; }
					td { padding-right:3px; }
				</style>
			</head>
			<body>
				<h2 align="center"><xsl:value-of select="$txtOtsikko"/></h2>  
				<table class="varitausta" width="100%">
					<col align="left" valign="top" width="3%"/>
					<tr>
						<td colspan="4" class="ryhmanOtsikko"><xsl:value-of select="$txtViestinTiedot"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtMessageDate"/>:</td>
						<td><xsl:value-of select="substring(FinvoiceReceiverInfo/MessageDetails/MessageDate,7,2)"/>.<xsl:value-of select="substring(FinvoiceReceiverInfo/MessageDetails/MessageDate,5,2)"/>.<xsl:value-of select="substring(FinvoiceReceiverInfo/MessageDetails/MessageDate,1,4)"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtTimeStamp"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/ReceiverInfoTimeStamp"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtMessageTypeCode"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/MessageDetails/MessageTypeCode"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtMessageTypeText"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/MessageDetails/MessageTypeText"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtActionCode"/>:</td>
						<td>
							<xsl:choose>
								<xsl:when test="FinvoiceReceiverInfo/MessageDetails/MessageActionCode = 'ADD'">
									<xsl:value-of select="$txtADD"/>
								</xsl:when>
								<xsl:when test="FinvoiceReceiverInfo/MessageDetails/MessageActionCode = 'CHANGE'">
									<xsl:value-of select="$txtCHANGE"/>
								</xsl:when>
								<xsl:when test="FinvoiceReceiverInfo/MessageDetails/MessageActionCode = 'DELETE'">
									<xsl:value-of select="$txtDELETE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="FinvoiceReceiverInfo/MessageDetails/MessageActionCode"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="FinvoiceReceiverInfo/MessageDetails/MessageActionCodeIdentifier">
								<xsl:choose>
									<xsl:when test="FinvoiceReceiverInfo/MessageDetails/MessageActionCodeIdentifier = '01'">
										<xsl:text> / </xsl:text><xsl:value-of select="$txtIdConversion"/>
										<xsl:if test="FinvoiceReceiverInfo/ConversionDetails/ConversionID">
											<xsl:text> / </xsl:text><xsl:value-of select="FinvoiceReceiverInfo/ConversionDetails/ConversionID"/>
										</xsl:if>
									</xsl:when>
									<xsl:when test="FinvoiceReceiverInfo/MessageDetails/MessageActionCodeIdentifier = '02'">
										<xsl:text> / </xsl:text><xsl:value-of select="$txtIdMaintenance"/>
									</xsl:when>
								</xsl:choose>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtSenderInfoIdentifier"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/MessageDetails/SenderInfoIdentifier"/></td>
					</tr>
					<tr>
						<td colspan="4" class="ryhmanOtsikko"><xsl:value-of select="$txtInvoiceSender"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtInvoiceSenderAddress"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/InvoiceSenderAddress"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtInvoiceSenderIntermediatorAddress"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/InvoiceSenderIntermediatorAddress"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtSellerPartyIdentifier"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPartyIdentifier"/></td>
					</tr>
					<xsl:if test="FinvoiceReceiverInfo/SellerPartyDetails/SellerOrganisationName">
						<tr valign="top">
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerOrganisationName"/>:</td>
							<td>
								<xsl:for-each select="FinvoiceReceiverInfo/SellerPartyDetails/SellerOrganisationName">
									<xsl:value-of select="."/><br/>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:if>
					<xsl:for-each select="FinvoiceReceiverInfo/SellerPartyDetails/SellerOrganisationNames">
						<tr valign="top">
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerOrganisationName"/> (<xsl:value-of select="./@LanguageCode"/>):</td>
							<td>
								<xsl:for-each select="SellerOrganisationName">
									<xsl:value-of select="."/><br/>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:if test="FinvoiceReceiverInfo/SellerPartyDetails/SellerOrganisationBankName">
						<tr valign="top">
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerOrganisationBankName"/>:</td>
							<td>
								<xsl:for-each select="FinvoiceReceiverInfo/SellerPartyDetails/SellerOrganisationBankName">
									<xsl:value-of select="."/><br/>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtKatuosoite"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerStreetName"/></td>
						</tr>
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtPostiosoite"/>:</td>
							<td>
								<xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerPostCodeIdentifier"/><xsl:text> </xsl:text>
								<xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerTownName"/>
							</td>
						</tr>
						<xsl:if test="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerPostOfficeBoxIdentifier">
							<tr>
								<td nowrap="nowrap"><xsl:value-of select="$txtPostilokero"/>:</td>
								<td><xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerPostOfficeBoxIdentifier"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryCode or FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryName">
							<tr>
								<td nowrap="nowrap"><xsl:value-of select="$txtMaa"/>:</td>
								<td>
									<xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryCode"/><xsl:text> </xsl:text>
									<xsl:if test="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryCode and FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryName">
										<xsl:text>/ </xsl:text>
									</xsl:if>
									<xsl:value-of select="FinvoiceReceiverInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryName"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/SellerOrganisationUnitNumber">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtOrganisationUnitNumber"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/SellerOrganisationUnitNumber"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/SellerWebaddressNameText">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtWebaddressNameText"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/SellerWebaddressNameText"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/SellerWebaddressText">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtWebaddressText"/>:</td>
							<td>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/SellerWebaddressText"/>
									</xsl:attribute>
									<xsl:value-of select="FinvoiceReceiverInfo/InvoiceSenderInformationDetails/SellerWebaddressText"/>
								</a>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="4" class="ryhmanOtsikko"><xsl:value-of select="$txtInvoiceDetails"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtPaymentInstructionIdentifier"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/SellerInvoiceDetails/PaymentInstructionIdentifier"/></td>
					</tr>
					<xsl:for-each select="FinvoiceReceiverInfo/SellerInvoiceDetails/SellerInstructionFreeText">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerInstructionFreeText"/> (<xsl:value-of select="./@LanguageCode"/>):</td>
							<td>
								<xsl:value-of select="."/>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="FinvoiceReceiverInfo/SellerInvoiceDetails/SellerInvoiceTypeDetails">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerInvoiceTypeText"/> (<xsl:value-of select="SellerInvoiceTypeText/@LanguageCode"/>):</td>
							<td><xsl:value-of select="SellerInvoiceTypeText"/></td>
						</tr>
						<xsl:for-each select="SellerInvoiceIdentifierText">
							<tr>
								<td nowrap="nowrap" class="sisennetty"><xsl:value-of select="$txtSellerInvoiceIdentifierText"/><xsl:text> </xsl:text><xsl:value-of select="position()"/>:</td>
								<td><xsl:value-of select="."/></td>
							</tr>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:if test="FinvoiceReceiverInfo/ProposedDueDate">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtProposedDueDate"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/ProposedDueDate"/>.</td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/ProposedInvoicePeriod">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtProposedInvoicePeriod"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/ProposedInvoicePeriod"/><xsl:text> </xsl:text><xsl:value-of select="$txtProposedInvoicePeriodInfo"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/SellerInvoiceDetails/SellerDirectDebitIdentifier">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerDirectDebitIdentifier"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/SellerInvoiceDetails/SellerDirectDebitIdentifier"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/SellerInvoiceDetails/SellerDirectPaymentIdentifier">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtSellerDirectPaymentIdentifier"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/SellerInvoiceDetails/SellerDirectPaymentIdentifier"/></td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="4" class="ryhmanOtsikko"><xsl:value-of select="$txtSellerAccountDetails"/></td>
					</tr>
					<xsl:for-each select="FinvoiceReceiverInfo/SellerAccountDetails">
						<tr>
							<xsl:choose>
								<xsl:when test="SellerBic">
									<td nowrap="nowrap"><xsl:value-of select="$txtTilinumeroJaBIC"/>:</td>
									<td>
										<xsl:call-template name="OutputEpiAccountID">
											<xsl:with-param name="scheme" select="SellerAccountID/@IdentificationSchemeName"/>
											<xsl:with-param name="account" select="SellerAccountID"/>
										</xsl:call-template>
										<xsl:text> / </xsl:text><xsl:value-of select="SellerBic"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td nowrap="nowrap"><xsl:value-of select="$txtTilinumero"/>:</td>
									<td>
										<xsl:call-template name="OutputEpiAccountID">
											<xsl:with-param name="scheme" select="SellerAccountID/@IdentificationSchemeName"/>
											<xsl:with-param name="account" select="SellerAccountID"/>
										</xsl:call-template>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
					</xsl:for-each>
					<tr>
						<td colspan="4" class="ryhmanOtsikko"><xsl:value-of select="$txtBuyerPartyDetails"/></td>
					</tr>
					<xsl:if test="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPartyIdentifier">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtBuyerPartyIdentifier"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPartyIdentifier"/></td>
						</tr>
					</xsl:if>
					<tr>
						<td nowrap="nowrap" valign="top"><xsl:value-of select="$txtBuyerOrganisationName"/>:</td>
						<td>
							<xsl:for-each select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerOrganisationName">
								<xsl:value-of select="."/><br/>
							</xsl:for-each>
						</td>
					</tr>
					<xsl:if test="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtKatuosoite"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/BuyerStreetName"/></td>
						</tr>
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtPostiosoite"/>:</td>
							<td>
								<xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/BuyerPostCodeIdentifier"/><xsl:text> </xsl:text>
								<xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/BuyerTownName"/>
							</td>
						</tr>
						<xsl:if test="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/BuyerPostOfficeBoxIdentifier">
							<tr>
								<td nowrap="nowrap"><xsl:value-of select="$txtPostilokero"/>:</td>
								<td><xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/BuyerPostOfficeBoxIdentifier"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/CountryCode or FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/CountryName">
							<tr>
								<td nowrap="nowrap"><xsl:value-of select="$txtMaa"/>:</td>
								<td>
									<xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/CountryCode"/><xsl:text> </xsl:text>
									<xsl:if test="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/CountryCode and FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/CountryName">
										<xsl:text>/ </xsl:text>
									</xsl:if>
									<xsl:value-of select="FinvoiceReceiverInfo/BuyerPartyDetails/BuyerPostalAddressDetails/CountryName"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/BuyerOrganisationUnitNumber">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtOrganisationUnitNumber"/>:</td>
							<td><xsl:value-of select="FinvoiceReceiverInfo/BuyerOrganisationUnitNumber"/></td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="4" class="ryhmanOtsikko"><xsl:value-of select="$txtInvoiceRecipientDetails"/></td>
					</tr>
					<xsl:if test="FinvoiceReceiverInfo/BuyerServiceCode">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtBuyerServiceCode"/>:</td>
							<xsl:variable name="serviceCode" select="FinvoiceReceiverInfo/BuyerServiceCode"/>
							<td>
								<xsl:choose>
									<xsl:when test="$serviceCode = '00'"><xsl:value-of select="$txtELasku"/></xsl:when>
									<xsl:when test="$serviceCode = '01'"><xsl:value-of select="$txtSuoramaksu"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$serviceCode"/></xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtInvoiceRecipientAddress"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/InvoiceRecipientDetails/InvoiceRecipientAddress"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><xsl:value-of select="$txtInvoiceRecipientIntermediatorAddress"/>:</td>
						<td><xsl:value-of select="FinvoiceReceiverInfo/InvoiceRecipientDetails/InvoiceRecipientIntermediatorAddress"/></td>
					</tr>
					<xsl:for-each select="FinvoiceReceiverInfo/InvoiceRecipientDetails/SellerInvoiceIdentifier">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="position()"/>.<xsl:text> </xsl:text><xsl:value-of select="$txtSellerInvoiceIdentifier"/>:</td>
							<td><xsl:value-of select="."/></td>
						</tr>
					</xsl:for-each>
					<xsl:if test="FinvoiceReceiverInfo/InvoiceRecipientDetails/EpiRemittanceIdentifier">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtEpiRemittanceIdentifier"/>:</td>
							<td>
								<xsl:call-template name="OutputEpiRemittanceInfoIdentifier">
									<xsl:with-param name="erii" select="FinvoiceReceiverInfo/InvoiceRecipientDetails/EpiRemittanceIdentifier"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="FinvoiceReceiverInfo/InvoiceRecipientDetails/InvoiceRecipientLanguageCode">
						<tr>
							<td nowrap="nowrap"><xsl:value-of select="$txtLanguage"/>:</td>
							<xsl:variable name="langCode" select="FinvoiceReceiverInfo/InvoiceRecipientDetails/InvoiceRecipientLanguageCode"/>
							<td>
								<xsl:choose>
									<xsl:when test="$langCode = 'FI'"><xsl:value-of select="$txtSuomi"/></xsl:when>
									<xsl:when test="($langCode = 'SV') or ($langCode = 'SE')"><xsl:value-of select="$txtRuotsi"/></xsl:when>
									<xsl:when test="$langCode = 'EN'"><xsl:value-of select="$txtEnglanti"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$langCode"/></xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:if>
				</table>
			</body>
		</html>
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
	<!-- Template, joka osaa tulostaa tilinumeroita (IBAN ryhmiteltyn� ja muut sellaisenaan). -->
	<xsl:template name="OutputEpiAccountID">
		<xsl:param name="scheme"/>
		<xsl:param name="account"/>
		<xsl:variable name="lenAccount" select="string-length($account)"/>
		<xsl:choose>
			<xsl:when test="$scheme = 'IBAN'">
				<xsl:choose>
					<xsl:when test="$lenAccount &lt; 5">
						<xsl:value-of select="$account"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($account, 1, 4)"/>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="$lenAccount &lt; 9">
								<xsl:value-of select="substring($account, 5, $lenAccount - 4)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring($account, 5, 4)"/>
								<xsl:text> </xsl:text>
								<xsl:choose>
									<xsl:when test="$lenAccount &lt; 13">
										<xsl:value-of select="substring($account, 9, $lenAccount - 8)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring($account, 9, 4)"/>
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when test="$lenAccount &lt; 17">
												<xsl:value-of select="substring($account, 13, $lenAccount - 12)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring($account, 13, 4)"/>
												<xsl:text> </xsl:text>
												<xsl:choose>
													<xsl:when test="$lenAccount &lt; 21">
														<xsl:value-of select="substring($account, 17, $lenAccount - 16)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring($account, 17, 4)"/>
														<xsl:text> </xsl:text>
														<xsl:value-of select="substring($account, 21, $lenAccount - 20)"/>
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
			<xsl:otherwise>
				<xsl:value-of select="$account"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
