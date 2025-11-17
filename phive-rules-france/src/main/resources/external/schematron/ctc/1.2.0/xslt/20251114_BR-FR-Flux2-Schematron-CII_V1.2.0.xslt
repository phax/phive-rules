<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:custom="http://www.example.org/custom" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->
<xsl:function as="xs:boolean" name="custom:is-valid-id-format">
    <xsl:param as="xs:string?" name="id" />
    <xsl:sequence select="       matches(normalize-space($id), '^[A-Za-z0-9+\-_/]+$') and       not(matches($id, ' ')) and       not(starts-with($id, ' ')) and       not(ends-with($id, ' '))       " />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-date-format">
    <xsl:param as="xs:string?" name="date" />
    
    
    <xsl:variable name="shortDate" select="substring($date, 1, 8)" />
    
    
    <xsl:variable name="isFormatValid" select="matches($shortDate, '^20\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$')" />
    
    
    <xsl:variable name="year" select="number(substring($shortDate, 1, 4))" />
    <xsl:variable name="month" select="number(substring($shortDate, 5, 2))" />
    <xsl:variable name="day" select="number(substring($shortDate, 7, 2))" />
    
    
    <xsl:variable name="isLeapYear" select="($year mod 4 = 0 and $year mod 100 != 0) or ($year mod 400 = 0)" />
    
    
    <xsl:variable name="maxDay" select="       if ($month = (1, 3, 5, 7, 8, 10, 12)) then 31       else if ($month = (4, 6, 9, 11)) then 30       else if ($month = 2 and $isLeapYear) then 29       else if ($month = 2) then 28       else 0" />
    
    
    <xsl:sequence select="$isFormatValid and $day le $maxDay" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-document-type-code">
    <xsl:param as="xs:string?" name="code" />
    <xsl:variable as="xs:string" name="custom:document-type-codes" select="'380 389 393 501 386 500 384 471 472 473 261 262 381 396 502 503'" />
    <xsl:sequence select="$code = tokenize($custom:document-type-codes, '\s+')" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-billing-mode">
    <xsl:param as="xs:string?" name="code" />
    <xsl:variable as="xs:string" name="custom:billing-modes" select="'B1 S1 M1 B2 S2 M2 S3 B4 S4 M4 S5 S6 B7 S7 B8 S8 M8'" />
    <xsl:sequence select="$code = tokenize($custom:billing-modes, '\s+')" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:check-siret-siren-coherence">
    <xsl:param as="xs:string?" name="siret" />
    <xsl:param as="xs:string?" name="siren" />
    <xsl:sequence select="matches($siret, '^\d{14}$') and substring($siret, 1, 9) = $siren" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-bar-treatment">
    <xsl:param as="xs:string?" name="value" />
    <xsl:sequence select="$value = ('B2B', 'B2BINT', 'B2C', 'OUTOFSCOPE', 'ARCHIVEONLY')" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-eas-code">
    <xsl:param as="xs:string?" name="code" />
    <xsl:variable as="xs:string" name="custom:eas-codes" select="'AN AQ AS AU EM 0002 0007 0009 0037 0060 0088 0096 0097 0106        0130 0135 0142 0147 0151 0154 0158 0170 0177 0183 0184 0188 0190        0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204        0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0218 0221 0225        0230 0235 0240 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924        9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937        9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950        9951 9952 9953 9957 9959'" />
    <xsl:sequence select="$code = tokenize($custom:eas-codes, '\s+')" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-vat-category-code">
    <xsl:param as="xs:string?" name="code" />
    <xsl:variable name="validCodes" select="('S', 'E', 'AE', 'K', 'G', 'O', 'Z')" />
    <xsl:sequence select="$code = $validCodes" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-vat-rate">
    <xsl:param as="xs:string?" name="rate" />
    <xsl:variable name="validRates" select="(       '0', '0.0', '0.00', '10', '10.0', '10.00', '13', '13.0', '13.00', '20', '20.0', '20.00',       '8.5', '8.50', '19.6', '19.60', '2.1', '2.10', '5.5', '5.50', '7', '7.0', '7.00',       '20.6', '20.60', '1.05', '0.9', '0.90', '1.75', '9.2', '9.20', '9.6', '9.60'       )" />
    <xsl:sequence select="$rate = $validRates" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-attachment-code">
    <xsl:param as="xs:string?" name="code" />
    <xsl:variable name="validCodes" select="(       'RIB', 'LISIBLE', 'FEUILLE_DE_STYLE', 'PJA', 'BORDEREAU_SUIVI',       'DOCUMENT_ANNEXE', 'BON_LIVRAISON', 'BON_COMMANDE',       'BORDEREAU_SUIVI_VALIDATION', 'ETAT_ACOMPTE', 'FACTURE_PAIEMENT_DIRECT'       )" />
    <xsl:sequence select="$code = $validCodes" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-schemeid-format">
    <xsl:param as="xs:string?" name="value" />
    
    <xsl:sequence select="matches($value, '^[A-Za-z0-9+\-_/]+$')" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-decimal-19-2">
    <xsl:param as="xs:string?" name="amount" />
    <xsl:sequence select="matches($amount, '^[-]?\d{1,19}(\.\d{1,2})?$') and string-length(replace($amount, '\.', '')) le 19" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-decimal-19-4">
    <xsl:param as="xs:string?" name="quantity" />
    <xsl:sequence select="matches($quantity, '^[-]?\d{1,19}(\.\d{1,4})?$') and string-length(replace($quantity, '\.', '')) le 19" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-decimal-19-6-positive">
    <xsl:param as="xs:string?" name="amount" />
    <xsl:sequence select="matches($amount, '^\d{1,19}(\.\d{1,6})?$') and string-length(replace($amount, '\.', '')) le 19" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="custom:is-valid-percent-4-2-positive">
    <xsl:param as="xs:string?" name="percent" />
    <xsl:sequence select="matches($percent, '^\d{1,4}(\.\d{1,2})?$') and string-length(replace($percent, '\.', '')) le 4" />
  </xsl:function>

