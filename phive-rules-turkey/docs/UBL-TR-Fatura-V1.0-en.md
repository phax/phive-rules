# UBL-TR (Fatura — Invoice)

**TURKISH REVENUE ADMINISTRATION (Gelir İdaresi Başkanlığı)**
Audit and Compliance Management Department (Denetim ve Uyum Yönetim Daire Başkanlığı)

December 2017 — ANKARA
Version: 1.0

---

## Version History

| Version | Release Date | Added/Removed/Changed Section | Description |
|---------|--------------|--------------------------------|-------------|
| 0.1 | 28.11.2014 | -- | First release date of the draft guide |
| 0.2 | 31.03.2015 | Page 34 | TaxInclusiveAmount and PayableAmount fields in the example were **changed**. |
| 0.2 | 31.03.2015 | 2.3.37, 2.3.38, 2.3.39, 2.3.40 | Examples were **changed**. |
| 0.2 | 31.03.2015 | -- | First release date of the guide |
| 0.3 | 31.03.2016 | 2.3.5 | The ID field was **changed**. |
| 0.4 | 15.04.2016 | Page 22 | The Note field was **removed**. |
| 0.4 | 15.04.2016 | 2.3.21 | 2.3.21 was **changed**. |
| 1.0 | 20.12.2017 | Pages 17, 18 | Updated for EFT-POS in line with Communiqué No. 483. |

---

## Table of Contents

1. Introduction
2. UBL-TR INVOICE
   - 2.1 XSD Representation
   - 2.2 Invoice Elements — General
   - 2.3 Invoice Elements — Detail
     - 2.3.1 UBLExtensions
     - 2.3.2 UBLVersionID
     - 2.3.3 CustomizationID
     - 2.3.4 ProfileID
     - 2.3.5 ID
     - 2.3.6 CopyIndicator
     - 2.3.7 UUID
     - 2.3.8 IssueDate
     - 2.3.9 IssueTime
     - 2.3.10 InvoiceTypeCode
     - 2.3.11 Note
     - 2.3.12 DocumentCurrencyCode
     - 2.3.13 TaxCurrencyCode
     - 2.3.14 PricingCurrencyCode
     - 2.3.15 PaymentCurrencyCode
     - 2.3.16 PaymentAlternativeCurrencyCode
     - 2.3.17 AccountingCost
     - 2.3.18 LineCountNumeric
     - 2.3.19 InvoicePeriod
     - 2.3.20 OrderReference
     - 2.3.21 BillingReference
     - 2.3.22 DespatchDocumentReference
     - 2.3.23 ReceiptDocumentReference
     - 2.3.24 OriginatorDocumentReference
     - 2.3.25 ContractDocumentReference
     - 2.3.26 AdditionalDocumentReference
     - 2.3.27 Signature
     - 2.3.28 AccountingSupplierParty
     - 2.3.29 AccountingCustomerParty
     - 2.3.30 BuyerCustomerParty
     - 2.3.31 SellerSupplierParty
     - 2.3.32 TaxRepresentativeParty
     - 2.3.33 Delivery
     - 2.3.34 PaymentMeans
     - 2.3.35 PaymentTerms
     - 2.3.36 AllowanceCharge
     - 2.3.37 TaxExchangeRate
     - 2.3.38 PricingExchangeRate
     - 2.3.39 PaymentExchangeRate
     - 2.3.40 PaymentAlternativeExchangeRate
     - 2.3.41 TaxTotal
     - 2.3.42 WithholdingTaxTotal
     - 2.3.43 LegalMonetaryTotal
     - 2.3.44 InvoiceLine

---

## 1. Introduction

This guide has been prepared to provide information about the XSD, definition, usage forms and cardinalities of the elements of the invoice document contained in the UBL-TR v1.2 (UBL 2.1 Turkish Customisation) package and to demonstrate sample usages.

When describing each invoice element of the UBL-TR package in this guide, the following table structure has been used.

| [Element: UBL name] | [Element: Turkish equivalent] |
|---------------------|--------------------------------|
| **Diagram** | The diagram of the element described in this row is shown. |
| **Cardinality** | This section presents the cardinality of the element. Cardinalities can be:<br>**Mandatory (1):** The element is mandatory and must occur exactly once.<br>**Mandatory (1..n):** The element is mandatory and must occur at least once. The element may repeat.<br>**Optional (0..1):** The element is optional and may occur at most once.<br>**Optional (0..n):** The element is optional and may repeat. |
| **Description** | This section describes the purpose of the element. |
| **Usage** | How the element is used, its relationships with other elements, its data type and the constraints applied to it are described in detail in this section. The common classes used by complex elements are referenced via "See". |
| **Example** | One or more XML examples of the element are provided in this section. |

---

## 2. UBL-TR INVOICE

### 2.1 XSD Representation

The representation of the main elements of the XSD schema for the invoice document in the UBL-TR package is as follows.

