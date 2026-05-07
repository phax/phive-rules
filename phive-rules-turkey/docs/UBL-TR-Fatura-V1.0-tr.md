# UBL-TR (Fatura - Invoice)

**GELİR İDARESİ BAŞKANLIĞI**
Denetim ve Uyum Yönetim Daire Başkanlığı

Aralık 2017 — ANKARA
Versiyon: 1.0

---

## Versiyon Geçmişi

| Versiyon | Yayım Tarihi | Eklenen/Silinen/Değişen Bölüm | Açıklama |
|----------|--------------|--------------------------------|----------|
| 0.1 | 28.11.2014 | -- | Taslak kılavuzun ilk yayım tarihi |
| 0.2 | 31.03.2015 | Sayfa 34 | Örnekteki TaxInclusiveAmount ve PayableAmount alanı **değiştirildi**. |
| 0.2 | 31.03.2015 | 2.3.37, 2.3.38, 2.3.39, 2.3.40 | Örnekler **değiştirildi**. |
| 0.2 | 31.03.2015 | -- | Kılavuzun ilk yayım tarihi |
| 0.3 | 31.03.2016 | 2.3.5 | ID alanı **değiştirildi**. |
| 0.4 | 15.04.2016 | Sayfa 22 | Not alanı **çıkartıldı**. |
| 0.4 | 15.04.2016 | 2.3.21 | 2.3.21 **değiştirildi**. |
| 1.0 | 20.12.2017 | Sayfa 17, 18 | 483 nolu tebliğe göre EFT-POS için güncelleme yapıldı. |

---

## İçindekiler

1. Giriş
2. UBL-TR FATURA
   - 2.1 XSD Gösterimi
   - 2.2 Fatura Elemanları-Genel
   - 2.3 Fatura Elemanları-Detay
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

## 1. Giriş

Bu kılavuz, UBL-TR v1.2 (UBL 2.1 Türkiye Özelleştirmesi) paketinde yer alan fatura belgesinde geçen elemanlara ait XSD, tanımlama, kullanım şekilleri, kardinaliteler hakkında bilgi vermek ve örnek kullanım şekillerini göstermek amacı ile hazırlanmıştır.

Kılavuz içerisinde UBL-TR paketinde yer alan faturaya ilişkin herbir eleman açıklanırken aşağıdaki tablo yapısı kullanılmıştır.

| [Eleman: UBL adı] | [Eleman: Türkçe karşılığı] |
|-------------------|----------------------------|
| **Diyagram** | Bu satırda anlatılan elemanın diyagramı sunulmaktadır. |
| **Kardinalite** | Bu bölümde elemanın kardinalitesi sunulmaktadır. Kardinaliteler aşağıdaki şekilde olabilir:<br>**Zorunlu (1):** Eleman zorunlu ve mutlaka bir tane bulunmak zorundadır.<br>**Zorunlu (1..n):** Eleman zorunlu ve en az bir tane bulunmak zorundadır. Eleman birden fazla tekrarlayabilir.<br>**Seçimli (0..1):** Eleman seçimlidir ve en çok bir tane bulunabilir.<br>**Seçimli (0..n):** Eleman seçimlidir ve birden fazla tekrarlayabilir. |
| **Açıklama** | Elemanın ne amaçla kullanıldığı bu bölümde açıklanmaktadır. |
| **Kullanım** | Elemanın nasıl kullanılacağı, diğer elemanlar arasındaki ilişkiler, elemanın veri tipi, elemandaki kısıtlar detaylı olarak bu bölümde açıklanır. Karmaşık elemanların gösterdiği ortak sınıflar ayrıca "Bknz." ile referans verilmektedir. |
| **Örnek** | Eleman için bir veya daha çok XML örneği bu bölümde sunulmaktadır. |

---

## 2. UBL-TR FATURA

### 2.1 XSD Gösterimi

UBL-TR paketinde yer alan fatura belgesine ait XSD şemasının ana elemanlarının gösterimi aşağıdaki gibidir.

(InvoiceType ana elemanları: ext:UBLExtensions, cbc:UBLVersionID, cbc:CustomizationID, cbc:ProfileID, cbc:ID, cbc:CopyIndicator, cbc:UUID, cbc:IssueDate, cbc:IssueTime, cbc:InvoiceTypeCode, cbc:Note, cbc:DocumentCurrencyCode, cbc:TaxCurrencyCode, cbc:PricingCurrencyCode, cbc:PaymentCurrencyCode, cbc:PaymentAlternativeCurrencyCode, cbc:AccountingCost, cbc:LineCountNumeric, cac:InvoicePeriod, cac:OrderReference, cac:BillingReference, cac:DespatchDocumentReference, cac:ReceiptDocumentReference, cac:OriginatorDocumentReference, cac:ContractDocumentReference, cac:AdditionalDocumentReference, cac:Signature, cac:AccountingSupplierParty, cac:AccountingCustomerParty, cac:BuyerCustomerParty, cac:SellerSupplierParty, cac:TaxRepresentativeParty, cac:Delivery, cac:PaymentMeans, cac:PaymentTerms, cac:AllowanceCharge, cac:TaxExchangeRate, cac:PricingExchangeRate, cac:PaymentExchangeRate, cac:PaymentAlternativeExchangeRate, cac:TaxTotal, cac:WithholdingTaxTotal, cac:LegalMonetaryTotal, cac:InvoiceLine)

### 2.2 Fatura Elemanları-Genel

Fatura belgesine ait XSD şemasında yer alan ana elemanların Türkçe karşılıkları ve içeriğine ilişkin açıklamalar, aşağıdaki tabloda yer almaktadır.

