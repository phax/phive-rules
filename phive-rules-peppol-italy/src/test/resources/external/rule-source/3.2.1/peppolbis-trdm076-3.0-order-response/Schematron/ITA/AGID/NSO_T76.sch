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
   
    <!-- La funzione estrae la stringa posizionale in un takenize di # -->
   	<function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:getPartTokenizeID" as="xs:string">		 
		<param name="reference" as="xs:string"/>
		<param name="arg" as="xs:integer"/>
	  
		<variable name="listToken" select="tokenize($reference, '#')" /> 

		<sequence select="$listToken[$arg]"/>
	 		
	</function>
	
	<!-- La funzione estrae il numero di stringhe in un takenize di # -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:countDelitited" as="xs:integer">		 
      <param name="reference" as="xs:string"/>
	  <variable name="stringList" select="tokenize($reference, '#')"/>
	  
	  <sequence select="count($stringList) - 1"/>
		
	</function>
   
	<!-- Controllo se la data è valida -->
	<function name="u:validationDate" as="xs:boolean"
              xmlns="http://www.w3.org/1999/XSL/Transform">
		
		<param name="arg" as="xs:string?"/>

		<sequence select="string(normalize-space($arg)) castable as xs:date"/>

	</function>
	
	<!-- Controllo della PIVA secondo le regole https://databularium.com/it/2015/08/21/come-controllare-la-correttezza-della-partita-iva/ -->
    <function name="u:checkPIVA" as="xs:integer"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="xs:string?"/>
		
		<sequence select="
				if (not($arg castable as xsd:integer)) 
					then 1
					else ( u:addPIVA($arg,xs:integer(0)) mod 10 )" />
		
    </function>
	
	<!-- Funzione di utilità per il controllo della PIVA -->
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

	<!-- Funzione di utilità per il controllo del EndpointID -->
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
	
	<!-- Controllo Codice Fiscale-->
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

	<!-- Controllo Codice Fiscale 16 -->
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
	
	<!-- Controllo Codice Fiscale 11 -->
    <function name="u:checkCF11" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="xs:string?"/>
		
		<sequence select="
					if ( ($arg castable as xsd:integer) and (string-length($arg) = 11) ) 
					then true()
					else false()
					" />
					
    </function>	
	
	<!-- Controllo Codice IPA -->
    <function name="u:checkCodiceIPA" as="xs:boolean"
			  xmlns="http://www.w3.org/1999/XSL/Transform">

        <param name="arg" as="xs:string?"/>
		
		<variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>

		<sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
		
    </function>
	
    <!-- DEFINIZIONE PHASE -->
    <phase id="underConstruction">
	   <active pattern="verificaOrderReferenceID"/>
	   <active pattern="verificaPIVA"/>	   	   
	   <active pattern="verificaLinee"/>	
	   <active pattern="verificaCodiceIPA"/>
	   <active pattern="verificaBuyer"/>
	   <active pattern="verificaCF"/>  	   
    </phase>

    <!-- DEFINIZIONE ABSTRACT ROLE PATTERN -->	
	<pattern id="Abstract">
		
		<rule abstract="true" id="verifica_codice_ipa">	
			
			<assert id="NSO_110" 
				test="if(@schemeID=0201) then u:checkCodiceIPA(.) else true()" flag="fatal">NSO_110 - Il Codice IPA indicato nell’elemento non è valido.
			</assert>

		</rule>
		
	</pattern>

    <!-- DEFINIZIONE PATTERN NELLA PHASE verificaOrderReferenceID -->
    <pattern id="verificaOrderReferenceID">

		<!-- Verifica cac:OrderReference sia presente una sola volta -->	
		<rule context="ubl:OrderResponse">
								
			<assert id="NSO_145" test="count(/ubl:OrderResponse/cac:OrderReference) = 1" flag="fatal">
				NSO_145 - Il Documento contiene più di un elemento "cac:OrderReference".
			</assert>

		</rule>
		
		<!-- Verifica struttura cac:OrderReference/cbc:ID -->	
		<rule context="ubl:OrderResponse/cac:OrderReference/cbc:ID">
					
			
			<assert id="NSO_140" test="(u:countDelitited(.) = 2)" flag="fatal">
				NSO_140 - Il formato dell’elemento "cac:OrderReference/cbc:ID" non è valido (esempio di formato corretto: "110#2018-01-30#QLHCFC ").
			</assert>

			<assert id="NSO_141" test="(if (u:countDelitited(.) != 2) then false() else u:getPartTokenizeID(.,1)!='')" flag="fatal">
				NSO_141 - L'ID presente nell’elemento non è valorizzato.
			</assert>			

			<assert id="NSO_142" test="(if (u:countDelitited(.) != 2) then false() else u:validationDate(u:getPartTokenizeID(.,2)))" flag="fatal">
				NSO_142 - Il formato della data presente nell’elemento non è corretto (esempio corretto: "2020-01-31").
			</assert>

			<assert id="NSO_143" test="((( if (u:countDelitited(.) != 2) then false() else string-length(u:getPartTokenizeID(.,3))=6 )))" flag="fatal">
				NSO_143 - L'EndpointID indicato nell’elemento non è un valore valido (esempio di valore corretto: "QLHCFC").
			</assert>

		</rule>

	</pattern>
	
   <pattern id="verificaPIVA">

		<!-- Controllo della PIVA secondo le regole https://databularium.com/it/2015/08/21/come-controllare-la-correttezza-della-partita-iva/ -->
		<rule context="ubl:OrderResponse/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">

			<!-- nel caso in cui schemeID = 9906 oppure 0211 l'endpointID deve contenere una partita iva formalmente corretta -->
			<assert id="NSO_130"
                 test="if((@schemeID=9906 or @schemeID=0211)) then ( if(u:checkPIVA(substring(.,3,13))!=0) then false() else true() ) else true()" flag="fatal">
					NSO_130 - La partita IVA indicata nell’elemento non è valida.
			</assert>
			
		</rule>
		
	</pattern>	

   <pattern id="verificaLinee">

		<rule context="ubl:OrderResponse">

			<!-- le rige ordine sono permesse sono nel caso di modifica CA -->			
			<assert id="NSO_150" test="( if (/ubl:OrderResponse/cbc:OrderResponseCode = 'CA') then ( if (count(/ubl:OrderResponse/cac:OrderLine)=0) then false() else true() ) else ( if (count(/ubl:OrderResponse/cac:OrderLine)=0) then true() else false() ) )" flag="fatal">
				NSO_150 - Il Documento deve contenere uno o piu elementi "cac:OrderLine" solo se si tratta di una Risposta con modifica. - The Document must contain one or more "cac:OrderLine" elements only in Order response with change.
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
	
	<!-- Verifica Buyer: schemaID dell'Endopoint deve essere sempre 0201 -->	
	<pattern id="verificaBuyer">
		
		<rule context="/ubl:OrderResponse/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_111"
                 test="if(@schemeID=0201) then true() else false()"
                 flag="fatal">NSO_111 - Il valore dell’attributo schemeID dell’elemento è errato (il valore corretto è "0201"). The value of schemeID attribute of the element is incorrect (the correct value is "0201").
			</assert>
		</rule>
		
	</pattern>

    <!--  CF da 16 (verificare solo struttura, no controlli di merito) o CF da 11  (11 numeri senza IT);  -->	
	<pattern id="verificaCF">
		
		<rule context="/ubl:OrderResponse/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_120"
                 test="if((@schemeID=9907 or @schemeID=0210)) then u:checkCF(.) else true()"
                 flag="fatal">NSO_120 - Il Codice Fiscale indicato nell’elemento non è valido.
			</assert>
		</rule>

		<!--<rule context="/ubl:OrderResponse/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
			<assert id="NSO_120"
                 test="if((@schemeID=9907 or @schemeID=0210)) then u:checkCF(.) else true()"
                 flag="fatal">NSO_120 - Il Codice Fiscale indicato nell’elemento non è valido.
			</assert>
		</rule>-->
		
	</pattern>	
	
</schema>