(InvoiceType main elements: ext:UBLExtensions, cbc:UBLVersionID, cbc:CustomizationID, cbc:ProfileID, cbc:ID, cbc:CopyIndicator, cbc:UUID, cbc:IssueDate, cbc:IssueTime, cbc:InvoiceTypeCode, cbc:Note, cbc:DocumentCurrencyCode, cbc:TaxCurrencyCode, cbc:PricingCurrencyCode, cbc:PaymentCurrencyCode, cbc:PaymentAlternativeCurrencyCode, cbc:AccountingCost, cbc:LineCountNumeric, cac:InvoicePeriod, cac:OrderReference, cac:BillingReference, cac:DespatchDocumentReference, cac:ReceiptDocumentReference, cac:OriginatorDocumentReference, cac:ContractDocumentReference, cac:AdditionalDocumentReference, cac:Signature, cac:AccountingSupplierParty, cac:AccountingCustomerParty, cac:BuyerCustomerParty, cac:SellerSupplierParty, cac:TaxRepresentativeParty, cac:Delivery, cac:PaymentMeans, cac:PaymentTerms, cac:AllowanceCharge, cac:TaxExchangeRate, cac:PricingExchangeRate, cac:PaymentExchangeRate, cac:PaymentAlternativeExchangeRate, cac:TaxTotal, cac:WithholdingTaxTotal, cac:LegalMonetaryTotal, cac:InvoiceLine)

### 2.2 Invoice Elements — General

The Turkish equivalents and content descriptions of the main elements of the XSD schema for the invoice document are listed in the table below.

| No | UBL Name | Turkish Equivalent | Content |
|----|----------|--------------------|---------|
| 1 | UBLExtensions | UBL Genişletme Alanı (UBL Extension Area) | UBL Extension Area — Contains Electronic Signature information in XAdES format. |
| 2 | UBLVersionID | UBL Versiyon Numarası | UBL version number. |
| 3 | CustomizationID | Özelleştirme Numarası | UBL customisation number. |
| 4 | ProfileID | Senaryo | The scenario used. |
| 5 | ID | Fatura Numarası | Invoice number. |
| 6 | CopyIndicator | Asıl / Suret | Indicates whether the invoice is an original or copy. |
| 7 | UUID | Evrensel Tekil Tanımlama Numarası (ETTN) | Number that ensures the universal uniqueness of the invoice. |
| 8 | IssueDate | Düzenleme Tarihi | Issue date of the invoice. |
| 9 | IssueTime | Düzenleme Zamanı | Issue time of the invoice. |
| 10 | InvoiceTypeCode | Fatura Tip Kodu | Invoice type code. |
| 11 | Note | Not | General notes related to the invoice. |
| 12 | DocumentCurrencyCode | Belge Para Birim Kodu | Code of the currency in which the invoice is issued. |
| 13 | TaxCurrencyCode | Vergi Para Birim Kodu | Currency code to be used for tax payments other than the document currency. |
| 14 | PricingCurrencyCode | Fiyatlandırma Para Birim Kodu | Currency code to be used for pricing other than the document currency. |
| 15 | PaymentCurrencyCode | Ödeme Para Birim Kodu | Currency code to be used for payment other than the document currency. |
| 16 | PaymentAlternativeCurrencyCode | Alternatif Ödeme Para Birim Kodu | Alternative currency code to be used for payment other than the document and payment currency. |
| 17 | AccountingCost | İlave Fatura Tipi Ayrımı | Allows the taxpayer to specify a custom invoice type if a further classification is needed. |
| 18 | LineCountNumeric | Kalem Sayısı | Number of invoice line items. |
| 19 | InvoicePeriod | Fatura Dönemi | The period to which the invoice belongs. |
| 20 | OrderReference | Sipariş Bilgileri | Order information. |
| 21 | BillingReference | Diğer İlişkili Olduğu Belgelerin Bilgileri | Information of other documents related to the invoice. |
| 22 | DespatchDocumentReference | İrsaliye Bilgileri | Despatch advice (irsaliye) information. |
| 23 | ReceiptDocumentReference | Alındı Bilgileri | Receipt information. |
| 24 | OriginatorDocumentReference | Başlangıç Dokümanı Bilgileri | Information of documents that constitute the reference for issuing the invoice. |
| 25 | ContractDocumentReference | Kontrat Dokümanı Bilgileri | Contract document information. |
| 26 | AdditionalDocumentReference | İlave Doküman | Information about other documents related to the invoice. |
| 27 | Signature | Mali Mühür/İmza | Electronic Fiscal Seal and/or Electronic Signature with related certificate information. |
| 28 | AccountingSupplierParty | Satıcı | Information about the party issuing the invoice. |
| 29 | AccountingCustomerParty | Alıcı | Information about the party receiving the invoice. |
| 30 | BuyerCustomerParty | Faturadaki Hizmeti/Mal Alan Taraf | The party receiving the goods or services on the invoice, other than the invoice buyer. |
| 31 | SellerSupplierParty | Faturadaki Hizmeti/Mal Sağlayan Taraf | The party providing the goods or services on the invoice, other than the invoice issuer. |
| 32 | TaxRepresentativeParty | Vergi İşleriyle Sorumlu Taraf | Party responsible for tax affairs. |
| 33 | Delivery | Gönderim, Taşıma, Sevkiyat Bilgileri | Delivery, transport and shipment information. |
| 34 | PaymentMeans | Ödeme Şekli | Payment means information. |
| 35 | PaymentTerms | Ödeme Koşulları | Payment terms information. |
| 36 | AllowanceCharge | Iskonto/Artırım | Discount or surcharge information applied to the invoice. |
| 37 | TaxExchangeRate | Vergi Döviz Kuru | Exchange rate to be used for tax calculation when other than the document currency. |
| 38 | PricingExchangeRate | Fiyatlandırma Döviz Kuru | Exchange rate to be used for pricing when other than the document currency. |
| 39 | PaymentExchangeRate | Ödeme Döviz Kuru | Exchange rate to be used for payment when other than the document currency. |
| 40 | PaymentAlternativeExchangeRate | Ödeme Alternatif Döviz Kuru | Alternative payment exchange rate to be used when other than the document and payment currency. |
| 41 | TaxTotal | Toplam Vergi | Tax information and totals. |
| 42 | WithholdingTaxTotal | Tevkifat Bilgileri | Withholding tax information. |
| 43 | LegalMonetaryTotal | Parasal Toplamlar | Totals of monetary amounts on the invoice. |
| 44 | InvoiceLine | Mal/Hizmet Kalemleri | Goods/services lines covered by the invoice. |

