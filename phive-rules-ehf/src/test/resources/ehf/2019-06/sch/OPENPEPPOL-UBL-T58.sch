<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" queryBinding="xslt2">
  <title>OPENPEPPOL  T58 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <phase id="OPENPEPPOLT58_phase">
    <active pattern="UBL-T58"/>
  </phase>
  <phase id="codelist_phase">
    <active pattern="CodesT58"/>
  </phase>
  
  
  <!--Suppressed abstract pattern T58 was here-->
  
  
  <!--Start pattern based on abstract T58--><pattern id="UBL-T58">
  <rule context="//cbc:EndpointID">
    <assert test="@schemeID" flag="fatal" id="EUGEN-T58-R001">[EUGEN-T58-R001]-An endpoint identifier MUST have a scheme identifier attribute</assert>
  </rule>
  <rule context="//cac:PartyIdentification/cbc:ID">
    <assert test="@schemeID" flag="fatal" id="EUGEN-T58-R002">[EUGEN-T58-R002]-A party identifier MUST have a scheme identifier attribute</assert>
  </rule>
  <rule context="//cbc:ResponseCode">
    <assert test="@listID = 'UNCL4343'" flag="fatal" id="EUGEN-T58-R003">[EUGEN-T58-R003]-A response code MUST have a list identifier attribute “UNCL4343”</assert>
  </rule>
  <rule context="/ubl:ApplicationResponse">
    <assert test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)" flag="warning" id="EUGEN-T58-R004">[EUGEN-T58-R004]- A catalogue response should not contain empty elements</assert>
  </rule>
</pattern>
  
  
  <pattern id="CodesT58">



<rule context="cbc:EndpointID//@schemeID" flag="fatal">
  <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal" id="OP-T58-R001">[OP-T58-R001]-An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
</rule>

<rule context="cac:PartyIdentification/cbc:ID//@schemeID" flag="fatal">
  <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal" id="OP-T58-R002">[OP-T58-R002]-A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
</rule>

<rule context="cbc:ResponseCode" flag="fatal">
  <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AP RE ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal" id="OP-T58-R003">[OP-T58-R003]-A Response code MUST be from the UN CEFACT 4343 code list PEPPOL subset</assert>
</rule>
  
<rule context="cbc:*/@unitCode">
	<assert test="( ( not(contains(normalize-space(.),' ')) and not(contains( ' 5 6 8 16 17 18 19 26 29 30 31 32 36 43 44 45 46 47 48 53 54 62 63 69 71 72 73 90 92 93 94 95 96 97 98 1A 1B 1C 1D 1E 1F 1G 1H 1J 1K 1L 1M 1X 2V 2W 3E 3G 3H 3I 4A 4B 4E 5C 5F 5G 5H 5I 5K 5P 5Q AJ AM AP AR AV AW B0 B2 B5 B6 B9 BD BE BG BH BJ BK BL BO BR BT BW BX BZ C1 C2 C4 C5 C6 C77 C98 CA CH CJ CK CL CO CQ CR CS CT CU CV CY CZ D14 D28 D40 D64 D66 D67 D7 D79 D8 D90 D92 D96 D97 D98 D99 DC DE DI DQ DR DRM DS DY E2 E3 E5 EC EP EV F1 F9 FB FD FE FG FM G7 GC GD GH GK GN GW GY GZ H1 H2 HD HE HF HI HK HL HO HS HT HY IC IF II IL IM IP IT JB JG JO JR KD KF KG KS KTM L61 L62 LC LE LI LJ LX M0 MA MF MK MQ MT MV N2 NB NBB NC ND NE NG NH NI NJ NN NPL NRL NV NY OP P0 P3 P4 P6 P7 P8 P9 PA PB PE PF PG PK PL PM PN PU PV PW PY PZ QD QH QK R4 RA RD RG RK RL RN RO RS RU S5 S6 S7 S8 SA SD SE SK SL SN SO SP SS SST ST SV T1 T4 T5 T6 T7 T8 TA TC TD TE TF TJ TK TL TN TQ TR TS TSD TSH TT TU TV TW TY UD UE UF UH UM VI VQ VS W4 WH WI WR YL YT Z1 Z2 Z3 Z4 Z5 Z6 Z8 ',concat(' ',normalize-space(.),' ') ) )) )" flag="warning" id="OP-T58-R004">[OP-T58-R004]-The unit code used has been marked as deprecated and will be removed in a future release.</assert>

	<assert test="( ( not(contains(normalize-space(.),' ')) and not(contains( ' 43 2W 4A AM AV BD BE BG BJ BK BL BO BR BT BX CA CH CJ CL CO CQ CR CS CT CU CV CY D97 DR EV JG JR KG MT NRL PA PF PG PK PL PU RD RG RL RO SA SL SO ST SV TK TN TU TY VI VQ Z2 Z3 Z4 ',concat(' ',normalize-space(.),' ') ) ) ) )" flag="warning" id="OP-T58-R005">[OP-T58-R005]-The unit code used has been marked for change in a future release so that will be prefixed with an X. As example code AE will become code XAE.</assert>
</rule>
  

</pattern>
</schema>