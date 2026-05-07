<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron"
			xmlns:sch="http://purl.oclc.org/dsdl/schematron"
			xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
			xmlns:ef="http://www.efatura.gov.tr/envelope-namespace">

	<!-- phive-rules-turkey: <sch:ns> declarations placed before <sch:include>/<let> so the
	     compiled XSLT emits <ns-prefix-in-attribute-values> before any <active-pattern>; this is
	     the order required by the strict SVRL schema used by ph-schematron. -->
	<sch:ns prefix="sh" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" />
	<sch:ns prefix="ef" uri="http://www.efatura.gov.tr/package-namespace" />
	<sch:ns prefix="inv" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
	<sch:ns prefix="apr" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" />
	<sch:ns prefix="desp" uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" />
	<sch:ns prefix="recp" uri="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2" />
	<sch:ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
	<sch:ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
	<sch:ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
	<sch:ns prefix="ds" uri="http://www.w3.org/2000/09/xmldsig#" />
	<sch:ns prefix="xades" uri="http://uri.etsi.org/01903/v1.3.2#" />
	<sch:ns prefix="hr" uri="http://www.hr-xml.org/3" />
	<sch:ns prefix="oa" uri="http://www.openapplications.org/oagis/9" />
	<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />

	<sch:include href="UBL-TR_Codelist.xml#codes"/>
	<sch:include href="UBL-TR_Common_Schematron.xml#abstracts"/>

	<let name="type" value="efatura"/>
	
	<let name="envelopeType" value="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:Type"/>
	<let name="senderId" value="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact"/>
	<let name="senderAlias" value="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/>
	<let name="receiverId" value="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact"/>
	<let name="receiverAlias" value="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier"/>
	<let name="responseCode" value="//apr:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode" />
	
	<!-- StandardBusinessDocument -->
	<sch:pattern id="document">
		<sch:rule context="sh:StandardBusinessDocument">
			<sch:extends rule="DocumentCheck"/>
			<sch:extends rule="namespaceCheck"/>
		</sch:rule>
	</sch:pattern>
	
	<!-- StandardBusinessDocumentHeader -->
	<sch:pattern id="header">
		<sch:rule context="sh:StandardBusinessDocumentHeader">
			<sch:extends rule="HeaderCheck"/>
		</sch:rule>
		
		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier">
			<sch:extends rule="EmptyCheck"/>
		</sch:rule>
		
		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier">
			<sch:extends rule="EmptyCheck"/>
		</sch:rule>
		
		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:Sender">
			<sch:extends rule="ContactInformationCheck"/>
		</sch:rule>

		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:Receiver">
			<sch:extends rule="ContactInformationCheck"/>
		</sch:rule>

		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation">
			<sch:extends rule="ContactCheck"/>
		</sch:rule>

		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation">
			<sch:extends rule="ContactCheck"/>
		</sch:rule>

		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification">
			<sch:extends rule="TypeVersionCheck"/>
			<sch:extends rule="EnvelopeTypeCheck"/>
			<sch:extends rule="EnvelopeTypeElementTypeCheck"/>
		</sch:rule>
		
		<sch:rule context="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier">
			<sch:extends rule="UUIDCheck"/>
		</sch:rule>
	</sch:pattern>	
	
	<!--General Rules-->
	<sch:rule context="//cbc:IdentificationCode">
			<sch:extends rule="CountryCodeCheck"/>
	</sch:rule>
	<sch:rule context="//cbc:SourceCurrencyCode">
			<sch:extends rule="GeneralCurrencyCodeCheck"/>
	</sch:rule>
	<sch:rule context="//cbc:TargetCurrencyCode">
			<sch:extends rule="GeneralCurrencyCodeCheck"/>
	</sch:rule>
	<sch:rule context="//cbc:CurrencyCode">
			<sch:extends rule="GeneralCurrencyCodeCheck"/>
	</sch:rule>
	<sch:rule context="//@currencyID">
			<sch:extends rule="GeneralCurrencyIDCheck"/>
	</sch:rule>
	<sch:rule context="//@unitCode">
			<sch:extends rule="GeneralUnitCodeCheck"/>
	</sch:rule>	
	
	<sch:rule context="//cbc:ChannelCode">
			<sch:extends rule="GeneralChannelCodeCheck"/>
	</sch:rule>
	
	<sch:rule context="//cbc:IssueDate">
			<sch:extends rule="TimeCheck"/>
	</sch:rule>
	
	<sch:rule context="//@mimeCode">
			<sch:extends rule="MimeCodeCheck"/>
	</sch:rule>
	<!-- Package -->
	<sch:pattern id="package">
		<sch:rule context="ef:Package">
			<sch:extends rule="ElementsGroupCountCheck"/>
		</sch:rule>
		<sch:rule context="ef:Package/Elements">
			<sch:extends rule="ElementTypeCheck"/>
			<sch:extends rule="ElementCountCheck"/>
			<sch:extends rule="ElementListCountCheck"/>
			<sch:extends rule="ElementNameCheck"/>
			<sch:extends rule="InvoiceCountCheck"/>
		</sch:rule>
		<sch:rule context="ef:Package/Elements/ElementList">
			<sch:extends rule="ExportInvoiceCountCheck"/>
		</sch:rule>
	</sch:pattern>	
	
	<!-- Invoice -->
	<sch:pattern id="invoice">
		<sch:rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature">
			<sch:extends rule="XadesSignatureCheckForInvoice"/>
			<sch:extends rule="SignatureMethodCheck"/>
			<!-- <sch:extends rule="SignatureIDCheck"/> -->			
		</sch:rule>
		<sch:rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data">
			<sch:extends rule="X509DataCheck"/>	
		</sch:rule>
		<sch:rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName">
			<sch:extends rule="X509SubjectNameCheck"/>	
		</sch:rule>		
		<sch:rule context="inv:Invoice">
			<sch:extends rule="UBLVersionIDCheck"/>
			<sch:extends rule="CustomizationIDCheck"/>
			<sch:extends rule="ProfileIDCheck"/>
			<sch:extends rule="InvoiceIDCheck"/>
			<sch:extends rule="CopyIndicatorCheck"/>
			<!--<sch:extends rule="TimeCheck"/>-->
			<sch:extends rule="InvoiceTypeCodeCheck"/>
			<sch:extends rule="CurrencyCodeCheck"/>
			<!-- <sch:extends rule="URI2IDCheck"/> -->
			<sch:extends rule="SignatureCountCheck"/>
			<sch:extends rule="GeneralWithholdingTaxTotalCheck"/>
			<sch:extends rule="DeliveryCodeCheck"/>
			<sch:extends rule="TaxRepresentativePartyCheck"/>
			<sch:extends rule="HKSInvioceCheck"/>
			<sch:extends rule="IADEInvioceCheck"/>
			<sch:extends rule="IlacTibbiCihazInvoiceTypeCodeCheck"/>	
			<sch:extends rule="YatirimTesvikInvoiceTypeCodeCheck"/>	
			<sch:extends rule="YatirimTesvikContractDocumentReferenceIDCheck"/>			
			<sch:extends rule="IdisInvoiceTypeCodeCheck"/>	
		</sch:rule>
		<sch:rule context="inv:Invoice/cbc:UUID">
			<sch:extends rule="UUIDCheck"/>
		</sch:rule>	
		<sch:rule context="inv:Invoice/cac:Signature">
			<sch:extends rule="SignatureCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:WithholdingTaxTotal/cac:TaxSubtotal">
			<sch:extends rule="WithholdingTaxTotalCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
			<sch:extends rule="DocumentSenderCheck"/>
		</sch:rule>		
		<sch:rule context="inv:Invoice/cac:AccountingSupplierParty/cac:Party">
			<sch:extends rule="PartyIdentificationPartyNamePersonCheck"/>
			<sch:extends rule="PartyVDCheck"/>
			<sch:extends rule="IdisSevkiyatNoCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
			<sch:extends rule="PartyIdentificationTEKNOLOJIDESTEKCheck"/>
			<sch:extends rule="DocumentReceiverCheck"/>
			<sch:extends rule="TaxFreeInvoiceCheck"/>
		</sch:rule>		
		<sch:rule context="inv:Invoice/cac:AccountingCustomerParty/cac:Party">
			<sch:extends rule="PartyIdentificationPartyNamePersonCheck"/>
		</sch:rule>
				
		<sch:rule context="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode">
			<sch:extends rule="TaxTypeCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode">
			<sch:extends rule="TaxTypeCheck"/>
		</sch:rule>		
		
		<sch:rule context="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal">
			<sch:extends rule="TaxExemptionReasonCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:TaxTotal">
			<sch:extends rule="YatirimTesvikKDVCheck"/>
			<sch:extends rule="DemirbasKDVTaxExemptionCheck"/>
		</sch:rule>
		
		<!--<sch:rule context="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal">
			<sch:extends rule="TaxExemptionReasonCheck"/>
		</sch:rule>
		-->
		
		<sch:rule context="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory">
			<sch:extends rule="TaxExemptionReasonCodeCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:InvoiceLine">
			<sch:extends rule="PriceAmountCheck"/>
			<sch:extends rule="LineDeliveryCheck"/>
			<sch:extends rule="PackageCheck"/>
			<sch:extends rule="DeliveryCodeCheck"/>			
			<sch:extends rule="IlacTibbiCihazAdditionalItemIdentificationCheck"/>			
			<sch:extends rule="TeknolojiDestekAdditionalItemIdentificationCheck"/>		
			<sch:extends rule="IhracKayitliPartyIdentificationIDTypeCheck"/>		
			<sch:extends rule="YatirimTesvikCommodityClassificationCheck"/>		
			<sch:extends rule="YatirimTesvikItemClassificationCodeCheck"/>		
			<sch:extends rule="YatirimTesvikItemClassificationCodeIstisnaCheck"/>		
			<sch:extends rule="YatirimTesvikItemClassificationCodeIstisnaCalculationSequenceNumericCheck"/>		
			<sch:extends rule="YatirimTesvikTaxExemptionReasonCode308Check"/>		
			<sch:extends rule="YatirimTesvikTaxExemptionReasonCode339Check"/>		
			<sch:extends rule="YatirimTesvikItemInstanceCheck"/>		
			<sch:extends rule="YatirimTesvikLineKDVCheck"/>
			<sch:extends rule="IdisEtiketNoCheck"/>
		</sch:rule>
		
		<!--<sch:rule context="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory">
			<sch:extends rule="TaxExemptionReasonCodeCheck"/>
		</sch:rule>-->
		
		<sch:rule context="inv:Invoice/cac:InvoiceLine/cac:WithholdingTaxTotal/cac:TaxSubtotal">
			<sch:extends rule="WithholdingTaxTotalCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity">
			<sch:extends rule="InvoicedQuantityCheck"/>
		</sch:rule>
		
		<sch:rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:SignedInfo/ds:Reference/ds:Transforms">
			<sch:extends rule="TransformCountCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:TaxTotal/cbc:TaxAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:Signature/cac:SignatoryParty">
			<sch:extends rule="SignatoryPartyPartyIdentificationCheck"/>
		</sch:rule>		
		
		<sch:rule context="inv:Invoice/cac:TaxTotal/cbc:TaxAmount">
			<sch:extends rule="decimalCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode">
			<sch:extends rule="PaymentMeansCodeCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cac:BillingReference/cac:AdditionalDocumentReference">
			<sch:extends rule="BillingReferenceCheck"/>
		</sch:rule>
		<sch:rule context="inv:Invoice/cbc:ProfileID">
			<sch:extends rule="IhracatYolcuBeraberCheck"/>
			<sch:extends rule="KamuFaturaCheck"/>
		</sch:rule>		
		<sch:rule context="inv:Invoice/cac:BuyerCustomerParty">
			<sch:extends rule="TaxFreeNationalityIDCheck"/>
			<sch:extends rule="PassportIDCheck"/>
			<sch:extends rule="OfficelTitleCheck"/>			
		</sch:rule>		
	</sch:pattern>
	
	<!-- ApplicationResponse -->
	<sch:pattern id="applicationresponse">
		<sch:rule context="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature">
			<sch:extends rule="XadesSignatureCheck"/>
			<!-- <sch:extends rule="SignatureIDCheck"/> -->			
		</sch:rule>
		<sch:rule context="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data">
			<sch:extends rule="X509DataCheck"/>	
		</sch:rule>
		<sch:rule context="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName">
			<sch:extends rule="X509SubjectNameCheck"/>	
		</sch:rule>	
		
		<sch:rule context="apr:ApplicationResponse">
			<sch:extends rule="UBLVersionIDCheck"/>
			<sch:extends rule="CustomizationIDCheck"/>
			<sch:extends rule="ApplicationResponseProfileIDCheck"/>
			<sch:extends rule="IDCheck"/>
			<sch:extends rule="ARSignatureCheck"/>
			<sch:extends rule="DocumentResponseCountCheck"/>
			<!-- <sch:extends rule="URI2IDCheck"/> -->
			<sch:extends rule="SignatureCountCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cac:Signature">
			<sch:extends rule="SignatureCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cbc:UUID">
			<sch:extends rule="UUIDCheck"/>
		</sch:rule>

		<sch:rule context="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>
		<sch:rule context="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
			<sch:extends rule="ARSenderCheck"/>
		</sch:rule>		
		<sch:rule context="apr:ApplicationResponse/cac:SenderParty">
			<sch:extends rule="ARPartyIdentificationPartyNamePersonCheck"/>
			<sch:extends rule="ARPartyIdentificationGTBCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>
		<sch:rule context="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
			<sch:extends rule="ARReceiverCheck"/>
		</sch:rule>
		<sch:rule context="apr:ApplicationResponse/cac:ReceiverParty">
			<sch:extends rule="ARPartyIdentificationPartyNamePersonCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cac:DocumentResponse">
			<sch:extends rule="DocumentResponseCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cac:DocumentResponse/cac:Response">
			<sch:extends rule="ResponseCodeCheck"/>
			<sch:extends rule="PostBoxResponseCodeCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response">
			<sch:extends rule="DescriptionCountCheck"/>
			<sch:extends rule="PostBoxResponseCodeCheck"/>
			<sch:extends rule="AppResponseCodeCheck"/>
		</sch:rule>
		
		<sch:rule context="apr:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference">
			<sch:extends rule="PostBoxDocumentReferenceCheck"/>
		</sch:rule>
	</sch:pattern>
	
	<!-- hr:ProcessUserAccount -->
	<sch:pattern id="processuseraccount">
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea">
			<sch:extends rule="ApplicationAreaCheck"/>
		</sch:rule>
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Sender">
			<sch:extends rule="OASenderCheck"/>
		</sch:rule>
		
		<!-- Xades Signature  -->
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature">
			<sch:extends rule="OASignatureCheck"/>
		</sch:rule>	
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature">
			<sch:extends rule="XadesSignatureCheck"/>
		</sch:rule>
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data">
			<sch:extends rule="X509DataCheck"/>
		</sch:rule>
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName">
			<sch:extends rule="X509SubjectNameCheck"/>
		</sch:rule>
		
		<!-- Counter Signature -->
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature">
			<sch:extends rule="CounterSignatureCheck"/>
		</sch:rule>	
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature">
			<sch:extends rule="XadesSignatureCheck"/>
		</sch:rule>
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data">
			<sch:extends rule="X509DataCheck"/>
		</sch:rule>
		<sch:rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName">
			<sch:extends rule="X509SubjectNameCheck"/>
		</sch:rule>		

		<sch:rule context="hr:ProcessUserAccount/hr:DataArea">
			<sch:extends rule="UserAccountCountCheck" />
		</sch:rule>

		<sch:rule context="hr:ProcessUserAccount/hr:DataArea/hr:UserAccount">
			<sch:extends rule="UserAccountCheck" />
		</sch:rule>
	</sch:pattern>
	
	<!-- hr:CancelUserAccount -->
	<sch:pattern id="canceluseraccount">
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea">
			<sch:extends rule="ApplicationAreaCheck"/>
		</sch:rule>
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Sender">
			<sch:extends rule="OASenderCheck"/>
		</sch:rule>
		
		<!-- Xades Signature  -->
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature">
			<sch:extends rule="OASignatureCheck"/>
		</sch:rule>	
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature">
			<sch:extends rule="XadesSignatureCheck"/>
		</sch:rule>
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data">
			<sch:extends rule="X509DataCheck"/>
		</sch:rule>
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName">
			<sch:extends rule="X509SubjectNameCheck"/>
		</sch:rule>
		
		<!-- Counter Signature -->
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature">
			<sch:extends rule="CounterSignatureCheck"/>
		</sch:rule>	
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature">
			<sch:extends rule="XadesSignatureCheck"/>
		</sch:rule>
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data">
			<sch:extends rule="X509DataCheck"/>
		</sch:rule>
		<sch:rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName">
			<sch:extends rule="X509SubjectNameCheck"/>
		</sch:rule>		

		<sch:rule context="hr:CancelUserAccount/hr:DataArea">
			<sch:extends rule="UserAccountCountCheck" />
		</sch:rule>
		
		<sch:rule context="hr:CancelUserAccount/hr:DataArea/hr:UserAccount">
			<sch:extends rule="UserAccountCheck" />
		</sch:rule>
	</sch:pattern>

	<!-- DespatchAdvice-->
	<sch:pattern id="despatchadvice">
		<sch:rule context="desp:DespatchAdvice">
			<sch:extends rule="DespatchAdviceTypeCodeCheck"/>
			<sch:extends rule="InvoiceIDCheck"/>
			<sch:extends rule="CustomizationIDCheck"/>
			<sch:extends rule="ProfileIDTypeDespatchAdvice"/>
			<sch:extends rule="DespatchDateCheck"/>
			<sch:extends rule="DespatchTimeCheck"/>
			<sch:extends rule="DespatchAddressCheck"/>
			<sch:extends rule="DespatchCarrierDriverCheck"/>
			<sch:extends rule="DespatchAdviceHKSKunyeCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cbc:UUID">
			<sch:extends rule="UUIDCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:DespatchLine">
			<sch:extends rule="DeliveredQuantityCheck"/>
			<sch:extends rule="ItemNameCheck"/>
			<sch:extends rule="DespatchLineIdCheck"/>			
			<sch:extends rule="DespatchIdisEtiketNoCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
			<sch:extends rule="DocumentSenderCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
			<sch:extends rule="DocumentReceiverCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:Shipment/cac:Delivery/cac:CarrierParty/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:Shipment/cac:Delivery/cac:CarrierParty/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>
		<sch:rule context="desp:DespatchAdvice/cac:Shipment/cac:ShipmentStage/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID">
			<sch:extends rule="LicensePlateIDSchemeIDCheck"/>
		</sch:rule>		
		<sch:rule context="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>		
		<sch:rule context="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party">
			<sch:extends rule="PartyIdentificationPartyNamePersonCheck"/>
			<sch:extends rule="DespatchIdisSevkiyatNoCheck"/>
		</sch:rule>		
		<sch:rule context="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>		
		<sch:rule context="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party">
			<sch:extends rule="PartyIdentificationPartyNamePersonCheck"/>
		</sch:rule>
	</sch:pattern>
	
	<!-- ReceiptAdvice-->
	<sch:pattern id="receiptadvice">
		<sch:rule context="recp:ReceiptAdvice">
			<sch:extends rule="ReceiptAdviceTypeCodeCheck"/>
			<sch:extends rule="ReceiptAdviceIDCheck"/>
			<sch:extends rule="CustomizationIDCheck"/>
		</sch:rule>
		<sch:rule context="recp:ReceiptAdvice/cbc:UUID">
			<sch:extends rule="UUIDCheck"/>
		</sch:rule>
		<sch:rule context="recp:ReceiptAdvice/cac:ReceiptLine">
			<sch:extends rule="ItemNameCheck"/>
			<sch:extends rule="DespatchLineIdCheck"/>
		</sch:rule>
		<sch:rule context="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
		</sch:rule>
		<sch:rule context="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
		</sch:rule>
		<sch:rule context="recp:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification">
			<sch:extends rule="PartyIdentificationTCKNVKNCheck"/>
		</sch:rule>
		<sch:rule context="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>		
		<sch:rule context="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party">
			<sch:extends rule="PartyIdentificationPartyNamePersonCheck"/>
		</sch:rule>		
		<sch:rule context="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<sch:extends rule="PartyIdentificationSchemeIDCheck"/>
		</sch:rule>		
		<sch:rule context="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party">
			<sch:extends rule="PartyIdentificationPartyNamePersonCheck"/>
		</sch:rule>
	</sch:pattern>
	
	

</sch:schema>