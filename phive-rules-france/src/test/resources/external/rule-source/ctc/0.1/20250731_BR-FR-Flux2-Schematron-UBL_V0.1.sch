<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:custom="http://www.example.org/custom"
  queryBinding="xslt2"
  xsl:exclude-result-prefixes="xs custom">
  
  <ns prefix="custom" uri="http://www.example.org/custom"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  
  
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
    
    <!-- Vérifie le format AAAA-MM-JJ -->
    <xsl:variable name="isFormatValid" select="matches($date, '^20\d{2}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$')"/>
    
    <!-- Extraction des composantes -->
    <xsl:variable name="year" select="number(substring($date, 1, 4))"/>
    <xsl:variable name="month" select="number(substring($date, 6, 2))"/>
    <xsl:variable name="day" select="number(substring($date, 9, 2))"/>
    
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
     

  <!-- Règles de validation UBL -->
  <pattern id="BR-FR-01">
    <title>BR-FR-01 — Validation de la longueur et du format des identifiants de facture</title>
    
    <!-- BT-1 : Invoice identifier -->
    <rule context="ubl:Invoice/cbc:ID | cn:CreditNote/cbc:ID">
      <assert test="string-length(.) le 35" flag="warning">
        BR-FR-01/BT-1 : L'identifiant de facture (cbc:ID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </assert>
      <assert test="custom:is-valid-id-format(.)" flag="warning">
        BR-FR-01/BT-1 : L'identifiant de facture (cbc:ID) contient des caractères non autorisés. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </assert>
    </rule>
    
    <!-- BT-25 : Referenced invoice ID in header -->
    <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID | cn:CreditNote/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
      <assert test="string-length(.) le 35" flag="warning">
        BR-FR-01/BT-25 : L'identifiant de facture référencée (cbc:ID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </assert>
      <assert test="custom:is-valid-id-format(.)" flag="warning">
        BR-FR-01/BT-25 : L'identifiant de facture référencée (cbc:ID) contient des caractères non autorisés. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-136 : Referenced invoice ID at line level -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:ID | cn:CreditNote/cac:CreditNoteLine/cac:DocumentReference/cbc:ID">
      <assert test="string-length(.) le 35" flag="warning">
        BR-FR-01/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (cbc:ID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </assert>
      <assert test="custom:is-valid-id-format(.)" flag="warning">
        BR-FR-01/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (cbc:ID) contient des caractères non autorisés. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-02">
    <title>BR-FR-02 — Validation du format des identifiants de facture</title>
    
    <!-- BT-1 : Invoice identifier -->
    <rule context="ubl:Invoice/cbc:ID | cn:CreditNote/cbc:ID">
      <assert test="custom:is-valid-id-format(.)" flag="warning">
        BR-FR-02/BT-1 : L'identifiant de facture (cbc:ID) doit être composé uniquement de caractères alphanumériques (A-Z, a-z, 0-9) et peut contenir les caractères spéciaux autorisés : tiret (-), plus (+), tiret bas (_), barre oblique (/). Il ne doit pas contenir uniquement des espaces, ni commencer ou se terminer par un espace, ni contenir d'espaces consécutifs. Valeur actuelle : "<value-of select='.'/>".
        Veuillez corriger le format de l'identifiant.
      </assert>
    </rule>
    
    <!-- BT-25 : Referenced invoice ID in header -->
    <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID | cn:CreditNote/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
      <assert test="custom:is-valid-id-format(.)" flag="warning">
        BR-FR-02/BT-25 : L'identifiant de facture référencée (cbc:ID) doit respecter le format autorisé : caractères alphanumériques et les symboles - + _ /. Il ne doit pas contenir uniquement des espaces, ni commencer ou se terminer par un espace, ni contenir d'espaces consécutifs. Valeur actuelle : "<value-of select='.'/>".
        Veuillez corriger le format de l'identifiant.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-136 : Referenced invoice ID at line level -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:ID | cn:CreditNote/cac:CreditNoteLine/cac:DocumentReference/cbc:ID">
      <assert test="custom:is-valid-id-format(.)" flag="warning">
        EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (cbc:ID) doit respecter le format autorisé : caractères alphanumériques et les symboles - + _ /. Il ne doit pas contenir uniquement des espaces, ni commencer ou se terminer par un espace, ni contenir d'espaces consécutifs. Valeur actuelle : "<value-of select='.'/>".
        Veuillez corriger le format de l'identifiant.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-03">
    <title>BR-FR-03 — Validation de l'année dans les dates (2000–2099)</title>
    
    <!-- BT-2 -->
    <rule context="ubl:Invoice/cbc:IssueDate | cn:CreditNote/cbc:IssueDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-2 : La date d’émission (udt:DateTimeString) doit contenir une année comprise entre 2000 et 2099, au format AAAAMMJJ. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l’année est correcte et que le format est conforme.
      </assert>
    </rule>
    
    <!-- BT-7 -->
    <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxPointDate | cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxPointDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-7 : La date de fait générateur de la taxe (udt:DateString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-9 -->
    <rule context="ubl:Invoice/cbc:DueDate | cn:CreditNote/cbc:DueDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-9 : La date d’échéance (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-26 -->
    <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate | cn:CreditNote/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-26 : La date d’émission de la facture référencée (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-72 -->
    <rule context="ubl:Invoice/cac:Delivery/cbc:ActualDeliveryDate | cn:CreditNote/cac:Delivery/cbc:ActualDeliveryDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-72 : La date de livraison effective (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-73 -->
    <rule context="ubl:Invoice/cac:InvoicePeriod/cbc:StartDate | cn:CreditNote/cac:InvoicePeriod/cbc:StartDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-73 : La date de début de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-74 -->
    <rule context="ubl:Invoice/cac:InvoicePeriod/cbc:EndDate | cn:CreditNote/cac:InvoicePeriod/cbc:EndDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-74 : La date de fin de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-138 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:IssueDate | cn:CreditNote/cac:CreditNoteLine/cac:DocumentReference/cbc:IssueDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        EXT-FR-FE-138 : La date d’émission de la facture référencée en ligne (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-158 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:Delivery/cbc:ActualDeliveryDate | cn:CreditNote/cac:CreditNoteLine/cac:Delivery/cbc:ActualDeliveryDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        EXT-FR-FE-158 : La date de livraison effective en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-134 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | cn:CreditNote/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-134 : La date de début de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
    
    <!-- BT-135 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | cn:CreditNote/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
      <assert test="custom:is-valid-date-format(.)" flag="warning">
        BR-FR-03/BT-135 : La date de fin de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier la validité de la date.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-04">
    <title>BR-FR-04 — Validation du code type de document</title>
    
    <!-- BT-3 -->
    <rule context="ubl:Invoice/cbc:InvoiceTypeCode | cn:CreditNote/cbc:InvoiceTypeCode">
      <assert test=". = ('380','389','393','501','386','500','384','471','472','473','261','262','381','396','502','503')" flag="warning">
        BR-FR-04/BT-3 : Le code type de document (cbc:InvoiceTypeCode") n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<value-of select='.'/>".
        Veuillez utiliser un code conforme à la liste autorisée. Les autres codes définis dans la norme UNTDID 1001 ne doivent pas être utilisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-02 -->
    <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode | cn:CreditNote/cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode">
      <assert test=". = ('380','389','393','501','386','500','384','471','472','473','261','262','381','396','502','503')" flag="warning">
        BR-FR-04/EXT-FR-FE-02 : Le code type de document référencé (cbc:DocumentTypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<value-of select='.'/>".
        Veuillez utiliser un code conforme à la liste autorisée.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-137 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode | cn:CreditNote/cac:CreditNoteLine/cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode">
      <assert test=". = ('380','389','393','501','386','500','384','471','472','473','261','262','381','396','502','503')" flag="warning">
        BR-FR-04/EXT-FR-FE-137 : Le code type de document référencé en ligne (cbc:DocumentTypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<value-of select='.'/>".
        Veuillez utiliser un code conforme à la liste autorisée.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-05">
    <title>BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-3)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="allNotes" value="string-join(./cbc:Note, '')"/>
      <assert test="contains($allNotes, '#PMT#')">
        BR-FR-05/BT-22 : La mention relative aux frais de recouvrement (code PMT) est absente. Elle est obligatoire dans les notes (BG-3).
      </assert>
      <assert test="contains($allNotes, '#PMD#')">
        BR-FR-05/BT-22 : La mention relative aux pénalités de retard (code PMD) est absente. Elle est obligatoire dans les notes (BG-3).
      </assert>
      <assert test="contains($allNotes, '#AAB#')">
        BR-FR-05/BT-22 : La mention relative à l’escompte ou à son absence (code AAB) est absente. Elle est obligatoire dans les notes (BG-3).
      </assert>
    </rule>  
  </pattern>
  
  <pattern id="BR-FR-06">
    <title>BR-FR-06 — Unicité des codes sujets dans les notes (BG-3)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="allNotes" value="string-join(./cbc:Note, '')"/>
      <assert test="count(tokenize($allNotes, '#PMT#')) - 1  le 1">
        BR-FR-06/BT-21 : Le code sujet PMT (indemnité forfaitaire pour frais de recouvrement) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
      <assert test="count(tokenize($allNotes, '#PMD#')) - 1  le 1">
        BR-FR-06/BT-21 : Le code sujet PMD (pénalités de retard) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
      <assert test="count(tokenize($allNotes, '#AAB#')) - 1  le 1">
        BR-FR-06/BT-21 : Le code sujet AAB (mention d’escompte ou d’absence d’escompte) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
      <assert test="count(tokenize($allNotes, '#TXD#')) - 1  le 1">
        BR-FR-06/BT-21 : Le code sujet TXD (mention de taxe) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
    </rule> 
  </pattern>
  
  <pattern id="BR-FR-08">
    <title>BR-FR-08 — Validation du mode de facturation (BT-23)</title>
    
    <rule context="ubl:Invoice/cbc:ProfileID | cn:CreditNote/cbc:ProfileID">
      <assert test="custom:is-valid-billing-mode(.)" flag="warning">
        BR-FR-08/BT-23 : La valeur du mode de facturation (ram:ID) n’est pas autorisée. Valeurs acceptées : B1, S1, M1, B2, S2, M2, B4, S4, M4, S5, S6, B7, S7.
        Valeur actuelle : "<value-of select='.'/>".
        Veuillez utiliser une valeur conforme à la liste des modes de facturation autorisés.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-09">
    <title>BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)</title>
    
    <!-- BT-29 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party | cn:CreditNote/cac:AccountingSupplierParty/cac:Party">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002']"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/BT-29 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- BT-46 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party | cn:CreditNote/cac:AccountingCustomerParty/cac:Party">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002']"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/BT-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- BT-60 -->
    <rule context="ubl:Invoice/cac:PayeeParty | cn:CreditNote/cac:PayeeParty">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/BT-60 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-06 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:AgentParty | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:AgentParty">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/EXT-FR-FE-06 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-46 -->
    <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty | cn:CreditNote/cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/EXT-FR-FE-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-69 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:AgentParty | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:AgentParty">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/EXT-FR-FE-69 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-92 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/EXT-FR-FE-92 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-115 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party">
      <let name="siret" value="cac:PartyIdentification/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/EXT-FR-FE-115 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- BT-71 -->
    <rule context="ubl:Invoice/cac:Delivery | cn:CreditNote/cac:Delivery">
      <let name="siret" value="cac:DeliveryLocation/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:DeliveryParty/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:DeliveryParty/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/BT-71 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-146 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:Delivery/cac:DeliveryLocation | cn:CreditNote/cac:CreditNoteLine/cac:Delivery/cac:DeliveryLocation">
      <let name="siret" value="cac:DeliveryLocation/cbc:ID[@schemeID='0009']"/>
      <let name="siren" value="if (string(cac:DeliveryParty/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'])) then cac:DeliveryParty/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret, $siren)" flag="warning">
        BR-FR-09/EXT-FR-FE-146 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select='$siret'/>", SIREN : "<value-of select='$siren'/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-10">
    <title>BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)</title>
    
    <rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity">
      <let name="siren" value="cbc:CompanyID[@schemeID='0002']"/>
      <assert test="$siren and matches(normalize-space($siren), '^\d{9}$')">
        BR-FR-10/BT-30 : Le SIREN du vendeur (CompanyID[@schemeID='0002']) est obligatoire et doit être composé exactement de 9 chiffres. 
        Valeur actuelle : "<value-of select="$siren"/>". Veuillez renseigner un identifiant SIREN valide.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-11"> 
    <title>BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="allNotes" value="string-join(./cbc:Note, '')[contains(., '#BAR#')]"/>
      <let name="afterBar" value="substring-after($allNotes, '#BAR#')"/>
      <let name="barTreatment" value="if (contains($afterBar, '#')) then substring-before($afterBar, '#') else $afterBar"/> 
      <let name="siren" value="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002']"/>
      
      <assert test="not($barTreatment='B2B') or ($siren and matches(normalize-space($siren), '^\d{9}$'))" flag="warning">
        BR-FR-11/BT-47 : Si une note contient le code sujet BAR avec la valeur 'B2B', alors le SIREN de l’acheteur (cbc:ID[@schemeID='0002']) est obligatoire et doit être composé exactement de 9 chiffres.
        Valeur actuelle : "<value-of select="$siren"/>". Veuillez renseigner un identifiant SIREN valide.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-12">
    <title>BR-FR-12 — Vérification de la présence du BT-49</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="endpointID" value="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
      
      <assert test="normalize-space($endpointID) != ''" flag="warning">
        BR-FR-12/BT-49 : Le BT-49 (cbc:EndpointID) est obligatoire. Valeur actuelle : BT-49="<value-of select="$endpointID"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-13">
    <title>BR-FR-13 — Vérification de la présence du BT-34</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="endpointID" value="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID"/>
      
      <assert test="normalize-space($endpointID) != ''" flag="warning">
        BR-FR-13/BT-34 : Le BT-34 (cbc:EndpointID du vendeur) est obligatoire. Valeur actuelle : BT-34="<value-of select="$endpointID"/>".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-15">
    <title>BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)</title>
      
    <!-- BT-95 et BT-102 -->
    <rule context="cac:AllowanceCharge/cac:TaxCategory">
      <let name="categoryCode" value="cbc:ID"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning">
        BR-FR-15/BT-95/BT-102 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select='$categoryCode'/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning">
        BR-FR-15/BT-95/BT-102 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select='$categoryCode'/>".
      </assert>
    </rule>
    
    <!-- BT-118 -->
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory">
      <let name="categoryCode" value="cbc:ID"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning">
        BR-FR-15/BT-118 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select='$categoryCode'/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning">
        BR-FR-15/BT-118 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select='$categoryCode'/>".
      </assert>
    </rule>
    
    <!-- BT-151 -->
    <rule context="cac:Item/cac:ClassifiedTaxCategory">
      <let name="categoryCode" value="cbc:ID"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning">
        BR-FR-15/BT-151 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select='$categoryCode'/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning">
        BR-FR-15/BT-151 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select='$categoryCode'/>".
      </assert>
    </rule> 
  </pattern>
  <pattern id="BR-FR-16">
    <title>BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)</title>
    
    <!-- BT-96 -->
    <rule context="cac:AllowanceCharge/cac:TaxCategory">
      <let name="vatRate" value="cbc:Percent"/>
      <assert test="not($vatRate) or custom:is-valid-vat-rate($vatRate)" flag="warning">
        BR-FR-16/BT-96 : Le taux de TVA (cbc:Percent) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select='$vatRate'/>".
      </assert>
    </rule>
    
    <!-- BT-103 -->
    <rule context="cac:AllowanceCharge/cac:TaxCategory">
      <let name="vatRate" value="cbc:Percent"/>
      <assert test="not($vatRate) or custom:is-valid-vat-rate($vatRate)" flag="warning">
        BR-FR-16/BT-103 : Le taux de TVA (cbc:Percent) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select='$vatRate'/>".
      </assert>
    </rule>
    
    <!-- BT-119 -->
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory">
      <let name="vatRate" value="cbc:Percent"/>
      <assert test="not($vatRate) or custom:is-valid-vat-rate($vatRate)" flag="warning">
        BR-FR-16/BT-119 : Le taux de TVA (cbc:Percent) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select='$vatRate'/>".
      </assert>
    </rule>
    
    <!-- BT-152 -->
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory">
      <let name="vatRate" value="cbc:Percent"/>
      <assert test="not($vatRate) or custom:is-valid-vat-rate($vatRate)" flag="warning">
        BR-FR-16/BT-152 : Le taux de TVA (cbc:Percent) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select='$vatRate'/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-17">
    <title>BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)</title>
    
    <rule context="cac:AdditionalDocumentReference">
      <let name="docTypeDESC" value="cbc:DocumentDescription"/>
      
      <assert test="cbc:DocumentTypeCode or custom:is-valid-attachment-code($docTypeDESC)" flag="warning">
        BR-FR-17/BT-123 : Le code de qualification de la pièce jointe "<value-of select='$docTypeDESC'/>" est invalide. Il doit appartenir à la liste des codes autorisés. Veuillez corriger la valeur de BT-123.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-18">
    <title>BR-FR-18 — Un seul document additionnel avec la description "LISIBLE" (BT-123)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="lisibleCount" value="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'LISIBLE'])"/>
      
      <assert test="$lisibleCount le 1" flag="warning">
        BR-FR-18/BT-123 : Il ne peut y avoir <value-of select="'qu’un seul'"/> document additionnel (cac:AdditionalDocumentReference) dont la description (cbc:DocumentDescription) est "LISIBLE".
        Nombre de documents trouvés : <value-of select="$lisibleCount"/>.
        Veuillez supprimer les doublons ou corriger les descriptions.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-20">
    <title>BR-FR-20 — Vérification du traitement associé à une note avec code sujet "BAR" (BT-21)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="allNotes" value="string-join(./cbc:Note, '')[contains(., '#BAR#')]"/>
      <let name="afterBar" value="substring-after($allNotes, '#BAR#')"/>
      <let name="barTreatment" value="if (contains($afterBar, '#')) then substring-before($afterBar, '#') else $afterBar"/>    
      <let name="invalidNotes" value="$barTreatment != '' and $barTreatment != 'B2B' and $barTreatment != 'B2BINT' and $barTreatment != 'B2C' and $barTreatment != 'OUTOFSCOPE' and $barTreatment != 'ARCHIVEONLY'"/>
      
      <assert test="not($invalidNotes)" flag="warning">
        BR-FR-20/BT-21 : Lorsqu’une note a pour code sujet « BAR » (cbc:SubjectCode), la valeur associée (cbc:Note) doit être l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<value-of select="$barTreatment"/>". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-21">
    <title>BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="allNotes" value="string-join(./cbc:Note, '')[contains(., '#BAR#')]"/>
      <let name="afterBar" value="substring-after($allNotes, '#BAR#')"/>
      <let name="treatment" value="if (contains($afterBar, '#')) then substring-before($afterBar, '#') else $afterBar"/>   
      <let name="typeCode" value="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>
      <let name="siren" value="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002']"/>
      <let name="endpointID" value="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
      <let name="schemeID" value="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID"/>
      
      <assert test="not($treatment='B2B') or $typeCode = ('389', '501', '500', '471', '473', '261', '502') or (starts-with($endpointID, $siren) and $schemeID = '0225')" flag="warning">
        BR-FR-21/BT-49 : Si le traitement est BAR/B2B et que le type de document (cbc:InvoiceTypeCode) n’est pas en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-49 (cbc:EndpointID) doit commencer par le SIREN (cbc:ID[@schemeID='0002']) et le schemeID doit être égal à "0225".
        Valeurs actuelles : BAR = "<value-of select='$treatment'/>", EndpointID="<value-of select='$endpointID'/>", schemeID="<value-of select='$schemeID'/>", SIREN="<value-of select='$siren'/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-22">
    <title>BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="allNotes" value="string-join(./cbc:Note, '')[contains(., '#BAR#')]"/>
      <let name="afterBar" value="substring-after($allNotes, '#BAR#')"/>
      <let name="treatment" value="if (contains($afterBar, '#')) then substring-before($afterBar, '#') else $afterBar"/>   
      <let name="typeCode" value="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>
      <let name="siren" value="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0002']"/>
      <let name="endpointID" value="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID"/>
      <let name="schemeID" value="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID/@schemeID"/>
      
      <assert test="not($treatment) or not($typeCode = ('389', '501', '500', '471', '473', '261', '502')) or 
        (starts-with($endpointID, $siren) and $schemeID = '0225')" flag="warning">
        BR-FR-22/BT-34 : Si le traitement est BAR/B2B et que le type de document (cbc:InvoiceTypeCode) est en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-34 (cbc:EndpointID du vendeur) doit commencer par le SIREN (cbc:ID[@schemeID='0002']) et le schemeID doit être égal à "0225".
        Valeurs actuelles : EndpointID="<value-of select='$endpointID'/>", schemeID="<value-of select='$schemeID'/>", SIREN="<value-of select='$siren'/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-23">
    <title>BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225</title>
    
    <!-- BT-34 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/BT-34 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- BT-49 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/BT-49 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-12 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/EXT-FR-FE-12 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-29 -->
    <rule context="ubl:Invoice/cac:PayeeParty/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:PayeeParty/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/EXT-FR-FE-29 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-52 -->
    <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/EXT-FR-FE-52 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-75 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/EXT-FR-FE-75 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-98 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/EXT-FR-FE-98 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-121 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID[@schemeID='0225'] | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-23/EXT-FR-FE-121 : L'adresse électronique (cbc:EndpointID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-24">
    <title>BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224</title>
    
    <!-- BT-29 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224'] | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-24/BT-29 : L'identifiant privé (cbc:ID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- BT-46 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224'] | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning">
        BR-FR-24/BT-46 : L'identifiant privé (cbc:ID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-25">
    <title>BR-FR-25 — Longueur maximale des adresses électroniques</title>
    
    <!-- BT-34 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/BT-34 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- BT-49 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/BT-49 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-12 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cbc:EndpointID | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/EXT-FR-FE-12 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-29 -->
    <rule context="ubl:Invoice/cac:PayeeParty/cbc:EndpointID | cn:CreditNote/cac:PayeeParty/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/EXT-FR-FE-29 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-52 -->
    <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty/cbc:EndpointID | cn:CreditNote/cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/EXT-FR-FE-52 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-75 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cbc:EndpointID | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/EXT-FR-FE-75 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-98 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/EXT-FR-FE-98 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-121 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cbc:EndpointID">
      <assert test="string-length(.) le 125" flag="warning">
        BR-FR-25/EXT-FR-FE-121 : L'adresse électronique (cbc:EndpointID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-26">
    <title>BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224</title>
    
    <!-- BT-29 -->
    <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224'] | cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224']">
      <assert test="string-length(.) le 100" flag="warning">
        BR-FR-26/BT-29 : L'identifiant privé (cbc:ID) dépasse 100 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- BT-46 -->
    <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224'] | cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0224']">
      <assert test="string-length(.) le 100" flag="warning">
        BR-FR-26/BT-46 : L'identifiant privé (cbc:ID) dépasse 100 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CO-03">
    <title>BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)</title>
    
    <rule context="cn:CreditNote">
      <let name="typeCode" value="cbc:CreditNoteTypeCode"/>
      <let name="contractReference" value="cac:ContractDocumentReference/cbc:ID"/>
      <let name="billingPeriodStart" value="cac:InvoicePeriod/cbc:StartDate"/>
      <let name="billingPeriodEnd" value="cac:InvoicePeriod/cbc:EndDate"/>
      
      <assert test="not($typeCode = '262') or (string($contractReference) and string($billingPeriodStart) and string($billingPeriodEnd))"
        flag="warning">
        BR-FR-CO-03/BT-3 : Si le code type de la facture (BT-3) est égal à 262 (Avoir Remise Globale), alors :
        - Le numéro de contrat (BT-12) doit être présent
        - La période de facturation (BG-14) doit être renseignée (dates de début et de fin).
        Valeurs actuelles : BT-12="<value-of select="$contractReference"/>", période="<value-of select="$billingPeriodStart"/> à <value-of select="$billingPeriodEnd"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-04">
    <title>BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="typeCode" value="cbc:InvoiceTypeCode"/>
      <let name="references" value="cac:BillingReference"/>
      <assert test="not($typeCode = '384' or $typeCode = '471' or $typeCode = '472' or $typeCode = '473') or count($references) = 1"
        flag="warning">
        BR-FR-CO-04/BT-3 : Si le type de facture (BT-3) est une facture rectificative (384, 471, 472, 473), alors **une et une seule** référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente.
        Nombre de références valides trouvées : <value-of select="count($references)"/>.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-05">
    <title>BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)</title>
    
    <rule context="cn:CreditNote">
      <let name="typeCode" value="cbc:CreditNoteTypeCode"/>
      <let name="headerReferences" value="cac:BillingReference/cac:InvoiceDocumentReference"/>
      <let name="headerRefCount" value="count($headerReferences[cbc:ID and cbc:IssueDate])"/>
      <let name="lineReferences" value="cac:CreditNoteLine/cac:BillingReference/cac:InvoiceDocumentReference[cbc:ID and cbc:IssueDate]"/>
      <let name="lineCount" value="count(cac:CreditNoteLine)"/>
      
      <assert test="not($typeCode = '261' or $typeCode = '381' or $typeCode = '396' or $typeCode = '502' or $typeCode = '503') or ($headerRefCount &gt; 0 or count($lineReferences) = $lineCount)"
        flag="warning">
        BR-FR-CO-05/BT-3 : Si le type de facture (BT-3) est un avoir (261, 381, 396, 502, 503), alors :
        - soit au moins une référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente au niveau entête,
        - soit chaque ligne (BG-25) doit contenir une référence à une facture antérieure (EXT-FR-FE-136) avec sa date (EXT-FR-FE-138).
        Références entête trouvées : <value-of select="$headerRefCount"/>.
      </assert>
    </rule>
  
  </pattern>
  <pattern id="BR-FR-CO-07">
    <title>BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="typeCode" value="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>
      <let name="billingContext" value="cac:PaymentTerms/cbc:Note"/>
      <let name="issueDate" value="cbc:IssueDate"/>
      <let name="dueDate" value="cbc:DueDate"/>
      
      <assert test="not($dueDate and not($typeCode = '386' or $typeCode = '500' or $typeCode = '503' or $billingContext = 'B2' or $billingContext = 'S2' or $billingContext = 'M2') and $dueDate &lt; $issueDate)"
        flag="warning">
        BR-FR-CO-07/BT-9 : La date d’échéance (BT-9), si présente, doit être postérieure ou égale à la date de facture (BT-2),
        sauf si la facture est de type acompte (386, 500, 503) ou si le cadre de facturation (BT-23) est B2, S2 ou M2.
        Valeurs actuelles : Date facture = "<value-of select="$issueDate"/>", Date échéance = "<value-of select="$dueDate"/>", Type = "<value-of select="$typeCode"/>", Cadre = "<value-of select="$billingContext"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-08">
    <title>BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="typeCode" value="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>
      <let name="billingContext" value="cac:PaymentTerms/cbc:Note"/>
      
      <assert test="not($billingContext = 'B4' or $billingContext = 'S4' or $billingContext = 'M4') or not($typeCode = '386' or $typeCode = '500' or $typeCode = '503')"
        flag="warning">
        BR-FR-CO-08/BT-23 : Si le cadre de facturation (BT-23) est B4, S4 ou M4 (factures définitives après acompte), alors le type de facture (BT-3) ne peut pas être une facture ou un avoir d’acompte (386, 500, 503).
        Valeurs actuelles : BT-23="<value-of select="$billingContext"/>", BT-3="<value-of select="$typeCode"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-09">
    <title>BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="billingContext" value="cac:PaymentTerms/cbc:Note"/>
      <let name="paidAmount" value="cac:LegalMonetaryTotal/cbc:PaidAmount"/>
      <let name="grandTotal" value="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"/>
      <let name="payableAmount" value="cac:LegalMonetaryTotal/cbc:PayableAmount"/>
      <let name="dueDate" value="cbc:DueDate"/>
      
      <assert test="not($billingContext = 'B2' or $billingContext = 'S2' or $billingContext = 'M2') or ($paidAmount = $grandTotal)"
        flag="warning">
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2 (facture déjà payée), alors le montant déjà payé (BT-113) doit être égal au montant total TTC (BT-112).
        Montant payé : <value-of select="$paidAmount"/>, Montant total : <value-of select="$grandTotal"/>.
      </assert>
      
      <assert test="not($billingContext = 'B2' or $billingContext = 'S2' or $billingContext = 'M2') or ($payableAmount = 0)"
        flag="warning">
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors le net à payer (BT-115) doit être égal à 0.
        Net à payer : <value-of select="$payableAmount"/>.
      </assert>
      
      <assert test="not($billingContext = 'B2' or $billingContext = 'S2' or $billingContext = 'M2') or string($dueDate)"
        flag="warning">
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors la date d’échéance (BT-9) doit être renseignée et correspondre à la date de paiement.
        Date d’échéance actuelle : <value-of select="$dueDate"/>.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-10">
    <title>BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      
      <assert test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) or cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/BT-29 : Si l’identifiant global du fournisseur (BT-29) est renseigné, alors son schéma (BT-29-1) doit également être renseigné.
      </assert>
      
      <assert test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) or cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/BT-46 : Si l’identifiant global du client (BT-46) est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
      <assert test="not(cac:PayeeParty/cac:PartyIdentification/cbc:ID) or cac:PayeeParty/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/BT-60 : Si l’identifiant global du bénéficiaire (BT-60) est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
      <assert test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cac:PartyIdentification/cbc:ID) or cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/EXT-FR-FE-06 : Si l’identifiant global de l’agent du client est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
      <assert test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty/cac:PartyIdentification/cbc:ID) or cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/EXT-FR-FE-46 : Si l’identifiant global du payeur est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
      <assert test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyIdentification/cbc:ID) or cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/EXT-FR-FE-69 : Si l’identifiant global de l’agent du fournisseur est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
      <assert test="not(cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID) or cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/EXT-FR-FE-92 : Si l’identifiant global du prestataire de services du client est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
      <assert test="not(cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID) or cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID" flag="warning">
        BR-FR-CO-10/EXT-FR-FE-115 : Si l’identifiant global du prestataire de services du fournisseur est renseigné, alors son schéma doit également être renseigné.
      </assert>
      
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CO-12">
    <title>BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="invoiceCurrency" value="cbc:DocumentCurrencyCode"/>
      <let name="accountingCurrency" value="cbc:TaxCurrencyCode"/>
      <let name="taxAmountValueEUR" value="cac:TaxTotal/cbc:TaxAmount[@currencyID='EUR']"/>
      
      <assert test="not($invoiceCurrency != 'EUR') or ($accountingCurrency = 'EUR' and string($taxAmountValueEUR))"
        flag="warning">
        BR-FR-CO-12/BT-5 : Si la devise de facture (BT-5) est différente de EUR, alors :
        - la devise de comptabilité (BT-6) doit être présente et égale à EUR,
        - le montant de TVA en devise de comptabilité (BT-111) doit être renseigné,
        - et sa devise (BT-111-1) doit être égale à EUR.
        Valeurs actuelles : BT-5="<value-of select="$invoiceCurrency"/>", BT-6="<value-of select="$accountingCurrency"/>", BT-111="<value-of select="$taxAmountValueEUR"/>"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-14">
    <title>BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="isAU" value="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID = '0231'])"/>
      <let name="allNotes" value="string-join(./cbc:Note, '')[contains(., '#TXD#')]"/>
      <let name="afterTXD" value="substring-after($allNotes, '#TXD#')"/>
      <let name="ValeurTXD" value="if (contains($afterTXD, '#')) then substring-before($afterTXD, '#') else $afterTXD"/>   
      
      <let name="hasTXDNote" value="$ValeurTXD='MEMBRE_ASSUJETTI_UNIQUE'"/>
      
      <assert test="not($isAU) or $hasTXDNote" flag="warning">
        BR-FR-CO-14/BT-29-1 : Si le schéma d’identification du vendeur (BT-29-1) est '0231', cela signifie qu’il est membre d’un assujetti unique.
        Dans ce cas, une note (BG-1) avec le code sujet 'TXD' (BT-21) et le texte 'MEMBRE_ASSUJETTI_UNIQUE' (BT-22) doit être présente et non "<value-of select="$ValeurTXD"/>"
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-15">
    <title>BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)</title>
    
    <rule context="ubl:Invoice | cn:CreditNote">
      <let name="isAU" value="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID = '0231'])"/>
      <let name="fiscalRep" value="cac:TaxRepresentativeParty/cac:PartyTaxScheme"/>
      <let name="fiscalRepVAT" value="$fiscalRep/cbc:CompanyID"/>
      
      <assert test="not($isAU) or (exists($fiscalRep) and string($fiscalRepVAT))" flag="warning">
        BR-FR-CO-15/BT-29-1 : Si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231), alors le bloc représentant fiscal (BG-11) doit être présent et contenir le numéro de TVA de l’assujetti unique (BT-63).
        État actuel : représentant fiscal <value-of select="name($fiscalRep)"/>, numéro de TVA = "<value-of select="$fiscalRepVAT"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-DEC-01">
    <title>BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)</title>
    
    <!-- BT-93 et BT-100 -->
    <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:BaseAmount | cn:CreditNote/cac:AllowanceCharge/cbc:BaseAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-93/BT-100 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-92 et BT-99 -->
    <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:Amount | cn:CreditNote/cac:AllowanceCharge/cbc:Amount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-92/BT-99 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-106 -->
    <rule context="cac:LegalMonetaryTotal/cbc:LineExtensionAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-106 : Le montant « <value-of select="."/> » est invalide.Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-107 -->
    <rule context="cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-107 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-108 -->
    <rule context="cac:LegalMonetaryTotal/cbc:ChargeTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-108 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-109 -->
    <rule context="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-109 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-110 -->
    <rule context="cac:TaxTotal/cbc:TaxAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-110 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-111 -->
    <rule context="cac:TaxTotal/cbc:TaxAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-111 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-112 -->
    <rule context="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-112 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-113 -->
    <rule context="cac:LegalMonetaryTotal/cbc:PrepaidAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-113 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-114 -->
    <rule context="cac:LegalMonetaryTotal/cbc:PayableRoundingAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-114 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-115 -->
    <rule context="cac:LegalMonetaryTotal/cbc:PayableAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-115 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-116 -->
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-116 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-117 -->
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-117 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    
    <!-- BT-131 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount | cn:CreditNote/cac:CreditNoteLine/cbc:LineExtensionAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-131 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-136 et BT-141 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge/cbc:Amount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-136/BT-141 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
    <!-- BT-137 et BT-142 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge/cbc:BaseAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" test="custom:is-valid-decimal-19-2($amount)">
        BR-FR-DEC-01/BT-137/BT-142 : Le montant « <value-of select="."/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-DEC-02">
    <title>BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)</title>
    
    <!-- BT-129 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity | cn:CreditNote/cac:CreditNoteLine/cbc:CreditedQuantity">
      <let name="quantity" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-4($quantity)" flag="warning">
        BR-FR-DEC-02/BT-129 : La quantité « <value-of select="$quantity"/> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </assert>
    </rule>
    
    <!-- BT-149 -->
    <rule context="ubl:Invoice/cac:InvoiceLine | cn:CreditNote/cac:CreditNoteLine">
      <let name="quantity" value="normalize-space(cac:Price/cbc:BaseQuantity)"/>
      <assert test="not($quantity) or custom:is-valid-decimal-19-4($quantity)" flag="warning">
        BR-FR-DEC-02/BT-149 : La quantité de base du prix « <value-of select="$quantity"/> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </assert>
    </rule>
    
  </pattern>
  <pattern id="BR-FR-DEC-03">
    <title>BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)</title>
    
    <!-- BT-146 -->
    <rule context="ubl:Invoice/cac:InvoiceLine | cn:CreditNote/cac:CreditNoteLine">
      <let name="amount" value="normalize-space(cac:Price/cbc:PriceAmount)"/>
      <assert test="not($amount) or custom:is-valid-decimal-19-6-positive($amount)" flag="warning">
        BR-FR-DEC-03/BT-146 : Le montant « <value-of select="$amount"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </assert>
    </rule>
    
    <!-- BT-147 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge | cn:CreditNote/cac:CreditNoteLine/cac:Price/cac:AllowanceCharge">
      <let name="amount" value="normalize-space(cbc:Amount)"/>
      <assert test="not($amount) or custom:is-valid-decimal-19-6-positive($amount)" flag="warning">
        BR-FR-DEC-03/BT-147 : Le montant « <value-of select="$amount"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </assert>
    </rule>
    
    <!-- BT-148 -->
    <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount | cn:CreditNote/cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="not($amount) or custom:is-valid-decimal-19-6-positive($amount)" flag="warning">
        BR-FR-DEC-03/BT-148 : Le montant « <value-of select="$amount"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-DEC-04">
    <title>BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)</title>
    
    <!-- BT-96 ou BT-103 -->
    <rule context="cac:AllowanceCharge/cac:TaxCategory/cbc:Percent">
      <let name="rate" value="normalize-space(.)"/>
      <assert test="custom:is-valid-percent-4-2-positive($rate)" flag="warning">
        BR-FR-DEC-04/BT-96 ou BT-103 : Le taux de TVA « <value-of select="$rate"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </assert>
    </rule>
    
    <!-- BT-119 -->
    <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent">
      <let name="rate" value="normalize-space(.)"/>
      <assert test="custom:is-valid-percent-4-2-positive($rate)" flag="warning">
        BR-FR-DEC-04/BT-119 : Le taux de TVA « <value-of select="$rate"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </assert>
    </rule>
    
    <!-- BT-152 -->
    <rule context="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent">
      <let name="rate" value="normalize-space(.)"/>
      <assert test="custom:is-valid-percent-4-2-positive($rate)" flag="warning">
        BR-FR-DEC-04/BT-152 : Le taux de TVA « <value-of select="$rate"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </assert>
    </rule>
  </pattern>

</schema>