<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="custom" uri="http://www.example.org/custom" />
      <svrl:ns-prefix-in-attribute-values prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
      <svrl:ns-prefix-in-attribute-values prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />
      <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-01_BR-FR-02</xsl:attribute>
        <xsl:attribute name="name">BR-FR-01 — Validation de la longueur et du format des identifiants de facture</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-03</xsl:attribute>
        <xsl:attribute name="name">BR-FR-03 — Validation de l'année dans les dates (2000–2099)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-04</xsl:attribute>
        <xsl:attribute name="name">BR-FR-04 — Validation du code type de document</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-05</xsl:attribute>
        <xsl:attribute name="name">BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-3)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-06</xsl:attribute>
        <xsl:attribute name="name">BR-FR-06 — Unicité des codes sujets dans les notes (BG-3)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-08</xsl:attribute>
        <xsl:attribute name="name">BR-FR-08 — Validation du mode de facturation (BT-23)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-09</xsl:attribute>
        <xsl:attribute name="name">BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-10</xsl:attribute>
        <xsl:attribute name="name">BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-11</xsl:attribute>
        <xsl:attribute name="name">BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-12</xsl:attribute>
        <xsl:attribute name="name">BR-FR-12 — Vérification de la présence du BT-49</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-13</xsl:attribute>
        <xsl:attribute name="name">BR-FR-13 — Vérification de la présence du BT-34</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-15</xsl:attribute>
        <xsl:attribute name="name">BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-16</xsl:attribute>
        <xsl:attribute name="name">BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-17</xsl:attribute>
        <xsl:attribute name="name">BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-18</xsl:attribute>
        <xsl:attribute name="name">BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-20</xsl:attribute>
        <xsl:attribute name="name">BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-21</xsl:attribute>
        <xsl:attribute name="name">BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-22</xsl:attribute>
        <xsl:attribute name="name">BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M37" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-23</xsl:attribute>
        <xsl:attribute name="name">BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M38" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-24</xsl:attribute>
        <xsl:attribute name="name">BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M39" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-25</xsl:attribute>
        <xsl:attribute name="name">BR-FR-25 — Longueur maximale des adresses électroniques (CII)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-26</xsl:attribute>
        <xsl:attribute name="name">BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-27</xsl:attribute>
        <xsl:attribute name="name">BR-FR-27 — Validation du groupe Attribut d’article (BG-32)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-28</xsl:attribute>
        <xsl:attribute name="name">BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-29</xsl:attribute>
        <xsl:attribute name="name">BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-30</xsl:attribute>
        <xsl:attribute name="name">BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-31</xsl:attribute>
        <xsl:attribute name="name">BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-03</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M47" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-04</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M48" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-05</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M49" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-07</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M50" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-08</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M51" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-09</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M52" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-10</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M53" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-12</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M54" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-14</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M55" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-CO-15</xsl:attribute>
        <xsl:attribute name="name">BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M56" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-DEC-01</xsl:attribute>
        <xsl:attribute name="name">BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M57" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-DEC-02</xsl:attribute>
        <xsl:attribute name="name">BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M58" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-DEC-03</xsl:attribute>
        <xsl:attribute name="name">BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M59" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">BR-FR-DEC-04</xsl:attribute>
        <xsl:attribute name="name">BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M60" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN BR-FR-01_BR-FR-02BR-FR-01 — Validation de la longueur et du format des identifiants de facture-->