| No | UBL Adı | Türkçe Karşılığı | İçerik |
|----|---------|------------------|--------|
| 1 | UBLExtensions | UBL Genişletme Alanı | UBL Genişletme Alanı – Bu alanda XAdES formatında Elektronik İmza bilgileri bulunmaktadır. |
| 2 | UBLVersionID | UBL Versiyon Numarası | UBL Versiyon Numarası |
| 3 | CustomizationID | Özelleştirme Numarası | UBL Özelleştirme Numarası |
| 4 | ProfileID | Senaryo | Kullanılan Senaryo |
| 5 | ID | Fatura Numarası | Faturaya Ait Numara |
| 6 | CopyIndicator | Asıl / Suret | Faturanın Asıl veya Suret Bilgisi |
| 7 | UUID | Evrensel Tekil Tanımlama Numarası (ETTN) | Faturanın Evrensel Tekliğini Sağlayan Numara |
| 8 | IssueDate | Düzenleme Tarihi | Faturanın Düzenleme Tarihi |
| 9 | IssueTime | Düzenleme Zamanı | Faturanın Düzenleme Zamanı |
| 10 | InvoiceTypeCode | Fatura Tip Kodu | Fatura Tipi Kodu |
| 11 | Note | Not | Fatura İle İlgili Genel Açıklamalar |
| 12 | DocumentCurrencyCode | Belge Para Birim Kodu | Faturanın Düzenlendiği Para Biriminin Kodu |
| 13 | TaxCurrencyCode | Vergi Para Birim Kodu | Belge Para Birimi Kodu Dışında Vergi Ödemelerinde Kullanılacak Para Birimi Kodu |
| 14 | PricingCurrencyCode | Fiyatlandırma Para Birim Kodu | Belge Para Birimi Kodu Dışında Fiyatlandırmada Kullanılacak Para Birimi Kodu |
| 15 | PaymentCurrencyCode | Ödeme Para Birim Kodu | Belge Para Birimi Kodu Dışında Ödemede Kullanılacak Para Birimi Kodu |
| 16 | PaymentAlternativeCurrencyCode | Alternatif Ödeme Para Birim Kodu | Belge Para Birimi ve Ödeme Para Birimi Dışında Ödemelerde Kullanılacak Alternatif Para Birimi Kodu |
| 17 | AccountingCost | İlave Fatura Tipi Ayrımı | Mükellefin Fatura Tipi Olarak İlave Bir Ayırıma Gitmesi Gerekiyorsa Kendi Belirleyeceği Farklı Bir Fatura Tipini Bu Elemana Yazabilir |
| 18 | LineCountNumeric | Kalem Sayısı | Fatura Kalem Sayısı |
| 19 | InvoicePeriod | Fatura Dönemi | Faturanın Ait Olduğu Dönem Bilgileri |
| 20 | OrderReference | Sipariş Bilgileri | Sipariş Bilgileri |
| 21 | BillingReference | Diğer İlişkili Olduğu Belgelerin Bilgileri | Faturanın İlişkili Olduğu Diğer Belgelerin Bilgileri |
| 22 | DespatchDocumentReference | İrsaliye Bilgileri | İrsaliye Bilgileri |
| 23 | ReceiptDocumentReference | Alındı Bilgileri | Alındı Bilgileri |
| 24 | OriginatorDocumentReference | Başlangıç Dokümanı Bilgileri | Faturanın Düzenlenmesine Referans Teşkil Eden Belgelere Ait Bilgileri |
| 25 | ContractDocumentReference | Kontrat Dokümanı Bilgileri | Kontrat Dokümanına Ait Bilgiler |
| 26 | AdditionalDocumentReference | İlave Doküman | Fatura ile ilgili Diğer Dokümanlara Ait Bilgiler |
| 27 | Signature | Mali Mühür/İmza | Elektronik Mali Mühür ve/veya Elektronik İmza ile Bunlara Ait Sertifika Bilgileri |
| 28 | AccountingSupplierParty | Satıcı | Faturayı Düzenleyen Tarafa Ait Bilgiler |
| 29 | AccountingCustomerParty | Alıcı | Faturayı Alan Tarafa Ait Bilgiler |
| 30 | BuyerCustomerParty | Faturadaki Hizmeti/Mal Alan Taraf | Faturanın Alıcısının Haricinde Faturadaki Mal veya Hizmeti Alan Taraf |
| 31 | SellerSupplierParty | Faturadaki Hizmeti/Mal Sağlayan Taraf | Faturayı Düzenleyen Haricinde Faturadaki Mal veya Hizmeti Sağlayan Taraf |
| 32 | TaxRepresentativeParty | Vergi İşleriyle Sorumlu Taraf | Vergi İşleriyle Sorumlu Taraf |
| 33 | Delivery | Gönderim, Taşıma, Sevkiyat Bilgileri | Gönderim, Taşıma ve Sevkiyat Bilgileri |
| 34 | PaymentMeans | Ödeme Şekli | Ödeme Şekline İlişkin Bilgiler |
| 35 | PaymentTerms | Ödeme Koşulları | Ödeme Koşullarına İlişkin Bilgiler |
| 36 | AllowanceCharge | Iskonto/Artırım | Faturaya Uygulanan Iskonto veya Artırım Bilgileri |
| 37 | TaxExchangeRate | Vergi Döviz Kuru | Belge Para Birimi Dışında Vergi Ödemelerinin Hesaplamasında Kullanılacak Döviz Kuru |
| 38 | PricingExchangeRate | Fiyatlandırma Döviz Kuru | Belge Para Birimi Dışında Fiyatlandırmada Kullanılacak Döviz Kuru |
| 39 | PaymentExchangeRate | Ödeme Döviz Kuru | Belge Para Birimi Dışında Ödemelerde Kullanılacak Döviz Kuru |
| 40 | PaymentAlternativeExchangeRate | Ödeme Alternatif Döviz Kuru | Belge Para Birimi ve Ödeme Para Birimi Dışında Ödemelerde Kullanılacak Alternatif Döviz Kuru |
| 41 | TaxTotal | Toplam Vergi | Vergi Bilgileri ve Toplamlar |
| 42 | WithholdingTaxTotal | Tevkifat Bilgileri | Tevkifat Bilgileri |
| 43 | LegalMonetaryTotal | Parasal Toplamlar | Fatura İçindeki Parasal Tutarların Toplamları |
| 44 | InvoiceLine | Mal/Hizmet Kalemleri | Faturaya Konu Mal Hizmet Bilgileri |

