# Serbia SEO – Technical Rules for Despatch Advice, Receipt Advice and Application Response

This document is an **English-language extraction** of the technical rules for the
Serbian **SEO** system (*Sistem Elektronskih Otpremnica* – System of Electronic
Despatch Notes), operated by the Ministry of Finance (MFIN) Central Register.

Source: *Техничко упутство – API документација* (Technical Instruction – API
documentation), version 1.5.0, in force from 18 February 2025, section 1
("Specification for electronic despatch note and receipt note in domestic trade
in the Republic of Serbia"), pages 4–37. Portal: <https://eotpremnica.efaktura.gov.rs/>.

It is intended as the implementation reference for writing **Schematron business
rules** for the three SEO document types. The original specification is in Serbian
(Cyrillic); the business terms below were translated to English. Where the
specification text contained an obvious UBL element-name typo, the **real UBL 2.1
element name** is used here and the discrepancy is recorded in
[§9 Spec discrepancies](#9-spec-discrepancies-corrected-element-names).

GitHub issue: <https://github.com/phax/phive-rules/issues/68>

> **Status:** No official `.sch`/`.xslt` Schematron files are published by MFIN.
> These rules are derived from the prose specification and the published UBL 2.1
> example documents. The current `phive-rules-serbia` SEO VES coordinates perform
> **UBL 2.1 XSD validation only** – the rules below are the basis for adding
> Serbia-specific business validation.

---

## 1. Documents and identifiers

Three UBL 2.1 document types are exchanged. All data exchange is via UBL XML in
**UTF-8** encoding (other encodings may break parsing, hashing and signing).

| SEO document (Serbian) | UBL 2.1 root document | `cbc:CustomizationID` | `cbc:ProfileID` |
|---|---|---|---|
| eOtpremnica (despatch note) | `DespatchAdvice` | `urn:fdc:mfin.gov.rs:logistics:trns:despatch_advice:1:2025.12` | `urn:fdc:peppol.eu:logistics:bis:despatch_advice_only:1` |
| ePrijemnica (receipt note) | `ReceiptAdvice` | `urn:fdc:mfin.gov.rs:logistics:trns:receipt_advice:1:2025.12` | `urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1` |
| Izmena podataka pošiljke / user actions (despatch data changes) | `ApplicationResponse` | `urn:fdc:mfin.gov.rs:logistics:trns:application_response:1:2025.12` | *(see note)* |

Every document **must** carry the `cbc:CustomizationID` value above (placed at the
top of the document, immediately after the extensions). The `ProfileID` values
above come from the published examples; the specification does not list a separate
ProfileID for the Application Response.

### Document relationships and "user actions"

- A **Despatch Advice** is the primary document from sender to recipient.
- A **Receipt Advice** is the recipient's reply; it references exactly one
  despatch advice (`cac:DespatchDocumentReference`).
- An **Application Response** carries subsequent *changes/actions* on a shipment.
  Unlike the despatch/receipt documents, user-action documents follow the same
  processing/validation steps but are **not signed**, so the chronological event
  sequence for each shipment can be reconstructed in case of disagreement.
  The action type is in `cbc:ResponseCode` (see [§7 Code lists](#7-code-lists)).

Possible actions: physical receipt, cancellation (storno), vehicle change, start
of transport, transload (pretovar), seizure, and the reply to a receipt advice
(accept / reject).

---

## 2. Namespaces

| Prefix | Namespace |
|---|---|
| *(default)* | `urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2` / `…:ReceiptAdvice-2` / `…:ApplicationResponse-2` |
| `cac` | `urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2` |
| `cbc` | `urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2` |
| `cec` | `urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2` |
| `sbt` | `http://mfin.gov.rs/srbdt/srbdtext` |

All Serbia-specific data not representable in standard UBL is carried under the
`cec:UBLExtensions/cec:UBLExtension/cec:ExtensionContent/sbt:SrbDtExt` extension
container (the `sbt:SrbDtExt` element). See [§8 Extension element order](#8-extension-element-order)
for the mandatory child ordering, which is XSD-enforced.

---

## 3. Notation

Each row defines one element/field of the semantic model.

- **Ident.** – term/group identifier from the semantic model (`FI-Gxx` = field,
  `FG-x` = group).
- **K** (cardinality) – minimum..maximum occurrences. Where the Serbian profile is
  **more restrictive** than the base model, this is noted as
  *(restricted from `<base>`)*; the effective Serbian cardinality is the one shown.
- **T** (semantic data type):
  | Code | Type |
  |---|---|
  | `C` | Code |
  | `D` | Date |
  | `I` | Identifier |
  | `Q` | Quantity |
  | `T` | Text |
  | `B` | Binary Object |
  | `O` | Document Reference Identifier |
  | `S` | Attribute |
  | `At` | Attachment |
- **UBL path** – mapping into the UBL document.
- **Usage note** – additional usage constraint defined by this specification.

---

## 4. Despatch Advice (eOtpremnica → UBL `DespatchAdvice`)

### Header

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G01 | Despatch advice number | 1..1 | I | `/DespatchAdvice/cbc:ID` | Must be unique within a single PIB (tax ID); for public-funds users it must be unique within the JBKJS. Max 500 chars. |
| FI‑G02 | Despatch advice type code | 1..1 *(restricted from 0..1)* | C | `/DespatchAdvice/cbc:DespatchAdviceTypeCode` | Codes: `Int` = internal despatch, `Ext` = external despatch. Max 25 chars. |
| FI‑G04 | ZIN number | 0..1 | I | `…/sbt:SrbDtExt/sbt:OfflineZinNumber/cbc:ID` | ZIN hologram-label number. Max 25 chars. Only an assigned ZIN may be entered. Format = 11 chars: first two letters, then 9 digits (e.g. `AA012345678`). |
| FI‑G05 | Despatch advice issue date | 1..1 | D | `/DespatchAdvice/cbc:IssueDate` | ISO date `yyyy-MM-dd`, e.g. `2024-12-25`. |
| FI‑G06 | Planned delivery start date and time | 0..1 | D | `/DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:EstimatedDespatchDate` (date) + `…/cbc:EstimatedDespatchTime` (time) | Mandatory **only for tobacco/excise products**. Planned start must **not be after** the planned end (FI‑G07). Date `yyyy-MM-dd`. Time `HH:mm:ss±HH:mm` e.g. `10:36:46+01:00`; if a date is present the time is mandatory; offset optional, defaults to `00:00`. |
| FI‑G07 | Planned delivery end date and time | 1..1 | D | `/DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate` + `…/cbc:EndTime` | Same date/time rules as FI‑G06. |
| FI‑G08 | Actual despatch date and time | 1..1 | D | `/DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate` + `…/cbc:ActualDespatchTime` | Same date/time rules. |
| FI‑G09 | Shipment gross weight | 0..1 | Q | `/DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure` + `@unitCode` | Unit code required: `GRM` (g), `KGM` (kg), `TNE` (t). If unit code is not one of these, the value is ignored entirely. |
| FI‑G010 | Shipment gross volume | 0..1 | Q | `/DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure` + `@unitCode` | Unit code required: `MTQ` (m³), `LTR` (l). If unit code invalid, value ignored entirely. |
| FI‑G011 | Shipment package number | 0..1 | Q | `/DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity` | Total number of packages in the shipment. |
| FI‑G012 | Contract reference | 0..1 | O | `…/sbt:SrbDtExt/sbt:ExtDocuments/cac:ContractDocumentReference/cbc:ID` | Contract number. Max 500 chars. |
| FI‑G013 | Purchase order reference | 0..1 *(restricted from 0..n)* | O | `/DespatchAdvice/cac:OrderReference/cbc:ID` | Order/offer number. Max 500 chars. |
| FI‑G014 | Framework agreement reference | 0..1 *(restricted from 0..n)* | O | `…/sbt:SrbDtExt/sbt:ExtDocuments/cac:OriginatorDocumentReference/cbc:ID` | Framework-agreement number. Max 500 chars. |
| FI‑G015 | Shipment method | 1..1 | C | `…/sbt:SrbDtExt/sbt:ShipmentMethod/cbc:ShipmentMethodType` | `1` Own transport, `2` Carrier, `3` Recipient's transport, `4` Personal pickup, `5` Personal delivery. For 1/2/3 the Carrier (Prevoznik) party is used; for 4/5 the Courier (Kurir) is used. |
| FI‑G016 | Delivery note | 0..1 | T | `/DespatchAdvice/cac:Shipment/cac:Delivery/cbc:DeliveryInstructions` | Free text concerning delivery at the destination. Max 2000 chars. |
| FI‑G017 | Despatch note | 0..n | T | `/DespatchAdvice/cbc:Note` | Free text at whole-despatch level; stored as JSON. Combined length of all joined notes must not exceed **2000 characters**, counted as **characters, not UTF‑8 bytes**. |
| FI‑G018 | Goods return | 0..1 | C | `…/sbt:SrbDtExt/sbt:GoodsReturn/cbc:Return` | Value `1` ⇒ this is a goods return. |
| FI‑G019 | Hazardous goods | 0..1 | C | `…/sbt:SrbDtExt/sbt:HazardousGoods/cac:Hazardous/cbc:IsHazardous` | Value `1` ⇒ transport of hazardous materials. Enables the FG‑17 additional hazardous fields. |
| FI‑G021 | Third-party goods | 0..1 | T | `…/sbt:SrbDtExt/sbt:ThirdPartyGoods/cbc:ID` | Identifier (GUID format) of the related despatch advice in the system (capillary transport). |

### FG‑1 Despatch location address

Group `/DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress`
(0..1). Warehouse address where transport starts. **If omitted, the despatch
address equals the sender legal entity's address.**

| Ident. | Business term | K | T | UBL path (relative to `…/cac:Despatch/cac:DespatchAddress` unless noted) | Usage note |
|---|---|---|---|---|---|
| FI‑G11 | Address line 1 | 1..1 *(restricted from 0..1)* | T | `/cbc:StreetName` | Street name. |
| FI‑G12 | Address line 2 | 0..1 | T | `/cbc:AdditionalStreetName` | Additional street name. |
| FI‑G13 | Address line 3 | 0..1 | T | `/cac:AddressLine/cbc:Line` | House number. |
| FI‑G14 | City | 1..1 *(restricted from 0..1)* | T | `/cbc:CityName` | Despatch city/town. |
| FI‑G15 | Post code | 0..1 | T | `/DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone` | Postal code. **⚠ Path as written in the spec points to the supplier party postal address, not the despatch address – see [§9](#9-spec-discrepancies-corrected-element-names).** |
| FI‑G16 | Country subdivision | 0..1 | T | `/cbc:CountrySubentity` | Municipality (opština). |
| FI‑G17 | Country code | 1..1 | C | `/cac:Country/cbc:IdentificationCode` | For Serbia = `RS`. |
| FI‑G18 | Object code | 0..1 | C | `/cbc:ID` | Facility/object code. |

### FG‑2 Delivery location address

Group `/DespatchAdvice/cac:Shipment/cac:Delivery/cac:DeliveryAddress` (0..1). Final
transport address. **If omitted, equals the recipient legal entity's address.**

| Ident. | Business term | K | T | UBL path (relative to `…/cac:Delivery/cac:DeliveryAddress`) | Usage note |
|---|---|---|---|---|---|
| FI‑G21 | Address line 1 | 1..1 *(restricted from 0..1)* | T | `/cbc:StreetName` | Street name. |
| FI‑G22 | Address line 2 | 0..1 | T | `/cbc:AdditionalStreetName` | Additional street name. |
| FI‑G23 | Address line 3 | 0..1 | T | `/cac:AddressLine/cbc:Line` | House number. |
| FI‑G24 | City | 1..1 *(restricted from 0..1)* | T | `/cbc:CityName` | Destination city/town. |
| FI‑G25 | Post code | 0..1 | T | `/cbc:PostalZone` | Postal code. |
| FI‑G26 | Country subdivision | 0..1 | T | `/cbc:CountrySubentity` | Municipality. |
| FI‑G27 | Country code | 1..1 | C | `/cac:Country/cbc:IdentificationCode` | `RS`. |
| FI‑G28 | Object code | 0..1 | C | `/cbc:ID` | Facility/object code. |

### FG‑3 Despatch supplier party (sender) and FG‑4 / FG‑5

Group `/DespatchAdvice/cac:DespatchSupplierParty` (1..1). Sender of goods. A
**non-resident** sender must have a registered PIB in Serbia and, where the law
requires, a tax proxy.

| Ident. | Business term | K | T | UBL path (relative to `/DespatchAdvice/cac:DespatchSupplierParty/cac:Party`) | Usage note |
|---|---|---|---|---|---|
| FI‑G31 | Party name | 1..1 | T | `/cac:PartyLegalEntity/cbc:RegistrationName` | Business name. Residents: companies use business name; natural persons trading under JMBG use first + last name; other legal forms use the official full name. |
| FI‑G32 | Trading name | 0..1 | T | `/cac:PartyName/cbc:Name` | Residents: short business name / trading name. |
| FI‑G33 | Party identifier | 0..1 *(restricted from 0..n)* | I | `/cac:PartyIdentification/cbc:ID` | Public-funds users: exactly one identifier starting with `JBKJS:` followed by five digits from JBKJS. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyIdentification/cbc:ID/@schemeID` | Not stated for public-funds users. |
| FI‑G34 | Legal registration identifier | 1..1 *(restricted from 0..1)* | I | `/cac:PartyLegalEntity/cbc:CompanyID` | Mandatory for residents; natural persons use JMBG unless they trade under a special registration number. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyLegalEntity/cbc:CompanyID/@schemeID` | Not stated for resident companies. |
| FI‑G35 | Party VAT (PIB) | 1..1 *(restricted from 0..1)* | I | `/cac:PartyTaxScheme/cbc:CompanyID` | PIB with `RS` prefix. Per the PIB rulebook, JMBG is used as PIB for resident natural persons who are not entrepreneurs and for those with agriculture/forestry income. **Use `cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = "VAT"`.** |
| FI‑G36 | Additional legal information | 0..1 | T | `/cac:PartyLegalEntity/cbc:CompanyLegalForm` | Additional legal info if any. |
| FI‑G37 | Electronic address | 1..1 *(restricted from 0..1)* | I | `/cbc:EndpointID` | Sender PIB (may be in JMBG form). |
| ↳ | Scheme identifier | 1..1 *(restricted from 0..1)* | S | `/cbc:EndpointID/@schemeID` | EAS (Electronic Address Scheme). For Serbia always `9948`. |

**FG‑4 Despatch party postal address** – `/DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress` (1..1), registered seat of the sender:

| Ident. | Business term | K | T | UBL path (relative to `…/cac:Party/cac:PostalAddress`) | Usage note |
|---|---|---|---|---|---|
| FI‑G41 | Address line 1 | 1..1 *(restricted from 0..1)* | T | `/cbc:StreetName` | Street name. |
| FI‑G42 | Address line 2 | 0..1 | T | `/cbc:AdditionalStreetName` | |
| FI‑G43 | Address line 3 | 0..1 | T | `/cac:AddressLine/cbc:Line` | House number. |
| FI‑G44 | City | 1..1 *(restricted from 0..1)* | T | `/cbc:CityName` | |
| FI‑G45 | Post code | 0..1 | T | `/cbc:PostalZone` | |
| FI‑G46 | Country subdivision | 0..1 | T | `/cbc:CountrySubentity` | Municipality. |
| FI‑G47 | Country code | 1..1 | C | `/cac:Country/cbc:IdentificationCode` | `RS`. |

**FG‑5 Despatch contact** – `/DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact` (0..1):

| Ident. | Business term | K | T | UBL path (relative to `…/cac:Party/cac:Contact`) | Usage note |
|---|---|---|---|---|---|
| FI‑G51 | Contact point | 0..1 | T | `/cbc:Name` | Customer centre / dept / person. |
| FI‑G52 | Contact telephone | 0..1 | T | `/cbc:Telephone` | |
| FI‑G53 | Contact email | 0..1 | T | `/cbc:ElectronicMail` | |

### FG‑6 Delivery customer party (recipient) and FG‑7 / FG‑8

Group `/DespatchAdvice/cac:DeliveryCustomerParty` (1..1). Recipient of goods. A
**non-resident** recipient must have a registered PIB in Serbia and, where the law
requires, a tax proxy. Field semantics mirror the sender (FG‑3/4/5).

| Ident. | Business term | K | T | UBL path (relative to `/DespatchAdvice/cac:DeliveryCustomerParty/cac:Party`) | Usage note |
|---|---|---|---|---|---|
| FI‑G61 | Party name | 1..1 | T | `/cac:PartyLegalEntity/cbc:RegistrationName` | As FI‑G31. |
| FI‑G62 | Trading name | 0..1 | T | `/cac:PartyName/cbc:Name` | As FI‑G32. |
| FI‑G63 | Party identifier | 0..1 *(restricted from 0..n)* | I | `/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyIdentification/cbc:ID/@schemeID` | |
| FI‑G64 | Legal registration identifier | 1..1 *(restricted from 0..1)* | I | `/cac:PartyLegalEntity/cbc:CompanyID` | Mandatory for residents; natural persons = JMBG. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyLegalEntity/cbc:CompanyID/@schemeID` | |
| FI‑G65 | Party VAT (PIB) | 1..1 *(restricted from 0..1)* | I | `/cac:PartyTaxScheme/cbc:CompanyID` | PIB with `RS` prefix; JMBG may serve as PIB. Use `cac:TaxScheme/cbc:ID = "VAT"`. |
| FI‑G66 | Additional legal information | 0..1 | T | `/cac:PartyLegalEntity/cbc:CompanyLegalForm` | |
| FI‑G67 | Electronic address | 1..1 *(restricted from 0..1)* | I | `/cbc:EndpointID` | Recipient PIB (may be JMBG form). |
| ↳ | Scheme identifier | 1..1 *(restricted from 0..1)* | S | `/cbc:EndpointID/@schemeID` | EAS; Serbia = `9948`. |

**FG‑7 Delivery party postal address** – `/DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress` (1..1):

| Ident. | Business term | K | T | UBL path (relative to `…/cac:Party/cac:PostalAddress`) | Usage note |
|---|---|---|---|---|---|
| FI‑G71 | Address line 1 | 1..1 *(restricted from 0..1)* | T | `/cbc:StreetName` | |
| FI‑G72 | Address line 2 | 0..1 | T | `/cbc:AdditionalStreetName` | |
| FI‑G73 | Address line 3 | 0..1 | T | `/cac:AddressLine/cbc:Line` | House number. |
| FI‑G74 | City | 1..1 *(restricted from 0..1)* | T | `/cbc:CityName` | |
| FI‑G75 | Post code | 0..1 | T | `/cbc:PostalZone` | |
| FI‑G76 | Country subdivision | 0..1 | T | `/cbc:CountrySubentity` | |
| FI‑G77 | Country code | 1..1 | C | `/cac:Country/cbc:IdentificationCode` | `RS`. |

**FG‑8 Delivery party contact** – `/DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:Contact` (0..1): FI‑G81 contact point `/cbc:Name`, FI‑G82 telephone `/cbc:Telephone`, FI‑G83 email `/cbc:ElectronicMail` (each 0..1, T).

### FG‑9 Carrier party and FG‑10 / FG‑11

Group `/DespatchAdvice/cac:Shipment/cac:ShipmentStage/cac:CarrierParty` (0..n).
**Carrier is mandatory** when shipment method is Own transport, Carrier or
Recipient's transport (FI‑G015 ∈ {1,2,3}). Transloading (pretovar) is supported:
each leg is one `cac:ShipmentStage` with one carrier and one driver. Transloading
is **not** possible for Personal pickup or Personal delivery (FI‑G015 ∈ {4,5}).

| Ident. | Business term | K | T | UBL path (relative to `…/cac:ShipmentStage/cac:CarrierParty`) | Usage note |
|---|---|---|---|---|---|
| FI‑G91 | Carrier name | 1..1 | T | `/cac:PartyLegalEntity/cbc:RegistrationName` | As FI‑G31. |
| FI‑G92 | Trading name | 0..1 | T | `/cac:PartyName/cbc:Name` | |
| FI‑G93 | Identifier | 0..1 *(restricted from 0..n)* | I | `/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyIdentification/cbc:ID/@schemeID` | |
| FI‑G94 | Legal registration identifier | 1..1 *(restricted from 0..1)* | I | `/cac:PartyLegalEntity/cbc:CompanyID` | Mandatory for residents; natural persons = JMBG. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyLegalEntity/cbc:CompanyID/@schemeID` | |
| FI‑G95 | Carrier VAT (PIB) | 1..1 *(restricted from 0..1)* | I | `/cac:PartyTaxScheme/cbc:CompanyID` | PIB with `RS` prefix. Use `cac:TaxScheme/cbc:ID = "VAT"`. |
| FI‑G96 | Additional legal information | 0..1 | T | `/cac:PartyLegalEntity/cbc:CompanyLegalForm` | |
| FI‑G97 | Electronic address | 1..1 *(restricted from 0..1)* | I | `/cbc:EndpointID` | Carrier PIB (may be JMBG form). |
| ↳ | Scheme identifier | 1..1 *(restricted from 0..1)* | S | `/cbc:EndpointID/@schemeID` | EAS; Serbia = `9948`. |

**FG‑10 Carrier postal address** – `…/cac:ShipmentStage/cac:CarrierParty/cac:PostalAddress` (1..1): FI‑G101 `/cbc:StreetName` (1..1, restricted from 0..1), FI‑G102 `/cbc:AdditionalStreetName` (0..1), FI‑G103 `/cac:AddressLine/cbc:Line` (0..1), FI‑G104 `/cbc:CityName` (1..1, restricted from 0..1), FI‑G105 `/cbc:PostalZone` (0..1), FI‑G106 `/cbc:CountrySubentity` (0..1), FI‑G107 `/cac:Country/cbc:IdentificationCode` (1..1, `RS`).

**FG‑11 Carrier contact** – `…/cac:ShipmentStage/cac:CarrierParty/cac:Contact` (0..1): FI‑G111 `/cbc:Name`, FI‑G112 `/cbc:Telephone`, FI‑G113 `/cbc:ElectronicMail` (each 0..1, T).

### FG‑12 Carrier driver

Group `/DespatchAdvice/cac:Shipment/cac:ShipmentStage/cac:DriverPerson` (0..1).
Driver, vehicle and route per shipment stage.

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G120 | Driver's ID | 0..1 | I | `…/cac:ShipmentStage/cac:DriverPerson/cbc:ID` | Email address of the person carrying the goods. If the person uses the MATP app with the same email (same account as on eID) entered as identifier at carrier legal-entity level, the driver may use the same account for several carriers. |
| FI‑G121 | Driver's name | 0..1 | T | `…/cac:DriverPerson/cbc:FirstName` + `…/cbc:FamilyName` | First and last name. |
| FI‑G122 | Driver's license number | 0..1 | I | `…/cac:DriverPerson/cac:IdentityDocumentReference/cbc:ID` + `…/cbc:DocumentType` | Driving licence number. |
| FI‑G123 | Driver contact telephone | 0..1 | T | `…/cac:DriverPerson/cac:Contact/cbc:Telephone` | |
| FI‑G124 | License plate ID | 1..1 | I | `…/cac:ShipmentStage/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID` | Vehicle registration plate. |
| FI‑G126 | Driver email address | 0..1 | T | `…/cac:DriverPerson/cac:Contact/cbc:ElectronicMail` | Need not equal the email that identifies the driver for MATP app access. |
| FI‑G125 | Driving route | 0..1 | T | `…/cac:ShipmentStage/cac:LoadingPortLocation/cbc:Description` + `…/cac:UnloadingPortLocation/cbc:Description` | **If a planned transload exists, the route is mandatory.** |

### FG‑13 Personal delivery (courier)

Group `/DespatchAdvice/cac:Shipment/cac:ShipmentStage/cac:MasterPerson` (0..1).
Delivery by a physical person when shipment method is Personal pickup or Personal
delivery (FI‑G015 ∈ {4,5}). **The courier is mandatory; the Carrier (FG‑9) and
Driver (FG‑12) are omitted.**

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G131 | Contact point | 1..1 *(restricted from 0..1)* | T | `…/cac:MasterPerson/cbc:FirstName` + `…/cbc:FamilyName` | Name of the courier performing the delivery/pickup. |
| FI‑G132 | Identifier | 1..1 *(restricted from 0..1)* | I | `…/cac:MasterPerson/cac:IdentityDocumentReference/cbc:ID` + `…/cbc:DocumentType` | Courier's ID-card number. `DocumentType` is always "Lična karta" (ID card). |

### FG‑14 Despatch line

Group `/DespatchAdvice/cac:DespatchLine` (1..n).

| Ident. | Business term | K | T | UBL path (relative to `/DespatchAdvice/cac:DespatchLine`) | Usage note |
|---|---|---|---|---|---|
| FI‑G141 | Line identifier | 1..1 | I | `/cbc:ID` | Sequence number of the despatch line. |
| FI‑G142 | Delivered quantity | 1..1 *(restricted from 0..1)* | Q | `/cbc:DeliveredQuantity` | Quantity of the item on the line. |
| FI‑G143 | Delivered quantity unit of measure code | 1..1 *(restricted from 0..1)* | C | `/cbc:DeliveredQuantity/@unitCode` | Allowed unit codes – see [§7 Code lists](#unit-of-measure-codes-fi-g143-despatch--fi-g143-receipt). |
| FI‑G144 | Referenced purchase order line reference | 0..1 | I | `/cac:OrderLineReference/cbc:LineID` | If `N/A` is entered, the order-line reference is treated as not present. |

**FG‑15 Item information** – `/DespatchAdvice/cac:DespatchLine/cac:Item` (1..1):

| Ident. | Business term | K | T | UBL path (relative to `…/cac:DespatchLine/cac:Item`) | Usage note |
|---|---|---|---|---|---|
| FI‑G151 | Item name | 1..1 | T | `/cbc:Name` | |
| FI‑G153 | Item seller's identifier | 1..1 *(restricted from 0..1)* | I | `/cac:SellersItemIdentification/cbc:ID` | Item code in the seller's books. |
| FI‑G152 | Item description | 0..n | T | `/cbc:Description` | |
| FI‑G154 | Item standard identification (GTIN) | 0..1 | I | `/cac:StandardItemIdentification/cbc:ID` | Global item number. If the tag is sent it **must** have a value and may contain up to 14 digits. |

**FG‑16 Item attributes** – `/DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty` (0..n). One despatch advice may mix non-excise and excise goods. Attributes are optional per line; multiple may be added. The VACR web app shows at most 4 additional attributes (excluding excise attributes), but all sent attributes remain accessible via XML.

| Ident. | Business term | K | T | UBL path (relative to `…/cac:AdditionalItemProperty`) | Usage note |
|---|---|---|---|---|---|
| FI‑G161 | Item attribute name | 1..1 | T | `/cbc:Name` | For excise goods these named attributes are mandatory – see [§7 Excise-goods attributes](#excise-goods-attributes-fi-g161fi-g162). |
| FI‑G162 | Item attribute value | 0..1 | T | `/cbc:Value` | Value rules per excise category – see [§7](#excise-goods-attributes-fi-g161fi-g162). |

### FG‑17 Hazardous goods data

Group `…/sbt:SrbDtExt/sbt:HazardousGoods/cac:AdditionalHazardousProperty` (0..n).
Used when goods are hazardous (FI‑G019 = 1). Each entry has a name then a value;
multiple entries allowed.

| Ident. | Business term | K | T | UBL path (relative to `…/sbt:HazardousGoods/cac:AdditionalHazardousProperty`) | Usage note |
|---|---|---|---|---|---|
| FI‑G171 | Additional hazardous field name | 1..1 *(restricted from 0..1)* | T | `/cbc:Name` | |
| FI‑G172 | Additional hazardous field value | 1..1 *(restricted from 0..1)* | T | `/cbc:Value` | |
| FI‑G173 | Additional hazardous field comment | 0..1 | T | `/cbc:Comment` | |

### FG‑18 Additional document reference

Group `/DespatchAdvice/cac:AdditionalDocumentReference` (0..n). Attachment to the
despatch advice. **Either** an embedded attachment **or** a URI link to an external
document must be present – **not both** in the same structure.

| Ident. | Business term | K | T | UBL path (relative to `…/cac:AdditionalDocumentReference`) | Usage note |
|---|---|---|---|---|---|
| FI‑G181 | Supporting document reference | 0..1 | O | `/cbc:ID` | Identifier of the accompanying document. |
| FI‑G182 | Supporting document description | 0..1 | T | `/cbc:DocumentDescription` | |
| FI‑G183 | External document location | 0..1 | T | `/cac:Attachment/cac:ExternalReference/cbc:URI` | Mutually exclusive with FI‑G184. |
| FI‑G184 | Attached document | 0..1 | B | `/cac:Attachment/cbc:EmbeddedDocumentBinaryObject` | The embedded file. Mutually exclusive with FI‑G183. |
| ↳ | Attached document MIME code | 1..1 | S | `/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode` | |
| ↳ | Attached document filename | 1..1 | S | `/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename` | |

---

## 5. Receipt Advice (ePrijemnica → UBL `ReceiptAdvice`)

Most party/address groups (FG‑1 … FG‑13) are **identical to the Despatch Advice**
but rooted at `/ReceiptAdvice/…` instead of `/DespatchAdvice/…`. Only the
receipt-specific header fields, lines and the referenced-issuer group differ; they
are listed below. For the shared groups, apply the FG‑1…FG‑13 rules from §4 with
the `/ReceiptAdvice` root.

### Header

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G01 | Receipt advice number | 1..1 | I | `/ReceiptAdvice/cbc:ID` | Unique within a PIB; public-funds within JBKJS. Max 500 chars. |
| FI‑G03 | Despatch internal reference | 1..1 | I | `/ReceiptAdvice/cac:DespatchDocumentReference/cbc:ID` | Number of the related despatch advice this receipt refers to. Max 500 chars. |
| FI‑G04 | Despatch advice issue date | 1..1 | D | `/ReceiptAdvice/cac:DespatchDocumentReference/cbc:IssueDate` | `yyyy-MM-dd`. |
| FI‑G07 | Receipt advice issue date | 1..1 | D | `/ReceiptAdvice/cbc:IssueDate` | `yyyy-MM-dd`. |
| FI‑G08 | Actual delivery start date and time | 1..1 *(restricted from 0..1)* | D | `/ReceiptAdvice/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate` + `…/cbc:ActualDeliveryTime` | Date/time rules as despatch. |
| FI‑G09 | Shipment gross weight | 0..1 | Q | `/ReceiptAdvice/cac:Shipment/cbc:GrossWeightMeasure` + `@unitCode` | `GRM`/`KGM`/`TNE`; invalid unit ⇒ ignored. |
| FI‑G010 | Shipment gross volume | 0..1 | Q | `/ReceiptAdvice/cac:Shipment/cbc:GrossVolumeMeasure` + `@unitCode` | `MTQ`/`LTR`; invalid unit ⇒ ignored. |
| FI‑G011 | Contract reference | 0..1 | O | `…/sbt:SrbDtExt/sbt:ExtDocuments/cac:ContractDocumentReference/cbc:ID` | Max 500 chars. |
| FI‑G012 | Purchase order reference | 0..1 *(restricted from 0..n)* | O | `/ReceiptAdvice/cac:OrderReference/cbc:ID` | Max 500 chars. |
| FI‑G013 | Framework agreement reference | 0..1 *(restricted from 0..n)* | O | `…/sbt:SrbDtExt/sbt:ExtDocuments/cac:OriginatorDocumentReference/cbc:ID` | Max 500 chars. |
| FI‑G014 | Shipment method | 1..1 | C | `…/sbt:SrbDtExt/sbt:ShipmentMethod/cbc:ShipmentMethodType` | Codes 1–5 as despatch. |
| FI‑G015 | Receipt note | 0..n | T | `/ReceiptAdvice/cbc:Note` | JSON; combined ≤ 2000 characters (count characters, not UTF‑8 bytes). |
| FI‑G016 | Despatch package number | 0..1 | Q | `/ReceiptAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity` | Number of packages stated on the receipt. |
| FI‑G017 | Receipt advice type code | 1..1 *(restricted from 0..1)* | C | `/ReceiptAdvice/cbc:ReceiptAdviceTypeCode` | `Int` = internal, `Ext` = external. |

Shared groups for Receipt Advice (apply §4 rules at `/ReceiptAdvice` root):

- **FG‑1** Despatch location address `…/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress` (FI‑G11…G18). *(Note: FI‑G15 post code path in the spec is `/ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone` – same anomaly as despatch, see [§9](#9-spec-discrepancies-corrected-element-names).)*
- **FG‑2** Delivery location address `…/cac:Shipment/cac:Delivery/cac:DeliveryAddress` (FI‑G21…G28).
- **FG‑3/4/5** Despatch supplier party `/ReceiptAdvice/cac:DespatchSupplierParty` (FI‑G31…G53).
- **FG‑6/7/8** Delivery customer party `/ReceiptAdvice/cac:DeliveryCustomerParty` (FI‑G61…G83).
- **FG‑9/10/11** Carrier party `/ReceiptAdvice/cac:Shipment/cac:ShipmentStage/cac:CarrierParty` (FI‑G91…G113).
- **FG‑12** Carrier driver `/ReceiptAdvice/cac:Shipment/cac:ShipmentStage/cac:DriverPerson` – field IDs are renumbered in the receipt model: FI‑G120 driver's ID `/cbc:ID`; FI‑G121 name `/cbc:FirstName`+`/cbc:FamilyName`; FI‑G125 license number `/cac:IdentityDocumentReference/cbc:ID`+`/cbc:DocumentType`; FI‑G126 email `/cac:Contact/cbc:ElectronicMail`; FI‑G122 telephone `/cac:Contact/cbc:Telephone`; FI‑G123 license plate `…/cac:ShipmentStage/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID` (1..1); FI‑G124 driving route `…/cac:LoadingPortLocation/cbc:Description`+`…/cac:UnloadingPortLocation/cbc:Description` (mandatory if planned transload).
- **FG‑13** Personal delivery (courier) `/ReceiptAdvice/cac:Shipment/cac:ShipmentStage/cac:MasterPerson` – FI‑G131 (1..1) `/cbc:FirstName`+`/cbc:FamilyName`; FI‑G132 (1..1) `/cac:IdentityDocumentReference/cbc:ID`+`/cbc:DocumentType` (`DocumentType` always "Lična karta").

### FG‑14 Receipt line

Group `/ReceiptAdvice/cac:ReceiptLine` (1..n). The quantity model differs from the
despatch advice (counted / accepted / rejected).

| Ident. | Business term | K | T | UBL path (relative to `/ReceiptAdvice/cac:ReceiptLine`) | Usage note |
|---|---|---|---|---|---|
| FI‑G141 | Line identifier | 1..1 | I | `/cbc:ID` | Sequence number of the receipt line. |
| FI‑G143 | Delivered quantity unit of measure code | 1..1 *(restricted from 0..1)* | C | `/cbc:ReceivedQuantity/@unitCode` | Unit codes – see [§7](#unit-of-measure-codes-fi-g143-despatch--fi-g143-receipt). |
| FI‑G144 | Received quantity | 1..1 *(restricted from 0..1)* | Q | `/cbc:ReceivedQuantity` | Counted quantity; may differ from the despatch quantity. Mandatory for qualitative + quantitative check. |
| FI‑G145 | Accepted quantity | 1..1 *(restricted from 0..1)* | Q | `/cbc:ReceivedQuantity` and `/cbc:RejectedQuantity` | Accepted quantity ≤ received. **Computed: FI‑G145 = FI‑G144 − FI‑G146** (received − rejected). Mandatory for qualitative + quantitative check. *(See [§9](#9-spec-discrepancies-corrected-element-names) – there is no dedicated UBL "AcceptedQuantity" element; it is derived.)* |
| FI‑G146 | Rejected quantity | 1..1 *(restricted from 0..1)* | Q | `/cbc:RejectedQuantity` | Quantity returned to the sender by the same transport. |
| FI‑G147 | Referenced purchase order line reference | 0..1 | I | `/cac:OrderLineReference/cbc:LineID` | |
| FI‑G148 | Line note | 0..n | T | `/cbc:Note` | Free text. |
| FI‑G149 | Despatch line reference | 0..1 | I | `/cac:DespatchLineReference/cbc:LineID` | Receipt line references the corresponding despatch line. |

**FG‑15 Item information** – `/ReceiptAdvice/cac:ReceiptLine/cac:Item` (1..1): FI‑G151 name `/cbc:Name` (1..1); FI‑G152 description `/cbc:Description` (0..n); FI‑G153 seller's identifier `/cac:SellersItemIdentification/cbc:ID` (1..1, restricted from 0..1); FI‑G154 GTIN `/cac:StandardItemIdentification/cbc:ID` (0..1, up to 14 digits).

**FG‑16 Item attributes** – `/ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:AdditionalItemProperty` (0..n). Copied from the despatch advice. FI‑G161 name `/cbc:Name` (1..1, excise codes as §7), FI‑G162 value `/cbc:Value` (0..1, rules as §7).

### FG‑17 Additional document reference (Receipt)

Group `/ReceiptAdvice/cac:AdditionalDocumentReference` (0..n). Same "attachment XOR
URI" rule as despatch FG‑18.

| Ident. | Business term | K | T | UBL path (relative to `…/cac:AdditionalDocumentReference`) | Usage note |
|---|---|---|---|---|---|
| FI‑G171 | Supporting document reference | 0..1 | O | `/cbc:ID` | |
| FI‑G172 | Supporting document description | 0..1 | T | `/cbc:DocumentDescription` | |
| FI‑G173 | External document location | 0..1 | T | `/cac:Attachment/cac:ExternalReference/cbc:URI` | Mutually exclusive with FI‑G174. |
| FI‑G174 | Attached document | 0..1 | B | `/cac:Attachment/cbc:EmbeddedDocumentBinaryObject` | Mutually exclusive with FI‑G173. |
| ↳ | Attached document MIME code | 1..1 | S | `/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode` | |
| ↳ | Attached document filename | 1..1 | S | `/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename` | |

### FG‑18 Referenced issuer party (Receipt)

Group `/ReceiptAdvice/cac:DespatchDocumentReference/cac:IssuerParty` (1..1). The
party that issued the despatch advice this receipt refers to.

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G181 | Issuer party electronic address | 1..1 | I | `…/cac:DespatchDocumentReference/cac:IssuerParty/cbc:EndpointID` | Issuer PIB (may be JMBG form). |
| ↳ | Scheme identifier | 1..1 | S | `…/cbc:EndpointID/@schemeID` | EAS; Serbia = `9948`. |
| FI‑G182 | Issuer party identifier | 0..1 | I | `…/cac:DespatchDocumentReference/cac:IssuerParty/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `…/cac:PartyIdentification/cbc:ID/@schemeID` | |

---

## 6. Application Response (shipment changes / user actions → UBL `ApplicationResponse`)

Carries actions/changes on an existing shipment (see [§1](#1-documents-and-identifiers)).

### Header

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G01 | Shipment change number | 1..1 | I | `/ApplicationResponse/cbc:ID` | Unique change number within the sender's status changes. Max 500 chars. |
| FI‑G02 | Shipment change issue date | 1..1 | D | `/ApplicationResponse/cbc:IssueDate` | ISO date `yyyy-MM-dd`. |
| FI‑G03 | Note | 0..1 | T | `/ApplicationResponse/cbc:Note` | Free text. Max 2000 chars. |
| FI‑G04 | Shipment change type code | 1..1 | C | `/ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode` | `1` storno (cancel); `2` seizure; `3` receipt accepted; `4` receipt rejected; `5` transload (pretovar); `6` physical receipt of goods; `7` start of transport; `8` vehicle change. |
| FI‑G05 | Referenced document | 1..1 | O | `/ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID` | Reference to the original despatch advice or receipt advice. Max 500 chars. |
| FI‑G06 | Referenced document issue date | 1..1 | D | `/ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:IssueDate` | ISO date. |

### FG‑1 Sender party / FG‑2 Receiver party / FG‑3 Referenced issuer party

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G11 | Sender party electronic address | 1..1 | I | `/ApplicationResponse/cac:SenderParty/cbc:EndpointID` | Sender PIB (may be JMBG form). On **seizure**, the name of the service that performed the seizure is given and **two documents** are sent – one to the goods sender, one to the goods recipient. |
| ↳ | Scheme identifier | 1..1 | S | `…/cac:SenderParty/cbc:EndpointID/@schemeID` | EAS; Serbia = `9948`. |
| FI‑G12 | Sender party identifier | 0..1 | I | `/ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `…/cac:PartyIdentification/cbc:ID/@schemeID` | |
| FI‑G21 | Receiver party electronic address | 1..1 | I | `/ApplicationResponse/cac:ReceiverParty/cbc:EndpointID` | |
| ↳ | Scheme identifier | 1..1 | S | `…/cac:ReceiverParty/cbc:EndpointID/@schemeID` | `9948`. |
| FI‑G22 | Receiver party identifier | 0..1 | I | `/ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `…/cac:PartyIdentification/cbc:ID/@schemeID` | |
| FI‑G31 | Issuer party electronic address | 1..1 | I | `/ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cac:IssuerParty/cbc:EndpointID` | Issuer of the original referenced document. |
| ↳ | Scheme identifier | 1..1 | S | `…/cac:IssuerParty/cbc:EndpointID/@schemeID` | `9948`. |
| FI‑G32 | Issuer party identifier | 0..1 | I | `…/cac:IssuerParty/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `…/cac:PartyIdentification/cbc:ID/@schemeID` | |

### FG‑4 Carrier party (transload)

Group `…/sbt:SrbDtExt/sbt:TransShipment/cac:ShipmentStage/cac:CarrierParty` (0..n).
**Carrier data is mandatory when the change type is Transload** (FI‑G04 = 5).
Transload is not possible when the original shipment method is Personal pickup or
Personal delivery.

| Ident. | Business term | K | T | UBL path (relative to `…/sbt:TransShipment/cac:ShipmentStage/cac:CarrierParty`) | Usage note |
|---|---|---|---|---|---|
| FI‑G41 | Carrier name | 1..1 | T | `/cac:PartyLegalEntity/cbc:RegistrationName` | As FI‑G31 (despatch). |
| FI‑G42 | Trading name | 0..1 | T | `/cac:PartyName/cbc:Name` | |
| FI‑G43 | Identifier | 0..1 *(restricted from 0..n)* | I | `/cac:PartyIdentification/cbc:ID` | Public-funds: `JBKJS:` + 5 digits. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyIdentification/cbc:ID/@schemeID` | |
| FI‑G44 | Legal registration identifier | 1..1 | I | `/cac:PartyLegalEntity/cbc:CompanyID` | Mandatory for residents; natural persons = JMBG. |
| ↳ | Scheme identifier | 0..1 | S | `/cac:PartyLegalEntity/cbc:CompanyID/@schemeID` | |
| FI‑G45 | Carrier VAT (PIB) | 1..1 *(restricted from 0..1)* | I | `/cac:PartyTaxScheme/cbc:CompanyID` | PIB with `RS` prefix. Use `cac:TaxScheme/cbc:ID = "VAT"`. |
| FI‑G46 | Additional legal information | 0..1 | T | `/cac:PartyLegalEntity/cbc:CompanyLegalForm` | |
| FI‑G47 | Electronic address | 1..1 *(restricted from 0..1)* | I | `/cbc:EndpointID` | Carrier PIB (may be JMBG form). |
| ↳ | Scheme identifier | 1..1 *(restricted from 0..1)* | S | `/cbc:EndpointID/@schemeID` | EAS; Serbia = `9948`. |

**FG‑5 Carrier postal address** (1..1) – the spec mixes two roots; see [§9](#9-spec-discrepancies-corrected-element-names):
- FI‑G51 line 1 `/ApplicationResponse/cac:DocumentResponse/cac:Response/cac:ShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName` (1..1).
- FI‑G52 line 2 `…/sbt:TransShipment/cac:ShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName` (0..1).
- FI‑G53 line 3 `…/sbt:TransShipment/…/cac:PostalAddress/cac:AddressLine/cbc:Line` (0..1).
- FI‑G54 city `…/sbt:TransShipment/…/cac:PostalAddress/cbc:CityName` (1..1, restricted from 0..1).
- FI‑G55 post code `…/cac:PostalAddress/cbc:PostalZone` (0..1).
- FI‑G56 country subdivision `…/cac:PostalAddress/cbc:CountrySubentity` (0..1).
- FI‑G57 country code `…/cac:PostalAddress/cac:Country/cbc:IdentificationCode` (1..1, `RS`).

**FG‑6 Carrier contact** (0..1) – `…/sbt:TransShipment/cac:ShipmentStage/cac:CarrierParty/cac:Contact`: FI‑G61 `/cbc:Name`, FI‑G62 `/cbc:Telephone`, FI‑G63 `/cbc:ElectronicMail` (each 0..1, T).

### FG‑7 Carrier driver (transload / vehicle change)

Group `…/sbt:SrbDtExt/sbt:TransShipment/cac:ShipmentStage/cac:DriverPerson` (0..1).
Besides updating all legs, it is possible to update **only the vehicle and driver**
data. Such a change can be initiated **before the start of the journey** and **cannot
change the transport-company data**.

Two distinct paths apply, selected by the change type:
- **Unplanned transload** → `…/sbt:SrbDtExt/sbt:TransShipment/cac:ShipmentStage/…`
- **Vehicle change** → `…/sbt:SrbDtExt/sbt:VehicleChange/…`

| Ident. | Business term | K | T | UBL path (unplanned transload) | UBL path (vehicle change) | Usage note |
|---|---|---|---|---|---|---|
| FI‑G70 | Driver's ID | 0..1 | I | `…/sbt:TransShipment/cac:ShipmentStage/cac:DriverPerson/cbc:ID` | `…/sbt:VehicleChange/cac:DriverPerson/cbc:ID` | Email of the person carrying goods (see FI‑G120 despatch). |
| FI‑G71 | Driver's name | 0..1 | T | `…/sbt:TransShipment/cac:ShipmentStage/cac:DriverPerson/cbc:FirstName` + `/ApplicationResponse/cac:DocumentResponse/cac:Response/cac:ShipmentStage/cac:DriverPerson/cbc:FamilyName` | `…/sbt:VehicleChange/cac:DriverPerson/cbc:FirstName` + `…/cbc:FamilyName` | *(Mixed roots for First/Family name in spec – see [§9](#9-spec-discrepancies-corrected-element-names).)* |
| FI‑G75 | Driver's license number | 0..1 | I | `…/sbt:TransShipment/cac:ShipmentStage/cac:DriverPerson/cac:IdentityDocumentReference/cbc:ID` + `…/cbc:DocumentType` | `…/sbt:VehicleChange/cac:DriverPerson/cac:IdentityDocumentReference/cbc:ID` + `…/cbc:DocumentType` | |
| FI‑G72 | Driver contact telephone | 0..1 | T | `…/sbt:TransShipment/cac:ShipmentStage/cac:DriverPerson/cac:Contact/cbc:Telephone` | `…/sbt:VehicleChange/cac:DriverPerson/cac:Contact/cbc:Telephone` | |
| FI‑G73 | License plate ID | 1..1 | I | `…/sbt:TransShipment/cac:ShipmentStage/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID` | `…/sbt:VehicleChange/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID` | |
| FI‑G74 | Driving route | 1..1 | T | `…/sbt:TransShipment/cac:ShipmentStage/cac:LoadingPortLocation/cbc:Description` + `…/cac:UnloadingPortLocation/cbc:Description` | — | **Mandatory if an unplanned transload exists.** |

### FG‑8 Signed despatch advice / start of transportation

Group `…/sbt:SrbDtExt/sbt:TransportationStart` and
`…/sbt:TransportationStart/cac:SignedDocumentDA` (0..1, type `At`). A despatch
advice that was printed, physically signed by the driver, then scanned and attached
as proof of goods receipt.

| Ident. | Business term | K | T | UBL path | Usage note |
|---|---|---|---|---|---|
| FI‑G81 | Start of transportation | 1..1 | D | `…/sbt:TransportationStart/cbc:StartDate` + `…/cbc:StartTime` | Date `yyyy-MM-dd`; time `HH:mm:ss±HH:mm`; if date present, time mandatory; offset optional, defaults to `00:00`. |
| FI‑G82 | Attached document | 0..1 | B | `…/sbt:TransportationStart/cac:SignedDocumentDA/cac:Attachment/cbc:EmbeddedDocumentBinaryObject` | The document itself. **Not mandatory** if confirmation is done via the VACR app (driver signature on a printed form is then not required). |
| ↳ | Attached document MIME code | 1..1 | S | `…/cbc:EmbeddedDocumentBinaryObject/@mimeCode` | |
| ↳ | Attached document filename | 1..1 | S | `…/cbc:EmbeddedDocumentBinaryObject/@filename` | |

---

## 7. Code lists

### Shipment method (FI‑G015 despatch / FI‑G014 receipt)

`…/sbt:SrbDtExt/sbt:ShipmentMethod/cbc:ShipmentMethodType`:

| Value | Meaning | Party used |
|---|---|---|
| `1` | Own transport (Sopstveni prevoz) | Carrier (FG‑9) |
| `2` | Carrier (Prevoznik) | Carrier (FG‑9) |
| `3` | Recipient's transport (Prevoz primaoca) | Carrier (FG‑9) |
| `4` | Personal pickup (Lično preuzimanje) | Courier (FG‑13) |
| `5` | Personal delivery (Lična dostava) | Courier (FG‑13) |

### Shipment change type (Application Response FI‑G04)

`/ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode`:

| Value | Meaning |
|---|---|
| `1` | Storno (cancellation) |
| `2` | Seizure of goods (zaplena robe) |
| `3` | Receipt accepted (prihvaćena prijemnica) |
| `4` | Receipt rejected (odbijena prijemnica) |
| `5` | Transload (pretovar) |
| `6` | Physical receipt of goods (fizički prijem robe) |
| `7` | Start of transport (start prevoza) |
| `8` | Vehicle change (promena vozila) |

### Despatch / Receipt type code

`Int` = internal, `Ext` = external (`cbc:DespatchAdviceTypeCode` / `cbc:ReceiptAdviceTypeCode`).

### Shipment gross weight / volume unit codes

- Weight (FI‑G09): `GRM` (g), `KGM` (kg), `TNE` (t).
- Volume (FI‑G010): `MTQ` (m³), `LTR` (l).
- An invalid/missing unit code ⇒ the whole measure is ignored.

### Unit-of-measure codes (FI‑G143 despatch / FI‑G143 receipt)

`@unitCode` on `cbc:DeliveredQuantity` (despatch) / `cbc:ReceivedQuantity` (receipt):

| Code | Meaning | Code | Meaning |
|---|---|---|---|
| `KWH` | kWh | `MIN` | minute |
| `H87` | piece (kom) | `HUR` | hour |
| `KGM` | kg | `DAY` | day |
| `KMT` | km | `MON` | month |
| `GRM` | g | `ANN` | year |
| `MTR` | m | `SEC` | second |
| `LTR` | l | `ACT` | activity (akt) |
| `TNE` | t | `H18` | hectare (ha) |
| `MTK` | m² | `H16` | are (a) |
| `MTQ` | m³ | `CMK` | cm² |
| `XKI` | set | `KT` | kit (komplet) |
| `PR` | pair (par) | `KWT` | kW |

### Excise-goods attributes (FI‑G161/FI‑G162)

For excise goods, the following named additional attributes (`cbc:Name`) are
**mandatory** with coded names; the value (`cbc:Value`) depends on category:

1. **Excise category** – `cbc:Name = AKCIZE.KATEGORIJA`; allowed `cbc:Value`:
   `DUVAN` (tobacco), `KAFA` (coffee), `ALKOHOL` (alcohol), `NAFTA` (petroleum
   derivatives), `NIKOTIN` (nicotine).
2. **Packaging / measure** – name depends on category:
   | Category | Attribute name (`cbc:Name`) | Allowed value (`cbc:Value`) |
   |---|---|---|
   | `DUVAN` | `AKCIZE.DUVAN.TIP_PAKOVANJA` | `PAKLICA`, `BOKS`, `MASTERKEJS`, `PALETA` |
   | `NIKOTIN` | `AKCIZE.NIKOTIN.TIP_PAKOVANJA` | any text |
   | `KAFA` | `AKCIZE.KAFA.GRAMAZA` | any decimal (grammage) |
   | `ALKOHOL` | `AKCIZE.ALKOHOL.LITRAZA` | any decimal (litres) |
   | `NAFTA` | `AKCIZE.NAFTA.GUSTINA` | any decimal (density) |
3. **Brand code** – **only** for tobacco (`AKCIZE.KATEGORIJA = DUVAN`): a third
   attribute `cbc:Name = AKCIZE.DUVAN.SIFRA_ROBNE_MARKE`, with the brand code as
   `cbc:Value`.

---

## 8. Extension element order

Under `…/cec:ExtensionContent/sbt:SrbDtExt`, child elements are XSD-ordered and
**must appear in this sequence** (Central Register processing depends on it).

**Despatch Advice extension order:**

```xml
<xsd:element ref="sbt:ShipmentMethod"     minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:OfflineZinNumber"   minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:GoodsReturn"        minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:HazardousGoods"     minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:ThirdPartyGoods"    minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:ExtDocuments"       minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:TransportationStart" minOccurs="0" maxOccurs="1"/>
<xsd:element ref="sbt:TransShipment"      minOccurs="0" maxOccurs="1"/>
```

**Receipt Advice extension order:**

```xml
<xsd:element ref="sbt:ShipmentMethod"     minOccurs="1" maxOccurs="1"/>
<xsd:element ref="sbt:ExtDocuments"       minOccurs="0" maxOccurs="1"/>
```

The Application Response uses `sbt:TransShipment`, `sbt:VehicleChange` and
`sbt:TransportationStart` extension elements (see FG‑4 … FG‑8 above); the
specification does not give an explicit ordered list for it.

---

## 9. Spec discrepancies (corrected element names)

The prose specification contains some UBL element-name typos and inconsistent
paths. The tables above use the **real UBL 2.1 element names** (confirmed against
the official example XML files under
`src/test/resources/external/test-files/1.1.0/`). Recorded here for traceability:

| Where | Spec text | Used here (correct) | Basis |
|---|---|---|---|
| All contact / driver email fields (FI‑G53, FI‑G83, FI‑G113, FI‑G126, FG‑6 …) | `cbc:ElectronicEmail` | `cbc:ElectronicMail` | UBL 2.1 element name; confirmed in `eotpremnica-001.xml`. |
| Receipt advice type code (FI‑G017) | `cac:ReceiptAdviceTypeCode` | `cbc:ReceiptAdviceTypeCode` | Confirmed `<cbc:ReceiptAdviceTypeCode>` in `eprijemnica-001.xml`. |
| Despatch / Receipt post code FI‑G15 | `…/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone` | *(left as written – flagged)* | Path points to the **supplier party** postal address, not the **despatch location** address; likely a copy/paste error. A Schematron author should decide whether FI‑G15 maps to `…/cac:Despatch/cac:DespatchAddress/cbc:PostalZone`. |
| Application Response FG‑5 / FG‑7 driver-name paths | Mixed roots (`cac:DocumentResponse/cac:Response/…` vs `sbt:TransShipment/…`) | *(both documented – flagged)* | The spec mixes the standard-UBL and the extension roots within the same group; verify against a real Application Response example before finalizing. |
| Receipt "Accepted quantity" FI‑G145 | mapped to `cbc:ReceivedQuantity` + `cbc:RejectedQuantity` | *(derived, not a distinct element)* | There is no `AcceptedQuantity` element in UBL `ReceiptLine`; accepted = received − rejected. |

> **No official Application Response example file** is published, so the
> Application Response paths (especially FG‑5/FG‑7) could not be cross-checked
> against a real document and should be verified before being enforced.

---

## 10. Summary of cross-field rules for Schematron

Beyond cardinality and code-list checks, the following conditional/business rules
are the most useful candidates for Schematron assertions:

1. **CustomizationID** must equal the fixed value for the document type ([§1](#1-documents-and-identifiers)).
2. **Country codes** (FI‑G17/G27/G47/G77/G107/G57) for domestic Serbian addresses must be `RS`.
3. **EndpointID schemeID** (electronic addresses) must be `9948`.
4. **TaxScheme ID** for the VAT/PIB element must be `VAT`.
5. **Shipment method drives party presence:** FI‑G015 ∈ {1,2,3} ⇒ Carrier (FG‑9) mandatory; FI‑G015 ∈ {4,5} ⇒ Courier (FG‑13) mandatory and Carrier/Driver omitted.
6. **Planned start ≤ planned end:** FI‑G06 date/time must not be after FI‑G07.
7. **Tobacco/excise products:** FI‑G06 (planned start) is mandatory; excise attribute set (FI‑G161/G162) mandatory; brand code only for `DUVAN`.
8. **Hazardous goods:** FI‑G019 = 1 enables/expects the FG‑17 additional hazardous fields.
9. **Attachment XOR external URI:** within one `cac:AdditionalDocumentReference`, exactly one of embedded attachment (FI‑G184/FI‑G174) or external URI (FI‑G183/FI‑G173) may be present.
10. **Receipt quantities:** accepted = received − rejected (FI‑G145 = FI‑G144 − FI‑G146); accepted ≤ received.
11. **Route on transload:** if a (planned or unplanned) transload exists, the driving route is mandatory (FI‑G125 / FI‑G124 / FI‑G74).
12. **Document type codes** restricted to `Int` / `Ext`.
13. **Length limits:** document number 500; notes combined 2000 characters (count characters, not UTF‑8 bytes); GTIN ≤ 14 digits; ZIN = 2 letters + 9 digits.
14. **Public-funds identifiers** (FI‑G33/G63/G93/…): exactly one identifier `JBKJS:` + 5 digits.