<svrl:text>BR-FR-01 — Validation de la longueur et du format des identifiants de facture</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID" mode="M20" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 35">
          <xsl:attribute name="id">BR-FR-01_BT-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-01/BT-1 : L'identifiant de facture (ram:ID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-id-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-id-format(.)">
          <xsl:attribute name="id">BR-FR-02_BT-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-02/BT-1 : L'identifiant de facture (ram:ID) contient des caractères non autorisés. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" mode="M20" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 35">
          <xsl:attribute name="id">BR-FR-01_BT-25</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-01/BT-25 : L'identifiant de facture référencée (ram:IssuerAssignedID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-id-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-id-format(.)">
          <xsl:attribute name="id">BR-FR-02_BT-25</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-02/BT-25 : L'identifiant de facture référencée (ram:IssuerAssignedID) contient des caractères non autorisés. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" mode="M20" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 35">
          <xsl:attribute name="id">BR-FR-01_EXT-FR-FE-136</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-01/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (ram:IssuerAssignedID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-id-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-id-format(.)">
          <xsl:attribute name="id">BR-FR-02_EXT-FR-FE-136</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-02/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (ram:IssuerAssignedID) contient des caractères non autorisés. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-03BR-FR-03 — Validation de l'année dans les dates (2000–2099)-->
<svrl:text>BR-FR-03 — Validation de l'année dans les dates (2000–2099)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" mode="M21" priority="1010">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-2 : La date d’émission (udt:DateTimeString) doit contenir une année comprise entre 2000 et 2099, au format AAAAMMJJ. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier que l’année est correcte et que le format est conforme.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString" mode="M21" priority="1009">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-7</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-7 : La date de fait générateur de la taxe (udt:DateString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString" mode="M21" priority="1008">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-9</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-9 : La date d’échéance (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M21" priority="1007">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-26</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-26 : La date d’émission de la facture référencée (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M21" priority="1006">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-72</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-72 : La date de livraison effective (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M21" priority="1005">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-73</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-73 : La date de début de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M21" priority="1004">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_BT-74</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-74 : La date de fin de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M21" priority="1003">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-138</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/EXT-FR-FE-138 : La date d’émission de la facture référencée en ligne (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M21" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-158</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/EXT-FR-FE-158 : La date de livraison effective en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M21" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-134</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-134 : La date de début de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M21" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-date-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-date-format(.)">
          <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-135</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-03/BT-135 : La date de fin de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez vérifier la validité de la date.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-04BR-FR-04 — Validation du code type de document-->
<svrl:text>BR-FR-04 — Validation du code type de document</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode" mode="M22" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-document-type-code(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-document-type-code(.)">
          <xsl:attribute name="id">BR-FR-04_BT-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-04/BT-3 : Le code type de document (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez utiliser un code conforme à la liste autorisée. Les autres codes définis dans la norme UNTDID 1001 ne doivent pas être utilisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode" mode="M22" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-document-type-code(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-document-type-code(.)">
          <xsl:attribute name="id">BR-FR-04_EXT-FR-FE-02</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-04/EXT-FR-FE-02 : Le code type de document référencé (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez utiliser un code conforme à la liste autorisée.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode" mode="M22" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-document-type-code(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-document-type-code(.)">
          <xsl:attribute name="id">BR-FR-04_EXT-FR-FE-137</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-04/EXT-FR-FE-137 : Le code type de document référencé en ligne (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez utiliser un code conforme à la liste autorisée.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-05BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-3)-->
<svrl:text>BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-3)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument" mode="M23" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument" />
    <xsl:variable name="notes" select="ram:IncludedNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists($notes[ram:SubjectCode = 'PMT'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists($notes[ram:SubjectCode = 'PMT'])">
          <xsl:attribute name="id">BR-FR-05_BT-22_PMT</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-05/BT-22 : La mention relative aux frais de recouvrement (code PMT) est absente. Elle est obligatoire dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists($notes[ram:SubjectCode = 'PMD'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists($notes[ram:SubjectCode = 'PMD'])">
          <xsl:attribute name="id">BR-FR-05_BT-22_PMD</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-05/BT-22 : La mention relative aux pénalités de retard (code PMD) est absente. Elle est obligatoire dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists($notes[ram:SubjectCode = 'AAB'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists($notes[ram:SubjectCode = 'AAB'])">
          <xsl:attribute name="id">BR-FR-05_BT-22_AAB</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-05/BT-22 : La mention relative à l’escompte ou à son absence (code AAB) est absente. Elle est obligatoire dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-06BR-FR-06 — Unicité des codes sujets dans les notes (BG-3)-->
<svrl:text>BR-FR-06 — Unicité des codes sujets dans les notes (BG-3)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument" mode="M24" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument" />
    <xsl:variable name="notes" select="ram:IncludedNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($notes[ram:SubjectCode = 'PMT']) le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($notes[ram:SubjectCode = 'PMT']) le 1">
          <xsl:attribute name="id">BR-FR-06_BT-21_PMT</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-06/BT-21 : Le code sujet PMT (indemnité forfaitaire pour frais de recouvrement) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($notes[ram:SubjectCode = 'PMD']) le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($notes[ram:SubjectCode = 'PMD']) le 1">
          <xsl:attribute name="id">BR-FR-06_BT-21_PMD</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-06/BT-21 : Le code sujet PMD (pénalités de retard) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($notes[ram:SubjectCode = 'AAB']) le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($notes[ram:SubjectCode = 'AAB']) le 1">
          <xsl:attribute name="id">BR-FR-06_BT-21_AAB</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-06/BT-21 : Le code sujet AAB (mention d’escompte ou d’absence d’escompte) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($notes[ram:SubjectCode = 'TXD']) le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($notes[ram:SubjectCode = 'TXD']) le 1">
          <xsl:attribute name="id">BR-FR-06_BT-21_TXD</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-06/BT-21 : Le code sujet TXD (mention de taxe) ne doit apparaître qu'une seule fois dans les notes (BG-3).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-08BR-FR-08 — Validation du mode de facturation (BT-23)-->
<svrl:text>BR-FR-08 — Validation du mode de facturation (BT-23)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID" mode="M25" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-billing-mode(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-billing-mode(.)">
          <xsl:attribute name="id">BR-FR-08_BT-23</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-08/BT-23 : La valeur du mode de facturation (ram:ID) n’est pas autorisée. Valeurs acceptées : B1, S1, M1, B2, S2, M2, B4, S4, M4, S5, S6, B7, S7.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez utiliser une valeur conforme à la liste des modes de facturation autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M25" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-09BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)-->
<svrl:text>BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" mode="M26" priority="1009">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_BT-29</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/BT-29 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" mode="M26" priority="1008">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_BT-46</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/BT-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty" mode="M26" priority="1007">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_BT-60</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/BT-60 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty" mode="M26" priority="1006">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-06</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/EXT-FR-FE-06 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty" mode="M26" priority="1005">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-46</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/EXT-FR-FE-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty" mode="M26" priority="1004">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-69</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/EXT-FR-FE-69 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty" mode="M26" priority="1003">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-92</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/EXT-FR-FE-92 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty" mode="M26" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-115</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/EXT-FR-FE-115 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" mode="M26" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_BT-71</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/BT-71 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty" mode="M26" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty" />
    <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']" />
    <xsl:variable name="siren" select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
          <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-146</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-09/EXT-FR-FE-146 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text />
            <xsl:value-of select="$siret" />
            <xsl:text />", SIREN : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-10BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)-->
<svrl:text>BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M27" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="siren" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID = '0002']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$siren and matches(normalize-space($siren), '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="$siren and matches(normalize-space($siren), '^\d{9}$')">
          <xsl:attribute name="id">BR-FR-10_BT-30</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-10/BT-30 : Le SIREN du vendeur (ram:ID) est obligatoire et doit être composé exactement de 9 chiffres. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
        Veuillez renseigner un identifiant SIREN valide.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-11BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)-->
<svrl:text>BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M28" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="barTreatment" select="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content" />
    <xsl:variable name="siren" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID = '0002']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($barTreatment = 'B2B') or matches($siren, '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($barTreatment = 'B2B') or matches($siren, '^\d{9}$')">
          <xsl:attribute name="id">BR-FR-11_BT-47</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-11/BT-47 : Si une note contient le code sujet BAR avec la valeur 'B2B', alors le SIREN de l’acheteur (BT-47, ram:ID) est obligatoire et doit être composé exactement de 9 chiffres. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
        Veuillez renseigner un identifiant SIREN valide.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-12BR-FR-12 — Vérification de la présence du BT-49-->
<svrl:text>BR-FR-12 — Vérification de la présence du BT-49</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M29" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="endpointID" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string($endpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string($endpointID)">
          <xsl:attribute name="id">BR-FR-12_BT-49</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-12/BT-49 : Le BT-49  est obligatoire.
        Valeur actuelle : BT-49="<xsl:text />
            <xsl:value-of select="$endpointID" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-13BR-FR-13 — Vérification de la présence du BT-34-->
<svrl:text>BR-FR-13 — Vérification de la présence du BT-34</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M30" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="endpointID" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string($endpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string($endpointID)">
          <xsl:attribute name="id">BR-FR-13_BT-34</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-13/BT-34 : Le BT-34  est obligatoire.
        Valeur actuelle : BT-34="<xsl:text />
            <xsl:value-of select="$endpointID" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-15BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)-->
<svrl:text>BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax" mode="M31" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax" />
    <xsl:variable name="categoryCode" select="ram:CategoryCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-vat-category-code($categoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-vat-category-code($categoryCode)">
          <xsl:attribute name="id">BR-FR-15_BT-95_BT-102</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-15/BT-95 ou BT-102 : Code de catégorie de TVA invalide. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$categoryCode" />
            <xsl:text />". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($categoryCode = ('L', 'M'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($categoryCode = ('L', 'M'))">
          <xsl:attribute name="id">BR-FR-15_BT-95_BT-102_LM</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-15/BT-95 ou BT-102 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$categoryCode" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M31" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />
    <xsl:variable name="categoryCode" select="ram:CategoryCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-vat-category-code($categoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-vat-category-code($categoryCode)">
          <xsl:attribute name="id">BR-FR-15_BT-95_BT-118</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-15/BT-118 : Code de catégorie de TVA invalide. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$categoryCode" />
            <xsl:text />". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($categoryCode = ('L', 'M'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($categoryCode = ('L', 'M'))">
          <xsl:attribute name="id">BR-FR-15_BT-95_BT-118_LM</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-15/BT-118 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$categoryCode" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax" mode="M31" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax" />
    <xsl:variable name="categoryCode" select="ram:CategoryCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-vat-category-code($categoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-vat-category-code($categoryCode)">
          <xsl:attribute name="id">BR-FR-15_BT-95_BT-151</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-15/BT-151 : Code de catégorie de TVA invalide. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$categoryCode" />
            <xsl:text />". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($categoryCode = ('L', 'M'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($categoryCode = ('L', 'M'))">
          <xsl:attribute name="id">BR-FR-15_BT-95_BT-151_LM</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-15/BT-151 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="$categoryCode" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-16BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)-->
<svrl:text>BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax" mode="M32" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax" />
    <xsl:variable name="rate" select="string(ram:RateApplicablePercent)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($rate) or custom:is-valid-vat-rate($rate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($rate) or custom:is-valid-vat-rate($rate)">
          <xsl:attribute name="id">BR-FR-16_BT-96_BT-103</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-16/BT-96 ou BT-103 : Le taux de TVA (BT-96) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<xsl:text />
            <xsl:value-of select="$rate" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M32" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />
    <xsl:variable name="rate" select="string(ram:RateApplicablePercent)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($rate) or custom:is-valid-vat-rate($rate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($rate) or custom:is-valid-vat-rate($rate)">
          <xsl:attribute name="id">BR-FR-16_BT-119</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-16/BT-119 : Le taux de TVA (BT-119) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<xsl:text />
            <xsl:value-of select="$rate" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax" mode="M32" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax" />
    <xsl:variable name="rate" select="string(ram:RateApplicablePercent)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($rate) or custom:is-valid-vat-rate($rate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($rate) or custom:is-valid-vat-rate($rate)">
          <xsl:attribute name="id">BR-FR-16_BT-152</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-16/BT-152 : Le taux de TVA (BT-152) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<xsl:text />
            <xsl:value-of select="$rate" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-17BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)-->
<svrl:text>BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode = '916']" mode="M33" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode = '916']" />
    <xsl:variable name="code" select="normalize-space(ram:Name)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($code) or custom:is-valid-attachment-code($code)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($code) or custom:is-valid-attachment-code($code)">
          <xsl:attribute name="id">BR-FR-17_BT-123</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-17/BT-123 : Le code de qualification de la pièce jointe "<xsl:text />
            <xsl:value-of select="$code" />
            <xsl:text />" est invalide. Il doit appartenir à la liste des codes autorisés. Veuillez corriger la valeur de BT-123.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-18BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)-->
<svrl:text>BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M34" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="lisibleCount" select="count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:Name = 'LISIBLE'])" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$lisibleCount le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$lisibleCount le 1">
          <xsl:attribute name="id">BR-FR-18_BT-123</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-18/BT-123 : Il ne peut y avoir **qu’un seul** document additionnel (BG-24) dont la description (BT-123) est "LISIBLE".
        Nombre de documents trouvés : <xsl:text />
            <xsl:value-of select="$lisibleCount" />
            <xsl:text />.
        Veuillez supprimer les doublons ou corriger les descriptions.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-20BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)-->
