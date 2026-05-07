# Turkey UBL-TR / e-Fatura — Technical Implementation Summary

A consolidated, English summary of all technical-implementation-relevant material extracted from the documents and packages downloaded from the Turkish Revenue Administration (GİB) e-Fatura site (`https://ebelge.gib.gov.tr/efaturamevzuat.html`). Covers XML structure, XML Schema (XSD), Schematron rules, code lists, the SBDH envelope, the UBL extension area, the XAdES signature, web service contract, and tooling-relevant constants.

> **Source documents** are referenced in section [11. References](#11-references). All filesystem paths in this document are relative to `phive-rules-turkey/docs/`.

---

## 1. Document model

The Turkish e-invoicing format is **UBL 2.1** with a national customisation called **UBL-TR 1.2.1**. Four document types are exchanged:

| Document | Top-level element | Namespace |
|---|---|---|
| Invoice | `inv:Invoice` | `urn:oasis:names:specification:ubl:schema:xsd:Invoice-2` |
| Application Response | `apr:ApplicationResponse` | `urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2` |
| Despatch Advice | `desp:DespatchAdvice` | `urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2` |
| Receipt Advice | `recp:ReceiptAdvice` | `urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2` |

A Credit Note schema is also shipped (`UBL-CreditNote-2.1.xsd`) and accepted by the platform but not used by the standard Turkish profiles for the four primary processes — a `cac:BillingReference/cac:InvoiceDocumentReference` on a regular `inv:Invoice` is used instead.

The platform exchange unit is not a bare UBL document but a **Standard Business Document (SBD)** envelope — see section [4. SBDH envelope](#4-sbdh-envelope-zarf-şema-yapısı).

> Source: `UBLTR_1.2.1_Paketi/xsdrt/maindoc/`, `UBL-TR Fatura - V 1.0.pdf`, `UBL-TR İrsaliye - V 1.2.pdf`, `UBL-TR İrsaliye Yanıtı - V 1.0.pdf`, `UBL-TR Uygulama Yanıtı - V 0.2.pdf`.

---

## 2. XML namespaces

The full namespace map used across XSD and Schematron (taken verbatim from `UBL-TR_Main_Schematron.xml`):

| Prefix | URI | Purpose |
|---|---|---|
| `sh` | `http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader` | UN/CEFACT SBDH (envelope) |
| `ef` (envelope) | `http://www.efatura.gov.tr/envelope-namespace` | GİB envelope-level extensions |
| `ef` (package) | `http://www.efatura.gov.tr/package-namespace` | GİB `ef:Package` element wrapping the payload(s) |
| `inv` | `urn:oasis:names:specification:ubl:schema:xsd:Invoice-2` | UBL Invoice |
| `apr` | `urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2` | UBL Application Response |
| `desp` | `urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2` | UBL Despatch Advice |
| `recp` | `urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2` | UBL Receipt Advice |
| `cac` | `urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2` | UBL CAC |
| `cbc` | `urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2` | UBL CBC |
| `ext` | `urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2` | UBL Extensions container |
| `ds` | `http://www.w3.org/2000/09/xmldsig#` | XML-DSig |
| `xades` | `http://uri.etsi.org/01903/v1.3.2#` | ETSI XAdES v1.3.2 |
| `hr` | `http://www.hr-xml.org/3` | HR-XML (only used by user-account messages) |
| `oa` | `http://www.openapplications.org/oagis/9` | OAGIS 9 (used by user-account messages) |
| `xsi` | `http://www.w3.org/2001/XMLSchema-instance` | Standard XML Schema instance |

---

## 3. XML Schemas (XSD)

### 3.1 UBL-TR 1.2.1 schema set

Shipped under `UBLTR_1.2.1_Paketi/xsdrt/`. The set is the standard OASIS UBL 2.1 schema with **no schema-level changes** — Turkish customisation is applied through profiles (`cbc:CustomizationID = 'TR1.2'` or `'TR1.2.1'`) and Schematron rules, not via XSD restrictions.

**Main documents (`xsdrt/maindoc/`):**
- `UBL-Invoice-2.1.xsd`
- `UBL-CreditNote-2.1.xsd`
- `UBL-DespatchAdvice-2.1.xsd`
- `UBL-ReceiptAdvice-2.1.xsd`
- `UBL-ApplicationResponse-2.1.xsd`

**Common building blocks (`xsdrt/common/`):**
- `CCTS_CCT_SchemaModule-2.1.xsd` — Core Component Types
- `UBL-CommonAggregateComponents-2.1.xsd` (CAC)
- `UBL-CommonBasicComponents-2.1.xsd` (CBC)
- `UBL-CommonExtensionComponents-2.1.xsd` — **UBLExtensions / UBLExtension / ExtensionContent**
- `UBL-CommonSignatureComponents-2.1.xsd`
- `UBL-CoreComponentParameters-2.1.xsd`
- `UBL-ExtensionContentDataType-2.1.xsd`
- `UBL-QualifiedDataTypes-2.1.xsd`
- `UBL-SignatureAggregateComponents-2.1.xsd`
- `UBL-SignatureBasicComponents-2.1.xsd`
- `UBL-UnqualifiedDataTypes-2.1.xsd`
- `UBL-XAdESv132-2.1.xsd` — ETSI XAdES 1.3.2
- `UBL-XAdESv141-2.1.xsd` — ETSI XAdES 1.4.1
- `UBL-xmldsig-core-schema-2.1.xsd` — XML-DSig

**InvoiceType element sequence** (verbatim from `UBL-Invoice-2.1.xsd`):

`ext:UBLExtensions, cbc:UBLVersionID, cbc:CustomizationID, cbc:ProfileID, cbc:ID, cbc:CopyIndicator, cbc:UUID, cbc:IssueDate, cbc:IssueTime?, cbc:InvoiceTypeCode, cbc:Note*, cbc:DocumentCurrencyCode, cbc:TaxCurrencyCode?, cbc:PricingCurrencyCode?, cbc:PaymentCurrencyCode?, cbc:PaymentAlternativeCurrencyCode?, cbc:AccountingCost?, cbc:LineCountNumeric, cac:InvoicePeriod?, cac:OrderReference?, cac:BillingReference*, cac:DespatchDocumentReference*, cac:ReceiptDocumentReference*, cac:OriginatorDocumentReference*, cac:ContractDocumentReference*, cac:AdditionalDocumentReference*, cac:Signature+, cac:AccountingSupplierParty, cac:AccountingCustomerParty, cac:BuyerCustomerParty?, cac:SellerSupplierParty?, cac:TaxRepresentativeParty?, cac:Delivery*, cac:PaymentMeans*, cac:PaymentTerms?, cac:AllowanceCharge*, cac:TaxExchangeRate?, cac:PricingExchangeRate?, cac:PaymentExchangeRate?, cac:PaymentAlternativeExchangeRate?, cac:TaxTotal+, cac:WithholdingTaxTotal*, cac:LegalMonetaryTotal, cac:InvoiceLine+`

### 3.2 UBL extension area

The standard UBL 2.1 extension hook is reused — no Turkish-specific schema is layered on top:

```
ext:UBLExtensions (1..*)
└── ext:UBLExtension (1..*)
    └── ext:ExtensionContent (1)
        └── XAdES ds:Signature  ← carries the XAdES-BES signature
```

`ExtensionContent` is `xs:any` with `processContents="lax"`, so the embedded `ds:Signature` is XSD-valid against `UBL-xmldsig-core-schema-2.1.xsd` / `UBL-XAdESv132-2.1.xsd`.

> Source: `UBLTR_1.2.1_Paketi/xsdrt/common/UBL-CommonExtensionComponents-2.1.xsd`, `UBL-ExtensionContentDataType-2.1.xsd`.

### 3.3 GİB envelope schemas

Shipped under `e-FaturaPaketi/xsd/Envelope/`. These wrap the UBL document inside a UN/CEFACT SBDH plus a GİB-defined `ef:Package`:

- `StandardBusinessDocumentHeader.xsd` — UN/CEFACT SBDH (UN/CEFACT defines `StandardBusinessDocument`, `StandardBusinessDocumentHeader`, `Sender`, `Receiver`, `DocumentIdentification`, `Manifest`, `BusinessScope`, `Partner`).
- `Partner.xsd`, `DocumentIdentification.xsd`, `Manifest.xsd`, `BusinessScope.xsd`, `BasicTypes.xsd` — SBDH building blocks.
- `Package_1_2.xsd` — GİB-defined `ef:Package` element with `Elements/ElementType + ElementCount + ElementList/<any>` for the actual payload(s).
- `Package.xsd` — older variant (UBL 2.0 era).
- `PackageProxy_1_2.xsd` — proxy schema importing both SBDH and `Package_1_2.xsd`. **Document instances must reference this via `xsi:schemaLocation`.**
- `PackageProxy.xsd` — older variant for UBL 2.0.

Auxiliary HR-XML / OAGIS schemas under `e-FaturaPaketi/xsd/HRXML/` and `e-FaturaPaketi/xsd/Userlist/` are only used for `ProcessUserAccount` / `CancelUserAccount` administrative messages, not invoice exchange.

---

## 4. SBDH envelope (Zarf Şema Yapısı)

The transport unit on the wire is a UN/CEFACT-style **Standard Business Document (Zarf)** that wraps one or more UBL documents:

```
sh:StandardBusinessDocument (xsi:schemaLocation must include "PackageProxy_1_2.xsd")
├── sh:StandardBusinessDocumentHeader
│   ├── sh:HeaderVersion              ('1.0' or '1.2')
│   ├── sh:Sender (1..*)              VKN_TCKN identifier + alias
│   ├── sh:Receiver (1..*)            VKN_TCKN identifier + alias
│   └── sh:DocumentIdentification     Standard='UBL-TR', TypeVersion='1.2', Type=<envelope-type>, InstanceIdentifier=<GUID>, CreationDateAndTime=xs:dateTime
└── ef:Package (http://www.efatura.gov.tr/package-namespace)
    └── Elements (1..10)
        ├── ElementType               INVOICE | APPLICATIONRESPONSE | DESPATCHADVICE | RECEIPTADVICE | CREDITNOTE | PROCESSUSERACCOUNT | CANCELUSERACCOUNT
        ├── ElementCount              ≤ 1000 (≤ 100 if INVOICE; exactly 1 for IHRACAT or YOLCUBERABERFATURA profiles)
        └── ElementList               <any> — contains ElementCount UBL documents of the matching type
```

### Envelope types and their valid payloads

Enforced by Schematron `EnvelopeTypeElementTypeCheck`:

| Envelope `Type` | Allowed `ElementType` |
|---|---|
| `SENDERENVELOPE` | `INVOICE`, `DESPATCHADVICE`, `CREDITNOTE` |
| `POSTBOXENVELOPE` | `APPLICATIONRESPONSE`, `RECEIPTADVICE` |
| `SYSTEMENVELOPE` | `APPLICATIONRESPONSE` |
| `USERENVELOPE` | `PROCESSUSERACCOUNT`, `CANCELUSERACCOUNT` (must target receiver VKN `3900383669` / alias `GIB`; sender alias must appear in `UserEnvelopeAliases`) |

### Sender/Receiver identification

Within `sh:Sender` / `sh:Receiver` there must be **exactly one** `sh:ContactInformation` whose `sh:ContactTypeIdentifier = 'VKN_TCKN'`, with `sh:Contact` being a 10-digit VKN (legal entity tax ID) or 11-digit TCKN (national ID). Additional `ContactInformation` repetitions may carry `UNVAN` (company name), email, phone, fax.

> Source: `Ek-1e-FaturaUygulamasiZarfSemaYapisi-v1.5.pdf`, `e-FaturaPaketi/xsd/Envelope/*.xsd`.

---

## 5. Schematron rules

The Turkish business-rule layer is implemented as **ISO Schematron** under `e-FaturaPaketi/schematron/`:

| File | Purpose | Lines |
|---|---|---|
| `UBL-TR_Main_Schematron.xml` | Active rules — pattern/context wiring; this is the entry-point | ~570 |
| `UBL-TR_Common_Schematron.xml` | ~80 abstract `sch:rule` definitions referenced from the main file via `sch:extends` | ~770 |
| `UBL-TR_Codelist.xml` | Code-list variables (`sch:let`) consumed by the rules | ~70 |
| `Açıklamalar.txt`, `History.txt` | Plain-text release notes |  |

The main file `<sch:include href="UBL-TR_Codelist.xml#codes"/>` and `<sch:include href="UBL-TR_Common_Schematron.xml#abstracts"/>` to assemble the full schema. Assert messages are written in **Turkish**.

### 5.1 Schematron parameter

A single Schematron parameter selects the validation profile:

```xml
<let name="type" value="efatura"/>
```

| Value | Meaning |
|---|---|
| `efatura` (or empty / unset) | Standard e-Fatura central-application validation. |
| `earchive` | e-Arşiv mode — restricts `cbc:ProfileID` to `EARSIVFATURA`. |

e-Arşiv producers must override this parameter at SVRL / XSLT runtime; central e-Fatura producers leave it as default.

> Source: `e-FaturaPaketi/schematron/Açıklamalar.txt`.

### 5.2 Patterns and contexts

Top-level Schematron patterns in `UBL-TR_Main_Schematron.xml`:

- `document` — root `sh:StandardBusinessDocument` checks
- `header` — SBDH header / sender / receiver / document identification
- `package` — `ef:Package` group/count/element-list cardinality
- `invoice` — full UBL Invoice tree (signatures, parties, tax totals, monetary totals, lines, billing reference, profiles)
- `applicationresponse` — Application Response tree
- `processuseraccount`, `canceluseraccount` — user-account admin messages (HR-XML based)
- `despatchadvice`, `receiptadvice` — Despatch/Receipt Advice trees

General root rules also fire on common attributes: `//cbc:IdentificationCode`, `//cbc:CurrencyCode`, `//@currencyID`, `//@unitCode`, `//cbc:ChannelCode`, `//cbc:IssueDate`, `//@mimeCode`.

### 5.3 Notable abstract rules (selected)

The following are illustrative — the full set of ~80 abstract rules is in `UBL-TR_Common_Schematron.xml`:

| Abstract rule ID | Asserted constraint |
|---|---|
| `DocumentCheck` | SBD must contain `sh:StandardBusinessDocumentHeader` and `ef:Package`; `xsi:schemaLocation` must contain `PackageProxy_1_2.xsd`. |
| `HeaderCheck` | `sh:HeaderVersion` ∈ {`1.0`, `1.2`}; exactly one Sender / Receiver. |
| `TypeVersionCheck` | `sh:TypeVersion = '1.2'`. |
| `EnvelopeTypeCheck` | `sh:Type` ∈ `EnvelopeType` codelist. |
| `EnvelopeTypeElementTypeCheck` | Envelope-type vs payload-type compatibility table (see [4. SBDH envelope](#4-sbdh-envelope-zarf-şema-yapısı)). |
| `UUIDCheck` | `InstanceIdentifier` (envelope) and `cbc:UUID` (UBL) must be a valid GUID. |
| `ContactCheck` | `VKN_TCKN` contact value length must be 10 or 11. |
| `UBLVersionIDCheck` | `cbc:UBLVersionID = '2.1'`. |
| `CustomizationIDCheck` | `cbc:CustomizationID` ∈ {`TR1.2`, `TR1.2.1`}. |
| `ProfileIDCheck` | `cbc:ProfileID` must be in `ProfileIDType` (or `ProfileIDTypeEarchive` when `$type = 'earchive'`). |
| `InvoiceIDCheck` | Regex `^[A-Z0-9]{3}20[0-9]{2}[0-9]{9}$` — 3-char alphanumeric prefix + `20YY` + 9-digit sequence (e.g. `GIB2009000000001`). |
| `CopyIndicatorCheck` | Must be `false` (original) or `true` (copy). |
| `TimeCheck` | Date/time syntax. |
| `InvoiceTypeCodeCheck` | `cbc:InvoiceTypeCode` ∈ `InvoiceTypeCodeList`. |
| `CurrencyCodeCheck`, `GeneralCurrencyCodeCheck`, `GeneralCurrencyIDCheck` | All currency codes/IDs ∈ `CurrencyCodeList` (ISO 4217). |
| `CountryCodeCheck` | `cbc:IdentificationCode` ∈ `CountryCodeList` (ISO 3166-1 alpha-2). |
| `GeneralUnitCodeCheck` | `@unitCode` ∈ `UnitCodeList` (UN/ECE Recommendation 20 — full list embedded). |
| `MimeCodeCheck` | `@mimeCode` ∈ `MimeCodeList`. |
| `GeneralChannelCodeCheck` | `cbc:ChannelCode` ∈ `ChannelCodeList`. |
| `decimalCheck` | Numeric-precision constraint on monetary amounts. |
| `SignatureCountCheck` | Number of UBL signatures consistent with profile. |
| `XadesSignatureCheck`, `XadesSignatureCheckForInvoice` | Required XAdES sub-elements present (see [6. XAdES](#6-xades-electronic-signature)). |
| `PartyIdentificationSchemeIDCheck`, `PartyIdentificationTCKNVKNCheck` | `schemeID` ∈ `PartyIdentificationIDType`; tax-ID length validation. |
| `DocumentSenderCheck`, `DocumentReceiverCheck` | Inner-document parties must match the SBDH sender/receiver. |
| `TaxFreeInvoiceCheck`, `IhracatYolcuBeraberCheck` | Special-profile cross-checks. |
| `TaxRepresentativePartyCheck` | If present, structural completeness of `cac:TaxRepresentativeParty`. |
| `GeneralWithholdingTaxTotalCheck`, `WithholdingTaxTotalCheck`, `TaxExemptionReasonCodeCheck` | Withholding-tax category and exemption-reason validations. |
| `BillingReferenceCheck`, `GeneralBillingReferenceCheck` | Reference-document checks (incl. ÖKC information slip via `AdditionalDocumentReference` — see Fatura guide §2.3.21). |
| `PaymentMeansCodeCheck` | `cac:PaymentMeans/cbc:PaymentMeansCode` ∈ `PaymentMeansCodeTypeList`. |
| `InvoicedQuantityCheck`, `PriceAmountCheck` | Line-level quantity/price validation. |
| `DeliveryCodeCheck`, `LineDeliveryCheck` | Delivery-term codes ∈ `DeliveryTermCodeList` (Incoterms). |
| `PartyVDCheck` | "VD" (Vergi Dairesi — tax office) on parties. |
| `OfficelTitleCheck` | Office title formatting. |
| `PackageCheck` | `cac:Package` (line-level packaging) consistency. |
| `HKSInvioceCheck`, `IADEInvioceCheck`, `IhracKayitliPartyIdentificationIDTypeCheck`, `IlacTibbiCihazInvoiceTypeCodeCheck`, `IlacTibbiCihazAdditionalItemIdentificationCheck`, `YatirimTesvik*Check`, `IdisInvoiceTypeCodeCheck`, `IdisSevkiyatNoCheck`, `TeknolojiDestekAdditionalItemIdentificationCheck` | Profile-specific rules (HKS livestock, returns, registered exports, pharmaceutical/medical-device, investment incentive, EFT-POS technology support, IDIS shipment number). |
| `TaxFreeNationalityIDCheck`, `PassportIDCheck` | Tax-free passenger profile. |
| `ExportInvoiceCountCheck` | An `ef:Package` Elements group may carry only **one** `IHRACAT` invoice or one `YOLCUBERABERFATURA` invoice. |
| `ElementsGroupCountCheck`, `ElementCountCheck`, `ElementListCountCheck`, `ElementNameCheck`, `InvoiceCountCheck` | Envelope cardinality limits (≤ 10 `Elements`, ≤ 1000 per group, ≤ 100 invoices, payload type matches `ElementType`). |

### 5.4 Code lists (`sch:let` variables in `UBL-TR_Codelist.xml`)

Comma-padded enumerations. Full list of variable names:

`ProfileIDType, ProfileIDTypeEarchive, ProfileIDTypeDespatchAdvice, ProfileIDTypeGoruntuleme, InvoiceTypeCodeList, DespatchAdviceTypeCodeList, ReceiptAdviceTypeCodeList, EnvelopeType, ElementType, TaxType, WithholdingTaxType, WithholdingTaxTypeWithPercent, AccountingCostCodeList, TaxExemptionReasonCodeType, istisnaTaxExemptionReasonCodeType, ozelMatrahTaxExemptionReasonCodeType, ihracExemptionReasonCodeType, DeliveryTermCodeList, TransportModeCodeList, PartyIdentificationIDType, LicensePlateIDSchemeIDType, DocumentDescriptionType, ResponseCodeType, AppResponseCodeType, ContactTypeIdentifierType, PackageTypeCodeList, CurrencyCodeList, CountryCodeList, UserType, ReservedAliases, UserEnvelopeAliases, UnitCodeList, PaymentMeansCodeTypeList, ChannelCodeList, MimeCodeList, AdditionalItemIdentificationIDType, IhracKayitliPartyIdentificationIDType, YatirimTesvikEArsivInvoiceTypeCodeList, YatirimTesvikItemClassificationCodeList`.

Key lists (verbatim values):

| List | Values |
|---|---|
| `ProfileIDType` | `TICARIFATURA`, `TEMELFATURA`, `YOLCUBERABERFATURA`, `IHRACAT`, `OZELFATURA`, `KAMU`, `HKS`, `ENERJI`, `ILAC_TIBBICIHAZ`, `YATIRIMTESVIK`, `IDIS` |
| `ProfileIDTypeEarchive` | `EARSIVFATURA` |
| `ProfileIDTypeDespatchAdvice` | `TEMELIRSALIYE`, `HKSIRSALIYE`, `IDISIRSALIYE` |
| `InvoiceTypeCodeList` | `SATIS`, `IADE`, `TEVKIFAT`, `TEVKIFATIADE`, `ISTISNA`, `OZELMATRAH`, `IHRACKAYITLI`, `SGK`, `KOMISYONCU`, `HKSSATIS`, `HKSKOMISYONCU`, `KONAKLAMAVERGISI`, `SARJ`, `SARJANLIK`, `TEKNOLOJIDESTEK`, `YTBSATIS`, `YTBIADE`, `YTBISTISNA`, `YTBTEVKIFAT`, `YTBTEVKIFATIADE` |
| `DespatchAdviceTypeCodeList` | `SEVK`, `MATBUDAN` |
| `ReceiptAdviceTypeCodeList` | `SEVK` |
| `EnvelopeType` | `SENDERENVELOPE`, `POSTBOXENVELOPE`, `SYSTEMENVELOPE`, `USERENVELOPE` |
| `ElementType` | `INVOICE`, `APPLICATIONRESPONSE`, `PROCESSUSERACCOUNT`, `CANCELUSERACCOUNT`, `DESPATCHADVICE`, `RECEIPTADVICE`, `CREDITNOTE` |
| `TaxType` (32 codes) | `0003, 0015 (KDV/VAT), 0061, 0071, 0073, 0074, 0075, 0076, 0077, 1047, 1048, 4080 (Special Communications Tax), 4081, 9015, 9021, 9077, 8001…8008, 9040, 0011, 4071, 4171, 0021, 0022, 9944, 0059` |
| `WithholdingTaxType` (52 codes) | `601`–`627`, `801`–`825` |
| `AccountingCostCodeList` | `SAGLIK_ECZ, SAGLIK_HAS, SAGLIK_OPT, SAGLIK_MED, ABONELIK, MAL_HIZMET, DIGER` |
| `DeliveryTermCodeList` | Incoterms — `CFR, CIF, CIP, CPT, DAF, DDP, DDU, DEQ, DES, EXW, FAS, FCA, FOB, DAP, DPU` |
| `TaxExemptionReasonCodeType` | ~140 reason codes covering KDV exemption, ihrac (export), istisna and ihtisas regimes |
| `UnitCodeList` | UN/ECE Rec. 20 (full list, e.g. `KGM, MTR, LTR, EA, BX, NAR, …`) |

A more human-readable view of all lists is published in `UBLTR_1.2.1_Kilavuzlar/.../KOD LİSTELERİ/UBL-TR Kod Listeleri - V 1.42.pdf`.

> Source: `e-FaturaPaketi/schematron/UBL-TR_*.xml`.

---

## 6. XAdES electronic signature

### 6.1 Format

- **Profile:** XAdES-BES, **enveloped** technique only. *Enveloping* and *Detached* are explicitly rejected.
- **Container:** Embedded inside `inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature` (and the analogous path on `apr:ApplicationResponse`).
- **Recommended digest algorithm:** SHA-256.
- The fiscal seal certificate (Mali Mühür) is issued by TÜBİTAK BİLGEM Kamu Sertifikasyon Merkezi for legal entities; natural persons use a qualified electronic signature.

### 6.2 Required XML structure

```xml
<ds:Signature Id="Signature">
  <ds:SignedInfo Id="SignedInfo">
    <ds:CanonicalizationMethod/>
    <ds:SignatureMethod/>
    <ds:Reference URI="">
      <ds:Transforms><ds:Transform/></ds:Transforms>
      <ds:DigestMethod/>
      <ds:DigestValue/>
    </ds:Reference>
    <ds:Reference URI="#SignedProperties">
      <ds:DigestMethod/>
      <ds:DigestValue/>
    </ds:Reference>
  </ds:SignedInfo>
  <ds:SignatureValue/>
  <ds:KeyInfo>
    <ds:KeyValue/>
    <ds:X509Data>
      <ds:X509SubjectName/>
      <ds:X509Certificate/>
    </ds:X509Data>
  </ds:KeyInfo>
  <ds:Object>
    <xades:QualifyingProperties Target="Signature">
      <xades:SignedProperties Id="SignedProperties">
        <xades:SignedSignatureProperties>
          <xades:SigningTime/>
          <xades:SigningCertificate>
            <xades:Cert>
              <xades:CertDigest>
                <ds:DigestMethod/>
                <ds:DigestValue/>
              </xades:CertDigest>
              <xades:IssuerSerial>
                <ds:X509IssuerName/>
                <ds:X509SerialNumber/>
              </xades:IssuerSerial>
            </xades:Cert>
          </xades:SigningCertificate>
          <xades:SignerRole>
            <xades:ClaimedRoles><xades:ClaimedRole/></xades:ClaimedRoles>
          </xades:SignerRole>
        </xades:SignedSignatureProperties>
      </xades:SignedProperties>
    </xades:QualifyingProperties>
  </ds:Object>
</ds:Signature>
```

### 6.3 Mandatory child elements (Schematron `XadesSignatureCheck`)

- `ds:SignedInfo/ds:Reference/ds:Transforms`
- `ds:KeyInfo` and `ds:KeyInfo/ds:X509Data`
- `ds:Object` with `xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime`
- `ds:Object` with `xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate`

> Source: `Ek-3e-FaturaUygulamasiYazilimStandartlariVeNesneYapisi-v1.4.pdf` §3, `Imzalama_Araci_Kullanim_Kilavuzu-v1.2.pdf`, `e-FaturaPaketi/schematron/UBL-TR_Common_Schematron.xml#XadesSignatureCheck`.

---

## 7. Web service / transport contract (relevant for end-to-end testing only)

A PHIVE-style validator only consumes the XML; the service contract is included here for completeness because validation results have to be returned in the same envelope shape:

| Aspect | Value |
|---|---|
| Protocol | SOAP 1.1 over HTTPS (TLS) — DOC encoding (RPC rejected) |
| Optimisation | MTOM/XOP for binary payload (the zipped envelope) |
| Profile compliance | WS-I and WS-I Basic Profile |
| Compression | **Standard ZIP** only (gzip / rar **not allowed**) |
| Envelope hash | **MD5**, lowercase, 32 hex chars |
| Container hash recommendation | SHA-256 (digest in `ds:DigestMethod`/`ds:DigestValue`) |
| WSDL | `e-FaturaPaketi/wsdl/EFatura_Test.wsdl`, `EFatura_Canlı.wsdl` |
| Methods | `sendDocument(DocumentRequest) → DocumentResponse`, `getApplicationResponse(GetAppRespRequest) → GetAppRespResponse`; both throw `EFaturaFaultMessage` |
| File-name convention | The ZIP file name **must equal the SBDH `InstanceIdentifier`** (the GUID), with extension `.zip` |
| Fault codes (`EFaturaFault`) | `2000` OZET DEGERLER ESIT DEGIL, `2001` ZARF ID SISTEMDE MEVCUT, `2002` ZARF ARSIVE EKLENEMEDI, `2003` ZARF KUYRUGA EKLENEMEDI, `2004` ZARF ID BULUNAMADI, `2005` SISTEM HATASI, `2006` GECERSIZ ZARF ADI, `2007` PAKET GÖNDERMEYE VE SORGULAMAYA YETKİNİZ GEÇİCİ OLARAK KALDIRILMIŞTIR |
| SOAP fault namespace | `http://gib.gov.tr/vedop3/eFatura` |

> Source: `Ek-3e-FaturaUygulamasiYazilimStandartlariVeNesneYapisi-v1.4.pdf`, `e-FaturaUygulamasiEntegrasyonKilavuzu-v1.10.pdf`, `e-Fatura_Uygulamasi_Ozel_Entegrasyon_Kilavuzu_v1.13.pdf`.

---

## 8. Profile-specific extensions

Although there is no separate XSD per profile, several Turkish profiles add Schematron-only constraints. They are mentioned here because validator users typically need to know which `cbc:ProfileID` activates which rule set:

| Profile (`cbc:ProfileID`) | Activated rule families |
|---|---|
| `TEMELFATURA`, `TICARIFATURA` | Baseline rules |
| `IHRACAT` | `IhracatYolcuBeraberCheck`, `ExportInvoiceCountCheck`, `IhracKayitliPartyIdentificationIDTypeCheck`, `ihracExemptionReasonCodeType` (`701`–`704`) |
| `YOLCUBERABERFATURA` | `TaxFreeInvoiceCheck`, `TaxFreeNationalityIDCheck`, `PassportIDCheck`, `ExportInvoiceCountCheck` |
| `OZELFATURA`, `OZELMATRAH` | `ozelMatrahTaxExemptionReasonCodeType` (`801`–`812`) |
| `ISTISNA` | `istisnaTaxExemptionReasonCodeType` (~120 codes) |
| `KAMU` | Public-sector specific; technical guide `Kamu_e-Fatura_Teknik_Kilavuzu_v1.5.pdf` |
| `HKS`, `HKSSATIS`, `HKSKOMISYONCU`, `HKSIRSALIYE` | `HKSInvioceCheck` (livestock) |
| `ENERJI`, `SARJ`, `SARJANLIK` | Electricity-charging — guide `Elektrik_Sarj_Hizmetlerine_Iliskin_Fatura_Teknik_Kilavuzu_V.1.0.pdf` |
| `ILAC_TIBBICIHAZ` | `IlacTibbiCihazInvoiceTypeCodeCheck`, `IlacTibbiCihazAdditionalItemIdentificationCheck` — guide `Ilac_ve_Tibbi_Cihaz_Teslimlerine_Iliskin_Fatura_Teknik_Kilavuzu_V.1.2.pdf` |
| `YATIRIMTESVIK`, `YTBSATIS`/`YTBIADE`/`YTBISTISNA`/`YTBTEVKIFAT`/`YTBTEVKIFATIADE` | `YatirimTesvik*Check` family — guide `Yatirim_Tesvik_Kapsaminda_Yapilan_Teslimlere_Iliskin_Fatura_Teknik_Kilavuzu_V1.1.pdf` |
| `IDIS`, `IDISIRSALIYE` | `IdisInvoiceTypeCodeCheck`, `IdisSevkiyatNoCheck` — guide `IDIS_Kapsaminda_Yapilan_Teslimlere_Iliskin_Fatura_ve_Irsaliye_Teknik_Kilavuzu_V.1.0.pdf` |
| `EARSIVFATURA` | Activated by Schematron `$type='earchive'` (different ProfileID list) |
| `TEKNOLOJIDESTEK` | `TeknolojiDestekAdditionalItemIdentificationCheck` |
| `KONAKLAMAVERGISI` | Accommodation tax invoice |
| `SGK` | Social-security invoices — guides `SGK_e-Fatura_Teknik_Dokuman.pdf`, `SGK_e-FATURA_UYGULAMA_KILAVUZU.pdf` |

`InvoiceTypeCodeList` controls the line-level invoice type and is independent of `ProfileID` — but the two are correlated by Schematron rules per profile (e.g. `YATIRIMTESVIK` profile only allows `YTB*` invoice type codes).

---

## 9. Customisation / Profile identifiers

Reference values that an external validator (such as PHIVE) needs to register on the entry point:

| Field | Value |
|---|---|
| `cbc:UBLVersionID` | `2.1` |
| `cbc:CustomizationID` | `TR1.2` (legacy) or `TR1.2.1` (current) |
| `cbc:ProfileID` | One of the values listed in §8 |
| `sh:Standard` | `UBL-TR` |
| `sh:HeaderVersion` | `1.2` (also accepted: `1.0`) |
| `sh:TypeVersion` | `1.2` |
| `xsi:schemaLocation` (root) | Must include `PackageProxy_1_2.xsd` |

Suggested PHIVE VES coordinate naming (informational):

```
groupId   = tr.efatura
artifactId= invoice | application-response | despatch-advice | receipt-advice | credit-note
version   = 1.2.1
```

The optional Schematron parameter `type` (efatura | earchive) should be exposed as a VES configuration knob.

---

## 10. Sample XML files shipped with the packages

Useful as positive/negative test fixtures:

**UBL-TR 1.2.1 package — `UBLTR_1.2.1_Paketi/xml/`:**
`TemelFaturaOrnegi.xml` (basic invoice), `TicariFaturaOrnegi.xml` (commercial), `IadeFaturasiOrnegi.xml` (return), `KabulUygulamaYanitiOrnegi.xml` (acceptance app-response), `RedUygulamaYanitiOrnegi.xml` (rejection), `IadeUygulamaYanitiOrnegi.xml` (return app-response), `IHRACAT.xml`, `IHRACAT_GTB_UygulamaYaniti_KABUL.xml`, `IHRACAT_GTB_UygulamaYaniti_RED.xml`, `YOLCUBERABER.xml`, `YOLCUBERABER_UygulamaYaniti.xml`, `ISTISNA-1.xml`, `ISTISNA-2.xml`, `OTV.xml` (excise tax), `OZELMATRAH.xml`, `TEVKIFAT.xml`, `HASTANE.xml` (hospital), `HKS-Ornek1.xml` / `HKS-Ornek2.xml`, `Irsaliye-Ornek1.xml`–`Irsaliye-Ornek3.xml`, `Irsaliye-Matbudan.xml`, `IrsaliyeYaniti-Ornek1.xml`–`IrsaliyeYaniti-Ornek4.xml`, `SARJ.xml`, `SARJANLIK.xml`. Plus the visualisation XSLTs `appResponse.xslt`, `irsaliye.xslt`, `irsaliyeyaniti.xslt` and the CSS `ubl.css`.

**e-Fatura package — `e-FaturaPaketi/xml/`:**
Envelope-wrapped variants (suffix `_ZARF`) and several SBDH+Package examples: `1_TEMEL_FATURA_ZARF.xml`, `2_TICARI_FATURA_ZARF.xml`, `7_TEMEL_FATURA_IADE_ZARF.xml`, `6_TEMEL_FATURA_KDV_SIFIR_ZARF.xml`, `7_TICARI_FATURA_ZARF.xml`, `2_UYGULAMA_YANITI_KABUL_ZARF.xml`, `3_UYGULAMA_YANITI_RED_ZARF.xml`, `7_UYGULAMA_YANITI_IADE_ZARF.xml`, `1_SISTEM_YANITI_MERKEZ.xml`, `1_SISTEM_YANITI_POSTA_KUTUSU.xml`, `1_SISTEM_YANITI_GTB_POSTA_KUTUSU.xml`, `4_KULLANICI_ACMA_ZARF.xml`, `5_KULLANICI_SILME_ZARF.xml`, `8_FATURA_SAKLAMA_KULLANICI_ACMA_ZARF.xml`, `9_FATURA_SAKLAMA_KULLANICI_SILME_ZARF.xml`, `TEKNOLOJI_DESTEK.xml`.

---

## 11. References

All source artefacts live under `phive-rules-turkey/docs/`. The mapping below shows which document each section of this summary draws from.

### Core technical packages

| Folder / file | Provides | Used in §§ |
|---|---|---|
| `UBLTR_1.2.1_Paketi/xsdrt/` | UBL-TR 1.2.1 XSD set (main + common + XAdES + XML-DSig) | 1, 3, 6 |
| `UBLTR_1.2.1_Paketi/xml/` | Sample documents, visualisation XSLT | 10 |
| `e-FaturaPaketi/xsd/Envelope/` | SBDH + ef:Package envelope XSDs | 3.3, 4 |
| `e-FaturaPaketi/xsd/HRXML/`, `e-FaturaPaketi/xsd/Userlist/` | User-account admin schemas (HR-XML, OAGIS) | 3.3 |
| `e-FaturaPaketi/schematron/UBL-TR_Main_Schematron.xml` | Active rule contexts | 5 |
| `e-FaturaPaketi/schematron/UBL-TR_Common_Schematron.xml` | ~80 abstract rules | 5.3, 6.3 |
| `e-FaturaPaketi/schematron/UBL-TR_Codelist.xml` | Code-list `sch:let` variables | 5.4 |
| `e-FaturaPaketi/schematron/Açıklamalar.txt` | Schematron `type` parameter explanation | 5.1 |
| `e-FaturaPaketi/schematron/History.txt` | Schematron release notes |  |
| `e-FaturaPaketi/wsdl/EFatura_Test.wsdl`, `EFatura_Canlı.wsdl` | Web-service contract | 7 |
| `e-FaturaPaketi/xml/*_ZARF.xml` | Envelope sample documents | 4, 10 |

### Guides (PDFs)

| Document | Coverage of this summary |
|---|---|
| `UBL-TR-Fatura-V1.0-tr.md` / `-en.md` (extracted earlier) | Full Invoice element catalogue (cardinality, usage) |
| `UBLTR_1.2.1_Kilavuzlar/.../UBL-TR Fatura - V 1.0.pdf` | Source PDF for the above |
| `UBLTR_1.2.1_Kilavuzlar/.../UBL-TR İrsaliye - V 1.2.pdf` | Despatch Advice element catalogue |
| `UBLTR_1.2.1_Kilavuzlar/.../UBL-TR İrsaliye Yanıtı - V 1.0.pdf` | Receipt Advice element catalogue |
| `UBLTR_1.2.1_Kilavuzlar/.../UBL-TR Uygulama Yanıtı - V 0.2.pdf` | Application Response element catalogue |
| `UBLTR_1.2.1_Kilavuzlar/.../GENEL AÇIKLAMALAR/UBL-TR Genel Açıklamalar - V 0.4.pdf` | UBL-TR overview |
| `UBLTR_1.2.1_Kilavuzlar/.../ORTAK ELEMANLAR/UBL-TR Ortak Elemanlar - V 0.7.pdf` | UBL CAC/CBC reusable types in Turkish context |
| `UBLTR_1.2.1_Kilavuzlar/.../KOD LİSTELERİ/UBL-TR Kod Listeleri - V 1.42.pdf` | All code lists (human-readable) — §5.4 |
| `UBLTR_1.2.1_Kilavuzlar/.../SENARYOLAR/UBL-TR Temel Fatura Senaryosu - V 0.2.pdf` | Basic invoice scenario flow |
| `UBLTR_1.2.1_Kilavuzlar/.../SENARYOLAR/UBL-TR Ticari Fatura Senaryosu - V 0.3.pdf` | Commercial invoice scenario (with app-response) |
| `UBLTR_1.2.1_Kilavuzlar/.../SENARYOLAR/UBL-TR Temel İrsaliye Senaryosu - V 0.3.pdf` | Despatch-advice scenario |
| `Ek-1e-FaturaUygulamasiZarfSemaYapisi-v1.5.pdf` | SBDH envelope structure — §4 |
| `Ek-2e-FaturaUygulamasiSistemYanitiSemaYapisi-v1.5.pdf` | System-response envelope (SYSTEMENVELOPE payload) |
| `Ek-3e-FaturaUygulamasiYazilimStandartlariVeNesneYapisi-v1.4.pdf` | Software standards: MTOM, XAdES, ZIP, MD5, SSL, web-service object model — §6, §7 |
| `e-FaturaUygulamasiEntegrasyonKilavuzu-v1.10.pdf` | Full integration guide — §7 |
| `e-Fatura_Uygulamasi_Ozel_Entegrasyon_Kilavuzu_v1.13.pdf` | Special-integrator (private integrator) guide — §7 |
| `Imzalama_Araci_Kullanim_Kilavuzu-v1.2.pdf` | Signing-tool user guide — §6 |
| `e-FaturaPortaliKullanimKilavuzu-v1.5.pdf` | Web portal manual (non-technical) |
| `E-FaturaGoruntuleyiciKullanimKilavuzuV-1.0.pdf` | Document-viewer manual |
| `e-FaturaTestPlani.pdf` | Test plan (test scenarios) |
| `e-FaturaUygulamasiSaklamaKilavuzu.pdf` | Long-term archival rules |
| `E-FaturaUygulamasiBasvuruRehberiveKilavuzu_V1.2.pdf` | Application/onboarding |
| `e-Fatura_Iptal_Ihtar_Itiraz_Bildirim_Kilavuzu_V_1.2.pdf` | Cancellation / objection notification flow |
| `Kamu_e-Fatura_Teknik_Kilavuzu_v1.5.pdf` | Public-sector profile (KAMU) |
| `e-BELGE_OZEL_ENTEGRATORLERI_BILGI_SISTEMLERI_DENETIMI_KILAVUZU.pdf` | Audit guide for private integrators |
| `Karekod_Standardi_Kilavuzu_V.1.2.pdf` | QR-code (Karekod) standard for human-readable rendition |
| `Elektrik_Sarj_Hizmetlerine_Iliskin_Fatura_Teknik_Kilavuzu_V.1.0.pdf` | Electricity-charging profile (`SARJ`/`SARJANLIK`) |
| `Ilac_ve_Tibbi_Cihaz_Teslimlerine_Iliskin_Fatura_Teknik_Kilavuzu_V.1.2.pdf` | Pharmaceutical / medical-device profile |
| `IDIS_Kapsaminda_Yapilan_Teslimlere_Iliskin_Fatura_ve_Irsaliye_Teknik_Kilavuzu_V.1.0.pdf` | İDİS profile |
| `Yatirim_Tesvik_Kapsaminda_Yapilan_Teslimlere_Iliskin_Fatura_Teknik_Kilavuzu_V1.1.pdf` | Investment-incentive profile |
| `Gumruk_Islemleri_Kilavuzu_Versiyon_1.8.zip` → `Gumruk_Islemleri_Kilavuzu_Versiyon_1_8.pdf`, `IHRACAT_EkAlanlar.pdf` | Customs (export) procedures |
| `SGK_e-Fatura_Teknik_Dokuman.pdf`, `SGK_e-FATURA_UYGULAMA_KILAVUZU.pdf` | Social Security profile |

### External references cited inside the documents

| Reference | URL / identifier |
|---|---|
| OASIS UBL 2.1 OS | `http://docs.oasis-open.org/ubl/os-UBL-2.1/` |
| GS1 SBDH | `http://www.gs1.org/gsmp/kc/ecom/xml/xml_sbdh` |
| ETSI XAdES 1.3.2 | `http://uri.etsi.org/01903/v1.3.2#` |
| W3C XML-DSig | `http://www.w3.org/2000/09/xmldsig#` |
| GİB e-Fatura legislation portal (download source for everything in this folder) | `https://ebelge.gib.gov.tr/efaturamevzuat.html` |

---

## 12. Implementation checklist for a PHIVE rule module

Mapping the above to PHIVE wiring (concrete suggestions, not part of the GİB specification):

1. **XSD validation layer** — register `UBL-Invoice-2.1.xsd`, `UBL-ApplicationResponse-2.1.xsd`, `UBL-DespatchAdvice-2.1.xsd`, `UBL-ReceiptAdvice-2.1.xsd` (and optionally `UBL-CreditNote-2.1.xsd`) from `UBLTR_1.2.1_Paketi/xsdrt/maindoc/`. Imports from `xsdrt/common/` resolve relatively.
2. **Schematron validation layer** — compile `e-FaturaPaketi/schematron/UBL-TR_Main_Schematron.xml` with `ph-schematron-maven-plugin` to XSLT and ship the result under `phive-rules-turkey/src/main/resources/external/schematron/efatura/<release>/`. The Common Schematron and Codelist files must sit alongside (the Main file `<sch:include>`s them).
3. **Optional second Schematron run** — same Main Schematron with the parameter `type=earchive` (separate VES coordinate, e.g. `tr.efatura:invoice:1.2.1+earchive`).
4. **Envelope validation (optional)** — register the SBDH+Package XSDs from `e-FaturaPaketi/xsd/Envelope/` for callers that hand in the Zarf (envelope) rather than the bare UBL.
5. **VES coordinates** — see §9.
6. **Test fixtures** — copy from `UBLTR_1.2.1_Paketi/xml/` (positive cases) and `e-FaturaPaketi/xml/` (envelope cases) into `src/test/resources/external/test-files/<profile>/<version>/`.
7. **Display names** — keep "e-Fatura" and "UBL-TR 1.2.1" in the VES display name so users can find them from PHIVE viewers.
