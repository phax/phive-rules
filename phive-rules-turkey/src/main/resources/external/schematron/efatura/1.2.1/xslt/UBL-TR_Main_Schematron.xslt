<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:apr="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:desp="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:ef="http://www.efatura.gov.tr/package-namespace" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:hr="http://www.hr-xml.org/3" xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:oa="http://www.openapplications.org/oagis/9" xmlns:recp="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:xades="http://uri.etsi.org/01903/v1.3.2#" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
        <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])" />
        <xsl:if test="$p_1>1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1" />]</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>']</xsl:text>
        <xsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])" />
        <xsl:if test="$p_2>1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2" />]</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
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
      <svrl:ns-prefix-in-attribute-values prefix="sh" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" />
      <svrl:ns-prefix-in-attribute-values prefix="ef" uri="http://www.efatura.gov.tr/package-namespace" />
      <svrl:ns-prefix-in-attribute-values prefix="inv" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="apr" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" />
      <svrl:ns-prefix-in-attribute-values prefix="desp" uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="recp" uri="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ds" uri="http://www.w3.org/2000/09/xmldsig#" />
      <svrl:ns-prefix-in-attribute-values prefix="xades" uri="http://uri.etsi.org/01903/v1.3.2#" />
      <svrl:ns-prefix-in-attribute-values prefix="hr" uri="http://www.hr-xml.org/3" />
      <svrl:ns-prefix-in-attribute-values prefix="oa" uri="http://www.openapplications.org/oagis/9" />
      <svrl:ns-prefix-in-attribute-values prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">codes</xsl:attribute>
        <xsl:attribute name="name">codes</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">abstracts</xsl:attribute>
        <xsl:attribute name="name">abstracts</xsl:attribute>
        <svrl:text>Pattern for storing abstract rules</svrl:text>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">document</xsl:attribute>
        <xsl:attribute name="name">document</xsl:attribute>
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
        <xsl:attribute name="id">header</xsl:attribute>
        <xsl:attribute name="name">header</xsl:attribute>
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
        <xsl:attribute name="id">package</xsl:attribute>
        <xsl:attribute name="name">package</xsl:attribute>
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
        <xsl:attribute name="id">invoice</xsl:attribute>
        <xsl:attribute name="name">invoice</xsl:attribute>
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
        <xsl:attribute name="id">applicationresponse</xsl:attribute>
        <xsl:attribute name="name">applicationresponse</xsl:attribute>
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
        <xsl:attribute name="id">processuseraccount</xsl:attribute>
        <xsl:attribute name="name">processuseraccount</xsl:attribute>
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
        <xsl:attribute name="id">canceluseraccount</xsl:attribute>
        <xsl:attribute name="name">canceluseraccount</xsl:attribute>
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
        <xsl:attribute name="id">despatchadvice</xsl:attribute>
        <xsl:attribute name="name">despatchadvice</xsl:attribute>
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
        <xsl:attribute name="id">receiptadvice</xsl:attribute>
        <xsl:attribute name="name">receiptadvice</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN codes-->
