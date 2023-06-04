<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:setu="http://ns.hr-xml.org/2007-04-15" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="nl.setu.2007.businessrules.timecard" title="Business rules voor het controleren van een timecard bericht (SETU Standard for Reporting Time &amp; Expenses versie 1.4).">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="setu" uri="http://ns.hr-xml.org/2007-04-15" />
      <svrl:ns-prefix-in-attribute-values prefix="xsd" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M8" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M37" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M38" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M39" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Business rules voor het controleren van een timecard bericht (SETU Standard for Reporting Time &amp; Expenses versie 1.4).</svrl:text>
  <xsl:param name="RateOrAmount" select="',hourly,hourlysplit,4weekly,monthly,weekly,hourlyconsolidated,'" />
  <xsl:param name="ActionCode" select="',Add,Change,Void,Unchanged,'" />
  <xsl:param name="IdOwner" select="',StaffingCustomer,StaffingCompany,KvK,OIN,BTW,Fi,'" />
  <xsl:param name="SETU_CL_HourTypes" select="',Additional wage dispensation,Adoption leave,Child-birth sick time,Internship,Overtime wage dispensation,Pregnancy sick time,Regular wage dispensation,Shift wage dispensation,Transition allowance,Vacation additional,Additionalplus,Regular canceled,Shift canceled,Shiftplus canceled,Additional canceled,Additionalplus canceled,Regular complemented,Additional complemented,Shift complemented,Overtime complemented,Overtime canceled,Overtimeplus canceled,Regular,Overtime,Overtimeplus,Shift,Shiftplus,Attendance,Travel,Additional,Internal,Time for time hour build-up,Time for time overtime hour build-up,Special Leave,Short leave,Holiday,Unpaid leave,Training,Vacation,Reduction of working hours,Sick time,Work underload,Care Leave,WTR (work time reduction),Compensation leave,Funeral,Maternity Leave,Withdrawal time for time hours,Contract hours,Standby,'" />
  <xsl:param name="SETU_CL_ExpenseAllowanceTypes" select="',100,100B,100O,101,101B,101O,102,102B,102O,103,103B,103O,104,104B,104O,105,105B,105O,106,106B,106O,107,107B,107O,201,201B,201O,202,202B,202O,203,203B,203O,300,300B,300O,301,301B,301O,302,302B,302O,303,303B,303O,304,304B,304O,400,400B,400O,501,501B,501O,502,502B,502O,503,503B,503O,600,600B,600O,601,601B,601O,602,602B,602O,603,603B,603O,604,604B,604O,701,701B,701O,702,702B,702O,703,703B,703O,801,801B,801O,802,802B,802O,803,803B,803O,900,900B,900O,901,901B,901O,903,903B,903O,904,904B,904O,905,905B,905O,906,906B,906O,907,907B,907O,908,908B,908O,909,909B,909O,910,910B,910O,911,911B,911O,912,912B,912O,913,913B,913O,914,914B,914O,'" />

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Id.1-->
<xsl:template match="/setu:TimeCard" mode="M8" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard" id="nl.setu.2007.businessrules.timecard.businessrule.Id.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:Id) = 1) and (normalize-space(setu:Id) != '') and         (count(setu:Id/@idOwner) = 1) and (normalize-space(setu:Id/@idOwner) != '') and         (count(setu:Id/setu:IdValue) = 1) and (normalize-space(setu:Id/setu:IdValue) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:Id) = 1) and (normalize-space(setu:Id) != '') and (count(setu:Id/@idOwner) = 1) and (normalize-space(setu:Id/@idOwner) != '') and (count(setu:Id/setu:IdValue) = 1) and (normalize-space(setu:Id/setu:IdValue) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                A timecard should have exactly one Id element, with exactly one idOwner attribuut and one IdValue element.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Id.2-->
<xsl:template match="/setu:TimeCard/setu:Id" mode="M9" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.Id.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany')  " />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attribute of Id should have the value 'StaffingCustomer'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Person.2-->
<xsl:template match="/setu:TimeCard/setu:ReportedResource/setu:Person/setu:Id" mode="M10" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedResource/setu:Person/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.Person.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and        ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Person/Id element should have exactly one idOwner attribute, with the value 'StaffingCustomer' or 'StaffingCompany'.
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Person.3-->
<xsl:template match="/setu:TimeCard/setu:ReportedResource/setu:Person/setu:Id" mode="M11" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedResource/setu:Person/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.Person.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Person/Id element should contain exactly one IdValue element. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.PersonName.1-->
<xsl:template match="//setu:PersonName" mode="M12" priority="1000">
    <svrl:fired-rule context="//setu:PersonName" id="nl.setu.2007.businessrules.timecard.businessrule.PersonName.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:FormattedName)=1) and (normalize-space(setu:FormattedName)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:FormattedName)=1) and (normalize-space(setu:FormattedName)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The PersonName element should contain exactly one non-empty FormattedName element. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.ReportedTime.1-->
<xsl:template match="/setu:TimeCard" mode="M13" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard" id="nl.setu.2007.businessrules.timecard.businessrule.ReportedTime.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:ReportedTime) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:ReportedTime) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The ReportedTime element must exist exactly once. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.ReportedTime.2-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime" mode="M14" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime" id="nl.setu.2007.businessrules.timecard.businessrule.ReportedTime.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(@status) = 'rejected') or (normalize-space(@status) = 'corrected') or (normalize-space(@status) = '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(@status) = 'rejected') or (normalize-space(@status) = 'corrected') or (normalize-space(@status) = '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The status of a ReportedTime element must be empty or contain 'rejected'. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.ActionCode.1-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval" mode="M15" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval" id="nl.setu.2007.businessrules.timecard.businessrule.ActionCode.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(@actionCode) = 1) and contains($ActionCode, concat(',', @actionCode, ','))) or not(count(@actionCode) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(@actionCode) = 1) and contains($ActionCode, concat(',', @actionCode, ','))) or not(count(@actionCode) = 1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute actionCode of TimeInterval must contain one of the following values: <xsl:text />
            <xsl:value-of select="$ActionCode" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@actionCode" />
            <xsl:text />' is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.TimeInterval.1-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:Id" mode="M16" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.TimeInterval.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The TimeInterval/Id element should have exactly one idOwner attribute.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.TimeInterval.2-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:Id" mode="M17" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.TimeInterval.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:IdValue) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:IdValue) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The TimeInterval/Id element may have at most one IdValue element.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.EndDateTime.3-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval" mode="M18" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval" id="nl.setu.2007.businessrules.timecard.businessrule.EndDateTime.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:Duration)=0) and (count(setu:EndDateTime) = 1)) or not(count(setu:Duration)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:Duration)=0) and (count(setu:EndDateTime) = 1)) or not(count(setu:Duration)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                For a TimeInterval the EndDateTime element must be present if no Duration element is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.EndDateTime.4-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval" mode="M19" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval" id="nl.setu.2007.businessrules.timecard.businessrule.EndDateTime.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:EndDateTime)=0) and (count(setu:Duration) = 1)) or not(count(setu:EndDateTime)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:EndDateTime)=0) and (count(setu:Duration) = 1)) or not(count(setu:EndDateTime)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                For a TimeInterval the Duration element must be present if no EndDateTime element is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.RateOrAmount.1-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:RateOrAmount" mode="M20" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:RateOrAmount" id="nl.setu.2007.businessrules.timecard.businessrule.RateOrAmount.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($RateOrAmount, concat(',', @type, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($RateOrAmount, concat(',', @type, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute type of the element RateOrAmount must contain one of the following values: <xsl:text />
            <xsl:value-of select="$RateOrAmount" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@type" />
            <xsl:text />' is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.RateOrAmount.2-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:RateOrAmount" mode="M21" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:TimeInterval/setu:RateOrAmount" id="nl.setu.2007.businessrules.timecard.businessrule.RateOrAmount.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@multiplier)=1) and ((@multiplier) >= 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@multiplier)=1) and ((@multiplier) >= 100)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute multiplier of the element RateOrAmount must be present exactly once and contain a value greater of equal to 100.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.ActionCode.2-->
<xsl:template match="//setu:Allowance" mode="M22" priority="1000">
    <svrl:fired-rule context="//setu:Allowance" id="nl.setu.2007.businessrules.timecard.businessrule.ActionCode.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(@actionCode)=1) and contains($ActionCode, concat(',', @actionCode, ','))) or not(count(@actionCode)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(@actionCode)=1) and contains($ActionCode, concat(',', @actionCode, ','))) or not(count(@actionCode)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute actionCode of Allowance must contain one of the following values: <xsl:text />
            <xsl:value-of select="$ActionCode" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@actionCode" />
            <xsl:text />' is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Allowance.1-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:Allowance/setu:Id" mode="M23" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:Allowance/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.Allowance.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and ((normalize-space(@idOwner)='StaffingCustomer') or (normalize-space(@idOwner)='StaffingCompany'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner)='StaffingCustomer') or (normalize-space(@idOwner)='StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Allowance/Id element should have exactly one idOwner attribute.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Allowance.2-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:Allowance/setu:Id" mode="M24" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:Allowance/setu:Id" id="nl.setu.2007.businessrules.timecard.businessrule.Allowance.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Allowance/Id element should have exactly one IdValue element.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Allowance.3-->
<xsl:template match="/setu:TimeCard/setu:ReportedTime/setu:Allowance/setu:Id/setu:IdValue" mode="M25" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:ReportedTime/setu:Allowance/setu:Id/setu:IdValue" id="nl.setu.2007.businessrules.timecard.businessrule.Allowance.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@name)=1) and ((normalize-space(@name)='expense') or (normalize-space(@name)='allowance'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@name)=1) and ((normalize-space(@name)='expense') or (normalize-space(@name)='allowance'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The name attribute of the Allowance/Id/IdValue element should exist exactly once and must have the value 'expense' or 'allowance'.
                Currently '<xsl:text />
            <xsl:value-of select="@name" />
            <xsl:text />' is provided.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M25" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Amount.1-->
<xsl:template match="//Allowance" mode="M26" priority="1000">
    <svrl:fired-rule context="//Allowance" id="nl.setu.2007.businessrules.timecard.businessrule.Amount.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:Amount) = 1) and (normalize-space(setu:Amount) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:Amount) = 1) and (normalize-space(setu:Amount) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                An Allowance must contain exactly one Amount element.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.CustomerReportingRequirements.1-->
<xsl:template match="//setu:CustomerReportingRequirements" mode="M27" priority="1000">
    <svrl:fired-rule context="//setu:CustomerReportingRequirements" id="nl.setu.2007.businessrules.timecard.businessrule.CustomerReportingRequirements.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:SupervisorName)=0) and (count(setu:LocationCode)=0) and (count(setu:LocationName)=0) and (count(setu:CustomerJobCode)=0) and (count(setu:CustomerJobDescription)=0) and (count(setu:AccountCode)=0) and (count(setu:ExternalOrderNumber)=0) and (count(setu:ExternalReqNumber)=0) and (count(setu:Entity)=0) and (count(setu:SubEntity)=0) and (count(setu:Shift)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:SupervisorName)=0) and (count(setu:LocationCode)=0) and (count(setu:LocationName)=0) and (count(setu:CustomerJobCode)=0) and (count(setu:CustomerJobDescription)=0) and (count(setu:AccountCode)=0) and (count(setu:ExternalOrderNumber)=0) and (count(setu:ExternalReqNumber)=0) and (count(setu:Entity)=0) and (count(setu:SubEntity)=0) and (count(setu:Shift)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element CustomerReportingRequirements contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.CustomerReportingRequirements.2-->
<xsl:template match="/setu:Timecard/setu:ReportedTime/setu:TimeInterval/setu:AdditionalData/setu:StaffingAdditionalData/setu:CustomerReportingRequirements//setu:AdditionalRequirement" mode="M28" priority="1000">
    <svrl:fired-rule context="/setu:Timecard/setu:ReportedTime/setu:TimeInterval/setu:AdditionalData/setu:StaffingAdditionalData/setu:CustomerReportingRequirements//setu:AdditionalRequirement" id="nl.setu.2007.businessrules.timecard.businessrule.CustomerReportingRequirements.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(@requirementTitle)=1 and normalize-space(@requirementTitle)!=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(@requirementTitle)=1 and normalize-space(@requirementTitle)!=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                For each AdditionalRequirement the attribute requirementTitle must exist exactly once and may not be empty .
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierId.1-->
<xsl:template match="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M29" priority="1000">
    <svrl:fired-rule context="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingSupplierId) = count(setu:StaffingSupplierId[not(@idOwner = preceding-sibling::setu:StaffingSupplierId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingSupplierId) = count(setu:StaffingSupplierId[not(@idOwner = preceding-sibling::setu:StaffingSupplierId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingSupplierId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierId.2-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M30" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingSupplierId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierId.3-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M31" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingSupplierId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerId.1-->
<xsl:template match="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M32" priority="1000">
    <svrl:fired-rule context="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingCustomerId) = count(setu:StaffingCustomerId[not(@idOwner = preceding-sibling::setu:StaffingCustomerId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingCustomerId) = count(setu:StaffingCustomerId[not(@idOwner = preceding-sibling::setu:StaffingCustomerId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingCustomerId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerId.2-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M33" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingCustomerId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerId.3-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M34" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingCustomerId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.AssignmentId.1-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation/setu:AssignmentId" mode="M35" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation/setu:AssignmentId" id="nl.setu.2007.businessrules.timecard.businessrule.AssignmentId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and (normalize-space(@idOwner) = 'StaffingCompany')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and (normalize-space(@idOwner) = 'StaffingCompany')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element AssignmentId must exist exactly once and should have the valid value 'StaffingCompany'.
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.AssignmentId.2-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation/setu:AssignmentId" mode="M36" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation/setu:AssignmentId" id="nl.setu.2007.businessrules.timecard.businessrule.AssignmentId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element AssignmentId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierOrgUnitId.1-->
<xsl:template match="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M37" priority="1000">
    <svrl:fired-rule context="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierOrgUnitId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingSupplierOrgUnitId) = count(setu:StaffingSupplierOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingSupplierOrgUnitId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingSupplierOrgUnitId) = count(setu:StaffingSupplierOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingSupplierOrgUnitId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingSupplierOrgUnitId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierOrgUnitId.2-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M38" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierOrgUnitId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingSupplierOrgUnitId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierOrgUnitId.3-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M39" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingSupplierOrgUnitId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingSupplierOrgUnitId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerOrgUnitId.1-->
<xsl:template match="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M40" priority="1000">
    <svrl:fired-rule context="//setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerOrgUnitId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingCustomerOrgUnitId) = count(setu:StaffingCustomerOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingCustomerOrgUnitId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingCustomerOrgUnitId) = count(setu:StaffingCustomerOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingCustomerOrgUnitId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingCustomerOrgUnitId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerOrgUnitId.2-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M41" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerOrgUnitId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingCustomerOrgUnitId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerOrgUnitId.3-->
<xsl:template match="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M42" priority="1000">
    <svrl:fired-rule context="/setu:TimeCard/setu:AddtionalData/setu:StaffingAdditionalData/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.2007.businessrules.timecard.businessrule.StaffingCustomerOrgUnitId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingCustomerOrgUnitId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timecard.businessrule.Duration.1-->
<xsl:template match="//setu:Duration" mode="M43" priority="1000">
    <svrl:fired-rule context="//setu:Duration" id="nl.setu.2007.businessrules.timecard.businessrule.Duration.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test=". >= 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                A negative Duration is provided: '<xsl:text />
            <xsl:value-of select="current()" />
            <xsl:text />', for corrections use the correction message instead of negative hours.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2007.businessrules.timevard.businessrule.AdditionalData.1-->
<xsl:template match="//setu:AdditionalData" mode="M44" priority="1000">
    <svrl:fired-rule context="//setu:AdditionalData" id="nl.setu.2007.businessrules.timevard.businessrule.AdditionalData.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingAdditionalData) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingAdditionalData) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                Each AdditionalData element must have exactly one StaffingAdditionalData element as a child.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2022.businessrules.invoice.businessrule.TimeInterval.1-->
<xsl:template match="//setu:ReportedTime/setu:TimeInterval" mode="M45" priority="1000">
    <svrl:fired-rule context="//setu:ReportedTime/setu:TimeInterval" id="nl.setu.2022.businessrules.invoice.businessrule.TimeInterval.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($SETU_CL_HourTypes, concat(',', @type, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($SETU_CL_HourTypes, concat(',', @type, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
            Value '
            <xsl:text />
            <xsl:value-of select="@type" />
            <xsl:text />
            ' is not part of codelist Hour types.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2022.businessrules.invoice.businessrule.Allowance.1-->
<xsl:template match="//setu:ReportedTime/setu:Allowance" mode="M46" priority="1000">
    <svrl:fired-rule context="//setu:ReportedTime/setu:Allowance" id="nl.setu.2022.businessrules.invoice.businessrule.Allowance.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($SETU_CL_ExpenseAllowanceTypes, concat(',', @type, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($SETU_CL_ExpenseAllowanceTypes, concat(',', @type, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
            Value '
            <xsl:text />
            <xsl:value-of select="@type" />
            <xsl:text />
            ' is not part of codelist Expense and Allowance types.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
