<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" version="4.01" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<!-- Tekstit alkavat -->
	<xsl:variable name="txtOtsikko">Finvoice-sanoman vastaanottajan ilmoitus</xsl:variable>
	<xsl:variable name="txtMessageDate">P�iv�ys</xsl:variable>
	<xsl:variable name="txtTimeStamp">Aikaleima</xsl:variable>
	<xsl:variable name="txtMessageTypeCode">Tyyppikoodi</xsl:variable>
	<xsl:variable name="txtMessageTypeText">Tyyppi</xsl:variable>
	<xsl:variable name="txtActionCode">Toiminto</xsl:variable>
	<xsl:variable name="txtADD">Lis�ys</xsl:variable>
	<xsl:variable name="txtCHANGE">Muutos</xsl:variable>
	<xsl:variable name="txtDELETE">Poisto</xsl:variable>
	<xsl:variable name="txtSenderInfoIdentifier">Laskuttajailmoituksen tunniste</xsl:variable>
	<xsl:variable name="txtInvoiceSender">Laskuttajan tiedot</xsl:variable>
	<xsl:variable name="txtInvoiceSenderAddress">Verkkolaskuosoite</xsl:variable>
	<xsl:variable name="txtInvoiceSenderIntermediatorAddress">V�litt�j�n tunnus</xsl:variable>
	<xsl:variable name="txtSellerPartyIdentifier">Laskuttajan Y-tunnus</xsl:variable>
	<xsl:variable name="txtSellerOrganisationName">Laskuttajan nimi</xsl:variable>
	<xsl:variable name="txtSellerOrganisationBankName">Laskuttajan nimi pankissa</xsl:variable>
	<xsl:variable name="txtKatuosoite">Katuosoite</xsl:variable>
	<xsl:variable name="txtPostiosoite">Postiosoite</xsl:variable>
	<xsl:variable name="txtPostilokero">Postilokero</xsl:variable>
	<xsl:variable name="txtMaa">Maa</xsl:variable>
	<xsl:variable name="txtOrganisationUnitNumber">Organisaatioyksikk�</xsl:variable>
	<xsl:variable name="txtWebaddressNameText">Web-sivuston selitys</xsl:variable>
	<xsl:variable name="txtWebaddressText">Web-sivuston URL</xsl:variable>
	<xsl:variable name="txtInvoiceDetails">Laskun tiedot</xsl:variable>
	<xsl:variable name="txtPaymentInstructionIdentifier">Laskutusaiheen koodi</xsl:variable>
	<xsl:variable name="txtSellerInstructionFreeText">Ohje vastaanottajalle</xsl:variable>
	<xsl:variable name="txtSellerInvoiceTypeText">Laskun aihe</xsl:variable>
	<xsl:variable name="txtSellerInvoiceIdentifierText">Tunnistetieto</xsl:variable>
	<xsl:variable name="txtProposedDueDate">Ehdotettu er�p�iv�</xsl:variable>
	<xsl:variable name="txtProposedInvoicePeriod">Ehdotettu laskutusjakso</xsl:variable>
	<xsl:variable name="txtProposedInvoicePeriodInfo">(kertaa vuodessa)</xsl:variable>
	<xsl:variable name="txtSellerDirectDebitIdentifier">Suoraveloitustunnus</xsl:variable>
	<xsl:variable name="txtSellerDirectPaymentIdentifier">Suoralaskutunnus</xsl:variable>
	<xsl:variable name="txtSellerAccountDetails">Laskuttajan pankkiyhteystiedot</xsl:variable>
	<xsl:variable name="txtTilinumeroJaBIC">Tilinumero ja tilipankin BIC</xsl:variable>
	<xsl:variable name="txtTilinumero">Tilinumero</xsl:variable>
	<xsl:variable name="txtBuyerPartyDetails">Ostajan tiedot</xsl:variable>
	<xsl:variable name="txtBuyerPartyIdentifier">Y-tunnus / Hetu</xsl:variable>
	<xsl:variable name="txtBuyerOrganisationName">Nimi</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientDetails">Laskun vastaanottajan tiedot</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientAddress">Laskutusosoite</xsl:variable>
	<xsl:variable name="txtInvoiceRecipientIntermediatorAddress">V�litt�j�n tunnus</xsl:variable>
	<xsl:variable name="txtSellerInvoiceIdentifier">Tunnistetieto laskuttajalla</xsl:variable>
	<xsl:variable name="txtEpiRemittanceIdentifier">Maksun viitenumero</xsl:variable>
	<xsl:variable name="txtViestinTiedot">Viestin tiedot</xsl:variable>
	<xsl:variable name="txtIdConversion">konversio</xsl:variable>
	<xsl:variable name="txtIdMaintenance">yll�pito</xsl:variable>
	<xsl:variable name="txtLanguage">Kieli</xsl:variable>
	<xsl:variable name="txtSuomi">Suomi</xsl:variable>
	<xsl:variable name="txtRuotsi">Ruotsi</xsl:variable>
	<xsl:variable name="txtEnglanti">Englanti</xsl:variable>
	<xsl:variable name="txtBuyerServiceCode">Palvelu</xsl:variable>
	<xsl:variable name="txtELasku">E-lasku</xsl:variable>
	<xsl:variable name="txtSuoramaksu">Suoramaksu</xsl:variable>
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
					<xsl:if test="FinvoiceReceiverInfo/SellerAccountDetails">
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
					</xsl:if>
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