Each main element listed in the table is described in detail in the following section. The description method gives priority to the element name, its Turkish equivalent, usage form, and examples.

---

## 2.3 Invoice Elements — Detail

### 2.3.1 UBLExtensions

| UBLExtensions | UBL Extension Area |
|---------------|---------------------|
| **Cardinality** | Mandatory (1..n) |
| **Description** | Fiscal seal / electronic signature information in XAdES format will be written into this area. |
| **Usage** | See Common Classes: UBLExtension |
| **Example** | `<ext:UBLExtensions>` structure containing an XAdES electronic signature (including ds:Signature, ds:SignedInfo, ds:CanonicalizationMethod, ds:SignatureMethod, ds:Reference, ds:Transforms, ds:DigestMethod, ds:DigestValue, ds:SignatureValue, ds:KeyInfo, ds:X509Data, ds:X509Certificate, ds:KeyValue, ds:RSAKeyValue, ds:Modulus, ds:Exponent). |

### 2.3.2 UBLVersionID

| UBLVersionID | UBL Version Number |
|--------------|---------------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The UBL version of the XSD document is written. |
| **Usage** | The value "2.1" is used. |
| **Example** | `<cbc:UBLVersionID>2.1</cbc:UBLVersionID>` |

### 2.3.3 CustomizationID

| CustomizationID | Customisation Number |
|-----------------|------------------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The customisation number of UBL. |
| **Usage** | The value "TR1.2" is used. |
| **Example** | `<cbc:CustomizationID>TR1.2</cbc:CustomizationID>` |

### 2.3.4 ProfileID

| ProfileID | Scenario |
|-----------|----------|
| **Cardinality** | Mandatory (1) |
| **Description** | The scenario being used. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:ProfileID>TEMELFATURA</cbc:ProfileID>` |

### 2.3.5 ID

| ID | Invoice Number |
|----|-----------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The Invoice Number — composed of a 3-character alphanumeric unit code combined with a 13-digit sequential number — is written into this element. The first four digits of the sequential number indicate the year in which the invoice was issued; the remaining nine digits represent the sequential number. The same invoice number cannot be used more than once by the issuing entity. |
| **Usage** | Alphanumeric |
| **Example** | `<cbc:ID>GIB2009000000001</cbc:ID> ` |

### 2.3.6 CopyIndicator

| CopyIndicator | Original/Copy |
|---------------|----------------|
| **Cardinality** | Mandatory (1) |
| **Description** | Indicates whether the issued invoice is an original or a copy. |
| **Usage** | "false" if original, "true" if copy. |
| **Example** | `<cbc:CopyIndicator>true</cbc:CopyIndicator>` |

### 2.3.7 UUID

| UUID | Universally Unique Identifier |
|------|--------------------------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The Universally Unique Identifier (ETTN) is the number ensuring the universal uniqueness of the issued invoice. It is generated by the invoice issuer in accordance with the standards and used in the invoices. |
| **Usage** | GUID format |
| **Example** | `<cbc:UUID>e093a490-dd99-11dd-ad8b-0800200c9a66</cbc:UUID>` |

### 2.3.8 IssueDate

| IssueDate | Issue Date |
|-----------|------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The issue date of the invoice is written. |
| **Usage** | Year-Month-Day (YYYY-MM-DD) |
| **Example** | `<cbc:IssueDate>2009-01-01</cbc:IssueDate>` |

### 2.3.9 IssueTime

| IssueTime | Issue Time |
|-----------|-------------|
| **Cardinality** | Optional (0..1) |
| **Description** | The issue time of the invoice may be written. |
| **Usage** | Hour:Minute:Second |
| **Example** | `<cbc:IssueTime>14:50:00</cbc:IssueTime>` |

### 2.3.10 InvoiceTypeCode

| InvoiceTypeCode | Invoice Type Code |
|------------------|---------------------|
| **Cardinality** | Mandatory (1) |
| **Description** | Codes for the invoice types available in UBL-TR are written here. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:InvoiceTypeCode>SATIS</cbc:InvoiceTypeCode>` |

### 2.3.11 Note

