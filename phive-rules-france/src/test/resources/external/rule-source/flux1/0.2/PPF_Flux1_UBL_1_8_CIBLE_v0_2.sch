<?xml version='1.0' encoding='UTF-8'?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>PPF — Flux 1 UBL e-invoicing &amp; e-reporting — Profil de Base (Trajectoire DÉMARRAGE) - Extension FULL/CIBLE</title>
  <ns prefix="ubl-invoice" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="ubl-creditnote" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>

  <pattern id="F1-START-FACTURE-ID-G1.05">
    <rule context="/ubl-invoice:Invoice/cbc:ID | /ubl-creditnote:CreditNote/cbc:ID">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 35" flag="fatal">[G1.05] L'identifiant de facture ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal">[G1.05] L'identifiant de facture ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(contains($v, '  '))" flag="fatal">[G1.05] L'identifiant de facture ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal">[G1.05] L'identifiant de facture contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-FACTURE-TYPE-G1.01">
    <rule context="/ubl-invoice:Invoice/cbc:InvoiceTypeCode | /ubl-creditnote:CreditNote/cbc:CreditNoteTypeCode">
      <assert test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')" flag="fatal">[G1.01] Le type de document / facture '<value-of select="."/>' n'est pas autorisé au démarrage de la réforme. | Source : Annexe 7 v1.8 G1.01</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-FACTURE-DATE-G1.09">
    <rule context="/ubl-invoice:Invoice/cbc:IssueDate | /ubl-creditnote:CreditNote/cbc:IssueDate">
      <let name="annee" value="number(substring(., 1, 4))"/>
      <assert test="matches(., '^\d{4}-\d{2}-\d{2}$')" flag="fatal">[G1.09] La date d'émission de la facture (<value-of select="."/>) doit respecter le format standard UBL (AAAA-MM-JJ). | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{4}-\d{2}-\d{2}$')) or ($annee &gt;= 2000 and $annee &lt;= 2099)" flag="fatal">[G1.36] L'année de facturation (<value-of select="xs:string($annee)"/>) doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-VENDEUR-ID-G2.19">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
      <let name="scheme" value="string(@schemeID)"/>
      <assert test="$scheme = ('0002','0223','0227','0228','0229')" flag="fatal">[G2.19] Le type d'identifiant (schemeID='<value-of select="$scheme"/>') du vendeur n'est pas valide. | Source : Annexe 7 v1.8 G2.19</assert>
      <assert test="not($scheme = '0002') or matches(., '^\d{9}$')" flag="fatal">[G2.19] L'identifiant de type 0002 (SIREN) du vendeur doit comporter exactement 9 chiffres numériques. | Source : Annexe 7 v1.8 G2.19</assert>
      <assert test="not($scheme = '0223') or string-length(.) &lt;= 18" flag="fatal">[G2.19] L'identifiant de type 0223 du vendeur ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-VENDEUR-TVA-G2.33">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingSupplierParty/cac:Party">
      <assert test="not(cac:PartyLegalEntity/cbc:CompanyID/@schemeID = ('0002','0223')) or string(cac:PartyTaxScheme/cbc:CompanyID)" flag="fatal">[G2.33] L'identifiant TVA du vendeur est obligatoire au démarrage si l'identifiant légal est un SIREN ou UE_HORS_FRANCE. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-VENDEUR-PAYS-G2.01">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
      <assert test="matches(., '^[A-Z]{2}$') and not(. = 'EL')" flag="fatal">[G2.01] Le code pays du vendeur (<value-of select="."/>) doit comporter 2 lettres majuscules ISO 3166-1 alpha-2 ('GR' requis pour la Grèce). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-ACHETEUR-ID-G2.19">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
      <let name="scheme" value="string(@schemeID)"/>
      <assert test="$scheme = ('0002','0223','0227','0228','0229')" flag="fatal">[G2.19] Le type d'identifiant (schemeID='<value-of select="$scheme"/>') de l'acheteur n'est pas autorisé. | Source : Annexe 7 v1.8 G2.19</assert>
      <assert test="not($scheme = '0002') or matches(., '^\d{9}$')" flag="fatal">[G2.19] L'identifiant de type 0002 (SIREN) de l'acheteur doit comporter exactement 9 chiffres numériques. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-ACHETEUR-TVA-G2.33">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingCustomerParty/cac:Party">
      <assert test="not(cac:PartyLegalEntity/cbc:CompanyID/@schemeID = ('0002','0223')) or string(cac:PartyTaxScheme/cbc:CompanyID)" flag="fatal">[G2.33] L'identifiant TVA de l'acheteur est obligatoire au démarrage si son identifiant de structure est un SIREN ou UE_HORS_FRANCE. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-ACHETEUR-PAYS-G2.01">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
      <assert test="matches(., '^[A-Z]{2}$') and not(. = 'EL')" flag="fatal">[G2.01] Le code pays de l'acheteur (<value-of select="."/>) doit comporter 2 lettres majuscules ISO 3166-1 alpha-2 ('GR' requis pour la Grèce). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-TAXE-TYPE-G1.103">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID">
      <assert test=". = 'VAT'" flag="fatal">[G1.103] Le type de taxe doit obligatoirement être égal à 'VAT' (TVA) sur les flux de facturation. | Source : Annexe 7 v1.8 G1.103</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-PAIEMENT-CONDITIONS-P1.11">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:InvoicePeriod/cbc:DescriptionCode">
      <assert test=". = ('5','29','72','3','35','432')" flag="fatal">[P1.11] Le code de date d'exigibilite de la TVA (BT-8) doit appartenir aux nomenclatures UNTDID 2475 ou 2005. | Source : Annexe 7 v1.8 P1.11</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-PAIEMENT-MOYEN-BT81">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:PaymentMeans/cbc:PaymentMeansCode">
      <assert test=". = ('10', '20', '30', '42', '48', '49', '97')" flag="fatal">[BT-81] Le code du moyen de paiement saisi ('<value-of select="."/>') n'est pas conforme à la nomenclature restreinte du démarrage. | Source : Codelist ISO/UNECE</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-LOGISTIQUE-TRANSPORT-BT80">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:Delivery/cac:Shipment/cac:ShipmentStage/cac:TransportMeans/cbc:TransportModeCode">
      <assert test=". = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')" flag="fatal">[BT-80] Le code du mode de transport ('<value-of select="."/>') doit faire partie de la nomenclature de la Recommandation 19 de l'UNECE. | Source : UNECE Rec 19</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-TVA-CATEGORIE-G2.31">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID">
      <assert test=". = ('S','E','AE','K','G','O','Z')" flag="fatal">[G2.31] Le code de catégorie TVA saisi ('<value-of select="."/>') doit appartenir à la nomenclature autorisée UNTDID 5305. | Source : Annexe 7 v1.8 G2.31</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-TVA-TAUX-G1.24">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" flag="fatal">[G1.24] Le taux de TVA appliqué (<value-of select="."/>%) n'est pas présent dans la liste des taux légaux français autorisés. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-TOTAL-FORMATS-G1.14">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:LegalMonetaryTotal/*[ends-with(local-name(), 'Amount')]">
      <assert test="matches(string(.), '^-?\d+(\.\d{1,2})?$')" flag="fatal">[G1.14] <value-of select="local-name()"/> : Le montant saisi ('<value-of select="."/>') comporte trop de décimales (2 maximum autorisées avec séparateur point). | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(string(.), '.', '')) &lt;= 19" flag="fatal">[G1.14] <value-of select="local-name()"/> : La longueur totale dépasse la limite des 19 chiffres significatifs. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-TOTAL-COHERENCE-G1.53">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <let name="totalHT" value="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>
      <let name="sommeBasesHT" value="cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount"/>
      <let name="totalTVA" value="cac:TaxTotal/cbc:TaxAmount"/>
      <let name="sommeTVA" value="cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount"/>
      <assert test="not($totalHT) or not($sommeBasesHT) or (abs(number($totalHT) - sum($sommeBasesHT)) &lt;= 0.01)" flag="fatal">[G1.53] Écart sur le Total Hors Taxe global (<value-of select="$totalHT"/>) vis-à-vis de la somme des bases ventilées (<value-of select="sum($sommeBasesHT)"/>). Tolérance de 0,01 EUR. | Source : Annexe 7 v1.8 G1.53</assert>
      <assert test="not($totalTVA) or not($sommeTVA) or (abs(number($totalTVA) - sum($sommeTVA)) &lt;= 0.01)" flag="fatal">[G1.53] Écart sur le Montant Total de TVA global (<value-of select="$totalTVA"/>) vis-à-vis de la somme des lignes de TVA calculées (<value-of select="sum($sommeTVA)"/>). Tolérance de 0,01 EUR. | Source : Annexe 7 v1.8 G1.53</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-LIGNE-PRIX-G1.55">
    <rule context="(/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:Price">
      <let name="prixNet" value="number(cbc:PriceAmount)"/>
      <let name="nodePrixBrut" value="cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:BaseAmount"/>
      <let name="prixBrut" value="if ($nodePrixBrut) then number($nodePrixBrut) else $prixNet"/>
      <let name="nodeRabais" value="cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount"/>
      <let name="rabais" value="if (string($nodeRabais)) then number($nodeRabais) else 0"/>
      <assert test="not($nodePrixBrut) or (abs($prixNet - ($prixBrut - $rabais)) &lt;= 0.01)" flag="fatal">[G1.55] Incohérence sur la ligne d'article : le prix net unitaire calculé (<value-of select="string($prixNet)"/>) doit correspondre au prix brut unitaire (<value-of select="string($prixBrut)"/>) moins les remises et rabais (<value-of select="string($rabais)"/>). | Source : Annexe 7 v1.8 G1.55</assert>
    </rule>
  </pattern>

  <pattern id="F1-START-LIGNE-QUANTITE-G1.15">
    <rule context="(/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cbc:InvoicedQuantity | (/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cbc:CreditedQuantity">
      <assert test="matches(string(.), '^-?\d+(\.\d{1,4})?$')" flag="fatal">[G1.15] La quantité facturée sur la ligne (<value-of select="."/>) possède un nombre de décimales invalide (maximum 4 décimales avec séparateur point). | Source : Annexe 7 v1.8 G1.15</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G6.08-OBLIGATOIRES">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="cbc:ID" flag="fatal">[G6.08] BT-1 Numero de facture obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cbc:IssueDate" flag="fatal">[G6.08] BT-2 Date d'emission obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="(self::ubl-invoice:Invoice and cbc:InvoiceTypeCode) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode)" flag="fatal">[G6.08] BT-3 Code de type de facture obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cbc:DocumentCurrencyCode" flag="fatal">[G6.08] BT-5 Devise de facture obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cbc:ProfileID" flag="fatal">[G6.08] BT-23 Cadre de facturation obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cbc:CustomizationID" flag="fatal">[G6.08] BT-24 Profil obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" flag="fatal">[G6.08] BT-30 SIREN vendeur obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID" flag="fatal">[G6.08] BT-30-1 Qualifiant SIREN vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" flag="fatal">[G6.08] BT-40 Code pays vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" flag="fatal">[G6.08] BT-47 SIREN acheteur obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID" flag="fatal">[G6.08] BT-47-1 Qualifiant SIREN acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" flag="fatal">[G6.08] BT-55 Code pays acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:LegalMonetaryTotal" flag="fatal">[G6.08] BG-22 Totaux du document obligatoires. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" flag="fatal">[G6.08] BT-109 Total hors TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:TaxTotal/cbc:TaxAmount" flag="fatal">[G6.08] BT-110 Montant total TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:TaxTotal/cbc:TaxAmount/@currencyID" flag="fatal">[G6.08] BT-110-1 Devise du montant total TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:TaxTotal/cac:TaxSubtotal" flag="fatal">[G6.08] BG-23 Ventilation TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-BG23-G6.08">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:TaxTotal/cac:TaxSubtotal">
      <assert test="cbc:TaxableAmount" flag="fatal">[G6.08] BT-116 Base d'imposition du type TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cbc:TaxAmount" flag="fatal">[G6.08] BT-117 Montant TVA par type obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:TaxCategory/cbc:ID" flag="fatal">[G6.08] BT-118 Code type TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'" flag="fatal">[S1.17] BT-118-0 Qualifiant du code type TVA obligatoire et egal a VAT. | Source : Annexe 7 v1.8 S1.17</assert>
      <assert test="cac:TaxCategory/cbc:Percent" flag="fatal">[G6.08] BT-119 Taux TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.02-G1.60">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="cbc:ProfileID = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')" flag="fatal">[G1.02] Le cadre de facturation BT-23 doit appartenir a la liste autorisee. | Source : Annexe 7 v1.8 G1.02</assert>
      <assert test="not(cbc:ProfileID = ('B4','S4','M4') and ((self::ubl-invoice:Invoice and cbc:InvoiceTypeCode = ('386','500','503')) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode = ('386','500','503'))))" flag="fatal">[G1.60] Le type de facture est incompatible avec le cadre de facturation B4/S4/M4. | Source : Annexe 7 v1.8 G1.60</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.10-G1.12-DEVISES">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="matches(cbc:DocumentCurrencyCode, '^[A-Z]{3}$')" flag="fatal">[G1.10] BT-5 doit respecter le format ISO 4217. | Source : Annexe 7 v1.8 G1.10</assert>
      <assert test="not(cbc:DocumentCurrencyCode != 'EUR') or cac:TaxTotal/cbc:TaxAmount[@currencyID='EUR']" flag="fatal">[G1.12] Si BT-5 est different de EUR, BT-111 doit etre renseigne en EUR. | Source : Annexe 7 v1.8 G1.12</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.09-DATES">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cbc:DueDate | (/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cbc:PaymentDueDate | (/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cbc:ActualDeliveryDate | (/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cac:InvoicePeriod/cbc:StartDate | (/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cac:InvoicePeriod/cbc:EndDate">
      <assert test="matches(., '^\d{4}-\d{2}-\d{2}$')" flag="fatal">[G1.09] La date doit respecter le format UBL AAAA-MM-JJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{4}-\d{2}-\d{2}$')) or (number(substring(.,1,4)) &gt;= 2000 and number(substring(.,1,4)) &lt;= 2099)" flag="fatal">[G1.36] L'annee de la date doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G6.25-PERIODES">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cac:InvoicePeriod[cbc:StartDate and cbc:EndDate]">
      <assert test="cbc:EndDate &gt; cbc:StartDate" flag="fatal">[G6.25] La date de fin de periode ne peut pas etre anterieure ou egale a la date de debut. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.31-REFERENCES">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="not((self::ubl-invoice:Invoice and cbc:InvoiceTypeCode = ('384','471','472','473')) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode = ('384','471','472','473'))) or count(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) = 1 or (count(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) = 0 and exists((cac:InvoiceLine | cac:CreditNoteLine)) and (every $l in (cac:InvoiceLine | cac:CreditNoteLine) satisfies ($l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and $l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate)))" flag="fatal">[G1.31] Une facture rectificative doit comporter un unique numero de facture anterieure BT-25 en entete, ou le numero BT-25 et la date BT-26 sur toutes les lignes en profil FULL/CIBLE. | Source : Annexe 7 v1.8 G1.31</assert>
      <assert test="not((self::ubl-invoice:Invoice and cbc:InvoiceTypeCode = ('261','381','396','502','503')) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode = ('261','381','396','502','503'))) or cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID or (count(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) = 0 and exists((cac:InvoiceLine | cac:CreditNoteLine)) and (every $l in (cac:InvoiceLine | cac:CreditNoteLine) satisfies ($l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and $l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate)))" flag="fatal">[G1.31] Un avoir doit comporter au moins un numero de facture anterieure BT-25 en entete, ou le numero BT-25 et la date BT-26 sur toutes les lignes en profil FULL/CIBLE. | Source : Annexe 7 v1.8 G1.31</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.05-REF-ID">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
      <assert test="string-length(.) &lt;= 35" flag="fatal">[G1.05] BT-25 ne peut pas depasser 35 caracteres. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with(., ' ') or ends-with(., ' ') or contains(., '  '))" flag="fatal">[G1.05] BT-25 ne peut pas commencer/terminer par un espace ni contenir deux espaces consecutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches(., '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal">[G1.05] BT-25 contient des caracteres non autorises. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.14-MONTANTS">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cbc:*[local-name() = ('Amount','BaseAmount','TaxAmount','TaxableAmount','TransactionCurrencyTaxAmount','LineExtensionAmount','TaxExclusiveAmount','TaxInclusiveAmount','AllowanceTotalAmount','ChargeTotalAmount','PrepaidAmount','PayableRoundingAmount','PayableAmount')][not(ancestor::cac:Price)]">
      <assert test="matches(string(.), '^-?\d+(\.\d{1,2})?$')" flag="fatal">[G1.14] Le montant doit comporter au maximum 2 decimales avec un point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(string(.), '.', '')) &lt;= 19" flag="fatal">[G1.14] Le montant ne peut pas depasser 19 chiffres hors separateur et signe. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.16-PRIX">
    <rule context="(/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:Price//cbc:*[local-name() = ('PriceAmount','BaseAmount','Amount')]">
      <assert test="matches(string(.), '^\d+(\.\d{1,6})?$')" flag="fatal">[G1.16] Le prix doit comporter au maximum 6 decimales, sans signe negatif. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(string(.), '.', '')) &lt;= 19" flag="fatal">[G1.16] Le prix ne peut pas depasser 19 chiffres hors separateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G2.19-G1.63-SIREN">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID | (/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
      <assert test="@schemeID = '0002'" flag="fatal">[G1.63] Le vendeur et l'acheteur doivent etre identifies par un SIREN qualifie 0002 en Flux 1 DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G1.63</assert>
      <assert test="matches(., '^\d{9}$')" flag="fatal">[G1.63] Le SIREN vendeur/acheteur doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G1.63</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-S1.14-ASSUJETTI-UNIQUE">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
      <assert test="@schemeID = '0231'" flag="fatal">[S1.14] L'identifiant d'assujetti unique BT-29d doit utiliser le qualifiant 0231. | Source : Annexe 7 v1.8 S1.14</assert>
      <assert test="matches(., '^\d{9}$')" flag="fatal">[G1.101] Le SIREN de l'assujetti unique doit comporter 9 chiffres. | Source : Annexe 7 v1.8 G1.101</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-S1.17-QUALIFIANTS-TVA">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cac:PartyTaxScheme/cac:TaxScheme/cbc:ID | (/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)//cac:TaxCategory/cac:TaxScheme/cbc:ID">
      <assert test=". = 'VAT'" flag="fatal">[S1.17] Le qualifiant d'identifiant TVA doit etre VAT en UBL. | Source : Annexe 7 v1.8 S1.17</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.41-G1.47-G2.32-G6.21">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID = 'E') or (cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']/cac:TaxCategory/cbc:TaxExemptionReasonCode and cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']/cac:TaxCategory/cbc:TaxExemptionReason)" flag="fatal">[G1.41] Une ventilation TVA de type E doit comprendre un code et un motif d'exoneration. | Source : Annexe 7 v1.8 G1.41</assert>
      <assert test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID = 'E') or cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID or cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">[G1.47] Si une ventilation TVA est exoneree (E), l'identifiant TVA vendeur ou representant fiscal est obligatoire. | Source : Annexe 7 v1.8 G1.47</assert>
      <assert test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = 'VATEX-FR-CNWVAT') or ((self::ubl-invoice:Invoice and cbc:InvoiceTypeCode = ('261','381','396')) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode = ('261','381','396')))" flag="fatal">[G6.21] Le code VATEX-FR-CNWVAT est reserve aux avoirs 261, 381 ou 396. | Source : Annexe 7 v1.8 G6.21</assert>
      <assert test="not(every $c in cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID satisfies ($c = ('O','E')) and exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode[. = ('VATEX-FR-CGI261-1','VATEX-FR-CGI261-2','VATEX-FR-CGI261-3','VATEX-FR-CGI261-4','VATEX-FR-CGI261-5','VATEX-FR-CGI261-7','VATEX-FR-CGI261-8','VATEX-FR-CGI261A','VATEX-FR-CGI261B','VATEX-FR-CGI261C-1','VATEX-FR-CGI261C-2','VATEX-FR-CGI261C-3','VATEX-FR-CGI261D-1','VATEX-FR-CGI261D-1BIS','VATEX-FR-CGI261D-2','VATEX-FR-CGI261D-3','VATEX-FR-CGI261D-4','VATEX-FR-CGI261E-1','VATEX-FR-CGI261E-2')]))" flag="fatal">[G2.32] Rejet si la facture comporte uniquement des codes TVA O/E avec un code d'exoneration hors champs liste. | Source : Annexe 7 v1.8 G2.32</assert>
    </rule>
  </pattern>

  <pattern id="F1-COMPLETE-UBL-G1.24-G2.31">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory">
      <assert test="cbc:ID = ('S','E','AE','K','G','O','Z')" flag="fatal">[G2.31] Le code de categorie TVA doit appartenir a la liste autorisee. | Source : Annexe 7 v1.8 G2.31</assert>
      <assert test="number(cbc:Percent) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" flag="fatal">[G1.24] Le taux de TVA doit appartenir a la liste des taux autorises. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F1-FULL-UBL-G6.09-LIGNES-OBLIGATOIRES">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="(self::ubl-invoice:Invoice and cac:InvoiceLine) or (self::ubl-creditnote:CreditNote and cac:CreditNoteLine)" flag="fatal">[G6.09] BG-25 Ligne de facture obligatoire en profil FULL/CIBLE. Extension du profil BASE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
    </rule>
  </pattern>

  <pattern id="F1-FULL-UBL-G6.09-CONTENU-LIGNE">
    <rule context="/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine">
      <assert test="(self::cac:InvoiceLine and cbc:InvoicedQuantity) or (self::cac:CreditNoteLine and cbc:CreditedQuantity)" flag="fatal">[G6.09] BT-129 Quantite facturee/creditee obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
      <assert test="cbc:InvoicedQuantity/@unitCode or cbc:CreditedQuantity/@unitCode" flag="fatal">[G6.09] BT-130 Unite de quantite obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
      <assert test="cac:Price" flag="fatal">[G6.09] BG-29 Detail du prix obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
      <assert test="cac:Price/cbc:PriceAmount" flag="fatal">[G6.09] BT-146 Prix net unitaire obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
      <assert test="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:BaseAmount" flag="fatal">[G6.09] BT-148 Prix brut unitaire obligatoire lorsque le detail prix est renseigne en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
      <assert test="cac:Item" flag="fatal">[G6.09] BG-31 Article obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
      <assert test="cac:Item/cbc:Name" flag="fatal">[G6.09] BT-153 Nom de l'article obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</assert>
    </rule>
  </pattern>

  <pattern id="F1-CIBLE-UBL-G1.31-REFERENCES-ANTERIEURES">
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and (cac:InvoiceLine | cac:CreditNoteLine)/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID)" flag="fatal">[G1.31] Les references a factures anterieures ne doivent pas etre renseignees simultanement en entete et en ligne en profil FULL/CIBLE. | Source : Annexe 7 v1.8 G1.31</assert>
      <assert test="not((self::ubl-invoice:Invoice and cbc:InvoiceTypeCode = ('261','381','384','396','471','472','473','502','503')) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode = ('261','381','384','396','471','472','473','502','503'))) or (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate) or (self::ubl-invoice:Invoice and (every $l in cac:InvoiceLine satisfies ($l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and $l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate))) or (self::ubl-creditnote:CreditNote and (every $l in cac:CreditNoteLine satisfies ($l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and $l/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate)))" flag="fatal">[G1.31] Pour un avoir ou une facture rectificative en FULL/CIBLE, la reference anterieure doit porter le numero et la date, soit en entete soit sur toutes les lignes. | Source : Annexe 7 v1.8 G1.31</assert>
      <assert test="not((self::ubl-invoice:Invoice and cbc:InvoiceTypeCode = ('384','471','472','473')) or (self::ubl-creditnote:CreditNote and cbc:CreditNoteTypeCode = ('384','471','472','473'))) or count(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) &lt;= 1" flag="fatal">[G1.31] Une facture rectificative doit pointer au plus une facture anterieure en entete. | Source : Annexe 7 v1.8 G1.31</assert>
    </rule>
  </pattern>

  <pattern id="F1-CIBLE-UBL-BT26-DATE-FACTURE-ANTERIEURE">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate | (/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate">
      <assert test="matches(., '^\d{4}-\d{2}-\d{2}$')" flag="fatal">[G1.09] BT-26 Date de facture anterieure au format UBL AAAA-MM-JJ. | Source : Annexe 1 Flux 1 / Annexe 7 G1.09</assert>
      <assert test="not(matches(., '^\d{4}-\d{2}-\d{2}$')) or (number(substring(., 1, 4)) &gt;= 2000 and number(substring(., 1, 4)) &lt;= 2099)" flag="fatal">[G1.36] BT-26 L'annee de la facture anterieure doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F1-CIBLE-UBL-G6.16-ADRESSE-LIVRAISON">
    <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:Delivery/cac:DeliveryLocation/cac:Address | (/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:Delivery/cac:DeliveryLocation/cac:Address">
      <assert test="cbc:StreetName" flag="fatal">[G6.16] BT-75 Ligne d'adresse de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</assert>
      <assert test="cbc:CityName" flag="fatal">[G6.16] BT-77 Ville de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</assert>
      <assert test="cbc:PostalZone" flag="fatal">[G6.16] BT-78 Code postal de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</assert>
      <assert test="cac:Country/cbc:IdentificationCode" flag="fatal">[G6.16] BT-80 Code pays de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</assert>
      <assert test="not(cac:Country/cbc:IdentificationCode) or (matches(cac:Country/cbc:IdentificationCode, '^[A-Z]{2}$') and not(cac:Country/cbc:IdentificationCode = 'EL'))" flag="fatal">[G2.01] Le code pays de livraison doit etre au format ISO 3166-1 alpha-2, avec GR pour la Grece. | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F1-CIBLE-UBL-DATES-LIGNE">
    <rule context="(/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:Delivery/cbc:ActualDeliveryDate | (/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:InvoicePeriod/cbc:StartDate | (/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:InvoicePeriod/cbc:EndDate">
      <assert test="matches(., '^\d{4}-\d{2}-\d{2}$')" flag="fatal">[G1.09] Les dates de ligne FULL/CIBLE doivent respecter le format UBL AAAA-MM-JJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{4}-\d{2}-\d{2}$')) or (number(substring(., 1, 4)) &gt;= 2000 and number(substring(., 1, 4)) &lt;= 2099)" flag="fatal">[G1.36] L'annee des dates de ligne FULL/CIBLE doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F1-CIBLE-UBL-G6.25-PERIODES-LIGNE">
    <rule context="(/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:InvoicePeriod[cbc:StartDate and cbc:EndDate]">
      <assert test="cbc:EndDate &gt; cbc:StartDate" flag="fatal">[G6.25] En ligne, la date de fin de periode ne peut pas etre anterieure ou egale a la date de debut. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>

	<pattern id="F1-FULL-UBL-ALLOWANCE-CHARGE-DOCUMENT">
  <rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)/cac:AllowanceCharge">

    <assert test="cbc:Amount" flag="fatal">
      [G6.09] BT-92/BT-99 Montant de remise ou charge document obligatoire lorsque BG-20/BG-21 est renseigné.
      | Source : Annexe 1 Flux 1
    </assert>

    <assert test="cac:TaxCategory/cbc:ID" flag="fatal">
      [G6.09] Code de catégorie TVA obligatoire sur remise/charge document.
      | Source : Annexe 1 Flux 1
    </assert>

    <assert
      test="cbc:ChargeIndicator = ('true', '1')
            or normalize-space(cac:TaxCategory/cbc:Percent) != ''"
      flag="fatal">
      [G6.10] Le taux de TVA est obligatoire pour une remise au niveau du document.
      | Source : Annexe 7 v1.8 G6.10
    </assert>

    <assert test="cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'" flag="fatal">
      [S1.17] Le qualifiant TVA des remises/charges document doit être VAT.
      | Source : Annexe 7 v1.8 S1.17
    </assert>

    <assert
      test="not(cac:TaxCategory/cbc:ID)
            or cac:TaxCategory/cbc:ID = ('S','E','AE','K','G','O','Z')"
      flag="fatal">
      [G2.31] Le code de catégorie TVA des remises/charges document doit appartenir à la liste autorisée.
      | Source : Annexe 7 v1.8 G2.31
    </assert>

    <assert
      test="not(cac:TaxCategory/cbc:Percent)
            or number(cac:TaxCategory/cbc:Percent) =
               (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)"
      flag="fatal">
      [G1.24] Le taux de TVA des remises/charges document doit appartenir à la liste autorisée.
      | Source : Annexe 7 v1.8 G1.24
    </assert>

  </rule>
</pattern>

  <pattern id="F1-FULL-UBL-ALLOWANCE-CHARGE-LIGNE">
    <rule context="(/ubl-invoice:Invoice/cac:InvoiceLine | /ubl-creditnote:CreditNote/cac:CreditNoteLine)/cac:AllowanceCharge">
      <assert test="cbc:Amount" flag="fatal">[G6.09] Montant de remise/charge de ligne obligatoire lorsque BG-27/BG-28 est renseigne. | Source : Annexe 1 Flux 1</assert>
    </rule>
  </pattern>
</schema>