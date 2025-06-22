<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="https://www.w3.org/1999/XSL/Transform"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>Controlli NSO per il tracciato PEPPOL Order transaction 3.0</title>

    <!-- DEFINIZIONE NAMESPACES -->
   
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:OrderResponse-2" prefix="ubl"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>

    <!-- DEFINIZIONE FUNZIONI -->
   
    <!-- Funzione deternina il sottotipo di documento:
	
	     "Cancelled" Cancella  		CANC 
		 "Revised"   Sostituzione	SOST
		 "Connected" Collegamento   CONN	
		 "Invoice"   Fattura		INVO	
		 altrimenti  Iniziale		INIZ
	-->
	
    <function name="u:tipoOrdine" as="xs:string"
              xmlns="http://www.w3.org/1999/XSL/Transform">		
		<param name="arg" as="xs:string?"/>
		<variable name="tipo" select="if (u:countDelitited($arg) != 3) then 'NSO2' else u:getPartTokenizeID($arg,4)"/>
		<sequence select="if ($tipo eq 'Cancelled') then 'CANC' else
							(if ($tipo eq 'Revised') then 'SOST' else 
								(if ($tipo eq 'Connected') then 'CONN' else 
									(if ($tipo eq 'Invoice') then 'INVO' else
										(if ($tipo eq 'NSO2') then 'ERRORE_NSO2' else 'ERRORE'								
										)
									)
								)
							)"/>
    </function>
   
   	<function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:getPartTokenizeID" as="xs:string">		 
		<param name="reference" as="xs:string"/>
		<param name="arg" as="xs:integer"/>
	  
		<variable name="listToken" select="tokenize($reference, '#')" /> 

		<sequence select="$listToken[$arg]"/>
	 		
	</function>
	
	<function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:countDelitited" as="xs:integer">		 
      <param name="reference" as="xs:string"/>
	  <variable name="stringList" select="tokenize($reference, '#')"/>
	  
	  <sequence select="count($stringList) - 1"/>
		
	</function>

   	<function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:is" as="xs:boolean">		 
		<param name="arg" as="xs:boolean"/>
	  
		<sequence select="xs:boolean($arg)"/>
	 		
	</function>
   
	<function name="u:validationDate" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="arg" as="xs:string?"/>

		<sequence select="string(normalize-space($arg)) castable as xs:date"/>

	</function>

	<function name="u:checkEndpoint" as="xs:integer" 
			  xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="arg" as="xs:string"/>

		<variable name="paese" select="substring($arg,1,2)"/>
		<variable name="codice" select="substring($arg,3)"/>

        <sequence select="
		if ($paese castable as xsd:string) 		
		then 
		(
			if ($paese = 'IT' and (string-length($codice) = 11)) 
			then
			(
				if (u:checkPIVA($codice)) 
				then
				(
					1
				)
				else
				(
					0
				)
			)
			else
			(
				0

			)
		)
		else
		(
			0
		)
		"/>
			
	</function>
	
    <function name="u:checkCodiceIPA" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="xs:string?"/>
		
		<variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>

		<sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
		
    </function>

    <function name="u:checkCF" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

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

    <function name="u:checkCF16" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

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
					" />
					
    </function>
	
    <function name="u:checkCF11" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="xs:string?"/>
		
		<sequence select="
					if ( ($arg castable as xsd:integer) and (string-length($arg) = 11) ) 
					then true()
					else false()
					" />
					
    </function>
	
    <function name="u:checkPIVA" as="xs:integer"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="xs:string?"/>
		
		<sequence select="
				if (not($arg castable as xsd:integer)) 
					then 1
					else ( u:addPIVA($arg,xs:integer(0)) mod 10 )" />
		
    </function>
	
	<function name="u:addPIVA" as="xs:integer" 
			  xmlns="http://www.w3.org/1999/XSL/Transform">
		
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

	<function name="u:checkPIVAseIT" as="xs:boolean" 
			  xmlns="http://www.w3.org/1999/XSL/Transform">
		
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

	<function name="u:verificaCIG" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">
		
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

	<function name="u:isEsclusioneValida" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="arg" as="xs:string?"/>

		<sequence select="( contains( 'ES01 ES02 ES03 ES04 ES05 ES06 ES07 ES08 ES09 ES10 
								       ES11 ES12 ES13 ES14 ES15 ES16 ES17 ES18 ES19 ES20 
									   ES21 ES22 ES23 ES24 ES25 ES26 ES27', $arg ) 
						  )"/>

	</function>	
	
	<function name="u:isCIGValido" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="arg" as="xs:string?"/>

		<sequence select=" (
					( matches (substring($arg,1,7), '0000000') )  
					or 
					not ( if(u:hexToDec(substring($arg,8,3)) = xs:integer((xs:integer(substring($arg,1,7)) * 211 ) mod 4091) ) then 0 else 1) 
						   )"/>
							 
	</function>	

	<function name="u:isSmartCIGValido" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="arg" as="xs:string?"/>

		<sequence select=" (
					( matches (substring($arg,4,7), '0000000') )  
					or 
					not ( if(u:hexToDec(substring($arg,2,2)) = xs:integer((xs:integer(u:hexToDec(substring($arg,4,7))) * 211 ) mod 251) ) then 0 else 1) 
						   )"/>
							 
	</function>

	<function name="u:isCIG" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">

		<param name="arg" as="xs:string?"/>
 	   
	    <variable name="stringList" select="tokenize($arg, ':')"/>
	  
	    <sequence select="if ((count($stringList) -1) > 0) then false() else true()"/>

	</function>
	
	<function name="u:normalizaCIG" as="xs:string"
              xmlns="http://www.w3.org/1999/XSL/Transform">

		<param name="arg" as="xs:string?"/>
	  
	    <sequence select="if ( matches (substring($arg,1,4), 'CIG:') ) then substring($arg,5,10) else $arg"/>

	</function>
	
	<!--funzione tecnica di traformazione hex to dec per la verifica del CIG -->
	<function name="u:hexToDec" as="xs:double" 
			  xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="hex" as="xs:string?"/>
		
		<variable name="dec" select="string-length(substring-before('0123456789ABCDEF', substring($hex,1,1)))"/>
		
		<choose>
			<when test="matches($hex, '([0-9]*|[A-F]*)' ) ">
				<sequence select="if ($hex = '') then 0 else ( $dec * u:hexToDec2(16, string-length($hex) - 1) + u:hexToDec(substring($hex,2)) )"/>
			</when>
			<otherwise>
				<message>Provided value is not hexadecimal...</message>
				<sequence select="0"/>
			</otherwise>
		</choose>
		
	</function>

	<!--funzione tecnica di traformazione hex to dec per la verifica del CIG -->	
	<function name="u:hexToDec2" as="xs:double" 
			  xmlns="http://www.w3.org/1999/XSL/Transform">
      
	  <param name="base" as="xs:decimal"/>
      <param name="exp" as="xs:decimal"/>
	  
	  <sequence select="if ($exp lt 0) then u:hexToDec2(1.0 div $base, -$exp) else if ($exp eq 0) then 1e0 else $base * u:hexToDec2($base, $exp - 1)" />	
	  
    </function>

	<!-- La funziona verifica che se il CIG è presente a livello di linea d'ordine all'interno di ogni singola riga ci sia uno ed un solo CIG
			- la funzione non verifica il CIG ma verifica che sia del formato corretto
	-->
    <function name="u:checkCIGLinea" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="item()*"/>
		
		<variable name="long" select="string-join(u:checkCIGLineaAlg($arg) ,'')"/>
		<variable name="short" select="string-join(distinct-values(u:checkCIGLineaAlg($arg)),'')"/>
		
		<!--
		<value-of select="$long"/>
		<value-of select="$short"/>
		-->
		
		<value-of select="if ( xs:string($long) eq xs:string($short) ) then true() else false()"/>
			
    </function>	

    <function name="u:checkCIGLineaAlg" as="xs:string*"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

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
	
    <!-- DEFINIZIONE PHASE -->
    <phase id="OrderAgreement">
	   <active pattern="verificaID"/>
	   <active pattern="verificaLineeOrdine"/>	   
	   <active pattern="verificaCodiceIPA"/>
	   <active pattern="verificaBuyer"/>
	   <active pattern="verificaCF"/>
	   <active pattern="verificaPIVA"/>
	   <active pattern="verificaCIG"/>
    </phase>

	
    <!-- DEFINIZIONE ABSTRACT ROLE PATTERN -->	
	<pattern id="getAbstractTipoOrdine">
								
		<rule abstract="true" id="define_tipologia_ordine">	

			<let name="tipologia_ordine_ristretta" value="if (/ubl:OrderResponse/cac:OrderReference/cbc:ID = '0') then  'INIZ' else u:tipoOrdine(/ubl:OrderResponse/cac:OrderReference/cbc:ID)"/>

			<assert id="NSO_240" test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO2') then false() else true()" flag="fatal">
				NSO_240 - Il formato dell’elemento "cac:OrderReference/cbc:ID" non è valido (esempio di formato corretto: "110#2018-01-30#IT01043931003#Revised").The format of the element  "cac:OrderReference/cbc:ID" is invalid (correct format example: "110#2018-01-30#IT01043931003#Revised").
			</assert>

			<assert id="NSO_244" test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()" flag="fatal">
				NSO_244 - Nell’elemento "cac:OrderReference/cbc:ID", il ReferenceType non è valorizzato correttamente (i valori ammessi sono: "Connected", "Cancelled", "Revised", "Invoice"). In the element "cac:OrderReference/cbc:ID" the ReferenceType is invalid (the allowed values are: "Connected", "Cancelled", "Revised", "Invoice").
			</assert>
			
			<let name="CONN" value="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
			<let name="INIZ" value="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
			<let name="SOST" value="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>	
			<let name="CANC" value="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>			
			<let name="INVO" value="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>			

		</rule>
		
		<rule abstract="true" id="verifica_codice_ipa">	
			
			<assert id="NSO_210" 
				test="if(@schemeID=0201) then u:checkCodiceIPA(.) else true()" flag="fatal">NSO_210 - Il Codice IPA indicato nell’elemento non è valido. - The IPA Code specified in the element is invalid.
			</assert>

		</rule>
		
	</pattern>

    <!-- DEFINIZIONE PATTERN NELLA PHASE verificaID -->

    <pattern id="verificaID">

		<rule context="/ubl:OrderResponse/cac:OrderReference/cbc:ID">
			<extends rule="define_tipologia_ordine"/>

			<assert id="NSO_241" test="not( (u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( (u:getPartTokenizeID(.,1)='') ) )" flag="fatal">
				 NSO_241 - L'ID presente nell’elemento non è valorizzato. The ID in the element is not set.
			</assert>	
			
			<assert id="NSO_242" test="not( (u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and not (u:validationDate(u:getPartTokenizeID(.,2))) )" flag="fatal">
				NSO_242 - Il formato della data presente nell’elemento non è corretto (esempio corretto: "2020-01-31"). The format of the date in the element is incorrect (correct format example: "2020-01-31").
			</assert>
			
			<assert id="NSO_243" test="not( (u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( not ( u:checkPIVAseIT(u:getPartTokenizeID(.,3)) ) ) )" flag="fatal">
				NSO_243 - L'EndpointID indicato nell’elemento non è un valore valido (esempi di valori corretti: "IT01043931003", "QLHCFC"). The EndpointID specified in the element  is not a valid value (correct values examples: "IT01043931003", "QLHCFC").
			</assert>
			
		</rule>

		<rule context="ubl:OrderResponse">
								
			<assert id="NSO_245" test="count(/ubl:OrderResponse/cac:OrderReference) = 1" flag="fatal">
				NSO_245 - Il Documento contiene più di un elemento "cac:OrderReference". - The Document contains more than one "cac:OrderReference" element. 
			</assert>

		</rule>
		
	</pattern>

    <!-- DEFINIZIONE PATTERN NELLA PHASE verificaLineeOrdine -->	
	<pattern id="verificaLineeOrdine">
	
		<rule context="/ubl:OrderResponse">
			<extends rule="define_tipologia_ordine"/>
			
			<assert id="NSO_250" test=" not( (u:is($CANC)) and (count(cac:OrderLine) != 1)) " flag="fatal">
				NSO_250 - Il Documento contiene più di un elemento "cac:OrderLine". The Document contains more than one "cac:OrderLine" element.
			</assert>

		</rule>
			
		<rule context="/ubl:OrderResponse/cac:OrderLine/cac:LineItem">
			<extends rule="define_tipologia_ordine"/>
			
			<assert id="NSO_253" test=" not( (u:is($CANC)) and (cbc:ID != 'NA')) " flag="fatal">
				NSO_253 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA"). The value specified in the element is not allowed (the correct value is "NA").
			</assert>
			
			<assert id="NSO_254" test=" not( (u:is($CANC)) and (cbc:Quantity != '0')) " flag="fatal">
				NSO_254 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "0"). The value specified in the element is not allowed (the correct value is "0").
			</assert>
			
			<assert id="NSO_257" test=" not( (u:is($CANC)) and (cac:Price/cbc:PriceAmount != '0.00')) " flag="fatal">
				NSO_257 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "0,00"). The value specified in the element is not allowed (the correct value is "0,00").
			</assert>
			
			<assert id="NSO_256" test=" not( (u:is($CANC)) and (cac:Item/cbc:Name != 'NA')) " flag="fatal">
				NSO_256 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA"). The value specified in the element is not allowed (the correct value is "NA").
			</assert>
		
			<assert id="NSO_259" test=" not( (u:is($CANC)) and ((count(cac:Item/cac:SellersItemIdentification/cbc:ID)!=1) or (cac:Item/cac:SellersItemIdentification/cbc:ID != 'NA'))) " flag="fatal">
				NSO_259 - Il valore indicato nell’elemento non è ammesso (il valore corretto è "NA"). The value specified in the element is not allowed (the correct value is "NA").
			</assert>		
			
			<assert id="NSO_252"
				test=" not( (u:is($CANC)) and
							(       cbc:LineExtensionAmount
								or  cbc:Note
								or  cac:Delivery
								or  cac:Item/cbc:Description	
								or  cac:Item/cac:BuyersItemIdentification		
								or  cac:Item/cac:StandardItemIdentification									
								or  cac:Item/cac:ItemSpecificationDocumentReference								
								or  cac:Item/cac:CommodityClassification	
								or  cac:Item/cac:TransactionConditions
								or  cac:Item/cac:ClassifiedTaxCategory	
								or  cac:Item/cac:AdditionalItemProperty	
								or  cac:Item/cac:Certificate
								or  cac:Price/cbc:BaseQuantity
								or  cac:Price/cbc:PriceType
								or  cac:Price/cac:AllowanceCharge)
							) " flag="fatal" >
					NSO_252 - La linea d’ordine contiene elementi non ammessi all’interno di "LineItem" (gli elementi ammessi sono: "ID", "Quantity", "Price", "Name"). The order line contains elements that are not allowed within "LineItem" (the allowed elements are: "ID", "Quantity", "Price", "Name").
			</assert>
			
		</rule>		
		
	</pattern>
	
    <!-- DEFINIZIONE PATTERN NELLA PHASE verificaCodiceIPA -->	
	<pattern id="verificaCodiceIPA">

		<rule context="/ubl:OrderResponse/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:OrderLine/cac:SellerSubstitutedLineItem/cac:Item/cac:StandardItemIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
		<rule context="/ubl:OrderResponse/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID">
			<extends rule="verifica_codice_ipa"/>
		</rule>	
		
	</pattern>
	
	<pattern id="verificaBuyer">
		
		<rule context="/ubl:OrderResponse/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_211"
                 test="if(@schemeID=0201) then true() else false()"
                 flag="fatal">NSO_211 - Il valore dell’attributo schemeID dell’elemento è errato (il valore corretto è "0201"). - The value of schemeID attribute of the element is incorrect (the correct value is "0201").
			</assert>
		</rule>
		
	</pattern>

	<pattern id="verificaCF">
		
		<rule context="/ubl:OrderResponse/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_220"
                 test="if((@schemeID=9907 or @schemeID=0210)) then u:checkCF(.) else true()"
                 flag="fatal">NSO_220 - Il Codice Fiscale indicato nell’elemento non è valido. - The Tax Code specified in the element is invalid.
			</assert>
		</rule>
		
	</pattern>	

    <!-- DEFINIZIONE PATTERN NELLA PHASE verificaPIVA -->
   <pattern id="verificaPIVA">

		<rule context="ubl:OrderResponse/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			
			<assert id="NSO_230"
                 test="if((@schemeID=9906 or @schemeID=0211)) then ( if(u:checkPIVA(substring(.,3,13))!=0) then false() else true() ) else true()" flag="fatal">
					NSO_230 - La partita IVA indicata nell’elemento non è valida. - The VAT number specified in the element is invalid.
			</assert>
			
		</rule>
		
	</pattern>

    <!-- DEFINIZIONE PATTERN NELLA PHASE verificaCIG -->
    <pattern id="verificaCIG">
	
		<rule context="/ubl:OrderResponse"> 
			<extends rule="define_tipologia_ordine"/>

			<assert id="NSO_261"
                 test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:OrderResponse/cac:OriginatorDocumentReference) and ( string-join(u:checkCIGLineaAlg(/ubl:OrderResponse/cac:OrderLine/cac:LineItem),'') eq '') ) then true() else false() ) )"
                 flag="fatal">NSO_261 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente. - The Tender Identification Code (CIG) or the Exemption Code is not present at the entire document level or in all order lines, or is present in both levels simultaneously.
			</assert>			

			<assert id="NSO_261"
                 test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( (/ubl:OrderResponse/cac:OriginatorDocumentReference) and  (string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:OrderResponse/cac:OrderLine/cac:LineItem)),'')) != 0 )) then true() else false() ) )"
                 flag="fatal">NSO_261 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente. - The Tender Identification Code (CIG) or the Exemption Code is not present at the entire document level or in all order lines, or is present in both levels simultaneously.
			</assert>

			<assert id="NSO_261"
                 test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:OrderResponse/cac:OriginatorDocumentReference) and not ( (count(/ubl:OrderResponse/cac:OrderLine)*4) = string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:OrderResponse/cac:OrderLine/cac:LineItem)),'')) )  )  then true() else false() ) )"
                 flag="fatal">NSO_261 - Il Codice Identificativo di Gara (CIG) o il Codice di esenzione non è presente a livello di intero Documento o in tutte linee d’ordine, oppure è presente in entrambi i livelli contemporaneamente. - The Tender Identification Code (CIG) or the Exemption Code is not present at the entire document level or in all order lines, or is present in both levels simultaneously.
			</assert>			

			<assert id="NSO_262"
                 test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( not (u:checkCIGLinea(/ubl:OrderResponse/cac:OrderLine/cac:LineItem)) ) )"
                 flag="fatal">NSO_262 - Una o più linee d’ordine contengono più di un Codice Identificativo di Gara (CIG) o Codice di esenzione. - One or more order lines contain more than one Tender Identification Code (CIG) or Exemption Code.
			</assert>
			
		</rule>
		
		<rule context="/ubl:OrderResponse/cac:OriginatorDocumentReference">
			<extends rule="define_tipologia_ordine"/>

			<assert id="NSO_260"
                 test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )"
                 flag="fatal">NSO_260 - Il Codice Identificativo di Gara (CIG o Smart CIG) o il Codice di esenzione indicato nell’elemento non è valido. - The Tender Identification Code (CIG or Smart CIG) or the Exemption Code specified in the element is invalid.
			</assert>
			
		</rule>
		
		<rule context="/ubl:OrderResponse/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
			<extends rule="define_tipologia_ordine"/>
		
			<assert id="NSO_260"
                 test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )"
                 flag="fatal">NSO_260 - Il Codice Identificativo di Gara (CIG o Smart CIG) o il Codice di esenzione indicato nell’elemento non è valido. - The Tender Identification Code (CIG or Smart CIG) or the Exemption Code specified in the element is invalid.
			</assert>
			
		</rule>
		
	</pattern>	
	
</schema>