<xsl:variable name="ProfileIDType" select="',TICARIFATURA,TEMELFATURA,YOLCUBERABERFATURA,IHRACAT,OZELFATURA,KAMU,HKS,ENERJI,ILAC_TIBBICIHAZ,YATIRIMTESVIK,IDIS,'" />
  <xsl:variable name="ProfileIDTypeEarchive" select="',EARSIVFATURA,'" />
  <xsl:variable name="ProfileIDTypeDespatchAdvice" select="',TEMELIRSALIYE,HKSIRSALIYE,IDISIRSALIYE,'" />
  <xsl:variable name="ProfileIDTypeGoruntuleme" select="',TICARIFATURA,TEMELFATURA,YOLCUBERABERFATURA,IHRACAT,EARSIVFATURA,OZELFATURA,KAMU,HKS,ENERJI,ILAC_TIBBICIHAZ,YATIRIMTESVIK,IDIS,'" />
  <xsl:variable name="InvoiceTypeCodeList" select="',SATIS,IADE,TEVKIFAT,TEVKIFATIADE,ISTISNA,OZELMATRAH,IHRACKAYITLI,SGK,KOMISYONCU,HKSSATIS,HKSKOMISYONCU,KONAKLAMAVERGISI,SARJ,SARJANLIK,TEKNOLOJIDESTEK,YTBSATIS,YTBIADE,YTBISTISNA,YTBTEVKIFAT,YTBTEVKIFATIADE,'" />
  <xsl:variable name="DespatchAdviceTypeCodeList" select="',SEVK,MATBUDAN,'" />
  <xsl:variable name="ReceiptAdviceTypeCodeList" select="',SEVK,'" />
  <xsl:variable name="EnvelopeType" select="',SENDERENVELOPE,POSTBOXENVELOPE,SYSTEMENVELOPE,USERENVELOPE,'" />
  <xsl:variable name="ElementType" select="',INVOICE,APPLICATIONRESPONSE,PROCESSUSERACCOUNT,CANCELUSERACCOUNT,DESPATCHADVICE,RECEIPTADVICE,CREDITNOTE,'" />
  <xsl:variable name="TaxType" select="',0003,0015,0061,0071,0073,0074,0075,0076,0077,1047,1048,4080,4081,9015,9021,9077,8001,8002,8004,8005,8006,8007,8008,9040,0011,4071,4171,0021,0022,9944,0059,'" />
  <xsl:variable name="WithholdingTaxType" select="',601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,'" />
  <xsl:variable name="WithholdingTaxTypeWithPercent" select="',60130,60140,60290,60350,60370,60450,60550,60690,60790,60890,60950,60970,61090,61190,61270,61290,61370,61390,61450,61550,61570,61650,61770,61870,61970,62070,62190,62290,62350,62420,62530,62620,65090,65050,65070,65020,65030,62740,62750,801100,802100,803100,804100,805100,806100,807100,808100,809100,810100,811100,812100,813100,814100,815100,816100,817100,818100,819100,820100,821100,822100,823100,824100,825100,'" />
  <xsl:variable name="AccountingCostCodeList" select="',SAGLIK_ECZ,SAGLIK_HAS,SAGLIK_OPT,SAGLIK_MED,ABONELIK,MAL_HIZMET,DIGER,'" />
  <xsl:variable name="TaxExemptionReasonCodeType" select="',001,101,102,103,104,105,106,107,108,151,201,202,204,205,206,207,208,209,211,212,213,214,215,216,217,218,219,220,221,223,225,226,227,228,229,230,231,232,234,235,236,237,238,239,240,241,242,250,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,350,351,501,555,801,802,803,804,805,806,807,808,809,810,811,812,701,702,703,704,'" />
  <xsl:variable name="istisnaTaxExemptionReasonCodeType" select="',001,101,102,103,104,105,106,107,108,201,202,204,205,206,207,208,209,211,212,213,214,215,216,217,218,219,220,221,223,225,226,227,228,229,230,231,232,234,235,236,237,238,239,240,241,242,250,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,350,501,'" />
  <xsl:variable name="ozelMatrahTaxExemptionReasonCodeType" select="',801,802,803,804,805,806,807,808,809,810,811,812,'" />
  <xsl:variable name="ihracExemptionReasonCodeType" select="',701,702,703,704,'" />
  <xsl:variable name="DeliveryTermCodeList" select="',CFR,CIF,CIP,CPT,DAF,DDP,DDU,DEQ,DES,EXW,FAS,FCA,FOB,DAP,DPU,'" />
  <xsl:variable name="TransportModeCodeList" select="',0,1,2,3,4,5,6,7,8,9,'" />
  <xsl:variable name="PartyIdentificationIDType" select="',TCKN,VKN,HIZMETNO,MUSTERINO,TESISATNO,TELEFONNO,DISTRIBUTORNO,TICARETSICILNO,TAPDKNO,BAYINO,ABONENO,SAYACNO,EPDKNO,SUBENO,PASAPORTNO,ARACIKURUMETIKET,ARACIKURUMVKN,CIFTCINO,IMALATCINO,DOSYANO,HASTANO,MERSISNO,URETICINO,GTB_REFNO,GTB_GCB_TESCILNO,GTB_FIILI_IHRACAT_TARIHI,ARACKIMLIKNO,PLAKA,SEVKIYATNO,'" />
  <xsl:variable name="LicensePlateIDSchemeIDType" select="',DORSE,PLAKA,'" />
  <xsl:variable name="DocumentDescriptionType" select="',AVANS,YEMEK_FIS,E-FATURA,E-FATURA_IRSALIYE,E-ARSIV,E-ARSIV_IRSALIYE,FATURA,OTOPARK,FATURA_TAHSILAT,FATURA_TAHSILAT_KOMISYONLU,'" />
  <xsl:variable name="ResponseCodeType" select="',KABUL,RED,IADE,S_APR,GUMRUKONAY,'" />
  <xsl:variable name="AppResponseCodeType" select="',1000,1100,1110,1111,1120,1130,1131,1132,1133,1140,1141,1142,1143,1150,1160,1161,1162,1163,1170,1171,1172,1175,1176,1177,1180,1181,1182,1183,1190,1191,1195,1200,'" />
  <xsl:variable name="ContactTypeIdentifierType" select="',UNVAN,VKN_TCKN,'" />
  <xsl:variable name="PackageTypeCodeList" select="',1A,1B,1D,1F,1G,1W,2C,3A,3H,43,44,4A,4B,4C,4D,4F,4G,4H,5H,5L,5M,6H,6P,7A,7B,8A,8B,8C,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AL,AM,AP,AT,AV,B4,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ,CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,DA,DB,DC,DG,DH,DI,DJ,DK,DL,DM,DN,DP,DR,DS,DT,DU,DV,DW,DX,DY,EC,ED,EE,EF,EG,EH,EI,EN,FB,FC,FD,FE,FI,FL,FO,FP,FR,FT,FW,FX,GB,GI,GL,GR,GU,GY,GZ,HA,HB,HC,HG,HN,HR,IA,IB,IC,ID,IE,IF,IG,IH,IK,IL,IN,IZ,JB,JC,JG,JR,JT,JY,KG,KI,LE,LG,LT,LU,LV,LZ,MA,MB,MC,ME,MR,MS,MT,MW,MX,NA,NE,NF,NG,NS,NT,NU,NV,OA,OB,OC,OD,OE,OF,OK,OT,OU,P2,PA,PB,PC,PD,PE,PF,PG,PH,PI,PJ,PK,PL,PN,PO,PP,PR,PT,PU,PV,PX,PY,PZ,QA,QB,QC,QD,QF,QG,QH,QJ,QK,QL,QM,QN,QP,QQ,QR,QS,RD,RG,RJ,RK,RL,RO,RT,RZ,SA,SB,SC,SD,SE,SH,SI,SK,SL,SM,SO,SP,SS,ST,SU,SV,SW,SX,SY,SZ,T1,TB,TC,TD,TE,TG,TI,TK,TL,TN,TO,TR,TS,TT,TU,TV,TW,TY,TZ,UC,UN,VA,VG,VI,VK,VL,VO,VP,VQ,VN,VR,VS,VY,WA,WB,WC,WD,WF,WG,WH,WJ,WK,WL,WM,WN,WP,WQ,WR,WS,WT,WU,WV,WW,WX,WY,WZ,XA,XB,XC,XD,XF,XG,XH,XJ,XK,YA,YB,YC,YD,YF,YG,YH,YJ,YK,YL,YM,YN,YP,YQ,YR,YS,YT,YV,YW,YX,YY,YZ,ZA,ZB,ZC,ZD,ZF,ZG,ZH,ZJ,ZK,ZL,ZM,ZN,ZP,ZQ,ZR,ZS,ZT,ZU,ZV,ZW,ZX,ZY,ZZ,'" />
  <xsl:variable name="CurrencyCodeList" select="',AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT,BGN,BHD,BIF,BMD,BND,BOB,BOV,BRL,BSD,BTN,BWP,BYN,BZD,CAD,CDF,CHE,CHF,CHW,CLF,CLP,CNY,COP,COU,CRC,CUC,CUP,CVE,CZK,DJF,DKK,DOP,DZD,EEK,EGP,ERN,ETB,EUR,FJD,FKP,GBP,GEL,GHS,GIP,GMD,GNF,GTQ,GWP,GYD,HKD,HNL,HRK,HTG,HUF,IDR,ILS,INR,IQD,IRR,ISK,JMD,JOD,JPY,KES,KGS,KHR,KMF,KPW,KRW,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,LTL,LVL,LYD,MAD,MDL,MGA,MKD,MMK,MNT,MOP,MRU,MUR,MVR,MWK,MXN,MXV,MYR,MZN,NAD,NGN,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PKR,PLN,PYG,QAR,RON,RSD,RUB,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SLE,SLL,SOS,SRD,SSP,STD,STN,SVC,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,USD,USN,USS,UYI,UYU,UYW,UZS,VEF,VND,VUV,WST,XAD,XAF,XAG,XAU,XBA,XBB,XBC,XBD,XCD,XCG,XDR,XFU,XOF,XPD,XPF,XPT,XSU,XTS,XUA,XXX,VED,VES,YER,ZAR,ZMK,ZMW,ZWG,ZWL,'" />
  <xsl:variable name="CountryCodeList" select="',AF,AX,AL,DZ,AS,AD,AO,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BA,BW,BV,BR,IO,BN,BG,BF,BI,KH,CM,CA,CV,KY,CF,TD,CL,CW,CN,CX,CC,CO,KM,CG,CD,CK,CR,CI,HR,CU,CY,CZ,DK,DJ,DM,DO,EC,EG,SV,GQ,ER,EE,ET,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,GG,GN,GW,GY,HT,HM,VA,HN,HK,HU,IS,IN,ID,IR,IQ,IE,IM,IL,IT,JM,JP,JE,JO,KZ,KE,KI,KP,KR,KW,KG,LA,LV,LB,LS,LR,LY,LI,LT,LU,MO,MK,MG,MW,MY,MV,ML,MT,MH,MQ,MR,MU,YT,MX,FM,MD,MC,MN,ME,MS,MA,MZ,MM,NA,NR,NP,NL,AN,NC,NZ,NI,NE,NG,NU,NF,MP,NO,OM,PK,PW,PS,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,RE,RO,RU,RW,BL,SH,KN,LC,MF,PM,VC,WS,SM,ST,SA,SN,RS,SC,SL,SG,SK,SI,SB,SO,ZA,GS,ES,LK,SD,SR,SJ,SZ,SE,CH,SY,TW,TJ,TZ,TH,TL,TG,TK,TO,TT,TN,TR,TM,TC,TV,UG,UA,AE,GB,US,UM,UY,UZ,VU,VE,VN,VG,VI,WF,EH,YE,ZM,ZW,CTR,XK,BQ,SX,ZZ,XZ,SS,'" />
  <xsl:variable name="UserType" select="',1,2,11,12,21,22,31,32,41,42,'" />
  <xsl:variable name="ReservedAliases" select="',usergb,GIB,archive,earchive,archive_earchive,eticket,edespatch,esevoucher,epreceipt,esevoucher_archive,epreceipt_archive,erevenue,echeck,eexchangecert,ebreceipt,einsurancecomm,'" />
  <xsl:variable name="UserEnvelopeAliases" select="',usergb,archive,earchive,archive_earchive,eticket,edespatch,archive_edespatch,esevoucher,epreceipt,esevoucher_archive,epreceipt_archive,erevenue,echeck,eexchangecert,ebreceipt,einsurancecomm,'" />
  <xsl:variable name="UnitCodeList" select="',05,06,08,10,11,13,14,15,16,17,18,19,1A,1B,1C,1D,1E,1F,1G,1H,1I,1J,1K,1L,1M,1X,20,21,22,23,24,25,26,27,28,29,2A,2B,2C,2G,2H,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2V,2W,2X,2Y,2Z,30,31,32,33,34,35,36,37,38,3B,3C,3E,3G,3H,3I,40,41,43,44,45,46,47,48,4A,4B,4C,4E,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,53,54,56,57,58,59,5A,5B,5C,5E,5F,5G,5H,5I,5J,5K,5P,5Q,60,61,62,63,64,66,69,71,72,73,74,76,77,78,80,81,84,85,87,89,90,91,92,93,94,95,96,97,98,A1,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,A6,A60,A61,A62,A63,A64,A65,A66,A67,A68,A69,A7,A70,A71,A73,A74,A75,A76,A77,A78,A79,A8,A80,A81,A82,A83,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,A99,AA,AB,ACR,ACT,AD,AE,AH,AI,AJ,AK,AL,AM,AMH,AMP,AMVT,ANN,AP,AO,APZ,AQ,AR,ARE,AS,ASM,ASU,ATM,ATT,AV,AW,AWG,AY,AYR,AZ,B0,B1,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B2,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B4,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,B5,B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B6,B60,B61,B62,B63,B64,B65,B66,B67,B68,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B80,B81,B82,B83,B84,B85,B86,B87,B88,B89,B9,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BAS,BB,BD,BE,BFT,BG,BH,BHP,BIL,BJ,BK,BL,BLD,BLL,BO,BP,BPM,BQL,BR,BT,BTU,BUA,BUI,BW,BX,BZ,C0,C1,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C2,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C37,C38,C39,C4,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C5,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C6,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C74,C75,C76,C77,C78,C79,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C98,C99,CA,CCT,CDL,CEL,CEN,CG,CGM,CH,CJ,CK,CKG,CL,CLF,CLT,CMK,CMQ,CMT,CNP,CNT,CO,COU,CPR,CQ,CR,CS,CT,CTG,CTM,CTN,CU,CUR,CV,CWA,CWI,CY,CZ,D03,D04,D1,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31,D32,D33,D34,D35,D36,D37,D38,D39,D40,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D64,D65,D66,D67,D68,D69,D7,D70,D71,D72,D73,D74,D75,D76,D77,D78,D79,D8,D80,D81,D82,D83,D85,D86,D87,D88,D89,D9,D90,D91,D92,D93,D94,D95,D96,D97,D98,D99,DAA,DAD,DAY,DB,DBM,DBW,DC,DD,DE,DEC,DG,DI,DJ,DLT,DMA,DMK,DMO,DMQ,DMT,DN,DPC,DPR,DPT,DQ,DR,DRA,DRI,DRL,DRM,DS,DT,DTN,DU,DWT,DX,DY,DZN,DZP,E01,E07,E08,E09,E10,E11,E12,E14,E15,E16,E17,E18,E19,E2,E20,E21,E22,E23,E25,E27,E28,E3,E30,E31,E32,E33,E34,E35,E36,E37,E38,E39,E4,E40,E41,E42,E43,E44,E45,E46,E47,E48,E49,E5,E50,E51,E52,E53,E54,E55,E56,E57,E58,E59,E60,E61,E62,E63,E64,E65,E66,E67,E68,E69,E70,E71,E72,E73,E74,E75,E76,E77,E78,E79,E80,E81,E82,E83,E84,E85,E86,E87,E88,E89,E90,E91,E92,E93,E94,E95,E96,E97,E98,E99,EA,EB,EC,EP,EQ,EV,F01,F02,F03,F04,F05,F06,F07,F08,F1,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56,F57,F58,F59,F60,F61,F62,F63,F64,F65,F66,F67,F68,F69,F70,F71,F72,F73,F74,F75,F76,F77,F78,F79,F80,F81,F82,F83,F84,F85,F86,F87,F88,F89,F9,F90,F91,F92,F93,F94,F95,F96,F97,F98,F99,FAH,FAR,FB,FBM,FC,FD,FE,FF,FG,FH,FIT,FL,FM,FNU,FOT,FP,FR,FS,FTK,FTQ,G01,G04,G05,G06,G08,G09,G10,G11,G12,G13,G14,G15,G16,G17,G18,G19,G2,G20,G21,G23,G24,G25,G26,G27,G28,G29,G3,G30,G31,G32,G33,G34,G35,G36,G37,G38,G39,G40,G41,G42,G43,G44,G45,G46,G47,G48,G49,G50,G51,G52,G53,G54,G55,G56,G57,G58,G59,G60,G61,G62,G63,G64,G65,G66,G67,G68,G69,G7,G70,G71,G72,G73,G74,G75,G76,G77,G78,G79,G80,G81,G82,G83,G84,G85,G86,G87,G88,G89,G90,G91,G92,G93,G94,G95,G96,G97,G98,G99,GB,GBQ,GC,GD,GDW,GE,GF,GFI,GGR,GH,GIA,GIC,GII,GIP,GJ,GK,GL,GLD,GLI,GLL,GM,GMS,GN,GO,GP,GQ,GRM,GRN,GRO,GRT,GT,GV,GW,GWH,GY,GZ,H03,H04,H05,H06,H07,H08,H09,H1,H10,H11,H12,H13,H14,H15,H16,H18,H19,H2,H20,H21,H22,H23,H24,H25,H26,H27,H28,H29,H30,H31,H32,H33,H34,H35,H36,H37,H38,H39,H40,H41,H42,H43,H44,H45,H46,H47,H48,H49,H50,H51,H52,H53,H54,H55,H56,H57,H58,H59,H60,H61,H62,H63,H64,H65,H66,H67,H68,H69,H70,H71,H72,H73,H74,H75,H76,H77,H78,H79,H80,H81,H82,H83,H84,H85,H87,H88,H89,H90,H91,H92,H93,H94,H95,H96,H98,H99,HA,HAD,HAGR,HAR,HBA,HBX,HC,HD,HDW,HE,HEA,HF,HGM,HH,HI,HIU,HJ,HK,HKM,HL,HLT,HM,HMO,HMQ,HMT,HN,HO,HP,HPA,HS,HT,HTZ,HUR,HWE,HY,IA,IC,IE,IF,II,IL,IM,INH,INK,INQ,IP,ISD,IT,IU,IUG,IV,J10,J12,J13,J14,J15,J16,J17,J18,J19,J2,J20,J21,J22,J23,J24,J25,J26,J27,J28,J29,J30,J31,J32,J33,J34,J35,J36,J38,J39,J40,J41,J42,J43,J44,J45,J46,J47,J48,J49,J50,J51,J52,J53,J54,J55,J56,J57,J58,J59,J60,J61,J62,J63,J64,J65,J66,J67,J68,J69,J70,J71,J72,J73,J74,J75,J76,J78,J79,J81,J82,J83,J84,J85,J87,J89,J90,J91,J92,J93,J94,J95,J96,J97,J98,J99,JB,JE,JG,JK,JM,JNT,JO,JOU,JPS,JR,JWL,K1,K10,K11,K12,K13,K14,K15,K16,K17,K18,K19,K2,K20,K21,K22,K23,K24,K25,K26,K27,K28,K3,K30,K31,K32,K33,K34,K35,K36,K37,K38,K39,K40,K41,K42,K43,K45,K46,K47,K48,K49,K5,K50,K51,K52,K53,K54,K55,K58,K59,K6,K60,K61,K62,K63,K64,K65,K66,K67,K68,K69,K70,K71,K73,K74,K75,K76,K77,K78,K79,K80,K81,K82,K83,K84,K85,K86,K87,K88,K89,K90,K91,K92,K93,K94,K95,K96,K97,K98,K99,KA,KAT,KB,KBA,KCC,KD,KDW,KEL,KF,KFO,KG,KGM,KGS,KH6,KHO,KHY,KHZ,KI,KIC,KIP,KJ,KJO,KL,KLK,KLX,KMA,KMH,KMK,KMQ,KMT,KNI,KNM,KNS,KNT,KO,KOH,KPA,KPH,KPO,KPP,KPR,KR,KS,KSD,KSH,KT,KTM,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWN,KWO,KWS,KWT,KWY,KX,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L2,L20,L21,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54,L55,L56,L57,L58,L59,L60,L61,L62,L63,L64,L65,L66,L67,L68,L69,L70,L71,L72,L73,L74,L75,L76,L77,L78,L79,L80,L81,L82,L83,L84,L85,L86,L87,L88,L89,L90,L91,L92,L93,L94,L95,L96,L98,L99,LA,LAC,LBR,LBT,LC,LD,LE,LEF,LF,LH,LI,LJ,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUB,LUM,LUX,LX,LY,M0,M1,M10,M11,M12,M13,M14,M15,M16,M17,M18,M19,M20,M21,M22,M23,M24,M25,M26,M27,M29,M30,M31,M32,M33,M34,M35,M36,M37,M38,M39,M4,M40,M41,M42,M43,M44,M45,M46,M47,M48,M49,M5,M50,M51,M52,M53,M55,M56,M57,M58,M59,M60,M61,M62,M63,M64,M65,M66,M67,M68,M69,M7,M70,M71,M72,M73,M74,M75,M76,M77,M78,M79,M80,M81,M82,M83,M84,M85,M86,M87,M88,M89,M9,M90,M91,M92,M93,M94,M95,M96,M97,M98,M99,MA,MAH,MAL,MAM,MAR,MAW,MBE,MBF,MBR,MC,MCU,MD,MF,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MK,MKD,MKM,MKW,MLD,MLT,MMK,MMQ,MMT,MND,MNJ,MON,MPA,MQ,MQD,MQH,MQM,MQS,MQW,MRD,MRM,MRW,MSK,MT,MTK,MTQ,MTR,MTS,MTZ,MV,MVA,MWH,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N3,N30,N31,N32,N33,N34,N35,N36,N37,N38,N39,N40,N41,N42,N43,N44,N45,N46,N47,N48,N49,N50,N51,N52,N53,N54,N55,N56,N57,N58,N59,N60,N61,N62,N63,N64,N65,N66,N67,N68,N69,N70,N71,N72,N73,N74,N75,N76,N77,N78,N79,N80,N81,N82,N83,N84,N85,N86,N87,N88,N89,N90,N91,N92,N93,N94,N95,N96,N97,N98,N99,NA,NAR,NB,NBB,NC,NCL,NCR,ND,NE,NEW,NF,NG,NH,NI,NIL,NIU,NJ,NL,NM3,NMI,NMP,NN,NPL,NPR,NPT,NQ,NR,NRL,NT,NTT,NTU,NU,NV,NX,NY,OA,ODE,ODG,ODK,ODM,OHM,OMV,ON,ONZ,OP,OPM,OT,OTB,OZ,OZA,OZI,P0,P1,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P2,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P3,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P4,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P5,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P6,P60,P61,P62,P63,P64,P65,P66,P67,P68,P69,P7,P70,P71,P72,P73,P74,P75,P76,P77,P78,P79,P8,P80,P81,P82,P83,P84,P85,P86,P87,P88,P89,P9,P90,P91,P92,P93,P94,P95,P96,P97,P98,P99,PA,PAL,PB,PD,PE,PF,PFL,PG,PGL,PI,PK,PL,PLA,PM,PN,PO,PQ,PR,PS,PT,PTD,PTI,PTL,PTN,PU,PV,PW,PY,PZ,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29,Q3,Q30,Q31,Q32,Q33,Q34,Q35,Q36,Q37,Q38,Q39,Q40,Q41,Q42,QA,QAN,QB,QD,QH,QK,QR,QT,QTD,QTI,QTL,QTR,R1,R4,R9,RA,RD,RG,RH,RK,RL,RM,RN,RO,ROM,RP,RPM,RPS,RS,RT,RU,S3,S4,S5,S6,S7,S8,SA,SAN,SCO,SCR,SD,SE,SEC,SET,SG,SHT,SIE,SK,SL,SM3,SMI,SN,SO,SP,SQ,SQR,SR,SS,SST,ST,STC,STI,STK,STL,STN,STW,SV,SW,SX,SYR,T0,T1,T3,T4,T5,T6,T7,T8,TA,TAH,TAN,TC,TD,TE,TF,TI,TIC,TIP,TJ,TK,TKM,TL,TMS,TN,TNE,TP,TPI,TPR,TQ,TQD,TR,TRL,TS,TSD,TSH,TST,TT,TTS,TU,TV,TW,TWH,TY,U1,U2,UA,UB,UC,UD,UE,UF,UH,UM,VA,VI,VLT,VP,VQ,VS,W2,W4,WA,WB,WCD,WE,WEB,WEE,WG,WH,WHR,WI,WM,WR,WSD,WTT,WW,X1,YDK,YDQ,YL,YRD,YT,Z1,Z11,Z2,Z3,Z4,Z5,Z6,Z8,Z9,ZP,ZZ,'" />
  <xsl:variable name="PaymentMeansCodeTypeList" select="',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,60,61,62,63,64,65,66,67,70,74,75,76,77,78,91,92,93,94,95,96,97,ZZZ,'" />
  <xsl:variable name="ChannelCodeList" select="',AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,CA,EI,EM,EX,FT,FX,GM,IE,IM,MA,PB,PS,SW,TE,TG,TL,TM,TT,TX,XF,XG,XH,XI,XJ,'" />
  <xsl:variable name="MimeCodeList" select="',application/CSTAdata+xml,application/EDI-Consent,application/EDI-X12,application/EDIFACT,application/activemessage,application/andrew-inset,application/applefile,application/atomicmail,application/batch-SMTP,application/beep+xml,application/cals-1840,application/cnrp+xml,application/commonground,application/cpl+xml,application/csta+xml,application/cybercash,application/dca-rft,application/dec-dx,application/dialog-info+xml,application/dicom,application/dns,application/dvcs,application/epp+xml,application/eshop,application/fits,application/font-tdpfr,application/http,application/hyperstudio,application/iges,application/im-iscomposing+xml,application/index,application/index.cmd,application/index.obj,application/index.response,application/index.vnd,application/iotp,application/ipp,application/isup,application/kpml-request+xml,application/kpml-response+xml,application/mac-binhex40,application/macwriteii,application/marc,application/mathematica,application/mbox,application/mikey,application/mpeg4-generic,application/msword,application/news-message-id,application/news-transmission,application/ocsp-request,application/ocsp-response,application/octet-stream,application/oda,application/ogg,application/parityfec,application/pdf,application/pgp-encrypted,application/pgp-keys,application/pgp-signature,application/pidf+xml,application/pkcs10,application/pkcs7-mime,application/pkcs7-signature,application/pkix-cert,application/pkix-crl,application/pkix-pkipath,application/pkixcmp,application/postscript,application/prs.alvestrand.titrax-sheet,application/prs.cww,application/prs.nprend,application/prs.plucker,application/qsig,application/rdf+xml,application/reginfo+xml,application/remote-printing,application/resource-lists+xml,application/riscos,application/rls-services+xml,application/rtf,application/samlassertion+xml,application/samlmetadata+xml,application/sbml+xml,application/sdp,application/set-payment,application/set-payment-initiation,application/set-registration,application/set-registration-initiation,application/sgml,application/sgml-open-catalog,application/shf+xml,application/sieve,application/simple-filter+xml,application/simple-message-summary,application/slate,application/soap+xml,application/spirits-event+xml,application/timestamp-query,application/timestamp-reply,application/tve-trigger,application/vemmi,application/vnd.3M.Post-it-Notes,application/vnd.3gpp.pic-bw-large,application/vnd.3gpp.pic-bw-small,application/vnd.3gpp.pic-bw-var,application/vnd.3gpp.sms,application/vnd.FloGraphIt,application/vnd.Kinar,application/vnd.Mobius.DAF,application/vnd.Mobius.DIS,application/vnd.Mobius.MBK,application/vnd.Mobius.MQY,application/vnd.Mobius.MSL,application/vnd.Mobius.PLC,application/vnd.Mobius.TXF,application/vnd.Quark.QuarkXPress,application/vnd.RenLearn.rlprint,application/vnd.accpac.simply.aso,application/vnd.accpac.simply.imp,application/vnd.acucobol,application/vnd.acucorp,application/vnd.adobe.xfdf,application/vnd.aether.imp,application/vnd.amiga.ami,application/vnd.anser-web-certificate-issue-initiation,application/vnd.anser-web-funds-transfer-initiation,application/vnd.audiograph,application/vnd.blueice.multipass,application/vnd.bmi,application/vnd.businessobjects,application/vnd.canon-cpdl,application/vnd.canon-lips,application/vnd.cinderella,application/vnd.claymore,application/vnd.commerce-battelle,application/vnd.commonspace,application/vnd.contact.cmsg,application/vnd.cosmocaller,application/vnd.criticaltools.wbs+xml,application/vnd.ctc-posml,application/vnd.cups-postscript,application/vnd.cups-raster,application/vnd.cups-raw,application/vnd.curl,application/vnd.cybank,application/vnd.data-vision.rdz,application/vnd.dna,application/vnd.dpgraph,application/vnd.dreamfactory,application/vnd.dxr,application/vnd.ecdis-update,application/vnd.ecowin.chart,application/vnd.ecowin.filerequest,application/vnd.ecowin.fileupdate,application/vnd.ecowin.series,application/vnd.ecowin.seriesrequest,application/vnd.ecowin.seriesupdate,application/vnd.enliven,application/vnd.epson.esf,application/vnd.epson.msf,application/vnd.epson.quickanime,application/vnd.epson.salt,application/vnd.epson.ssf,application/vnd.ericsson.quickcall,application/vnd.eudora.data,application/vnd.fdf,application/vnd.ffsns,application/vnd.fints,application/vnd.framemaker,application/vnd.fsc.weblaunch,application/vnd.fujitsu.oasys,application/vnd.fujitsu.oasys2,application/vnd.fujitsu.oasys3,application/vnd.fujitsu.oasysgp,application/vnd.fujitsu.oasysprs,application/vnd.fujixerox.ddd,application/vnd.fujixerox.docuworks,application/vnd.fujixerox.docuworks.binder,application/vnd.fut-misnet,application/vnd.genomatix.tuxedo,application/vnd.grafeq,application/vnd.groove-account,application/vnd.groove-help,application/vnd.groove-identity-message,application/vnd.groove-injector,application/vnd.groove-tool-message,application/vnd.groove-tool-template,application/vnd.groove-vcard,application/vnd.hbci,application/vnd.hcl-bireports,application/vnd.hhe.lesson-player,application/vnd.hp-HPGL,application/vnd.hp-PCL,application/vnd.hp-PCLXL,application/vnd.hp-hpid,application/vnd.hp-hps,application/vnd.httphone,application/vnd.hzn-3d-crossword,application/vnd.ibm.MiniPay,application/vnd.ibm.afplinedata,application/vnd.ibm.electronic-media,application/vnd.ibm.modcap,application/vnd.ibm.rights-management,application/vnd.ibm.secure-container,application/vnd.informix-visionary,application/vnd.intercon.formnet,application/vnd.intertrust.digibox,application/vnd.intertrust.nncp,application/vnd.intu.qbo,application/vnd.intu.qfx,application/vnd.ipunplugged.rcprofile,application/vnd.irepository.package+xml,application/vnd.is-xpr,application/vnd.japannet-directory-service,application/vnd.japannet-jpnstore-wakeup,application/vnd.japannet-payment-wakeup,application/vnd.japannet-registration,application/vnd.japannet-registration-wakeup,application/vnd.japannet-setstore-wakeup,application/vnd.japannet-verification,application/vnd.japannet-verification-wakeup,application/vnd.jisp,application/vnd.kde.karbon,application/vnd.kde.kchart,application/vnd.kde.kformula,application/vnd.kde.kivio,application/vnd.kde.kontour,application/vnd.kde.kpresenter,application/vnd.kde.kspread,application/vnd.kde.kword,application/vnd.kenameaapp,application/vnd.kidspiration,application/vnd.koan,application/vnd.liberty-request+xml,application/vnd.llamagraphics.life-balance.desktop,application/vnd.llamagraphics.life-balance.exchange+xml,application/vnd.lotus-1-2-3,application/vnd.lotus-approach,application/vnd.lotus-freelance,application/vnd.lotus-notes,application/vnd.lotus-organizer,application/vnd.lotus-screencam,application/vnd.lotus-wordpro,application/vnd.mcd,application/vnd.mediastation.cdkey,application/vnd.meridian-slingshot,application/vnd.mfmp,application/vnd.micrografx.flo,application/vnd.micrografx.igx,application/vnd.mif,application/vnd.minisoft-hp3000-save,application/vnd.mitsubishi.misty-guard.trustweb,application/vnd.mophun.application,application/vnd.mophun.certificate,application/vnd.motorola.flexsuite,application/vnd.motorola.flexsuite.adsi,application/vnd.motorola.flexsuite.fis,application/vnd.motorola.flexsuite.gotap,application/vnd.motorola.flexsuite.kmr,application/vnd.motorola.flexsuite.ttc,application/vnd.motorola.flexsuite.wem,application/vnd.mozilla.xul+xml,application/vnd.ms-artgalry,application/vnd.ms-asf,application/vnd.ms-excel,application/vnd.ms-lrm,application/vnd.ms-powerpoint,application/vnd.ms-project,application/vnd.ms-tnef,application/vnd.ms-works,application/vnd.ms-wpl,application/vnd.mseq,application/vnd.msign,application/vnd.music-niff,application/vnd.musician,application/vnd.nervana,application/vnd.netfpx,application/vnd.noblenet-directory,application/vnd.noblenet-sealer,application/vnd.noblenet-web,application/vnd.nokia.landmark+wbxml,application/vnd.nokia.landmark+xml,application/vnd.nokia.landmarkcollection+xml,application/vnd.nokia.radio-preset,application/vnd.nokia.radio-presets,application/vnd.novadigm.EDM,application/vnd.novadigm.EDX,application/vnd.novadigm.EXT,application/vnd.obn,application/vnd.omads-email+xml,application/vnd.omads-file+xml,application/vnd.omads-folder+xml,application/vnd.osa.netdeploy,application/vnd.palm,application/vnd.paos.xml,application/vnd.pg.format,application/vnd.pg.osasli,application/vnd.picsel,application/vnd.powerbuilder6,application/vnd.powerbuilder6-s,application/vnd.powerbuilder7,application/vnd.powerbuilder7-s,application/vnd.powerbuilder75,application/vnd.powerbuilder75-s,application/vnd.previewsystems.box,application/vnd.publishare-delta-tree,application/vnd.pvi.ptid1,application/vnd.pwg-multiplexed,application/vnd.pwg-xhtml-print+xml,application/vnd.rapid,application/vnd.s3sms,application/vnd.sealed.doc,application/vnd.sealed.eml,application/vnd.sealed.mht,application/vnd.sealed.net,application/vnd.sealed.ppt,application/vnd.sealed.xls,application/vnd.sealedmedia.softseal.html,application/vnd.sealedmedia.softseal.pdf,application/vnd.seemail,application/vnd.shana.informed.formdata,application/vnd.shana.informed.formtemplate,application/vnd.shana.informed.interchange,application/vnd.shana.informed.package,application/vnd.smaf,application/vnd.sss-cod,application/vnd.sss-dtf,application/vnd.sss-ntf,application/vnd.street-stream,application/vnd.sus-calendar,application/vnd.svd,application/vnd.swiftview-ics,application/vnd.syncml.+xml,application/vnd.syncml.ds.notification,application/vnd.triscape.mxs,application/vnd.trueapp,application/vnd.truedoc,application/vnd.ufdl,application/vnd.uiq.theme,application/vnd.uplanet.alert,application/vnd.uplanet.alert-wbxml,application/vnd.uplanet.bearer-choice,application/vnd.uplanet.bearer-choice-wbxml,application/vnd.uplanet.cacheop,application/vnd.uplanet.cacheop-wbxml,application/vnd.uplanet.channel,application/vnd.uplanet.channel-wbxml,application/vnd.uplanet.list,application/vnd.uplanet.list-wbxml,application/vnd.uplanet.listcmd,application/vnd.uplanet.listcmd-wbxml,application/vnd.uplanet.signal,application/vnd.vcx,application/vnd.vectorworks,application/vnd.vidsoft.vidconference,application/vnd.visio,application/vnd.visionary,application/vnd.vividence.scriptfile,application/vnd.vsf,application/vnd.wap.sic,application/vnd.wap.slc,application/vnd.wap.wbxml,application/vnd.wap.wmlc,application/vnd.wap.wmlscriptc,application/vnd.webturbo,application/vnd.wordperfect,application/vnd.wqd,application/vnd.wrq-hp3000-labelled,application/vnd.wt.stf,application/vnd.wv.csp+wbxml,application/vnd.wv.csp+xml,application/vnd.wv.ssp+xml,application/vnd.xara,application/vnd.xfdl,application/vnd.yamaha.hv-dic,application/vnd.yamaha.hv-script,application/vnd.yamaha.hv-voice,application/vnd.yamaha.smaf-audio,application/vnd.yamaha.smaf-phrase,application/vnd.yellowriver-custom-menu,application/watcherinfo+xml,application/whoispp-query,application/whoispp-response,application/wita,application/wordperfect5.1,application/x400-bp,application/xhtml+xml,application/xml,application/xml-dtd,application/xml-external-parsed-entity,application/xmpp+xml,application/xop+xml,application/zip,audio/32kadpcm,audio/3gpp,audio/AMR,audio/AMR-WB,audio/BV16,audio/BV32,audio/CN,audio/DAT12,audio/DVI4,audio/EVRC,audio/EVRC-QCP,audio/EVRC0,audio/G.722.1,audio/G722,audio/G723,audio/G726-16,audio/G726-24,audio/G726-32,audio/G726-40,audio/G728,audio/G729,audio/G729D,audio/G729E,audio/GSM,audio/GSM-EFR,audio/L16,audio/L20,audio/L24,audio/L8,audio/LPC,audio/MP4A-LATM,audio/MPA,audio/PCMA,audio/PCMU,audio/QCELP,audio/RED,audio/SMV,audio/SMV-QCP,audio/SMV0,audio/VDVI,audio/basic,audio/clearmode,audio/dsr-es201108,audio/dsr-es202050,audio/dsr-es202211,audio/dsr-es202212,audio/iLBC,audio/mpa-robust,audio/mpeg,audio/mpeg4-generic,audio/parityfec,audio/prs.sid,audio/telephone-event,audio/tone,audio/vnd.3gpp.iufp,audio/vnd.audiokoz,audio/vnd.cisco.nse,audio/vnd.cns.anp1,audio/vnd.cns.inf1,audio/vnd.digital-winds,audio/vnd.everad.plj,audio/vnd.lucent.voice,audio/vnd.nokia.mobile-xmf,audio/vnd.nortel.vbk,audio/vnd.nuera.ecelp4800,audio/vnd.nuera.ecelp7470,audio/vnd.nuera.ecelp9600,audio/vnd.octel.sbc,audio/vnd.qcelp,audio/vnd.rhetorex.32kadpcm,audio/vnd.sealedmedia.softseal.mpeg,audio/vnd.vmx.cvsd,image/cgm,image/fits,image/g3fax,image/gif,image/ief,image/jp2,image/jpeg,image/jpm,image/jpx,image/naplps,image/png,image/prs.btif,image/prs.pti,image/t38,image/tiff,image/tiff-fx,image/vnd.cns.inf2,image/vnd.djvu,image/vnd.dwg,image/vnd.dxf,image/vnd.fastbidsheet,image/vnd.fpx,image/vnd.fst,image/vnd.fujixerox.edmics-mmr,image/vnd.fujixerox.edmics-rlc,image/vnd.globalgraphics.pgb,image/vnd.microsoft.icon,image/vnd.mix,image/vnd.ms-modi,image/vnd.net-fpx,image/vnd.sealed.png,image/vnd.sealedmedia.softseal.gif,image/vnd.sealedmedia.softseal.jpg,image/vnd.svf,image/vnd.wap.wbmp,image/vnd.xiff,message/CPIM,message/delivery-status,message/disposition-notification,message/external-body,message/http,message/news,message/partial,message/rfc822,message/s-http,message/sip,message/sipfrag,message/tracking-status,model/iges,model/mesh,model/vnd.dwf,model/vnd.flatland.3dml,model/vnd.gdl,model/vnd.gs-gdl,model/vnd.gtw,model/vnd.mts,model/vnd.parasolid.transmit.binary,model/vnd.parasolid.transmit.text,model/vnd.vtu,model/vrml,multipart/alternative,multipart/appledouble,multipart/byteranges,multipart/digest,multipart/encrypted,multipart/form-data,multipart/header-set,multipart/mixed,multipart/parallel,multipart/related,multipart/report,multipart/signed,multipart/voice-message,text/RED,text/calendar,text/css,text/csv,text/directory,text/dns,text/enriched,text/html,text/parityfec,text/plain,text/prs.fallenstein.rst,text/prs.lines.tag,text/rfc822-headers,text/richtext,text/rtf,text/sgml,text/t140,text/tab-separated-values,text/troff,text/uri-list,text/vnd.DMClientScript,text/vnd.IPTC.NITF,text/vnd.IPTC.NewsML,text/vnd.abc,text/vnd.curl,text/vnd.esmertec.theme-descriptor,text/vnd.fly,text/vnd.fmi.flexstor,text/vnd.in3d.3dml,text/vnd.in3d.spot,text/vnd.latex-z,text/vnd.motorola.reflex,text/vnd.ms-mediapackage,text/vnd.net2phone.commcenter.command,text/vnd.sun.j2me.app-descriptor,text/vnd.wap.si,text/vnd.wap.sl,text/vnd.wap.wml,text/vnd.wap.wmlscript,text/xml,text/xml-external-parsed-entity,video/3gpp,video/BMPEG,video/BT656,video/CelB,video/DV,video/H261,video/H263,video/H263-1998,video/H263-2000,video/H264,video/JPEG,video/MJ2,video/MP1S,video/MP2P,video/MP2T,video/MP4V-ES,video/MPV,video/SMPTE292M,video/mpeg,video/mpeg4-generic,video/nv,video/parityfec,video/pointer,video/quicktime,video/raw,video/vnd.fvt,video/vnd.motorola.video,video/vnd.motorola.videop,video/vnd.mpegurl,video/vnd.nokia.interleaved-multimedia,video/vnd.objectvideo,video/vnd.sealed.mpeg1,video/vnd.sealed.mpeg4,video/vnd.sealed.swf,video/vnd.sealedmedia.softseal.mov,video/vnd.vivo,application/vnd.openxmlformats-officedocument.wordprocessingml.document,'" />
  <xsl:variable name="AdditionalItemIdentificationIDType" select="',KUNYENO,ILAC,TIBBICIHAZ,TELEFON,TABLET_PC,DIGER,'" />
  <xsl:variable name="IhracKayitliPartyIdentificationIDType" select="',SATICIDIBSATIRKOD,ALICIDIBSATIRKOD,'" />
  <xsl:variable name="YatirimTesvikEArsivInvoiceTypeCodeList" select="',YTBSATIS,YTBIADE,YTBISTISNA,YTBTEVKIFAT,YTBTEVKIFATIADE,'" />
  <xsl:variable name="YatirimTesvikItemClassificationCodeList" select="',01,02,03,04,'" />
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN abstracts-->
<xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:param name="type" select="efatura" />
  <xsl:param name="envelopeType" select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:Type" />
  <xsl:param name="senderId" select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact" />
  <xsl:param name="senderAlias" select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier" />
  <xsl:param name="receiverId" select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact" />
  <xsl:param name="receiverAlias" select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier" />
  <xsl:param name="responseCode" select="//apr:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode" />

