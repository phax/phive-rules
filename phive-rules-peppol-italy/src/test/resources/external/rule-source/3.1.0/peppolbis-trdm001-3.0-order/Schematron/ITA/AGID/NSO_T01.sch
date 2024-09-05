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
		<variable name="tipo" select="if (u:countDelitited($arg) != 3) then 'NSO2' else u:getPartTokenizeID($arg,4)"/>
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
	<!-- La funzione estrae la stringa posizionale in un takenize di # -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:getPartTokenizeID" as="xs:string">
		<param name="reference" as="xs:string"/>
		<param name="arg" as="xs:integer"/>
		<variable name="listToken" select="tokenize($reference, '#')"/>
		<sequence select="$listToken[$arg]"/>
	</function>
	<!-- La funzione estrae il numero di stringhe in un takenize di # -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:countDelitited" as="xs:integer">
		<param name="reference" as="xs:string"/>
		<variable name="stringList" select="tokenize($reference, '#')"/>
		<sequence select="count($stringList) - 1"/>
	</function>
	<!-- Funzione tecnica per ottimizzazione scrittura codice -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:is" as="xs:boolean">
		<param name="arg" as="xs:boolean"/>
		<sequence select="xs:boolean($arg)"/>
	</function>
	<!-- Controllo se la data è valida -->
	<function name="u:validationDate" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="string(normalize-space($arg)) castable as xs:date"/>
	</function>
	<!-- Controllo CIG (comprende tutti i controlli:
			normalizza CIG: gli toglie eventuale CIG:
			verifica se il campo normalizzato è un CIG (non deve avere i ":")
			verifica se è lungo 4 (caso esclusioni) o 10 (CIG o SmartCIG)
			Verifica se è un CIG Valido o un Smart CIG Valido o una esclusione Valida
	-->
	<function name="u:verificaCIG" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="argNor" select="u:normalizaCIG($arg)"/>
		<sequence select="
		if (u:isCIG($argNor)) then
		( if ( string-length($argNor) != 4 and string-length($argNor) != 10 ) then true() else 
			( if ( string-length($argNor) = 4 and not ( u:isEsclusioneValida($argNor) ) ) then true() else
				( if ( string-length($argNor) = 10 and contains('X Y Z', substring($argNor,1,1)) and not ( u:isSmartCIGValido($argNor) ) ) then true() else
					( if ( string-length($argNor) = 10 and not (contains('X Y Z', substring($argNor,1,1))) and not ( u:isCIGValido($argNor) ) ) then true() else
						false()
					)
				)
			)
		) else false()"/>
	</function>
	<!-- Verifica se Codice Esclusione CIG è valido -->
	<function name="u:isEsclusioneValida" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="( contains( 'ES01 ES02 ES03 ES04 ES05 ES06 ES07 ES08 ES09 ES10 
								       ES11 ES12 ES13 ES14 ES15 ES16 ES17 ES18 ES19 ES20 
									   ES21 ES22 ES23 ES24 ES25 ES26 ES27', $arg ) 
						  )"/>
	</function>
	<!-- Verifica se CIG è valido-->
	<function name="u:isCIGValido" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select=" (
					( matches (substring($arg,1,7), '0000000') )  
					or 
					not ( if(u:hexToDec(substring($arg,8,3)) = xs:integer((xs:integer(substring($arg,1,7)) * 211 ) mod 4091) ) then 0 else 1) 
						   )"/>
	</function>
	<!-- Verifica se Smart CIG è valido-->
	<function name="u:isSmartCIGValido" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select=" (
					( matches (substring($arg,4,7), '0000000') )  
					or 
					not ( if(u:hexToDec(substring($arg,2,2)) = xs:integer((xs:integer(u:hexToDec(substring($arg,4,7))) * 211 ) mod 251) ) then 0 else 1) 
						   )"/>
	</function>
	<!-- Verifica se è un CIG - Non deve essere presente il carattere ":" -->
	<function name="u:isCIG" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="stringList" select="tokenize($arg, ':')"/>
		<sequence select="if ((count($stringList) -1) > 0) then false() else true()"/>
	</function>
	<!-- Se presente toglie CIG: -->
	<function name="u:normalizaCIG" as="xs:string" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="if ( matches (substring($arg,1,4), 'CIG:') ) then substring($arg,5,10) else $arg"/>
	</function>
	<!--funzione tecnica di traformazione hex to dec per la verifica del CIG -->
	<function name="u:hexToDec" as="xs:double" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="hex" as="xs:string?"/>
		<variable name="dec" select="string-length(substring-before('0123456789ABCDEF', substring($hex,1,1)))"/>
		<choose>
			<when test="matches($hex, '([0-9]*|[A-F]*)' ) ">
				<sequence select="if ($hex = '') then 0 else ( $dec * u:hexToDec2(16, string-length($hex) - 1) + u:hexToDec(substring($hex,2)) )"/>
			</when>
			<otherwise>
				<message>Il valore fornito non è esadecimale...</message>
				<sequence select="0"/>
			</otherwise>
		</choose>
	</function>
	<!--funzione tecnica di traformazione hex to dec per la verifica del CIG -->
	<function name="u:hexToDec2" as="xs:double" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="base" as="xs:decimal"/>
		<param name="exp" as="xs:decimal"/>
		<sequence select="if ($exp lt 0) then u:hexToDec2(1.0 div $base, -$exp) else if ($exp eq 0) then 1e0 else $base * u:hexToDec2($base, $exp - 1)"/>
	</function>
	<!-- La funziona verifica che se il CIG è presente a livello di linea d'ordine all'interno di ogni singola riga ci sia uno ed un solo CIG
			- la funzione non verifica il CIG ma verifica che sia del formato corretto
	-->
	<function name="u:checkCIGLinea" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="item()*"/>
		<variable name="long" select="string-join(u:checkCIGLineaAlg($arg) ,'')"/>
		<variable name="short" select="string-join(distinct-values(u:checkCIGLineaAlg($arg)),'')"/>
		<!--
		<value-of select="$long"/>
		<value-of select="$short"/>
		-->
		<value-of select="if ( xs:string($long) eq xs:string($short) ) then true() else false()"/>
	</function>
	<function name="u:divisoNumeroZeri" as="xs:string" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<value-of select="xs:string(xs:integer($arg) div 4)"/>
	</function>
	<!-- La funziona restituisce una sequenza delle posizioni (a livello di linea) in cui compare un CIG semanticamente valido -->
	<function name="u:checkCIGLineaAlg" as="xs:string*" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="item()*"/>
		<for-each select="$arg">
			<variable name="countRiga" select="position()"/>
			<for-each select="./cac:Item/cac:ItemSpecificationDocumentReference">
				<value-of select="
					if  (u:isCIG(u:normalizaCIG(./cbc:ID))) then (
							format-number($countRiga, '0000')
						) else ''				
				"/>
			</for-each>
		</for-each>
	</function>
	<!-- Controllo della PIVA secondo le regole https://databularium.com/it/2015/08/21/come-controllare-la-correttezza-della-partita-iva/ -->
	<function name="u:checkPIVA" as="xs:integer" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
				if (not($arg castable as xsd:integer)) 
					then 1
					else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
	</function>
	<!-- Funzione di utilità per il controllo della PIVA -->
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
	<!-- Funzione di utilità per il controllo del EndpointID -->
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
	<!-- Controllo Codice Fiscale-->
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
	<!-- Controllo Codice Fiscale 16 -->
	<function name="u:checkCF16" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
		<sequence select="
					if ( 	(string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and  
					        (substring($arg,7,2) castable as xsd:integer) and 
							(string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and 
							(substring($arg,10,2) castable as xsd:integer) and  
							(substring($arg,12,3) castable as xsd:string) and 
							(substring($arg,15,1) castable as xsd:integer) and  
							(string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)
						) 
					then true()
					else false()
					"/>
	</function>
	<!-- Controllo Codice Fiscale 11 -->
	<function name="u:checkCF11" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
					if ( ($arg castable as xsd:integer) and (string-length($arg) = 11) ) 
					then true()
					else false()
					"/>
	</function>
	<!-- Controllo Codice IPA -->
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
			<!--Struttura ID errata-->
			<assert id="NSO_040" test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()" flag="fatal">
				NSO_040 - Il formato dell’elemento "cac:OrderDocumentReference/cbc:ID" non è valido (esempio di format corretto: "110#2018-01-30#aaaaaa#Revised").
			</assert>
			<!--Tipo documento non riconosciuto-->
			<assert id="NSO_044" test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()" flag="fatal">
				NSO_044 - Nell’elemento "cac:OrderDocumentReference/cbc:ID", il ReferenceType non è valorizzato correttamente (i valori ammessi sono: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
			</assert>
			<!--Presenza di troppi OrderDocumentReference-->
			<assert id="NSO_045" test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()" flag="fatal">
				NSO_045 – Il Documento contiene più di un elemento "cac:OrderDocumentReference".
			</assert>
			<let name="INIZ" value="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
			<let name="CONN" value="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
			<let name="SOST" value="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
			<let name="CANC" value="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
			<let name="CONF" value="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
			<!-- NB un ordine di tipo involice è un ordine iniziale -->
			<let name="INVO" value="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>
		</rule>
		<rule abstract="true" id="verifica_codice_ipa">
			<assert id="NSO_010" test="if(@schemeID=0201) then u:checkCodiceIPA(.) else true()" flag="fatal">NSO_010 – Il Codice IPA indicato nell’elemento non è valido.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaID -->
	<pattern id="verificaID">
		<!-- Role test e template -->
		<rule context="/ubl:Order">
			<extends rule="define_tipologia_ordine"/>
			<!--
			<report test="true()">
			    TipoOrdineRistretta = <value-of select="$tipologia_ordine_ristretta"/>
			</report>

			<assert id="NSO000" test="not(u:is($INIZ) and true())" flag="info">Errore di test Ordine Iniziale</assert>
			<assert id="NSO000" test="not(u:is($INIZ) and false())" flag="info">NON DEVE COMPARIRE ## Ordine Iniziale</assert>
			<assert id="NSO000" test="not(u:is($CONN) and true())" flag="info">Errore di test Ordine Iniziale Collegato</assert>
			<assert id="NSO000" test="not(u:is($CONN) and false())" flag="info">NON DEVE COMPARIRE ## Ordine Iniziale Collegato</assert>
			<assert id="NSO000" test="not(u:is($SOST) and true())" flag="info">Errore di test Ordine Sostituzione</assert>
			<assert id="NSO000" test="not(u:is($SOST) and false())" flag="info">NON DEVE COMPARIRE ## Ordine Sostituzione</assert>
			<assert id="NSO000" test="not(u:is($CANC) and true())" flag="info">Errore di test Ordine Cancellazione</assert>
			<assert id="NSO000" test="not(u:is($CANC) and false())" flag="info">NON DEVE COMPARIRE ## Ordine Cancellazione</assert>
			<assert id="NSO000" test="not((u:is($SOST) or u:is($CANC)) and true())" flag="info">Errore di test Ordine Cancellazione/Sostituzione</assert>
			<assert id="NSO000" test="not((u:is($SOST) or u:is($CANC)) and false())" flag="info">NON DEVE COMPARIRE ## Ordine Cancellazione/Sostituzione</assert>
			-->
		</rule>
		<!-- Verifica struttura cac:OrderDocumentReference/cbc:ID -->
		<rule context="cac:OrderDocumentReference/cbc:ID">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_042" test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and not (u:validationDate(u:getPartTokenizeID(.,2))) )" flag="fatal">NSO_042 – Il formato della data presente nell’elemento non è corretto (esempio corretto: "2020-01-31").
			</assert>
			<assert id="NSO_043" test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( not ( u:checkPIVAseIT(u:getPartTokenizeID(.,3)) ) ) )" flag="fatal">NSO_043 - L'EndpointID indicato nell’elemento non è un valore valido (esempio di valore corretto: "IT01043931003").
			</assert>
			<assert id="NSO_041" test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( (u:getPartTokenizeID(.,1)='') ) )" flag="fatal">NSO_041 - L'ID presente nell’elemento non è valorizzato.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaLineeOrdine -->
	<pattern id="verificaLineeOrdine">
		<!-- L'ordine di revoca e l'ordine di conferma deveno contenere una e una sola linea ordine -->
		<rule context="/ubl:Order">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_050" test=" not( (u:is($CONF) or u:is($CANC)) and (count(cac:OrderLine) != 1)) " flag="fatal">NSO_050 – Il Documento contiene più di un elemento "cac:OrderLine".
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_051" test=" not( (u:is($CONF) or u:is($CANC)) and (count(cbc:Note) != 0)) " flag="fatal">NSO_051 – La linea d’ordine contiene elementi non ammessi (l’unico elemento ammesso è "LineItem").
			</assert>
		</rule>
		<!-- Se è un ordine di revoca o un ordine di conferma, deve contenere una sola linea d’ordine che riporta solo i campi di seguito indicati: "ID", valorizzato con "NA"; "Quantity", valorizzato con "0"; "Name", valorizzato con "NA -->
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem">
			<extends rule="define_tipologia_ordine"/>
			<assert id="NSO_053" test=" not( (u:is($CONF) or u:is($CANC)) and (cbc:ID != 'NA')) " flag="fatal">NSO_053 – Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA").
			</assert>
			<assert id="NSO_054" test=" not( (u:is($CONF) or u:is($CANC)) and (cbc:Quantity != '0')) " flag="fatal">NSO_054 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "0").
			</assert>
			<assert id="NSO_056" test=" not( (u:is($CONF) or u:is($CANC)) and (cac:Item/cbc:Name != 'NA')) " flag="fatal">NSO_056 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA").
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
							) " flag="fatal">NSO_052 – La linea d’ordine contiene elementi non ammessi all’interno di "LineItem" (gli elementi ammessi sono: "ID", "Quantity", "Name").
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaCIG -->
	<pattern id="verificaCIG">
		<rule context="/ubl:Order">
			<extends rule="define_tipologia_ordine"/>
			<!-- Se è un ordine iniziale, sostituzione, connessione o fattura deve essere presente il CIG o a livello di documento o in ogni singola linea d'ordine -->
			<!-- verifica se non è presente in testata e nelle linee -->
			<assert id="NSO_061" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and ( string-join(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem),'') eq '') ) then true() else false() ) )" flag="fatal">NSO_061 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente.
			</assert>
			<!-- verifica che è presente in testata o in alcune linee -->
			<assert id="NSO_061" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( (/ubl:Order/cac:OriginatorDocumentReference) and  (string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) != 0 )) then true() else false() ) )" flag="fatal">NSO_061 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente.
			</assert>
			<!-- verifica che se non presente in testata sia presente in tutte le linee-->
			<assert id="NSO_061" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and not ( (count(/ubl:Order/cac:OrderLine)*4) = string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) )  )  then true() else false() ) )" flag="fatal">NSO_061 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente.
			</assert>
			<!-- verifica che se presente nelle linee sia presente una sola volta per linee-->
			<assert id="NSO_062" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( not (u:checkCIGLinea(/ubl:Order/cac:OrderLine/cac:LineItem)) ) )" flag="fatal">NSO_062 – Una o più linee d’ordine contengono più di un Codice Identificativo di Gara (CIG) o Codice di esenzione.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OriginatorDocumentReference">
			<extends rule="define_tipologia_ordine"/>
			<!-- Se è un ordine iniziale, sostituzione o cancellazione, se presente un campo CIG deve essere valido -->
			<assert id="NSO_060" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )" flag="fatal">NSO_060 - Il Codice Identificativo di Gara (CIG o Smart CIG) o il Codice di esenzione indicato nell’elemento non è valido.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
			<extends rule="define_tipologia_ordine"/>
			<!-- Se è un ordine iniziale, sostituzione o cancellazione, se presente un campo CIG deve essere valido -->
			<assert id="NSO_060" test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )" flag="fatal">NSO_060 - Il Codice Identificativo di Gara (CIG o Smart CIG) o il Codice di esenzione indicato nell’elemento non è valido.
			</assert>
		</rule>
	</pattern>
	<!-- DEFINIZIONE PATTERN NELLA PHASE verificaPIVA -->
	<pattern id="verificaPIVA">
		<!-- Controllo della PIVA secondo le regole https://databularium.com/it/2015/08/21/come-controllare-la-correttezza-della-partita-iva/ -->
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<!-- nel caso in cui schemeID = 9906 oppure 0211 l'endpointID deve contenere una partita iva formalmente corretta -->
			<assert id="NSO_030" test="if((@schemeID=9906 or @schemeID=0211)) then u:checkPIVAseIT(.) else true() " flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
			<!-- Se primi 2 caratteri IT una PIVA valido o se lungo 11 Codice Fiscale numerico  -->
			<assert id="NSO_030" test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()" flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
			<!-- nel caso in cui schemeID = 9906 oppure 0211 l'endpointID deve contenere una partita iva formalmente corretta -->
			<assert id="NSO_030" test="if((@schemeID=9906 or @schemeID=0211)) then u:checkPIVAseIT(.) else true() " flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
			<!-- Se primi 2 caratteri IT una PIVA valido o se lungo 11 Codice Fiscale numerico  -->
			<assert id="NSO_030" test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()" flag="fatal">NSO_030 – La partita IVA indicata nell’elemento non è valida.
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
	<!--  CF da 16 (verificare solo struttura, no controlli di merito) o CF da 11  (11 numeri senza IT);  -->
	<pattern id="verificaCF">
		<rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_020" test="if((@schemeID=9907 or @schemeID=0210) and not (.=string(9999999999999999))) then u:checkCF(.) else true()" flag="fatal">NSO_020 – Il Codice Fiscale indicato nell’elemento non è valido.
			</assert>
		</rule>
		<rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_020" test="if((@schemeID=9907 or @schemeID=0210)) then u:checkCF(.) else true()" flag="fatal">NSO_020 – Il Codice Fiscale indicato nell’elemento non è valido.
			</assert>
		</rule>
	</pattern>
	<!-- Verifica Buyer: schemaID dell'Endopoint deve essere sempre 0201 -->
	<pattern id="verificaBuyer">
		<rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_011" test="if(@schemeID=0201) then true() else false()" flag="fatal">NSO_011 – Il valore dell’attributo schemeID dell’elemento è errato (il valore corretto è "0201").
			</assert>
		</rule>
	</pattern>
</schema>