## Sources

https://www.mvcr.cz/isdoc/clanek/aktualni-verze.aspx
http://www.isdoc.cz/6.0/readme-cs.html
http://www.isdoc.cz/fileadmin/isdoc/6.0/isdoc-schema-6.0.1-20140526.zip
http://www.isdoc.cz/fileadmin/isdoc/isdoc-schema-5.3.1-20111230.zip

## Errors in on v6.0.2

assertion line 222:

```
            <sch:assert test="every $va in isdoc:InvoiceLines/isdoc:InvoiceLine/isdoc:ClassifiedTaxCategory/isdoc:VATApplicable satisfied $va = 'false'">Je-li doklad nedaňový (element VATApplicable obsahuje hodnotu
```

Instead of `satisfied` it should be `satisfies`


assertion line 238:

```xml
            <sch:assert test="if (isdoc:InvoicedQuantity/@unitCode) then                                 every $q in isdoc:Item/isdoc:StoreBatches/isdoc:StoreBatch/isdoc:Quantity) satisfies $q/@unitCode = isdoc:InvoicedQuantity/@unitCode                               else true()">Jednotka v rozpisu všech šarží/sériových čísel (element StoreBatches) musí
```

Here the closing bracket after "Quantity" is the problem. Adding an opening bracket resolves the issue:

```xml
            <sch:assert test="if (isdoc:InvoicedQuantity/@unitCode) then                                 every $q in (isdoc:Item/isdoc:StoreBatches/isdoc:StoreBatch/isdoc:Quantity) satisfies $q/@unitCode = isdoc:InvoicedQuantity/@unitCode                               else true()">Jednotka v rozpisu všech šarží/sériových čísel (element StoreBatches) musí
```
