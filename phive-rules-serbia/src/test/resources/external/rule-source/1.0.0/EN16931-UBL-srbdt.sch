<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.

-->

<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="UBL-srbdt">
  <rule context="cbc:CustomizationID" flag="fatal">
        <assert 
           test = "starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022')"
           id="RSR-01"
           flag="fatal">[RSR-01]-Identifikator specifikacije (BT-24) treba da počinje sa 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022'</assert>
  </rule>

   <rule context="sbt:SrbDtExt" flag="fatal">
   <assert 
           test = "starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022')"
           id="RSR-02"
           flag="fatal">[RSR-02]-Identifikator specifikacije (BT-24) fakture koja koristi ekstenzije treba da počinje sa 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022'</assert>
    
  </rule>

  <rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" flag="fatal">
    <assert
      test="(self::cbc:InvoiceTypeCode and 
                ( (not(contains(normalize-space(.), ' ')) and 
                   contains(' 380 383 386 ', 
                       concat(' ', normalize-space(.), ' '))))) or 
            (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and 
                    contains(' 381 ', concat(' ', normalize-space(.), ' ')))))" 
      id="RSR-03" 
      flag="fatal">[RSR-03]-Šifra vrste fakture (BT-3) treba da bude jedna od: 380, 381, 383 ili 386</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
     <assert
       test="not(exists(cbc:TaxPointDate))"
       id="RSR-04"
       flag="fatal">[RSR-04]-Faktura ne treba da sadrži element datum poreske obaveze (BT-7), umesto toga treba koristiti šifru datuma poreske obaveze (BT-8)</assert>
     <assert
       test="exists(/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode)"
       id="RSR-05"
       flag="fatal">[RSR-05]-Faktura treba da sadrži šifru datuma poreske obaveze (BT-8)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode">
    <assert
       test="(not(contains(normalize-space(.), ' ')) and 
                   contains(' 35 432 3 ', concat(' ', normalize-space(.), ' ')))"
       id="RSR-06"
       flag="fatal">[RSR-06]-Šifra datuma poreske obaveze (BT-8) treba da bude jedna od: 35 (prema datumu prometa), 432 (prema datumu plaćanja) ili 3 (prema datumu izdavanja fakture)</assert>
  </rule>

  <rule context="cac:BillingReference">
    <assert 
       test="exists(cac:InvoiceDocumentReference/cbc:IssueDate)" 
       flag="fatal" 
       id="RSR-07">[RSR-07]-Referenca na prethodnu fakturu (BG-3) treba da sadrži datum izdavanja prethodne fakture (BT-26).</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert 
      test="not (cac:InvoicePeriod/cbc:DescriptionCode = '432') or exists(/ubl:Invoice/cbc:DueDate | /cn:CreditNote/cac:PaymentMeans/cbc:PaymentDueDate)"
      flag="fatal"
      id="RSR-08">[RSR-08]-Kada šifra datuma poreske obaveze (BT-8) određuje da poreska obaveza nastaje prema datumu plaćanja (šifra 432) tada treba da je naveden datum dospeća plaćanja (BT-9)</assert>
    <assert
      test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID)"
      flag="fatal"
      id="RSR-09">[RSR-09]-Faktura treba da sadrži PIB prodavca (BT-31)</assert>
    <assert 
      test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID)"
      flag="fatal"
      id="RSR-10">[RSR-10]-Faktura treba da sadrži identifikator registracije poreza na strani prodavca (BT-32)</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID">
      <assert
        test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and
              (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))"
        flag="fatal"
        id="RSR-11">[RSR-11]-PIB prodavca (BT-31) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[normalize-space(upper-case(cbc:ID)) != 'VAT']">
      <assert
        test="upper-case(normalize-space(cbc:ID)) = 'RS-VAT-STATUS'"
        flag="fatal"
        id="RSR-12">[RSR-12]-Identifikatora registracije poreza na strani prodavca (BT-32) u UBL formatu treba da ima PartyTaxScheme ID sa vrednošću RS-VAT-STATUS</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingSupplierParty/cac:Party/cbc:EndpointID)"
      flag="fatal"
      id="RSR-13">[RSR-13]-Faktura treba da sadrži elektronsku adresu prodavca (BT-34)</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
    <assert
      test="normalize-space(@schemeID) = '9948'"
      flag="fatal"
      id="RSR-14">[RSR-14]-Elektronska adresa prodavca (BT-34) treba da ima identifikator šeme '9948'</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
    <assert 
      test="concat('RS',normalize-space(.)) = 
             normalize-space(upper-case(../cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID))"
      flag="fatal"
      id="RSR-15">[RSR-15]-Elektronska adresa prodavca (BT-34) treba da sadrži PIB prodavca (BT-31) bez prefiksa 'RS'</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)"
      flag="fatal"
      id="RSR-16">[RSR-16]-Faktura treba da sadrži mesto prodavca (BT-37)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)"
      flag="fatal"
      id="RSR-17">[RSR-17]-Faktura treba da sadrži matični broj kupca (BT-47)</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
    <assert
      test="not(exists(@schemeID))"
      flag="fatal"
      id="RSR-18">[RSR-18]-Matični broj kupca (BT-47) ne treba da ima identifikator šeme</assert>
    <assert
        test="(matches(normalize-space(.),'^[0-9]+$')) and
              (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))"
        flag="fatal"
        id="RSR-19">[RSR-19]-Matični broj kupca (BT-47) treba da ima 8 ili 13 cifara</assert> 
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)"
      flag="fatal"
      id="RSR-20">[RSR-20]-Faktura treba da sadrži PIB kupca (BT-48)</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
      <assert
        test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and
              (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))"
        flag="fatal"
        id="RSR-21">[RSR-21]-PIB kupca (BT-48) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID)"
      flag="fatal"
      id="RSR-22">[RSR-22]-Faktura treba da sadrži elektronsku adresu kupca (BT-49)</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
    <assert
      test="normalize-space(@schemeID) = '9948'"
      flag="fatal"
      id="RSR-23">[RSR-23]-Elektronska adresa kupca (BT-49) treba da ima identifikator šeme '9948'</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
    <assert 
      test="concat('RS',normalize-space(.)) = 
             normalize-space(upper-case(../cac:PartyTaxScheme/cbc:CompanyID))"
      flag="fatal"
      id="RSR-24">[RSR-24]-Elektronska adresa kupca (BT-49) treba da sadrži PIB kupca (BT-48) bez prefiksa 'RS'</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)"
      flag="fatal"
      id="RSR-25">[RSR-25]-Faktura treba da sadrži mesto kupca (BT-52)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)"
      flag="fatal"
      id="RSR-26">[RSR-26]-Faktura treba da sadrži poštanski broj kupca (BT-53)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:PayeeParty | /cn:CreditNote/cac:PayeeParty" flag="fatal">
    <assert
       test="count(cac:PartyLegalEntity/cbc:CompanyID) = 1"
       flag="fatal"
       id="RSR-27">[RSR-27]-Primalac plaćanja (BG-10) treba da ima tačno jedan matični broj primaoca plaćanja (BT-61)</assert>
  </rule>

  <rule context="cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID" flag="fatal">
     <assert
        test="(matches(normalize-space(.),'^[0-9]+$')) and
              (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))"
        flag="fatal"
        id="RSR-28">[RSR-28]-Matični broj primaoca plaćanja (BT-61) treba da ima 8 ili 13 cifara</assert> 
  </rule>

  <rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" flag="fatal">
    <assert
      test="exists(cac:PartyTaxScheme/cbc:CompanyID)"
      flag="fatal"
      id="RSR-29">[RSR-29]-Poreski punomoćnik prodavca (BG-11) treba da sadrži PIB poreskog punomoćnika (BT-63)</assert>
  </rule>

  <rule context="cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID">
      <assert
        test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and
              (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))"
        flag="fatal"
        id="RSR-30">[RSR-30]-PIB poreskog punomoćnika prodavca (BT-63) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" flag="fatal">
    <assert
      test="exists(cac:PostalAddress/cbc:CityName)"
      flag="fatal"
      id="RSR-31">[RSR-31]-Poreski punomoćnik prodavca (BG-11) treba da sadrži mesto poreskog punomoćnika (BT-66)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" flag="fatal">
    <assert
      test="exists(cac:PostalAddress/cbc:PostalZone)"
      flag="fatal"
      id="RSR-32">[RSR-32]-Poreski punomoćnik prodavca (BG-11) treba da sadrži poštanski broj poreskog punomoćnika (BT-67)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert 
      test="not(cac:InvoicePeriod/cbc:DescriptionCode = '35') or exists(cac:Delivery/cbc:ActualDeliveryDate)"
      flag="fatal"
      id="RSR-33">[RSR-33]-Kada šifra datuma poreske obaveze (BT-8) određuje da poreska obaveza nastaje prema datumu prometa (šifra 35) tada treba da je naveden datum prometa (BT-72)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID | /cn:CreditNote/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RSR-34" 
      flag="fatal">[RSR-34]-Šifra kategorije PDV-a za popust/trošak na nivou dokumneta (BT-95/BT-102) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RSR-35" 
      flag="fatal">[RSR-35]-Šifra kategorije PDV-a (BT-118) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>
  
  <rule context="cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RSR-36" 
      flag="fatal">[RSR-36]-Šifra kategorije PDV-a za stavku (BT-151) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>

  <rule context="sbt:SrbDtExt/sbt:InvoicedPrepaymentAmmount/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RSE-01" 
      flag="fatal">[RSE-01]-Šifra kategorije PDV-a na avansu (BT-Е4) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>

  <rule context="sbt:SrbDtExt/sbt:ReducedTotals/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RSE-02" 
      flag="fatal">[RSE-02]-Šifra kategorije PDV-a na umanjenom iznosu (BT-Е8) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>

  <rule context="sbt:SrbDtExt/sbt:ReducedTotals" flag="fatal">
    <assert 
      test="(exists(/ubl:Invoice) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) = 
              xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) - xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount))) or
            (exists(/cn:CreditNote) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) = 
              xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) - xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:PrepaidAmount)))"
      id="RSE-03"
      flag="fatal">[RSE-03]-Umanjen ukupan iznos bez PDV-a (BT-Е10) treba da bude jednak razlici ukupnog iznosa sa PDV-om (BT-112) i plaćenog iznosa (BT-113)</assert>
  </rule>
</pattern>