<svrl:text>BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']" mode="M35" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']" />
    <xsl:variable name="barTreatment" select="ram:Content" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-bar-treatment($barTreatment)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-bar-treatment($barTreatment)">
          <xsl:attribute name="id">BR-FR-20_BT-21</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-20/BT-21 : Lorsqu’une note a pour code sujet « BAR » (BT-21), la valeur associée (BT-22, contenu de la note) doit être l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<xsl:text />
            <xsl:value-of select="$barTreatment" />
            <xsl:text />". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-21BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture-->
<svrl:text>BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M36" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="barTreatment" select="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content" />
    <xsl:variable name="docType" select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="siren" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />
    <xsl:variable name="endpointID" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID" />
    <xsl:variable name="endpointSchemeID" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID" />
    <xsl:variable name="isB2B" select="$barTreatment = 'B2B'" />
    <xsl:variable name="isExcludedDocType" select="$docType = ('389', '501', '500', '471', '473', '261', '502')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isB2B and not($isExcludedDocType)) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isB2B and not($isExcludedDocType)) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')">
          <xsl:attribute name="id">BR-FR-21_BT-49</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-21/BT-49 : Si le traitement est BAR/B2B et que le type de document (BT-3) n’est pas en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-49 (EndpointID) doit commencer par le SIREN (BT-47) et le BT-49-1 (schemeID) doit être égal à "0225".
        Valeurs actuelles : EndpointID="<xsl:text />
            <xsl:value-of select="$endpointID" />
            <xsl:text />", schemeID="<xsl:text />
            <xsl:value-of select="$endpointSchemeID" />
            <xsl:text />", SIREN="<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-22BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture-->
<svrl:text>BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M37" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="barTreatment" select="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content" />
    <xsl:variable name="docType" select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="siren" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />
    <xsl:variable name="endpointID" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID" />
    <xsl:variable name="endpointSchemeID" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID" />
    <xsl:variable name="isB2B" select="$barTreatment = 'B2B'" />
    <xsl:variable name="isExcludedDocType" select="$docType = ('389', '501', '500', '471', '473', '261', '502')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isB2B and $isExcludedDocType) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isB2B and $isExcludedDocType) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')">
          <xsl:attribute name="id">BR-FR-22_BT-34</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-22/BT-34 : Si le traitement est BAR/B2B et que le type de document (BT-3) est en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-34 (EndpointID du vendeur) doit commencer par le SIREN (BT-30) et le BT-34-1 (schemeID) doit être égal à "0225".
        Valeurs actuelles : EndpointID="<xsl:text />
            <xsl:value-of select="$endpointID" />
            <xsl:text />", schemeID="<xsl:text />
            <xsl:value-of select="$endpointSchemeID" />
            <xsl:text />", SIREN="<xsl:text />
            <xsl:value-of select="$siren" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-23BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)-->
