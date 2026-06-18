<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="pdvcat">
  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
      <assert 
        test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = '$PDVCATCODE']) or 
                exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = '$PDVCATCODE'])) and 
               (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = '$PDVCATCODE']) = 1)) or 
                (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = '$PDVCATCODE']) and 
                  not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = '$PDVCATCODE']))"
        flag="fatal" id="RSK-X-01">[$RSK-X-01]-Faktura koja sadrži stavku fakture (BG-25), popust na nivou dokumenta (BG-20) ili troškove na nivou dokumenta (BG-21) sa šifrom PDV kategorije (BT-151, BT-95 odnosno BT-102) jednakom '$PDVCATCODE' treba da sadrži tačno jedan poreski međuzbir (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom '$PDVCATCODE'.</assert>
  </rule>
  <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = '$PDVCATCODE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
                  cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = '$PDVCATCODE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert 
      test="(xs:decimal(cbc:Percent) = 0)" 
      flag="fatal" 
      id="RSK-X-05">[$RSK-X-05]-Stavka fakture (BG-25) sa šifrom PDV kategorije (BT-151) jednakom '$PDVCATCODE', treba da ima stopu PDV-a (BT-152) jednaku nuli.</assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='$PDVCATCODE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert 
      test="(xs:decimal(cbc:Percent) = 0)" 
      flag="fatal" 
      id="RSK-X-06">[$RSK-X-06]-U popustu na nivou dokumenta (BG-20) za šifru kategorije PDV-a (BT-95) jednaku '$PDVCATCODE', stopa PDV-a (BT-96) treba da je nula.</assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='$PDVCATCODE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert 
       test="(xs:decimal(cbc:Percent) = 0)" 
       flag="fatal" id="RSK-X-07">[$RSK-X-07]-U trošku na nivou dokumenta (BG-21) sa kategorijom PDV-a (BT-102) jednakom '$PDVCATCODE', stopa PDV-a (BT-103) treba da je nula.</assert>
  </rule>
  <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = '$PDVCATCODE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert 
      test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (
              sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='$PDVCATCODE']/xs:decimal(cbc:LineExtensionAmount)) + 
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - 
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or 
            (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (
              sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + 
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - 
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" 
      flag="fatal" 
      id="RSK-X-08">[$RSK-X-08]-U poreskom međuzbiru (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom '$PDVCATCODE', iznos osnovice (BT-116) treba da je jednak zbiru neto iznosa stavki (BT-131) umanjenog za zbir popusta na nivou dokumenta (BT-92) i uvećanog za zbir troškova na nivou dokumenta (BT-99) gde je šifra kategorije PDV-a (BT-151, BT-95, BT-102) jednaka '$PDVCATCODE'.</assert>
    <assert 
      test="xs:decimal(../cbc:TaxAmount) = 0" 
      flag="fatal" 
      id="RSK-X-09">[$RSK-X-09]-Iznos poreza za kategoriju PDV-a '$PDVCATCODE' (BT-117, BT-118) u poreskom međuzbiru (BG-23) treba da je jednak nuli.</assert>
    <assert 
      test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" 
      flag="fatal" 
      id="RSK-X-10">[$RSK-X-10]-Poreski međuzbir (BG-23) sa kategorijom PDV-a (BT-118) jednakom '$PDVCATCODE' treba da sadrži šifru ili tekst osnova izuzeće od PDV (BT-121, BT-120).</assert>
  </rule>
</pattern>