| Note | Note |
|------|------|
| **Cardinality** | Optional (0..n) |
| **Description** | This element is used for general notes intended to appear on the invoice. The element may be repeated when multiple notes are needed. |
| **Usage** | Free Text |
| **Example** | `<cbc:Note>If the contents of this invoice are not contested within 7 days, it shall be deemed accepted as is.</cbc:Note>` |

### 2.3.12 DocumentCurrencyCode

| DocumentCurrencyCode | Document Currency Code |
|----------------------|--------------------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The code of the currency in which the invoice is issued is written into this element. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:DocumentCurrencyCode>TRY</cbc:DocumentCurrencyCode>` |

### 2.3.13 TaxCurrencyCode

| TaxCurrencyCode | Tax Currency Code |
|-----------------|---------------------|
| **Cardinality** | Optional (0..1) |
| **Description** | If the taxes shown on the invoice need to be presented in a currency other than the "Document Currency Code", the code of that currency may be written here. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:TaxCurrencyCode>USD</cbc:TaxCurrencyCode>` |

### 2.3.14 PricingCurrencyCode

| PricingCurrencyCode | Pricing Currency Code |
|---------------------|--------------------------|
| **Cardinality** | Optional (0..1) |
| **Description** | If goods or service prices need to be shown in a currency other than the "Document Currency Code", that currency may be coded into this element. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:PricingCurrencyCode>USD</cbc:PricingCurrencyCode>` |

### 2.3.15 PaymentCurrencyCode

| PaymentCurrencyCode | Payment Currency Code |
|---------------------|--------------------------|
| **Cardinality** | Optional (0..1) |
| **Description** | If the payment is to be made in a currency other than the "Document Currency Code", the currency in which the amounts are expressed may be coded into this element. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:PaymentCurrencyCode>USD</cbc:PaymentCurrencyCode>` |

### 2.3.16 PaymentAlternativeCurrencyCode

| PaymentAlternativeCurrencyCode | Alternative Payment Currency Code |
|--------------------------------|-------------------------------------|
| **Cardinality** | Optional (0..1) |
| **Description** | If the payable amount is also to be expressed in a currency other than the document currency and the payment currency, the code of that currency may be written here. |
| **Usage** | See Code Lists |
| **Example** | `<cbc:PaymentAlternativeCurrencyCode>USD</cbc:PaymentAlternativeCurrencyCode>` |

### 2.3.17 AccountingCost

| AccountingCost | Account Code |
|----------------|---------------|
| **Cardinality** | Optional (0..1) |
| **Description** | If the taxpayer needs an additional invoice-type classification, a different invoice type defined by the taxpayer may be written here. |
| **Usage** | Free Text |
| **Example** | `<cbc:AccountingCost>Gider</cbc:AccountingCost>` |

### 2.3.18 LineCountNumeric

| LineCountNumeric | Line Count |
|------------------|--------------|
| **Cardinality** | Mandatory (1) |
| **Description** | The number of line items on the invoice is written here. Even if the count of an item is greater than one, that item group is shown as a single line. |
| **Usage** | Numeric |
| **Example** | `<cbc:LineCountNumeric>2</cbc:LineCountNumeric>` |

### 2.3.19 InvoicePeriod

| InvoicePeriod | Invoice Period |
|---------------|------------------|
| **Diagram (fields)** | cbc:StartDate, cbc:StartTime, cbc:EndDate, cbc:EndTime, cbc:DurationMeasure, cbc:Description |
| **Cardinality** | Optional (0..1) |
| **Description** | Used when period information is to be included on the invoice. |
| **Usage** | See Common Classes: Period |
| **Example** | `<cac:InvoicePeriod><cbc:StartDate>2009-08-13</cbc:StartDate><cbc:EndDate>2009-09-13</cbc:EndDate><cbc:Description>[DESCRIPTION]</cbc:Description></cac:InvoicePeriod>` |

### 2.3.20 OrderReference

| OrderReference | Order Information |
|----------------|--------------------|
| **Diagram (fields)** | cbc:ID, cbc:SalesOrderID, cbc:IssueDate, cbc:OrderTypeCode, cac:DocumentReference |
| **Cardinality** | Optional (0..1) |
| **Description** | Used to display order information and to attach the order document to the invoice. |
| **Usage** | See Common Classes: OrderReference |
| **Example** | `<cac:OrderReference><cbc:ID>12345</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:OrderReference>` |

### 2.3.21 BillingReference