<!--PATTERN document-->


	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocument" mode="M23" priority="1000">
    <svrl:fired-rule context="sh:StandardBusinessDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sh:StandardBusinessDocumentHeader" />
      <xsl:otherwise>
        <svrl:failed-assert test="sh:StandardBusinessDocumentHeader">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:StandardBusinessDocumentHeader zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ef:Package" />
      <xsl:otherwise>
        <svrl:failed-assert test="ef:Package">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ef:Package zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains(@xsi:schemaLocation,'PackageProxy_1_2.xsd')" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains(@xsi:schemaLocation,'PackageProxy_1_2.xsd')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:StandardBusinessDocument alanın  xsi:schemaLocation niteliği 'PackageProxy_1_2.xsd' olmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(name()= 'Invoice') or string-length(normalize-space(string(namespace::xsi))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(name()= 'Invoice') or string-length(normalize-space(string(namespace::xsi))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Invoice elemanı geçerli ve boş değer içermeyen xmlns:xsi niteliği içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN header-->


	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader" mode="M24" priority="1008">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sh:HeaderVersion = '1.0' or sh:HeaderVersion = '1.2'" />
      <xsl:otherwise>
        <svrl:failed-assert test="sh:HeaderVersion = '1.0' or sh:HeaderVersion = '1.2'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz sh:HeaderVersion elemanı değeri. sh:HeaderVersion elemanı 1.0 veya 1.2 değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(sh:Sender) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(sh:Sender) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:Sender zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(sh:Receiver) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(sh:Receiver) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:Receiver zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier" mode="M24" priority="1007">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(.))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(.))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. Boş olmayan bir değer içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier" mode="M24" priority="1006">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(.))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(.))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. Boş olmayan bir değer içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Sender" mode="M24" priority="1005">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:Sender" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(sh:ContactInformation) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(sh:ContactInformation) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>En az bir sh:ContactInformation elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:ContactTypeIdentifier elemanı değeri 'VKN_TCKN' ye eşit olan bir tane sh:ContactInformation elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Receiver" mode="M24" priority="1004">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:Receiver" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(sh:ContactInformation) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(sh:ContactInformation) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>En az bir sh:ContactInformation elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:ContactTypeIdentifier elemanı değeri 'VKN_TCKN' ye eşit olan bir tane sh:ContactInformation elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation" mode="M24" priority="1003">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sh:ContactTypeIdentifier" />
      <xsl:otherwise>
        <svrl:failed-assert test="sh:ContactTypeIdentifier">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:ContactTypeIdentifier zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:ContactTypeIdentifier) or contains($ContactTypeIdentifierType, concat(',',sh:ContactTypeIdentifier,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:ContactTypeIdentifier) or contains($ContactTypeIdentifierType, concat(',',sh:ContactTypeIdentifier,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz sh:ContactTypeIdentifier değeri : '<xsl:text />
            <xsl:value-of select="sh:ContactTypeIdentifier" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:ContactTypeIdentifier) or not(sh:ContactTypeIdentifier = 'VKN_TCKN') or string-length(sh:Contact) = 11 or string-length(sh:Contact) = 10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:ContactTypeIdentifier) or not(sh:ContactTypeIdentifier = 'VKN_TCKN') or string-length(sh:Contact) = 11 or string-length(sh:Contact) = 10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:ContactTypeIdentifier elemanın değeri 'VKN_TCKN' olması durumunda sh:Contact elemanına 10 haneli vergi kimlik numarası ve ya 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation" mode="M24" priority="1002">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sh:ContactTypeIdentifier" />
      <xsl:otherwise>
        <svrl:failed-assert test="sh:ContactTypeIdentifier">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:ContactTypeIdentifier zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:ContactTypeIdentifier) or contains($ContactTypeIdentifierType, concat(',',sh:ContactTypeIdentifier,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:ContactTypeIdentifier) or contains($ContactTypeIdentifierType, concat(',',sh:ContactTypeIdentifier,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz sh:ContactTypeIdentifier değeri : '<xsl:text />
            <xsl:value-of select="sh:ContactTypeIdentifier" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:ContactTypeIdentifier) or not(sh:ContactTypeIdentifier = 'VKN_TCKN') or string-length(sh:Contact) = 11 or string-length(sh:Contact) = 10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:ContactTypeIdentifier) or not(sh:ContactTypeIdentifier = 'VKN_TCKN') or string-length(sh:Contact) = 11 or string-length(sh:Contact) = 10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:ContactTypeIdentifier elemanın değeri 'VKN_TCKN' olması durumunda sh:Contact elemanına 10 haneli vergi kimlik numarası ve ya 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification" mode="M24" priority="1001">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sh:TypeVersion = '1.2'" />
      <xsl:otherwise>
        <svrl:failed-assert test="sh:TypeVersion = '1.2'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz sh:TypeVersion elemanı değeri. '1.2' değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($EnvelopeType, concat(',',sh:Type,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($EnvelopeType, concat(',',sh:Type,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz zarf türü : '<xsl:text />
            <xsl:value-of select="sh:Type" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:Type = 'SENDERENVELOPE') or not(//ElementType != 'INVOICE') or  not(//ElementType != 'DESPATCHADVICE') or  not(//ElementType != 'CREDITNOTE')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:Type = 'SENDERENVELOPE') or not(//ElementType != 'INVOICE') or not(//ElementType != 'DESPATCHADVICE') or not(//ElementType != 'CREDITNOTE')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>SENDERENVELOPE türündeki zarf Invoice,DespatchAdvice veya CreditNote şemasına göre oluşturulmuş belge taşımalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:Type = 'POSTBOXENVELOPE') or not(//ElementType != 'APPLICATIONRESPONSE') or not(//ElementType != 'RECEIPTADVICE')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:Type = 'POSTBOXENVELOPE') or not(//ElementType != 'APPLICATIONRESPONSE') or not(//ElementType != 'RECEIPTADVICE')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>POSTBOXENVELOPE türündeki zarf, ApplicationResponse veya ReceiptAdvice  şemasına göre oluşturulmuş belge taşımalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:Type = 'SYSTEMENVELOPE') or not(//ElementType != 'APPLICATIONRESPONSE')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:Type = 'SYSTEMENVELOPE') or not(//ElementType != 'APPLICATIONRESPONSE')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>SYSTEMENVELOPE türündeki zarf ApplicationResponse şemasına göre oluşturulmuş belge taşımalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:Type = 'USERENVELOPE') or (//ElementType = 'PROCESSUSERACCOUNT' or //ElementType = 'CANCELUSERACCOUNT')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:Type = 'USERENVELOPE') or (//ElementType = 'PROCESSUSERACCOUNT' or //ElementType = 'CANCELUSERACCOUNT')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>USERENVELOPE türündeki zarf ProcessUserAccount ve ya CancelUserAccount şemasına göre oluşturulmuş belge taşımalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:Type = 'USERENVELOPE') or ($receiverId = '3900383669' and $receiverAlias = 'GIB')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:Type = 'USERENVELOPE') or ($receiverId = '3900383669' and $receiverAlias = 'GIB')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>USERENVELOPE türündeki zarfı yalnızca 3900383669 vergi kimlik numaralı ve GIB etiketli kullanıcıya gönderebilirsiniz.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sh:Type = 'USERENVELOPE') or contains($UserEnvelopeAliases, concat(',',normalize-space($senderAlias),','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sh:Type = 'USERENVELOPE') or contains($UserEnvelopeAliases, concat(',',normalize-space($senderAlias),','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>USERENVELOPE türündeki zarfı UserEnvelopeAliases listesindeki etiketlerden birisiyle gönderebilirsiniz.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier" mode="M24" priority="1000">
    <svrl:fired-rule context="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı UUID formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:IdentificationCode" mode="M0" priority="1015">
    <svrl:fired-rule context="//cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CountryCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CountryCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri:<xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:SourceCurrencyCode" mode="M0" priority="1014">
    <svrl:fired-rule context="//cbc:SourceCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri:<xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:TargetCurrencyCode" mode="M0" priority="1013">
    <svrl:fired-rule context="//cbc:TargetCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri:<xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:CurrencyCode" mode="M0" priority="1012">
    <svrl:fired-rule context="//cbc:CurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri:<xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//@currencyID" mode="M0" priority="1011">
    <svrl:fired-rule context="//@currencyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz currencyID niteliği : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//@unitCode" mode="M0" priority="1010">
    <svrl:fired-rule context="//@unitCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//cbc:UBLVersionID = '2.1') or contains($UnitCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//cbc:UBLVersionID = '2.1') or contains($UnitCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz unitCode niteliği : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:ChannelCode" mode="M0" priority="1009">
    <svrl:fired-rule context="//cbc:ChannelCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//cbc:UBLVersionID = '2.1') or contains($ChannelCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//cbc:UBLVersionID = '2.1') or contains($ChannelCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri:<xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:IssueDate" mode="M0" priority="1008">
    <svrl:fired-rule context="//cbc:IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:date(.) le xs:date(current-date())" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:date(.) le xs:date(current-date())">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:IssueDate değeri : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' cbc:IssueDate alanı günün tarihinden ileri bir tarih olamaz</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:date('2005-01-01+04:00')  le xs:date(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:date('2005-01-01+04:00') le xs:date(.)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:IssueDate değeri : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' cbc:IssueDate alanı 01.01.2005 tarihinden önce bir tarih olamaz</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//@mimeCode" mode="M0" priority="1007">
    <svrl:fired-rule context="//@mimeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($MimeCodeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($MimeCodeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz mimeCode niteliği : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN package-->


	<!--RULE -->
<xsl:template match="ef:Package" mode="M34" priority="1002">
    <svrl:fired-rule context="ef:Package" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(Elements) &lt; 11" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(Elements) &lt; 11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ef:Package elemanı içerisinde en fazla 10 tane Elements elemanı olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ef:Package/Elements" mode="M34" priority="1001">
    <svrl:fired-rule context="ef:Package/Elements" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($ElementType, concat(',',ElementType,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($ElementType, concat(',',ElementType,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz  ElementType değeri : '<xsl:text />
            <xsl:value-of select="ElementType" />
            <xsl:text />'. Geçerli ElementType değerleri için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ElementCount &lt; 1001" />
      <xsl:otherwise>
        <svrl:failed-assert test="ElementCount &lt; 1001">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementCount elemanın değeri en fazla 1000 olabilir..</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ElementList/*) = ElementCount " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ElementList/*) = ElementCount">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı içersinde bulunan eleman sayısı ElementCount elemanı değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ElementType='INVOICE') or count(ElementList/inv:Invoice)=ElementCount" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ElementType='INVOICE') or count(ElementList/inv:Invoice)=ElementCount">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı içerisinde bulunan inv:Invoice elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ElementType='APPLICATIONRESPONSE') or count(ElementList/apr:ApplicationResponse)=ElementCount" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ElementType='APPLICATIONRESPONSE') or count(ElementList/apr:ApplicationResponse)=ElementCount">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı içerisinde bulunan apr:ApplicationResponse elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ElementType='PROCESSUSERACCOUNT') or count(ElementList/hr:ProcessUserAccount)=ElementCount" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ElementType='PROCESSUSERACCOUNT') or count(ElementList/hr:ProcessUserAccount)=ElementCount">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı içerisinde bulunan hr:ProcessUserAccount elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ElementType='CANCELUSERACCOUNT') or count(ElementList/hr:CancelUserAccount)=ElementCount" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ElementType='CANCELUSERACCOUNT') or count(ElementList/hr:CancelUserAccount)=ElementCount">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı içerisinde bulunan hr:CancelUserAccount elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ElementType='INVOICE') or count(ElementList/inv:Invoice) &lt; 101 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ElementType='INVOICE') or count(ElementList/inv:Invoice) &lt; 101">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı içerisinde bulunan inv:Invoice elemanı sayısı 100'den fazla olamaz.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ef:Package/Elements/ElementList" mode="M34" priority="1000">
    <svrl:fired-rule context="ef:Package/Elements/ElementList" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../ElementType='INVOICE') or not(count(inv:Invoice[cbc:ProfileID='IHRACAT']) > 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../ElementType='INVOICE') or not(count(inv:Invoice[cbc:ProfileID='IHRACAT']) > 1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı cbc:ProfileID değeri 'IHRACAT' olan sadece 1 tane inv:Invoice elamanı içerebilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../ElementType='INVOICE') or not(count(inv:Invoice[cbc:ProfileID='YOLCUBERABERFATURA']) > 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../ElementType='INVOICE') or not(count(inv:Invoice[cbc:ProfileID='YOLCUBERABERFATURA']) > 1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElementList elemanı cbc:ProfileID değeri 'YOLCUBERABERFATURA' olan sadece 1 tane inv:Invoice elamanı içerebilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN invoice-->


	<!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature" mode="M35" priority="1033">
    <svrl:fired-rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:SignedInfo/ds:Reference/ds:Transforms">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:KeyInfo" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:KeyInfo">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:Object" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:Object">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Object elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningTime elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningCertificate elemanı zorunlu bir elemandır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ds:SignedInfo/ds:Reference[@URI = '']) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ds:SignedInfo/ds:Reference[@URI = '']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo elamanı içerisinde URI niteliği boşluğa("") eşit olan sadece bir tane ds:Reference elemanı bulunmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../../../cbc:UBLVersionID = '2.1') or ds:SignedInfo/ds:SignatureMethod/@Algorithm !='http://www.w3.org/2000/09/xmldsig#rsa-sha1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../../../cbc:UBLVersionID = '2.1') or ds:SignedInfo/ds:SignatureMethod/@Algorithm !='http://www.w3.org/2000/09/xmldsig#rsa-sha1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignatureMethod alanının Algorithm niteliği "http://www.w3.org/2000/09/xmldsig#rsa-sha1" olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data" mode="M35" priority="1032">
    <svrl:fired-rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:X509Certificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:X509Certificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" mode="M35" priority="1031">
    <svrl:fired-rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice" mode="M35" priority="1030">
    <svrl:fired-rule context="inv:Invoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:UBLVersionID = '2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:UBLVersionID = '2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:UBLVersionID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:UBLVersionID" />
            <xsl:text />'. cbc:UBLVersionID değeri '2.1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:CustomizationID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:CustomizationID" />
            <xsl:text />' cbc:CustomizationID elemanı değeri 'TR1.2' veya 'TR1.2.1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($type = 'efatura' or $type = '' or not($type)) or contains($ProfileIDType, concat(',',cbc:ProfileID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($type = 'efatura' or $type = '' or not($type)) or contains($ProfileIDType, concat(',',cbc:ProfileID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ProfileID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ProfileID" />
            <xsl:text />'. Geçerli cbc:ProfileID değerleri için ProfileIDType listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($type = 'earchive') or contains($ProfileIDTypeEarchive, concat(',',cbc:ProfileID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($type = 'earchive') or contains($ProfileIDTypeEarchive, concat(',',cbc:ProfileID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ProfileID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ProfileID" />
            <xsl:text />'. Geçerli cbc:ProfileID değerleri için ProfileIDTypeEarchive listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($type = 'goruntuleme') or contains($ProfileIDTypeGoruntuleme, concat(',',cbc:ProfileID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($type = 'goruntuleme') or contains($ProfileIDTypeGoruntuleme, concat(',',cbc:ProfileID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ProfileID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ProfileID" />
            <xsl:text />'. Geçerli cbc:ProfileID değerleri için ProfileIDTypeGoruntuleme listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@xsi:schemaLocation) or contains(@xsi:schemaLocation,'UBL-Invoice-2.1.xsd')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@xsi:schemaLocation) or contains(@xsi:schemaLocation,'UBL-Invoice-2.1.xsd')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Invoice alanın  xsi:schemaLocation özeliği 'UBL-Invoice-2.1.xsd' olmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(cbc:ID,'^[A-Z0-9]{3}20[0-9]{2}[0-9]{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(cbc:ID,'^[A-Z0-9]{3}20[0-9]{2}[0-9]{9}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı 'ABC2009123456789' formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CopyIndicator = 'false'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CopyIndicator = 'false'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:CopyIndicator elemanı değeri. cbc:CopyIndicator elemanı 'false' değerine eşit olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($InvoiceTypeCodeList, concat(',',cbc:InvoiceTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($InvoiceTypeCodeList, concat(',',cbc:InvoiceTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:InvoiceTypeCode elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:InvoiceTypeCode" />
            <xsl:text />'. Geçerli cbc:InvoiceTypeCode değerleri için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:InvoiceTypeCode='IADE') or cbc:ProfileID='TEMELFATURA' or cbc:ProfileID='EARSIVFATURA' or cbc:ProfileID='ILAC_TIBBICIHAZ' or cbc:ProfileID='YATIRIMTESVIK' or cbc:ProfileID='IDIS'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:InvoiceTypeCode='IADE') or cbc:ProfileID='TEMELFATURA' or cbc:ProfileID='EARSIVFATURA' or cbc:ProfileID='ILAC_TIBBICIHAZ' or cbc:ProfileID='YATIRIMTESVIK' or cbc:ProfileID='IDIS'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura tipi IADE iken fatura profili sadece TEMELFATURA , EARSIVFATURA, ILAC_TIBBICIHAZ, YATIRIMTESVIK veya IDIS olabilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not($type = 'efatura' or $type = '' or not($type)) or (cbc:ProfileID = 'ENERJI' and (cbc:InvoiceTypeCode = 'SARJ' or cbc:InvoiceTypeCode = 'SARJANLIK'))) or (not($type = 'efatura' or $type = '' or not($type)) or (not(cbc:ProfileID = 'ENERJI') and not(cbc:InvoiceTypeCode = 'SARJ' or cbc:InvoiceTypeCode = 'SARJANLIK')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not($type = 'efatura' or $type = '' or not($type)) or (cbc:ProfileID = 'ENERJI' and (cbc:InvoiceTypeCode = 'SARJ' or cbc:InvoiceTypeCode = 'SARJANLIK'))) or (not($type = 'efatura' or $type = '' or not($type)) or (not(cbc:ProfileID = 'ENERJI') and not(cbc:InvoiceTypeCode = 'SARJ' or cbc:InvoiceTypeCode = 'SARJANLIK')))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ProfileID ve cbc:InvoiceTypeCode elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ProfileID" />
            <xsl:text /> ve <xsl:text />
            <xsl:value-of select="cbc:InvoiceTypeCode" />
            <xsl:text />'. cbc:ProfileID değeri ENERJI olduğu durumda cbc:InvoiceTypeCode değeri SARJ veya SARJANLIK olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ProfileID = 'EARSIVFATURA' or not(cbc:InvoiceTypeCode = 'TEKNOLOJIDESTEK')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ProfileID = 'EARSIVFATURA' or not(cbc:InvoiceTypeCode = 'TEKNOLOJIDESTEK')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ProfileID ve cbc:InvoiceTypeCode elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ProfileID" />
            <xsl:text /> ve <xsl:text />
            <xsl:value-of select="cbc:InvoiceTypeCode" />
            <xsl:text />'. cbc:InvoiceTypeCode değeri <xsl:text />
            <xsl:value-of select="cbc:InvoiceTypeCode" />
            <xsl:text /> olduğu durumda cbc:ProfileID değeri EARSIVFATURA olmalıdır.<xsl:text />
            <xsl:value-of select="string('&#xA;')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($CurrencyCodeList, concat(',',cbc:DocumentCurrencyCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($CurrencyCodeList, concat(',',cbc:DocumentCurrencyCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:DocumentCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:TaxCurrencyCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:TaxCurrencyCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:TaxCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:PricingCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PricingCurrencyCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:PricingCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PricingCurrencyCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:PricingCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:PaymentCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentCurrencyCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:PaymentCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentCurrencyCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:PaymentCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:PaymentAlternativeCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentAlternativeCurrencyCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:PaymentAlternativeCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentAlternativeCurrencyCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:PaymentAlternativeCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentCurrencyCode!='TRY') or cac:PricingExchangeRate/cbc:CalculationRate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentCurrencyCode!='TRY') or cac:PricingExchangeRate/cbc:CalculationRate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Para birimi TRY olmayan belgelerde kur bilgisi zorunludur.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentCurrencyCode!='TRY') or not(cac:PricingExchangeRate/cbc:CalculationRate) or matches(cac:PricingExchangeRate/cbc:CalculationRate,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,6}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentCurrencyCode!='TRY') or not(cac:PricingExchangeRate/cbc:CalculationRate) or matches(cac:PricingExchangeRate/cbc:CalculationRate,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,6}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cac:PricingExchangeRate/cbc:CalculationRate elemanı değeri. cac:PricingExchangeRate/cbc:CalculationRate elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 6 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Signature) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Signature) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>En fazla bir tane cac:Signature elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:WithholdingTaxTotal)) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'YTBTEVKIFAT' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'YTBIADE' or cbc:InvoiceTypeCode = 'SGK' or cbc:InvoiceTypeCode = 'SARJ' or cbc:InvoiceTypeCode = 'SARJANLIK'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:WithholdingTaxTotal)) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'YTBTEVKIFAT' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'YTBIADE' or cbc:InvoiceTypeCode = 'SGK' or cbc:InvoiceTypeCode = 'SARJ' or cbc:InvoiceTypeCode = 'SARJANLIK'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uyumsuz fatura tipi: '<xsl:text />
            <xsl:value-of select="cbc:InvoiceTypeCode" />
            <xsl:text />'. cac:WithholdingTaxTotal elamanı varken fatura tipi TEVKIFAT,YTBTEVKIFAT,IADE,YTBIADE,SGK,SARJ ve SARJANLIK olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '4171'])) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'SGK' or cbc:InvoiceTypeCode = 'YTBIADE'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '4171'])) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'SGK' or cbc:InvoiceTypeCode = 'YTBIADE'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uyumsuz fatura tipi: '<xsl:text />
            <xsl:value-of select="cbc:InvoiceTypeCode" />
            <xsl:text />'. cbc:TaxTypeCode değeri 4171 ise fatura tipi TEVKIFAT,IADE, YTBIADE veya SGK olabilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or contains($DeliveryTermCodeList, concat(',',cac:Delivery/cac:DeliveryTerms/cbc:ID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or contains($DeliveryTermCodeList, concat(',',cac:Delivery/cac:DeliveryTerms/cbc:ID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, schemeID niteliği INCOTERMS olan Geçersiz cac:Delivery/cac:DeliveryTerms/cbc:ID değeri : '<xsl:text />
            <xsl:value-of select="cac:Delivery/cac:DeliveryTerms/cbc:ID" />
            <xsl:text />' Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode)) or contains($PackageTypeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode)) or contains($PackageTypeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz : cbc:PackagingTypeCode değeri : '<xsl:text />
            <xsl:value-of select="cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode" />
            <xsl:text />' Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode)) or contains($TransportModeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode)) or contains($TransportModeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:TransportModeCode : '<xsl:text />
            <xsl:value-of select="cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode" />
            <xsl:text />' Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='YOLCUBERABERFATURA') or count(cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='ARACIKURUMVKN' and (string-length(normalize-space(string(text()))) = 10 or string-length(normalize-space(string(text()))) = 11) ]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='YOLCUBERABERFATURA') or count(cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='ARACIKURUMVKN' and (string-length(normalize-space(string(text()))) = 10 or string-length(normalize-space(string(text()))) = 11) ]) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri YOLCUBERABERFATURA iken, cac:TaxRepresentativeParty/cac:PartyIdentification elemanı schemeID niteliği değeri 'ARACIKURUMVKN' olan ve değeri geçerli bir vkn/tckn olan bir tane cbc:ID elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='YOLCUBERABERFATURA') or count(cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='ARACIKURUMETIKET' and string-length(normalize-space(string(text()))) > 0 ])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='YOLCUBERABERFATURA') or count(cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='ARACIKURUMETIKET' and string-length(normalize-space(string(text()))) > 0 ])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri YOLCUBERABERFATURA iken, cac:TaxRepresentativeParty/cac:PartyIdentification elemanı schemeID niteliği değeri 'ARACIKURUMETIKET' olan ve değeri boş olmayan bir tane cbc:ID elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='HKS') or (count(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='KUNYENO' and string-length(normalize-space(string(text()))) = 19 ]) = count(cac:InvoiceLine))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='HKS') or (count(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='KUNYENO' and string-length(normalize-space(string(text()))) = 19 ]) = count(cac:InvoiceLine))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProfileID='HKS' iken, her cac:InvoiceLine elemanı 19 karakterli 'KUNYENO' içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:InvoiceTypeCode = 'TEVKIFATIADE' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'YTBIADE' or cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE') or (count(cac:BillingReference/cac:InvoiceDocumentReference) > 0 and count(cac:BillingReference/cac:InvoiceDocumentReference[(cbc:DocumentTypeCode='İADE' or cbc:DocumentTypeCode='IADE') and string-length(normalize-space(cbc:ID)) = 16 ]) = count(cac:BillingReference/cac:InvoiceDocumentReference))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:InvoiceTypeCode = 'TEVKIFATIADE' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'YTBIADE' or cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE') or (count(cac:BillingReference/cac:InvoiceDocumentReference) > 0 and count(cac:BillingReference/cac:InvoiceDocumentReference[(cbc:DocumentTypeCode='İADE' or cbc:DocumentTypeCode='IADE') and string-length(normalize-space(cbc:ID)) = 16 ]) = count(cac:BillingReference/cac:InvoiceDocumentReference))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IADE, TEVKIFATIADE ve YTBIADE fatura tiplerinde iade bilgilerini içeren cbc:DocumentTypeCode değeri IADE ve 16 haneli ID değeri olan iade fatura sayısı kadar cac:BillingReference/cac:InvoiceDocumentReference elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='ILAC_TIBBICIHAZ') or (cbc:InvoiceTypeCode = 'SATIS' or cbc:InvoiceTypeCode = 'ISTISNA' or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'TEVKIFATIADE' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'IHRACKAYITLI')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='ILAC_TIBBICIHAZ') or (cbc:InvoiceTypeCode = 'SATIS' or cbc:InvoiceTypeCode = 'ISTISNA' or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'TEVKIFATIADE' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'IHRACKAYITLI')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ILAC_TIBBICIHAZ Fatura senaryosunda fatura tipi “SATIS”, “ISTISNA” “TEVKIFAT”, “TEVKIFATIADE”, “IADE” ve “IHRACKAYITLI” tiplerinden biri olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='YATIRIMTESVIK') or (cbc:InvoiceTypeCode = 'SATIS' or cbc:InvoiceTypeCode = 'ISTISNA' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'TEVKIFATIADE')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='YATIRIMTESVIK') or (cbc:InvoiceTypeCode = 'SATIS' or cbc:InvoiceTypeCode = 'ISTISNA' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'TEVKIFATIADE')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında fatura tipi “SATIS”, “ISTISNA” , “IADE” , "TEVKIFAT" ve "TEVKIFATIADE" tiplerinden biri olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='YATIRIMTESVIK' or (cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',cbc:InvoiceTypeCode,',')))) or (count(cac:ContractDocumentReference) = 1 and count(cac:ContractDocumentReference/cbc:ID[@schemeID = 'YTBNO']) > 0 and string-length(cac:ContractDocumentReference/cbc:ID[@schemeID = 'YTBNO']) = 6 and translate(cac:ContractDocumentReference/cbc:ID[@schemeID = 'YTBNO'], '0123456789', '') = '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='YATIRIMTESVIK' or (cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',cbc:InvoiceTypeCode,',')))) or (count(cac:ContractDocumentReference) = 1 and count(cac:ContractDocumentReference/cbc:ID[@schemeID = 'YTBNO']) > 0 and string-length(cac:ContractDocumentReference/cbc:ID[@schemeID = 'YTBNO']) = 6 and translate(cac:ContractDocumentReference/cbc:ID[@schemeID = 'YTBNO'], '0123456789', '') = '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında 6 Haneli Yatırım Teşvik Numarası olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='IDIS') or (cbc:InvoiceTypeCode = 'SATIS' or cbc:InvoiceTypeCode = 'ISTISNA' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'TEVKIFATIADE' or cbc:InvoiceTypeCode = 'IHRACKAYITLI')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='IDIS') or (cbc:InvoiceTypeCode = 'SATIS' or cbc:InvoiceTypeCode = 'ISTISNA' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'TEVKIFATIADE' or cbc:InvoiceTypeCode = 'IHRACKAYITLI')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IDIS fatura senaryosunda fatura tipi SATIS, ISTISNA, IADE, TEVKIFAT, TEVKIFATIADE ve IHRACKAYITLI tiplerinden biri olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cbc:UUID" mode="M35" priority="1029">
    <svrl:fired-rule context="inv:Invoice/cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı UUID formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:Signature" mode="M35" priority="1028">
    <svrl:fired-rule context="inv:Invoice/cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID='VKN_TCKN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID='VKN_TCKN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Signature elemanı içerisindeki cbc:ID elemanının schemeID niteliği değeri 'VKN_TCKN' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği 'VKN_TCKN' ye eşit olan elemanın uzunluğu vergi kimlik numarası için 10 karakter TC kimlik numrası için 11 karakter olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:WithholdingTaxTotal/cac:TaxSubtotal" mode="M35" priority="1027">
    <svrl:fired-rule context="inv:Invoice/cac:WithholdingTaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and             (string-length(normalize-space(string(cbc:Percent)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and (string-length(normalize-space(string(cbc:Percent)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:WithholdingTaxTotal elemanı geçerli ve boş değer içermeyen cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode ve cac:TaxSubtotal/cbc:Percent elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode elemanı : '<xsl:text />
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> Uyumsuz vergi tipi yüzdesi: '<xsl:text />
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" />
            <xsl:text />' vergi tipinin yüzdesi '<xsl:text />
            <xsl:value-of select="cbc:Percent" />
            <xsl:text />' olamaz </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M35" priority="1026">
    <svrl:fired-rule context="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" mode="M35" priority="1025">
    <svrl:fired-rule context="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile belgeyi düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile belgeyi düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party" mode="M35" priority="1024">
    <svrl:fired-rule context="inv:Invoice/cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:PartyTaxScheme/cac:TaxScheme/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:PartyTaxScheme/cac:TaxScheme/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name elamanı dolu olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//inv:Invoice/cbc:ProfileID = 'IDIS') or count(cac:PartyIdentification/cbc:ID[@schemeID='SEVKIYATNO' and starts-with(., 'SE-') and string-length(.) = 10 and translate(substring(., 4), '0123456789', '') = '']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//inv:Invoice/cbc:ProfileID = 'IDIS') or count(cac:PartyIdentification/cbc:ID[@schemeID='SEVKIYATNO' and starts-with(., 'SE-') and string-length(.) = 10 and translate(substring(., 4), '0123456789', '') = '']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Sevkiyat Numarası değeri SE-0000000 formatında girilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M35" priority="1023">
    <svrl:fired-rule context="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" mode="M35" priority="1022">
    <svrl:fired-rule context="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../../cbc:InvoiceTypeCode='TEKNOLOJIDESTEK') or cbc:ID/@schemeID='TCKN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../../cbc:InvoiceTypeCode='TEKNOLOJIDESTEK') or cbc:ID/@schemeID='TCKN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>TEKNOLOJIDESTEK fatura tipinde alıcı kimlik numarası TCKN olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile belgeyi alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile belgeyi alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID ='1460415308') or not(../../../cbc:ProfileID!='YOLCUBERABERFATURA') or not(../../../cbc:ProfileID!='IHRACAT') or not(../../../cbc:ProfileID!='OZELFATURA') or not(../../../cbc:ProfileID!='KAMU')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID ='1460415308') or not(../../../cbc:ProfileID!='YOLCUBERABERFATURA') or not(../../../cbc:ProfileID!='IHRACAT') or not(../../../cbc:ProfileID!='OZELFATURA') or not(../../../cbc:ProfileID!='KAMU')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> 1460415308 vergi Numaralı mükellefe (GÜMRÜK VE TİCARET BAKANLIĞI BİLGİ İŞLEMDAİRESİ BAŞKANLIĞI) yollanan fatura senaryosu 'YOLCUBERABERFATURA' veya IHRACAT olabilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party" mode="M35" priority="1021">
    <svrl:fired-rule context="inv:Invoice/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" mode="M35" priority="1020">
    <svrl:fired-rule context="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($TaxType, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($TaxType, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz  cbc:TaxTypeCode değeri : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" mode="M35" priority="1019">
    <svrl:fired-rule context="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($TaxType, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($TaxType, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz  cbc:TaxTypeCode değeri : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal" mode="M35" priority="1018">
    <svrl:fired-rule context="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../../cbc:InvoiceTypeCode = 'IADE' or ../../cbc:InvoiceTypeCode = 'YTBIADE' or ../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../cbc:InvoiceTypeCode = 'SGK' or ../../cbc:InvoiceTypeCode = 'KONAKLAMAVERGISI' or not(cbc:TaxAmount = 0) or not(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015') or string-length(normalize-space(cac:TaxCategory/cbc:TaxExemptionReason)) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="../../cbc:InvoiceTypeCode = 'IADE' or ../../cbc:InvoiceTypeCode = 'YTBIADE' or ../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../cbc:InvoiceTypeCode = 'SGK' or ../../cbc:InvoiceTypeCode = 'KONAKLAMAVERGISI' or not(cbc:TaxAmount = 0) or not(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015') or string-length(normalize-space(cac:TaxCategory/cbc:TaxExemptionReason)) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Vergi miktarı 0 olan 0015 vergi kodlu KDV için cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) elemanı bulunmalıdır ve boş değer içermemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal" mode="M35" priority="1017">
    <svrl:fired-rule context="inv:Invoice/cac:TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',../cbc:InvoiceTypeCode,',')))) and not(../cbc:InvoiceTypeCode = 'IADE' or ../cbc:InvoiceTypeCode = 'TEVKIFATIADE' or ../cbc:InvoiceTypeCode = 'YTBIADE' or ../cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE')) or (count(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0 and number(cbc:Percent) > 0]) = count(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015']) and count(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0 and number(cbc:Percent) > 0]) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',../cbc:InvoiceTypeCode,',')))) and not(../cbc:InvoiceTypeCode = 'IADE' or ../cbc:InvoiceTypeCode = 'TEVKIFATIADE' or ../cbc:InvoiceTypeCode = 'YTBIADE' or ../cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE')) or (count(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0 and number(cbc:Percent) > 0]) = count(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015']) and count(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0 and number(cbc:Percent) > 0]) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında KDV Oranı ve Değeri girilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((not(../cbc:ProfileID = 'TEMELFATURA' or ../cbc:ProfileID = 'TICARIFATURA' or ../cbc:ProfileID = 'EARSIVFATURA') or ((../cbc:InvoiceTypeCode = 'ISTISNA' or ../cbc:InvoiceTypeCode = 'IHRACKAYITLI') or (../cbc:ProfileID = 'EARSIVFATURA' and starts-with(../cbc:InvoiceTypeCode, 'YTB')))) and cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = 555)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((not(../cbc:ProfileID = 'TEMELFATURA' or ../cbc:ProfileID = 'TICARIFATURA' or ../cbc:ProfileID = 'EARSIVFATURA') or ((../cbc:InvoiceTypeCode = 'ISTISNA' or ../cbc:InvoiceTypeCode = 'IHRACKAYITLI') or (../cbc:ProfileID = 'EARSIVFATURA' and starts-with(../cbc:InvoiceTypeCode, 'YTB')))) and cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = 555)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
            <xsl:text />
            <xsl:value-of select="../cbc:ProfileID" />
            <xsl:text /> senaryolu <xsl:text />
            <xsl:value-of select="../cbc:InvoiceTypeCode" />
            <xsl:text /> fatura tipinde '555' vergi muafiyet kodu kullanılamaz.          </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = '555') or (not(../cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and (number(cbc:Percent) = 0 or number(cbc:TaxAmount) = 0)]) and not(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and (number(cbc:Percent) = 0 or number(cbc:TaxAmount) = 0)]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = '555') or (not(../cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and (number(cbc:Percent) = 0 or number(cbc:TaxAmount) = 0)]) and not(cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and (number(cbc:Percent) = 0 or number(cbc:TaxAmount) = 0)]))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Vergi istisna muafiyet kodu 555 olduğu durumda KDV 0 geçilemez.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" mode="M35" priority="1016">
    <svrl:fired-rule context="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReason)))) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReason)))) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) elemanı boş değer içermemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReasonCode)))) != 0 and contains($TaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReasonCode)))) != 0 and contains($TaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:TaxExemptionReasonCode niteliği : '<xsl:text />
            <xsl:value-of select="cbc:TaxExemptionReasonCode" />
            <xsl:text />' cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) elemanı varken cbc:TaxExemptionReasonCode elamanı dolu ve geçerli bir değer olmalıdır. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(cbc:TaxExemptionReasonCode != 555 and contains($istisnaTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'ISTISNA' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'SGK' or ../../../cbc:InvoiceTypeCode = 'YTBISTISNA' or ../../../cbc:InvoiceTypeCode = 'YTBIADE'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../../cbc:UBLVersionID ='2.1') or not(cbc:TaxExemptionReasonCode != 555 and contains($istisnaTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'ISTISNA' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'SGK' or ../../../cbc:InvoiceTypeCode = 'YTBISTISNA' or ../../../cbc:InvoiceTypeCode = 'YTBIADE'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uyumsuz fatura tipi: '<xsl:text />
            <xsl:value-of select="../../../cbc:InvoiceTypeCode" />
            <xsl:text />'. Vergi istisna muhafiyet kodu : '<xsl:text />
            <xsl:value-of select="cbc:TaxExemptionReasonCode" />
            <xsl:text />' için fatura tipi ISTISNA,IADE,IHRACKAYITLI,SGK,YTBIADE veya YTBISTISNA olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ozelMatrahTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'SGK'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ozelMatrahTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'SGK'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uyumsuz fatura tipi: '<xsl:text />
            <xsl:value-of select="../../../cbc:InvoiceTypeCode" />
            <xsl:text />'.  Vergi istisna muhafiyet kodu : '<xsl:text />
            <xsl:value-of select="cbc:TaxExemptionReasonCode" />
            <xsl:text />' için fatura tipi OZELMATRAH,IADE veya SGK olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ihracExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'SGK' " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ihracExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'SGK'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uyumsuz fatura tipi: '<xsl:text />
            <xsl:value-of select="../../../cbc:InvoiceTypeCode" />
            <xsl:text />'.  Vergi istisna muhafiyet kodu : '<xsl:text />
            <xsl:value-of select="cbc:TaxExemptionReasonCode" />
            <xsl:text />' için fatura tipi IHRACKAYITLI,IADE veya SGK olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' and cbc:TaxExemptionReasonCode = '702') or (count(../../../cac:InvoiceLine/cac:Delivery/cac:Shipment[cac:GoodsItem/cbc:RequiredCustomsID[string-length(normalize-space(string(text()))) = 12] and cac:TransportHandlingUnit/cac:CustomsDeclaration/cac:IssuerParty/cac:PartyIdentification/cbc:ID[@schemeID='ALICIDIBSATIRKOD' and string-length(normalize-space(string(text()))) = 11]]) = count(../../../cac:InvoiceLine))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' and cbc:TaxExemptionReasonCode = '702') or (count(../../../cac:InvoiceLine/cac:Delivery/cac:Shipment[cac:GoodsItem/cbc:RequiredCustomsID[string-length(normalize-space(string(text()))) = 12] and cac:TransportHandlingUnit/cac:CustomsDeclaration/cac:IssuerParty/cac:PartyIdentification/cbc:ID[@schemeID='ALICIDIBSATIRKOD' and string-length(normalize-space(string(text()))) = 11]]) = count(../../../cac:InvoiceLine))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IHRACKAYITLI fatura tipinde 702 Muafiyet sebebi için GTİP ve Alıcı Satır Kodu bilgisi girilmelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine" mode="M35" priority="1015">
    <svrl:fired-rule context="inv:Invoice/cac:InvoiceLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Price/cbc:PriceAmount))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Price/cbc:PriceAmount))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:InvoiceLine elemanı geçerli ve boş değer içermeyen cac:Price/cbc:PriceAmount elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cbc:LineExtensionAmount))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cbc:LineExtensionAmount))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:InvoiceLine elemanı geçerli ve boş değer içermeyen cbc:LineExtensionAmount elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or count(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or count(../cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or count(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or count(../cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:InvoiceLine/cac:Delivery/cac:DeliveryTerms elamanı schemeID niteliği değeri 'INCOTERMS' olan en az bir cbc:ID elemanı içermiyorsa, Invoice/cac:Delivery/cac:DeliveryTerms elamanı schemeID niteliği değeri 'INCOTERMS' olan en az bir cbc:ID elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or cac:Delivery/cac:DeliveryAddress or ../cac:Delivery/cac:DeliveryAddress" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or cac:Delivery/cac:DeliveryAddress or ../cac:Delivery/cac:DeliveryAddress">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken Invoice ve cac:InvoiceLine elemanlarından en az bir tanesi cac:Delivery/cac:DeliveryAddress elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode))) != 0 or string-length(normalize-space(string(../cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode))) != 0 or string-length(normalize-space(string(../cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:InvoiceLine elemanı Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode elamanı içermiyorsa Invoice elemanı Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Delivery/cac:Shipment/cac:GoodsItem/cbc:RequiredCustomsID))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Delivery/cac:Shipment/cac:GoodsItem/cbc:RequiredCustomsID))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:InvoiceLine elemanı geçerli ve boş değer içermeyen ccac:Delivery/cac:Shipment/cac:GoodsItem/cbc:RequiredCustomsID elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cbc:InvoicedQuantity))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cbc:InvoicedQuantity))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:InvoiceLine elemanı geçerli ve boş değer içermeyen cbc:InvoicedQuantity elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or contains($DeliveryTermCodeList, concat(',',cac:Delivery/cac:DeliveryTerms/cbc:ID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or contains($DeliveryTermCodeList, concat(',',cac:Delivery/cac:DeliveryTerms/cbc:ID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, schemeID niteliği INCOTERMS olan Geçersiz cac:Delivery/cac:DeliveryTerms/cbc:ID değeri : '<xsl:text />
            <xsl:value-of select="cac:Delivery/cac:DeliveryTerms/cbc:ID" />
            <xsl:text />' Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode)) or contains($PackageTypeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode)) or contains($PackageTypeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz : cbc:PackagingTypeCode değeri : '<xsl:text />
            <xsl:value-of select="cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode" />
            <xsl:text />' Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode)) or contains($TransportModeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode)) or contains($TransportModeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:TransportModeCode : '<xsl:text />
            <xsl:value-of select="cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode" />
            <xsl:text />' Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='ILAC_TIBBICIHAZ') or count(cac:Item/cac:AdditionalItemIdentification/cbc:ID[(@schemeID = 'ILAC' or @schemeID = 'TIBBICIHAZ' or @schemeID = 'DIGER') and (string-length(normalize-space())) != 0]) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='ILAC_TIBBICIHAZ') or count(cac:Item/cac:AdditionalItemIdentification/cbc:ID[(@schemeID = 'ILAC' or @schemeID = 'TIBBICIHAZ' or @schemeID = 'DIGER') and (string-length(normalize-space())) != 0]) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri ILAC_TIBBICIHAZ iken, satır bazında geçerli kod listesinde yer alan en az 1 tane AdditionalItemIdentification elementi içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:InvoiceTypeCode = 'TEKNOLOJIDESTEK') or cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID = 'TELEFON' or @schemeID = 'TABLET_PC']" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:InvoiceTypeCode = 'TEKNOLOJIDESTEK') or cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID = 'TELEFON' or @schemeID = 'TABLET_PC']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>TEKNOLOJIDESTEK fatura tipinde yer alan tüm kalemler TELEFON, TABLET_PC schemeID li cac:AdditionalItemIdentification bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:InvoiceTypeCode = 'IHRACKAYITLI' and ../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = '702') or count(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:CustomsDeclaration/cac:IssuerParty/cac:PartyIdentification/cbc:ID[@schemeID and not(contains(concat(',', $IhracKayitliPartyIdentificationIDType, ','), concat(',', @schemeID, ',')))]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:InvoiceTypeCode = 'IHRACKAYITLI' and ../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode = '702') or count(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:CustomsDeclaration/cac:IssuerParty/cac:PartyIdentification/cbc:ID[@schemeID and not(contains(concat(',', $IhracKayitliPartyIdentificationIDType, ','), concat(',', @schemeID, ',')))]) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz Ihraç Kayıtlı schemeID niteliği. Geçerli değerler için kod listesine bakınız."</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',../cbc:InvoiceTypeCode,',')))) or count(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',../cbc:InvoiceTypeCode,',')))) or count(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında Harcama Tipi belirtilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',../cbc:InvoiceTypeCode,',')))) or contains($YatirimTesvikItemClassificationCodeList, concat(',',cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',../cbc:InvoiceTypeCode,',')))) or contains($YatirimTesvikItemClassificationCodeList, concat(',',cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ItemClassificationCode elemanı değeri. Geçerki değer için YatirimTesvikItemClassificationCodeList listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) or contains(',01,02,', concat(',',cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) or contains(',01,02,', concat(',',cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında ISTISNA Fatura Tipinde Harcama Tipi 01 veya 02 kodunu alabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) or count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and cbc:CalculationSequenceNumeric = '-1']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) or count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and cbc:CalculationSequenceNumeric = '-1']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında ISTISNA Fatura Tipinde cbc:CalculationSequenceNumeric alanı -1 seçilmelidir. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) and cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '01') or count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:TaxTypeCode = '0015' and cbc:TaxExemptionReasonCode = '308']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) and cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '01') or count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:TaxTypeCode = '0015' and cbc:TaxExemptionReasonCode = '308']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında ISTISNA Fatura Tipinde Harcama Tipi 01 ise 308 istisna kodu seçilebilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) and cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '02') or count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:TaxTypeCode = '0015' and cbc:TaxExemptionReasonCode = '339']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(((../cbc:ProfileID = 'YATIRIMTESVIK' and ../cbc:InvoiceTypeCode = 'ISTISNA') or (../cbc:ProfileID = 'EARSIVFATURA' and ../cbc:InvoiceTypeCode = 'YTBISTISNA')) and cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '02') or count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:TaxTypeCode = '0015' and cbc:TaxExemptionReasonCode = '339']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında ISTISNA Fatura Tipinde Harcama Tipi 02 ise 339 istisna kodu seçilebilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',../cbc:InvoiceTypeCode,',')))) and cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '01') or (string-length(normalize-space(string(cac:Item/cbc:ModelName))) != 0 and string-length(normalize-space(string(cac:Item/cac:ItemInstance/cbc:ProductTraceID))) != 0 and string-length(normalize-space(string(cac:Item/cac:ItemInstance/cbc:SerialID))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',../cbc:InvoiceTypeCode,',')))) and cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '01') or (string-length(normalize-space(string(cac:Item/cbc:ModelName))) != 0 and string-length(normalize-space(string(cac:Item/cac:ItemInstance/cbc:ProductTraceID))) != 0 and string-length(normalize-space(string(cac:Item/cac:ItemInstance/cbc:SerialID))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında Harcama Tipi 01 için Makine Adı, Makine Teçhizat Sıra No ve Makine ID alanları belirtilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',../cbc:InvoiceTypeCode,',')))) and not(../cbc:InvoiceTypeCode = 'IADE' or ../cbc:InvoiceTypeCode = 'TEVKIFATIADE' or ../cbc:InvoiceTypeCode = 'YTBIADE' or ../cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE')) or count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0 and number(cbc:Percent) > 0]) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',../cbc:InvoiceTypeCode,',')))) and not(../cbc:InvoiceTypeCode = 'IADE' or ../cbc:InvoiceTypeCode = 'TEVKIFATIADE' or ../cbc:InvoiceTypeCode = 'YTBIADE' or ../cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE')) or count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0 and number(cbc:Percent) > 0]) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında Kalem Bazında KDV Oranı ve Değeri girilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList,  concat(',',../cbc:InvoiceTypeCode,',')))) and (../cbc:InvoiceTypeCode = 'IADE' or ../cbc:InvoiceTypeCode = 'TEVKIFATIADE' or ../cbc:InvoiceTypeCode = 'YTBIADE' or ../cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE')) or not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '03' or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '04') or count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0]) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((../cbc:ProfileID = 'YATIRIMTESVIK' or (../cbc:ProfileID='EARSIVFATURA' and contains($YatirimTesvikEArsivInvoiceTypeCodeList, concat(',',../cbc:InvoiceTypeCode,',')))) and (../cbc:InvoiceTypeCode = 'IADE' or ../cbc:InvoiceTypeCode = 'TEVKIFATIADE' or ../cbc:InvoiceTypeCode = 'YTBIADE' or ../cbc:InvoiceTypeCode = 'YTBTEVKIFATIADE')) or not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '03' or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '04') or count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015' and number(cbc:TaxAmount) > 0]) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Yatırım Teşvik Faturasında Harcama Tipi 03 ve 04 için KDV değeri girilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID = 'IDIS') or count(cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='ETIKETNO' and string-length(.) = 9 and translate(substring(., 1, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '') = '' and translate(substring(., 3), '0123456789', '') = '']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID = 'IDIS') or count(cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='ETIKETNO' and string-length(.) = 9 and translate(substring(., 1, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '') = '' and translate(substring(., 3), '0123456789', '') = '']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>İlk iki hanesi karakter ve sonraki 7 hanesi rakam olan 9 karakterli en az bir Etiket Numarası bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine/cac:WithholdingTaxTotal/cac:TaxSubtotal" mode="M35" priority="1014">
    <svrl:fired-rule context="inv:Invoice/cac:InvoiceLine/cac:WithholdingTaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and             (string-length(normalize-space(string(cbc:Percent)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and (string-length(normalize-space(string(cbc:Percent)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:WithholdingTaxTotal elemanı geçerli ve boş değer içermeyen cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode ve cac:TaxSubtotal/cbc:Percent elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode elemanı : '<xsl:text />
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> Uyumsuz vergi tipi yüzdesi: '<xsl:text />
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" />
            <xsl:text />' vergi tipinin yüzdesi '<xsl:text />
            <xsl:value-of select="cbc:Percent" />
            <xsl:text />' olamaz </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity" mode="M35" priority="1013">
    <svrl:fired-rule context="inv:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(@unitCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(@unitCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:InvoicedQuantity elemanı geçerli ve boş değer içermeyen bir adet unitCode niteliğine sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" mode="M35" priority="1012">
    <svrl:fired-rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" mode="M35" priority="1011">
    <svrl:fired-rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" mode="M35" priority="1010">
    <svrl:fired-rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount" mode="M35" priority="1009">
    <svrl:fired-rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" mode="M35" priority="1008">
    <svrl:fired-rule context="inv:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:SignedInfo/ds:Reference/ds:Transforms" mode="M35" priority="1007">
    <svrl:fired-rule context="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:SignedInfo/ds:Reference/ds:Transforms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ds:Transform) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ds:Transform) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Transforms elemanı içerisinde en fazla bir tane ds:Transform elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cbc:TaxAmount" mode="M35" priority="1006">
    <svrl:fired-rule context="inv:Invoice/cac:TaxTotal/cbc:TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:Signature/cac:SignatoryParty" mode="M35" priority="1005">
    <svrl:fired-rule context="inv:Invoice/cac:Signature/cac:SignatoryParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN']) > 0 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN']) > 0 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:SignatoryParty alanı schemeID niteliği değeri 'VKN' veya 'TCKN' olan en az bir cac:PartyIdentification/cbc:ID elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cbc:TaxAmount" mode="M35" priority="1004">
    <svrl:fired-rule context="inv:Invoice/cac:TaxTotal/cbc:TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode" mode="M35" priority="1003">
    <svrl:fired-rule context="inv:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../cbc:UBLVersionID = '2.1') or contains($PaymentMeansCodeTypeList, concat(',',.,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../cbc:UBLVersionID = '2.1') or contains($PaymentMeansCodeTypeList, concat(',',.,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz  cbc:PaymentMeansCode değeri : '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:BillingReference/cac:AdditionalDocumentReference" mode="M35" priority="1002">
    <svrl:fired-rule context="inv:Invoice/cac:BillingReference/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or cbc:DocumentType = 'OKCBilgiFisi'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or cbc:DocumentType = 'OKCBilgiFisi'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBilgiFisi' olmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentType = 'OKCBilgiFisi') or cbc:DocumentTypeCode = 'OKCBF'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentType = 'OKCBilgiFisi') or cbc:DocumentTypeCode = 'OKCBF'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBilgiFisi' iken cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF olmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cbc:IssueDate)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cbc:IssueDate)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elamanı geçerli ve boş değer içermeyen bir cbc:
			elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cbc:ID)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cbc:ID)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elamanı geçerli ve boş değer içermeyen bir cbc:ID elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or contains($DocumentDescriptionType, concat(',',cbc:DocumentDescription,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or contains($DocumentDescriptionType, concat(',',cbc:DocumentDescription,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:DocumentDescription elemanı : '<xsl:text />
            <xsl:value-of select="cbc:DocumentDescription" />
            <xsl:text />'. cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elamanı geçerli ve boş değer içermeyen bir cbc:DocumentDescription elemanı içermelidir. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:Attachment/cac:ExternalReference/cbc:URI)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:Attachment/cac:ExternalReference/cbc:URI)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elamanı geçerli ve boş değer içermeyen bir cac:Attachment/cac:ExternalReference/cbc:URI elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:ValidityPeriod/cbc:StartDate)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:ValidityPeriod/cbc:StartDate)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elamanı geçerli ve boş değer içermeyen bir cac:ValidityPeriod/cbc:StartDate elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or cac:ValidityPeriod/cbc:StartDate = cbc:IssueDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or cac:ValidityPeriod/cbc:StartDate = cbc:IssueDate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> cac:BillingReference/cac:AdditionalDocumentReference/cac:ValidityPeriod/cbc:StartDate elemanının değeri ile cac:BillingReference/cac:AdditionalDocumentReference/cbc:IssueDate elemanının değeri aynı olmalıdır. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:IssuerParty/cbc:EndpointID)))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:IssuerParty/cbc:EndpointID)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode elemanının değeri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elamanı geçerli ve boş değer içermeyen bir cac:IssuerParty/cbc:EndpointID elemanı içermelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cbc:ProfileID" mode="M35" priority="1001">
    <svrl:fired-rule context="inv:Invoice/cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($receiverAlias = 'urn:mail:yolcuberaberpk@gtb.gov.tr') or (.='YOLCUBERABERFATURA')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($receiverAlias = 'urn:mail:yolcuberaberpk@gtb.gov.tr') or (.='YOLCUBERABERFATURA')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier elemanının değeri 'urn:mail:yolcuberaberpk@gtb.gov.tr' iken inv:Invoice/cbc:ProfileID elemanının değeri 'YOLCUBERABERFATURA' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($receiverAlias = 'urn:mail:ihracatpk@gtb.gov.tr') or (.='IHRACAT') or (.='OZELFATURA')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($receiverAlias = 'urn:mail:ihracatpk@gtb.gov.tr') or (.='IHRACAT') or (.='OZELFATURA')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier elemanının değeri 'urn:mail:ihracatpk@gtb.gov.tr' iken inv:Invoice/cbc:ProfileID elemanının değeri 'IHRACAT' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.='YOLCUBERABERFATURA') or (../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID='TAXFREE' and ../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.='YOLCUBERABERFATURA') or (../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID='TAXFREE' and ../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>inv:Invoice/cbc:ProfileID elemanının değeri 'YOLCUBERABERFATURA' iken cbc:ID elemanının değeri TAXFREE ve schemeID özelliği PARTYTYPE olan bir cac:BuyerCustomerParty içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.='IHRACAT') or (../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID='EXPORT' and ../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.='IHRACAT') or (../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID='EXPORT' and ../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>inv:Invoice elemanı inv:Invoice/cbc:ProfileID elemanının değeri 'IHRACAT' iken, schemeID özelliği PARTYTYPE olan ve değeri EXPORT olan cbc:ID elemanı içeren bir cac:BuyerCustomerParty elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.='KAMU') or matches(../cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID,'^TR\d{7}[A-Z0-9]{17}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.='KAMU') or matches(../cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID,'^TR\d{7}[A-Z0-9]{17}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>inv:Invoice/cbc:ProfileID elemanının değeri 'KAMU' iken cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID alanına geçerli bir Türkiye IBAN numarası yazılmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="inv:Invoice/cac:BuyerCustomerParty" mode="M35" priority="1000">
    <svrl:fired-rule context="inv:Invoice/cac:BuyerCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Party/cac:PartyIdentification/cbc:ID = 'TAXFREE') or not(cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE') or contains($CountryCodeList, concat(',',cac:Party/cac:Person/cbc:NationalityID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Party/cac:PartyIdentification/cbc:ID = 'TAXFREE') or not(cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE') or contains($CountryCodeList, concat(',',cac:Party/cac:Person/cbc:NationalityID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Invoice/BuyerCustomerParty/Party/PartyIdentification/cbc:ID elemanının değeri TAXFREE ve schemeID özelliği PARTYTYPE iken cac:Party/cac:Person/cbc:NationalityID elamanı dolu ve geçerli bir değer olmalıdır. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Party/cac:PartyIdentification/cbc:ID = 'TAXFREE') or not(cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE') or (string-length(normalize-space(string(cac:Party/cac:Person/cac:IdentityDocumentReference/cbc:ID)))) !=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Party/cac:PartyIdentification/cbc:ID = 'TAXFREE') or not(cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE') or (string-length(normalize-space(string(cac:Party/cac:Person/cac:IdentityDocumentReference/cbc:ID)))) !=0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Invoice/BuyerCustomerParty/Party/PartyIdentification/cbc:ID elemanının değeri TAXFREE ve schemeID özelliği PARTYTYPE iken cac:Party/cac:Person/cac:IdentityDocumentReference elamanı geçerli ve boş değer içermeyen bir cbc:ID elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT iken, cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName elamanı dolu olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN applicationresponse-->


	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature" mode="M36" priority="1015">
    <svrl:fired-rule context="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:SignedInfo/ds:Reference/ds:Transforms">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:KeyInfo" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:KeyInfo">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:Object" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:Object">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Object elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningTime elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningCertificate elemanı zorunlu bir elemandır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data" mode="M36" priority="1014">
    <svrl:fired-rule context="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:X509Certificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:X509Certificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" mode="M36" priority="1013">
    <svrl:fired-rule context="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse" mode="M36" priority="1012">
    <svrl:fired-rule context="apr:ApplicationResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:UBLVersionID = '2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:UBLVersionID = '2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:UBLVersionID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:UBLVersionID" />
            <xsl:text />'. cbc:UBLVersionID değeri '2.1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:CustomizationID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:CustomizationID" />
            <xsl:text />' cbc:CustomizationID elemanı değeri 'TR1.2' veya 'TR1.2.1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or cbc:ProfileID = 'UBL-TR-PROFILE-1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or cbc:ProfileID = 'UBL-TR-PROFILE-1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Sistem yanıtı için cbc:ProfileID  elemanı değeri 'UBL-TR-PROFILE-1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@xsi:schemaLocation) or contains(@xsi:schemaLocation,'UBL-ApplicationResponse-2.1.xsd')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@xsi:schemaLocation) or contains(@xsi:schemaLocation,'UBL-ApplicationResponse-2.1.xsd')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ApplicationResponse alanın  xsi:schemaLocation özeliği 'UBL-ApplicationResponse-2.1.xsd' olmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or (cbc:ProfileID = 'TICARIFATURA' or cbc:ProfileID = 'IHRACAT')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or (cbc:ProfileID = 'TICARIFATURA' or cbc:ProfileID = 'IHRACAT')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uygulama yanıtı için cbc:ProfileID  elemanı değeri 'TICARIFATURA' veya 'IHRACAT' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cbc:ID))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cbc:ID))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı boş olamaz.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID!='IHRACAT') or not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or cac:Signature" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID!='IHRACAT') or not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or cac:Signature">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uygulama yanıtı için cac:Signature elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID!='IHRACAT') or not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or ext:UBLExtensions" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID!='IHRACAT') or not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or ext:UBLExtensions">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Uygulama yanıtı için imza bilgisinin konulduğu ext:UBLExtensions elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:DocumentResponse) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:DocumentResponse) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:DocumentResponse elemanından bir tane olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Signature) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Signature) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>En fazla bir tane cac:Signature elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:Signature" mode="M36" priority="1011">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID/@schemeID='VKN_TCKN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID/@schemeID='VKN_TCKN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Signature elemanı içerisindeki cbc:ID elemanının schemeID niteliği değeri 'VKN_TCKN' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği 'VKN_TCKN' ye eşit olan elemanın uzunluğu vergi kimlik numarası için 10 karakter TC kimlik numrası için 11 karakter olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cbc:UUID" mode="M36" priority="1010">
    <svrl:fired-rule context="apr:ApplicationResponse/cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı UUID formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID" mode="M36" priority="1009">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification" mode="M36" priority="1008">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile sistem yanıtınını düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile sistem yanıtınını düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile uygulama yanıtınını düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile uygulama yanıtınını düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:SenderParty" mode="M36" priority="1007">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:SenderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or not(../cac:DocumentResponse/cac:Response/cbc:ResponseCode='KABUL') or count(cac:PartyIdentification/cbc:ID[@schemeID='GTB_GCB_TESCILNO'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or not(../cac:DocumentResponse/cac:Response/cbc:ResponseCode='KABUL') or count(cac:PartyIdentification/cbc:ID[@schemeID='GTB_GCB_TESCILNO'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT ve cbc:ResponseCode değeri'KABUL' iken, schemeID niteliği değeri 'GTB_GCB_TESCILNO' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID='IHRACAT') or not(../cac:DocumentResponse/cac:Response/cbc:ResponseCode='KABUL') or (count(cac:PartyIdentification/cbc:ID[@schemeID='GTB_FIILI_IHRACAT_TARIHI'])=1 and matches(cac:PartyIdentification/cbc:ID[@schemeID='GTB_FIILI_IHRACAT_TARIHI'],'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID='IHRACAT') or not(../cac:DocumentResponse/cac:Response/cbc:ResponseCode='KABUL') or (count(cac:PartyIdentification/cbc:ID[@schemeID='GTB_FIILI_IHRACAT_TARIHI'])=1 and matches(cac:PartyIdentification/cbc:ID[@schemeID='GTB_FIILI_IHRACAT_TARIHI'],'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ProfileID elemanının değeri IHRACAT ve cbc:ResponseCode değeri'KABUL' iken, schemeID niteliği değeri 'GTB_FIILI_IHRACAT_TARIHI' olan ve YYYY-MM-DD formatında geçerli değer içeren bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" mode="M36" priority="1006">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification" mode="M36" priority="1005">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile sistem yanıtınını alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile sistem yanıtınını alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile uygulama yanıtınını alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile uygulama yanıtınını alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:ReceiverParty" mode="M36" priority="1004">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:ReceiverParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse" mode="M36" priority="1003">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:DocumentResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or count(cac:LineResponse) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or count(cac:LineResponse) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Sistem yanıtı belgesi için cac:LineResponse elemanı zorunludur ve bir tane olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or not(count(cac:LineResponse) = 1) or count(cac:LineResponse/cac:Response) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or not(count(cac:LineResponse) = 1) or count(cac:LineResponse/cac:Response) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:LineResponse elemanı içerisinde bir tane cac:Response elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($responseCode = 'S_APR') or not(count(cac:LineResponse) = 1) or not(count(cac:LineResponse/cac:Response) = 1) or cac:LineResponse/cac:Response/cbc:ResponseCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($responseCode = 'S_APR') or not(count(cac:LineResponse) = 1) or not(count(cac:LineResponse/cac:Response) = 1) or cac:LineResponse/cac:Response/cbc:ResponseCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Response elemanı içerisinde cbc:ResponseCode elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse/cac:Response" mode="M36" priority="1002">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:DocumentResponse/cac:Response" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ResponseCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ResponseCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ResponseCode zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ResponseCode) or contains($ResponseCodeType, concat(',',cbc:ResponseCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ResponseCode) or contains($ResponseCodeType, concat(',',cbc:ResponseCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ResponseCode elemanı değeri '<xsl:text />
            <xsl:value-of select="cbc:ResponseCode" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($envelopeType = 'POSTBOXENVELOPE') or ( cbc:ResponseCode = 'RED' or cbc:ResponseCode = 'KABUL' or cbc:ResponseCode = 'IADE' or cbc:ResponseCode = 'GUMRUKONAY' )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($envelopeType = 'POSTBOXENVELOPE') or ( cbc:ResponseCode = 'RED' or cbc:ResponseCode = 'KABUL' or cbc:ResponseCode = 'IADE' or cbc:ResponseCode = 'GUMRUKONAY' )">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>POSTBOXENVELOPE türündeki zarfların cbc:ResponseCode değerleri sadece RED,KABUL,IADE veya GUMRUKONAY olabilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response" mode="M36" priority="1001">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Description) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Description) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Response elemanı içerisinde bir tane cbc:Description elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($envelopeType = 'POSTBOXENVELOPE') or ( cbc:ResponseCode = 'RED' or cbc:ResponseCode = 'KABUL' or cbc:ResponseCode = 'IADE' or cbc:ResponseCode = 'GUMRUKONAY' )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($envelopeType = 'POSTBOXENVELOPE') or ( cbc:ResponseCode = 'RED' or cbc:ResponseCode = 'KABUL' or cbc:ResponseCode = 'IADE' or cbc:ResponseCode = 'GUMRUKONAY' )">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>POSTBOXENVELOPE türündeki zarfların cbc:ResponseCode değerleri sadece RED,KABUL,IADE veya GUMRUKONAY olabilir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($envelopeType = 'SYSTEMENVELOPE') or contains($AppResponseCodeType, concat(',',cbc:ResponseCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($envelopeType = 'SYSTEMENVELOPE') or contains($AppResponseCodeType, concat(',',cbc:ResponseCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>SYSTEMENVELOPE türündeki zarflar için geçersiz cbc:ResponseCode elemanı değeri '<xsl:text />
            <xsl:value-of select="cbc:ResponseCode" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference" mode="M36" priority="1000">
    <svrl:fired-rule context="apr:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(normalize-space(string(cbc:DocumentTypeCode)))) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(normalize-space(string(cbc:DocumentTypeCode)))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:DocumentReference elemanı geçerli ve boş değer içermeyen cbc:DocumentTypeCode elemanına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(normalize-space(string(cbc:DocumentType )))) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(normalize-space(string(cbc:DocumentType )))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:DocumentReference elemanı geçerli ve boş değer içermeyen cbc:DocumentType  elemanına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN processuseraccount-->


	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea" mode="M37" priority="1011">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(oa:Sender) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(oa:Sender) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Bir tane oa:Sender elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(oa:Signature) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(oa:Signature) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:Signature zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Sender" mode="M37" priority="1010">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Sender" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="oa:LogicalID" />
      <xsl:otherwise>
        <svrl:failed-assert test="oa:LogicalID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:LogicalID zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(oa:LogicalID) or (string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(oa:LogicalID) or (string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:LogicalID elemanı 10 haneli VKN ve ya 11 haneli TCKN olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(oa:LogicalID) or not(string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11) or not($senderId) or oa:LogicalID = $senderId" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(oa:LogicalID) or not(string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11) or not($senderId) or oa:LogicalID = $senderId">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile kullanıcı işlemi yapacak özel entegratör(<xsl:text />
            <xsl:value-of select="oa:LogicalID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature" mode="M37" priority="1009">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ds:Signature) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ds:Signature) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:Signature elemanı içerisinde ds:Signature elemanı zorunludur.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature" mode="M37" priority="1008">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:SignedInfo/ds:Reference/ds:Transforms">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:KeyInfo" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:KeyInfo">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:Object" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:Object">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Object elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningTime elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningCertificate elemanı zorunlu bir elemandır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data" mode="M37" priority="1007">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:X509Certificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:X509Certificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" mode="M37" priority="1006">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature" mode="M37" priority="1005">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ds:Signature) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ds:Signature) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:CounterSignature elemanı içerisinde ds:Signature elemanı zorunludur.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature" mode="M37" priority="1004">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:SignedInfo/ds:Reference/ds:Transforms">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:KeyInfo" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:KeyInfo">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:Object" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:Object">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Object elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningTime elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningCertificate elemanı zorunlu bir elemandır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data" mode="M37" priority="1003">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:X509Certificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:X509Certificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" mode="M37" priority="1002">
    <svrl:fired-rule context="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/hr:DataArea" mode="M37" priority="1001">
    <svrl:fired-rule context="hr:ProcessUserAccount/hr:DataArea" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or count(hr:UserAccount) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or count(hr:UserAccount) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura saklama hizmeti için oluşturulan belgelerde yalnızca bir tane hr:UserAccount elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/hr:DataArea/hr:UserAccount" mode="M37" priority="1000">
    <svrl:fired-rule context="hr:ProcessUserAccount/hr:DataArea/hr:UserAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hr:UserID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hr:UserID) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:UserID zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hr:PersonName) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hr:PersonName) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:PersonName zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:UserRole) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:UserRole) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:UserRole zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')))  or count(hr:UserRole) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:UserRole) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:UserRole zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'earchive') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'earchive') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_earchive') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eticket') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eticket') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'earchive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'earchive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_earchive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eticket') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eticket') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Serbest Meslek hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Müstahsil hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'erevenue') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'erevenue') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Mali rapor hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt_archive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt_archive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Müstahsil saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher_archive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher_archive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Serbest Meslek saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'ebreceipt') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'ebreceipt') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Dekont hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eexchangecert') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eexchangecert') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Döviz hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'echeck') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'echeck') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Adisyon hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hr:AccountConfiguration) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hr:AccountConfiguration) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:AccountConfiguration zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or (string-length(normalize-space(hr:UserID)) = 10 or string-length(normalize-space(hr:UserID)) = 11)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or (string-length(normalize-space(hr:UserID)) = 10 or string-length(normalize-space(hr:UserID)) = 11)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserID elemanına 10 haneli VKN ve ya 11 haneli TCKN yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 10) or not(hr:PersonName) or string-length(normalize-space(hr:PersonName/hr:FormattedName)) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 10) or not(hr:PersonName) or string-length(normalize-space(hr:PersonName/hr:FormattedName)) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Vergi kimlik numarasına sahip kullanıcılar için unvan bilgisi hr:FormattedName elemanına yazılmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 11) or not(hr:PersonName) or (string-length(normalize-space(hr:PersonName/oa:GivenName)) > 0 and string-length(normalize-space(hr:PersonName/hr:FamilyName)) > 0 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 11) or not(hr:PersonName) or (string-length(normalize-space(hr:PersonName/oa:GivenName)) > 0 and string-length(normalize-space(hr:PersonName/hr:FamilyName)) > 0 )">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>TC kimlik numarasına sahip kullanıcı için ad bilgisi oa:GivenName elemanına ve soyad bilgisi hr:FamilyName elemanına yazılmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:UserRole) = 1) or hr:UserRole/hr:RoleCode " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:UserRole) = 1) or hr:UserRole/hr:RoleCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:RoleCode zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:UserRole) = 1) or not(hr:UserRole/hr:RoleCode) or (normalize-space(hr:UserRole/hr:RoleCode) = 'GB' or normalize-space(hr:UserRole/hr:RoleCode) = 'PK')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:UserRole) = 1) or not(hr:UserRole/hr:RoleCode) or (normalize-space(hr:UserRole/hr:RoleCode) = 'GB' or normalize-space(hr:UserRole/hr:RoleCode) = 'PK')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:RoleCode elemanı değeri 'GB' ve ya 'PK' olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve boş bırakılmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &lt;= 250 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &lt;= 250">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve 250 karakterden fazla olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or not(contains($ReservedAliases, concat(',',normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),','))) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or not(contains($ReservedAliases, concat(',',normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),',')))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:WorkScopeCode(etiket) elemanında yasaklı bir etiket kullanmaktasınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or matches(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),'^urn:[A-Za-z0-9][A-Za-z0-9-]{0,31}:([A-Za-z0-9()+,-.:=@;$_!*]|%[0-9A-Fa-f]{2})+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or matches(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),'^urn:[A-Za-z0-9][A-Za-z0-9-]{0,31}:([A-Za-z0-9()+,-.:=@;$_!*]|%[0-9A-Fa-f]{2})+$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz hr:WorkScopeCode(etiket) değeri : <xsl:text />
            <xsl:value-of select="hr:AuthorizedWorkScope/hr:WorkScopeCode" />
            <xsl:text />. hr:WorkScopeCode(etiket) zorunlu bir elemandır ve urn formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'usergb') or not(count(hr:AccountConfiguration) = 1) or contains(',1,2,3,4,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'usergb') or not(count(hr:AccountConfiguration) = 1) or contains(',1,2,3,4,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 1,2,3,4 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or not(count(hr:AccountConfiguration) = 1) or contains(',11,12,13,14,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or not(count(hr:AccountConfiguration) = 1) or contains(',11,12,13,14,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 11,12,13,14 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',21,22,23,24,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',21,22,23,24,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 21,22,23,24 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',31,32,33,34,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',31,32,33,34,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 31,32,33,34 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eticket') or not(count(hr:AccountConfiguration) = 1) or contains(',41,42,43,44,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eticket') or not(count(hr:AccountConfiguration) = 1) or contains(',41,42,43,44,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 41,42,43,44 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',51,52,53,54,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',51,52,53,54,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 51,52,53,54 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',61,62,63,64,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',61,62,63,64,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 61,62,63,64 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher') or not(count(hr:AccountConfiguration) = 1) or contains(',71,72,73,74,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher') or not(count(hr:AccountConfiguration) = 1) or contains(',71,72,73,74,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 71,72,73,74 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',81,82,83,84,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',81,82,83,84,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 81,82,83,84 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',91,92,93,94,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',91,92,93,94,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 91,92,93,94 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',101,102,103,104,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',101,102,103,104,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 101,102,103,104 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'erevenue') or not(count(hr:AccountConfiguration) = 1) or contains(',111,112,121,122,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'erevenue') or not(count(hr:AccountConfiguration) = 1) or contains(',111,112,121,122,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 111,112,121 veya 122 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'ebreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',131,132,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'ebreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',131,132,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 131 veya 132 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eexchangecert') or not(count(hr:AccountConfiguration) = 1) or contains(',141,142,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eexchangecert') or not(count(hr:AccountConfiguration) = 1) or contains(',141,142,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 141 veya 142 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'echeck') or not(count(hr:AccountConfiguration) = 1) or contains(',151,152,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'echeck') or not(count(hr:AccountConfiguration) = 1) or contains(',151,152,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 151 veya 152 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'einsurancecomm') or not(count(hr:AccountConfiguration) = 1) or contains(',161,162,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'einsurancecomm') or not(count(hr:AccountConfiguration) = 1) or contains(',161,162,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 161 veya 162 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or not(following-sibling::hr:UserAccount) or  normalize-space(hr:UserID) = following-sibling::node()/normalize-space(hr:UserID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or not(following-sibling::hr:UserAccount) or normalize-space(hr:UserID) = following-sibling::node()/normalize-space(hr:UserID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserID'ye ait işlem yapılmalıdır. Farklı iki hr:UserID(<xsl:text />
            <xsl:value-of select="hr:UserID" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:UserID" />
            <xsl:text />) bulundu. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FormattedName) or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FormattedName) = following::node()/hr:PersonName/normalize-space(hr:FormattedName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/hr:FormattedName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(hr:FormattedName) = following::node()/hr:PersonName/normalize-space(hr:FormattedName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FormattedName'e ait işlem yapılmalıdır. Farklı iki hr:FormattedName(<xsl:text />
            <xsl:value-of select="hr:PersonName/hr:FormattedName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following-sibling::node()/hr:PersonName/hr:FormattedName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/oa:GivenName)     or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(oa:GivenName)     = following::node()/hr:PersonName/normalize-space(oa:GivenName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/oa:GivenName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(oa:GivenName) = following::node()/hr:PersonName/normalize-space(oa:GivenName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı oa:GivenName'e ait işlem yapılmalıdır. Farklı iki oa:GivenName(<xsl:text />
            <xsl:value-of select="hr:PersonName/oa:GivenName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:PersonName/oa:GivenName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:MiddleName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:MiddleName)    = following::node()/hr:PersonName/normalize-space(hr:MiddleName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/hr:MiddleName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(hr:MiddleName) = following::node()/hr:PersonName/normalize-space(hr:MiddleName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:MiddleName'e ait işlem yapılmalıdır. Farklı iki hr:MiddleName(<xsl:text />
            <xsl:value-of select="hr:PersonName/hr:MiddleName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:PersonName/hr:MiddleName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FamilyName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FamilyName)    = following::node()/hr:PersonName/normalize-space(hr:FamilyName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/hr:FamilyName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(hr:FamilyName) = following::node()/hr:PersonName/normalize-space(hr:FamilyName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FamilyName'e ait işlem yapılmalıdır. Farklı iki hr:FamilyName(<xsl:text />
            <xsl:value-of select="hr:PersonName/hr:FamilyName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:PersonName/hr:FamilyName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:AccountConfiguration) or not(hr:AccountConfiguration/hr:UserOptionCode) or not(following-sibling::hr:UserAccount) or  hr:AccountConfiguration/normalize-space(hr:UserOptionCode) = following::node()/hr:AccountConfiguration/normalize-space(hr:UserOptionCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:AccountConfiguration) or not(hr:AccountConfiguration/hr:UserOptionCode) or not(following-sibling::hr:UserAccount) or hr:AccountConfiguration/normalize-space(hr:UserOptionCode) = following::node()/hr:AccountConfiguration/normalize-space(hr:UserOptionCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserOptionCode'e ait işlem yapılmalıdır. Farklı iki hr:UserOptionCode(<xsl:text />
            <xsl:value-of select="hr:AccountConfiguration/hr:UserOptionCode" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:AccountConfiguration/hr:UserOptionCode" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN canceluseraccount-->


	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea" mode="M38" priority="1011">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(oa:Sender) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(oa:Sender) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Bir tane oa:Sender elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(oa:Signature) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(oa:Signature) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:Signature zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Sender" mode="M38" priority="1010">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Sender" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="oa:LogicalID" />
      <xsl:otherwise>
        <svrl:failed-assert test="oa:LogicalID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:LogicalID zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(oa:LogicalID) or (string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(oa:LogicalID) or (string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:LogicalID elemanı 10 haneli VKN ve ya 11 haneli TCKN olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(oa:LogicalID) or not(string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11) or not($senderId) or oa:LogicalID = $senderId" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(oa:LogicalID) or not(string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11) or not($senderId) or oa:LogicalID = $senderId">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile kullanıcı işlemi yapacak özel entegratör(<xsl:text />
            <xsl:value-of select="oa:LogicalID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature" mode="M38" priority="1009">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ds:Signature) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ds:Signature) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>oa:Signature elemanı içerisinde ds:Signature elemanı zorunludur.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature" mode="M38" priority="1008">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:SignedInfo/ds:Reference/ds:Transforms">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:KeyInfo" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:KeyInfo">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:Object" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:Object">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Object elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningTime elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningCertificate elemanı zorunlu bir elemandır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data" mode="M38" priority="1007">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:X509Certificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:X509Certificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" mode="M38" priority="1006">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature" mode="M38" priority="1005">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ds:Signature) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ds:Signature) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:CounterSignature elemanı içerisinde ds:Signature elemanı zorunludur.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature" mode="M38" priority="1004">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:SignedInfo/ds:Reference/ds:Transforms">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:KeyInfo" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:KeyInfo">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:Object" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:Object">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:Object elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningTime elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>xades:SigningCertificate elemanı zorunlu bir elemandır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data" mode="M38" priority="1003">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ds:X509Certificate" />
      <xsl:otherwise>
        <svrl:failed-assert test="ds:X509Certificate">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" mode="M38" priority="1002">
    <svrl:fired-rule context="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) != 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/hr:DataArea" mode="M38" priority="1001">
    <svrl:fired-rule context="hr:CancelUserAccount/hr:DataArea" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or count(hr:UserAccount) = 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or count(hr:UserAccount) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura saklama hizmeti için oluşturulan belgelerde yalnızca bir tane hr:UserAccount elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/hr:DataArea/hr:UserAccount" mode="M38" priority="1000">
    <svrl:fired-rule context="hr:CancelUserAccount/hr:DataArea/hr:UserAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hr:UserID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hr:UserID) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:UserID zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hr:PersonName) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hr:PersonName) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:PersonName zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:UserRole) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:UserRole) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:UserRole zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')))  or count(hr:UserRole) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:UserRole) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:UserRole zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'earchive') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'earchive') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_earchive') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eticket') or count(hr:UserRole) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eticket') or count(hr:UserRole) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'usergb') or not(contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'edespatch') or not(contains(',51,52,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))) or count(hr:AuthorizedWorkScope) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'earchive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'earchive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_earchive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eticket') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eticket') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Serbest Meslek hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Müstahsil hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'erevenue') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'erevenue') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Mali rapor hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt_archive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt_archive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Müstahsil saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher_archive') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher_archive') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Serbest Meslek saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'ebreceipt') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'ebreceipt') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Dekont hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eexchangecert') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eexchangecert') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Döviz hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'echeck') or count(hr:AuthorizedWorkScope) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'echeck') or count(hr:AuthorizedWorkScope) = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>E-Adisyon hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hr:AccountConfiguration) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hr:AccountConfiguration) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserAccount elemanı içersinde hr:AccountConfiguration zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or (string-length(normalize-space(hr:UserID)) = 10 or string-length(normalize-space(hr:UserID)) = 11)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or (string-length(normalize-space(hr:UserID)) = 10 or string-length(normalize-space(hr:UserID)) = 11)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserID elemanına 10 haneli VKN ve ya 11 haneli TCKN yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 10) or not(hr:PersonName) or string-length(normalize-space(hr:PersonName/hr:FormattedName)) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 10) or not(hr:PersonName) or string-length(normalize-space(hr:PersonName/hr:FormattedName)) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Vergi kimlik numarasına sahip kullanıcılar için unvan bilgisi hr:FormattedName elemanına yazılmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 11) or not(hr:PersonName) or (string-length(normalize-space(hr:PersonName/oa:GivenName)) > 0 and string-length(normalize-space(hr:PersonName/hr:FamilyName)) > 0 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 11) or not(hr:PersonName) or (string-length(normalize-space(hr:PersonName/oa:GivenName)) > 0 and string-length(normalize-space(hr:PersonName/hr:FamilyName)) > 0 )">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>TC kimlik numarasına sahip kullanıcı için ad bilgisi oa:GivenName elemanına ve soyad bilgisi hr:FamilyName elemanına yazılmaldır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:UserRole) = 1) or hr:UserRole/hr:RoleCode " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:UserRole) = 1) or hr:UserRole/hr:RoleCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:RoleCode zorunlu bir elemandır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:UserRole) = 1) or not(hr:UserRole/hr:RoleCode) or (normalize-space(hr:UserRole/hr:RoleCode) = 'GB' or normalize-space(hr:UserRole/hr:RoleCode) = 'PK')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:UserRole) = 1) or not(hr:UserRole/hr:RoleCode) or (normalize-space(hr:UserRole/hr:RoleCode) = 'GB' or normalize-space(hr:UserRole/hr:RoleCode) = 'PK')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:RoleCode elemanı değeri 'GB' ve ya 'PK' olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve boş bırakılmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &lt;= 250 " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &lt;= 250">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve 250 karakterden fazla olmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or not(contains($ReservedAliases, concat(',',normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),','))) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or not(contains($ReservedAliases, concat(',',normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),',')))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:WorkScopeCode(etiket) elemanında yasaklı bir etiket kullanmaktasınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or matches(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),'^urn:[A-Za-z0-9][A-Za-z0-9-]{0,31}:([A-Za-z0-9()+,-.:=@;$_!*]|%[0-9A-Fa-f]{2})+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(hr:AuthorizedWorkScope) = 1) or matches(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),'^urn:[A-Za-z0-9][A-Za-z0-9-]{0,31}:([A-Za-z0-9()+,-.:=@;$_!*]|%[0-9A-Fa-f]{2})+$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz hr:WorkScopeCode(etiket) değeri : <xsl:text />
            <xsl:value-of select="hr:AuthorizedWorkScope/hr:WorkScopeCode" />
            <xsl:text />. hr:WorkScopeCode(etiket) zorunlu bir elemandır ve urn formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'usergb') or not(count(hr:AccountConfiguration) = 1) or contains(',1,2,3,4,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'usergb') or not(count(hr:AccountConfiguration) = 1) or contains(',1,2,3,4,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 1,2,3,4 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive') or not(count(hr:AccountConfiguration) = 1) or contains(',11,12,13,14,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive') or not(count(hr:AccountConfiguration) = 1) or contains(',11,12,13,14,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 11,12,13,14 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',21,22,23,24,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',21,22,23,24,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 21,22,23,24 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',31,32,33,34,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',31,32,33,34,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 31,32,33,34 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eticket') or not(count(hr:AccountConfiguration) = 1) or contains(',41,42,43,44,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eticket') or not(count(hr:AccountConfiguration) = 1) or contains(',41,42,43,44,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 41,42,43,44 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',51,52,53,54,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',51,52,53,54,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 51,52,53,54 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'archive_edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',61,62,63,64,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'archive_edespatch') or not(count(hr:AccountConfiguration) = 1) or contains(',61,62,63,64,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 61,62,63,64 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher') or not(count(hr:AccountConfiguration) = 1) or contains(',71,72,73,74,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher') or not(count(hr:AccountConfiguration) = 1) or contains(',71,72,73,74,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 71,72,73,74 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',81,82,83,84,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',81,82,83,84,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 81,82,83,84 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'esevoucher_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',91,92,93,94,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'esevoucher_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',91,92,93,94,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 91,92,93,94 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'epreceipt_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',101,102,103,104,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'epreceipt_archive') or not(count(hr:AccountConfiguration) = 1) or contains(',101,102,103,104,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 101,102,103,104 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'erevenue') or not(count(hr:AccountConfiguration) = 1) or contains(',111,112,121,122,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'erevenue') or not(count(hr:AccountConfiguration) = 1) or contains(',111,112,121,122,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 111,112,121 veya 122 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'ebreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',131,132,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'ebreceipt') or not(count(hr:AccountConfiguration) = 1) or contains(',131,132,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 131 veya 132 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'eexchangecert') or not(count(hr:AccountConfiguration) = 1) or contains(',141,142,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'eexchangecert') or not(count(hr:AccountConfiguration) = 1) or contains(',141,142,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 141 veya 142 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'echeck') or not(count(hr:AccountConfiguration) = 1) or contains(',151,152,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'echeck') or not(count(hr:AccountConfiguration) = 1) or contains(',151,152,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 151 veya 152 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($senderAlias = 'einsurancecomm') or not(count(hr:AccountConfiguration) = 1) or contains(',161,162,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not($senderAlias = 'einsurancecomm') or not(count(hr:AccountConfiguration) = 1) or contains(',161,162,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>hr:UserOptionCode zorunlu bir elemandır ve değeri 161 veya 162 olabilir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:UserID) or not(following-sibling::hr:UserAccount) or  normalize-space(hr:UserID) = following-sibling::node()/normalize-space(hr:UserID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:UserID) or not(following-sibling::hr:UserAccount) or normalize-space(hr:UserID) = following-sibling::node()/normalize-space(hr:UserID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserID'ye ait işlem yapılmalıdır. Farklı iki hr:UserID(<xsl:text />
            <xsl:value-of select="hr:UserID" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:UserID" />
            <xsl:text />) bulundu. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FormattedName) or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FormattedName) = following::node()/hr:PersonName/normalize-space(hr:FormattedName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/hr:FormattedName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(hr:FormattedName) = following::node()/hr:PersonName/normalize-space(hr:FormattedName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FormattedName'e ait işlem yapılmalıdır. Farklı iki hr:FormattedName(<xsl:text />
            <xsl:value-of select="hr:PersonName/hr:FormattedName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following-sibling::node()/hr:PersonName/hr:FormattedName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/oa:GivenName)     or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(oa:GivenName)     = following::node()/hr:PersonName/normalize-space(oa:GivenName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/oa:GivenName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(oa:GivenName) = following::node()/hr:PersonName/normalize-space(oa:GivenName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı oa:GivenName'e ait işlem yapılmalıdır. Farklı iki oa:GivenName(<xsl:text />
            <xsl:value-of select="hr:PersonName/oa:GivenName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:PersonName/oa:GivenName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:MiddleName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:MiddleName)    = following::node()/hr:PersonName/normalize-space(hr:MiddleName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/hr:MiddleName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(hr:MiddleName) = following::node()/hr:PersonName/normalize-space(hr:MiddleName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:MiddleName'e ait işlem yapılmalıdır. Farklı iki hr:MiddleName(<xsl:text />
            <xsl:value-of select="hr:PersonName/hr:MiddleName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:PersonName/hr:MiddleName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FamilyName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FamilyName)    = following::node()/hr:PersonName/normalize-space(hr:FamilyName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:PersonName) or not(hr:PersonName/hr:FamilyName) or not(following-sibling::hr:UserAccount) or hr:PersonName/normalize-space(hr:FamilyName) = following::node()/hr:PersonName/normalize-space(hr:FamilyName)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FamilyName'e ait işlem yapılmalıdır. Farklı iki hr:FamilyName(<xsl:text />
            <xsl:value-of select="hr:PersonName/hr:FamilyName" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:PersonName/hr:FamilyName" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(hr:AccountConfiguration) or not(hr:AccountConfiguration/hr:UserOptionCode) or not(following-sibling::hr:UserAccount) or  hr:AccountConfiguration/normalize-space(hr:UserOptionCode) = following::node()/hr:AccountConfiguration/normalize-space(hr:UserOptionCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(hr:AccountConfiguration) or not(hr:AccountConfiguration/hr:UserOptionCode) or not(following-sibling::hr:UserAccount) or hr:AccountConfiguration/normalize-space(hr:UserOptionCode) = following::node()/hr:AccountConfiguration/normalize-space(hr:UserOptionCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserOptionCode'e ait işlem yapılmalıdır. Farklı iki hr:UserOptionCode(<xsl:text />
            <xsl:value-of select="hr:AccountConfiguration/hr:UserOptionCode" />
            <xsl:text />, <xsl:text />
            <xsl:value-of select="following::node()/hr:AccountConfiguration/hr:UserOptionCode" />
            <xsl:text />) bulundu.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN despatchadvice-->


	<!--RULE -->
<xsl:template match="desp:DespatchAdvice" mode="M39" priority="1012">
    <svrl:fired-rule context="desp:DespatchAdvice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($DespatchAdviceTypeCodeList, concat(',',cbc:DespatchAdviceTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($DespatchAdviceTypeCodeList, concat(',',cbc:DespatchAdviceTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:DespatchAdviceTypeCode elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:DespatchAdviceTypeCode" />
            <xsl:text />'. Geçerli cbc:DespatchAdviceTypeCode değerleri için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:DespatchAdviceTypeCode = 'MATBUDAN') or (count(cac:AdditionalDocumentReference[string-length(normalize-space(string(cbc:ID))) > 0  and string-length(normalize-space(string(cbc:IssueDate))) > 0 ]) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:DespatchAdviceTypeCode = 'MATBUDAN') or (count(cac:AdditionalDocumentReference[string-length(normalize-space(string(cbc:ID))) > 0 and string-length(normalize-space(string(cbc:IssueDate))) > 0 ]) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>DespatchAdviceTypeCode değeri 'MATBUDAN' iken  cbc:ID ve cbc:IssueDate alanları dolu olan en az bir tane cac:AdditionalDocumentReference alanı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(cbc:ID,'^[A-Z0-9]{3}20[0-9]{2}[0-9]{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(cbc:ID,'^[A-Z0-9]{3}20[0-9]{2}[0-9]{9}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı 'ABC2009123456789' formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:CustomizationID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:CustomizationID" />
            <xsl:text />' cbc:CustomizationID elemanı değeri 'TR1.2' veya 'TR1.2.1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($type = 'efatura' or $type = 'goruntuleme' or $type = '' or not($type)) or contains($ProfileIDTypeDespatchAdvice, concat(',',cbc:ProfileID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($type = 'efatura' or $type = 'goruntuleme' or $type = '' or not($type)) or contains($ProfileIDTypeDespatchAdvice, concat(',',cbc:ProfileID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ProfileID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ProfileID" />
            <xsl:text />'. Geçerli cbc:ProfileID değerleri için ProfileIDTypeDespatchAdvice listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ActualDespatchDate elemanı geçerli ve boş olmayan bir değer içermelidir.'<xsl:text />
            <xsl:value-of select="cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate,'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate,'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ActualDespatchDate değeri : '<xsl:text />
            <xsl:value-of select="cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate" />
            <xsl:text />'. cbc:ActualDespatchDate elamanı YYYY-MM-DD formatında geçerli bir tarih içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ActualDespatchTime elemanı geçerli ve boş olmayan bir değer içermelidir.'<xsl:text />
            <xsl:value-of select="cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:CitySubdivisionName))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:CitySubdivisionName))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>DespatchAdvice boş değer içermeyen cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:CitySubdivisionName elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:CityName))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:CityName))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>DespatchAdvice boş değer içermeyen cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:CityName elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cac:Country/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cac:Country/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>DespatchAdvice boş değer içermeyen cac:Shipment/cac:Delivery/cac:DeliveryAddress/cac:Country/cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:PostalZone,'^((0[1-9])|([1-7][0-9])|(8[0-1]))[0-9]{3}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:PostalZone,'^((0[1-9])|([1-7][0-9])|(8[0-1]))[0-9]{3}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Hatalı Posta Kodu :'<xsl:text />
            <xsl:value-of select="cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:PostalZone" />
            <xsl:text />' DespatchAdvice boş değer içermeyen geçerli bir cac:Shipment/cac:Delivery/cac:DeliveryAddress/cbc:PostalZone elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) = 0 and count(cac:Shipment/cac:Delivery/cac:CarrierParty) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) = 0 and count(cac:Shipment/cac:Delivery/cac:CarrierParty) = 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> DespatchAdvice  cac:Shipment/cac:ShipmentStage/cac:DriverPerson veya cac:Shipment/cac:Delivery/cac:CarrierParty alanlarından en az birini içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) or string-length(normalize-space(string(cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:FirstName))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) or string-length(normalize-space(string(cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:FirstName))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:FirstName alanı dolu olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) or string-length(normalize-space(string(cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:FamilyName))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) or string-length(normalize-space(string(cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:FamilyName))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:FamilyName alanı dolu olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) or string-length(normalize-space(string(cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:NationalityID))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Shipment/cac:ShipmentStage/cac:DriverPerson) or string-length(normalize-space(string(cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:NationalityID))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Shipment/cac:ShipmentStage/cac:DriverPerson/cbc:NationalityID alanı dolu olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ProfileID='HKSIRSALIYE') or (count(cac:DespatchLine/cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='KUNYENO' and string-length(normalize-space(string(text()))) = 19 ]) = count(cac:DespatchLine))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ProfileID='HKSIRSALIYE') or (count(cac:DespatchLine/cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='KUNYENO' and string-length(normalize-space(string(text()))) = 19 ]) = count(cac:DespatchLine))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProfileID='HKSIRSALIYE' iken, her cac:DespatchLine elemanı 19 karakterli 'KUNYENO' içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cbc:UUID" mode="M39" priority="1011">
    <svrl:fired-rule context="desp:DespatchAdvice/cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı UUID formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DespatchLine" mode="M39" priority="1010">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DespatchLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cbc:DeliveredQuantity))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cbc:DeliveredQuantity))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:DespatchLine elemanı geçerli ve boş değer içermeyen cbc:DeliveredQuantity elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cbc:DeliveredQuantity/@unitCode))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cbc:DeliveredQuantity/@unitCode))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:DeliveredQuantity elemanı dolu ve geçerli değer içeren unitCode niteliğine sahip olmalıdır</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Item/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Item/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Item elemanı boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cbc:ID))) != 0 and string(number(cbc:ID)) != 'NaN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cbc:ID))) != 0 and string(number(cbc:ID)) != 'NaN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı dolu ve gerçek sayı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../cbc:ProfileID = 'IDISIRSALIYE') or count(cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='ETIKETNO' and string-length(.) = 9 and translate(substring(., 1, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '') = '' and translate(substring(., 3), '0123456789', '') = '']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../cbc:ProfileID = 'IDISIRSALIYE') or count(cac:Item/cac:AdditionalItemIdentification/cbc:ID[@schemeID='ETIKETNO' and string-length(.) = 9 and translate(substring(., 1, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '') = '' and translate(substring(., 3), '0123456789', '') = '']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>İlk iki hanesi karakter ve sonraki 7 hanesi rakam olan 9 karakterli en az bir Etiket Numarası bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" mode="M39" priority="1009">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile belgeyi düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı gönderen kullanıcı(<xsl:text />
            <xsl:value-of select="$senderId" />
            <xsl:text />) ile belgeyi düzenleyen kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" mode="M39" priority="1008">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile belgeyi alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Zarfı alan kullanıcı(<xsl:text />
            <xsl:value-of select="$receiverId" />
            <xsl:text />) ile belgeyi alan kullanıcı(<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) aynı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" mode="M39" priority="1007">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:Shipment/cac:Delivery/cac:CarrierParty/cac:PartyIdentification" mode="M39" priority="1006">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:Shipment/cac:Delivery/cac:CarrierParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:Shipment/cac:Delivery/cac:CarrierParty/cac:PartyIdentification/cbc:ID" mode="M39" priority="1005">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:Shipment/cac:Delivery/cac:CarrierParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:Shipment/cac:ShipmentStage/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID" mode="M39" priority="1004">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:Shipment/cac:ShipmentStage/cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($LicensePlateIDSchemeIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($LicensePlateIDSchemeIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M39" priority="1003">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party" mode="M39" priority="1002">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//desp:DespatchAdvice/cbc:ProfileID = 'IDISIRSALIYE') or count(cac:PartyIdentification/cbc:ID[@schemeID='SEVKIYATNO' and starts-with(., 'SE-') and string-length(.) = 10 and translate(substring(., 4), '0123456789', '') = '']) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//desp:DespatchAdvice/cbc:ProfileID = 'IDISIRSALIYE') or count(cac:PartyIdentification/cbc:ID[@schemeID='SEVKIYATNO' and starts-with(., 'SE-') and string-length(.) = 10 and translate(substring(., 4), '0123456789', '') = '']) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Sevkiyat Numarası değeri SE-0000000 formatında girilmelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M39" priority="1001">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party" mode="M39" priority="1000">
    <svrl:fired-rule context="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN receiptadvice-->


	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice" mode="M40" priority="1009">
    <svrl:fired-rule context="recp:ReceiptAdvice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($ReceiptAdviceTypeCodeList, concat(',',cbc:ReceiptAdviceTypeCode,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($ReceiptAdviceTypeCodeList, concat(',',cbc:ReceiptAdviceTypeCode,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ReceiptAdviceTypeCode elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:ReceiptAdviceTypeCode" />
            <xsl:text />'. Geçerli cbc:ReceiptAdviceTypeCode değerleri için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cbc:ID))) = 16" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cbc:ID))) = 16">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı 16 haneli olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:CustomizationID elemanı değeri : '<xsl:text />
            <xsl:value-of select="cbc:CustomizationID" />
            <xsl:text />' cbc:CustomizationID elemanı değeri 'TR1.2' veya 'TR1.2.1' olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cbc:UUID" mode="M40" priority="1008">
    <svrl:fired-rule context="recp:ReceiptAdvice/cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı değeri. <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> elemanı UUID formatında olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:ReceiptLine" mode="M40" priority="1007">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:ReceiptLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cac:Item/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cac:Item/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Item elemanı boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(string(cbc:ID))) != 0 and string(number(cbc:ID)) != 'NaN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(string(cbc:ID))) != 0 and string(number(cbc:ID)) != 'NaN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı dolu ve gerçek sayı olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" mode="M40" priority="1006">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" mode="M40" priority="1005">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" mode="M40" priority="1004">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M40" priority="1003">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party" mode="M40" priority="1002">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M40" priority="1001">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Geçersiz schemeID niteliği : '<xsl:text />
            <xsl:value-of select="@schemeID" />
            <xsl:text />'. Geçerli değerler için kod listesine bakınız.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party" mode="M40" priority="1000">
    <svrl:fired-rule context="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0 and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