Tabloda yer alan ana elemanların her birine ait açıklamalar izleyen bölümde yapılacaktır. Açıklama yöntemi olarak öncelikle elemanın adı, Türkçe karşılığı, kullanım şekli ve örneklere yer verilecektir.

---

## 2.3 Fatura Elemanları-Detay

### 2.3.1 UBLExtensions

| UBLExtensions | UBL Genişletme Alanı |
|---------------|----------------------|
| **Kardinalite** | Zorunlu (1..n) |
| **Açıklama** | Bu alana XAdES formatında mali mühür/elektronik imza bilgileri yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: UBLExtension |
| **Örnek** | XAdES formatında elektronik imza içeren `<ext:UBLExtensions>` yapısı (ds:Signature, ds:SignedInfo, ds:CanonicalizationMethod, ds:SignatureMethod, ds:Reference, ds:Transforms, ds:DigestMethod, ds:DigestValue, ds:SignatureValue, ds:KeyInfo, ds:X509Data, ds:X509Certificate, ds:KeyValue, ds:RSAKeyValue, ds:Modulus, ds:Exponent dahil). |

### 2.3.2 UBLVersionID

| UBLVersionID | UBL Versiyon Numarası |
|--------------|------------------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | XSD dokümanının UBL versiyonu yazılacaktır. |
| **Kullanım** | Bu değer için "2.1" kullanılacaktır. |
| **Örnek** | `<cbc:UBLVersionID>2.1</cbc:UBLVersionID>` |

### 2.3.3 CustomizationID

| CustomizationID | Özelleştirme Numarası |
|-----------------|------------------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | UBL'in özelleştirme numarasıdır. |
| **Kullanım** | Bu değer için "TR1.2" kullanılacaktır. |
| **Örnek** | `<cbc:CustomizationID>TR1.2</cbc:CustomizationID>` |

### 2.3.4 ProfileID

| ProfileID | Senaryo |
|-----------|---------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Kullanılan senaryodur. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:ProfileID>TEMELFATURA</cbc:ProfileID>` |

### 2.3.5 ID

| ID | Fatura Numarası |
|----|-----------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Üç haneli alfanumerik birim kod ile 13 haneli müteselsil numaranın birleşiminden meydana gelen Fatura Numarası bu elemana yazılacaktır. Müteselsil numaranın ilk dört hanesi faturanın düzenlendiği yılı kalan dokuz hane ise müteselsil numarayı ifade etmektedir. Fatura düzenleyen bünyesinde aynı fatura numarası birden fazla kullanılamaz. |
| **Kullanım** | Alfanumerik |
| **Örnek** | `<cbc:ID>GIB2009000000001</cbc:ID>` |

### 2.3.6 CopyIndicator

| CopyIndicator | Asıl/Suret |
|---------------|------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemanda düzenlenen faturanın asıl veya suret olduğu gösterilecektir. |
| **Kullanım** | Asıl ise "false", suret ise "true" |
| **Örnek** | `<cbc:CopyIndicator>true</cbc:CopyIndicator>` |

### 2.3.7 UUID

| UUID | Evrensel Tekil Tanımlama Numarası |
|------|------------------------------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Evrensel Tekil Tanımlama Numarası (ETTN), düzenlenen faturanın evrensel eşsizliğini sağlayan numaradır. Bu numara fatura düzenleyen tarafından standartlara uygun olarak üretilip faturalarda kullanılacaktır. |
| **Kullanım** | GUID formatı |
| **Örnek** | `<cbc:UUID>e093a490-dd99-11dd-ad8b-0800200c9a66</cbc:UUID>` |

### 2.3.8 IssueDate

| IssueDate | Düzenleme Tarihi |
|-----------|-------------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemana faturanın düzenleme tarihi yazılacaktır. |
| **Kullanım** | Yıl-Ay-Gün (YYYY-AA-GG) |
| **Örnek** | `<cbc:IssueDate>2009-01-01</cbc:IssueDate>` |

### 2.3.9 IssueTime

| IssueTime | Düzenleme Zamanı |
|-----------|-------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Bu elemana faturanın düzenleme saati yazılabilecektir. |
| **Kullanım** | Saat:Dakika:Saniye |
| **Örnek** | `<cbc:IssueTime>14:50:00</cbc:IssueTime>` |

### 2.3.10 InvoiceTypeCode

| InvoiceTypeCode | Fatura Tip Kodu |
|------------------|------------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemanda UBL-TR içerisinde yer alan fatura tiplerine ait kodlar yazılacaktır. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:InvoiceTypeCode>SATIS</cbc:InvoiceTypeCode>` |

