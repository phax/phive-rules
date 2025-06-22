<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" xmlns:xsl="https://www.w3.org/1999/XSL/Transform" schemaVersion="iso" queryBinding="xslt2">
	<title>Controlli NSO per il tracciato PEPPOL Order transaction 3.0</title>
	<!-- DEFINIZIONE NAMESPACES -->
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" prefix="ubl"/>
	<ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
	<ns uri="utils" prefix="u"/>
	<!-- DEFINIZIONE FUNZIONI -->
	<!-- Funzione deternina il sottotipo di documento:
	
		 "Accepted"  Conferma 		CONF 
	     "Cancelled" Cancella  		CANC 
		 "Revised"   Sostituzione	SOST
		 "Connected" Collegamento   CONN
		 "Invoice" Fattura          INVO
		 altrimenti  Iniziale		INIZ
	-->
	<function name="u:tipoOrdine" as="xs:string" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="tipo" select="if (u:countDelitited($arg) != 4) then 'NSO2' else u:getPartTokenizeID($arg,4)"/>
		<sequence select="if ($tipo eq 'Cancelled') then 'CANC' else
							(if ($tipo eq 'Revised') then 'SOST' else 
								(if ($tipo eq 'Accepted') then 'CONF' else 
									(if ($tipo eq 'Connected') then 'CONN' else
										(if ($tipo eq 'Invoice') then 'INVO' else
											(if ($tipo eq 'NSO2') then 'ERRORE_NSO40' else 'ERRORE'								
											)
										)	
									)
								)
							)"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:getPartTokenizeID" as="xs:string">
		<param name="reference" as="xs:string"/>
		<param name="arg" as="xs:integer"/>
		<variable name="listToken" select="tokenize($reference, '#')"/>
		<sequence select="$listToken[$arg]"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:countDelitited" as="xs:integer">
		<param name="reference" as="xs:string"/>
		<variable name="stringList" select="tokenize($reference, '#')"/>
		<sequence select="count($stringList)"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:is" as="xs:boolean">
		<param name="arg" as="xs:boolean"/>
		<sequence select="xs:boolean($arg)"/>
	</function>
	<function name="u:validationDate" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="string(normalize-space($arg)) castable as xs:date"/>
	</function>
	<function name="u:verificaCIG" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="argNor" select="u:normalizaCIG($arg)"/>
		<sequence select="
				if (u:isCIG($argNor)) then
				(
					if ( (string-length($argNor) = 4) and ( u:isEsclusioneValida($argNor) ) ) then true()
					else if ( string-length($argNor) = 10) then
						(
							if (contains('XYZ', substring($argNor,1,1)) and ( u:isSmartCIGValido($argNor) ) ) then true()
							else if (not (contains('XYZ', substring($argNor,1,1))) and ( u:isCIGValido($argNor) ) ) then true()
							else false()
						)
					else false()
				)
				else false()
				"/>
	</function>
	<function name="u:isEsclusioneValida" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="( contains( 'ES01 ES02 ES03 ES04 ES05 ES06 ES07 ES08 ES09 ES10 
								       ES11 ES12 ES13 ES14 ES15 ES16 ES17 ES18 ES19 ES20 
									   ES21 ES22 ES23 ES24 ES25 ES26 ES27', $arg ) 
						  )"/>
	</function>
	<function name="u:isCIGValido" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<!-- Controllo applicativo -->
		<sequence select="true()"/>
	</function>
	<function name="u:isSmartCIGValido" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<!-- Controllo applicativo -->
		<sequence select="true()"/>
	</function>
	<function name="u:isCIG" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="stringList" select="tokenize($arg, ':')"/>
		<sequence select="if ((count($stringList) -1) > 0) then false() else true()"/>
	</function>
	<function name="u:normalizaCIG" as="xs:string" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="if ( matches (substring($arg,1,4), 'CIG:') ) then substring($arg,5,10) else $arg"/>
	</function>
	<function name="u:checkCIGLinea" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="item()*"/>
		<variable name="long" select="string-join(u:checkCIGLineaAlg($arg) ,'')"/>
		<variable name="short" select="string-join(distinct-values(u:checkCIGLineaAlg($arg)),'')"/>
		<value-of select="if ( xs:string($long) eq xs:string($short) ) then true() else false()"/>
	</function>
	<function name="u:divisoNumeroZeri" as="xs:string" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<value-of select="xs:string(xs:integer($arg) div 4)"/>
	</function>
	<function name="u:checkCIGLineaAlg" as="xs:string*" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="item()*"/>
		<for-each select="$arg">
			<variable name="countRiga" select="position()"/>
			<for-each select="./cac:Item/cac:ItemSpecificationDocumentReference">
				<value-of select="
					if (not( u:controlliUlterioriCodici(./cbc:ID) )) then (if  (u:isCIG(u:normalizaCIG(./cbc:ID))) then (
							format-number($countRiga, '0000')
						) else '') else ''
					
									
				"/>
			</for-each>
		</for-each>
	</function>
	<function name="u:checkPIVA" as="xs:integer" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
				if (not($arg castable as xsd:integer)) 
					then 1
					else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
	</function>
	<function name="u:addPIVA" as="xs:integer" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string"/>
		<param name="pari" as="xs:integer"/>
		<variable name="tappo" select="if (not($arg castable as xsd:integer)) then 0 else 1"/>
		<variable name="mapper" select="if ($tappo = 0) then 0 else 
																		( if ($pari = 1) 
																			then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) ) 
																			else ( xs:integer(substring($arg,1,1) ) )
																		)"/>
		<sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
	</function>
	<function name="u:checkPIVAseIT" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string"/>
		<variable name="paese" select="substring($arg,1,2)"/>
		<variable name="codice" select="substring($arg,3)"/>
		<sequence select="

			if ( $paese = 'IT' or $paese = 'it' )
			then
			(
				if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))
				then 
				(
					true()
				)
				else
				(
					false()
				)
			)
			else
			(
				true()
			)

		"/>
	</function>
	<function name="u:controlliUlterioriCodici" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="codici" select="tokenize($arg,':')"/>
		<variable name="tipoDocumento" select="$codici[1]"/>
		<sequence select=" if ($tipoDocumento='CUP')  then ($codici[2]!='') else 
	 		                   ( if ($tipoDocumento='DDT') then ($codici[2]!='') else 
	 		                   ( if ($tipoDocumento='IMPEGNO') then ($codici[2]!='') else
	 		                   ( if ($tipoDocumento='DELIBERA') then ($codici[2]!='') else 
	 		                   ( if ($tipoDocumento='CONVENZIONE') then ($codici[2]!='') else 
	 		                   ( if ($tipoDocumento='CONTRATTO') then ($codici[2]!='') else false() ) 
	 		                    ))))      "/>
	</function>
	<function name="u:checkCF" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
			if ( (string-length($arg) = 16) or (string-length($arg) = 11) ) 		
			then 
			(
				if ((string-length($arg) = 16)) 
				then
				(
					if (u:checkCF16($arg)) 
					then
					(
						true()
					)
					else
					(
						false()
					)
				)
				else
				(
					if(($arg castable as xsd:integer)) then true() else false()
	
				)
			)
			else
			(
				false()
			)
			"/>
	</function>
	<function name="u:valueOfDigit" as="xs:integer" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="digit" as="xs:string"/>
		<param name="posit" as="xs:integer"/>
		<sequence select="
					if ( ($digit = '0') or ($digit = 'a') or ($digit = 'A'))
					then (
						if(($posit mod 2) = 0) then 0 else 1
					)
					else if ( ($digit = '1') or ($digit = 'b') or ($digit = 'B'))
					then (
						if(($posit mod 2) = 0) then 1 else 0
					)
					else if ( ($digit = '2') or ($digit = 'c') or ($digit = 'C'))
					then (
						if(($posit mod 2) = 0) then 2 else 5
					)
					else if ( ($digit = '3') or ($digit = 'd') or ($digit = 'D'))
					then (
						if(($posit mod 2) = 0) then 3 else 7
					)
					else if ( ($digit = '4') or ($digit = 'e') or ($digit = 'E'))
					then (
						if(($posit mod 2) = 0) then 4 else 9
					)
					else if ( ($digit = '5') or ($digit = 'f') or ($digit = 'F'))
					then (
						if(($posit mod 2) = 0) then 5 else 13
					)
					else if ( ($digit = '6') or ($digit = 'g') or ($digit = 'G'))
					then (
						if(($posit mod 2) = 0) then 6 else 15
					)
					else if ( ($digit = '7') or ($digit = 'h') or ($digit = 'H'))
					then (
						if(($posit mod 2) = 0) then 7 else 17
					)
					else if ( ($digit = '8') or ($digit = 'i') or ($digit = 'I'))
					then (
						if(($posit mod 2) = 0) then 8 else 19
					)
					else if ( ($digit = '9') or ($digit = 'j') or ($digit = 'J'))
					then (
						if(($posit mod 2) = 0) then 9 else 21
					)
					else if (($digit = 'k') or ($digit = 'K'))
					then (
						if(($posit mod 2) = 0) then 10 else 2
					)
					else if (($digit = 'l') or ($digit = 'L'))
					then (
						if(($posit mod 2) = 0) then 11 else 4
					)
					else if (($digit = 'm') or ($digit = 'M'))
					then (
						if(($posit mod 2) = 0) then 12 else 18
					)
					else if (($digit = 'n') or ($digit = 'N'))
					then (
						if(($posit mod 2) = 0) then 13 else 20
					)
					else if (($digit = 'o') or ($digit = 'O'))
					then (
						if(($posit mod 2) = 0) then 14 else 11
					)
					else if (($digit = 'p') or ($digit = 'P'))
					then (
						if(($posit mod 2) = 0) then 15 else 3
					)
					else if (($digit = 'q') or ($digit = 'Q'))
					then (
						if(($posit mod 2) = 0) then 16 else 6
					)
					else if (($digit = 'r') or ($digit = 'R'))
					then (
						if(($posit mod 2) = 0) then 17 else 8
					)
					else if (($digit = 's') or ($digit = 'S'))
					then (
						if(($posit mod 2) = 0) then 18 else 12
					)
					else if (($digit = 't') or ($digit = 'T'))
					then (
						if(($posit mod 2) = 0) then 19 else 14
					)
					else if (($digit = 'u') or ($digit = 'U'))
					then (
						if(($posit mod 2) = 0) then 20 else 16
					)
					else if (($digit = 'v') or ($digit = 'V'))
					then (
						if(($posit mod 2) = 0) then 21 else 10
					)
					else if (($digit = 'w') or ($digit = 'W'))
					then (
						if(($posit mod 2) = 0) then 22 else 22
					)
					else if (($digit = 'x') or ($digit = 'X'))
					then (
						if(($posit mod 2) = 0) then 23 else 25
					)
					else if (($digit = 'y') or ($digit = 'Y'))
					then (
						if(($posit mod 2) = 0) then 24 else 24
					)
					else if (($digit = 'z') or ($digit = 'Z'))
					then (
						if(($posit mod 2) = 0) then 25 else 23
					)
					else 26
					"/>
	</function>
	<function name="u:checkDigit" as="xs:string" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="digit" as="xs:integer"/>
		<param name="case" as="xs:string"/>
		<sequence select="
					if ($digit = 0)
					then (
						if($case = 'lower') then 'a' else 'A'
					)
					else if ($digit = 1)
					then (
						if($case = 'lower') then 'b' else 'B'
					)
					else if ($digit = 2)
					then (
						if($case = 'lower') then 'c' else 'C'
					)
					else if ($digit = 3)
					then (
						if($case = 'lower') then 'd' else 'D'
					)
					else if ($digit = 4)
					then (
						if($case = 'lower') then 'e' else 'E'
					)
					else if ($digit = 5)
					then (
						if($case = 'lower') then 'f' else 'F'
					)
					else if ($digit = 6)
					then (
						if($case = 'lower') then 'g' else 'G'
					)
					else if ($digit = 7)
					then (
						if($case = 'lower') then 'h' else 'H'
					)
					else if ($digit = 8)
					then (
						if($case = 'lower') then 'i' else 'I'
					)
					else if ($digit = 9)
					then (
						if($case = 'lower') then 'j' else 'J'
					)
					else if ($digit = 10)
					then (
						if($case = 'lower') then 'k' else 'K'
					)
					else if ($digit = 11)
					then (
						if($case = 'lower') then 'l' else 'L'
					)
					else if ($digit = 12)
					then (
						if($case = 'lower') then 'm' else 'M'
					)
					else if ($digit = 13)
					then (
						if($case = 'lower') then 'n' else 'N'
					)
					else if ($digit = 14)
					then (
						if($case = 'lower') then 'o' else 'O'
					)
					else if ($digit = 15)
					then (
						if($case = 'lower') then 'p' else 'P'
					)
					else if ($digit = 16)
					then (
						if($case = 'lower') then 'q' else 'Q'
					)
					else if ($digit = 17)
					then (
						if($case = 'lower') then 'r' else 'R'
					)
					else if ($digit = 18)
					then (
						if($case = 'lower') then 's' else 'S'
					)
					else if ($digit = 19)
					then (
						if($case = 'lower') then 't' else 'T'
					)
					else if ($digit = 20)
					then (
						if($case = 'lower') then 'u' else 'U'
					)
					else if ($digit = 21)
					then (
						if($case = 'lower') then 'v' else 'V'
					)
					else if ($digit = 22)
					then (
						if($case = 'lower') then 'w' else 'W'
					)
					else if ($digit = 23)
					then (
						if($case = 'lower') then 'x' else 'X'
					)
					else if ($digit = 24)
					then (
						if($case = 'lower') then 'y' else 'Y'
					)
					else if ($digit = 25)
					then (
						if($case = 'lower') then 'z' else 'Z'
					)
					else '0'
					"/>
	</function>
	<function name="u:checkCF16" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
					if(matches($arg, '^[A-Za-z]{6}[0-9LMNPQRSTUVlmnpqrstuv]{2}[ABCDEHLMPRSTabcdehlmprst]{1}[0-9LMNPQRSTUVlmnpqrstuv]{2}[A-Za-z]{1}[0-9LMNPQRSTUVlmnpqrstuv]{3}[A-Za-z]{1}$'))
					then
					(
						if(
							(
								u:checkDigit((
									u:valueOfDigit(substring($arg,1,1), 1) + u:valueOfDigit(substring($arg,2,1), 2) +
									u:valueOfDigit(substring($arg,3,1), 3) + u:valueOfDigit(substring($arg,4,1), 4) +
									u:valueOfDigit(substring($arg,5,1), 5) + u:valueOfDigit(substring($arg,6,1), 6) +
									u:valueOfDigit(substring($arg,7,1), 7) + u:valueOfDigit(substring($arg,8,1), 8) +
									u:valueOfDigit(substring($arg,9,1), 9) + u:valueOfDigit(substring($arg,10,1), 10) +
									u:valueOfDigit(substring($arg,11,1), 11) + u:valueOfDigit(substring($arg,12,1), 12) +
									u:valueOfDigit(substring($arg,13,1), 13) + u:valueOfDigit(substring($arg,14,1), 14) +
									u:valueOfDigit(substring($arg,15,1), 15)
								) mod 26, 'lower') = substring($arg,16,1)
							)
							or
							(
								u:checkDigit((
									u:valueOfDigit(substring($arg,1,1), 1) + u:valueOfDigit(substring($arg,2,1), 2) +
									u:valueOfDigit(substring($arg,3,1), 3) + u:valueOfDigit(substring($arg,4,1), 4) +
									u:valueOfDigit(substring($arg,5,1), 5) + u:valueOfDigit(substring($arg,6,1), 6) +
									u:valueOfDigit(substring($arg,7,1), 7) + u:valueOfDigit(substring($arg,8,1), 8) +
									u:valueOfDigit(substring($arg,9,1), 9) + u:valueOfDigit(substring($arg,10,1), 10) +
									u:valueOfDigit(substring($arg,11,1), 11) + u:valueOfDigit(substring($arg,12,1), 12) +
									u:valueOfDigit(substring($arg,13,1), 13) + u:valueOfDigit(substring($arg,14,1), 14) +
									u:valueOfDigit(substring($arg,15,1), 15)
								) mod 26, 'upper') = substring($arg,16,1)
							)
						)
						then true()
						else false()
					)
					else false()
					"/>
	</function>
	<function name="u:checkCF11" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
					if ( ($arg castable as xsd:integer) and (string-length($arg) = 11) ) 
					then true()
					else false()
					"/>
	</function>
	<function name="u:checkCodiceIPA" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
		<sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
	</function>
	<!-- DEFINIZIONE PHASE -->
	<phase id="underConstruction">
		<active pattern="verificaID"/>
		<active pattern="verificaLineeOrdine"/>
		<active pattern="verificaCIG"/>
		<active pattern="verificaPIVA"/>
		<active pattern="verificaCodiceIPA"/>
		<active pattern="verificaCF"/>
		<active pattern="verificaBuyer"/>
	</phase>
	<!-- DEFINIZIONE ABSTRACT ROLE PATTERN -->
	<pattern id="getAbstractTipoOrdine">
		<!--Definizione delle role "define_tipologia_ordine" di tipo astratta. Analizza il campo "/ubl:Order/cac:OrderDocumentReference/cbc:ID" e definisce il sotto tipo del documento. Definisce delle variabili globali da utilizzare all'interno dei singoli pattern che estendono questa role.-->
		<rule abstract="true" id="define_tipologia_ordine">
			<let name="tipologia_ordine_ristretta" value="
			
				if (/ubl:Order/cac:OrderDocumentReference) 
				then
				(  
						if (count(/ubl:Order/cac:OrderDocumentReference) = 1)
						then 
						(
							u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)
						)
						else 
						(
							'ERRORE_NSO45'
						)
				)
				else
				(
						'INIZ'
				)
				
			"/>
			<assert id="NSO_040" test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()" flag="fatal">
				NSO_040 - Il formato dell’elemento "cac:OrderDocumentReference/cbc:ID" non è valido (esempio di format corretto: "110#2018-01-30#aaaaaa#Revised"). - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct format example: "110#2018-01-30#aaaaaa#Revised").
			</assert>
			<assert id="NSO_044" test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()" flag="fatal">
				NSO_044 - Nell’elemento "cac:OrderDocumentReference/cbc:ID", il ReferenceType non è valorizzato correttamente (i valori ammessi sono: "Connected", "Accepted", "Cancelled", "Revised", "Invoice"). – In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
			</assert>
			<assert id="NSO_045" test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()" flag="fatal">
				NSO_045 – Il Documento contiene più di un elemento "cac:OrderDocumentReference". - The Document contains more than one "cac:OrderDocumentReference" element.
			</assert>
			<let name="INIZ" value="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
			<let name="CONN" value="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
			<let name="SOST" value="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
			<let name="CANC" value="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
			<let name="CONF" value="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
			<let name="INVO" value="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>
		</rule>
		<rule abstract="true" id="verifica_codice_ipa">
			<assert id="NSO_010" test="if(@schemeID=0201) then u:checkCodiceIPA(.) else true()" flag="fatal">NSO_010 – Il Codice IPA indicato nell’elemento non è valido. - The IPA Code specified in the element is invalid.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaID -->
	<pattern id="verificaID">
		<rule context="/ubl:Order">
			<extends rule="define_tipologia_ordine"/>
		</rule>
		<rule context="cac:OrderDocumentReference/cbc:ID">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_042" test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and not (u:validationDate(u:getPartTokenizeID(.,2))) )" flag="fatal">NSO_042 – Il formato della data presente nell’elemento non è corretto (esempio corretto: "2020-01-31"). - The format of the date in the element is incorrect (correct format example: "2020-01-31"). 
			</assert>
			<assert id="NSO_043" test="not( ( u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO) )	and ( not((u:getPartTokenizeID(.,3)!='') and( u:checkPIVAseIT(u:getPartTokenizeID(.,3)) or u:checkCodiceIPA(u:getPartTokenizeID(.,3))) ) ) )" flag="fatal">NSO_043 - L'EndpointID indicato nell’elemento non è un valore valido (esempio di valore corretto: "IT01043931003"). - The EndpointID specified in the element  is not a valid value (correct value example: "IT01043931003"). 
			</assert>
			<assert id="NSO_041" test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( (u:getPartTokenizeID(.,1)='') ) )" flag="fatal">NSO_041 - L'ID presente nell’elemento non è valorizzato. - The ID in the element is not set.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaLineeOrdine -->
	<pattern id="verificaLineeOrdine">
		<rule context="/ubl:Order">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_050" test=" not( (u:is($CONF) or u:is($CANC)) and (count(cac:OrderLine) != 1)) " flag="fatal">NSO_050 – Il Documento contiene più di un elemento "cac:OrderLine". – The Document contains more than one "cac:OrderLine" element.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_051" test=" not( (u:is($CONF) or u:is($CANC)) and (count(cbc:Note) != 0)) " flag="fatal">NSO_051 – La linea d’ordine contiene elementi non ammessi (l’unico elemento ammesso è "LineItem"). – The order line contains not allowed elements (the only element allowed is "LineItem").
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_053" test=" not( (u:is($CONF) or u:is($CANC)) and (cbc:ID != 'NA')) " flag="fatal">NSO_053 – Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA"). - The value specified in the element is not allowed (the correct value is "NA").
			</assert>
			<assert id="NSO_054" test=" not( (u:is($CONF) or u:is($CANC)) and (cbc:Quantity != '0')) " flag="fatal">NSO_054 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "0"). - The value specified in the element is not allowed (the correct value is "0").
			</assert>
			<assert id="NSO_056" test=" not( (u:is($CONF) or u:is($CANC)) and (cac:Item/cbc:Name != 'NA')) " flag="fatal">NSO_056 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA"). - The value specified in the element is not allowed (the correct value is "NA"). 
			</assert>
			<assert id="NSO_052" test=" not( (u:is($CONF) or u:is($CANC)) and
							(      cbc:LineExtensionAmount
								or cbc:PartialDeliveryIndicator	
								or cbc:AccountingCost	
								or cac:Delivery	
								or cac:OriginatorParty	
								or cac:AllowanceCharge	
								or cac:Item/cbc:Description	
								or cac:Item/cac:BuyersItemIdentification	
								or cac:Item/cac:SellersItemIdentification	
								or cac:Item/cac:StandardItemIdentification	
								or cac:Item/cac:ItemSpecificationDocumentReference	
								or cac:Item/cac:CommodityClassification	
								or cac:Item/cac:ClassifiedTaxCategory	
								or cac:Item/cac:AdditionalItemProperty	
								or cac:Item/cac:ItemInstance
								or cac:Price)
							) " flag="fatal">NSO_052 – La linea d’ordine contiene elementi non ammessi all’interno di "LineItem" (gli elementi ammessi sono: "ID", "Quantity", "Name"). - The order line contains elements that are not allowed within "LineItem" (the allowed elements are: "ID", "Quantity", "Name").
			</assert>
		</rule>
	</pattern>
	<pattern id="controllo_lineitem_id">
		<rule context="cac:LineItem">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_064" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( string-length(cbc:ID)>6 ) )" flag="warning">NSO_064 - E' consigliabile che la lunghezza dell’identificativo della linea d'ordine non sia maggiore di 6. - Element 'cbc:ID' SHOULD have a maximum length of 6 characters.
			</assert>
		</rule>
	</pattern>
	<pattern id="controlloConsegnaDomicilio">
		<rule context="cac:DeliveryLocation">
			<assert id="NSO_063" flag="warning" test="if( ((upper-case(cbc:ID)) eq 'CONSEGNA DOMICILIARE') ) then false() else true()">NSO_063 – Avviso che non invalida l’ordine trasmesso: se l’elemento 'cac:Delivery' contiene informazioni relative a una persona fisica, è necessario osservare le vigenti norme in materia di protezione dei dati personali. - This warning does not invalidate the order: if the element 'cac:Delivery' contains personal data, the current data protection regulations must be observed.</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaCIG -->
	<pattern id="verificaCIG">
		<rule context="/ubl:Order">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_061" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and ( string-join(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem),'') eq '') ) then true() else false() ) )" flag="fatal">NSO_061 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente. - The Tender Identification Code (CIG) or the Exemption Code is not present at the entire document level or in all order lines, or is present in both levels simultaneously.
			</assert>
			<assert id="NSO_061" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( (/ubl:Order/cac:OriginatorDocumentReference) and  (string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) != 0 )) then true() else false() ) )" flag="fatal">NSO_061 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente. - The Tender Identification Code (CIG) or the Exemption Code is not present at the entire document level or in all order lines, or is present in both levels simultaneously.
			</assert>
			<assert id="NSO_061" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and not ( (count(/ubl:Order/cac:OrderLine)*4) = string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) )  )  then true() else false() ) )" flag="fatal">NSO_061 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente. - The Tender Identification Code (CIG) or the Exemption Code is not present at the entire document level or in all order lines, or is present in both levels simultaneously.
			</assert>
			<assert id="NSO_062" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( not (u:checkCIGLinea(/ubl:Order/cac:OrderLine/cac:LineItem)) ) )" flag="fatal">NSO_062 – Una o più linee d’ordine contengono più di un Codice Identificativo di Gara (CIG) o Codice di esenzione. – One or more order lines contain more than one Tender Identification Code (CIG) or Exemption Code.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OriginatorDocumentReference">
			<extends rule="define_tipologia_ordine"/>
			<!-- Se è un ordine iniziale, sostituzione o cancellazione, se presente un campo CIG deve essere valido -->
			<assert id="NSO_060" test=" ( u:verificaCIG(cbc:ID) )" flag="fatal">NSO_060 - Il Codice Identificativo di Gara (CIG o Smart CIG) o il Codice di esenzione indicato nell’elemento non è valido. - The Tender Identification Code (CIG or Smart CIG) or the Exemption Code specified in the element is invalid.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
			<extends rule="define_tipologia_ordine"/>
			<!-- Se è un ordine iniziale, sostituzione o cancellazione, se presente un campo CIG deve essere valido -->
			<assert id="NSO_060" test="if (  u:verificaCIG(cbc:ID)  ) then true() else (u:controlliUlterioriCodici(cbc:ID))" flag="fatal">NSO_060 - Il Codice Identificativo di Gara (CIG o Smart CIG) o il Codice di esenzione indicato nell’elemento non è valido. - The Tender Identification Code (CIG or Smart CIG) or the Exemption Code specified in the element is invalid.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaPIVA -->
	<pattern id="verificaPIVA">
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_030" test="if(@schemeID=9906 or @schemeID=0211) then u:checkPIVAseIT(.) else true() " flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida. - The VAT number specified in the element is invalid  is not valid.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
			<assert id="NSO_030" test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()" flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida. - The VAT number specified in the element is invalid  is not valid.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_030" test="if(@schemeID=9906 or @schemeID=0211) then u:checkPIVAseIT(.) else true() " flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida. - The VAT number specified in the element is invalid  is not valid.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
			<assert id="NSO_030" test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()" flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida. - The VAT number specified in the element is invalid  is not valid.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaCodiceIPA -->
	<pattern id="verificaCodiceIPA">
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>
	</pattern>
	<pattern id="verificaCF">
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_020" test="if((@schemeID=9907 or @schemeID=0210) and not (.=string(9999999999999999))) then u:checkCF(.) else true()" flag="fatal">NSO_020 – Il Codice Fiscale indicato nell’elemento non è valido. - The Tax Code specified in the element is invalid.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_020" test="if(@schemeID=9907 or @schemeID=0210) then u:checkCF(.) else true()" flag="fatal">NSO_020 – Il Codice Fiscale indicato nell’elemento non è valido. - The Tax Code specified in the element is invalid.
			</assert>
		</rule>
	</pattern>
	<pattern id="verificaBuyer">
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_011" test="if(@schemeID=0201) then true() else false()" flag="fatal">NSO_011 – Il valore dell’attributo schemeID dell’elemento è errato (il valore corretto è "0201"). - The value of schemeID attribute of the element is incorrect (the correct value is "0201").
			</assert>
		</rule>
	</pattern>
	<pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
		<let name="clUNCL5305" value="tokenize('AE E S Z G O K L M', '\s')"/>
		<rule context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cbc:ID">
			<assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" flag="fatal" id="NSO_070">NSO_070 - Il valore DEVE far parte della codifica 'Duty or tax or fee category code (UNCL5305)'. - Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.</assert>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:ID">
			<assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" flag="fatal" id="NSO_071">NSO_071 - Il valore DEVE far parte della codifica 'Duty or tax or fee category code (UNCL5305)'. - Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.</assert>
		</rule>
	</pattern>
</schema>