| BillingReference | Information of Other Related Documents |
|------------------|------------------------------------------|
| **Diagram (fields)** | cac:InvoiceDocumentReference, cac:SelfBilledInvoiceDocumentReference, cac:CreditNoteDocumentReference, cac:DebitNoteDocumentReference, cac:ReminderDocumentReference, cac:BillingReferenceLine |
| **Cardinality** | Optional (0..n) |
| **Description** | Information of other documents to which the invoice is related is written here.<br><br>**NOTE:** If the New Generation Cash Register (ÖKC) information slip data issued under VUK General Communiqué No. 433 is used, it shall be written under this element in the AdditionalDocumentReference element as follows:<br>- AdditionalDocumentReference/ID: Slip Number.<br>- AdditionalDocumentReference/IssueDate: Information slip date.<br>- AdditionalDocumentReference/DocumentTypeCode: must be the fixed value "OKCBF".<br>- AdditionalDocumentReference/DocumentType: must be the fixed value "OKCBilgiFisi".<br>- AdditionalDocumentReference/DocumentDescription: information slip type. Allowed values: AVANS, YEMEK_FIS, E-FATURA, E-FATURA_IRSALIYE, E-ARSIV, E-ARSIV_IRSALIYE, FATURA, OTOPARK, FATURA_TAHSILAT, FATURA_TAHSILAT_KOMISYONLU.<br>- AdditionalDocumentReference/Attachment/ExternalReference/URI: Z-Report number. Those exempted from EFT-POS use under VUK General Communiqué No. 483 shall write the value "483" in this field.<br>- AdditionalDocumentReference/ValidityPeriod/StartDate: when the document substitutes a despatch advice, the information slip date shall be written.<br>- AdditionalDocumentReference/ValidityPeriod/cbc:StartTime: when the document substitutes a despatch advice, the information slip time shall be written.<br>- AdditionalDocumentReference/IssuerParty/EndpointID: ÖKC serial number. Those exempted from EFT-POS use under VUK General Communiqué No. 483 shall write the value "483" in this field. |
| **Usage** | See Common Classes: BillingReference |
| **Example 1** | `<cac:BillingReference><cac:InvoiceDocumentReference><cbc:ID>12345</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:InvoiceDocumentReference></cac:BillingReference>` |
| **Example 2** | Full BillingReference example carrying an ÖKC information slip. AdditionalDocumentReference (ID=Slip no, IssueDate, DocumentTypeCode=OKCBF, DocumentType=OKCBilgiFisi, DocumentDescription=E-FATURA), Attachment/ExternalReference/URI=Z-Report no, ValidityPeriod/StartDate and StartTime, IssuerParty/EndpointID=MF XXX 11000100 (ÖKC serial no), PartyIdentification, PostalAddress (CitySubdivisionName, CityName, Country/Name). |

### 2.3.22 DespatchDocumentReference

| DespatchDocumentReference | Despatch Advice Information |
|---------------------------|--------------------------------|
| **Diagram (fields)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Cardinality** | Optional (0..n) |
| **Description** | This element may be used for despatch advice information. It may also be used to enter information of multiple despatch advices and to attach the despatch advice document to the invoice. |
| **Usage** | See Common Classes: DocumentReference |
| **Example** | `<cac:DespatchDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:DespatchDocumentReference>` |

### 2.3.23 ReceiptDocumentReference

| ReceiptDocumentReference | Receipt Information |
|--------------------------|----------------------|
| **Diagram (fields)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Cardinality** | Optional (0..n) |
| **Description** | Used to display receipt information and to attach the receipt document to the invoice. |
| **Usage** | See Common Classes: DocumentReference |
| **Example** | `<cac:ReceiptDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:ReceiptDocumentReference>` |

### 2.3.24 OriginatorDocumentReference

| OriginatorDocumentReference | Originator Document Information |
|------------------------------|-----------------------------------|
| **Diagram (fields)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Cardinality** | Optional (0..n) |
| **Description** | Information about related documents that constitute the reference for issuing the invoice is written here. |
| **Usage** | See Common Classes: DocumentReference |
| **Example** | `<cac:OriginatorDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:OriginatorDocumentReference>` |

### 2.3.25 ContractDocumentReference

| ContractDocumentReference | Contract Document Information |
|---------------------------|---------------------------------|
| **Diagram (fields)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Cardinality** | Optional (0..n) |
| **Description** | Used to display the information of the contract document related to the invoice. |
| **Usage** | See Common Classes: DocumentReference |
| **Example** | `<cac:ContractDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:ContractDocumentReference>` |

### 2.3.26 AdditionalDocumentReference

| AdditionalDocumentReference | Additional Document |
|------------------------------|----------------------|
| **Diagram (fields)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Cardinality** | Optional (0..n) |
| **Description** | Used for any documents — other than despatch advice, order, contract, receipt and other invoice documents — that are to be attached to the invoice. For example, when an additional invoice in a different currency is to be issued, that invoice can be issued and attached inside the EmbeddedDocumentBinaryObject element of AdditionalDocumentReference. |
| **Usage** | See Common Classes: DocumentReference |
| **Example** | `<cac:AdditionalDocumentReference><cbc:ID>1234</cbc:ID><cbc:IssueDate>2008-08-13</cbc:IssueDate><cac:Attachment><cbc:EmbeddedDocumentBinaryObject mimeCode="application/CSTAdata+xml">UjBsR09EbGhjZ0dTQUxNQUFBR0FBUlU1tQ1p0dU1GUXhFUzhi</cbc:EmbeddedDocumentBinaryObject></cac:Attachment></cac:AdditionalDocumentReference>` |

### 2.3.27 Signature