<svrl:text>BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1007">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_BT-34</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/BT-34 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1006">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_BT-49</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/BT-49 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1005">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-12</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/EXT-FR-FE-12 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1004">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-29</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/EXT-FR-FE-29 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1003">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-52</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/EXT-FR-FE-52 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-75</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/EXT-FR-FE-75 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-98</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/EXT-FR-FE-98 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" mode="M38" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-121</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-23/EXT-FR-FE-121 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-24BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)-->
<svrl:text>BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']" mode="M39" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-24_BT-29</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-24/BT-29 : L'identifiant privé (ram:GlobalID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']" mode="M39" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-schemeid-format(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-schemeid-format(.)">
          <xsl:attribute name="id">BR-FR-24_BT-46</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-24/BT-46 : L'identifiant privé (ram:GlobalID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-25BR-FR-25 — Longueur maximale des adresses électroniques (CII)-->
<svrl:text>BR-FR-25 — Longueur maximale des adresses électroniques (CII)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1007">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_BT-34</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/BT-34 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1006">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_BT-49</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/BT-49 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1005">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-12</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/EXT-FR-FE-12 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1004">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-29</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/EXT-FR-FE-29 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1003">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-52</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/EXT-FR-FE-52 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-75</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/EXT-FR-FE-75 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-98</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/EXT-FR-FE-98 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M40" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 125" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 125">
          <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-121</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-25/EXT-FR-FE-121 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-26BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224-->
<svrl:text>BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']" mode="M41" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 100">
          <xsl:attribute name="id">BR-FR-26_BT-29</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-26/BT-29 : L'identifiant privé (ram:GlobalID) dépasse 100 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']" mode="M41" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) le 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) le 100">
          <xsl:attribute name="id">BR-FR-26_BT-46</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-26/BT-46 : L'identifiant privé (ram:GlobalID) dépasse 100 caractères. Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-27BR-FR-27 — Validation du groupe Attribut d’article (BG-32)-->
<svrl:text>BR-FR-27 — Validation du groupe Attribut d’article (BG-32)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic" mode="M42" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:Description or ram:TypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:Description or ram:TypeCode">
          <xsl:attribute name="id">BR-FR-27_BG-32</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-27/BG-32 : Le groupe Attribut d’article (BG-32) doit contenir soit un nom d’attribut d’article (BT-160 : ram:Description), soit un code d’attribut d’article (EXT-FR-FE-159 : ram:TypeCode).
        Aucun des deux éléments n’a été trouvé dans le contexte ApplicableProductCharacteristic.
        Veuillez ajouter au moins l’un des deux éléments pour respecter la structure attendue.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Description" mode="M42" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Description" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-27_BT-160</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-27/BT-160 : Le nom d’attribut d’article (ram:Description) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez fournir un nom d’attribut valide ou utiliser un code à la place.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode" mode="M42" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-27_EXT-FR-FE-159</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-27/EXT-FR-FE-159 : Le code d’attribut d’article (ram:TypeCode) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez fournir un code d’attribut valide ou utiliser un nom à la place.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-28BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)-->
<svrl:text>BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic" mode="M43" priority="1003">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:Value or (ram:ValueMeasure and ram:ValueMeasure/@unitCode)) and not(ram:Value and (ram:ValueMeasure and ram:ValueMeasure/@unitCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:Value or (ram:ValueMeasure and ram:ValueMeasure/@unitCode)) and not(ram:Value and (ram:ValueMeasure and ram:ValueMeasure/@unitCode))">
          <xsl:attribute name="id">BR-FR-28_BT-161-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-28/BT-161 : Le groupe Attribut d’article (BG-32) doit contenir soit une valeur d’attribut (BT-161 : ram:Value), soit une valeur d’attribut avec unité de mesure (EXT-FR-FE-160 : ram:ValueMeasure) accompagnée de son unité (EXT-FR-FE-161 : @unitCode), et pas les deux.
        Veuillez fournir une valeur d’attribut ou une valeur mesurée avec son unité, et pas les deux.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Value" mode="M43" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Value" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-28_BT-161-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-28/BT-161 : La valeur d’attribut (ram:Value) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez fournir une valeur d’attribut valide ou utiliser une mesure avec unité.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure" mode="M43" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-28_EXT-FR-FE-160</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-28/EXT-FR-FE-160 : La valeur mesurée (ram:ValueMeasure) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez fournir une valeur mesurée valide accompagnée de son unité.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure/@unitCode" mode="M43" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure/@unitCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-28_EXT-FR-FE-161</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-28/EXT-FR-FE-161 : L’unité de mesure (@unitCode) ne doit pas être vide lorsqu’une valeur mesurée est fournie.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
        Veuillez spécifier une unité de mesure conforme.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-29BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)-->
<svrl:text>BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement" mode="M44" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1">
          <xsl:attribute name="id">BR-FR-29_BT-18</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-29/BT-18 : Parmi les identifiants d’objets facturés (BT-18), les schémas d’identification "AFL" et "AVV" ne doivent être présents qu’une seule fois chacun.
        Actuellement : AFL = <xsl:text />
            <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL'])" />
            <xsl:text /> occurrence(s), AVV = <xsl:text />
            <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV'])" />
            <xsl:text /> occurrence(s).
        Veuillez supprimer les doublons pour respecter la règle.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID" mode="M44" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-29_AFL</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-29/AFL : L’identifiant associé au schéma "AFL" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID" mode="M44" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-29_AVV</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-29/AVV : L’identifiant associé au schéma "AVV" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-30BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)-->
<svrl:text>BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" mode="M45" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1">
          <xsl:attribute name="id">BR-FR-30_BT-128</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-30/BT-128 : Parmi les identifiants d’objets facturés à la ligne (BT-128), les schémas d’identification "AFL" et "AVV" ne doivent être présents qu’une seule fois chacun.
        Actuellement : AFL = <xsl:text />
            <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL'])" />
            <xsl:text /> occurrence(s), AVV = <xsl:text />
            <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV'])" />
            <xsl:text /> occurrence(s).
        Veuillez supprimer les doublons pour respecter la règle.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID" mode="M45" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-30_AFL</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-30/AFL : L’identifiant associé au schéma "AFL" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID" mode="M45" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">BR-FR-30_AVV</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-30/AVV : L’identifiant associé au schéma "AVV" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-31BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste -->
