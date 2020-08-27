<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Copyright -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.w3.org/TR/REC-html40"
				xmlns:spy="http://www.pankkiyhdistys.fi/verkkolasku/finvoice/finvoiceack.xsd"
				xmlns:eb="http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd">
<!-- Tekstit alkavat -->
<!-- XSL-rivit suomeksi -->
<xsl:variable name="txtFEEDBACK">VIRHEPALAUTE</xsl:variable>
<xsl:variable name="txtErrorInXML">Finvoiceack xml-tietosis�lt� on tyhj� tai virheellinen.</xsl:variable>
<xsl:variable name="txtMessageId">Laskusanoman tunniste</xsl:variable>
<xsl:variable name="txtTimestamp">Laskusanoman aikaleima</xsl:variable>
<xsl:variable name="txtFromSender">Laskun l�hett�j�n osoite</xsl:variable>
<xsl:variable name="txtFromIntermediator">Laskun l�hett�j�n v�litt�j�</xsl:variable>
<xsl:variable name="txtToReceiver">Laskun vastaanottajan osoite</xsl:variable>
<xsl:variable name="txtToIntermediator">Laskun vastaanottajan v�litt�j�</xsl:variable>
<xsl:variable name="txtReason">Virhekoodi ja selitys</xsl:variable>
<!-- Tekstit loppuivat -->
	<!-- K�sitell��n Finvoiceack. -->
	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="$txtFEEDBACK"/></title>
				<style type="text/css">
			      body {background-color: white;color:black;}
					h2 {letter-spacing:8px; z-index:2;}
					.centered {text-align:center;}
					.centered table {margin-left:auto; margin-right:auto; text-align:left;}
				</style>
			</head>
			<body>
				<xsl:if test="count(spy:Finvoiceack) != '1'">
					<xsl:message terminate="yes">
						<xsl:value-of select="$txtErrorInXML"/>
					</xsl:message>
				</xsl:if>
				<center><h2><xsl:value-of select="$txtFEEDBACK"/></h2></center>
				<p>
				<br/>
				<div class="centered">
				<table cellpadding="0" border="0">
					<tr valign="top" align="left">
						<td><b><xsl:value-of select="$txtMessageId"/>:</b></td><td width="1%"/>
						<td><xsl:value-of select="spy:Finvoiceack/spy:Acknowledgement/spy:MessageData/eb:MessageId"/></td>
					</tr>
					<tr valign="top" align="left">
						<td><b><xsl:value-of select="$txtTimestamp"/>:</b></td><td width="1%"/>
						<td><xsl:value-of select="spy:Finvoiceack/spy:Acknowledgement/spy:MessageData/eb:Timestamp"/></td>
					</tr>
					<tr valign="top" align="left"><td><br/></td></tr>
					<xsl:for-each select="spy:Finvoiceack/spy:Acknowledgement/eb:From">
						<xsl:if test="eb:Role = 'Sender'">
							<tr valign="top" align="left">
								<td><b><xsl:value-of select="$txtFromSender"/>:</b></td><td width="1%"/>
								<td><xsl:value-of select="eb:PartyId"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="eb:Role = 'Intermediator'">
							<tr valign="top" align="left">
								<td><b><xsl:value-of select="$txtFromIntermediator"/>:</b></td><td width="1%"/>
								<td><xsl:value-of select="eb:PartyId"/></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<tr valign="top" align="left"><td><br/></td></tr>
					<xsl:for-each select="spy:Finvoiceack/spy:Acknowledgement/eb:To">
						<xsl:if test="eb:Role = 'Receiver'">
							<tr valign="top" align="left">
								<td><b><xsl:value-of select="$txtToReceiver"/>:</b></td><td width="1%"/>
								<td><xsl:value-of select="eb:PartyId"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="eb:Role = 'Intermediator'">
							<tr valign="top" align="left">
								<td><b><xsl:value-of select="$txtToIntermediator"/>:</b></td><td width="1%"/>
								<td><xsl:value-of select="eb:PartyId"/></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<tr valign="top" align="left"><td><br/></td></tr>
					<tr valign="top" align="left">
						<td><b><xsl:value-of select="$txtReason"/>:</b></td><td width="1%"/>
						<td><xsl:value-of select="spy:Finvoiceack/spy:Acknowledgement/spy:Reason/spy:Code"/> / <xsl:value-of select="spy:Finvoiceack/spy:Acknowledgement/spy:Reason/spy:Text"/></td>
					</tr>
				</table>
				</div>
				</p>
</body>
  </html>
		
	</xsl:template>
</xsl:stylesheet>