| Signature | Fiscal Seal/Signature |
|-----------|------------------------|
| **Diagram (fields)** | cbc:ID, SignatoryParty, DigitalSignatureAttachment |
| **Cardinality** | Mandatory (1..n) |
| **Description** | Information about the fiscal seal and/or electronic signature used on the invoice and the related certificates is provided in this element. |
| **Usage** | See Common Classes: Signature |
| **Example** | Full structure starting with `<cac:Signature><cbc:ID>1288331521</cbc:ID><cac:SignatoryParty>` and containing PartyIdentification (VKN), PostalAddress (StreetName=Ihlamur Mahallesi Selvi Caddesi Sedir Sokak, BuildingNumber=75/A, CitySubdivisionName=Kızılay, CityName=Ankara, PostalZone=06100, Country/Name=Türkiye) and DigitalSignatureAttachment/ExternalReference/URI=#12345. |

### 2.3.28 AccountingSupplierParty

| AccountingSupplierParty | Seller |
|-------------------------|--------|
| **Cardinality** | Mandatory (1) |
| **Description** | The information about the party issuing the invoice is provided in this element. |
| **Usage** | See Common Classes: SupplierParty |
| **Example** | `<cac:AccountingSupplierParty><cac:Party>` containing WebsiteURI=http://www.bbb.com.tr/, PartyIdentification/ID schemeID="VKN"=9205121120, PartyName=BBB Limited Şirketi, PostalAddress (ID=1234567890, StreetName=Ihlamur Mahallesi Selvi Caddesi Sedir Sokak, BuildingNumber=75/A, CitySubdivisionName=Kızılay, CityName=Ankara, PostalZone=06100, Country/Name=Türkiye), PartyTaxScheme/TaxScheme/Name=Çankaya, Contact (Telephone=(312) 621 1111, Telefax=(312) 621 1010, ElectronicMail=bb@bbb.com.tr). |

### 2.3.29 AccountingCustomerParty

| AccountingCustomerParty | Buyer |
|-------------------------|--------|
| **Cardinality** | Mandatory (1) |
| **Description** | The information about the party receiving the invoice is provided in this element. |
| **Usage** | See Common Classes: CustomerParty |
| **Example** | `<cac:AccountingCustomerParty><cac:Party>` containing WebsiteURI=http://www.aaa.com.tr/, PartyIdentification/ID schemeID="VKN"=1288331521, PartyName=AAA Anonim Şirketi, PostalAddress (ID=1234567890, StreetName=Papatya Caddesi Yasemin Sokak, BuildingNumber=21, CitySubdivisionName=Beşiktaş, CityName=İstanbul, PostalZone=34100, Country/Name=Türkiye), PartyTaxScheme/TaxScheme/Name=Büyük Mükellefler, Contact (Telephone=(212) 925 51515, Telefax=(212) 925505015, ElectronicMail=aa@aaa.com.tr). |

### 2.3.30 BuyerCustomerParty

| BuyerCustomerParty | Party Receiving the Goods/Service on the Invoice |
|--------------------|----------------------------------------------------|
| **Cardinality** | Optional (0..1) |
| **Description** | This element is used for the party receiving the goods or services on the invoice when different from the invoice buyer. |
| **Usage** | See Common Classes: CustomerParty |
| **Example** | BuyerCustomerParty in the same structure as the AccountingCustomerParty example. |

### 2.3.31 SellerSupplierParty

| SellerSupplierParty | Party Providing the Goods/Service on the Invoice |
|---------------------|----------------------------------------------------|
| **Cardinality** | Optional (0..1) |
| **Description** | This element is used for the party providing the goods or services on the invoice when different from the invoice issuer. |
| **Usage** | See Common Classes: SupplierParty |
| **Example** | SellerSupplierParty example with the same structure as AccountingCustomerParty/BuyerCustomerParty. |

### 2.3.32 TaxRepresentativeParty

| TaxRepresentativeParty | Party Responsible for Tax Affairs |
|------------------------|-------------------------------------|
| **Diagram (fields)** | cbc:WebsiteURI, cbc:IndustryClassificationCode, cac:PartyIdentification (1..n), cac:PartyName, cac:PostalAddress, cac:PartyTaxScheme, cac:PartyLegalEntity (0..n), cac:Contact, cac:Person, cac:AgentParty |
| **Cardinality** | Optional (0..1) |
| **Description** | This element is used to add information about the party responsible for tax affairs on the invoice, if needed. |
| **Usage** | See Common Classes: Party |
| **Example** | TaxRepresentativeParty/Party structure (WebsiteURI, PartyIdentification VKN=1288331521, PartyName=AAA Anonim Şirketi, PostalAddress, PartyTaxScheme, Contact). |

### 2.3.33 Delivery

| Delivery | Delivery, Transport, Shipment Information |
|----------|---------------------------------------------|
| **Diagram (fields)** | cbc:ID, cbc:Quantity, cbc:ActualDeliveryDate, cbc:ActualDeliveryTime, cbc:LatestDeliveryDate, cbc:LatestDeliveryTime, cbc:TrackingID, cac:DeliveryAddress, cac:AlternativeDeliveryLocation, cac:EstimatedDeliveryPeriod, cac:CarrierParty, cac:DeliveryParty, cac:Despatch, cac:DeliveryTerms (0..n), cac:Shipment |
| **Cardinality** | Optional (0..n) |
| **Description** | Information about delivery, transport and shipment may be written into this element. |
| **Usage** | See Common Classes: Delivery |
| **Example** | DeliveryAddress (CityName=Bakü, Country/Name=Azerbaycan), DeliveryParty (PartyIdentification VKN=1288331521, PartyName=AAA Nakliyat, PostalAddress=Papatya Caddesi Yasemin Sokak 21, Beşiktaş, İstanbul, 34100, Türkiye), DeliveryTerms/ID=CIF, Shipment (GrossWeightMeasure unitCode="KGM"=14444, NetWeightMeasure unitCode="KGM"=14414, TotalTransportHandlingUnitQuantity=21, InsuranceValueAmount currencyID="USD"=150, DeclaredForCarriageValueAmount currencyID="USD"=3900). |