### 2.3.11 Note

| Note | Not |
|------|-----|
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Faturada yer verilmek istenen genel açıklamalar için bu eleman kullanılacaktır. Birden fazla açıklama yapılmak istenmesi halinde elemanın tekrar kullanımı mümkündür. |
| **Kullanım** | Serbest Metin |
| **Örnek** | `<cbc:Note>İş bu fatura muhteviyatına 7 gün içerisinde itiraz edilmediği taktirde aynen kabul edilmiş sayılır.</cbc:Note>` |

### 2.3.12 DocumentCurrencyCode

| DocumentCurrencyCode | Belge Para Birim Kodu |
|----------------------|------------------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemana faturanın düzenlendiği paranın birim kodu yazılacaktır. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:DocumentCurrencyCode>TRY</cbc:DocumentCurrencyCode>` |

### 2.3.13 TaxCurrencyCode

| TaxCurrencyCode | Vergi Para Birimi Kodu |
|-----------------|--------------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Fatura üzerinde gösterilen vergilerin "Belge Para Birim Kodu" dışında başka bir para birimi ile gösterilmesi gerekiyorsa bu para biriminin kodu yazılabilecektir. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:TaxCurrencyCode>USD</cbc:TaxCurrencyCode>` |

### 2.3.14 PricingCurrencyCode

| PricingCurrencyCode | Fiyatlandırma Para Birim Kodu |
|---------------------|--------------------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Mal veya hizmet bedellerinin "Belge Para Birim Kodu" dışında bir para birimi ile de gösterilmesi gerekiyorsa sözkonusu para birimi bu elemana kodlanabilecektir. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:PricingCurrencyCode>USD</cbc:PricingCurrencyCode>` |

### 2.3.15 PaymentCurrencyCode

| PaymentCurrencyCode | Ödeme Para Birim Kodu |
|---------------------|------------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Ödemenin yapılacağı para birimi "Belge Para Birim Kodu" dışında bir para birimi ise bu bedellerin gösterildiği para birimi bu elemana kodlanabilecektir. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:PaymentCurrencyCode>USD</cbc:PaymentCurrencyCode>` |

### 2.3.16 PaymentAlternativeCurrencyCode

| PaymentAlternativeCurrencyCode | Alternatif Ödeme Para Birim Kodu |
|--------------------------------|------------------------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Ödenecek tutarın belge para birimi ile ödeme para birimi dışında başka bir para birimi ile de ifade edilmesinin istenmesi halinde söz konusu para biriminin kodu bu elemana yazılabilecektir. |
| **Kullanım** | Bknz. Kod Listeleri |
| **Örnek** | `<cbc:PaymentAlternativeCurrencyCode>USD</cbc:PaymentAlternativeCurrencyCode>` |

### 2.3.17 AccountingCost

| AccountingCost | Hesap Kodu |
|----------------|------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Mükellefin faturanın tipi olarak ilave bir ayırıma gitmesi gerekiyorsa kendi belirleyeceği farklı bir fatura tipini bu elemana yazabilir. |
| **Kullanım** | Serbest Metin |
| **Örnek** | `<cbc:AccountingCost>Gider</cbc:AccountingCost>` |

### 2.3.18 LineCountNumeric

| LineCountNumeric | Kalem Sayısı |
|------------------|---------------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemana fatura üzerinde yer alan kalem sayısı yazılacaktır. Malın adedi birden fazla olsa dahi bu mal grubu tek bir kalem olarak gösterilecektir. |
| **Kullanım** | Numerik |
| **Örnek** | `<cbc:LineCountNumeric>2</cbc:LineCountNumeric>` |

### 2.3.19 InvoicePeriod

| InvoicePeriod | Fatura Dönemi |
|---------------|----------------|
| **Diyagram (alanları)** | cbc:StartDate, cbc:StartTime, cbc:EndDate, cbc:EndTime, cbc:DurationMeasure, cbc:Description |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Faturada dönem bilgisine yer verilmesi halinde bu eleman kullanılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: Period |
| **Örnek** | `<cac:InvoicePeriod><cbc:StartDate>2009-08-13</cbc:StartDate><cbc:EndDate>2009-09-13</cbc:EndDate><cbc:Description>[AÇIKLAMA]</cbc:Description></cac:InvoicePeriod>` |

### 2.3.20 OrderReference

| OrderReference | Sipariş Bilgileri |
|----------------|--------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:SalesOrderID, cbc:IssueDate, cbc:OrderTypeCode, cac:DocumentReference |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Sipariş bilgilerinin gösterilmesinde ve sipariş belgesinin faturaya eklenmesinde bu eleman kullanılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: OrderReference |
| **Örnek** | `<cac:OrderReference><cbc:ID>12345</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:OrderReference>` |

### 2.3.21 BillingReference

