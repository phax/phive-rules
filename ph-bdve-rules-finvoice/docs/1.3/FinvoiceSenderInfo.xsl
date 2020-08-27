<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" version="4.01" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<!-- Tekstit alkavat -->
	<xsl:variable name="txtOtsikko">Finvoice-sanoman l�hett�j�n ilmoitus</xsl:variable>
	<xsl:variable name="txtSellerPartyDetails">Myyj�n tiedot</xsl:variable>
	<xsl:variable name="txtSellerPartyIdentifier">Y-tunnus/Hetu</xsl:variable>
	<xsl:variable name="txtSellerOrganisationName">Myyj�n nimi</xsl:variable>
	<xsl:variable name="txtKatuosoite">Katuosoite</xsl:variable>
	<xsl:variable name="txtPostinroJaKaupunki">Postinumero ja kaupunki</xsl:variable>
	<xsl:variable name="txtPostilokero">Postilokero</xsl:variable>
	<xsl:variable name="txtMaa">Maa</xsl:variable>
	<xsl:variable name="txtOrganisationUnitNumber">Organisaatioyksikk�</xsl:variable>
	<xsl:variable name="txtInvoiceSenderInformationDetails">Finvoice-sanoman l�hett�j�n tiedot</xsl:variable>
	<xsl:variable name="txtWebaddressText">Linkki web-sivulle</xsl:variable>
	<xsl:variable name="txtWebaddressNameText">Web-sivuston selitys</xsl:variable>
	<xsl:variable name="txtInvoiceSenderAddress">L�hett�j�n osoite</xsl:variable>
	<xsl:variable name="txtInvoiceSenderIntermediatorAddress">L�hett�j�n v�litt�j�n tunnus</xsl:variable>
	<xsl:variable name="txtNewInvoiceSenderAddress">Uusi l�hett�j�n osoite</xsl:variable>
	<xsl:variable name="txtNewInvoiceSenderIntermediatorAddress">Uusi l�hett�j�n v�litt�j�n tunnus</xsl:variable>
	<xsl:variable name="txtMessageDetails">Viestin tiedot</xsl:variable>
	<xsl:variable name="txtMessageDate">Viestin p�iv�ys</xsl:variable>
	<xsl:variable name="txtMessageTypeCode">Viestin tyyppikoodi</xsl:variable>
	<xsl:variable name="txtMessageTypeText">Viestin tyyppi</xsl:variable>
	<xsl:variable name="txtMessageActionCode">Viestin toimintakoodi</xsl:variable>
	<xsl:variable name="txtSenderInfoIdentifier">L�hett�j�n viite sanomalle</xsl:variable>
	<xsl:variable name="txtSellerInvoiceDetails">Laskun tiedot</xsl:variable>
	<xsl:variable name="txtSellerDirectDebitIdentifier">Laskuttajan suoraveloitustunnus</xsl:variable>
	<xsl:variable name="txtSellerDirectPaymentIdentifier">Laskuttajan suoramaksutunnus</xsl:variable>
	<xsl:variable name="txtPaymentInstructionIdentifier">Laskun aiheen koodi</xsl:variable>
	<xsl:variable name="txtSellerInvoiceTypeText">Laskun aihe</xsl:variable>
	<xsl:variable name="txtSellerInvoiceIdentifierText">Pyydett�v� tunnistetieto</xsl:variable>
	<xsl:variable name="txtSellerAccountID">Laskuttajan tilinumero</xsl:variable>
	<xsl:variable name="txtSellerBic">Laskuttajan</xsl:variable>
	<xsl:variable name="txtNewSellerAccountID">Uusi laskuttajan tilinumero</xsl:variable>
	<xsl:variable name="txtNewSellerBIC">Uusi laskuttajan BIC</xsl:variable>
	<xsl:variable name="txtSellerInstructionFreeText">Ohje vastaanottajalle</xsl:variable>
	<!-- Tekstit loppuivat -->
	<xsl:template match="/">
		<html>
			<body>
				<h2 align="center"><xsl:value-of select="$txtOtsikko"/></h2>
				<hr/>
				<table width="100%" border="0">
					<tr>
						<td width="49%" valign="top">
							<table bgcolor="#5555aa" border="0" width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td>
										<table bgcolor="#ccccee" border="0" width="100%" cellpadding="2">
											<tr>
												<th align="left"><xsl:value-of select="$txtSellerPartyDetails"/></th>
											</tr>
										</table>
										<table bgcolor="#eaedff" border="0" width="100%" cellpadding="2">
											<tr>
												<td><xsl:value-of select="$txtSellerPartyIdentifier"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/SellerPartyDetails/SellerPartyIdentifier"/>
												</td>
											</tr>
											<xsl:for-each select="FinvoiceSenderInfo/SellerPartyDetails/SellerOrganisationName">
												<tr>
													<td><xsl:value-of select="$txtSellerOrganisationName"/>:</td>
													<td>
														<xsl:value-of select="."/>
													</td>
												</tr>
											</xsl:for-each>
											<xsl:if test="count(FinvoiceSenderInfo/SellerPartyDetails/SellerPostalAddressDetails) &gt; 0">
												<tr>
													<td><xsl:value-of select="$txtKatuosoite"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerStreetName"/>
													</td>
												</tr>
												<tr>
													<td><xsl:value-of select="$txtPostinroJaKaupunki"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerPostCodeIdentifier"/>
														<xsl:text> </xsl:text>
														<xsl:value-of select="FinvoiceSenderInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerTownName"/>
													</td>
												</tr>
												<tr>
													<td><xsl:value-of select="$txtPostilokero"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/SellerPartyDetails/SellerPostalAddressDetails/SellerPostOfficeBoxIdentifier"/>
													</td>
												</tr>
												<tr>
													<td><xsl:value-of select="$txtMaa"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/SellerPartyDetails/SellerPostalAddressDetails/CountryName"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="count(FinvoiceSenderInfo/SellerOrganisationUnitNumber) &gt; 0">
												<tr>
													<td><xsl:value-of select="$txtOrganisationUnitNumber"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/SellerOrganisationUnitNumber"/>
													</td>
												</tr>
											</xsl:if>
										</table>
									</td>
								</tr>
							</table>
							<br/>
							<table bgcolor="#5555aa" border="0" width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td>
										<table bgcolor="#ccccee" border="0" width="100%" cellpadding="2">
											<tr>
												<th align="left" colspan="2"><xsl:value-of select="$txtInvoiceSenderInformationDetails"/></th>
											</tr>
										</table>
										<table bgcolor="#eaedff" border="0" width="100%" cellpadding="2">
											<xsl:if test="count(FinvoiceSenderInfo/InvoiceSenderInformationDetails/SellerWebaddressText) &gt; 0">
												<tr>
													<td valign="top"><xsl:value-of select="$txtWebaddressText"/>:</td>
													<td>
														<a>
															<xsl:attribute name="href"><xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/SellerWebaddressText"/></xsl:attribute>
															<xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/SellerWebaddressText"/>
														</a>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="count(FinvoiceSenderInfo/InvoiceSenderInformationDetails/SellerWebaddressNameText) &gt; 0">
												<tr>
													<td><xsl:value-of select="$txtWebaddressNameText"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/SellerWebaddressNameText"/>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td><xsl:value-of select="$txtInvoiceSenderAddress"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/InvoiceSenderAddress"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="$txtInvoiceSenderIntermediatorAddress"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/InvoiceSenderIntermediatorAddress"/>
												</td>
											</tr>
											<xsl:if test="string-length(FinvoiceSenderInfo/InvoiceSenderInformationDetails/NewInvoiceSenderAddress) != 0">
												<tr>
													<td><xsl:value-of select="$txtNewInvoiceSenderAddress"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/NewInvoiceSenderAddress"/>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="string-length(FinvoiceSenderInfo/InvoiceSenderInformationDetails/NewInvoiceSenderIntermediatorAddress) != 0">
												<tr>
													<td><xsl:value-of select="$txtNewInvoiceSenderIntermediatorAddress"/>:</td>
													<td>
														<xsl:value-of select="FinvoiceSenderInfo/InvoiceSenderInformationDetails/NewInvoiceSenderIntermediatorAddress"/>
													</td>
												</tr>
											</xsl:if>
										</table>
									</td>
								</tr>
							</table>
							<br/>
						</td>
						<td width="2%"/>
						<td width="49%" valign="top">
							<table bgcolor="#5555aa" border="0" width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td>
										<table bgcolor="#ccccee" border="0" width="100%" cellpadding="2">
											<tr>
												<th align="left" colspan="2"><xsl:value-of select="$txtMessageDetails"/></th>
											</tr>
										</table>
										<table bgcolor="#eaedff" border="0" width="100%" cellpadding="2">
											<tr>
												<td><xsl:value-of select="$txtMessageDate"/>:</td>
												<td>
													<xsl:value-of select="substring(FinvoiceSenderInfo/MessageDetails/MessageDate,7,2)"/>.<xsl:value-of select="substring(FinvoiceSenderInfo/MessageDetails/MessageDate,5,2)"/>.<xsl:value-of select="substring(FinvoiceSenderInfo/MessageDetails/MessageDate,1,4)"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="$txtMessageTypeCode"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/MessageDetails/MessageTypeCode"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="$txtMessageTypeText"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/MessageDetails/MessageTypeText"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="$txtMessageActionCode"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/MessageDetails/MessageActionCode"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="$txtSenderInfoIdentifier"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/MessageDetails/SenderInfoIdentifier"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<br/>
							<table bgcolor="#5555aa" border="0" width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td>
										<table bgcolor="#ccccee" border="0" width="100%" cellpadding="2">
											<tr>
												<th align="left" colspan="2"><xsl:value-of select="$txtSellerInvoiceDetails"/></th>
											</tr>
										</table>
										<table bgcolor="#eaedff" border="0" width="100%" cellpadding="2">
											<tr>
												<td><xsl:value-of select="$txtSellerDirectDebitIdentifier"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/SellerInvoiceDetails/SellerDirectDebitIdentifier"/>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="$txtSellerDirectPaymentIdentifier"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/SellerInvoiceDetails/SellerDirectPaymentIdentifier"/>
												</td>
											</tr>
											<xsl:for-each select="FinvoiceSenderInfo/SellerInvoiceDetails/SellerInstructionFreeText">
												<tr>
													<td nowrap="nowrap"><xsl:value-of select="$txtSellerInstructionFreeText"/> (<xsl:value-of select="./@LanguageCode"/>):</td>
													<td>
														<xsl:value-of select="."/>
													</td>
												</tr>
											</xsl:for-each>
											<tr>
												<td><xsl:value-of select="$txtPaymentInstructionIdentifier"/>:</td>
												<td>
													<xsl:value-of select="FinvoiceSenderInfo/SellerInvoiceDetails/PaymentInstructionIdentifier"/>
												</td>
											</tr>
											<xsl:for-each select="FinvoiceSenderInfo/SellerInvoiceDetails/SellerInvoiceTypeDetails">
												<tr>
													<td><xsl:value-of select="$txtSellerInvoiceTypeText"/> (<xsl:value-of select="SellerInvoiceTypeText/@LanguageCode"/>):</td>
													<td>
														<xsl:value-of select="SellerInvoiceTypeText"/>
													</td>
												</tr>
												<tr>
													<td><xsl:value-of select="$txtSellerInvoiceIdentifierText"/> (<xsl:value-of select="SellerInvoiceIdentifierText/@LanguageCode"/>):</td>
													<td>
														<xsl:value-of select="SellerInvoiceIdentifierText"/>
													</td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="FinvoiceSenderInfo/SellerAccountDetails">
												<tr>
													<td><xsl:value-of select="$txtSellerAccountID"/><xsl:text> </xsl:text>(<xsl:value-of select="SellerAccountID/@IdentificationSchemeName"/>):</td>
													<td>
														<xsl:value-of select="SellerAccountID"/>
													</td>
												</tr>
												<xsl:if test="string-length(SellerBic) != 0">
													<tr>
														<td><xsl:value-of select="$txtSellerBic"/><xsl:text> </xsl:text><xsl:value-of select="SellerBic/@IdentificationSchemeName"/>:</td>
														<td>
															<xsl:value-of select="SellerBic"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="string-length(NewSellerAccountID) != 0">
													<tr>
														<td><xsl:value-of select="$txtNewSellerAccountID"/>:</td>
														<td>
															<xsl:value-of select="NewSellerAccountID"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="string-length(NewSellerBIC) != 0">
													<tr>
														<td><xsl:value-of select="$txtNewSellerBIC"/>:</td>
														<td>
															<xsl:value-of select="NewSellerBIC"/>
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</table>
							<br/>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