<svrl:text>BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste </svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument" mode="M46" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument" />
    <xsl:variable name="barNotes" select="ram:IncludedNote[ram:SubjectCode = 'BAR']" />
    <xsl:variable name="barCount" select="count($barNotes[normalize-space(ram:Content) = 'B2B' or normalize-space(ram:Content) = 'B2BINT' or normalize-space(ram:Content) = 'B2C' or normalize-space(ram:Content) = 'OUTOFSCOPE' or normalize-space(ram:Content) = 'ARCHIVEONLY'])" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$barCount &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$barCount &lt;= 1">
          <xsl:attribute name="id">BR-FR-30_BT-21</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-30/BT-21 : Lorsque plusieurs notes ont le code sujet « BAR » (BT-21), Il ne peut y avoir qu'une seule valeur associée (BT-22, contenu de la note) parmi l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<xsl:text />
            <xsl:value-of select="$barNotes" />
            <xsl:text />" , Nombre de valeurs présentes (pas plus de 1) : <xsl:text />
            <xsl:value-of select="$barCount" />
            <xsl:text />  "/&gt;". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-03BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)-->
<svrl:text>BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M47" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="contractReference" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID" />
    <xsl:variable name="billingPeriodStart" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />
    <xsl:variable name="billingPeriodEnd" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($typeCode = '262') or (string($contractReference) and string($billingPeriodStart) and string($billingPeriodEnd))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($typeCode = '262') or (string($contractReference) and string($billingPeriodStart) and string($billingPeriodEnd))">
          <xsl:attribute name="id">BR-FR-CO-03_BT-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-03/BT-3 : Si le code type de la facture (BT-3) est égal à 262 (Avoir Remise Globale), alors :
        - Le numéro de contrat (BT-12) doit être présent
        - La période de facturation (BG-14) doit être renseignée (dates de début et de fin).
        Valeurs actuelles : BT-12="<xsl:text />
            <xsl:value-of select="$contractReference" />
            <xsl:text />", période="<xsl:text />
            <xsl:value-of select="$billingPeriodStart" />
            <xsl:text /> à <xsl:text />
            <xsl:value-of select="$billingPeriodEnd" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M47" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M47" priority="-1" />
  <xsl:template match="@*|node()" mode="M47" priority="-2">
    <xsl:apply-templates mode="M47" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-04BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)-->
<svrl:text>BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M48" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="references" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument" />
    <xsl:variable name="refCount" select="count($references)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($typeCode = ('384', '471', '472', '473')) or $refCount = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($typeCode = ('384', '471', '472', '473')) or $refCount = 1">
          <xsl:attribute name="id">BR-FR-CO-04_BT-4</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-04/BT-3 : Si le type de facture (BT-3) est une facture rectificative (384, 471, 472, 473), alors **une et une seule** référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente.
        Nombre de références valides trouvées : <xsl:text />
            <xsl:value-of select="$refCount" />
            <xsl:text />.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M48" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M48" priority="-1" />
  <xsl:template match="@*|node()" mode="M48" priority="-2">
    <xsl:apply-templates mode="M48" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-05BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)-->
<svrl:text>BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M49" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="headerRefs" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument" />
    <xsl:variable name="headerRefCount" select="count($headerRefs[ram:IssuerAssignedID and ram:FormattedIssueDateTime/qdt:DateTimeString])" />
    <xsl:variable name="lineRefsValid" select="every $line in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies          exists($line/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument[ram:IssuerAssignedID and ram:FormattedIssueDateTime/qdt:DateTimeString])" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($typeCode = ('261', '381', '396', '502', '503')) or ($headerRefCount ge 1 or $lineRefsValid)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($typeCode = ('261', '381', '396', '502', '503')) or ($headerRefCount ge 1 or $lineRefsValid)">
          <xsl:attribute name="id">BR-FR-CO-05_BT-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-05/BT-3 : Si le type de facture (BT-3) est un avoir (261, 381, 396, 502, 503), alors :
        - soit au moins une référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente au niveau entête,
        - soit chaque ligne (BG-25) doit contenir une référence à une facture antérieure (EXT-FR-FE-136) avec sa date (EXT-FR-FE-138).
        Références entête trouvées : <xsl:text />
            <xsl:value-of select="$headerRefCount" />
            <xsl:text />.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M49" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M49" priority="-1" />
  <xsl:template match="@*|node()" mode="M49" priority="-2">
    <xsl:apply-templates mode="M49" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-07BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers-->
<svrl:text>BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M50" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="dueDate" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString" />
    <xsl:variable name="issueDate" select="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" />
    <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="frameworkCode" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BusinessTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(string($dueDate)) or          ($typeCode = ('386', '500', '503') or $frameworkCode = ('B2', 'S2', 'M2') or $dueDate ge $issueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(string($dueDate)) or ($typeCode = ('386', '500', '503') or $frameworkCode = ('B2', 'S2', 'M2') or $dueDate ge $issueDate)">
          <xsl:attribute name="id">BR-FR-CO-07_BT-9</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-07/BT-9 : La date d’échéance (BT-9), si présente, doit être postérieure ou égale à la date de facture (BT-2),
        sauf si la facture est de type acompte (386, 500, 503) ou si le cadre de facturation (BT-23) est B2, S2 ou M2.
        Valeurs actuelles : Date facture = "<xsl:text />
            <xsl:value-of select="$issueDate" />
            <xsl:text />", Date échéance = "<xsl:text />
            <xsl:value-of select="$dueDate" />
            <xsl:text />", Type = "<xsl:text />
            <xsl:value-of select="$typeCode" />
            <xsl:text />", Cadre = "<xsl:text />
            <xsl:value-of select="$frameworkCode" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M50" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M50" priority="-1" />
  <xsl:template match="@*|node()" mode="M50" priority="-2">
    <xsl:apply-templates mode="M50" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-08BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)-->