| BillingReference | Faturanın İlişkili Olduğu Diğer Belgelerin Bilgileri |
|------------------|------------------------------------------------------|
| **Diyagram (alanları)** | cac:InvoiceDocumentReference, cac:SelfBilledInvoiceDocumentReference, cac:CreditNoteDocumentReference, cac:DebitNoteDocumentReference, cac:ReminderDocumentReference, cac:BillingReferenceLine |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Faturanın ilişkili olduğu diğer belgelerin bilgileri bu elemana yazılacaktır.<br><br>**NOT:** 433 nolu VUK genel tebliği kapsamında düzenlenen ÖKC bilgi fişi bilgileri kullanılmışsa bu elemanın altında AdditionalDocumentReference elemanına yazılacaktır. Bilgiler aşağıdaki şekilde yazılmalıdır.<br>- AdditionalDocumentReference/ID: Fiş Numarası yazılacaktır.<br>- AdditionalDocumentReference/IssueDate: Bilgi fişi tarihi yazılacaktır.<br>- AdditionalDocumentReference/DocumentTypeCode: OKCBF sabit değeri yazılmalıdır.<br>- AdditionalDocumentReference/DocumentType: OKCBilgiFisi sabit değeri yazılmalıdır.<br>- AdditionalDocumentReference/DocumentDescription: Bilgi Fişi Tipi yazılmalıdır. Kabul edilecek değerler şunlardır: AVANS, YEMEK_FIS, E-FATURA, E-FATURA_IRSALIYE, E-ARSIV, E-ARSIV_IRSALIYE, FATURA, OTOPARK, FATURA_TAHSILAT, FATURA_TAHSILAT_KOMISYONLU.<br>- AdditionalDocumentReference/Attachment/ExternalReference/URI: Z Raporu numarası yazılacaktır. 483 nolu VUK genel tebliği kapsamında EFT-POS için kullanma muafiyeti alanlar bu alana 483 değerini yazacaklardır.<br>- AdditionalDocumentReference/ValidityPeriod/StartDate: İrsaliye yerine geçmesi durumunda bilgi fişi tarihi yazılmalıdır.<br>- AdditionalDocumentReference/ValidityPeriod/cbc:StartTime: İrsaliye yerine geçmesi durumunda bilgi fişi zamanı yazılmalıdır.<br>- AdditionalDocumentReference/IssuerParty/EndpointID: ÖKC Seri numarası yazılacaktır. 483 nolu VUK genel tebliği kapsamında EFT-POS için kullanma muafiyeti alanlar bu alana 483 değerini yazacaklardır. |
| **Kullanım** | Bknz. Ortak Sınıflar: BillingReference |
| **Örnek 1** | `<cac:BillingReference><cac:InvoiceDocumentReference><cbc:ID>12345</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:InvoiceDocumentReference></cac:BillingReference>` |
| **Örnek 2** | ÖKC bilgi fişi içeren tam BillingReference örneği. AdditionalDocumentReference (ID=Fiş no, IssueDate, DocumentTypeCode=OKCBF, DocumentType=OKCBilgiFisi, DocumentDescription=E-FATURA), Attachment/ExternalReference/URI=Z Raporu no, ValidityPeriod/StartDate ve StartTime, IssuerParty/EndpointID=MF XXX 11000100 (ÖKC Seri no), PartyIdentification, PostalAddress (CitySubdivisionName, CityName, Country/Name) alanları içerir. |

### 2.3.22 DespatchDocumentReference

| DespatchDocumentReference | İrsaliye Bilgileri |
|---------------------------|---------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | İrsaliye bilgileri için bu eleman kullanılabilecektir. Birden fazla irsaliyeye ait bilgilerin girilmesi ve irsaliye belgesinin faturaya eklenmesinde bu eleman kullanılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: DocumentReference |
| **Örnek** | `<cac:DespatchDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:DespatchDocumentReference>` |

### 2.3.23 ReceiptDocumentReference

| ReceiptDocumentReference | Alındı Bilgileri |
|--------------------------|-------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Alındı bilgilerinin gösterilmesinde ve alındı belgesinin faturaya eklenmesinde bu eleman kullanılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: DocumentReference |
| **Örnek** | `<cac:ReceiptDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:ReceiptDocumentReference>` |

### 2.3.24 OriginatorDocumentReference

| OriginatorDocumentReference | Başlangıç Dokümanı Bilgileri |
|------------------------------|--------------------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Faturanın düzenlenmesine referans teşkil eden ilgili belgelere ait bilgiler bu elemana yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: DocumentReference |
| **Örnek** | `<cac:OriginatorDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:OriginatorDocumentReference>` |

### 2.3.25 ContractDocumentReference

| ContractDocumentReference | Kontrat Dokümanı Bilgileri |
|---------------------------|------------------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Fatura ile ilgili kontrat dokümanın bilgilerinin gösterilmesinde bu eleman kullanılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: DocumentReference |
| **Örnek** | `<cac:ContractDocumentReference><cbc:ID>123456</cbc:ID><cbc:IssueDate>2009-04-13</cbc:IssueDate></cac:ContractDocumentReference>` |

### 2.3.26 AdditionalDocumentReference

| AdditionalDocumentReference | İlave Doküman |
|------------------------------|-----------------|
| **Diyagram (alanları)** | cbc:ID, cbc:IssueDate, cbc:DocumentTypeCode, cbc:DocumentType, cbc:DocumentDescription, cac:Attachment, cac:ValidityPeriod, cac:IssuerParty |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | İrsaliye, sipariş, kontrat, alındı ve diğer fatura belgeleri dışında faturaya eklenmek istenen diğer belgeler için bu eleman kullanılabilecektir. Örneğin belge para birimi dışında ayrıca fatura düzenlenmek isteniyorsa bu fatura düzenlenip AdditionalDocumentReference elemanının EmbeddedDocumentBinaryObject elemanına eklenebilir. |
| **Kullanım** | Bknz. Ortak Sınıflar: DocumentReference |
| **Örnek** | `<cac:AdditionalDocumentReference><cbc:ID>1234</cbc:ID><cbc:IssueDate>2008-08-13</cbc:IssueDate><cac:Attachment><cbc:EmbeddedDocumentBinaryObject mimeCode="application/CSTAdata+xml">UjBsR09EbGhjZ0dTQUxNQUFBR0FBUlU1tQ1p0dU1GUXhFUzhi</cbc:EmbeddedDocumentBinaryObject></cac:Attachment></cac:AdditionalDocumentReference>` |

