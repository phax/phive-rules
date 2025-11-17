<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:custom="http://www.example.org/custom"
  queryBinding="xslt2"
  xsl:exclude-result-prefixes="xs custom">
  
  <ns prefix="custom" uri="http://www.example.org/custom"/>
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossDomainAcknowledgementAndResponse:100"/>
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
  <ns prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"/>
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>

  <!-- Fonctions utilisées dans les règles -->
  <!-- BR-FR-01 : identifiant valide -->
  <xsl:function name="custom:is-valid-id-format" as="xs:boolean">
    <xsl:param name="id" as="xs:string"/>
    <xsl:sequence select="
      matches(normalize-space($id), '^[A-Za-z0-9+\-_/]+$') and
      not(matches($id, ' ')) and
      not(starts-with($id, ' ')) and
      not(ends-with($id, ' '))
      "/>
  </xsl:function>
  
  <!-- BR-FR-03 : Année entre 2000 et 2099 et format date valide -->
  <xsl:function name="custom:is-valid-date-format" as="xs:boolean">
    <xsl:param name="date" as="xs:string"/>
    
    <!-- Vérifie le format AAAAMMJJ -->
    <xsl:variable name="isFormatValid" select="matches($date, '^20\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$')"/>
    
    <!-- Extraction des composantes -->
    <xsl:variable name="year" select="number(substring($date, 1, 4))"/>
    <xsl:variable name="month" select="number(substring($date, 5, 2))"/>
    <xsl:variable name="day" select="number(substring($date, 7, 2))"/>
    
    <!-- Calcul année bissextile -->
    <xsl:variable name="isLeapYear"
      select="($year mod 4 = 0 and $year mod 100 != 0) or ($year mod 400 = 0)"/>
    
    <!-- Nombre de jours max selon le mois -->
    <xsl:variable name="maxDay" select="
      if ($month = (1, 3, 5, 7, 8, 10, 12)) then 31
      else if ($month = (4, 6, 9, 11)) then 30
      else if ($month = 2 and $isLeapYear) then 29
      else if ($month = 2) then 28
      else 0"/>
    
    <!-- Résultat final -->
    <xsl:sequence select="$isFormatValid and $day le $maxDay"/>
  </xsl:function>
  
  <!-- BR-FR-04 : Code type de facture -->
  <xsl:function name="custom:is-valid-document-type-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="custom:document-type-codes" as="xs:string"
      select="'380 389 393 501 386 500 384 471 472 473 261 262 381 396 502 503'"/>
    <xsl:sequence select="$code = tokenize($custom:document-type-codes, '\s+')"/>
  </xsl:function>
  
  <!-- BR-FR-08 : Type de facture -->
  <xsl:function name="custom:is-valid-billing-mode" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="custom:billing-modes" as="xs:string"
      select="'B1 S1 M1 B2 S2 M2 B4 S4 M4 S5 S6 B7 S7'"/>
    <xsl:sequence select="$code = tokenize($custom:billing-modes, '\s+')"/>
  </xsl:function>
  
  <!-- BR-FR-09 : Vérification cohérence SIRET/SIREN -->
  <xsl:function name="custom:check-siret-siren-coherence" as="xs:boolean">
    <xsl:param name="siret" as="xs:string?"/>
    <xsl:param name="siren" as="xs:string?"/>
    <xsl:sequence select="matches($siret, '^\d{14}$') and substring($siret, 1, 9) = $siren"/>
  </xsl:function>
  
  <!-- BR-FR-11, 12, 13 et 20 : Code traitement BAR -->
  <xsl:function name="custom:is-valid-bar-treatment" as="xs:boolean">
    <xsl:param name="value" as="xs:string?"/>
    <xsl:sequence select="$value = ('B2B', 'B2BINT', 'B2C', 'OUTOFSCOPE', 'ARCHIVEONLY')"/>
  </xsl:function>
  
  <!-- BR-FR-12 : Codes EAS autorisés -->
  <xsl:function name="custom:is-valid-eas-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string?"/>
    <xsl:variable name="custom:eas-codes" as="xs:string"
      select="'AN AQ AS AU EM 0002 0007 0009 0037 0060 0088 0096 0097 0106 
      0130 0135 0142 0147 0151 0154 0158 0170 0177 0183 0184 0188 0190 
      0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 
      0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0218 0221 0225 
      0230 0235 0240 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 
      9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 
      9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 
      9951 9952 9953 9957 9959'"/>
    <xsl:sequence select="$code = tokenize($custom:eas-codes, '\s+')"/>
  </xsl:function>
  
  <!-- BR-FR-16 : Type de TVA -->
  <xsl:function name="custom:is-valid-vat-category-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="validCodes" select="('S', 'E', 'AE', 'K', 'G', 'O', 'Z')"/>
    <xsl:sequence select="$code = $validCodes"/>
  </xsl:function>
  
  <!-- BR-FR-16 : Taux de TVA -->
  <xsl:function name="custom:is-valid-vat-rate" as="xs:boolean">
    <xsl:param name="rate" as="xs:string"/>
    <xsl:variable name="validRates" select="(
      '0', '0.0', '0.00', '10', '10.0', '10.00', '13', '13.0', '13.00', '20', '20.0', '20.00',
      '8.5', '8.50', '19.6', '19.60', '2.1', '2.10', '5.5', '5.50', '7', '7.0', '7.00',
      '20.6', '20.60', '1.05', '0.9', '0.90', '1.75', '9.2', '9.20', '9.6', '9.60'
      )"/>
    <xsl:sequence select="$rate = $validRates"/>
  </xsl:function>
  
  <!-- BR-FR-17 : types de pièces jointes -->
  <xsl:function name="custom:is-valid-attachment-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="validCodes" select="(
      'RIB', 'LISIBLE', 'FEUILLE_DE_STYLE', 'PJA', 'BORDEREAU_SUIVI',
      'DOCUMENT_ANNEXE', 'BON_LIVRAISON', 'BON_COMMANDE',
      'BORDEREAU_SUIVI_VALIDATION', 'ETAT_ACOMPTE', 'FACTURE_PAIEMENT_DIRECT'
      )"/>
    <xsl:sequence select="$code = $validCodes"/>
  </xsl:function>
  
  <!-- BR-FR-23 et BR-FR-24 -->
  <xsl:function name="custom:is-valid-schemeid-format" as="xs:boolean">
    <xsl:param name="value" as="xs:string"/>
    <!-- Autorise lettres, chiffres, + - _ / sans espaces -->
    <xsl:sequence select="matches($value, '^[A-Za-z0-9+\-_/]+$')"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-01 : montants sur 19 positions, max 2 décimales -->
  <xsl:function name="custom:is-valid-decimal-19-2" as="xs:boolean">
    <xsl:param name="amount" as="xs:string"/>
    <xsl:sequence select="matches($amount, '^[-]?\d{1,19}(\.\d{1,2})?$') and string-length(replace($amount, '\.', '')) le 19"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-02 : quantités sur 19 positions, max 4 décimales -->
  <xsl:function name="custom:is-valid-decimal-19-4" as="xs:boolean">
    <xsl:param name="quantity" as="xs:string"/>
    <xsl:sequence select="matches($quantity, '^[-]?\d{1,19}(\.\d{1,4})?$') and string-length(replace($quantity, '\.', '')) le 19"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-03 : prix unitaires positifs, 19 positions, max 6 décimales -->
  <xsl:function name="custom:is-valid-decimal-19-6-positive" as="xs:boolean">
    <xsl:param name="amount" as="xs:string"/>
    <xsl:sequence select="matches($amount, '^\d{1,19}(\.\d{1,6})?$') and string-length(replace($amount, '\.', '')) le 19"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-04 : taux de TVA positifs, 4 positions, max 2 décimales -->
  <xsl:function name="custom:is-valid-percent-4-2-positive" as="xs:boolean">
    <xsl:param name="percent" as="xs:string"/>
    <xsl:sequence select="matches($percent, '^\d{1,4}(\.\d{1,2})?$') and string-length(replace($percent, '\.', '')) le 4"/>
  </xsl:function>
  
  <!-- BR-FR-CDV-CL-06 : liste des codes statuts de CDV -->
  <xsl:function name="custom:is-valid-invoice-status-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="custom:invoice-status-codes" as="xs:string"
      select="'200 201 202 203 204 205 206 207 208 209 210 211 212 213 214
               220 221 224 225 226 227 228
               250 251
               300 301 400 401 500 501 601'"/>
    <xsl:sequence select="$code = tokenize($custom:invoice-status-codes, '\s+')"/>
  </xsl:function>
  
  <!-- BR-FR-CDV-CL-09 : liste des motifs de statuts de CDV -->
  <xsl:function name="custom:is-valid-status-reason-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="custom:status-reason-codes" as="xs:string"
      select="'NON_TRANSMISE JUSTIF_ABS ROUTAGE_ERR AUTRE COORD_BANC_ERR TX_TVA_ERR MONTANTTOTAL_ERR CALCUL_ERR NON_CONFORME DOUBLON DEST_INC DEST_ERR TRANSAC_INC EMMET_INC CONTRAT_TERM DOUBLE_FACT CMD_ERR ADR_ERR SIRET_ERR CODE_ROUTAGE_ERR REF_CT_ABSENT REF_ERR PU_ERR REM_ERR QTE_ERR ART_ERR MODPAI_ERR QUALITE_ERR LIVR_INCOMP REJ_SEMAN REJ_UNI REJ_COH REJ_ADR REJ_CONT_B2G REJ_REF_PJ REJ_ASS_PJ IRR_VIDE_F IRR_TYPE_F IRR_SYNTAX IRR_TAILLE_PJ IRR_NOM_PJ IRR_VID_PJ IRR_EXT_DOC IRR_TAILLE_F IRR_ANTIVIRUS'"/>
    <xsl:sequence select="$code = tokenize($custom:status-reason-codes, '\s+')"/>
  </xsl:function>
  
  <!-- BR-FR-CDV-CL-10 : liste des actions de facture -->
  <xsl:function name="custom:is-valid-invoice-action-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string"/>
    <xsl:variable name="custom:invoice-action-codes" as="xs:string"
      select="'NOA PIN NIN CNF CNP CNA OTH'"/>
    <xsl:sequence select="$code = tokenize($custom:invoice-action-codes, '\s+')"/>
  </xsl:function>

  <!-- Règles de validation CDV -->
  <pattern id="BR-FR-04">
    <title>BR-FR-04 — Validation des codes de type de document</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:TypeCode">
      <assert test="custom:is-valid-document-type-code(.)"
        flag="warning"
        id="BR-FR-04_MDT-91">
        BR-FR-04/MDT-91 : Le code de type de document "<value-of select='.'/>" n'est pas autorisé selon les spécifications françaises.
        Veuillez utiliser un code parmi ceux définis dans la documentation (ex. : 380, 389, 393, etc.).
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-01">
    <title>BR-FR-CDV-01 — Présence obligatoire de MDG-3</title>
    
    <rule context="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter">
      <assert test="." 
        flag="warning" 
        id="BR-FR-CDV-01_MDG-3">
        BR-FR-CDV-01/MDG-3 : Le paramètre de contexte MDG-3 est obligatoire dans le document.
        Veuillez vous assurer que l'élément ram:GuidelineSpecifiedDocumentContextParameter est bien présent et correctement renseigné.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-02"> <!-- CYS3 urn.cpro.gouv.fr:1p0:CDV:invoice maintenu pour les échanges entre PA -->
    <title>BR-FR-CDV-02 — Vérification de la valeur de MDT-3</title>
    
    <rule context="rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext">
      <assert test="./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn.cpro.gouv.fr:1p0:CDV:invoice' 
        or (./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn.cpro.gouv.fr:1p0:CDV:einvoicingF2' and count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID) = 1 and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID[@schemeID='0238'] = '9998' and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode = 'DFH')"
        flag="warning"
        id="BR-FR-CDV-02_MDT-3">
        BR-FR-CDV-02/MDT-3 : La valeur de MDT-3 doit être :
        - "urn.cpro.gouv.fr:1p0:CDV:invoice", ou
        - "urn.cpro.gouv.fr:1p0:CDV:einvoicingF2" **uniquement si** il y a un unique Destinataire (Recipent) et que c'est le PPF : GlobalID = 9998 avec @shemeId = 0238 et CodeRole = DFH. 
        Valeurs actuelles : "<value-of select='./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID'/>". Nombre de Recipient : "<value-of select='count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID)'/>" - GlobalID : "<value-of select='../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID'/>" - @shemeID : "<value-of select='../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID/@schemeID'/>" - CodeRole : "<value-of select='../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode'/>"
        Veuillez corriger cette valeur pour respecter les spécifications du format CDV.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-03">
    <title>BR-FR-CDV-03 — Présence obligatoire de MDT-4</title>
    
    <rule context="rsm:ExchangedDocument">
      <assert test="ram:ID" 
        flag="warning" 
        id="BR-FR-CDV-03_MDT-4">
        BR-FR-CDV-03/MDT-4 : L'identifiant du document (ram:ID) est obligatoire.
        Veuillez vous assurer que l'élément "ram:ID" est bien présent dans "rsm:ExchangedDocument".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-04">
    <title>BR-FR-CDV-04 — Présence obligatoire de MDG-4</title>
    
    <rule context="rsm:ExchangedDocument/ram:IssueDateTime">
      <assert test="." 
        flag="warning" 
        id="BR-FR-CDV-04_MDG-4">
        BR-FR-CDV-04/MDG-4 : La date d’émission du document (MDG-4) est obligatoire.
        Veuillez vous assurer que l’élément "ram:IssueDateTime" est bien présent dans "rsm:ExchangedDocument".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-05">
    <title>BR-FR-CDV-05 — Présence obligatoire de MDG-9</title>
    
    <rule context="rsm:ExchangedDocument/ram:SenderTradeParty">
      <assert test="." 
        flag="warning" 
        id="BR-FR-CDV-05_MDG-9">
        BR-FR-CDV-05/MDG-9 : Le partenaire commercial émetteur (MDG-9) est obligatoire.
        Veuillez vous assurer que l’élément "ram:SenderTradeParty" est bien présent dans "rsm:ExchangedDocument".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-06">
    <title>BR-FR-CDV-06 — Présence obligatoire de MDT-21</title>
    
    <rule context="rsm:ExchangedDocument/ram:SenderTradeParty/ram:RoleCode">
      <assert test="." 
        flag="warning" 
        id="BR-FR-CDV-06_MDT-21">
        BR-FR-CDV-06/MDT-21 : Le rôle du partenaire commercial émetteur (MDT-21) est obligatoire.
        Veuillez vous assurer que l’élément "ram:RoleCode" est bien présent dans "rsm:ExchangedDocument/ram:SenderTradeParty".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-07">
    <title>BR-FR-CDV-07 — Validation conditionnelle de MDT-38 selon MDT-77</title>
    
    <rule context="rsm:ExchangedDocument/ram:IssuerTradeParty">
      
      <!-- MDT-77 = 23 → MDT-38 obligatoire -->
      <assert test="ram:RoleCode != '23' or ram:GlobalID"
        flag="warning"
        id="BR-FR-CDV-07_MDT-38_yes">
        BR-FR-CDV-07/MDT-38 : Lorsque le rôle du partenaire commercial émetteur (MDT-77) est égal à "23", l'identifiant (MDT-38) doit être renseigné.
        Veuillez vous assurer que l'élément "ram:GlobalID" est présent dans "ram:IssuerTradeParty".
      </assert>
      
      <!-- MDT-77 = 305 → MDT-38 ne doit pas être renseignée -->
      <assert test="ram:RoleCode != '305' or not(ram:GlobalID)"
        flag="warning"
        id="BR-FR-CDV-07_MDT-38_no">
        BR-FR-CDV-07/MDT-38 : Lorsque le rôle du partenaire commercial émetteur (MDT-77) est égal à "305", l'identifiant (MDT-38) ne doit pas être renseigné.
        Veuillez retirer l'élément "ram:GlobalID" de "ram:IssuerTradeParty" dans ce cas.
      </assert>
      
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-08">
    <title>BR-FR-CDV-08 — Obligation conditionnelle de MDT-73</title>
    
    <rule context="rsm:ExchangedDocument/ram:RecipientTradeParty">
      <assert test="(ram:RoleCode = 'WK' or ram:RoleCode = 'DFH') or ram:URIUniversalCommunication/ram:URIID"
        flag="warning"
        id="BR-FR-CDV-08_MDT-73">
        BR-FR-CDV-08/MDT-73 : Lorsque le rôle du destinataire (MDT-59) est différent de "WK" ou "DFH", l'adresse électronique du destinataire (MDT-73) est obligatoire.
        Veuillez vous assurer que l’élément "ram:URIID" est bien présent dans "ram:URIUniversalCommunication".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-09">
    <title>BR-FR-CDV-09 — Présence et valeur de MDT-77</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:TypeCode">
      <assert test=". = '23' or . = '305'"
        flag="warning"
        id="BR-FR-CDV-09_MDT-77">
        BR-FR-CDV-09/MDT-77 : Le code de type de document (MDT-77) est obligatoire et doit être égal à "23" ou "305".
        Valeur actuelle : "<value-of select='.'/>". Veuillez corriger cette valeur si nécessaire.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-10">
    <title>BR-FR-CDV-10 — Présence obligatoire de MDT-87</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerAssignedID">
      <assert test="." 
        flag="warning" 
        id="BR-FR-CDV-10_MDT-87">
        BR-FR-CDV-10/MDT-87 : L'identifiant de la facture référencée (MDT-87) est obligatoire.
        Veuillez vous assurer que l’élément "ram:IssuerAssignedID" est bien présent dans "rsm:ReferenceReferencedDocument".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-11">
    <title>BR-FR-CDV-11 — Présence obligatoire de MDG-35</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument">
      <assert test="ram:FormattedIssueDateTime or rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = '501'" 
        flag="warning" 
        id="BR-FR-CDV-11_MDG-35">
        BR-FR-CDV-11/MDG-35 : La date d’émission formatée de la facture référencée (MDG-35) est obligatoire,
        sauf si MDT-105 (code statut) est égal à "501" (IRRECEVABLE).
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-12">
    <title>BR-FR-CDV-12 — Présence obligatoire de MDT-105</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode">
      <assert test="." 
        flag="warning" 
        id="BR-FR-CDV-12_MDT-105">
        BR-FR-CDV-12/MDT-105 : Le code de condition de traitement (MDT-105) est obligatoire.
        Veuillez vous assurer que l’élément "ram:ProcessConditionCode" est bien présent dans "rsm:ReferenceReferencedDocument".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-13">
    <title>BR-FR-CDV-13 — Présence obligatoire de MDT-129</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerTradeParty">
      <assert test="ram:GlobalID or /rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = '501'" 
        flag="warning" 
        id="BR-FR-CDV-13_MDT-129">
        BR-FR-CDV-13/MDT-129 : L'identifiant du partenaire commercial émetteur (MDT-129) est obligatoire,
        sauf si MDT-105 (ram:ID dans BusinessProcessSpecifiedDocumentContextParameter) est égal à "501".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-14">
    <title>BR-FR-CDV-14 — Vérification des caractéristiques en cas de statut "Encaissé"</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument">
      <assert test="not(ram:ProcessConditionCode = '212') or 
        ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[
        ram:TypeCode = 'MEN' and ram:ValueAmount
        ]"
        flag="warning"
        id="BR-FR-CDV-14_MDT-207">
        BR-FR-CDV-14/MDT-207 : Lorsque le statut de traitement (MDT-105) est "212" (encaissé), il doit exister au moins un bloc "ram:SpecifiedDocumentCharacteristic" avec :
        - un "ram:TypeCode" égal à "MEN"
        - et une valeur "ram:ValueAmount" renseignée.
        Veuillez vérifier la présence et le contenu de ces éléments.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-15">
    <title>BR-FR-CDV-14 — Vérification des caractéristiques en cas de statut "Encaissé"</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode">
      <assert test="not((.) = '210' or (.) = '213' or (.) = '501' or (.) = '207' or (.) = '206' or (.) = '208') or (((.) = '210' or (.) = '213' or (.) = '501' or (.) = '207' or (.) = '206' or (.) = '208') and ../ram:SpecifiedDocumentStatus/ram:ReasonCode)"
        flag="warning"
        id="BR-FR-CDV-15_MDT-113">
        BR-FR-CDV-15/MDT-113 : Code Statut : "<value-of select='.'/>" : lorsque le statut (MDT-105 ou MDT-115) est égal à 210 (Refusée), 123 (Rejetée), 501 (Irrecevable), 207 (Litige), 206 (Suspendue) pu 208 (Approuvée Partiellement), lors un MOTIF (MDT-113) DOIT être présent.
        Veuillez vérifier la présence et le contenu du MOTIF (MDT-113).
      </assert>
    </rule>
    
  </pattern>
  
  
  
  <pattern id="BR-FR-CDV-CL-01"> <!-- CYS3 : test différent pour CDV PPF -->
    <title>BR-FR-CDV-CL-01 — Liste fermée de valeurs pour MDT-2</title>
    
    <rule context="rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext">
      <let name="TestPPF" value="(count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID) = 1 and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID[@schemeID='0238'] = '9998' and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode = 'DFH')"/>
      <assert test="(not($TestPPF) and (./ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = 'REGULATED' or . = 'NON_REGULATED' or . = 'B2C' or . = 'B2BINT' or . = 'OUTOFSCOPE')) or ($TestPPF and (string-length(normalize-space(./ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID)) &lt;= 3))"
        flag="warning"
        id="BR-FR-CDV-CL-01_MDT-2">
        BR-FR-CDV-CL-01/MDT-2 : La valeur de MDT-2 doit être l'une des suivantes : "REGULATED", "NON_REGULATED", "B2C", "B2BINT", "OUTOFSCOPE" sauf pour un CDV pour le PPF pourlequel le nombre de caractères DOIT être inférieur à 3. 
        Valeur actuelle : CDV PPF ? (true) : "<value-of select='$TestPPF'/>" - Valeur MDT-2 : "<value-of select='./ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID'/>". Veuillez corriger cette valeur si nécessaire.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-02"> <!-- CYS3 not(../...) -->
    <title>BR-FR-CDV-CL-02 — Contrôle de cohérence entre MDT-77 et MDT-21</title>
    
    <rule context="rsm:ExchangedDocument">
      <assert test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '305') or 
        ram:SenderTradeParty/ram:RoleCode = 'WK'"
        flag="warning"
        id="BR-FR-CDV-CL-02_MDT-21_305">
        BR-FR-CDV-CL-02/MDT-21 : Lorsque le statut (MDT-77) est "305", le rôle du partenaire commercial émetteur (MDT-21) doit être "WK".
        Valeur actuelle : "<value-of select='ram:SenderTradeParty/ram:RoleCode'/>".
      </assert>
      
      <assert test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '23') or 
        ram:SenderTradeParty/ram:RoleCode = 'BY' or
        ram:SenderTradeParty/ram:RoleCode = 'AB' or
        ram:SenderTradeParty/ram:RoleCode = 'DL' or
        ram:SenderTradeParty/ram:RoleCode = 'SE' or
        ram:SenderTradeParty/ram:RoleCode = 'SR' or
        ram:SenderTradeParty/ram:RoleCode = 'WK' or
        ram:SenderTradeParty/ram:RoleCode = 'PE' or
        ram:SenderTradeParty/ram:RoleCode = 'PR' or
        ram:SenderTradeParty/ram:RoleCode = 'II' or
        ram:SenderTradeParty/ram:RoleCode = 'IV'"
        flag="warning"
        id="BR-FR-CDV-CL-02_MDT-21_23">
        BR-FR-CDV-CL-02/MDT-21 : Lorsque le statut (MDT-77) est "23", le rôle du partenaire commercial émetteur (MDT-21) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "WK", "PE", "PR", "II", "IV".
        Valeur actuelle : "<value-of select='ram:SenderTradeParty/ram:RoleCode'/>".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-03">
    <title>BR-FR-CDV-CL-03 — Contrôle de cohérence entre MDT-77 et MDT-40</title>
    
    <rule context="rsm:ExchangedDocument">
      <!-- Si MDT-77 = 305, alors MDT-40 = WK - CYS3 not(../...) -->
      <assert test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '305') or 
        ram:IssuerTradeParty/ram:RoleCode = 'WK'"
        flag="warning"
        id="BR-FR-CDV-CL-03_MDT-40_305">
        BR-FR-CDV-CL-03/MDT-40 : Lorsque le statut (MDT-77) est "305", le rôle du partenaire commercial émetteur (MDT-40) doit être "WK".
        Valeur actuelle : "<value-of select='ram:IssuerTradeParty/ram:RoleCode'/>".
      </assert>
      
      <!-- Si MDT-77 = 23, alors MDT-40 ∈ liste -CYS3 not(../...) -->
      <assert test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '23') or 
        ram:IssuerTradeParty/ram:RoleCode = 'BY' or
        ram:IssuerTradeParty/ram:RoleCode = 'AB' or
        ram:IssuerTradeParty/ram:RoleCode = 'DL' or
        ram:IssuerTradeParty/ram:RoleCode = 'SE' or
        ram:IssuerTradeParty/ram:RoleCode = 'SR' or
        ram:IssuerTradeParty/ram:RoleCode = 'PE' or
        ram:IssuerTradeParty/ram:RoleCode = 'PR' or
        ram:IssuerTradeParty/ram:RoleCode = 'II' or
        ram:IssuerTradeParty/ram:RoleCode = 'IV'"
        flag="warning"
        id="BR-FR-CDV-CL-03_MDT-40_23">
        BR-FR-CDV-CL-03/MDT-40 : Lorsque le statut (MDT-77) est "23", le rôle du partenaire commercial émetteur (MDT-40) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "PE", "PR", "II", "IV".
        Valeur actuelle : "<value-of select='ram:IssuerTradeParty/ram:RoleCode'/>".
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-04">
    <title>BR-FR-CDV-CL-04 — Liste fermée de valeurs pour MDT-59</title>
    
    <rule context="rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode">
      <assert test=". = 'BY' or . = 'AB' or . = 'DL' or . = 'SE' or . = 'SR' or 
        . = 'PE' or . = 'PR' or . = 'II' or . = 'IV' or . = 'WK' or . = 'DFH'"
        flag="warning"
        id="BR-FR-CDV-CL-04_MDT-59">
        BR-FR-CDV-CL-04/MDT-59 : Le rôle du partenaire commercial destinataire (MDT-59) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "PE", "PR", "II", "IV", "WK", "DFH".
        Valeur actuelle : "<value-of select='.'/>". Veuillez corriger cette valeur si nécessaire.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-05">
    <title>BR-FR-CDV-CL-05 — Contrôle des statuts MDT-88 selon MDT-77</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument">
      
      <!-- Phase Transmission : MDT-77 = 305 - CYS3 ../ram:TypeCode + valeur absente -->
      <assert test="../ram:TypeCode != '305' or 
        ram:StatusCode = '10' or 
        ram:StatusCode = '51' or 
        ram:StatusCode = '43' or 
        ram:StatusCode = '8' or 
        ram:StatusCode = '48' or
        not(ram:StatusCode)"
        flag="warning"
        id="BR-FR-CDV-CL-05_MDT-88_305">
        BR-FR-CDV-CL-05/MDT-88 : Lorsque MDT-77 = "305" (Phase Transmission), siprésent, MDT-88 doit être l’un des codes suivants :
        "10", "51", "43", "8", "48".
        Valeur actuelle : "<value-of select='ram:StatusCode'/>".
      </assert>
      
      <!-- Phase Traitement : MDT-77 = 23 - CYS3 ../ram:TypeCode + valeur absente -->
      <assert test="../ram:TypeCode != '23' or 
        ram:StatusCode = '45' or 
        ram:StatusCode = '39' or 
        ram:StatusCode = '37' or 
        ram:StatusCode = '50' or 
        ram:StatusCode = '49' or 
        ram:StatusCode = '47' or 
        ram:StatusCode = '46' or 
        ram:StatusCode = '1'or
        not(ram:StatusCode)"
        flag="warning"
        id="BR-FR-CDV-CL-05_MDT-88_23">
        BR-FR-CDV-CL-05/MDT-88 : Lorsque MDT-77 = "23" (Phase Traitement), si présent, MDT-88 doit être l’un des codes suivants :
        "45", "39", "37", "50", "49", "47", "46", "1".
        Valeur actuelle : "<value-of select='ram:StatusCode'/>".
      </assert>
      
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-06">
    <title>BR-FR-CDV-CL-06 — Liste fermée de codes statuts de facture</title>
    
    <!-- MDT-105 -->
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode">
      <assert test="custom:is-valid-invoice-status-code(.)"
        flag="warning"
        id="BR-FR-CDV-CL-06_MDT-105">
        BR-FR-CDV-CL-06/MDT-105 : Le code de statut de facture (MDT-105) doit être dans la liste des codes autorisés :
        "200", "201", ..., "228".
        Valeur actuelle : "<value-of select='.'/>".
      </assert>
    </rule>
    
    <!-- MDT-115 -->
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:ProcessConditionCode">
      <assert test="custom:is-valid-invoice-status-code(.)"
        flag="warning"
        id="BR-FR-CDV-CL-06_MDT-115">
        BR-FR-CDV-CL-06/MDT-115 : Le code de statut de facture (MDT-115) doit être dans la liste des codes autorisés :
        "200", "201", ..., "228".
        Valeur actuelle : "<value-of select='.'/>".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-07">
    <title>BR-FR-CDV-CL-07 — Vérification de la valeur de MDT-132</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerTradeParty/ram:RoleCode">
      <assert test=". = 'SE'" 
        flag="warning" 
        id="BR-FR-CDV-CL-07_MDT-132">
        BR-FR-CDV-CL-07/MDT-132 : Le rôle du partenaire commercial émetteur (MDT-132) doit être "SE" (Vendeur).
        Valeur actuelle : "<value-of select='.'/>". Veuillez corriger cette valeur si nécessaire.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-08">
    <title>BR-FR-CDV-CL-08 — Liste fermée de valeurs pour MDT-158</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:RecipientTradeParty/ram:RoleCode">
      <assert test=". = 'BY' or . = 'AB' or . = 'DL' or . = 'SE' or . = 'SR' or 
        . = 'WK' or . = 'DFH' or . = 'PE' or . = 'PR' or 
        . = 'II' or . = 'IV'"
        flag="warning"
        id="BR-FR-CDV-CL-08_MDT-158">
        BR-FR-CDV-CL-08/MDT-158 : Le rôle du partenaire commercial destinataire (MDT-158) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "WK", "DFH", "PE", "PR", "II", "IV".
        Valeur actuelle : "<value-of select='.'/>". Veuillez corriger cette valeur si nécessaire.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-09"> <!-- CYS3 : complété des motifs par statut -->
    <title>BR-FR-CDV-CL-09 — Liste fermée de codes motifs de statuts</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:ReasonCode">
      <assert test="custom:is-valid-status-reason-code(.)"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113">
        BR-FR-CDV-CL-09/MDT-113 : Le code motif de statut (MDT-113) : "<value-of select='.'/>" n'est pas dans la liste des codes autorisés :
        "NON_TRANSMISE", "JUSTIF_ABS", "ROUTAGE_ERR", "AUTRE", "COORD_BANC_ERR", "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_INC", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT", "CMD_ERR", "ADR_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR", "PU_ERR", "REM_ERR", "QTE_ERR", "ART_ERR", "MODPAI_ERR", "QUALITE_ERR", "LIVR_INCOMP", "REJ_SEMAN", "REJ_UNI", "REJ_COH", "REJ_ADR", "REJ_CONT_B2G", "REJ_REF_PJ", "REJ_ASS_PJ", "IRR_VIDE_F", "IRR_TYPE_F", "IRR_SYNTAX", "IRR_TAILLE_PJ", "IRR_NOM_PJ", "IRR_VID_PJ", "IRR_EXT_DOC", "IRR_TAILLE_F", "IRR_ANTIVIRUS".
        Veuillez corriger cette valeur si nécessaire.
      </assert>

      <assert test="(../../ram:ProcessConditionCode != '200' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '200' )) or (../../ram:ProcessConditionCode = '200' and ../ram:ProcessConditionCode != '200' )
        or (.) = 'NON_TRANSMISE'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_200">
        BR-FR-CDV-CL-09/MDT-113_200 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut DÉPOSÉE (200) :
        "NON_TRANSMISE". Veuillez corriger cette valeur si nécessaire.
      </assert>
      
      <assert test="(../../ram:ProcessConditionCode != '213' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '213' )) or (../../ram:ProcessConditionCode = '213' and ../ram:ProcessConditionCode != '213' )
        or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'DOUBLON' or (.) = 'DEST_INC' or (.) = 'ADR_ERR'
        or (.) = 'REJ_SEMAN' or (.) = 'REJ_UNI' or (.) = 'REJ_COH' or (.) = 'REJ_ADR' or (.) = 'REJ_CONT_B2G' or (.) = 'REJ_REF_PJ' or (.) = 'REJ_ASS_PJ'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_213">
        BR-FR-CDV-CL-09/MDT-113_213 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut REJETÉE (213) :
        "MONTANTTOTAL_ERR", "CALCUL_ERR", "DOUBLON", "DEST_INC", "ADR_ERR", "REJ_SEMAN", "REJ_UNI", "REJ_COH", "REJ_ADR", "REJ_CONT_B2G", "REJ_REF_PJ", "REJ_ASS_PJ".
        Veuillez corriger cette valeur si nécessaire.
      </assert>

      <assert test="(../../ram:ProcessConditionCode != '210' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '210' )) or (../../ram:ProcessConditionCode = '210' and ../ram:ProcessConditionCode != '210' )
        or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON' or (.) = 'DEST_ERR'
        or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR' or (.) = 'ADR_ERR' or (.) = 'REF_CT_ABSENT'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_210">
        BR-FR-CDV-CL-09/MDT-113_210 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut REFUSÉE (210) :
        "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT", "CMD_ERR", "ADR_ERR", "REF_CT_ABSENT".
        Veuillez corriger cette valeur si nécessaire.
      </assert>

      <assert test="(../../ram:ProcessConditionCode != '207' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '207' )) or (../../ram:ProcessConditionCode = '207' and ../ram:ProcessConditionCode != '207' )
        or (.) = 'AUTRE' or (.) = 'COORD_BANC_ERR' or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON'
        or (.) = 'DEST_INC' or (.) = 'DEST_ERR' or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR'
        or (.) = 'ADR_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR' or (.) = 'PU_ERR' or (.) = 'REM_ERR'
        or (.) = 'QTE_ERR' or (.) = 'ART_ERR' or (.) = 'MODPAI_ERR' or (.) = 'QUALITE_ERR' or (.) = 'LIVR_INCOMP'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_207">
        BR-FR-CDV-CL-09/MDT-113_207 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut LITIGE (207) :
       "AUTRE", "COORD_BANC_ERR", "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_INC", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT",
        "CMD_ERR", "ADR_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR", "PU_ERR", "REM_ERR", "QTE_ERR", "ART_ERR", "MODPAI_ERR", "QUALITE_ERR", "LIVR_INCOMP".
        Veuillez corriger cette valeur si nécessaire.
      </assert>
      
      <assert test="(../../ram:ProcessConditionCode != '206' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '206' )) or (../../ram:ProcessConditionCode = '206' and ../ram:ProcessConditionCode != '206' )
        or (.) = 'AUTRE' or (.) = 'CMD_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR' or (.) = 'PU_ERR' or (.) = 'REM_ERR'
        or (.) = 'QTE_ERR' or (.) = 'ART_ERR' or (.) = 'MODPAI_ERR' or (.) = 'QUALITE_ERR' or (.) = 'LIVR_INCOMP'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_206">
        BR-FR-CDV-CL-09/MDT-113_206 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut APPROUVÉE PARTIELLEMENT (206) :
        "AUTRE", "CMD_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR", "PU_ERR", "REM_ERR", "QTE_ERR", "ART_ERR", "MODPAI_ERR", "QUALITE_ERR", "LIVR_INCOMP".
        Veuillez corriger cette valeur si nécessaire.
      </assert>
      
      <assert test="(../../ram:ProcessConditionCode != '208' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '208' )) or (../../ram:ProcessConditionCode = '208' and ../ram:ProcessConditionCode != '208' )
        or (.) = 'JUSTIF_ABS' or (.) = 'COORD_BANC_ERR' or (.) = 'CMD_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_208">
        BR-FR-CDV-CL-09/MDT-113_208 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut SUSPENDUE (208) :
        "JUSTIF_ABS", "COORD_BANC_ERR", "CMD_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR".
        Veuillez corriger cette valeur si nécessaire.
      </assert>
      
      <assert test="(../../ram:ProcessConditionCode != '221' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '221' )) or (../../ram:ProcessConditionCode = '221' and ../ram:ProcessConditionCode != '221' )
        or (.) = 'ROUTAGE_ERR'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_221">
        BR-FR-CDV-CL-09/MDT-113_221 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut ERREUR_ROUTAGE (221) :
        "ROUTAGE_ERR". Veuillez corriger cette valeur si nécessaire.
      </assert>
      
      <assert test="(../../ram:ProcessConditionCode != '501' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '501' )) or (../../ram:ProcessConditionCode = '501' and ../ram:ProcessConditionCode != '501' )
        or (.) = 'IRR_VIDE_F'  or (.) = 'IRR_TYPE_F'  or (.) = 'IRR_SYNTAX'  or (.) = 'IRR_TAILLE_PJ'  or (.) = 'IRR_NOM_PJ'  or (.) = 'IRR_VID_PJ'  or (.) = 'IRR_EXT_DOC'  or (.) = 'IRR_TAILLE_F'  or (.) = 'IRR_ANTIVIRUS'"
        flag="warning"
        id="BR-FR-CDV-CL-09_MDT-113_501">
        BR-FR-CDV-CL-09/MDT-113_501 : Le code motif de statut (MDT-113) : "<value-of select='.'/>", n'est pas dans la liste des codes autorisés pour le statut IRRECEVABLE (501) :
        "IRR_VIDE_F", "IRR_TYPE_F", "IRR_SYNTAX", "IRR_TAILLE_PJ", "IRR_NOM_PJ", "IRR_VID_PJ", "IRR_EXT_DOC, "IRR_TAILLE_F", "IRR_ANTIVIRUS". Veuillez corriger cette valeur si nécessaire.
      </assert>
      
      
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-10">
    <title>BR-FR-CDV-CL-10 — Liste fermée de codes actions de facture</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:RequestedActionCode">
      <assert test="custom:is-valid-invoice-action-code(.)"
        flag="warning"
        id="BR-FR-CDV-CL-10_MDT-121">
        BR-FR-CDV-CL-10/MDT-121 : Le code d'action de facture (MDT-121) doit être dans la liste des codes autorisés :
        "NOA", "PIN", "NIN", "CNF", "CNP", "CNA", "OTH".
        Valeur actuelle : "<value-of select='.'/>". Veuillez corriger cette valeur si nécessaire.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CDV-CL-11">
    <title>BR-FR-CDV-CL-11 — Liste fermée de codes pour MDT-207</title>
    
    <rule context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic/ram:TypeCode">
      <assert test=". = 'MEN' or . = 'MPA' or . = 'RAP' or . = 'ESC' or . = 'RAB' or . = 'REM' or . = 'MAP' or . = 'MAPTTC' or . = 'MNA' or . = 'MNATTC' or . = 'CBB' or . = 'DIV' or . = 'DVA' or . = 'MAJ'"
        flag="warning"
        id="BR-FR-CDV-CL-11_MDT-207">
        BR-FR-CDV-CL-11/MDT-207 : La valeur du TypeCode (MDT-207) doit appartenir à la liste fermée des codes autorisés :
        MEN, MPA, RAP, ESC, RAB, REM, MAP, MAPTTC, MNA, MNATTC, CBB, DIV, DVA, MAJ.
        Valeur actuelle : "<value-of select='.'/>". Veuillez corriger cette valeur si elle ne correspond pas à un code valide.
      </assert>
    </rule>
  </pattern>
  
  
  
</schema>