<svrl:text>BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M51" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="frameworkCode" select="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID" />
    <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($frameworkCode = ('B4', 'S4', 'M4')) or not($typeCode = ('386', '500', '503'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($frameworkCode = ('B4', 'S4', 'M4')) or not($typeCode = ('386', '500', '503'))">
          <xsl:attribute name="id">BR-FR-CO-08_BT-23</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-08/BT-23 : Si le cadre de facturation (BT-23) est B4, S4 ou M4 (factures définitives après acompte), alors le type de facture (BT-3) ne peut pas être une facture ou un avoir d’acompte (386, 500, 503).
        Valeurs actuelles : BT-23="<xsl:text />
            <xsl:value-of select="$frameworkCode" />
            <xsl:text />", BT-3="<xsl:text />
            <xsl:value-of select="$typeCode" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M51" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-09BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)-->
<svrl:text>BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M52" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="frameworkCode" select="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID" />
    <xsl:variable name="isPaidMode" select="$frameworkCode = ('B2', 'S2', 'M2')" />
    <xsl:variable name="paidAmount" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount" />
    <xsl:variable name="totalAmount" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount" />
    <xsl:variable name="dueAmount" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount" />
    <xsl:variable name="dueDate" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isPaidMode) or (number($paidAmount) = number($totalAmount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isPaidMode) or (number($paidAmount) = number($totalAmount))">
          <xsl:attribute name="id">BR-FR-CO-09_BT-23-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2 (facture déjà payée), alors le montant déjà payé (BT-113) doit être égal au montant total TTC (BT-112).
        Montant payé : <xsl:text />
            <xsl:value-of select="$paidAmount" />
            <xsl:text />, Montant total : <xsl:text />
            <xsl:value-of select="$totalAmount" />
            <xsl:text />.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isPaidMode) or (number($dueAmount) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isPaidMode) or (number($dueAmount) = 0)">
          <xsl:attribute name="id">BR-FR-CO-09_BT-23-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors le net à payer (BT-115) doit être égal à 0.
        Net à payer : <xsl:text />
            <xsl:value-of select="$dueAmount" />
            <xsl:text />.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isPaidMode) or string($dueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isPaidMode) or string($dueDate)">
          <xsl:attribute name="id">BR-FR-CO-09_BT-23-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors la date d’échéance (BT-9) doit être renseignée et correspondre à la date de paiement.
        Date d’échéance actuelle : <xsl:text />
            <xsl:value-of select="$dueDate" />
            <xsl:text />.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M52" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M52" priority="-1" />
  <xsl:template match="@*|node()" mode="M52" priority="-2">
    <xsl:apply-templates mode="M52" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-10BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID-->
<svrl:text>BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" mode="M53" priority="1009">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_BT-29-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-29 : Si l’identifiant global du vendeur (BT-29) est renseigné, alors son schéma (BT-29-1) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_BT-29-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-29 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé du vendeur (BT-29).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" mode="M53" priority="1008">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_BT-46-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-46 : Si l’identifiant global de l'acheteur (BT-46) est renseigné, alors son schéma (BT-46-1) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_BT-46-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-46 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé de l'acheteur (BT-46).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty" mode="M53" priority="1007">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_BT-60-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-60 : Si l’identifiant global du bénéficiaire (BT-60) est renseigné, alors son schéma (BT-60-1) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_BT-60-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-60 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé du bénéficiaire (BT-60).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty" mode="M53" priority="1006">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-06-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-06 : Si l’identifiant global de l'agent d'acheteur (EXT-FR-FE-06) est renseigné, alors son schéma (EXT-FR-FE-07) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-06-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-06 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé de l'agent d'acheteur (EXT-FR-FE-06).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty" mode="M53" priority="1005">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-46-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-46 : Si l’identifiant global du payeur (EXT-FR-FE-46) est renseigné, alors son schéma (EXT-FR-FE-47) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-46-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-46 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du payeur (EXT-FR-FE-46).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty" mode="M53" priority="1004">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-69-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
          BR-FR-CO-10/EXT-FR-FE-69 : Si l’identifiant global de l'agent du vendeur (EXT-FR-FE-69) est renseigné, alors son schéma (EXT-FR-FE-70) doit également être renseigné.
        </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-69-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
          BR-FR-CO-10/EXT-FR-FE-69 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé de l'agent du vendeur (EXT-FR-FE-69).
        </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty" mode="M53" priority="1003">
    <svrl:fired-rule context="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-92-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-92 : Si l’identifiant global du facturé à (EXT-FR-FE-92) est renseigné, alors son schéma (EXT-FR-FE-92-1) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-92-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-92 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du facturé à (EXT-FR-FE-92).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty" mode="M53" priority="1002">
    <svrl:fired-rule context="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-115-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-115 : Si l’identifiant global du facturant (EXT-FR-FE-115) est renseigné, alors son schéma (EXT-FR-FE-116) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-115-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-115 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du facturant (EXT-FR-FE-115).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" mode="M53" priority="1001">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_BT-71-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-71 : Si l’identifiant global du livré à (BT-71) est renseigné, alors son schéma (BT-71-1) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_BT-71-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/BT-71 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du livré à (BT-71).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty" mode="M53" priority="1000">
    <svrl:fired-rule context="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $id in ram:GlobalID satisfies $id/@schemeID">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-146-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-146 : Si l’identifiant global du livré à à la ligne (EXT-FR-FE-146 ) est renseigné, alors son schéma (EXT-FR-FE-147) doit également être renseigné.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
          <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-146-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-146  : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du livré à à la ligne (EXT-FR-FE-146 ).
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M53" priority="-1" />
  <xsl:template match="@*|node()" mode="M53" priority="-2">
    <xsl:apply-templates mode="M53" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-12BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR-->
<svrl:text>BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M54" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="invoiceCurrency" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode" />
    <xsl:variable name="accountingCurrency" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode" />
    <xsl:variable name="taxAmountEUR" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($invoiceCurrency != 'EUR') or          ($accountingCurrency = 'EUR' and string($taxAmountEUR))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($invoiceCurrency != 'EUR') or ($accountingCurrency = 'EUR' and string($taxAmountEUR))">
          <xsl:attribute name="id">BR-FR-CO-12_BT-5</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-12/BT-5 : Si la devise de facture (BT-5) est différente de EUR, alors :
        - la devise de comptabilité (BT-6) doit être présente et égale à EUR,
        - le montant de TVA en devise de comptabilité (BT-111) doit être renseigné,
        - et sa devise (BT-111-1) doit être égale à EUR.
        Valeurs actuelles : BT-5="<xsl:text />
            <xsl:value-of select="$invoiceCurrency" />
            <xsl:text />", BT-6="<xsl:text />
            <xsl:value-of select="$accountingCurrency" />
            <xsl:text />", BT-111="<xsl:text />
            <xsl:value-of select="$taxAmountEUR" />
            <xsl:text />"/&gt;".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M54" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M54" priority="-1" />
  <xsl:template match="@*|node()" mode="M54" priority="-2">
    <xsl:apply-templates mode="M54" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-14BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique-->