### 2.3.27 Signature

| Signature | Mali Mühür/İmza |
|-----------|-------------------|
| **Diyagram (alanları)** | cbc:ID, SignatoryParty, DigitalSignatureAttachment |
| **Kardinalite** | Zorunlu (1..n) |
| **Açıklama** | Bu elemanda faturada kullanılan mali mühür ve/veya elektronik imza ile sertifikalara ilişkin bilgilere yer verilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: Signature |
| **Örnek** | `<cac:Signature><cbc:ID>1288331521</cbc:ID><cac:SignatoryParty>` ile başlayan, PartyIdentification (VKN), PostalAddress (StreetName=Ihlamur Mahallesi Selvi Caddesi Sedir Sokak, BuildingNumber=75/A, CitySubdivisionName=Kızılay, CityName=Ankara, PostalZone=06100, Country/Name=Türkiye) ve DigitalSignatureAttachment/ExternalReference/URI=#12345 alanları içeren tam yapı. |

### 2.3.28 AccountingSupplierParty

| AccountingSupplierParty | Satıcı |
|-------------------------|--------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemanda faturayı düzenleyen tarafın bilgileri yer alacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: SupplierParty |
| **Örnek** | `<cac:AccountingSupplierParty><cac:Party>` içinde WebsiteURI=http://www.bbb.com.tr/, PartyIdentification/ID schemeID="VKN"=9205121120, PartyName=BBB Limited Şirketi, PostalAddress (ID=1234567890, StreetName=Ihlamur Mahallesi Selvi Caddesi Sedir Sokak, BuildingNumber=75/A, CitySubdivisionName=Kızılay, CityName=Ankara, PostalZone=06100, Country/Name=Türkiye), PartyTaxScheme/TaxScheme/Name=Çankaya, Contact (Telephone=(312) 621 1111, Telefax=(312) 621 1010, ElectronicMail=bb@bbb.com.tr). |

### 2.3.29 AccountingCustomerParty

| AccountingCustomerParty | Alıcı |
|-------------------------|--------|
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemanda faturayı alan tarafın bilgileri yer alacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: CustomerParty |
| **Örnek** | `<cac:AccountingCustomerParty><cac:Party>` içinde WebsiteURI=http://www.aaa.com.tr/, PartyIdentification/ID schemeID="VKN"=1288331521, PartyName=AAA Anonim Şirketi, PostalAddress (ID=1234567890, StreetName=Papatya Caddesi Yasemin Sokak, BuildingNumber=21, CitySubdivisionName=Beşiktaş, CityName=İstanbul, PostalZone=34100, Country/Name=Türkiye), PartyTaxScheme/TaxScheme/Name=Büyük Mükellefler, Contact (Telephone=(212) 925 51515, Telefax=(212) 925505015, ElectronicMail=aa@aaa.com.tr). |

### 2.3.30 BuyerCustomerParty

| BuyerCustomerParty | Faturadaki Hizmeti/Ürünü Alan Taraf |
|--------------------|--------------------------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Faturanın alıcısının haricinde faturadaki mal veya hizmeti alan taraf için bu eleman kullanılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: CustomerParty |
| **Örnek** | AccountingCustomerParty örneği ile aynı yapıda BuyerCustomerParty. |

### 2.3.31 SellerSupplierParty

| SellerSupplierParty | Faturadaki Hizmeti/Ürünü Sağlayan Taraf |
|---------------------|------------------------------------------|
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Faturayı düzenleyen haricinde faturadaki mal veya hizmeti sağlayan taraf bilgileri için bu eleman kullanılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: SupplierParty |
| **Örnek** | AccountingCustomerParty/BuyerCustomerParty ile aynı yapıda SellerSupplierParty örneği. |

### 2.3.32 TaxRepresentativeParty

| TaxRepresentativeParty | Vergi İşleriyle Sorumlu Taraf |
|------------------------|--------------------------------|
| **Diyagram (alanları)** | cbc:WebsiteURI, cbc:IndustryClassificationCode, cac:PartyIdentification (1..n), cac:PartyName, cac:PostalAddress, cac:PartyTaxScheme, cac:PartyLegalEntity (0..n), cac:Contact, cac:Person, cac:AgentParty |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Eğer faturadaki vergi işlerinden sorumlu olan taraf bilgileri eklenmek istiyorsa bu eleman kullanılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: Party |
| **Örnek** | TaxRepresentativeParty/Party yapısı (WebsiteURI, PartyIdentification VKN=1288331521, PartyName=AAA Anonim Şirketi, PostalAddress, PartyTaxScheme, Contact). |

### 2.3.33 Delivery

| Delivery | Gönderim, Taşıma, Sevkiyat Bilgileri |
|----------|----------------------------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:Quantity, cbc:ActualDeliveryDate, cbc:ActualDeliveryTime, cbc:LatestDeliveryDate, cbc:LatestDeliveryTime, cbc:TrackingID, cac:DeliveryAddress, cac:AlternativeDeliveryLocation, cac:EstimatedDeliveryPeriod, cac:CarrierParty, cac:DeliveryParty, cac:Despatch, cac:DeliveryTerms (0..n), cac:Shipment |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Bu elemana gönderim, taşıma ve sevkiyat ile ilgili bilgiler yazılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: Delivery |
| **Örnek** | DeliveryAddress (CityName=Bakü, Country/Name=Azerbaycan), DeliveryParty (PartyIdentification VKN=1288331521, PartyName=AAA Nakliyat, PostalAddress=Papatya Caddesi Yasemin Sokak 21, Beşiktaş, İstanbul, 34100, Türkiye), DeliveryTerms/ID=CIF, Shipment (GrossWeightMeasure unitCode="KGM"=14444, NetWeightMeasure unitCode="KGM"=14414, TotalTransportHandlingUnitQuantity=21, InsuranceValueAmount currencyID="USD"=150, DeclaredForCarriageValueAmount currencyID="USD"=3900). |

