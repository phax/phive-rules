<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt2"
        schemaVersion="ISO19757-3">

  <title>PPF — Flux 10 e-reporting — v1.8</title>

  <pattern id="F10-TRANSMISSION-G1.104">
    <rule context="/Report/ReportDocument/Id">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 50" flag="fatal"
        >[G1.104] L'identifiant de transmission ne peut pas dépasser 50 caractères. | Source : Annexe 7 v1.8 G1.104</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal"
        >[G1.104] L'identifiant de transmission ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.104</assert>
      <assert test="not(contains($v, '  '))" flag="fatal"
        >[G1.104] L'identifiant de transmission ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.104</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal"
        >[G1.104] L'identifiant de transmission contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.104</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSMISSION-G7.53">
    <rule context="/Report/ReportDocument/IssueDateTime/DateTimeString">
      <assert test="matches(., '^\d{14}$')" flag="fatal"
        >[G7.53] La date-heure de transmission doit être au format AAAAMMJJHHMMSS. | Source : Annexe 7 v1.8 G7.53</assert>
      <assert test="not(matches(., '^\d{14}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date-heure de transmission doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSMISSION-G8.01">
    <rule context="/Report/ReportDocument/TypeCode">
      <assert test=". = ('IN', 'RE')" flag="fatal"
        >[G8.01] Le type de transmission doit être IN (initiale) ou RE (rectificative). | Source : Annexe 7 v1.8 G8.01</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSMISSION-G6.29">
    <rule context="/Report/ReportDocument">
      <assert test="count((/Report/TransactionsReport, /Report/PaymentsReport)) = 1" flag="fatal"
        >[G6.29] La transmission doit contenir exactement un rapport : soit un rapport de transactions (TB-2), soit un rapport de paiements (TB-3), mais pas les deux. | Source : Annexe 7 v1.8 G6.29</assert>
    </rule>
  </pattern>

  <pattern id="F10-EMETTEUR-G6.22">
    <rule context="/Report/ReportDocument/Sender/Id">
      <assert test="@schemeId = '0238'" flag="fatal"
        >[G6.22] Le type d'identifiant de l'émetteur doit être 0238 (plateforme agréée). | Source : Annexe 7 v1.8 G6.22</assert>
      <assert test="string-length(.) = 4" flag="fatal"
        >[G6.22] Le matricule de la plateforme émettrice doit comporter exactement 4 caractères. | Source : Annexe 7 v1.8 G6.22</assert>
    </rule>
  </pattern>

  <pattern id="F10-EMETTEUR-G7.51">
    <rule context="/Report/ReportDocument/Sender/RoleCode">
      <assert test=". = 'WK'" flag="fatal"
        >[G7.51] Le code rôle de l'émetteur doit être WK (plateforme agréée). | Source : Annexe 7 v1.8 G7.51</assert>
    </rule>
  </pattern>

  <pattern id="F10-DECLARANT-G6.26">
    <rule context="/Report/ReportDocument/Issuer/Id">
      <assert test="@schemeId = '0002'" flag="fatal"
        >[G6.26] Le type d'identifiant du déclarant doit être 0002 (SIREN). | Source : Annexe 7 v1.8 G6.26</assert>
      <assert test="matches(., '^\d{9}$')" flag="fatal"
        >[G6.26] Le SIREN du déclarant doit comporter exactement 9 caractères numériques. | Source : Annexe 7 v1.8 G6.26</assert>
    </rule>
  </pattern>

  <pattern id="F10-DECLARANT-G7.52">
    <rule context="/Report/ReportDocument/Issuer/RoleCode">
      <assert test=". = ('BY', 'SE')" flag="fatal"
        >[G7.52] Le code rôle du déclarant doit être BY (acheteur) ou SE (vendeur). | Source : Annexe 7 v1.8 G7.52</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-TX-G1.09a">
    <rule context="/Report/TransactionsReport/ReportPeriod/StartDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] <name/> : la date de début de période de transmission doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] <name/> : l'année doit être comprise entre 2000 et 2099 (début période transmission). | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-TX-G1.09b">
    <rule context="/Report/TransactionsReport/ReportPeriod/EndDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] <name/> : la date de fin de période de transmission doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] <name/> : l'année doit être comprise entre 2000 et 2099 (fin période transmission). | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-TX-G6.25">
    <rule context="/Report/TransactionsReport/ReportPeriod[StartDate and EndDate]">
      <assert test="EndDate &gt; StartDate" flag="fatal"
        >[G6.25] La date de fin de période de transmission ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.01">
    <rule context="/Report/TransactionsReport/Invoice/TypeCode">
      <assert test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')"
              flag="fatal"
        >[G1.01] Le type de facture n'est pas autorisé par le PPF. | Source : Annexe 7 v1.8 G1.01</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.02">
    <rule context="/Report/TransactionsReport/Invoice/BusinessProcess/ID">
      <assert test=". = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')"
              flag="fatal"
        >[G1.02] Le cadre de facturation n'est pas autorisé. | Source : Annexe 7 v1.8 G1.02</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.60">
    <rule context="/Report/TransactionsReport/Invoice">
      <assert test="not(BusinessProcess/ID = ('B4','S4','M4') and
                        TypeCode = ('386','500','503'))" flag="fatal"
        >[G1.60] Le type de facture est incompatible avec le cadre de facturation (acomptes interdits avec B4/S4/M4). | Source : Annexe 7 v1.8 G1.60</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-S1.12">
    <rule context="/Report/TransactionsReport/Invoice/BusinessProcess/TypeID">
      <assert test=". = 'urn.cpro.gouv.fr:1p0:ereporting'" flag="fatal"
        >[S1.12] L'identifiant de profil doit être urn.cpro.gouv.fr:1p0:ereporting. | Source : Annexe 7 v1.8 S1.12</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.05a">
    <rule context="/Report/TransactionsReport/Invoice/ID">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 35" flag="fatal"
        >[G1.05] L'identifiant de facture ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal"
        >[G1.05] L'identifiant de facture ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(contains($v, '  '))" flag="fatal"
        >[G1.05] L'identifiant de facture ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal"
        >[G1.05] L'identifiant de facture contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.09a">
    <rule context="/Report/TransactionsReport/Invoice/IssueDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date d'émission de la facture doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date d'émission de la facture doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.09b">
    <rule context="/Report/TransactionsReport/Invoice/DueDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date d'échéance de la facture doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date d'échéance de la facture doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-P1.11">
    <rule context="/Report/TransactionsReport/Invoice/TaxDueDateTypeCode">
      <assert test=". = ('5','29','72','3','35','432')" flag="fatal"
        >[P1.11] Le code d'exigibilité de la TVA doit appartenir à UNTDID 2475 (5, 29, 72) ou UNTDID 2005 (3, 35, 432). | Source : Annexe 7 v1.8 P1.11</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G6.21">
    <rule context="/Report/TransactionsReport/Invoice">
      <assert test="not(TaxSubTotal/TaxCategory/TaxExemptionReasonCode = 'VATEX-FR-CNWVAT')
                    or TypeCode = ('261','381','396')" flag="fatal"
        >[G6.21] Le code VATEX-FR-CNWVAT est réservé aux avoirs (types 261, 381, 396). | Source : Annexe 7 v1.8 G6.21</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.32a">
    <rule context="/Report/TransactionsReport/Invoice[TypeCode = ('384','471','472','473')]">
      <assert test="count(ReferencedDocument) = 1 and ReferencedDocument/IssueDate"
              flag="fatal"
        >[G1.32] Une facture rectificative doit comporter une et une seule référence de facture antérieure avec sa date. | Source : Annexe 7 v1.8 G1.32</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.32b">
    <rule context="/Report/TransactionsReport/Invoice[TypeCode = ('261','381','396','502','503')]">
      <assert test="(count(ReferencedDocument) &gt;= 1 and ReferencedDocument/IssueDate)
                    or (exists(Line) and
                        (every $l in Line satisfies
                           (exists($l/ReferencedDocument/ID) and
                           exists($l/ReferencedDocument/IssueDate))))"
              flag="fatal"
        >[G1.32] Un avoir doit comporter au moins une référence de facture antérieure avec sa date, en entête ou sur chaque ligne. | Source : Annexe 7 v1.8 G1.32</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G6.28">
    <rule context="/Report/TransactionsReport/Invoice">
      <assert test="Buyer/CompanyId" flag="fatal"
        >[G6.28] L'identifiant de l'acheteur est obligatoire pour une transmission B2B international. | Source : Annexe 7 v1.8 G6.28</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.09c">
    <rule context="/Report/TransactionsReport/Invoice/ReferencedDocument/IssueDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de la facture antérieure doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de la facture antérieure doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-FACTURE-G1.05b">
    <rule context="/Report/TransactionsReport/Invoice/ReferencedDocument/ID">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 35" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(contains($v, '  '))" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.19a">
    <rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId">
      <assert test="@schemeId = ('0002','0223','0227','0228','0229')" flag="fatal"
        >[G2.19] Le type d'identifiant du vendeur doit être 0002, 0223, 0227, 0228 ou 0229. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.19b">
    <rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0002']">
      <assert test="matches(., '^\d{9}$')" flag="fatal"
        >[G2.19] L'identifiant vendeur de type 0002 (SIREN) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.19c">
    <rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0223']">
      <assert test="string-length(.) &lt;= 18" flag="fatal"
        >[G2.19] L'identifiant vendeur de type 0223 (UE_HORS_FRANCE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.19d">
    <rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0227']">
      <assert test="string-length(.) &lt;= 18" flag="fatal"
        >[G2.19] L'identifiant vendeur de type 0227 (HORS_UE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.19e">
    <rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0228']">
      <assert test="matches(., '^\d{9,10}$')" flag="fatal"
        >[G2.19] L'identifiant vendeur de type 0228 (RIDET) doit comporter 9 ou 10 chiffres. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.19f">
    <rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0229']">
      <assert test="matches(., '^\d{9}$')" flag="fatal"
        >[G2.19] L'identifiant vendeur de type 0229 (TAHITI) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.33a">
    <rule context="/Report/TransactionsReport/Invoice/Seller[CompanyId/@schemeId = ('0002','0223')]">
      <assert test="TaxRegistrationId" flag="fatal"
        >[G2.33] L'identifiant TVA du vendeur est obligatoire quand le type d'identifiant est 0002 ou 0223. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.33b">
    <rule context="/Report/TransactionsReport/Invoice/Seller/TaxRegistrationId">
      <assert test="@qualifyingId = 'VAT'" flag="fatal"
        >[G2.33] Le qualifiant de l'identifiant TVA du vendeur doit être VAT. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G1.102">
    <rule context="/Report/TransactionsReport/Invoice[TaxSubTotal/TaxCategory/Code = 'E']">
      <assert test="Seller/TaxRegistrationId or
                    SellerTaxRepresentative/TaxRegistrationId" flag="fatal"
        >[G1.102] L'identifiant TVA du vendeur ou du représentant fiscal est obligatoire quand un code de catégorie TVA "E" est présent. | Source : Annexe 7 v1.8 G1.102</assert>
    </rule>
  </pattern>

  <pattern id="F10-VENDEUR-G2.01">
    <rule context="/Report/TransactionsReport/Invoice/Seller/PostalAddress/CountryId">
      <assert test="matches(., '^[A-Z]{2}$')" flag="fatal"
        >[G2.01] <name/> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.19a">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId">
      <assert test="@schemeId = ('0002','0223','0227','0228','0229')" flag="fatal"
        >[G2.19] Le type d'identifiant de l'acheteur doit être 0002, 0223, 0227, 0228 ou 0229. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.19b">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0002']">
      <assert test="matches(., '^\d{9}$')" flag="fatal"
        >[G2.19] L'identifiant acheteur de type 0002 (SIREN) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.19c">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0223']">
      <assert test="string-length(.) &lt;= 18" flag="fatal"
        >[G2.19] L'identifiant acheteur de type 0223 (UE_HORS_FRANCE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.19d">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0227']">
      <assert test="string-length(.) &lt;= 18" flag="fatal"
        >[G2.19] L'identifiant acheteur de type 0227 (HORS_UE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.19e">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0228']">
      <assert test="matches(., '^\d{9,10}$')" flag="fatal"
        >[G2.19] L'identifiant acheteur de type 0228 (RIDET) doit comporter 9 ou 10 chiffres. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.19f">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0229']">
      <assert test="matches(., '^\d{9}$')" flag="fatal"
        >[G2.19] L'identifiant acheteur de type 0229 (TAHITI) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.33a">
    <rule context="/Report/TransactionsReport/Invoice/Buyer[CompanyId/@schemeId = ('0002','0223')]">
      <assert test="TaxRegistrationId" flag="fatal"
        >[G2.33] L'identifiant TVA de l'acheteur est obligatoire quand le type d'identifiant est 0002 ou 0223. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.33b">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/TaxRegistrationId">
      <assert test="@qualifyingId = 'VAT'" flag="fatal"
        >[G2.33] Le qualifiant de l'identifiant TVA de l'acheteur doit être VAT. | Source : Annexe 7 v1.8 G2.33</assert>
    </rule>
  </pattern>

  <pattern id="F10-ACHETEUR-G2.01">
    <rule context="/Report/TransactionsReport/Invoice/Buyer/PostalAddress/CountryId">
      <assert test="matches(., '^[A-Z]{2}$')" flag="fatal"
        >[G2.01] <name/> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIVRAISON-G1.09">
    <rule context="/Report/TransactionsReport/Invoice/Delivery/Date">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de livraison doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de livraison doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIVRAISON-G2.01">
    <rule context="/Report/TransactionsReport/Invoice/Delivery/Location/CountryId">
      <assert test="matches(., '^[A-Z]{2}$')" flag="fatal"
        >[G2.01] <name/> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-FAC-G1.09a">
    <rule context="/Report/TransactionsReport/Invoice/InvoicePeriod/StartDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de début de période de facturation doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de début de période de facturation doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-FAC-G1.09b">
    <rule context="/Report/TransactionsReport/Invoice/InvoicePeriod/EndDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de fin de période de facturation doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de fin de période de facturation doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-FAC-G6.25">
    <rule context="/Report/TransactionsReport/Invoice/InvoicePeriod[StartDate and EndDate]">
      <assert test="EndDate &gt; StartDate" flag="fatal"
        >[G6.25] La date de fin de période de facturation ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>

  <pattern id="F10-REMISE-G2.31">
    <rule context="/Report/TransactionsReport/Invoice/AllowanceCharge/TaxCategoryCode">
      <assert test=". = ('S','E','AE','K','G','O','Z')" flag="fatal"
        >[G2.31] Le code de catégorie TVA des remises/charges doit appartenir à UNTDID 5305 (S, E, AE, K, G, O, Z). | Source : Annexe 7 v1.8 G2.31</assert>
    </rule>
  </pattern>

  <pattern id="F10-REMISE-G1.24">
    <rule context="/Report/TransactionsReport/Invoice/AllowanceCharge/TaxPercent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)"
              flag="fatal"
        >[G1.24] Le taux de TVA des remises/charges n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F10-REMISE-G1.14">
    <rule context="/Report/TransactionsReport/Invoice/AllowanceCharge/Amount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TOTAL-G1.14a">
    <rule context="/Report/TransactionsReport/Invoice/MonetaryTotal/TaxExclusiveAmount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TOTAL-TAXAMOUNT">
    <rule context="/Report/TransactionsReport/Invoice/MonetaryTotal/TaxAmount">
      <assert test="@CurrencyCode = 'EUR'" flag="fatal"
        >[G6.23] <name/> : le montant de TVA de la facture doit être exprimé en euros. | Source : Annexe 7 v1.8 G6.23</assert>
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TOTAL-G1.53">
    <rule context="/Report/TransactionsReport/Invoice[CurrencyCode = 'EUR']">
      <let name="totalHT"      value="number(MonetaryTotal/TaxExclusiveAmount)"/>
      <let name="sommeBasesHT" value="sum(TaxSubTotal/TaxableAmount)"/>
      <let name="totalTVA"     value="number(MonetaryTotal/TaxAmount)"/>
      <let name="sommeTVA"     value="sum(TaxSubTotal/TaxAmount)"/>
      <let name="toleranceHT"  value="0.01 * count(TaxSubTotal/TaxableAmount)"/>
      <let name="toleranceTVA" value="0.01 * count(TaxSubTotal/TaxAmount)"/>
      <let name="amountsHTValides" value="every $m in (MonetaryTotal/TaxExclusiveAmount, TaxSubTotal/TaxableAmount) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)"/>
      <let name="amountsTVAValides" value="every $m in (MonetaryTotal/TaxAmount, TaxSubTotal/TaxAmount) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)"/>

      <assert test="not(MonetaryTotal/TaxExclusiveAmount) or not($amountsHTValides) or (abs($totalHT - $sommeBasesHT) &lt;= $toleranceHT)" flag="fatal"
        >[G1.53] Le montant total hors taxe (<value-of select="$totalHT"/>) doit être égal à la somme des bases d'imposition TVA (<value-of select="$sommeBasesHT"/>), avec une tolérance de 0,01 EUR par montant HT additionné. | Source : Annexe 7 v1.8 G1.53</assert>
      <assert test="not(MonetaryTotal/TaxAmount) or not($amountsTVAValides) or (abs($totalTVA - $sommeTVA) &lt;= $toleranceTVA)" flag="fatal"
        >[G1.53] Le montant total de TVA (<value-of select="$totalTVA"/>) doit être égal à la somme des montants de TVA par ventilation (<value-of select="$sommeTVA"/>), avec une tolérance de 0,01 EUR par montant TVA additionné. | Source : Annexe 7 v1.8 G1.53</assert>
    </rule>
  </pattern>

  <pattern id="F10-TVA-G2.31">
    <rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxCategory/Code">
      <assert test=". = ('S','E','AE','K','G','O','Z')" flag="fatal"
        >[G2.31] Le code de catégorie TVA doit appartenir à UNTDID 5305 (S, E, AE, K, G, O, Z). | Source : Annexe 7 v1.8 G2.31</assert>
    </rule>
  </pattern>

  <pattern id="F10-TVA-G1.24">
    <rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxCategory/Percent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)"
              flag="fatal"
        >[G1.24] Le taux de TVA n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F10-TVA-G1.40">
    <rule context="/Report/TransactionsReport/Invoice/TaxSubTotal[TaxCategory/Code = 'E']">
      <assert test="TaxCategory/TaxExemptionReasonCode and TaxCategory/TaxExemptionReason" flag="fatal"
        >[G1.40] Le code et le libellé du motif d'exonération sont obligatoires quand le code de catégorie TVA est "E". | Source : Annexe 7 v1.8 G1.40</assert>
    </rule>
  </pattern>

  <pattern id="F10-TVA-G1.14a">
    <rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxableAmount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TVA-G1.14b">
    <rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxAmount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.09a">
    <rule context="/Report/TransactionsReport/Invoice/Line/InvoicePeriod/StartDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de début de période de ligne doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de début de période de ligne doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.09b">
    <rule context="/Report/TransactionsReport/Invoice/Line/InvoicePeriod/EndDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de fin de période de ligne doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de fin de période de ligne doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G6.25">
    <rule context="/Report/TransactionsReport/Invoice/Line/InvoicePeriod[StartDate and EndDate]">
      <assert test="EndDate &gt; StartDate" flag="fatal"
        >[G6.25] La date de fin de période de ligne ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G2.01">
    <rule context="/Report/TransactionsReport/Invoice/Line/Delivery/Location/CountryId">
      <assert test="matches(., '^[A-Z]{2}$')" flag="fatal"
        >[G2.01] <name/> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.14">
    <rule context="/Report/TransactionsReport/Invoice/Line/AllowanceCharge/Amount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.15">
    <rule context="/Report/TransactionsReport/Invoice/Line/BilledQuantity">
      <assert test="matches(., '^-?\d+(\.\d{1,4})?$')" flag="fatal"
        >[G1.15] <name/> : doit comporter au maximum 4 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.15</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.15] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.15</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.16a">
    <rule context="/Report/TransactionsReport/Invoice/Line/Price/PriceAmount">
      <assert test="matches(., '^\d+(\.\d{1,6})?$')" flag="fatal"
        >[G1.16] <name/> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.16] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.16b">
    <rule context="/Report/TransactionsReport/Invoice/Line/Price/AllowanceChargeAmount">
      <assert test="matches(., '^\d+(\.\d{1,6})?$')" flag="fatal"
        >[G1.16] <name/> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.16] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.16c">
    <rule context="/Report/TransactionsReport/Invoice/Line/Price/AllowanceChargeBaseAmount">
      <assert test="matches(., '^\d+(\.\d{1,6})?$')" flag="fatal"
        >[G1.16] <name/> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.16] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.55">
    <rule context="/Report/TransactionsReport/Invoice/Line/Price[PriceAmount and AllowanceChargeAmount and AllowanceChargeBaseAmount]">
      <let name="prixValides" value="every $m in (PriceAmount, AllowanceChargeAmount, AllowanceChargeBaseAmount) satisfies (matches(string($m), '^\d+(\.\d{1,6})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)"/>
      <assert test="not($prixValides) or abs(number(PriceAmount) - (number(AllowanceChargeBaseAmount) - number(AllowanceChargeAmount))) &lt;= 0.01" flag="fatal"
        >[G1.55] Le prix net doit être égal au prix brut diminué du rabais (tolérance 0,01). | Source : Annexe 7 v1.8 G1.55</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.09c">
    <rule context="/Report/TransactionsReport/Invoice/Line/ReferencedDocument/IssueDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de la facture antérieure à la ligne doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de la facture antérieure à la ligne doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-LIGNE-G1.05">
    <rule context="/Report/TransactionsReport/Invoice/Line/ReferencedDocument/ID">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 35" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure à la ligne ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure à la ligne ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(contains($v, '  '))" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure à la ligne ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal"
        >[G1.05] L'identifiant de la facture antérieure à la ligne contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.09">
    <rule context="/Report/TransactionsReport/Transactions/Date">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date des transactions doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date des transactions doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.68">
    <rule context="/Report/TransactionsReport/Transactions/CategoryCode">
      <assert test=". = ('TLB1','TPS1','TNT1','TMA1')" flag="fatal"
        >[G1.68] La catégorie de transactions doit être TLB1, TPS1, TNT1 ou TMA1. | Source : Annexe 7 v1.8 G1.68</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-P1.11">
    <rule context="/Report/TransactionsReport/Transactions/TaxDueDateTypeCode">
      <assert test=". = ('5','29','72','3','35','432')" flag="fatal"
        >[P1.11] Le code d'exigibilité de la TVA doit appartenir à UNTDID 2475 (5, 29, 72) ou UNTDID 2005 (3, 35, 432). | Source : Annexe 7 v1.8 P1.11</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.24b">
    <rule context="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxPercent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)"
              flag="fatal"
        >[G1.24] Le taux de TVA des transactions n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.14a">
    <rule context="/Report/TransactionsReport/Transactions/TaxExclusiveAmount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.14b">
    <rule context="/Report/TransactionsReport/Transactions/TaxTotal">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.14c">
    <rule context="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxableAmount">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.14d">
    <rule context="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxTotal">
      <assert test="matches(., '^-?\d+(\.\d{1,2})?$')" flag="fatal"
        >[G1.14] <name/> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.14] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</assert>
    </rule>
  </pattern>

  <pattern id="F10-TRANSAC-G1.53">
    <rule context="/Report/TransactionsReport/Transactions[TransactionsCurrency = 'EUR']">
      <let name="totalHT"      value="number(TaxExclusiveAmount)"/>
      <let name="sommeBasesHT" value="sum(TaxSubtotal/TaxableAmount)"/>
      <let name="totalTVA"     value="number(TaxTotal)"/>
      <let name="sommeTVA"     value="sum(TaxSubtotal/TaxTotal)"/>
      <let name="toleranceHT"  value="0.01 * count(TaxSubtotal/TaxableAmount)"/>
      <let name="toleranceTVA" value="0.01 * count(TaxSubtotal/TaxTotal)"/>
      <let name="amountsHTValides" value="every $m in (TaxExclusiveAmount, TaxSubtotal/TaxableAmount) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)"/>
      <let name="amountsTVAValides" value="every $m in (TaxTotal, TaxSubtotal/TaxTotal) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)"/>
      <assert test="not($amountsHTValides) or abs($totalHT - $sommeBasesHT) &lt;= $toleranceHT" flag="fatal"
        >[G1.53] TaxExclusiveAmount (<value-of select="$totalHT"/>) doit être égal à la somme TaxableAmount (<value-of select="$sommeBasesHT"/>), avec une tolérance de 0,01 EUR par montant HT additionné. | Source : Annexe 7 v1.8 G1.53</assert>
      <assert test="not($amountsTVAValides) or abs($totalTVA - $sommeTVA) &lt;= $toleranceTVA" flag="fatal"
        >[G1.53] TaxTotal (<value-of select="$totalTVA"/>) doit être égal à la somme TaxSubtotal/TaxTotal (<value-of select="$sommeTVA"/>), avec une tolérance de 0,01 EUR par montant TVA additionné. | Source : Annexe 7 v1.8 G1.53</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-PMT-G1.09a">
    <rule context="/Report/PaymentsReport/ReportPeriod/StartDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de début de période de paiements doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de début de période de paiements doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-PMT-G1.09b">
    <rule context="/Report/PaymentsReport/ReportPeriod/EndDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date de fin de période de paiements doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date de fin de période de paiements doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PERIODE-PMT-G6.25">
    <rule context="/Report/PaymentsReport/ReportPeriod[StartDate and EndDate]">
      <assert test="EndDate &gt; StartDate" flag="fatal"
        >[G6.25] La date de fin de période de paiements ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-FACTURE-G1.05">
    <rule context="/Report/PaymentsReport/Invoice/InvoiceID">
      <let name="v" value="string(.)"/>
      <assert test="string-length($v) &lt;= 35" flag="fatal"
        >[G1.05] L'identifiant de facture dans le rapport de paiements ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(starts-with($v, ' ') or ends-with($v, ' '))" flag="fatal"
        >[G1.05] L'identifiant de facture dans le rapport de paiements ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="not(contains($v, '  '))" flag="fatal"
        >[G1.05] L'identifiant de facture dans le rapport de paiements ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</assert>
      <assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" flag="fatal"
        >[G1.05] L'identifiant de facture dans le rapport de paiements contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-FACTURE-G1.09">
    <rule context="/Report/PaymentsReport/Invoice/IssueDate">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date d'émission de facture dans le rapport de paiements doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date d'émission de facture dans le rapport de paiements doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-ENCAISSEMENT-G1.09">
    <rule context="/Report/PaymentsReport/Invoice/Payment/Date">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date d'encaissement doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date d'encaissement doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-ENCAISSEMENT-G1.24">
    <rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals/TaxPercent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)"
              flag="fatal"
        >[G1.24] Le taux de TVA dans le rapport de paiements n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-ENCAISSEMENT-G6.27a">
    <rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals[CurrencyCode]">
      <assert test="not(matches(CurrencyCode, '^[A-Z]{3}$')) or CurrencyCode = 'EUR'" flag="fatal"
        >[G6.27] Le montant encaissé doit être exprimé en euros. | Source : Annexe 7 v1.8 G6.27</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-ENCAISSEMENT-G1.16">
    <rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals/Amount">
      <assert test="matches(., '^\d+(\.\d{1,6})?$')" flag="fatal"
        >[G1.16] <name/> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.16] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-AGREGE-G1.09">
    <rule context="/Report/PaymentsReport/Transactions/Payment/Date">
      <assert test="matches(., '^\d{8}$')" flag="fatal"
        >[G1.09] La date d'encaissement agrégé doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</assert>
      <assert test="not(matches(., '^\d{8}$')) or
                    (number(substring(., 1, 4)) &gt;= 2000 and
                     number(substring(., 1, 4)) &lt;= 2099)" flag="fatal"
        >[G1.36] L'année de la date d'encaissement agrégé doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-AGREGE-G1.24">
    <rule context="/Report/PaymentsReport/Transactions/Payment/SubTotals/TaxPercent">
      <assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)"
              flag="fatal"
        >[G1.24] Le taux de TVA de l'encaissement agrégé n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-AGREGE-G6.27b">
    <rule context="/Report/PaymentsReport/Transactions/Payment/SubTotals[CurrencyCode]">
      <assert test="not(matches(CurrencyCode, '^[A-Z]{3}$')) or CurrencyCode = 'EUR'" flag="fatal"
        >[G6.27] Le montant encaissé agrégé doit être exprimé en euros. | Source : Annexe 7 v1.8 G6.27</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-AGREGE-G1.16">
    <rule context="/Report/PaymentsReport/Transactions/Payment/SubTotals/Amount">
      <assert test="matches(., '^\d+(\.\d{1,6})?$')" flag="fatal"
        >[G1.16] <name/> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</assert>
      <assert test="string-length(translate(., '.', '')) &lt;= 19" flag="fatal"
        >[G1.16] <name/> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</assert>
    </rule>
  </pattern>

  <pattern id="F10-PMT-DEVISE-G1.10">
    <rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals/CurrencyCode |
                   /Report/PaymentsReport/Transactions/Payment/SubTotals/CurrencyCode">
      <assert test="matches(., '^[A-Z]{3}$')" flag="fatal"
        >[G1.10] <name/> : doit respecter le format ISO 4217 (3 lettres majuscules — existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G1.10</assert>
    </rule>
  </pattern>

  <pattern id="F10-TX-DEVISE-G1.10">
    <rule context="/Report/TransactionsReport/Invoice/CurrencyCode |
                   /Report/TransactionsReport/Transactions/TransactionsCurrency">
      <assert test="matches(., '^[A-Z]{3}$')" flag="fatal"
        >[G1.10] <name/> : doit respecter le format ISO 4217 (3 lettres majuscules — existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G1.10</assert>
    </rule>
  </pattern>

</schema>
