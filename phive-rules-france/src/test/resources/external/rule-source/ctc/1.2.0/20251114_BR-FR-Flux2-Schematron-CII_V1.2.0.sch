<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:custom="http://www.example.org/custom"
  queryBinding="xslt2"
  xsl:exclude-result-prefixes="xs custom">
  
  <ns prefix="custom" uri="http://www.example.org/custom"/>
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"/>
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
  <ns prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"/>
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>

  <!-- Fonctions utilisées dans les règles -->
  <!-- BR-FR-01 : identifiant valide -->
  <xsl:function name="custom:is-valid-id-format" as="xs:boolean">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:sequence select="
      matches(normalize-space($id), '^[A-Za-z0-9+\-_/]+$') and
      not(matches($id, ' ')) and
      not(starts-with($id, ' ')) and
      not(ends-with($id, ' '))
      "/>
  </xsl:function>
  
  <!-- BR-FR-03 : Année entre 2000 et 2099 et format date valide -->
  <xsl:function name="custom:is-valid-date-format" as="xs:boolean">
    <xsl:param name="date" as="xs:string?"/>
    
    <!-- Tronque la date aux 8 premiers caractères -->
    <xsl:variable name="shortDate" select="substring($date, 1, 8)"/>
    
    <!-- Vérifie le format AAAAMMJJ -->
    <xsl:variable name="isFormatValid" select="matches($shortDate, '^20\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$')"/>
    
    <!-- Extraction des composantes -->
    <xsl:variable name="year" select="number(substring($shortDate, 1, 4))"/>
    <xsl:variable name="month" select="number(substring($shortDate, 5, 2))"/>
    <xsl:variable name="day" select="number(substring($shortDate, 7, 2))"/>
    
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
    <xsl:param name="code" as="xs:string?"/>
    <xsl:variable name="custom:document-type-codes" as="xs:string"
      select="'380 389 393 501 386 500 384 471 472 473 261 262 381 396 502 503'"/>
    <xsl:sequence select="$code = tokenize($custom:document-type-codes, '\s+')"/>
  </xsl:function>
  
  <!-- BR-FR-08 : Type de facture -->
  <xsl:function name="custom:is-valid-billing-mode" as="xs:boolean">
    <xsl:param name="code" as="xs:string?"/>
    <xsl:variable name="custom:billing-modes" as="xs:string"
      select="'B1 S1 M1 B2 S2 M2 S3 B4 S4 M4 S5 S6 B7 S7 B8 S8 M8'"/>
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
    <xsl:param name="code" as="xs:string?"/>
    <xsl:variable name="validCodes" select="('S', 'E', 'AE', 'K', 'G', 'O', 'Z')"/>
    <xsl:sequence select="$code = $validCodes"/>
  </xsl:function>
  
  <!-- BR-FR-16 : Taux de TVA -->
  <xsl:function name="custom:is-valid-vat-rate" as="xs:boolean">
    <xsl:param name="rate" as="xs:string?"/>
    <xsl:variable name="validRates" select="(
      '0', '0.0', '0.00', '10', '10.0', '10.00', '13', '13.0', '13.00', '20', '20.0', '20.00',
      '8.5', '8.50', '19.6', '19.60', '2.1', '2.10', '5.5', '5.50', '7', '7.0', '7.00',
      '20.6', '20.60', '1.05', '0.9', '0.90', '1.75', '9.2', '9.20', '9.6', '9.60'
      )"/>
    <xsl:sequence select="$rate = $validRates"/>
  </xsl:function>
  
  <!-- BR-FR-17 : types de pièces jointes -->
  <xsl:function name="custom:is-valid-attachment-code" as="xs:boolean">
    <xsl:param name="code" as="xs:string?"/>
    <xsl:variable name="validCodes" select="(
      'RIB', 'LISIBLE', 'FEUILLE_DE_STYLE', 'PJA', 'BORDEREAU_SUIVI',
      'DOCUMENT_ANNEXE', 'BON_LIVRAISON', 'BON_COMMANDE',
      'BORDEREAU_SUIVI_VALIDATION', 'ETAT_ACOMPTE', 'FACTURE_PAIEMENT_DIRECT'
      )"/>
    <xsl:sequence select="$code = $validCodes"/>
  </xsl:function>
  
  <!-- BR-FR-23 et BR-FR-24 -->
  <xsl:function name="custom:is-valid-schemeid-format" as="xs:boolean">
    <xsl:param name="value" as="xs:string?"/>
    <!-- Autorise lettres, chiffres, + - _ / sans espaces -->
    <xsl:sequence select="matches($value, '^[A-Za-z0-9+\-_/]+$')"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-01 : montants sur 19 positions, max 2 décimales -->
  <xsl:function name="custom:is-valid-decimal-19-2" as="xs:boolean">
    <xsl:param name="amount" as="xs:string?"/>
    <xsl:sequence select="matches($amount, '^[-]?\d{1,19}(\.\d{1,2})?$') and string-length(replace($amount, '\.', '')) le 19"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-02 : quantités sur 19 positions, max 4 décimales -->
  <xsl:function name="custom:is-valid-decimal-19-4" as="xs:boolean">
    <xsl:param name="quantity" as="xs:string?"/>
    <xsl:sequence select="matches($quantity, '^[-]?\d{1,19}(\.\d{1,4})?$') and string-length(replace($quantity, '\.', '')) le 19"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-03 : prix unitaires positifs, 19 positions, max 6 décimales -->
  <xsl:function name="custom:is-valid-decimal-19-6-positive" as="xs:boolean">
    <xsl:param name="amount" as="xs:string?"/>
    <xsl:sequence select="matches($amount, '^\d{1,19}(\.\d{1,6})?$') and string-length(replace($amount, '\.', '')) le 19"/>
  </xsl:function>
  
  <!-- BR-FR-DEC-04 : taux de TVA positifs, 4 positions, max 2 décimales -->
  <xsl:function name="custom:is-valid-percent-4-2-positive" as="xs:boolean">
    <xsl:param name="percent" as="xs:string?"/>
    <xsl:sequence select="matches($percent, '^\d{1,4}(\.\d{1,2})?$') and string-length(replace($percent, '\.', '')) le 4"/>
  </xsl:function>

  <!-- Règles de validation CII -->
  <pattern id="BR-FR-01_BR-FR-02">
    <title>BR-FR-01 — Validation de la longueur et du format des identifiants de facture</title>
    
    <!-- BT-1 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID">
      <assert test="string-length(.) le 35" flag="warning" id="BR-FR-01_BT-1">
        BR-FR-01/BT-1 : L'identifiant de facture (ram:ID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </assert>
      <assert test="custom:is-valid-id-format(.)" flag="warning" id="BR-FR-02_BT-1">
        BR-FR-02/BT-1 : L'identifiant de facture (ram:ID) contient des caractères non autorisés. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </assert>
    </rule>
    
    <!-- BT-25 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <assert test="string-length(.) le 35" flag="warning" id="BR-FR-01_BT-25">
        BR-FR-01/BT-25 : L'identifiant de facture référencée (ram:IssuerAssignedID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </assert>
      <assert test="custom:is-valid-id-format(.)" flag="warning" id="BR-FR-02_BT-25">
        BR-FR-02/BT-25 : L'identifiant de facture référencée (ram:IssuerAssignedID) contient des caractères non autorisés. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-136 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <assert test="string-length(.) le 35" flag="warning" id="BR-FR-01_EXT-FR-FE-136">
        BR-FR-01/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (ram:IssuerAssignedID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </assert>
      <assert test="custom:is-valid-id-format(.)" flag="warning" id="BR-FR-02_EXT-FR-FE-136">
        BR-FR-02/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (ram:IssuerAssignedID) contient des caractères non autorisés. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-03">
    <title>BR-FR-03 — Validation de l'année dans les dates (2000–2099)</title>
    
    <!-- BT-2 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-2">
        BR-FR-03/BT-2 : La date d’émission (udt:DateTimeString) doit contenir une année comprise entre 2000 et 2099, au format AAAAMMJJ. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier que l’année est correcte et que le format est conforme.
      </assert>  
    </rule>
    
    <!-- BT-7 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-7">
        BR-FR-03/BT-7 : La date de fait générateur de la taxe (udt:DateString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-9 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-9">
        BR-FR-03/BT-9 : La date d’échéance (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-26 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-26">
        BR-FR-03/BT-26 : La date d’émission de la facture référencée (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-72 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-72">
        BR-FR-03/BT-72 : La date de livraison effective (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-73 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-73">
        BR-FR-03/BT-73 : La date de début de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-74 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_BT-74">
        BR-FR-03/BT-74 : La date de fin de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- EXT-FR-FE-138 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_EXT-FR-FE-138">
        BR-FR-03/EXT-FR-FE-138 : La date d’émission de la facture référencée en ligne (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- EXT-FR-FE-158 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_EXT-FR-FE-158">
        BR-FR-03/EXT-FR-FE-158 : La date de livraison effective en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-134 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_EXT-FR-FE-134">
        BR-FR-03/BT-134 : La date de début de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
    
    <!-- BT-135 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">  
      <assert test="custom:is-valid-date-format(.)"
        flag="warning" id="BR-FR-03_EXT-FR-FE-135">
        BR-FR-03/BT-135 : La date de fin de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<value-of select="."/>".
        Veuillez vérifier la validité de la date.
      </assert>  
    </rule>
  </pattern>
  
  <pattern id="BR-FR-04">
    <title>BR-FR-04 — Validation du code type de document</title>
 
    <!-- BT-3 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">  
      <assert test="custom:is-valid-document-type-code(.)"
        flag="warning" id="BR-FR-04_BT-3">
        BR-FR-04/BT-3 : Le code type de document (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez utiliser un code conforme à la liste autorisée. Les autres codes définis dans la norme UNTDID 1001 ne doivent pas être utilisés.
      </assert>  
    </rule>
    
    <!-- EXT-FR-FE-02 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">  
      <assert test="custom:is-valid-document-type-code(.)"
        flag="warning" id="BR-FR-04_EXT-FR-FE-02">
        BR-FR-04/EXT-FR-FE-02 : Le code type de document référencé (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez utiliser un code conforme à la liste autorisée.
      </assert>  
    </rule>
    
    <!-- EXT-FR-FE-137 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">  
      <assert test="custom:is-valid-document-type-code(.)"
        flag="warning" id="BR-FR-04_EXT-FR-FE-137">
        BR-FR-04/EXT-FR-FE-137 : Le code type de document référencé en ligne (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez utiliser un code conforme à la liste autorisée.
      </assert>  
    </rule>  
  </pattern>
  
  <pattern id="BR-FR-05">
    <title>BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-3)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <let name="notes" value="ram:IncludedNote"/>
      
      <assert test="exists($notes[ram:SubjectCode = 'PMT'])" flag="warning" id="BR-FR-05_BT-22_PMT">
        BR-FR-05/BT-22 : La mention relative aux frais de recouvrement (code PMT) est absente. Elle est obligatoire dans les notes (BG-3).
      </assert>
      
      <assert test="exists($notes[ram:SubjectCode = 'PMD'])" flag="warning" id="BR-FR-05_BT-22_PMD">
        BR-FR-05/BT-22 : La mention relative aux pénalités de retard (code PMD) est absente. Elle est obligatoire dans les notes (BG-3).
      </assert>
      
      <assert test="exists($notes[ram:SubjectCode = 'AAB'])" flag="warning" id="BR-FR-05_BT-22_AAB">
        BR-FR-05/BT-22 : La mention relative à l’escompte ou à son absence (code AAB) est absente. Elle est obligatoire dans les notes (BG-3).
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-06">
    <title>BR-FR-06 — Unicité des codes sujets dans les notes (BG-3)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <let name="notes" value="ram:IncludedNote"/>
      
      <!-- PMT -->
      <assert test="count($notes[ram:SubjectCode = 'PMT']) le 1" flag="warning" id="BR-FR-06_BT-21_PMT">
        BR-FR-06/BT-21 : Le code sujet PMT (indemnité forfaitaire pour frais de recouvrement) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
      
      <!-- PMD -->
      <assert test="count($notes[ram:SubjectCode = 'PMD']) le 1" flag="warning" id="BR-FR-06_BT-21_PMD">
        BR-FR-06/BT-21 : Le code sujet PMD (pénalités de retard) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
      
      <!-- AAB -->
      <assert test="count($notes[ram:SubjectCode = 'AAB']) le 1" flag="warning" id="BR-FR-06_BT-21_AAB">
        BR-FR-06/BT-21 : Le code sujet AAB (mention d’escompte ou d’absence d’escompte) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
      
      <!-- TXD -->
      <assert test="count($notes[ram:SubjectCode = 'TXD']) le 1" flag="warning" id="BR-FR-06_BT-21_TXD">
        BR-FR-06/BT-21 : Le code sujet TXD (mention de taxe) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-08">
    <title>BR-FR-08 — Validation du mode de facturation (BT-23)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID">
      <assert test="custom:is-valid-billing-mode(.)"
        flag="warning" id="BR-FR-08_BT-23">
        BR-FR-08/BT-23 : La valeur du mode de facturation (ram:ID) n’est pas autorisée. Valeurs acceptées : B1, S1, M1, B2, S2, M2, B4, S4, M4, S5, S6, B7, S7.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez utiliser une valeur conforme à la liste des modes de facturation autorisés.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-09">
    <title>BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)</title>
    
    <!-- BT-29  CYS2 Cas de multiplicité de SIRET, appeler le premier uniquement -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002']"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_BT-29">
        BR-FR-09/BT-29 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- BT-46 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002']"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_BT-46">
        BR-FR-09/BT-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- BT-60 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_BT-60">
        BR-FR-09/BT-60 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-06 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_EXT-FR-FE-06">
        BR-FR-09/EXT-FR-FE-06 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-46 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_EXT-FR-FE-46">
        BR-FR-09/EXT-FR-FE-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-69 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_EXT-FR-FE-69">
        BR-FR-09/EXT-FR-FE-69 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-92 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/> 
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_EXT-FR-FE-92">
        BR-FR-09/EXT-FR-FE-92 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-115 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_EXT-FR-FE-115">
        BR-FR-09/EXT-FR-FE-115 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- BT-71 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <!-- <let name="siren" value="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/> -->
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_BT-71">
        BR-FR-09/BT-71 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-146 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty">
      <let name="siret" value="ram:GlobalID[@schemeID='0009']"/>
      <let name="siren" value="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" flag="warning" id="BR-FR-09_EXT-FR-FE-146">
        BR-FR-09/EXT-FR-FE-146 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<value-of select="$siret"/>", SIREN : "<value-of select="$siren"/>".
      </assert>
    </rule>
    
  </pattern>
  <pattern id="BR-FR-10">
    <title>BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="siren" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID = '0002']"/> <!-- [@schemeID = '0002'] -->
      <assert test="$siren and matches(normalize-space($siren), '^\d{9}$')" flag="warning" id="BR-FR-10_BT-30">
        BR-FR-10/BT-30 : Le SIREN du vendeur (ram:ID) est obligatoire et doit être composé exactement de 9 chiffres. Valeur actuelle : "<value-of select="$siren"/>".
        Veuillez renseigner un identifiant SIREN valide.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-11">
    <title>BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="barTreatment" value="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content"/>
      <let name="siren" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID = '0002']"/>
      
      <assert test="not($barTreatment = 'B2B') or matches($siren, '^\d{9}$')" flag="warning" id="BR-FR-11_BT-47">
        BR-FR-11/BT-47 : Si une note contient le code sujet BAR avec la valeur 'B2B', alors le SIREN de l’acheteur (BT-47, ram:ID) est obligatoire et doit être composé exactement de 9 chiffres. Valeur actuelle : "<value-of select="$siren"/>".
        Veuillez renseigner un identifiant SIREN valide.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-12">
    <title>BR-FR-12 — Vérification de la présence du BT-49</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="endpointID" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      
      <assert test="string($endpointID)" flag="warning" id="BR-FR-12_BT-49">
        BR-FR-12/BT-49 : Le BT-49  est obligatoire.
        Valeur actuelle : BT-49="<value-of select="$endpointID"/>".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-13">
    <title>BR-FR-13 — Vérification de la présence du BT-34</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="endpointID" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      
      <assert test="string($endpointID)" flag="warning" id="BR-FR-13_BT-34">
        BR-FR-13/BT-34 : Le BT-34  est obligatoire.
        Valeur actuelle : BT-34="<value-of select="$endpointID"/>".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-15">
    <title>BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)</title>
    
    <!-- BT-95 et BT-102 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax">
      <let name="categoryCode" value="ram:CategoryCode"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning" id="BR-FR-15_BT-95_BT-102">
        BR-FR-15/BT-95 ou BT-102 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select="$categoryCode"/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning" id="BR-FR-15_BT-95_BT-102_LM">
        BR-FR-15/BT-95 ou BT-102 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select="$categoryCode"/>".
      </assert>
    </rule>
    
    <!-- BT-102 
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax">
      <let name="categoryCode" value="ram:CategoryCode"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning">
        BR-FR-15/BT-102 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select="$categoryCode"/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning">
        BR-FR-15/BT-102 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select="$categoryCode"/>".
      </assert>
    </rule> -->
    
    <!-- BT-118 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <let name="categoryCode" value="ram:CategoryCode"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning" id="BR-FR-15_BT-95_BT-118">
        BR-FR-15/BT-118 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select="$categoryCode"/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning" id="BR-FR-15_BT-95_BT-118_LM">
        BR-FR-15/BT-118 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select="$categoryCode"/>".
      </assert>
    </rule>
    
    <!-- BT-151 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax">
      <let name="categoryCode" value="ram:CategoryCode"/>
      <assert test="custom:is-valid-vat-category-code($categoryCode)" flag="warning" id="BR-FR-15_BT-95_BT-151">
        BR-FR-15/BT-151 : Code de catégorie de TVA invalide. Valeur actuelle : "<value-of select="$categoryCode"/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </assert>
      <assert test="not($categoryCode = ('L', 'M'))" flag="warning" id="BR-FR-15_BT-95_BT-151_LM">
        BR-FR-15/BT-151 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<value-of select="$categoryCode"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-16">
    <title>BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)</title>
    
    <!-- BT-96 et BT-103 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax">
      <let name="rate" value="string(ram:RateApplicablePercent)"/>
      <assert test="not($rate) or custom:is-valid-vat-rate($rate)" flag="warning" id="BR-FR-16_BT-96_BT-103">
        BR-FR-16/BT-96 ou BT-103 : Le taux de TVA (BT-96) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select="$rate"/>".
      </assert>
    </rule>
    
    <!-- BT-103 
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax">
      <let name="rate" value="string(ram:RateApplicablePercent)"/>
      <assert test="not($rate) or custom:is-valid-vat-rate($rate)" flag="warning">
        BR-FR-16/BT-103 : Le taux de TVA (BT-103) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select="$rate"/>".
      </assert>
    </rule> -->
    
    <!-- BT-119 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <let name="rate" value="string(ram:RateApplicablePercent)"/>
      <assert test="not($rate) or custom:is-valid-vat-rate($rate)" flag="warning" id="BR-FR-16_BT-119">
        BR-FR-16/BT-119 : Le taux de TVA (BT-119) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select="$rate"/>".
      </assert>
    </rule>
    
    <!-- BT-152 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax">
      <let name="rate" value="string(ram:RateApplicablePercent)"/>
      <assert test="not($rate) or custom:is-valid-vat-rate($rate)" flag="warning" id="BR-FR-16_BT-152">
        BR-FR-16/BT-152 : Le taux de TVA (BT-152) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<value-of select="$rate"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-17">
    <title>BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode = '916']">
      <let name="code" value="normalize-space(ram:Name)"/>
      <assert test="not($code) or custom:is-valid-attachment-code($code)" flag="warning" id="BR-FR-17_BT-123">
        BR-FR-17/BT-123 : Le code de qualification de la pièce jointe "<value-of select="$code"/>" est invalide. Il doit appartenir à la liste des codes autorisés. Veuillez corriger la valeur de BT-123.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-18">
    <title>BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="lisibleCount" value="count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:Name = 'LISIBLE'])"/>
      
      <assert test="$lisibleCount le 1" flag="warning" id="BR-FR-18_BT-123">
        BR-FR-18/BT-123 : Il ne peut y avoir **qu’un seul** document additionnel (BG-24) dont la description (BT-123) est "LISIBLE".
        Nombre de documents trouvés : <value-of select="$lisibleCount"/>.
        Veuillez supprimer les doublons ou corriger les descriptions.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-20">
    <title>BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']">
      <let name="barTreatment" value="ram:Content"/>
      
      <assert test="custom:is-valid-bar-treatment($barTreatment)" flag="warning" id="BR-FR-20_BT-21">
        BR-FR-20/BT-21 : Lorsqu’une note a pour code sujet « BAR » (BT-21), la valeur associée (BT-22, contenu de la note) doit être l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<value-of select="$barTreatment"/>". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-21">
    <title>BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <!-- Variables -->
      <let name="barTreatment" value="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content"/>
      <let name="docType" value="rsm:ExchangedDocument/ram:TypeCode"/>
      <let name="siren" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
      <let name="endpointID" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <let name="endpointSchemeID" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID"/>
      <let name="isB2B" value="$barTreatment = 'B2B'"/>
      <let name="isExcludedDocType" value="$docType = ('389', '501', '500', '471', '473', '261', '502')"/>
      
      <!-- Contrôle -->
      <assert test="not($isB2B and not($isExcludedDocType)) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')" flag="warning"  id="BR-FR-21_BT-49">
        BR-FR-21/BT-49 : Si le traitement est BAR/B2B et que le type de document (BT-3) n’est pas en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-49 (EndpointID) doit commencer par le SIREN (BT-47) et le BT-49-1 (schemeID) doit être égal à "0225".
        Valeurs actuelles : EndpointID="<value-of select="$endpointID"/>", schemeID="<value-of select="$endpointSchemeID"/>", SIREN="<value-of select="$siren"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-22">
    <title>BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <!-- Variables -->
      <let name="barTreatment" value="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content"/>
      <let name="docType" value="rsm:ExchangedDocument/ram:TypeCode"/>
      <let name="siren" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
      <let name="endpointID" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <let name="endpointSchemeID" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID"/>
      <let name="isB2B" value="$barTreatment = 'B2B'"/>
      <let name="isExcludedDocType" value="$docType = ('389', '501', '500', '471', '473', '261', '502')"/>
      
      <!-- Contrôle -->
      <assert test="not($isB2B and $isExcludedDocType) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')" flag="warning" id="BR-FR-22_BT-34">
        BR-FR-22/BT-34 : Si le traitement est BAR/B2B et que le type de document (BT-3) est en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-34 (EndpointID du vendeur) doit commencer par le SIREN (BT-30) et le BT-34-1 (schemeID) doit être égal à "0225".
        Valeurs actuelles : EndpointID="<value-of select="$endpointID"/>", schemeID="<value-of select="$endpointSchemeID"/>", SIREN="<value-of select="$siren"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-23">
    <title>BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)</title>
    
    <!-- BT-34 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning" id="BR-FR-23_BT-34">
        BR-FR-23/BT-34 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- BT-49 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning" id="BR-FR-23_BT-49">
        BR-FR-23/BT-49 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-12 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning"  id="BR-FR-23_EXT-FR-FE-12">
        BR-FR-23/EXT-FR-FE-12 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-29 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning"  id="BR-FR-23_EXT-FR-FE-29">
        BR-FR-23/EXT-FR-FE-29 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-52 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning"  id="BR-FR-23_EXT-FR-FE-52">
        BR-FR-23/EXT-FR-FE-52 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-75 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning"  id="BR-FR-23_EXT-FR-FE-75">
        BR-FR-23/EXT-FR-FE-75 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-98 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning"  id="BR-FR-23_EXT-FR-FE-98">
        BR-FR-23/EXT-FR-FE-98 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-121 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning"  id="BR-FR-23_EXT-FR-FE-121">
        BR-FR-23/EXT-FR-FE-121 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-24">
    <title>BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)</title>
    
    <!-- BT-29 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning" id="BR-FR-24_BT-29">
        BR-FR-24/BT-29 : L'identifiant privé (ram:GlobalID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
    
    <!-- BT-46 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']">
      <assert test="custom:is-valid-schemeid-format(.)" flag="warning" id="BR-FR-24_BT-46">
        BR-FR-24/BT-46 : L'identifiant privé (ram:GlobalID) ne respecte pas le format autorisé. Valeur actuelle : "<value-of select='.'/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-25">
    <title>BR-FR-25 — Longueur maximale des adresses électroniques (CII)</title>
    
    <!-- BT-34 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_BT-34">
        BR-FR-25/BT-34 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- BT-49 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_BT-49">
        BR-FR-25/BT-49 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-12 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_EXT-FR-FE-12">
        BR-FR-25/EXT-FR-FE-12 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-29 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_EXT-FR-FE-29">
        BR-FR-25/EXT-FR-FE-29 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-52 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_EXT-FR-FE-52">
        BR-FR-25/EXT-FR-FE-52 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-75 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_EXT-FR-FE-75">
        BR-FR-25/EXT-FR-FE-75 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-98 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_EXT-FR-FE-98">
        BR-FR-25/EXT-FR-FE-98 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-121 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="string-length(.) le 125" flag="warning" id="BR-FR-25_EXT-FR-FE-121">
        BR-FR-25/EXT-FR-FE-121 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-26">
    <title>BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224</title>
    
    <!-- BT-29 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']">
      <assert test="string-length(.) le 100" flag="warning" id="BR-FR-26_BT-29">
        BR-FR-26/BT-29 : L'identifiant privé (ram:GlobalID) dépasse 100 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
    
    <!-- BT-46 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']">
      <assert test="string-length(.) le 100" flag="warning" id="BR-FR-26_BT-46">
        BR-FR-26/BT-46 : L'identifiant privé (ram:GlobalID) dépasse 100 caractères. Valeur actuelle : "<value-of select='.'/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-27">
    <title>BR-FR-27 — Validation du groupe Attribut d’article (BG-32)</title>
    
    <!-- BG-32 : Vérification dans ApplicableProductCharacteristic -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic">
      <assert test="ram:Description or ram:TypeCode"
        flag="warning" id="BR-FR-27_BG-32">
        BR-FR-27/BG-32 : Le groupe Attribut d’article (BG-32) doit contenir soit un nom d’attribut d’article (BT-160 : ram:Description), soit un code d’attribut d’article (EXT-FR-FE-159 : ram:TypeCode).
        Aucun des deux éléments n’a été trouvé dans le contexte ApplicableProductCharacteristic.
        Veuillez ajouter au moins l’un des deux éléments pour respecter la structure attendue.
      </assert>
    </rule>
    
    <!-- BT-160 : Vérification de la présence du nom -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Description">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-27_BT-160">
        BR-FR-27/BT-160 : Le nom d’attribut d’article (ram:Description) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez fournir un nom d’attribut valide ou utiliser un code à la place.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-159 : Vérification de la présence du code -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-27_EXT-FR-FE-159">
        BR-FR-27/EXT-FR-FE-159 : Le code d’attribut d’article (ram:TypeCode) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez fournir un code d’attribut valide ou utiliser un nom à la place.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-28">
    <title>BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)</title>
    
    <!-- BG-32 : Vérification dans ApplicableProductCharacteristic - VCYS3 : et pas les deux -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic">
      <assert test="(ram:Value or (ram:ValueMeasure and ram:ValueMeasure/@unitCode)) and not(ram:Value and (ram:ValueMeasure and ram:ValueMeasure/@unitCode))"
        flag="warning" id="BR-FR-28_BT-161-1">
        BR-FR-28/BT-161 : Le groupe Attribut d’article (BG-32) doit contenir soit une valeur d’attribut (BT-161 : ram:Value), soit une valeur d’attribut avec unité de mesure (EXT-FR-FE-160 : ram:ValueMeasure) accompagnée de son unité (EXT-FR-FE-161 : @unitCode), et pas les deux.
        Veuillez fournir une valeur d’attribut ou une valeur mesurée avec son unité, et pas les deux.
      </assert>
    </rule>
    
    <!-- BT-161 : Vérification de la valeur simple -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Value">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-28_BT-161-2">
        BR-FR-28/BT-161 : La valeur d’attribut (ram:Value) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez fournir une valeur d’attribut valide ou utiliser une mesure avec unité.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-160 : Vérification de la valeur mesurée -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-28_EXT-FR-FE-160">
        BR-FR-28/EXT-FR-FE-160 : La valeur mesurée (ram:ValueMeasure) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez fournir une valeur mesurée valide accompagnée de son unité.
      </assert>
    </rule>
    
    <!-- EXT-FR-FE-161 : Vérification de l’unité de mesure -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure/@unitCode">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-28_EXT-FR-FE-161">
        BR-FR-28/EXT-FR-FE-161 : L’unité de mesure (@unitCode) ne doit pas être vide lorsqu’une valeur mesurée est fournie.
        Valeur actuelle : "<value-of select="."/>".
        Veuillez spécifier une unité de mesure conforme.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-29">
    <title>BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)</title>
    
    <!-- Contexte : ApplicableHeaderTradeAgreement -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1"
        flag="warning" id="BR-FR-29_BT-18">
        BR-FR-29/BT-18 : Parmi les identifiants d’objets facturés (BT-18), les schémas d’identification "AFL" et "AVV" ne doivent être présents qu’une seule fois chacun.
        Actuellement : AFL = <value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL'])"/> occurrence(s), AVV = <value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV'])"/> occurrence(s).
        Veuillez supprimer les doublons pour respecter la règle.
      </assert>
    </rule>
    
    <!-- Vérification individuelle AFL -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-29_AFL">
        BR-FR-29/AFL : L’identifiant associé au schéma "AFL" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
      </assert>
    </rule>
    
    <!-- Vérification individuelle AVV -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-29_AVV">
        BR-FR-29/AVV : L’identifiant associé au schéma "AVV" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-30">
    <title>BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)</title>
    
    <!-- Contexte : ApplicableHeaderTradeAgreement -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <assert test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1"
        flag="warning" id="BR-FR-30_BT-128">
        BR-FR-30/BT-128 : Parmi les identifiants d’objets facturés à la ligne (BT-128), les schémas d’identification "AFL" et "AVV" ne doivent être présents qu’une seule fois chacun.
        Actuellement : AFL = <value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL'])"/> occurrence(s), AVV = <value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV'])"/> occurrence(s).
        Veuillez supprimer les doublons pour respecter la règle.
      </assert>
    </rule>
    
    <!-- Vérification individuelle AFL -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-30_AFL">
        BR-FR-30/AFL : L’identifiant associé au schéma "AFL" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
      </assert>
    </rule>
    
    <!-- Vérification individuelle AVV -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID">
      <assert test="normalize-space(.) != ''"
        flag="warning" id="BR-FR-30_AVV">
        BR-FR-30/AVV : L’identifiant associé au schéma "AVV" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<value-of select="."/>".
      </assert>
    </rule>
  </pattern>
 
 
  <pattern id="BR-FR-31">
    <title>BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste </title>
    
    <!-- Vérification présence d'une seule valeur codée (B2B, B2BINT, ...) avec code sujet BAR -->
    <rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <let name="barNotes" value="ram:IncludedNote[ram:SubjectCode = 'BAR']"/>
      <let name="barCount" value="count($barNotes[normalize-space(ram:Content) = 'B2B' or normalize-space(ram:Content) = 'B2BINT' or normalize-space(ram:Content) = 'B2C' or normalize-space(ram:Content) = 'OUTOFSCOPE' or normalize-space(ram:Content) = 'ARCHIVEONLY'])"/>
      
      <assert test="$barCount &lt;= 1" flag="warning" id="BR-FR-30_BT-21">
        BR-FR-30/BT-21 : Lorsque plusieurs notes ont le code sujet « BAR » (BT-21), Il ne peut y avoir qu'une seule valeur associée (BT-22, contenu de la note) parmi l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<value-of select="$barNotes"/>" , Nombre de valeurs présentes (pas plus de 1) : <value-of select="$barCount"/>  "/>". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </assert>
    </rule> 
    
    
  </pattern> 
  
  <pattern id="BR-FR-CO-03">
    <title>BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="typeCode" value="rsm:ExchangedDocument/ram:TypeCode"/>
      <let name="contractReference" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID"/>
      <let name="billingPeriodStart" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"/>
      <let name="billingPeriodEnd" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"/>
      
      <assert test="not($typeCode = '262') or (string($contractReference) and string($billingPeriodStart) and string($billingPeriodEnd))"
        flag="warning" id="BR-FR-CO-03_BT-3">
        BR-FR-CO-03/BT-3 : Si le code type de la facture (BT-3) est égal à 262 (Avoir Remise Globale), alors :
        - Le numéro de contrat (BT-12) doit être présent
        - La période de facturation (BG-14) doit être renseignée (dates de début et de fin).
        Valeurs actuelles : BT-12="<value-of select="$contractReference"/>", période="<value-of select="$billingPeriodStart"/> à <value-of select="$billingPeriodEnd"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-04">
    <title>BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)</title>
    
    <rule context="rsm:CrossIndustryInvoice"> 
      <let name="typeCode" value="rsm:ExchangedDocument/ram:TypeCode"/>
      <let name="references" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument"/>
    <!--  <let name="refCount" value="count($references[ram:IssuerAssignedID and ram:FormattedIssueDateTime/udt:DateTimeString])"/> -->
      <let name="refCount" value="count($references)"/>
      
      <assert test="not($typeCode = ('384', '471', '472', '473')) or $refCount = 1" flag="warning"  id="BR-FR-CO-04_BT-4">
        BR-FR-CO-04/BT-3 : Si le type de facture (BT-3) est une facture rectificative (384, 471, 472, 473), alors **une et une seule** référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente.
        Nombre de références valides trouvées : <value-of select="$refCount"/>.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-05">
    <title>BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="typeCode" value="rsm:ExchangedDocument/ram:TypeCode"/>
      <let name="headerRefs" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument"/>
      <let name="headerRefCount" value="count($headerRefs[ram:IssuerAssignedID and ram:FormattedIssueDateTime/qdt:DateTimeString])"/>
      <let name="lineRefsValid" value="every $line in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies 
        exists($line/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument[ram:IssuerAssignedID and ram:FormattedIssueDateTime/qdt:DateTimeString])"/>
      
      <assert test="not($typeCode = ('261', '381', '396', '502', '503')) or ($headerRefCount ge 1 or $lineRefsValid)" flag="warning" id="BR-FR-CO-05_BT-3">
        BR-FR-CO-05/BT-3 : Si le type de facture (BT-3) est un avoir (261, 381, 396, 502, 503), alors :
        - soit au moins une référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente au niveau entête,
        - soit chaque ligne (BG-25) doit contenir une référence à une facture antérieure (EXT-FR-FE-136) avec sa date (EXT-FR-FE-138).
        Références entête trouvées : <value-of select="$headerRefCount"/>.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-07">
    <title>BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="dueDate" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"/>
      <let name="issueDate" value="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"/>
      <let name="typeCode" value="rsm:ExchangedDocument/ram:TypeCode"/>
      <let name="frameworkCode" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BusinessTypeCode"/>
      
      <assert test="not(string($dueDate)) or 
        ($typeCode = ('386', '500', '503') or $frameworkCode = ('B2', 'S2', 'M2') or $dueDate ge $issueDate)"
        flag="warning" id="BR-FR-CO-07_BT-9">
        BR-FR-CO-07/BT-9 : La date d’échéance (BT-9), si présente, doit être postérieure ou égale à la date de facture (BT-2),
        sauf si la facture est de type acompte (386, 500, 503) ou si le cadre de facturation (BT-23) est B2, S2 ou M2.
        Valeurs actuelles : Date facture = "<value-of select="$issueDate"/>", Date échéance = "<value-of select="$dueDate"/>", Type = "<value-of select="$typeCode"/>", Cadre = "<value-of select="$frameworkCode"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-08">
    <title>BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="frameworkCode" value="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <let name="typeCode" value="rsm:ExchangedDocument/ram:TypeCode"/>
      
      <assert test="not($frameworkCode = ('B4', 'S4', 'M4')) or not($typeCode = ('386', '500', '503'))" flag="warning" id="BR-FR-CO-08_BT-23">
        BR-FR-CO-08/BT-23 : Si le cadre de facturation (BT-23) est B4, S4 ou M4 (factures définitives après acompte), alors le type de facture (BT-3) ne peut pas être une facture ou un avoir d’acompte (386, 500, 503).
        Valeurs actuelles : BT-23="<value-of select="$frameworkCode"/>", BT-3="<value-of select="$typeCode"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-09"> <!-- CYS3 CORRECTION Xpath BT-113 et Ajouter number(.) pour comparer des montants et nombres -->
    <title>BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="frameworkCode" value="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <let name="isPaidMode" value="$frameworkCode = ('B2', 'S2', 'M2')"/>
      <let name="paidAmount" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount"/>
      <let name="totalAmount" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount"/>
      <let name="dueAmount" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount"/>
      <let name="dueDate" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"/>
      
      <assert test="not($isPaidMode) or (number($paidAmount) = number($totalAmount))" flag="warning" id="BR-FR-CO-09_BT-23-1">
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2 (facture déjà payée), alors le montant déjà payé (BT-113) doit être égal au montant total TTC (BT-112).
        Montant payé : <value-of select="$paidAmount"/>, Montant total : <value-of select="$totalAmount"/>.
      </assert>
      
      <assert test="not($isPaidMode) or (number($dueAmount) = 0)" flag="warning" id="BR-FR-CO-09_BT-23-2">
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors le net à payer (BT-115) doit être égal à 0.
        Net à payer : <value-of select="$dueAmount"/>.
      </assert>
      
      <assert test="not($isPaidMode) or string($dueDate)" flag="warning" id="BR-FR-CO-09_BT-23-3">
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors la date d’échéance (BT-9) doit être renseignée et correspondre à la date de paiement.
        Date d’échéance actuelle : <value-of select="$dueDate"/>.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="BR-FR-CO-10"> <!-- CYS2 Revue du code pour l'unicité des schemeID -->
    
    <title>BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID</title>
    
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      
      <!-- Règle 1 : Chaque GlobalID doit avoir un @schemeID -->
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_BT-29-1">
        BR-FR-CO-10/BT-29 : Si l’identifiant global du vendeur (BT-29) est renseigné, alors son schéma (BT-29-1) doit également être renseigné.
      </assert>
      
      <!-- Règle 2 : Unicité des schemeID -->
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_BT-29-2">
        BR-FR-CO-10/BT-29 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé du vendeur (BT-29).
      </assert>
      
    </rule>
    
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_BT-46-1">
        BR-FR-CO-10/BT-46 : Si l’identifiant global de l'acheteur (BT-46) est renseigné, alors son schéma (BT-46-1) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_BT-46-2">
        BR-FR-CO-10/BT-46 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé de l'acheteur (BT-46).
      </assert>
      
    </rule>
    
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_BT-60-1">
        BR-FR-CO-10/BT-60 : Si l’identifiant global du bénéficiaire (BT-60) est renseigné, alors son schéma (BT-60-1) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_BT-60-2">
        BR-FR-CO-10/BT-60 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé du bénéficiaire (BT-60).
      </assert>
      
    </rule>  
    
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-06-1">
        BR-FR-CO-10/EXT-FR-FE-06 : Si l’identifiant global de l'agent d'acheteur (EXT-FR-FE-06) est renseigné, alors son schéma (EXT-FR-FE-07) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-06-2">
        BR-FR-CO-10/EXT-FR-FE-06 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé de l'agent d'acheteur (EXT-FR-FE-06).
      </assert>
      
    </rule> 
    
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-46-1">
        BR-FR-CO-10/EXT-FR-FE-46 : Si l’identifiant global du payeur (EXT-FR-FE-46) est renseigné, alors son schéma (EXT-FR-FE-47) doit également être renseigné.
      </assert>

      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-46-2">
        BR-FR-CO-10/EXT-FR-FE-46 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du payeur (EXT-FR-FE-46).
      </assert>
      
    </rule> 
 
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty">
        
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-69-1">
          BR-FR-CO-10/EXT-FR-FE-69 : Si l’identifiant global de l'agent du vendeur (EXT-FR-FE-69) est renseigné, alors son schéma (EXT-FR-FE-70) doit également être renseigné.
        </assert>
        
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-69-2">
          BR-FR-CO-10/EXT-FR-FE-69 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé de l'agent du vendeur (EXT-FR-FE-69).
        </assert>
        
    </rule> 
    
    <rule context="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-92-1">
        BR-FR-CO-10/EXT-FR-FE-92 : Si l’identifiant global du facturé à (EXT-FR-FE-92) est renseigné, alors son schéma (EXT-FR-FE-92-1) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-92-2">
        BR-FR-CO-10/EXT-FR-FE-92 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du facturé à (EXT-FR-FE-92).
      </assert>
      
    </rule> 
      
    <rule context="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-115-1">
        BR-FR-CO-10/EXT-FR-FE-115 : Si l’identifiant global du facturant (EXT-FR-FE-115) est renseigné, alors son schéma (EXT-FR-FE-116) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-115-2">
        BR-FR-CO-10/EXT-FR-FE-115 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du facturant (EXT-FR-FE-115).
      </assert>
      
    </rule>  
  
    <rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_BT-71-1">
        BR-FR-CO-10/BT-71 : Si l’identifiant global du livré à (BT-71) est renseigné, alors son schéma (BT-71-1) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_BT-71-2">
        BR-FR-CO-10/BT-71 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du livré à (BT-71).
      </assert>
      
    </rule>   
    
    <rule context="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty">
      
      <assert test="every $id in ram:GlobalID satisfies $id/@schemeID" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-146-1">
        BR-FR-CO-10/EXT-FR-FE-146 : Si l’identifiant global du livré à à la ligne (EXT-FR-FE-146 ) est renseigné, alors son schéma (EXT-FR-FE-147) doit également être renseigné.
      </assert>
      
      <assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" flag="warning" id="BR-FR-CO-10_EXT-FR-FE-146-2">
        BR-FR-CO-10/EXT-FR-FE-146  : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du livré à à la ligne (EXT-FR-FE-146 ).
      </assert>
      
    </rule> 
      
  </pattern>
  
  <pattern id="BR-FR-CO-12">
    <title>BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="invoiceCurrency" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
      <let name="accountingCurrency" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode"/> 
      <let name="taxAmountEUR" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']"/>
      
      <assert test="not($invoiceCurrency != 'EUR') or 
        ($accountingCurrency = 'EUR' and string($taxAmountEUR))" flag="warning" id="BR-FR-CO-12_BT-5">
        BR-FR-CO-12/BT-5 : Si la devise de facture (BT-5) est différente de EUR, alors :
        - la devise de comptabilité (BT-6) doit être présente et égale à EUR,
        - le montant de TVA en devise de comptabilité (BT-111) doit être renseigné,
        - et sa devise (BT-111-1) doit être égale à EUR.
        Valeurs actuelles : BT-5="<value-of select="$invoiceCurrency"/>", BT-6="<value-of select="$accountingCurrency"/>", BT-111="<value-of select="$taxAmountEUR"/>"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-14">
    <title>BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="isAU" value="exists(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID = '0231'])"/>
      <let name="hasTXDNote" value="exists(rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'TXD' and ram:Content = 'MEMBRE_ASSUJETTI_UNIQUE'])"/>
      
      <assert test="not($isAU) or $hasTXDNote" flag="warning" id="BR-FR-CO-14_BT-29-1">
        BR-FR-CO-14/BT-29-1 : Si le schéma d’identification du vendeur (BT-29-1) est '0231', cela signifie qu’il est membre d’un assujetti unique.
        Dans ce cas, une note (BG-1) avec le code sujet 'TXD' (BT-21) et le texte 'MEMBRE_ASSUJETTI_UNIQUE' (BT-22) doit être présente.
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-CO-15">
    <title>BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)</title>
    
    <rule context="rsm:CrossIndustryInvoice">
      <let name="isAU" value="some $id in ./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID satisfies $id/@schemeID = '0231'"/>
      <let name="fiscalRep" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty"/>
      <let name="fiscalVAT" value="$fiscalRep/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']"/>
      
      <assert test="not($isAU) or (exists($fiscalRep) and string($fiscalVAT))" flag="warning" id="BR-FR-CO-15_BT-29-1">
        BR-FR-CO-15/BT-29-1 : Si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231), alors le bloc représentant fiscal (BG-11) doit être présent et contenir le numéro de TVA de l’assujetti unique (BT-63).
        État actuel : représentant fiscal <value-of select="if (exists($fiscalRep)) then 'présent' else 'absent'"/>, numéro de TVA = "<value-of select="$fiscalVAT"/>".
      </assert>
    </rule>
  </pattern>
  <pattern id="BR-FR-DEC-01">
    <title>BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)</title>
    
    <!-- BT-92 et BT-99 -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-92_BT-99" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-92/BT-99 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-93 et BT-100 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-93_BT-100" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-93 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    
    <!-- BT-106 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-106" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-106 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-107 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-107" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-107 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-108 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-108" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-108 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-109 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-109" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-109 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-110 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-110" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-110 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-111 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert flag="warning" id="BR-FR-DEC-01_BT-111" test="custom:is-valid-decimal-19-2(normalize-space(.))">BR-FR-DEC-01/BT-111 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</assert></rule>
    <!-- BT-112 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-112">
        BR-FR-DEC-01/BT-112 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-113 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-113">
        BR-FR-DEC-01/BT-113 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-114 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-114">
        BR-FR-DEC-01/BT-114 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-115 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-115">
        BR-FR-DEC-01/BT-115 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-116 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-116">
        BR-FR-DEC-01/BT-116 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-117 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-117">
        BR-FR-DEC-01/BT-117 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-131 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-131">
        BR-FR-DEC-01/BT-131 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-136 et BT-141 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-136_BT-141">
        BR-FR-DEC-01/BT-136 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    <!-- BT-137 et BT-142 -->
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-2($amount)" flag="warning" id="BR-FR-DEC-01_BT-137_BT-142">
        BR-FR-DEC-01/BT-137 : Le montant « <value-of select="$amount"/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </assert>
    </rule>
    
  </pattern>
  
  <pattern id="BR-FR-DEC-02">
    <title>BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
      <let name="quantity" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-4($quantity)" flag="warning" id="BR-FR-DEC-02_BT-129">
        BR-FR-DEC-02/BT-129 : La quantité « <value-of select="$quantity"/> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </assert>
    </rule>

    <!-- -->
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity">
      <let name="quantity" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-4($quantity)" flag="warning" id="BR-FR-DEC-02_BT-149">
        BR-FR-DEC-02/BT-149 : La quantité « <value-of select="$quantity"/> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </assert>
    </rule>
    
    
  </pattern>
  <pattern id="BR-FR-DEC-03">
    <title>BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)</title>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-6-positive($amount)" flag="warning" id="BR-FR-DEC-03_BT-146">
        BR-FR-DEC-03/BT-146 : Le montant « <value-of select="$amount"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </assert>
    </rule>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-6-positive($amount)" flag="warning" id="BR-FR-DEC-03_BT-147">
        BR-FR-DEC-03/BT-147 : Le montant « <value-of select="$amount"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </assert>
    </rule>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount">
      <let name="amount" value="normalize-space(.)"/>
      <assert test="custom:is-valid-decimal-19-6-positive($amount)" flag="warning" id="BR-FR-DEC-03_BT-148">
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
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent">
      <let name="rate" value="normalize-space(.)"/>
      <assert test="custom:is-valid-percent-4-2-positive($rate)" flag="warning" id="BR-FR-DEC-04_BT-96_BT-103">
        BR-FR-DEC-04/BT-96 ou BT-103 : Le taux de TVA « <value-of select="$rate"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </assert>
    </rule>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent">
      <let name="rate" value="normalize-space(.)"/>
      <assert test="custom:is-valid-percent-4-2-positive($rate)" flag="warning" id="BR-FR-DEC-04_BT-119">
        BR-FR-DEC-04/BT-119 : Le taux de TVA « <value-of select="$rate"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </assert>
    </rule>
    
    <rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent">
      <let name="rate" value="normalize-space(.)"/>
      <assert test="custom:is-valid-percent-4-2-positive($rate)" flag="warning" id="BR-FR-DEC-04_BT-152">
        BR-FR-DEC-04/BT-152 : Le taux de TVA « <value-of select="$rate"/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </assert>
    </rule>
  </pattern>
  
</schema>