### 2.3.34 PaymentMeans

| PaymentMeans | Ödeme Şekli |
|--------------|--------------|
| **Diyagram (alanları)** | cbc:PaymentMeansCode, cbc:PaymentDueDate, cbc:PaymentChannelCode, cbc:InstructionNote, cac:PayerFinancialAccount, cac:PayeeFinancialAccount |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Bu elemana ödeme şekli ile ilgili bilgiler yazılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: PaymentMeans |
| **Örnek** | `<cac:PaymentMeans><cbc:PaymentMeansCode>42</cbc:PaymentMeansCode><cbc:PaymentDueDate>2009-01-13</cbc:PaymentDueDate><cbc:PaymentChannelCode>1234</cbc:PaymentChannelCode><cbc:InstructionNote>[AÇIKLAMA]</cbc:InstructionNote><cac:PayeeFinancialAccount><cbc:ID>IBANTR12345567</cbc:ID><cbc:CurrencyCode>TRY</cbc:CurrencyCode><cbc:PaymentNote>[ÖDEMEAÇIKLAMASI]</cbc:PaymentNote></cac:PayeeFinancialAccount></cac:PaymentMeans>` |

### 2.3.35 PaymentTerms

| PaymentTerms | Ödeme Koşulları |
|--------------|-------------------|
| **Diyagram (alanları)** | cbc:Note, cbc:PenaltySurchargePercent, cbc:Amount, cbc:PenaltyAmount, cbc:PaymentDueDate, cac:SettlementPeriod |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Bu elemana ödeme koşulları ve ödemenin yapılmaması halinde uygulanacak müeyyideler yazılabilecektir. |
| **Kullanım** | Bknz. Ortak Sınıflar: PaymentTerms |
| **Örnek** | `<cac:PaymentTerms><cbc:Note>[AÇIKLAMA]</cbc:Note><cbc:PenaltySurchargePercent>20.0</cbc:PenaltySurchargePercent><cbc:PaymentDueDate>2009-01-13</cbc:PaymentDueDate><cbc:Amount currencyID="TRY">100.0</cbc:Amount></cac:PaymentTerms>` |

### 2.3.36 AllowanceCharge

| AllowanceCharge | Iskonto / Artırım |
|-----------------|---------------------|
| **Diyagram (alanları)** | cbc:ChargeIndicator, cbc:AllowanceChargeReason, cbc:MultiplierFactorNumeric, cbc:SequenceNumeric, cbc:Amount, cbc:BaseAmount, cbc:PerUnitAmount |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Bu eleman fatura bütünü üzerinden iskonto veya artırım yapılması halinde kullanılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: AllowanceCharge |
| **Örnek** | `<cac:AllowanceCharge><cbc:ChargeIndicator>false</cbc:ChargeIndicator><cbc:AllowanceChargeReason>[ISKONTO]</cbc:AllowanceChargeReason><cbc:MultiplierFactorNumeric>0.5</cbc:MultiplierFactorNumeric><cbc:Amount currencyID="TRY">100</cbc:Amount><cbc:BaseAmount currencyID="TRY">200</cbc:BaseAmount></cac:AllowanceCharge>` |

### 2.3.37 TaxExchangeRate

| TaxExchangeRate | Vergi Döviz Kuru |
|-----------------|--------------------|
| **Diyagram (alanları)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Doküman üzerinde gösterilen vergiler, "Belge Para Birimi" dışında başka bir para birimi ile gösterilmişse ilgili döviz kuru bu elemana yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: ExchangeRate |
| **Örnek** | `<cac:TaxExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:TaxExchangeRate>` |

### 2.3.38 PricingExchangeRate

| PricingExchangeRate | Fiyatlandırma Döviz Kuru |
|---------------------|----------------------------|
| **Diyagram (alanları)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Bu elemana fatura üzerinde yer alan mal veya hizmet bedellerinin "Belge Para Birimi" dışında başka bir para birimi ile gösterilmesi halinde ilgili döviz kuru yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: ExchangeRate |
| **Örnek** | `<cac:PricingExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:PricingExchangeRate>` |

### 2.3.39 PaymentExchangeRate

| PaymentExchangeRate | Ödeme Döviz Kuru |
|---------------------|--------------------|
| **Diyagram (alanları)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Ödemenin "Belge Para Birimi" dışında herhangi bir para birimi ile yapılması halinde ilgili para biriminin döviz kuru bilgileri bu elemana yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: ExchangeRate |
| **Örnek** | `<cac:PaymentExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:PaymentExchangeRate>` |

### 2.3.40 PaymentAlternativeExchangeRate

