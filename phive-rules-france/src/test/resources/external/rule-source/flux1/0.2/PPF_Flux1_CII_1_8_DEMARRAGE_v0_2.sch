<?xml version='1.0' encoding='UTF-8'?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>PPF — Flux 1 CII e-invoicing &amp; e-reporting — Profil de Base (Trajectoire DÉMARRAGE)</title>
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"/>
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>
  <pattern id="F1-START-FACTURE-ID-G1.05">
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 35" flag="fatal">[G1.05] L'identifiant de facture ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal">[G1.05] L'identifiant de facture ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(contains($v, '  '))" flag="fatal">[G1.05] L'identifiant de facture ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal">[G1.05] L'identifiant de facture contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-FACTURE-TYPE-G1.01">
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <assert test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')" flag="fatal">[G1.01] Le type de document / facture '<value-of select="."/>' n'est pas autorisé au démarrage de la réforme. | Source : Annexe 7 v1.8 G1.01</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-FACTURE-DATE-G1.09">
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">
      <let name="annee" value="number(substring(., 1, 4))"/>
      <assert test="matches(., '^\d{8}$')" flag="fatal">[G1.09] La date d'émission de la facture (<value-of select="."/>) doit respecter le format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or ($annee &gt;= 2000 and$annee &lt;= 2099)" flag="fatal">[G1.36] L'année de facturation (<value-of select="xs:string($annee)"/>) doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-VENDEUR-ID-G2.19">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="scheme" value="string(@schemeID)"/>
      <assert test="$scheme = ('0002','0223','0227','0228','0229')" flag="fatal">[G2.19] Le type d'identifiant (schemeID='<value-of select="$scheme"/>') du vendeur n'est pas valide. | Source : Annexe 7 v1.8 G2.19</assert>
      <assert test="not($scheme = '0002') or matches(., '^\d{9}$')" flag="fatal">[G2.19] L'identifiant de type 0002 (SIREN) du vendeur doit comporter exactement 9 chiffres numériques. | Source : Annexe 7 v1.8 G2.19</assert>
      <assert test="not($scheme = '0223') or string-length(.) &lt;= 18" flag="fatal">[G2.19] L'identifiant de type 0223 du vendeur ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-VENDEUR-TVA-G2.33">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert test="not(ram:SpecifiedLegalOrganization/ram:ID/@schemeID = ('0002','0223')) or string(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])" flag="fatal">[G2.33] L'identifiant TVA du vendeur est obligatoire au démarrage si l'identifiant légal est un SIREN ou UE_HORS_FRANCE. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-VENDEUR-PAYS-G2.01">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <assert test="matches(., '^[A-Z]{2}$') and not(. = 'EL')" flag="fatal">[G2.01] Le code pays du vendeur (<value-of select="."/>) doit comporter 2 lettres majuscules ISO 3166-1 alpha-2 ('GR' requis pour la Grèce). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-ACHETEUR-ID-G2.19">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="scheme" value="string(@schemeID)"/>
      <assert test="$scheme = ('0002','0223','0227','0228','0229')" flag="fatal">[G2.19] Le type d'identifiant (schemeID='<value-of select="$scheme"/>') de l'acheteur n'est pas autorisé. | Source : Annexe 7 v1.8 G2.19</assert>
      <assert test="not($scheme = '0002') or matches(., '^\d{9}$')" flag="fatal">[G2.19] L'identifiant de type 0002 (SIREN) de l'acheteur doit comporter exactement 9 chiffres numériques. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-ACHETEUR-TVA-G2.33">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert test="not(ram:SpecifiedLegalOrganization/ram:ID/@schemeID = ('0002','0223')) or string(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])" flag="fatal">[G2.33] L'identifiant TVA de l'acheteur est obligatoire au démarrage si son identifiant de structure est un SIREN ou UE_HORS_FRANCE. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-ACHETEUR-PAYS-G2.01">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <assert test="matches(., '^[A-Z]{2}$') and not(. = 'EL')" flag="fatal">[G2.01] Le code pays de l'acheteur (<value-of select="."/>) doit comporter 2 lettres majuscules ISO 3166-1 alpha-2 ('GR' requis pour la Grèce). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-TAXE-TYPE-G1.103">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <assert test=". = 'VAT'" flag="fatal">[G1.103] Le type de taxe doit obligatoirement être égal à 'VAT' (TVA) sur les flux de facturation. | Source : Annexe 7 v1.8 G1.103</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-PAIEMENT-CONDITIONS-P1.11">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <assert test=". = ('5','29','72','3','35','432')" flag="fatal">[P1.11] Le code de date d'exigibilite de la TVA (BT-8) doit appartenir aux nomenclatures UNTDID 2475 ou 2005. | Source : Annexe 7 v1.8 P1.11</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-PAIEMENT-MOYEN-BT81">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode">
      <assert test=". = ('10', '20', '30', '42', '48', '49', '97')" flag="fatal">[BT-81] Le code du moyen de paiement saisi ('<value-of select="."/>') n'est pas conforme à la nomenclature restreinte du démarrage. | Source : Codelist ISO/UNECE</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-LOGISTIQUE-TRANSPORT-BT80">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:SpecifiedBorderTransportMeans/ram:ModeCode">
      <assert test=". = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')" flag="fatal">[BT-80] Le code du mode de transport ('<value-of select="."/>') doit faire partie de la nomenclature de la Recommandation 19 de l'UNECE. | Source : UNECE Rec 19</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-TVA-CATEGORIE-G2.31">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <assert test=". = ('S','E','AE','K','G','O','Z')" flag="fatal">[G2.31] Le code de catégorie TVA saisi ('<value-of select="."/>') doit appartenir à la nomenclature autorisée UNTDID 5305. | Source : Annexe 7 v1.8 G2.31</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-TVA-TAUX-G1.24">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" flag="fatal">[G1.24] Le taux de TVA appliqué (<value-of select="."/>%) n'est pas présent dans la liste des taux légaux français autorisés. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-TOTAL-FORMATS-G1.14">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/*[ends-with(local-name(), 'Amount')]">
      <assert test="matches(string(.), '^-?\d+(\.\d{1,2})?$')" flag="fatal">[G1.14] <value-of select="local-name()"/> : Le montant saisi ('<value-of select="."/>') comporte trop de décimales (2 maximum autorisées avec séparateur point). | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(string(.), '.', '')) &lt;= 19" flag="fatal">[G1.14] <value-of select="local-name()"/> : La longueur totale dépasse la limite des 19 chiffres significatifs. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-TOTAL-COHERENCE-G1.53">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <let name="totalHT" value="ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxExclusiveAmount"/>
      <let name="sommeBasesHT" value="ram:ApplicableTradeTax/ram:BasisAmount"/>
      <let name="totalTVA" value="ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']"/>
      <let name="sommeTVA" value="ram:ApplicableTradeTax/ram:CalculatedAmount"/>
      <assert test="not($totalHT) or not($sommeBasesHT) or (abs(number($totalHT) - sum($sommeBasesHT)) &lt;= 0.01)" flag="fatal">[G1.53] Écart sur le Total Hors Taxe global (<value-of select="$totalHT"/>) vis-à-vis de la somme des bases ventilées (<value-of select="sum($sommeBasesHT)"/>). Tolérance de 0,01 EUR. | Source : Annexe 7 v1.8 G1.53</assert>
      <assert test="not($totalTVA) or not($sommeTVA) or (abs(number($totalTVA) - sum($sommeTVA)) &lt;= 0.01)" flag="fatal">[G1.53] Écart sur le Montant Total de TVA global (<value-of select="$totalTVA"/>) vis-à-vis de la somme des lignes de TVA calculées (<value-of select="sum($sommeTVA)"/>). Tolérance de 0,01 EUR. | Source : Annexe 7 v1.8 G1.53</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-LIGNE-PRIX-G1.55">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice">
      <let name="prixNet" value="number(ram:ChargeAmount)"/>
      <let name="nodePrixBrut" value="../ram:GrossPriceProductTradePrice/ram:ChargeAmount"/>
      <let name="prixBrut" value="if ($nodePrixBrut) then number($nodePrixBrut) else $prixNet"/>
      <let name="nodeRabais" value="../ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount"/>
      <let name="rabais" value="if (string($nodeRabais)) then number($nodeRabais) else 0"/>
      <assert test="not($nodePrixBrut) or (abs($prixNet - ($prixBrut - $rabais)) &lt;= 0.01)" flag="fatal">[G1.55] Incohérence sur la ligne d'article : le prix net unitaire calculé (<value-of select="$prixNet"/>) doit correspondre au prix brut unitaire (<value-of select="$prixBrut"/>) moins les remises et rabais (<value-of select="$rabais"/>). | Source : Annexe 7 v1.8 G1.55</assert>
    </rule>
  </pattern>
  <pattern id="F1-START-LIGNE-QUANTITE-G1.15">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
      <assert test="matches(string(.), '^-?\d+(\.\d{1,4})?$')" flag="fatal">[G1.15] La quantité facturée sur la ligne (<value-of select="."/>) possède un nombre de décimales invalide (maximum 4 décimales avec séparateur point). | Source : Annexe 7 v1.8 G1.15</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G6.08-OBLIGATOIRES">
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="rsm:ExchangedDocument/ram:ID" flag="fatal">[G6.08] BT-1 Numero de facture obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" flag="fatal">[G6.08] BT-2 Date d'emission obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:ExchangedDocument/ram:TypeCode" flag="fatal">[G6.08] BT-3 Type de facture obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode" flag="fatal">[G6.08] BT-5 Devise obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID" flag="fatal">[G6.08] BT-23 Cadre de facturation obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID" flag="fatal">[G6.08] BT-24 Profil obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" flag="fatal">[G6.08] BT-30 SIREN vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID" flag="fatal">[G6.08] BT-30-1 Qualifiant SIREN vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID" flag="fatal">[G6.08] BT-40 Pays vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" flag="fatal">[G6.08] BT-47 SIREN acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID" flag="fatal">[G6.08] BT-47-1 Qualifiant SIREN acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID" flag="fatal">[G6.08] BT-55 Pays acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation" flag="fatal">[G6.08] BG-22 Totaux document obligatoires. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount" flag="fatal">[G6.08] BT-109 Total hors TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" flag="fatal">[G6.08] BT-110 Montant total TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" flag="fatal">[G6.08] BG-23 Ventilation TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-BG23-G6.08">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="ram:BasisAmount" flag="fatal">[G6.08] BT-116 Base d'imposition du type TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="ram:CalculatedAmount" flag="fatal">[G6.08] BT-117 Montant TVA par type obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="ram:CategoryCode" flag="fatal">[G6.08] BT-118 Code type TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
      <assert test="ram:TypeCode = 'VAT'" flag="fatal">[S1.17] BT-118-0 Qualifiant du code type TVA obligatoire et egal a VAT. | Source : Annexe 7 v1.8 S1.17</assert>
      <assert test="ram:RateApplicablePercent" flag="fatal">[G6.08] BT-119 Taux TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.02-G1.60">
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')" flag="fatal">[G1.02] Le cadre de facturation BT-23 doit appartenir a la liste autorisee. | Source : Annexe 7 v1.8 G1.02</assert>
      <assert test="not(rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('B4','S4','M4') and rsm:ExchangedDocument/ram:TypeCode = ('386','500','503'))" flag="fatal">[G1.60] Le type de facture est incompatible avec le cadre B4/S4/M4. | Source : Annexe 7 v1.8 G1.60</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.10-G1.12-DEVISES">
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="matches(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode, '^[A-Z]{3}$')" flag="fatal">[G1.10] BT-5 doit respecter le format ISO 4217. | Source : Annexe 7 v1.8 G1.10</assert>
      <assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode != 'EUR') or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']" flag="fatal">[G1.12] Si BT-5 est different de EUR, BT-111 doit etre renseigne en EUR. | Source : Annexe 7 v1.8 G1.12</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.09-DATES">
    <rule context="/rsm:CrossIndustryInvoice//udt:DateTimeString">
      <assert test="matches(., '^\d{8}$')" flag="fatal">[G1.09] La date CII doit respecter le format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or (number(substring(.,1,4)) &gt;= 2000 and number(substring(.,1,4)) &lt;= 2099)" flag="fatal">[G1.36] L'annee de la date doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G6.25-PERIODES">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod[ram:StartDateTime/udt:DateTimeString and ram:EndDateTime/udt:DateTimeString]">
      <assert test="ram:EndDateTime/udt:DateTimeString &gt; ram:StartDateTime/udt:DateTimeString" flag="fatal">[G6.25] La date de fin de periode ne peut pas etre anterieure ou egale a la date de debut. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.31-REFERENCES">
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="not(rsm:ExchangedDocument/ram:TypeCode = ('384','471','472','473')) or count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 1" flag="fatal">[G1.31] Une facture rectificative doit comporter un unique numero de facture anterieure BT-25 en profil BASE. | Source : Annexe 7 v1.8 G1.31</assert>
      <assert test="not(rsm:ExchangedDocument/ram:TypeCode = ('261','381','396','502','503')) or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" flag="fatal">[G1.31] Un avoir doit comporter au moins un numero de facture anterieure BT-25 en profil BASE. | Source : Annexe 7 v1.8 G1.31</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.05-REF-ID">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <assert test="string-length(.) &lt;= 35" flag="fatal">[G1.05] BT-25 ne peut pas depasser 35 caracteres. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with(., ' ') or ends-with(., ' ') or contains(., '  '))" flag="fatal">[G1.05] BT-25 ne peut pas commencer/terminer par un espace ni contenir deux espaces consecutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches(., '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal">[G1.05] BT-25 contient des caracteres non autorises. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.14-MONTANTS">
    <rule context="/rsm:CrossIndustryInvoice//*[local-name() = ('ActualAmount','BasisAmount','CalculatedAmount','TaxBasisTotalAmount','TaxTotalAmount','LineTotalAmount','GrandTotalAmount','AllowanceTotalAmount','ChargeTotalAmount','TotalPrepaidAmount','DuePayableAmount')][not(ancestor::ram:GrossPriceProductTradePrice)][not(ancestor::ram:NetPriceProductTradePrice)]">
      <assert test="matches(string(.), '^-?\d+(\.\d{1,2})?$')" flag="fatal">[G1.14] Le montant doit comporter au maximum 2 decimales avec un point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(string(.), '.', '')) &lt;= 19" flag="fatal">[G1.14] Le montant ne peut pas depasser 19 chiffres hors separateur et signe. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.16-PRIX">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem//ram:SpecifiedLineTradeAgreement//*[ends-with(local-name(), 'Amount')]">
      <assert test="matches(string(.), '^\d+(\.\d{1,6})?$')" flag="fatal">[G1.16] Le prix doit comporter au maximum 6 decimales, sans signe negatif. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(string(.), '.', '')) &lt;= 19" flag="fatal">[G1.16] Le prix ne peut pas depasser 19 chiffres hors separateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.63-SIREN">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <assert test="@schemeID = '0002'" flag="fatal">[G1.63] Le vendeur et l'acheteur doivent etre identifies par un SIREN qualifie 0002 en Flux 1 DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G1.63</assert>
      <assert test="matches(., '^\d{9}$')" flag="fatal">[G1.63] Le SIREN vendeur/acheteur doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G1.63</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-S1.14-ASSUJETTI-UNIQUE">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID">
      <assert test="@schemeID = '0231'" flag="fatal">[S1.14] L'identifiant d'assujetti unique BT-29d doit utiliser le qualifiant 0231. | Source : Annexe 7 v1.8 S1.14</assert>
      <assert test="matches(., '^\d{9}$')" flag="fatal">[G1.101] Le SIREN de l'assujetti unique doit comporter 9 chiffres. | Source : Annexe 7 v1.8 G1.101</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-S1.17-QUALIFIANTS-TVA">
    <rule context="/rsm:CrossIndustryInvoice//ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID = 'VA'" flag="fatal">[S1.17] Le qualifiant d'identifiant TVA doit etre VA en CII pour BT-31/48/63. | Source : Annexe 7 v1.8 S1.17</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-S1.13-DUE-DATE-TYPE">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert test="count(distinct-values(ram:ApplicableTradeTax/ram:DueDateTypeCode)) &lt;= 1" flag="fatal">[S1.13] En CII, BT-8 doit avoir la meme valeur si BG-23 est repete. | Source : Annexe 7 v1.8 S1.13</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.41-G1.47-G2.32-G6.21">
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E') or (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']/ram:ExemptionReasonCode and rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']/ram:ExemptionReason)" flag="fatal">[G1.41] Une ventilation TVA de type E doit comprendre un code et un motif d'exoneration. | Source : Annexe 7 v1.8 G1.41</assert>
      <assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E') or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID" flag="fatal">[G1.47] Si une ventilation TVA est exoneree (E), l'identifiant TVA vendeur ou representant fiscal est obligatoire. | Source : Annexe 7 v1.8 G1.47</assert>
      <assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode = 'VATEX-FR-CNWVAT') or rsm:ExchangedDocument/ram:TypeCode = ('261','381','396')" flag="fatal">[G6.21] Le code VATEX-FR-CNWVAT est reserve aux avoirs 261, 381 ou 396. | Source : Annexe 7 v1.8 G6.21</assert>
      <assert test="not(every $c in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode satisfies ($c = ('O','E')) and exists(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[. = ('VATEX-FR-CGI261-1','VATEX-FR-CGI261-2','VATEX-FR-CGI261-3','VATEX-FR-CGI261-4','VATEX-FR-CGI261-5','VATEX-FR-CGI261-7','VATEX-FR-CGI261-8','VATEX-FR-CGI261A','VATEX-FR-CGI261B','VATEX-FR-CGI261C-1','VATEX-FR-CGI261C-2','VATEX-FR-CGI261C-3','VATEX-FR-CGI261D-1','VATEX-FR-CGI261D-1BIS','VATEX-FR-CGI261D-2','VATEX-FR-CGI261D-3','VATEX-FR-CGI261D-4','VATEX-FR-CGI261E-1','VATEX-FR-CGI261E-2')]))" flag="fatal">[G2.32] Rejet si la facture comporte uniquement des codes TVA O/E avec un code d'exoneration hors champs liste. | Source : Annexe 7 v1.8 G2.32</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.24-G2.31">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="ram:CategoryCode = ('S','E','AE','K','G','O','Z')" flag="fatal">[G2.31] Le code de categorie TVA doit appartenir a la liste autorisee. | Source : Annexe 7 v1.8 G2.31</assert>
      <assert test="number(ram:RateApplicablePercent) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" flag="fatal">[G1.24] Le taux de TVA doit appartenir a la liste des taux autorises. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>
  <pattern id="F1-COMPLETE-CII-G1.53-COHERENCE">
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert test="not(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount) or not(ram:ApplicableTradeTax/ram:BasisAmount) or abs(number(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount) - sum(ram:ApplicableTradeTax/ram:BasisAmount)) &lt;= 0.01" flag="fatal">[G1.53] Le total hors TVA doit etre egal a la somme des bases d'imposition, tolerance 0,01. | Source : Annexe 7 v1.8 G1.53</assert>
      <assert test="not(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']) or not(ram:ApplicableTradeTax/ram:CalculatedAmount) or abs(number(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']) - sum(ram:ApplicableTradeTax/ram:CalculatedAmount)) &lt;= 0.01" flag="fatal">[G1.53] Le total TVA EUR doit etre egal a la somme des TVA par ventilation, tolerance 0,01. | Source : Annexe 7 v1.8 G1.53</assert>
    </rule>
  </pattern>
</schema>