### 2.3.34 PaymentMeans

| PaymentMeans | Payment Means |
|--------------|----------------|
| **Diagram (fields)** | cbc:PaymentMeansCode, cbc:PaymentDueDate, cbc:PaymentChannelCode, cbc:InstructionNote, cac:PayerFinancialAccount, cac:PayeeFinancialAccount |
| **Cardinality** | Optional (0..n) |
| **Description** | Information about the means of payment may be written into this element. |
| **Usage** | See Common Classes: PaymentMeans |
| **Example** | `<cac:PaymentMeans><cbc:PaymentMeansCode>42</cbc:PaymentMeansCode><cbc:PaymentDueDate>2009-01-13</cbc:PaymentDueDate><cbc:PaymentChannelCode>1234</cbc:PaymentChannelCode><cbc:InstructionNote>[DESCRIPTION]</cbc:InstructionNote><cac:PayeeFinancialAccount><cbc:ID>IBANTR12345567</cbc:ID><cbc:CurrencyCode>TRY</cbc:CurrencyCode><cbc:PaymentNote>[PAYMENT NOTE]</cbc:PaymentNote></cac:PayeeFinancialAccount></cac:PaymentMeans>` |

### 2.3.35 PaymentTerms

| PaymentTerms | Payment Terms |
|--------------|----------------|
| **Diagram (fields)** | cbc:Note, cbc:PenaltySurchargePercent, cbc:Amount, cbc:PenaltyAmount, cbc:PaymentDueDate, cac:SettlementPeriod |
| **Cardinality** | Optional (0..1) |
| **Description** | Payment terms and the penalties to be applied in case of non-payment may be written here. |
| **Usage** | See Common Classes: PaymentTerms |
| **Example** | `<cac:PaymentTerms><cbc:Note>[DESCRIPTION]</cbc:Note><cbc:PenaltySurchargePercent>20.0</cbc:PenaltySurchargePercent><cbc:PaymentDueDate>2009-01-13</cbc:PaymentDueDate><cbc:Amount currencyID="TRY">100.0</cbc:Amount></cac:PaymentTerms>` |

### 2.3.36 AllowanceCharge

| AllowanceCharge | Discount / Surcharge |
|-----------------|------------------------|
| **Diagram (fields)** | cbc:ChargeIndicator, cbc:AllowanceChargeReason, cbc:MultiplierFactorNumeric, cbc:SequenceNumeric, cbc:Amount, cbc:BaseAmount, cbc:PerUnitAmount |
| **Cardinality** | Optional (0..n) |
| **Description** | Used when a discount or surcharge is applied to the invoice as a whole. |
| **Usage** | See Common Classes: AllowanceCharge |
| **Example** | `<cac:AllowanceCharge><cbc:ChargeIndicator>false</cbc:ChargeIndicator><cbc:AllowanceChargeReason>[DISCOUNT]</cbc:AllowanceChargeReason><cbc:MultiplierFactorNumeric>0.5</cbc:MultiplierFactorNumeric><cbc:Amount currencyID="TRY">100</cbc:Amount><cbc:BaseAmount currencyID="TRY">200</cbc:BaseAmount></cac:AllowanceCharge>` |

### 2.3.37 TaxExchangeRate

| TaxExchangeRate | Tax Exchange Rate |
|-----------------|---------------------|
| **Diagram (fields)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Cardinality** | Optional (0..1) |
| **Description** | If the taxes shown on the document are presented in a currency other than the "Document Currency", the related exchange rate is written here. |
| **Usage** | See Common Classes: ExchangeRate |
| **Example** | `<cac:TaxExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:TaxExchangeRate>` |

### 2.3.38 PricingExchangeRate

| PricingExchangeRate | Pricing Exchange Rate |
|---------------------|--------------------------|
| **Diagram (fields)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Cardinality** | Optional (0..1) |
| **Description** | When goods or service prices on the invoice are shown in a currency other than the "Document Currency", the related exchange rate is written here. |
| **Usage** | See Common Classes: ExchangeRate |
| **Example** | `<cac:PricingExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:PricingExchangeRate>` |

### 2.3.39 PaymentExchangeRate

| PaymentExchangeRate | Payment Exchange Rate |
|---------------------|--------------------------|
| **Diagram (fields)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Cardinality** | Optional (0..1) |
| **Description** | When the payment is to be made in a currency other than the "Document Currency", the exchange rate of the related currency is written here. |
| **Usage** | See Common Classes: ExchangeRate |
| **Example** | `<cac:PaymentExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:PaymentExchangeRate>` |

### 2.3.40 PaymentAlternativeExchangeRate