| PaymentAlternativeExchangeRate | Alternatif Ödeme Döviz Kuru |
|--------------------------------|--------------------------------|
| **Diyagram (alanları)** | cbc:SourceCurrencyCode, cbc:TargetCurrencyCode, cbc:CalculationRate, cbc:Date |
| **Kardinalite** | Seçimli (0..1) |
| **Açıklama** | Bu elemana belge para birimi ve ödeme para birimi haricinde faturanın ödenmesinde kullanılması istenen alternatif para birimi varsa bu paranın döviz kuru bilgisi yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: ExchangeRate |
| **Örnek** | `<cac:PaymentAlternativeExchangeRate><cbc:SourceCurrencyCode>USD</cbc:SourceCurrencyCode><cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode><cbc:CalculationRate>2.60</cbc:CalculationRate><cbc:Date>2015-03-18</cbc:Date></cac:PaymentAlternativeExchangeRate>` |

### 2.3.41 TaxTotal

| TaxTotal | Toplam Vergi |
|----------|---------------|
| **Diyagram (alanları)** | cbc:TaxAmount, cac:TaxSubtotal (1..n) |
| **Kardinalite** | Zorunlu (1..n) |
| **Açıklama** | Bu elemana faturada yer alan vergi ve diğer yasal yükümlülükler ile ilgili bilgiler yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: TaxTotal |
| **Örnek** | `<cac:TaxTotal><cbc:TaxAmount currencyID="TRY">6.33</cbc:TaxAmount>` ile başlayan ve iki TaxSubtotal içeren yapı: 1) TaxableAmount=19.17, TaxAmount=3.45, CalculationSequenceNumeric=1, Percent=18.0, TaxScheme/Name=Katma Değer Vergisi, TaxScheme/TaxTypeCode=0015; 2) TaxableAmount=19.17, TaxAmount=2.88, CalculationSequenceNumeric=2, TransactionCurrencyTaxAmount=0.0, Percent=15.0, TaxScheme/Name=Özel İletişim Vergisi, TaxScheme/TaxTypeCode=4080. |

### 2.3.42 WithholdingTaxTotal

| WithholdingTaxTotal | Tevkifat Bilgileri |
|---------------------|---------------------|
| **Diyagram (alanları)** | cbc:TaxAmount, cac:TaxSubtotal (1..n) |
| **Kardinalite** | Seçimli (0..n) |
| **Açıklama** | Bu elemana tevkifatlı faturalarda yer alan tevkifat ile ilgili bilgiler yazılacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: TaxTotal |
| **Örnek** | `<cac:WithholdingTaxTotal><cbc:TaxAmount currencyID="TRY">3240</cbc:TaxAmount><cac:TaxSubtotal><cbc:TaxAmount currencyID="TRY">3240</cbc:TaxAmount><cbc:Percent>90</cbc:Percent><cac:TaxCategory><cac:TaxScheme><cbc:TaxTypeCode>606</cbc:TaxTypeCode></cac:TaxScheme></cac:TaxCategory></cac:TaxSubtotal></cac:WithholdingTaxTotal>` |

### 2.3.43 LegalMonetaryTotal

| LegalMonetaryTotal | Parasal Toplamlar |
|--------------------|---------------------|
| **Diyagram (alanları)** | cbc:LineExtensionAmount, cbc:TaxExclusiveAmount, cbc:TaxInclusiveAmount, cbc:AllowanceTotalAmount, cbc:ChargeTotalAmount, cbc:PayableRoundingAmount, cbc:PayableAmount |
| **Kardinalite** | Zorunlu (1) |
| **Açıklama** | Bu elemanda faturadaki çeşitli tutarların toplamları yer alacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: LegalMonetaryTotal |
| **Örnek** | `<cac:LegalMonetaryTotal><cbc:LineExtensionAmount currencyID="TRY">90</cbc:LineExtensionAmount><cbc:TaxExclusiveAmount currencyID="TRY">80</cbc:TaxExclusiveAmount><cbc:TaxInclusiveAmount currencyID="TRY">94</cbc:TaxInclusiveAmount><cbc:AllowanceTotal currencyID="TRY">10</cbc:AllowanceTotal><cbc:PayableRoundingAmount currencyID="TRY">0.4</cbc:PayableRoundingAmount><cbc:PayableAmount currencyID="TRY">94.4</cbc:PayableAmount></cac:LegalMonetaryTotal>` |

### 2.3.44 InvoiceLine

| InvoiceLine | Mal/Hizmet Kalemleri |
|-------------|------------------------|
| **Diyagram (alanları)** | cbc:ID, cbc:Note (0..n), cbc:InvoicedQuantity, cbc:LineExtensionAmount, cac:OrderLineReference (0..n), cac:DespatchLineReference (0..n), cac:ReceiptLineReference (0..n), cac:Delivery (0..n), cac:AllowanceCharge (0..n), cac:TaxTotal, cac:WithholdingTaxTotal (0..n), cac:Item, cac:Price, cac:SubInvoiceLine (0..n) |
| **Kardinalite** | Zorunlu (1..n) |
| **Açıklama** | Bu elemanda faturada yer alan mal ve/veya hizmetlere ait bilgiler yer alacaktır. |
| **Kullanım** | Bknz. Ortak Sınıflar: InvoiceLine |
| **Örnek** | `<cac:InvoiceLine><cbc:ID>1</cbc:ID><cbc:InvoicedQuantity unitCode="BX">30</cbc:InvoicedQuantity><cbc:LineExtensionAmount currencyID="TRY">1800</cbc:LineExtensionAmount><cac:Item><cbc:Name>URUN ADI</cbc:Name><cac:SellersItemIdentification><cbc:ID>1234567</cbc:ID></cac:SellersItemIdentification></cac:Item><cac:Price><cbc:PriceAmount currencyID="TRY">60</cbc:PriceAmount></cac:Price></cac:InvoiceLine>` |
