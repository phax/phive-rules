<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:custom="http://www.example.org/custom"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
                xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
                xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossDomainAcknowledgementAndResponse:100"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->

   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->

   <!--KEYS AND FUNCTIONS-->
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-id-format"
                 as="xs:boolean">
      <xsl:param name="id" as="xs:string"/>
      <xsl:sequence select="       matches(normalize-space($id), '^[A-Za-z0-9+\-_/]+$') and       not(matches($id, ' ')) and       not(starts-with($id, ' ')) and       not(ends-with($id, ' '))       "/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-date-format"
                 as="xs:boolean">
      <xsl:param name="date" as="xs:string"/>
      <!-- Vérifie le format AAAAMMJJ -->
      <xsl:variable name="isFormatValid"
                    select="matches($date, '^20\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$')"/>
      <!-- Extraction des composantes -->
      <xsl:variable name="year" select="number(substring($date, 1, 4))"/>
      <xsl:variable name="month" select="number(substring($date, 5, 2))"/>
      <xsl:variable name="day" select="number(substring($date, 7, 2))"/>
      <!-- Calcul année bissextile -->
      <xsl:variable name="isLeapYear"
                    select="($year mod 4 = 0 and $year mod 100 != 0) or ($year mod 400 = 0)"/>
      <!-- Nombre de jours max selon le mois -->
      <xsl:variable name="maxDay"
                    select="       if ($month = (1, 3, 5, 7, 8, 10, 12)) then 31       else if ($month = (4, 6, 9, 11)) then 30       else if ($month = 2 and $isLeapYear) then 29       else if ($month = 2) then 28       else 0"/>
      <!-- Résultat final -->
      <xsl:sequence select="$isFormatValid and $day le $maxDay"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-document-type-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="custom:document-type-codes"
                    as="xs:string"
                    select="'380 389 393 501 386 500 384 471 472 473 261 262 381 396 502 503'"/>
      <xsl:sequence select="$code = tokenize($custom:document-type-codes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-billing-mode"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="custom:billing-modes"
                    as="xs:string"
                    select="'B1 S1 M1 B2 S2 S3 M2 B4 S4 M4 S5 S6 B7 S7 B8 S8 M8 B9 S9 M9'"/>
      <xsl:sequence select="$code = tokenize($custom:billing-modes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:check-siret-siren-coherence"
                 as="xs:boolean">
      <xsl:param name="siret" as="xs:string?"/>
      <xsl:param name="siren" as="xs:string?"/>
      <xsl:sequence select="matches($siret, '^\d{14}$') and substring($siret, 1, 9) = $siren"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-bar-treatment"
                 as="xs:boolean">
      <xsl:param name="value" as="xs:string?"/>
      <xsl:sequence select="$value = ('B2B', 'B2BINT', 'B2C', 'OUTOFSCOPE', 'ARCHIVEONLY')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-eas-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="custom:eas-codes"
                    as="xs:string"
                    select="'AN AQ AS AU EM 0002 0007 0009 0037 0060 0088 0096 0097 0106        0130 0135 0142 0147 0151 0154 0158 0170 0177 0183 0184 0188 0190        0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204        0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0218 0221 0225        0230 0235 0240 0242 0244 0245 0246 0248        9910 9913 9914 9915 9918 9919 9920 9922 9923 9924        9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937        9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950        9951 9952 9953 9957 9959'"/>
      <xsl:sequence select="$code = tokenize($custom:eas-codes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-vat-category-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="validCodes" select="('S', 'E', 'AE', 'K', 'G', 'O', 'Z')"/>
      <xsl:sequence select="$code = $validCodes"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-vat-rate"
                 as="xs:boolean">
      <xsl:param name="rate" as="xs:string"/>
      <xsl:variable name="validRates"
                    select="(       '0', '0.0', '0.00', '10', '10.0', '10.00', '13', '13.0', '13.00', '20', '20.0', '20.00',       '8.5', '8.50', '19.6', '19.60', '2.1', '2.10', '5.5', '5.50', '7', '7.0', '7.00',       '20.6', '20.60', '1.05', '0.9', '0.90', '1.75', '9.2', '9.20', '9.6', '9.60'       )"/>
      <xsl:sequence select="$rate = $validRates"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-attachment-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="validCodes"
                    select="(       'RIB', 'LISIBLE', 'FEUILLE_DE_STYLE', 'PJA', 'BORDEREAU_SUIVI',       'DOCUMENT_ANNEXE', 'BON_LIVRAISON', 'BON_COMMANDE',       'BORDEREAU_SUIVI_VALIDATION', 'ETAT_ACOMPTE', 'FACTURE_PAIEMENT_DIRECT'       )"/>
      <xsl:sequence select="$code = $validCodes"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-schemeid-format"
                 as="xs:boolean">
      <xsl:param name="value" as="xs:string"/>
      <!-- Autorise lettres, chiffres, + - _ / sans espaces -->
      <xsl:sequence select="matches($value, '^[A-Za-z0-9+\-_/]+$')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-decimal-19-2"
                 as="xs:boolean">
      <xsl:param name="amount" as="xs:string"/>
      <xsl:sequence select="matches($amount, '^[-]?\d{1,19}(\.\d{1,2})?$') and string-length(replace($amount, '\.', '')) le 19"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-decimal-19-4"
                 as="xs:boolean">
      <xsl:param name="quantity" as="xs:string"/>
      <xsl:sequence select="matches($quantity, '^[-]?\d{1,19}(\.\d{1,4})?$') and string-length(replace($quantity, '\.', '')) le 19"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-decimal-19-6-positive"
                 as="xs:boolean">
      <xsl:param name="amount" as="xs:string"/>
      <xsl:sequence select="matches($amount, '^\d{1,19}(\.\d{1,6})?$') and string-length(replace($amount, '\.', '')) le 19"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-percent-4-2-positive"
                 as="xs:boolean">
      <xsl:param name="percent" as="xs:string"/>
      <xsl:sequence select="matches($percent, '^\d{1,4}(\.\d{1,2})?$') and string-length(replace($percent, '\.', '')) le 4"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-invoice-status-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="custom:invoice-status-codes"
                    as="xs:string"
                    select="'200 201 202 203 204 205 206 207 208 209 210 211 212 213 214                220 221 224 225 226 227 228                250 251                300 301 400 401 500 501 601'"/>
      <xsl:sequence select="$code = tokenize($custom:invoice-status-codes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-status-reason-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="custom:status-reason-codes"
                    as="xs:string"
                    select="'RETRAIT_MAN_SERV ST_CT_NON_DECLAR SUPPR_COMP_AVOIR TRANSF_PMNT_REGIE CONTACT_ACHTR NON_TRANSMISE JUSTIF_ABS ROUTAGE_ERR AUTRE COORD_BANC_ERR TX_TVA_ERR MONTANTTOTAL_ERR CALCUL_ERR NON_CONFORME DOUBLON DEST_INC DEST_ERR TRANSAC_INC EMMET_INC CONTRAT_TERM DOUBLE_FACT CMD_ERR ADR_ERR SIRET_ERR CODE_ROUTAGE_ERR REF_CT_ABSENT REF_ERR PU_ERR REM_ERR QTE_ERR ART_ERR MODPAI_ERR QUALITE_ERR LIVR_INCOMP REJ_SEMAN REJ_UNI REJ_COH REJ_ADR REJ_CONT_B2G REJ_REF_PJ REJ_ASS_PJ IRR_VIDE_F IRR_TYPE_F IRR_SYNTAX IRR_TAILLE_PJ IRR_NOM_PJ IRR_VID_PJ IRR_EXT_DOC IRR_TAILLE_F IRR_ANTIVIRUS IRR_NOM_F'"/>
      <xsl:sequence select="$code = tokenize($custom:status-reason-codes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-invoice-action-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string"/>
      <xsl:variable name="custom:invoice-action-codes"
                    as="xs:string"
                    select="'NOA PIN NIN CNF CNP CNA OTH'"/>
      <xsl:sequence select="$code = tokenize($custom:invoice-action-codes, '\s+')"/>
   </xsl:function>
   <!--DEFAULT RULES-->

   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.example.org/custom" prefix="custom"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:CrossDomainAcknowledgementAndResponse:100"
                                             prefix="rsm"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
                                             prefix="ram"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
                                             prefix="qdt"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
                                             prefix="udt"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-04</xsl:attribute>
            <xsl:attribute name="name">BR-FR-04 — Validation des codes de type de document</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-01</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-01 — Présence obligatoire de MDG-3</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-02</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-02 — Vérification de la valeur de MDT-3</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-03</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-03 — Présence obligatoire de MDT-4</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-04</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-04 — Présence obligatoire de MDG-4</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-05</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-05 — Présence obligatoire de MDG-9</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-06</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-06 — Présence obligatoire de MDT-21</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-07</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-07 — Validation conditionnelle de MDT-38 selon MDT-77</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-08</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-08 — Obligation conditionnelle de MDT-73</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-09</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-09 — Présence et valeur de MDT-77</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-10</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-10 — Présence obligatoire de MDT-87</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-11</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-11 — Présence obligatoire de MDG-35</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-12</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-12 — Présence obligatoire de MDT-105</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-13</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-13 — Présence obligatoire de MDT-129</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-14</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-14 — Vérification des caractéristiques en cas de statut "Encaissé"</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-15</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-15 — Vérification de la présence d'un Motif quand nécessaire. </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-16</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-16 — Présence obligatoire de MDT-124-2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-01</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-01 — Liste fermée de valeurs pour MDT-2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-02</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-02 — Contrôle de cohérence entre MDT-77 et MDT-21</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-03</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-03 — Contrôle de cohérence entre MDT-77 et MDT-40</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-04</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-04 — Liste fermée de valeurs pour MDT-59</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-05</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-05 — Contrôle des statuts MDT-88 selon MDT-77</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-06</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-06 — Liste fermée de codes statuts de facture</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-07</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-07 — Vérification de la valeur de MDT-132</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-08</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-08 — Liste fermée de valeurs pour MDT-158</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-09</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-09 — Liste fermée de codes motifs de statuts</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-10</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-10 — Liste fermée de codes actions de facture</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CDV-CL-11</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CDV-CL-11 — Liste fermée de codes pour MDT-207</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->

   <!--PATTERN BR-FR-04BR-FR-04 — Validation des codes de type de document-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-04 — Validation des codes de type de document</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:TypeCode"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-document-type-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-document-type-code(.)">
               <xsl:attribute name="id">BR-FR-04_MDT-91</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-04/MDT-91] : Le code de type de document "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>" n'est pas autorisé selon les spécifications françaises.
        Veuillez utiliser un code parmi ceux définis dans la documentation (ex. : 380, 389, 393, etc.).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-01BR-FR-CDV-01 — Présence obligatoire de MDG-3-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-01 — Présence obligatoire de MDG-3</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="."/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".">
               <xsl:attribute name="id">BR-FR-CDV-01_MDG-3</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-01/MDG-3] : Le paramètre de contexte MDG-3 est obligatoire dans le document.
        Veuillez vous assurer que l'élément ram:GuidelineSpecifiedDocumentContextParameter est bien présent et correctement renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-02BR-FR-CDV-02 — Vérification de la valeur de MDT-3-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-02 — Vérification de la valeur de MDT-3</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn.cpro.gouv.fr:1p0:CDV:invoice'          or (./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn.cpro.gouv.fr:1p0:CDV:einvoicingF2' and count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID) = 1 and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID[@schemeID='0238'] = '0000' and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode = 'DFH')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn.cpro.gouv.fr:1p0:CDV:invoice' or (./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn.cpro.gouv.fr:1p0:CDV:einvoicingF2' and count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID) = 1 and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID[@schemeID='0238'] = '0000' and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode = 'DFH')">
               <xsl:attribute name="id">BR-FR-CDV-02_MDT-3</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-02/MDT-3] : La valeur de MDT-3 doit être :
        - "urn.cpro.gouv.fr:1p0:CDV:invoice", ou
        - "urn.cpro.gouv.fr:1p0:CDV:einvoicingF2" **uniquement si** il y a un unique Destinataire (Recipent) et que c'est le PPF : GlobalID = 0000 avec @shemeId = 0238 et CodeRole = DFH. 
        Valeurs actuelles : "<xsl:text/>
                  <xsl:value-of select="./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID"/>
                  <xsl:text/>". Nombre de Recipient : "<xsl:text/>
                  <xsl:value-of select="count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID)"/>
                  <xsl:text/>" - GlobalID : "<xsl:text/>
                  <xsl:value-of select="../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID"/>
                  <xsl:text/>" - @shemeID : "<xsl:text/>
                  <xsl:value-of select="../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID/@schemeID"/>
                  <xsl:text/>" - CodeRole : "<xsl:text/>
                  <xsl:value-of select="../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode"/>
                  <xsl:text/>"
        Veuillez corriger cette valeur pour respecter les spécifications du format CDV.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-03BR-FR-CDV-03 — Présence obligatoire de MDT-4-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-03 — Présence obligatoire de MDT-4</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="rsm:ExchangedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ram:ID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ram:ID">
               <xsl:attribute name="id">BR-FR-CDV-03_MDT-4</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-03/MDT-4] : L'identifiant du document (ram:ID) est obligatoire.
        Veuillez vous assurer que l'élément "ram:ID" est bien présent dans "rsm:ExchangedDocument".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-04BR-FR-CDV-04 — Présence obligatoire de MDG-4-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-04 — Présence obligatoire de MDG-4</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:IssueDateTime"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:IssueDateTime"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="."/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".">
               <xsl:attribute name="id">BR-FR-CDV-04_MDG-4</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-04/MDG-4] : La date d’émission du document (MDG-4) est obligatoire.
        Veuillez vous assurer que l’élément "ram:IssueDateTime" est bien présent dans "rsm:ExchangedDocument".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-05BR-FR-CDV-05 — Présence obligatoire de MDG-9-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-05 — Présence obligatoire de MDG-9</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:SenderTradeParty"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:SenderTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="."/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".">
               <xsl:attribute name="id">BR-FR-CDV-05_MDG-9</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-05/MDG-9] : Le partenaire commercial émetteur (MDG-9) est obligatoire.
        Veuillez vous assurer que l’élément "ram:SenderTradeParty" est bien présent dans "rsm:ExchangedDocument".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-06BR-FR-CDV-06 — Présence obligatoire de MDT-21-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-06 — Présence obligatoire de MDT-21</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:SenderTradeParty/ram:RoleCode"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:SenderTradeParty/ram:RoleCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="."/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".">
               <xsl:attribute name="id">BR-FR-CDV-06_MDT-21</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-06/MDT-21] : Le rôle du partenaire commercial émetteur (MDT-21) est obligatoire.
        Veuillez vous assurer que l’élément "ram:RoleCode" est bien présent dans "rsm:ExchangedDocument/ram:SenderTradeParty".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-07BR-FR-CDV-07 — Validation conditionnelle de MDT-38 selon MDT-77-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-07 — Validation conditionnelle de MDT-38 selon MDT-77</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:IssuerTradeParty"
                 priority="1001"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:IssuerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../../rsm:AcknowledgementDocument/ram:TypeCode != '23' or ram:GlobalID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="../../rsm:AcknowledgementDocument/ram:TypeCode != '23' or ram:GlobalID">
               <xsl:attribute name="id">BR-FR-CDV-07_MDT-38_yes</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-07/MDT-38] : Lorsque le Code type du bloc Acknowledgement (MDT-77) est égal à "23", l'identifiant (MDT-38) doit être renseigné.
        Veuillez vous assurer que l'élément "ram:GlobalID" est présent dans "ram:IssuerTradeParty".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:IssuerTradeParty"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:IssuerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../rsm:AcknowledgementDocument/ram:TypeCode != '305' or count(../ram:RecipientTradeParty/ram:RoleCode='DFH') ge 0) or not(ram:GlobalID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../rsm:AcknowledgementDocument/ram:TypeCode != '305' or count(../ram:RecipientTradeParty/ram:RoleCode='DFH') ge 0) or not(ram:GlobalID)">
               <xsl:attribute name="id">BR-FR-CDV-07_MDT-38_no</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-07/MDT-38] : Lorsque Code type du bloc Acknowledgement (MDT-77) est égal à "305", l'identifiant (MDT-38) ne doit pas être renseigné.
        Veuillez retirer l'élément "ram:GlobalID" de "ram:IssuerTradeParty" dans ce cas.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-08BR-FR-CDV-08 — Obligation conditionnelle de MDT-73-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-08 — Obligation conditionnelle de MDT-73</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:RecipientTradeParty"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:RecipientTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(ram:RoleCode = 'WK' or ram:RoleCode = 'DFH') or ram:URIUniversalCommunication/ram:URIID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(ram:RoleCode = 'WK' or ram:RoleCode = 'DFH') or ram:URIUniversalCommunication/ram:URIID">
               <xsl:attribute name="id">BR-FR-CDV-08_MDT-73</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-08/MDT-73] : Lorsque le rôle du destinataire (MDT-59) est différent de "WK" ou "DFH", l'adresse électronique du destinataire (MDT-73) est obligatoire.
        Veuillez vous assurer que l’élément "ram:URIID" est bien présent dans "ram:URIUniversalCommunication".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-09BR-FR-CDV-09 — Présence et valeur de MDT-77-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-09 — Présence et valeur de MDT-77</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:TypeCode"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = '23' or . = '305'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". = '23' or . = '305'">
               <xsl:attribute name="id">BR-FR-CDV-09_MDT-77</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-09/MDT-77] : Le code de type de document (MDT-77) est obligatoire et doit être égal à "23" ou "305".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-10BR-FR-CDV-10 — Présence obligatoire de MDT-87-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-10 — Présence obligatoire de MDT-87</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerAssignedID"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="."/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".">
               <xsl:attribute name="id">BR-FR-CDV-10_MDT-87</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-10/MDT-87] : L'identifiant de la facture référencée (MDT-87) est obligatoire.
        Veuillez vous assurer que l’élément "ram:IssuerAssignedID" est bien présent dans "rsm:ReferenceReferencedDocument".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-11BR-FR-CDV-11 — Présence obligatoire de MDG-35-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-11 — Présence obligatoire de MDG-35</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ram:FormattedIssueDateTime) or /rsm:CrossDomainAcknowledgementAndResponse/rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode = '501'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(ram:FormattedIssueDateTime) or /rsm:CrossDomainAcknowledgementAndResponse/rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode = '501'">
               <xsl:attribute name="id">BR-FR-CDV-11_MDG-35</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-11/MDG-35] : La date d’émission formatée de la facture référencée (MDG-35) est obligatoire,
        sauf si MDT-105 (code statut) est égal à "501" (IRRECEVABLE).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-12BR-FR-CDV-12 — Présence obligatoire de MDT-105-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-12 — Présence obligatoire de MDT-105</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ram:ProcessConditionCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(ram:ProcessConditionCode)">
               <xsl:attribute name="id">BR-FR-CDV-12_MDT-105</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-12/MDT-105] : Le code de condition de traitement (MDT-105) est obligatoire.
        Veuillez vous assurer que l’élément "ram:ProcessConditionCode" est bien présent dans "rsm:ReferenceReferencedDocument".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-13BR-FR-CDV-13 — Présence obligatoire de MDT-129-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-13 — Présence obligatoire de MDT-129</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerTradeParty"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ram:GlobalID) or /rsm:CrossDomainAcknowledgementAndResponse/rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode = '501'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(ram:GlobalID) or /rsm:CrossDomainAcknowledgementAndResponse/rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode = '501'">
               <xsl:attribute name="id">BR-FR-CDV-13_MDT-129</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-13/MDT-129] : L'identifiant du vendeur émetteur de la facture (en direct ou pour son compte) (MDT-129) est obligatoire,
        sauf si MDT-105 est égal à "501".
        En cas de présence, une valeur au moins doit correspondre à l'Identifiant légal du VENDEUR tel que présent dans la facture en BT-30.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-14BR-FR-CDV-14 — Vérification des caractéristiques en cas de statut "Encaissé"-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-14 — Vérification des caractéristiques en cas de statut "Encaissé"</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ram:ProcessConditionCode = '212') or          ((count(ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[ram:TypeCode = 'MEN']) ge 1 )         and (count(ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[ram:TypeCode = 'MEN']) = count(ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[ram:TypeCode = 'MEN' and ram:ValueAmount and ram:ValuePercent])))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(ram:ProcessConditionCode = '212') or ((count(ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[ram:TypeCode = 'MEN']) ge 1 ) and (count(ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[ram:TypeCode = 'MEN']) = count(ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic[ram:TypeCode = 'MEN' and ram:ValueAmount and ram:ValuePercent])))">
               <xsl:attribute name="id">BR-FR-CDV-14_MDT-207</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-14/MDT-207] : Si le statut est "Encaissé" (MDT-105 = 212), ALORS il doit y avoir au moins 1 Bloc MDG-43 avec une valeur de MDT-207 = MEN et tous les blocs MDG-43 avec une valeur MDT-207 = "MEN" doivent contenir une valeur MDT-215 (Montant) et une valeur de MDT-224 (pourcentage de TVA).
        Veuillez vérifier la présence et le contenu de ces éléments.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-15BR-FR-CDV-15 — Vérification de la présence d'un Motif quand nécessaire. -->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-15 — Vérification de la présence d'un Motif quand nécessaire. </svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not((.) = '210' or (.) = '213' or (.) = '501' or (.) = '207' or (.) = '206' or (.) = '208') or (((.) = '210' or (.) = '213' or (.) = '501' or (.) = '207' or (.) = '206' or (.) = '208') and ../ram:SpecifiedDocumentStatus/ram:ReasonCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not((.) = '210' or (.) = '213' or (.) = '501' or (.) = '207' or (.) = '206' or (.) = '208') or (((.) = '210' or (.) = '213' or (.) = '501' or (.) = '207' or (.) = '206' or (.) = '208') and ../ram:SpecifiedDocumentStatus/ram:ReasonCode)">
               <xsl:attribute name="id">BR-FR-CDV-15_MDT-113</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-15/MDT-113] : Code Statut : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>" : lorsque le statut (MDT-105 ou MDT-115) est égal à 210 (Refusée), 123 (Rejetée), 501 (Irrecevable), 207 (Litige), 206 (Suspendue) pu 208 (Approuvée Partiellement), lors un MOTIF (MDT-113) DOIT être présent.
        Veuillez vérifier la présence et le contenu du MOTIF (MDT-113).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-16BR-FR-CDV-16 — Présence obligatoire de MDT-124-2-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-16 — Présence obligatoire de MDT-124-2</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ram:SequenceNumeric)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(ram:SequenceNumeric)">
               <xsl:attribute name="id">BR-FR-CDV-16_MDT-124-2</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-16/MDT-124-2] : Le numéro incrémental de détail de statut (MDT-124-2) est obligatoire si un détail de statut (MDG-37) est présent.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-01BR-FR-CDV-CL-01 — Liste fermée de valeurs pour MDT-2-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-01 — Liste fermée de valeurs pour MDT-2</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocumentContext"/>
      <xsl:variable name="TestPPF"
                    select="(count(../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID) = 1 and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:GlobalID[@schemeID='0238'] = '0000' and ../rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode = 'DFH')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(not($TestPPF) and (ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('REGULATED' ,'NON_REGULATED','B2C' ,'B2CINT','B2BINT', 'OUTOFSCOPE'))) or ($TestPPF and (string-length(normalize-space(ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID)) &lt;= 3))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(not($TestPPF) and (ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('REGULATED' ,'NON_REGULATED','B2C' ,'B2CINT','B2BINT', 'OUTOFSCOPE'))) or ($TestPPF and (string-length(normalize-space(ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID)) &lt;= 3))">
               <xsl:attribute name="id">BR-FR-CDV-CL-01_MDT-2</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-01/MDT-2] : La valeur de MDT-2 doit être l'une des suivantes : "REGULATED", "NON_REGULATED", "B2C", "B2CINT", "B2BINT", "OUTOFSCOPE" sauf pour un CDV pour le PPF pourlequel le nombre de caractères DOIT être inférieur à 3. 
        Valeur actuelle : CDV PPF ? (true) : "<xsl:text/>
                  <xsl:value-of select="$TestPPF"/>
                  <xsl:text/>" - Valeur MDT-2 : "<xsl:text/>
                  <xsl:value-of select="ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
                  <xsl:text/>". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-02BR-FR-CDV-CL-02 — Contrôle de cohérence entre MDT-77 et MDT-21-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-02 — Contrôle de cohérence entre MDT-77 et MDT-21</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="rsm:ExchangedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '305') or          ram:SenderTradeParty/ram:RoleCode = 'WK'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '305') or ram:SenderTradeParty/ram:RoleCode = 'WK'">
               <xsl:attribute name="id">BR-FR-CDV-CL-02_MDT-21_305</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-02/MDT-21] : Lorsque le statut (MDT-77) est "305", le rôle du partenaire commercial émetteur (MDT-21) doit être "WK".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:SenderTradeParty/ram:RoleCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '23') or          ram:SenderTradeParty/ram:RoleCode = 'BY' or         ram:SenderTradeParty/ram:RoleCode = 'AB' or         ram:SenderTradeParty/ram:RoleCode = 'DL' or         ram:SenderTradeParty/ram:RoleCode = 'SE' or         ram:SenderTradeParty/ram:RoleCode = 'SR' or         ram:SenderTradeParty/ram:RoleCode = 'WK' or         ram:SenderTradeParty/ram:RoleCode = 'PE' or         ram:SenderTradeParty/ram:RoleCode = 'PR' or         ram:SenderTradeParty/ram:RoleCode = 'II' or         ram:SenderTradeParty/ram:RoleCode = 'IV'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '23') or ram:SenderTradeParty/ram:RoleCode = 'BY' or ram:SenderTradeParty/ram:RoleCode = 'AB' or ram:SenderTradeParty/ram:RoleCode = 'DL' or ram:SenderTradeParty/ram:RoleCode = 'SE' or ram:SenderTradeParty/ram:RoleCode = 'SR' or ram:SenderTradeParty/ram:RoleCode = 'WK' or ram:SenderTradeParty/ram:RoleCode = 'PE' or ram:SenderTradeParty/ram:RoleCode = 'PR' or ram:SenderTradeParty/ram:RoleCode = 'II' or ram:SenderTradeParty/ram:RoleCode = 'IV'">
               <xsl:attribute name="id">BR-FR-CDV-CL-02_MDT-21_23</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-02/MDT-21] : Lorsque le statut (MDT-77) est "23", le rôle du partenaire commercial émetteur (MDT-21) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "WK", "PE", "PR", "II", "IV".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:SenderTradeParty/ram:RoleCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-03BR-FR-CDV-CL-03 — Contrôle de cohérence entre MDT-77 et MDT-40-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-03 — Contrôle de cohérence entre MDT-77 et MDT-40</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="rsm:ExchangedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '305') or          ram:IssuerTradeParty/ram:RoleCode = 'WK'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '305') or ram:IssuerTradeParty/ram:RoleCode = 'WK'">
               <xsl:attribute name="id">BR-FR-CDV-CL-03_MDT-40_305</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-03/MDT-40] : Lorsque le statut (MDT-77) est "305", le rôle du partenaire commercial émetteur (MDT-40) doit être "WK".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:IssuerTradeParty/ram:RoleCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '23') or          ram:IssuerTradeParty/ram:RoleCode = 'BY' or         ram:IssuerTradeParty/ram:RoleCode = 'AB' or         ram:IssuerTradeParty/ram:RoleCode = 'DL' or         ram:IssuerTradeParty/ram:RoleCode = 'SE' or         ram:IssuerTradeParty/ram:RoleCode = 'SR' or         ram:IssuerTradeParty/ram:RoleCode = 'PE' or         ram:IssuerTradeParty/ram:RoleCode = 'PR' or         ram:IssuerTradeParty/ram:RoleCode = 'II' or         ram:IssuerTradeParty/ram:RoleCode = 'IV'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(../rsm:AcknowledgementDocument/ram:TypeCode = '23') or ram:IssuerTradeParty/ram:RoleCode = 'BY' or ram:IssuerTradeParty/ram:RoleCode = 'AB' or ram:IssuerTradeParty/ram:RoleCode = 'DL' or ram:IssuerTradeParty/ram:RoleCode = 'SE' or ram:IssuerTradeParty/ram:RoleCode = 'SR' or ram:IssuerTradeParty/ram:RoleCode = 'PE' or ram:IssuerTradeParty/ram:RoleCode = 'PR' or ram:IssuerTradeParty/ram:RoleCode = 'II' or ram:IssuerTradeParty/ram:RoleCode = 'IV'">
               <xsl:attribute name="id">BR-FR-CDV-CL-03_MDT-40_23</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-03/MDT-40] : Lorsque le statut (MDT-77) est "23", le rôle du partenaire commercial émetteur (MDT-40) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "PE", "PR", "II", "IV".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:IssuerTradeParty/ram:RoleCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-04BR-FR-CDV-CL-04 — Liste fermée de valeurs pour MDT-59-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-04 — Liste fermée de valeurs pour MDT-59</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:ExchangedDocument/ram:RecipientTradeParty/ram:RoleCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'BY' or . = 'AB' or . = 'DL' or . = 'SE' or . = 'SR' or          . = 'PE' or . = 'PR' or . = 'II' or . = 'IV' or . = 'WK' or . = 'DFH'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'BY' or . = 'AB' or . = 'DL' or . = 'SE' or . = 'SR' or . = 'PE' or . = 'PR' or . = 'II' or . = 'IV' or . = 'WK' or . = 'DFH'">
               <xsl:attribute name="id">BR-FR-CDV-CL-04_MDT-59</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-04/MDT-59] : Le rôle du partenaire commercial destinataire (MDT-59) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "PE", "PR", "II", "IV", "WK", "DFH".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-05BR-FR-CDV-CL-05 — Contrôle des statuts MDT-88 selon MDT-77-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-05 — Contrôle des statuts MDT-88 selon MDT-77</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../ram:TypeCode != '305' or          ram:StatusCode = '10' or          ram:StatusCode = '51' or          ram:StatusCode = '43' or          ram:StatusCode = '8' or          ram:StatusCode = '48' or         not(ram:StatusCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="../ram:TypeCode != '305' or ram:StatusCode = '10' or ram:StatusCode = '51' or ram:StatusCode = '43' or ram:StatusCode = '8' or ram:StatusCode = '48' or not(ram:StatusCode)">
               <xsl:attribute name="id">BR-FR-CDV-CL-05_MDT-88_305</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-05/MDT-88] : Lorsque MDT-77 = "305" (Phase Transmission), siprésent, MDT-88 doit être l’un des codes suivants :
        "10", "51", "43", "8", "48".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:StatusCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../ram:TypeCode != '23' or          ram:StatusCode = '45' or          ram:StatusCode = '39' or          ram:StatusCode = '37' or          ram:StatusCode = '50' or          ram:StatusCode = '49' or          ram:StatusCode = '47' or          ram:StatusCode = '46' or          ram:StatusCode = '1'or         ram:StatusCode = '5'or         not(ram:StatusCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="../ram:TypeCode != '23' or ram:StatusCode = '45' or ram:StatusCode = '39' or ram:StatusCode = '37' or ram:StatusCode = '50' or ram:StatusCode = '49' or ram:StatusCode = '47' or ram:StatusCode = '46' or ram:StatusCode = '1'or ram:StatusCode = '5'or not(ram:StatusCode)">
               <xsl:attribute name="id">BR-FR-CDV-CL-05_MDT-88_23</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-05/MDT-88] : Lorsque MDT-77 = "23" (Phase Traitement), si présent, MDT-88 doit être l’un des codes suivants :
        "45", "39", "37", "50", "49", "47", "46", "1", "5" (pour les autres statuts)
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:StatusCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-06BR-FR-CDV-CL-06 — Liste fermée de codes statuts de facture-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-06 — Liste fermée de codes statuts de facture</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode"
                 priority="1001"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:ProcessConditionCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-invoice-status-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-invoice-status-code(.)">
               <xsl:attribute name="id">BR-FR-CDV-CL-06_MDT-105</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-06/MDT-105] : Le code de statut de facture (MDT-105) doit être dans la liste des codes autorisés :
        "200", "201", ..., "228".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:ProcessConditionCode"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:ProcessConditionCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-invoice-status-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-invoice-status-code(.)">
               <xsl:attribute name="id">BR-FR-CDV-CL-06_MDT-115</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-06/MDT-115] : Le code de statut de facture (MDT-115) doit être dans la liste des codes autorisés :
        "200", "201", ..., "228".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-07BR-FR-CDV-CL-07 — Vérification de la valeur de MDT-132-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-07 — Vérification de la valeur de MDT-132</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerTradeParty/ram:RoleCode"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:IssuerTradeParty/ram:RoleCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'SE'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". = 'SE'">
               <xsl:attribute name="id">BR-FR-CDV-CL-07_MDT-132</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-07/MDT-132] : Le rôle du partenaire commercial émetteur (MDT-132) doit être "SE" (Vendeur).
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-08BR-FR-CDV-CL-08 — Liste fermée de valeurs pour MDT-158-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-08 — Liste fermée de valeurs pour MDT-158</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:RecipientTradeParty/ram:RoleCode"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:RecipientTradeParty/ram:RoleCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'BY' or . = 'AB' or . = 'DL' or . = 'SE' or . = 'SR' or          . = 'WK' or . = 'DFH' or . = 'PE' or . = 'PR' or          . = 'II' or . = 'IV'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'BY' or . = 'AB' or . = 'DL' or . = 'SE' or . = 'SR' or . = 'WK' or . = 'DFH' or . = 'PE' or . = 'PR' or . = 'II' or . = 'IV'">
               <xsl:attribute name="id">BR-FR-CDV-CL-08_MDT-158</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-08/MDT-158] : Le rôle du partenaire commercial destinataire (MDT-158) doit être dans la liste suivante :
        "BY", "AB", "DL", "SE", "SR", "WK", "DFH", "PE", "PR", "II", "IV".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-09BR-FR-CDV-CL-09 — Liste fermée de codes motifs de statuts-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-09 — Liste fermée de codes motifs de statuts</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:ReasonCode"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:ReasonCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-status-reason-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-status-reason-code(.)">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>" n'est pas dans la liste des codes autorisés :
        "RETRAIT_MAN_SERV", "ST_CT_NON_DECLAR", "SUPPR_COMP_AVOIR", "TRANSF_PMNT_REGIE", "CONTACT_ACHTR", 
        "NON_TRANSMISE", "JUSTIF_ABS", "ROUTAGE_ERR", "AUTRE", "COORD_BANC_ERR", "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_INC", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT", "CMD_ERR", "ADR_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR", "PU_ERR", "REM_ERR", "QTE_ERR", "ART_ERR", "MODPAI_ERR", "QUALITE_ERR", "LIVR_INCOMP", "REJ_SEMAN", "REJ_UNI", "REJ_COH", "REJ_ADR", "REJ_CONT_B2G", "REJ_REF_PJ", "REJ_ASS_PJ", "IRR_VIDE_F", "IRR_TYPE_F", "IRR_SYNTAX", "IRR_TAILLE_PJ", "IRR_NOM_PJ", "IRR_VID_PJ", "IRR_EXT_DOC", "IRR_TAILLE_F", "IRR_ANTIVIRUS", "IRR_NOM_F".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '200' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '200' )) or (../../ram:ProcessConditionCode = '200' and ../ram:ProcessConditionCode != '200' )         or (.) = 'NON_TRANSMISE'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '200' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '200' )) or (../../ram:ProcessConditionCode = '200' and ../ram:ProcessConditionCode != '200' ) or (.) = 'NON_TRANSMISE'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_200</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_200] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut DÉPOSÉE (200) :
        "NON_TRANSMISE". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '213' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '213' )) or (../../ram:ProcessConditionCode = '213' and ../ram:ProcessConditionCode != '213' )         or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'DOUBLON' or (.) = 'DEST_INC' or (.) = 'ADR_ERR'         or (.) = 'REJ_SEMAN' or (.) = 'REJ_UNI' or (.) = 'REJ_COH' or (.) = 'REJ_ADR' or (.) = 'REJ_CONT_B2G' or (.) = 'REJ_REF_PJ' or (.) = 'REJ_ASS_PJ'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '213' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '213' )) or (../../ram:ProcessConditionCode = '213' and ../ram:ProcessConditionCode != '213' ) or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'DOUBLON' or (.) = 'DEST_INC' or (.) = 'ADR_ERR' or (.) = 'REJ_SEMAN' or (.) = 'REJ_UNI' or (.) = 'REJ_COH' or (.) = 'REJ_ADR' or (.) = 'REJ_CONT_B2G' or (.) = 'REJ_REF_PJ' or (.) = 'REJ_ASS_PJ'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_213</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_213] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut REJETÉE (213) :
        "MONTANTTOTAL_ERR", "CALCUL_ERR", "DOUBLON", "DEST_INC", "ADR_ERR", "REJ_SEMAN", "REJ_UNI", "REJ_COH", "REJ_ADR", "REJ_CONT_B2G", "REJ_REF_PJ", "REJ_ASS_PJ".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '210' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '210' )) or (../../ram:ProcessConditionCode = '210' and ../ram:ProcessConditionCode != '210' )         or (/rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID[@schemeID = '0238'] = '9999')          or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON' or (.) = 'DEST_ERR'         or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR' or (.) = 'ADR_ERR' or (.) = 'REF_CT_ABSENT'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '210' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '210' )) or (../../ram:ProcessConditionCode = '210' and ../ram:ProcessConditionCode != '210' ) or (/rsm:CrossDomainAcknowledgementAndResponse/rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID[@schemeID = '0238'] = '9999') or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON' or (.) = 'DEST_ERR' or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR' or (.) = 'ADR_ERR' or (.) = 'REF_CT_ABSENT'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_210</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_210] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut REFUSÉE (210) :
        "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT", "CMD_ERR", "ADR_ERR", "REF_CT_ABSENT".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '210' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '210' )) or (../../ram:ProcessConditionCode = '210' and ../ram:ProcessConditionCode != '210' )         or not(exists(//rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID)) or //rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID[@schemeID = '0238'] != '9999'         or (//rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID[@schemeID = '0238'] = '9999'         and ((.) = 'RETRAIT_MAN_SERV' or (.) = 'ST_CT_NON_DECLAR' or (.) = 'SUPPR_COMP_AVOIR' or (.) = 'TRANSF_PMNT_REGIE' or (.) = 'AUTRE' or (.) = 'COORD_BANC_ERR'         or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON' or (.) = 'DEST_ERR'         or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR' or (.) = 'ADR_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'LIVR_INCOMP'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '210' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '210' )) or (../../ram:ProcessConditionCode = '210' and ../ram:ProcessConditionCode != '210' ) or not(exists(//rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID)) or //rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID[@schemeID = '0238'] != '9999' or (//rsm:ExchangedDocument/ram:SenderTradeParty/ram:GlobalID[@schemeID = '0238'] = '9999' and ((.) = 'RETRAIT_MAN_SERV' or (.) = 'ST_CT_NON_DECLAR' or (.) = 'SUPPR_COMP_AVOIR' or (.) = 'TRANSF_PMNT_REGIE' or (.) = 'AUTRE' or (.) = 'COORD_BANC_ERR' or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON' or (.) = 'DEST_ERR' or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR' or (.) = 'ADR_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'LIVR_INCOMP'))">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_210B2G</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_210B2G] : SEULEMENT B2G : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut REFUSÉE B2G (210) :
        "RETRAIT_MAN_SERV", "ST_CT_NON_DECLAR", "SUPPR_COMP_AVOIR", "TRANSF_PMNT_REGIE", "CONTACT_ACHTR", "AUTRE", "COORD_BANC_ERR", "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT", "CMD_ERR", "ADR_ERR", "REF_CT_ABSENT", "LIVR_INCOMP".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '207' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '207' )) or (../../ram:ProcessConditionCode = '207' and ../ram:ProcessConditionCode != '207' )         or (.) = 'AUTRE' or (.) = 'COORD_BANC_ERR' or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON'         or (.) = 'DEST_INC' or (.) = 'DEST_ERR' or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR'         or (.) = 'ADR_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR' or (.) = 'PU_ERR' or (.) = 'REM_ERR'         or (.) = 'QTE_ERR' or (.) = 'ART_ERR' or (.) = 'MODPAI_ERR' or (.) = 'QUALITE_ERR' or (.) = 'LIVR_INCOMP'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '207' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '207' )) or (../../ram:ProcessConditionCode = '207' and ../ram:ProcessConditionCode != '207' ) or (.) = 'AUTRE' or (.) = 'COORD_BANC_ERR' or (.) = 'TX_TVA_ERR' or (.) = 'MONTANTTOTAL_ERR' or (.) = 'CALCUL_ERR' or (.) = 'NON_CONFORME' or (.) = 'DOUBLON' or (.) = 'DEST_INC' or (.) = 'DEST_ERR' or (.) = 'TRANSAC_INC' or (.) = 'EMMET_INC' or (.) = 'CONTRAT_TERM' or (.) = 'DOUBLE_FACT' or (.) = 'CMD_ERR' or (.) = 'ADR_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR' or (.) = 'PU_ERR' or (.) = 'REM_ERR' or (.) = 'QTE_ERR' or (.) = 'ART_ERR' or (.) = 'MODPAI_ERR' or (.) = 'QUALITE_ERR' or (.) = 'LIVR_INCOMP'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_207</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_207] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut LITIGE (207) :
       "AUTRE", "COORD_BANC_ERR", "TX_TVA_ERR", "MONTANTTOTAL_ERR", "CALCUL_ERR", "NON_CONFORME", "DOUBLON", "DEST_INC", "DEST_ERR", "TRANSAC_INC", "EMMET_INC", "CONTRAT_TERM", "DOUBLE_FACT",
        "CMD_ERR", "ADR_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR", "PU_ERR", "REM_ERR", "QTE_ERR", "ART_ERR", "MODPAI_ERR", "QUALITE_ERR", "LIVR_INCOMP".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '206' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '206' )) or (../../ram:ProcessConditionCode = '206' and ../ram:ProcessConditionCode != '206' )         or (.) = 'AUTRE' or (.) = 'CMD_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR' or (.) = 'PU_ERR' or (.) = 'REM_ERR'         or (.) = 'QTE_ERR' or (.) = 'ART_ERR' or (.) = 'MODPAI_ERR' or (.) = 'QUALITE_ERR' or (.) = 'LIVR_INCOMP'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '206' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '206' )) or (../../ram:ProcessConditionCode = '206' and ../ram:ProcessConditionCode != '206' ) or (.) = 'AUTRE' or (.) = 'CMD_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR' or (.) = 'PU_ERR' or (.) = 'REM_ERR' or (.) = 'QTE_ERR' or (.) = 'ART_ERR' or (.) = 'MODPAI_ERR' or (.) = 'QUALITE_ERR' or (.) = 'LIVR_INCOMP'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_206</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_206] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut APPROUVÉE PARTIELLEMENT (206) :
        "AUTRE", "CMD_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR", "PU_ERR", "REM_ERR", "QTE_ERR", "ART_ERR", "MODPAI_ERR", "QUALITE_ERR", "LIVR_INCOMP".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '208' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '208' )) or (../../ram:ProcessConditionCode = '208' and ../ram:ProcessConditionCode != '208' )         or (.) = 'JUSTIF_ABS' or (.) = 'COORD_BANC_ERR' or (.) = 'CMD_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '208' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '208' )) or (../../ram:ProcessConditionCode = '208' and ../ram:ProcessConditionCode != '208' ) or (.) = 'JUSTIF_ABS' or (.) = 'COORD_BANC_ERR' or (.) = 'CMD_ERR' or (.) = 'SIRET_ERR' or (.) = 'CODE_ROUTAGE_ERR' or (.) = 'REF_CT_ABSENT' or (.) = 'REF_ERR'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_208</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_208] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut SUSPENDUE (208) :
        "JUSTIF_ABS", "COORD_BANC_ERR", "CMD_ERR", "SIRET_ERR", "CODE_ROUTAGE_ERR", "REF_CT_ABSENT", "REF_ERR".
        Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '221' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '221' )) or (../../ram:ProcessConditionCode = '221' and ../ram:ProcessConditionCode != '221' )         or (.) = 'ROUTAGE_ERR'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '221' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '221' )) or (../../ram:ProcessConditionCode = '221' and ../ram:ProcessConditionCode != '221' ) or (.) = 'ROUTAGE_ERR'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_221</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_221] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut ERREUR_ROUTAGE (221) :
        "ROUTAGE_ERR". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(../../ram:ProcessConditionCode != '501' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '501' )) or (../../ram:ProcessConditionCode = '501' and ../ram:ProcessConditionCode != '501' )         or (.) = 'IRR_VIDE_F'  or (.) = 'IRR_TYPE_F'  or (.) = 'IRR_SYNTAX'  or (.) = 'IRR_TAILLE_PJ'  or (.) = 'IRR_NOM_PJ'  or (.) = 'IRR_VID_PJ'  or (.) = 'IRR_EXT_DOC'  or (.) = 'IRR_TAILLE_F'  or (.) = 'IRR_ANTIVIRUS' or (.) = 'IRR_NOM_F'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(../../ram:ProcessConditionCode != '501' and (not(../ram:ProcessConditionCode) or ../ram:ProcessConditionCode != '501' )) or (../../ram:ProcessConditionCode = '501' and ../ram:ProcessConditionCode != '501' ) or (.) = 'IRR_VIDE_F' or (.) = 'IRR_TYPE_F' or (.) = 'IRR_SYNTAX' or (.) = 'IRR_TAILLE_PJ' or (.) = 'IRR_NOM_PJ' or (.) = 'IRR_VID_PJ' or (.) = 'IRR_EXT_DOC' or (.) = 'IRR_TAILLE_F' or (.) = 'IRR_ANTIVIRUS' or (.) = 'IRR_NOM_F'">
               <xsl:attribute name="id">BR-FR-CDV-CL-09_MDT-113_501</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-09/MDT-113_501] : Le code motif de statut (MDT-113) : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>", n'est pas dans la liste des codes autorisés pour le statut IRRECEVABLE (501) :
        "IRR_VIDE_F", "IRR_TYPE_F", "IRR_SYNTAX", "IRR_TAILLE_PJ", "IRR_NOM_PJ", "IRR_VID_PJ", "IRR_EXT_DOC, "IRR_TAILLE_F", "IRR_ANTIVIRUS, IRR_NOM_F". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-10BR-FR-CDV-CL-10 — Liste fermée de codes actions de facture-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-10 — Liste fermée de codes actions de facture</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:RequestedActionCode"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:RequestedActionCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-invoice-action-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-invoice-action-code(.)">
               <xsl:attribute name="id">BR-FR-CDV-CL-10_MDT-121</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-10/MDT-121] : Le code d'action de facture (MDT-121) doit être dans la liste des codes autorisés :
        "NOA", "PIN", "NIN", "CNF", "CNP", "CNA", "OTH".
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". Veuillez corriger cette valeur si nécessaire.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>
   <!--PATTERN BR-FR-CDV-CL-11BR-FR-CDV-CL-11 — Liste fermée de codes pour MDT-207-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CDV-CL-11 — Liste fermée de codes pour MDT-207</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic/ram:TypeCode"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:AcknowledgementDocument/ram:ReferenceReferencedDocument/ram:SpecifiedDocumentStatus/ram:SpecifiedDocumentCharacteristic/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'MEN' or . = 'MPA' or . = 'RAP' or . = 'ESC' or . = 'RAB' or . = 'REM' or . = 'MAP' or . = 'MAPTTC' or . = 'MNA' or . = 'MNATTC' or . = 'CBB' or . = 'DIV' or . = 'DVA' or . = 'MAJ'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'MEN' or . = 'MPA' or . = 'RAP' or . = 'ESC' or . = 'RAB' or . = 'REM' or . = 'MAP' or . = 'MAPTTC' or . = 'MNA' or . = 'MNATTC' or . = 'CBB' or . = 'DIV' or . = 'DVA' or . = 'MAJ'">
               <xsl:attribute name="id">BR-FR-CDV-CL-11_MDT-207</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        [BR-FR-CDV-CL-11/MDT-207] : La valeur du TypeCode (MDT-207) doit appartenir à la liste fermée des codes autorisés :
        MEN, MPA, RAP, ESC, RAB, REM, MAP, MAPTTC, MNA, MNATTC, CBB, DIV, DVA, MAJ.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". Veuillez corriger cette valeur si elle ne correspond pas à un code valide.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>
</xsl:stylesheet>