| PaymentAlternativeExchangeRate | Alternative Payment Exchange Rate |
|--------------------------------|-------------------------------------|
| **Diagram (fields)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Cardinality** | Optional (0..1) |
| **Description** | If, beyond the document currency and the payment currency, an alternative currency is to be used to settle the invoice, the exchange rate information of that currency is written here. |
| **Usage** | See Common Classes: ExchangeRate |
| **Example** | `<cac:PaymentAlternativeExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:PaymentAlternativeExchangeRate>` |

### 2.3.41 TaxTotal

| TaxTotal | Tax Total |
|----------|------------|
| **Diagram (fields)** | cbc:TaxAmount, cac:TaxSubtotal (1..n) |
| **Cardinality** | Mandatory (1..n) |
| **Description** | Information about taxes and other legal obligations on the invoice is written here. |
| **Usage** | See Common Classes: TaxTotal |
| **Example** | `<cac:TaxTotal><cbc:TaxAmount currencyID="TRY">6.33</cbc:TaxAmount>` ... structure with two TaxSubtotals: 1) TaxableAmount=19.17, TaxAmount=3.45, CalculationSequenceNumeric=1, Percent=18.0, TaxScheme/Name=Katma Değer Vergisi (VAT), TaxScheme/TaxTypeCode=0015; 2) TaxableAmount=19.17, TaxAmount=2.88, CalculationSequenceNumeric=2, TransactionCurrencyTaxAmount=0.0, Percent=15.0, TaxScheme/Name=Özel İletişim Vergisi (Special Communication Tax), TaxScheme/TaxTypeCode=4080. |

### 2.3.42 WithholdingTaxTotal

| WithholdingTaxTotal | Withholding Tax Information |
|---------------------|--------------------------------|
| **Diagram (fields)** | cbc:TaxAmount, cac:TaxSubtotal (1..n) |
| **Cardinality** | Optional (0..n) |
| **Description** | Information about withholding for invoices subject to withholding tax is written here. |
| **Usage** | See Common Classes: TaxTotal |
| **Example** | `<cac:WithholdingTaxTotal><cbc:TaxAmount currencyID="TRY">3240</cbc:TaxAmount><cac:TaxSubtotal><cbc:TaxAmount currencyID="TRY">3240</cbc:TaxAmount><cbc:Percent>90</cbc:Percent><cac:TaxCategory><cac:TaxScheme><cbc:TaxTypeCode>606</cbc:TaxTypeCode></cac:TaxScheme></cac:TaxCategory></cac:TaxSubtotal></cac:WithholdingTaxTotal>` |

### 2.3.43 LegalMonetaryTotal

| LegalMonetaryTotal | Monetary Totals |
|--------------------|-------------------|
| **Diagram (fields)** | cbc:LineExtensionAmount, cbc:TaxExclusiveAmount, cbc:TaxInclusiveAmount, cbc:AllowanceTotalAmount, cbc:ChargeTotalAmount, cbc:PayableRoundingAmount, cbc:PayableAmount |
| **Cardinality** | Mandatory (1) |
| **Description** | Totals of various amounts on the invoice are placed here. |
| **Usage** | See Common Classes: LegalMonetaryTotal |
| **Example** | `<cac:LegalMonetaryTotal><cbc:LineExtensionAmount currencyID="TRY">90</cbc:LineExtensionAmount><cbc:TaxExclusiveAmount currencyID="TRY">80</cbc:TaxExclusiveAmount><cbc:TaxInclusiveAmount currencyID="TRY">94</cbc:TaxInclusiveAmount><cbc:AllowanceTotal currencyID="TRY">10</cbc:AllowanceTotal><cbc:PayableRoundingAmount currencyID="TRY">0.4</cbc:PayableRoundingAmount><cbc:PayableAmount currencyID="TRY">94.4</cbc:PayableAmount></cac:LegalMonetaryTotal>` |

### 2.3.44 InvoiceLine

| InvoiceLine | Goods/Service Line Items |
|-------------|----------------------------|
| **Diagram (fields)** | cbc:ID, cbc:Note (0..n), cbc:InvoicedQuantity, cbc:LineExtensionAmount, cac:OrderLineReference (0..n), cac:DespatchLineReference (0..n), cac:ReceiptLineReference (0..n), cac:Delivery (0..n), cac:AllowanceCharge (0..n), cac:TaxTotal, cac:WithholdingTaxTotal (0..n), cac:Item, cac:Price, cac:SubInvoiceLine (0..n) |
| **Cardinality** | Mandatory (1..n) |
| **Description** | Information about goods and/or services on the invoice is placed here. |
| **Usage** | See Common Classes: InvoiceLine |
| **Example** | `<cac:InvoiceLine><cbc:ID>1</cbc:ID><cbc:InvoicedQuantity unitCode="BX">30</cbc:InvoicedQuantity><cbc:LineExtensionAmount currencyID="TRY">1800</cbc:LineExtensionAmount><cac:Item><cbc:Name>PRODUCT NAME</cbc:Name><cac:SellersItemIdentification><cbc:ID>1234567</cbc:ID></cac:SellersItemIdentification></cac:Item><cac:Price><cbc:PriceAmount currencyID="TRY">60</cbc:PriceAmount></cac:Price></cac:InvoiceLine>` |