<svrl:text>BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M55" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="isAU" select="exists(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID = '0231'])" />
    <xsl:variable name="hasTXDNote" select="exists(rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'TXD' and ram:Content = 'MEMBRE_ASSUJETTI_UNIQUE'])" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isAU) or $hasTXDNote" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isAU) or $hasTXDNote">
          <xsl:attribute name="id">BR-FR-CO-14_BT-29-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-14/BT-29-1 : Si le schéma d’identification du vendeur (BT-29-1) est '0231', cela signifie qu’il est membre d’un assujetti unique.
        Dans ce cas, une note (BG-1) avec le code sujet 'TXD' (BT-21) et le texte 'MEMBRE_ASSUJETTI_UNIQUE' (BT-22) doit être présente.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M55" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M55" priority="-1" />
  <xsl:template match="@*|node()" mode="M55" priority="-2">
    <xsl:apply-templates mode="M55" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-CO-15BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)-->
<svrl:text>BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice" mode="M56" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice" />
    <xsl:variable name="isAU" select="some $id in ./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID satisfies $id/@schemeID = '0231'" />
    <xsl:variable name="fiscalRep" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty" />
    <xsl:variable name="fiscalVAT" select="$fiscalRep/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($isAU) or (exists($fiscalRep) and string($fiscalVAT))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($isAU) or (exists($fiscalRep) and string($fiscalVAT))">
          <xsl:attribute name="id">BR-FR-CO-15_BT-29-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-CO-15/BT-29-1 : Si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231), alors le bloc représentant fiscal (BG-11) doit être présent et contenir le numéro de TVA de l’assujetti unique (BT-63).
        État actuel : représentant fiscal <xsl:text />
            <xsl:value-of select="if (exists($fiscalRep)) then 'présent' else 'absent'" />
            <xsl:text />, numéro de TVA = "<xsl:text />
            <xsl:value-of select="$fiscalVAT" />
            <xsl:text />".
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M56" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M56" priority="-1" />
  <xsl:template match="@*|node()" mode="M56" priority="-2">
    <xsl:apply-templates mode="M56" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-DEC-01BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)-->
<svrl:text>BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount" mode="M57" priority="1016">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-92_BT-99</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-92/BT-99 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount" mode="M57" priority="1015">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-93_BT-100</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-93 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount" mode="M57" priority="1014">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-106</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-106 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount" mode="M57" priority="1013">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-107</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-107 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount" mode="M57" priority="1012">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-108</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-108 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount" mode="M57" priority="1011">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-109</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-109 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" mode="M57" priority="1010">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-110</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-110 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" mode="M57" priority="1009">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2(normalize-space(.))">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-111</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>BR-FR-DEC-01/BT-111 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount" mode="M57" priority="1008">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-112</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-112 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount" mode="M57" priority="1007">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-113</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-113 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount" mode="M57" priority="1006">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-114</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-114 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount" mode="M57" priority="1005">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-115</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-115 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount" mode="M57" priority="1004">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-116</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-116 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount" mode="M57" priority="1003">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-117</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-117 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount" mode="M57" priority="1002">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-131</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-131 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount" mode="M57" priority="1001">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-136_BT-141</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-136 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount" mode="M57" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-2($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-2($amount)">
          <xsl:attribute name="id">BR-FR-DEC-01_BT-137_BT-142</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-01/BT-137 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M57" priority="-1" />
  <xsl:template match="@*|node()" mode="M57" priority="-2">
    <xsl:apply-templates mode="M57" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-DEC-02BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)-->
<svrl:text>BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" mode="M58" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" />
    <xsl:variable name="quantity" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-4($quantity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-4($quantity)">
          <xsl:attribute name="id">BR-FR-DEC-02_BT-129</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-02/BT-129 : La quantité « <xsl:text />
            <xsl:value-of select="$quantity" />
            <xsl:text /> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M58" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity" mode="M58" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity" />
    <xsl:variable name="quantity" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-4($quantity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-4($quantity)">
          <xsl:attribute name="id">BR-FR-DEC-02_BT-149</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-02/BT-149 : La quantité « <xsl:text />
            <xsl:value-of select="$quantity" />
            <xsl:text /> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M58" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M58" priority="-1" />
  <xsl:template match="@*|node()" mode="M58" priority="-2">
    <xsl:apply-templates mode="M58" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-DEC-03BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)-->
<svrl:text>BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount" mode="M59" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-6-positive($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-6-positive($amount)">
          <xsl:attribute name="id">BR-FR-DEC-03_BT-146</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-03/BT-146 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount" mode="M59" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-6-positive($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-6-positive($amount)">
          <xsl:attribute name="id">BR-FR-DEC-03_BT-147</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-03/BT-147 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount" mode="M59" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount" />
    <xsl:variable name="amount" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-decimal-19-6-positive($amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-decimal-19-6-positive($amount)">
          <xsl:attribute name="id">BR-FR-DEC-03_BT-148</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-03/BT-148 : Le montant « <xsl:text />
            <xsl:value-of select="$amount" />
            <xsl:text /> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M59" priority="-1" />
  <xsl:template match="@*|node()" mode="M59" priority="-2">
    <xsl:apply-templates mode="M59" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN BR-FR-DEC-04BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)-->
<svrl:text>BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)</svrl:text>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent" mode="M60" priority="1002">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent" />
    <xsl:variable name="rate" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-percent-4-2-positive($rate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-percent-4-2-positive($rate)">
          <xsl:attribute name="id">BR-FR-DEC-04_BT-96_BT-103</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-04/BT-96 ou BT-103 : Le taux de TVA « <xsl:text />
            <xsl:value-of select="$rate" />
            <xsl:text /> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M60" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent" mode="M60" priority="1001">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent" />
    <xsl:variable name="rate" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-percent-4-2-positive($rate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-percent-4-2-positive($rate)">
          <xsl:attribute name="id">BR-FR-DEC-04_BT-119</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-04/BT-119 : Le taux de TVA « <xsl:text />
            <xsl:value-of select="$rate" />
            <xsl:text /> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M60" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent" mode="M60" priority="1000">
    <svrl:fired-rule context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent" />
    <xsl:variable name="rate" select="normalize-space(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="custom:is-valid-percent-4-2-positive($rate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="custom:is-valid-percent-4-2-positive($rate)">
          <xsl:attribute name="id">BR-FR-DEC-04_BT-152</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        BR-FR-DEC-04/BT-152 : Le taux de TVA « <xsl:text />
            <xsl:value-of select="$rate" />
            <xsl:text /> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M60" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M60" priority="-1" />
  <xsl:template match="@*|node()" mode="M60" priority="-2">
    <xsl:apply-templates mode="M60" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
