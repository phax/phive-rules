<pattern
        xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

        <title>Danish OIOUBL 3 - Excluded elements</title>


        <rule
                context="/">

                <assert
                        id="OIOUBL-COMMON-020"
                        test="not(.//cac:Signature/cac:SignatoryParty/cac:PostalAddress)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Signature/cac:SignatoryParty/cac:PostalAddress'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-021"
                        test="not(.//cac:OrderReference/cac:DocumentReference)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:OrderReference/cac:DocumentReference'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-022"
                        test="not(.//cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-023"
                        test="not(.//cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:SelfBilledInvoiceDocumentReference'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-024"
                        test="not(.//cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-025"
                        test="not(.//cac:BillingReference/cac:DebitNoteDocumentReference)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:DebitNoteDocumentReference'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-026"
                        test="not(.//cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-027"
                        test="not(.//cac:Delivery/cac:DeliveryAddress)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryAddress'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-028"
                        test="not(.//cac:Delivery/cac:CarrierParty)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:CarrierParty'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-029"
                        test="not(.//cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-030"
                        test="not(.//cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-031"
                        test="not(.//cac:BillingReference/cac:AdditionalDocumentReference)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:BillingReference/cac:AdditionalDocumentReference'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-032"
                        test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-033"
                        test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-034"
                        test="not(.//cac:PaymentMeans/cbc:PaymentDueDate)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:PaymentMeans/cbc:PaymentDueDate'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-035"
                        test="not(.//cac:AllowanceCharge/cac:PaymentMeans)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:AllowanceCharge/cac:PaymentMeans'), '(/Q\{[^}]+\})', '/')"/></assert>


                <assert
                        id="OIOUBL-COMMON-037"
                        test="not(.//cac:AllowanceCharge/cac:Taxtotal)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:AllowanceCharge/cac:Taxtotal'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-038"
                        test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:Percent'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-039"
                        test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-040"
                        test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-041"
                        test="not(.//cac:Person)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Person'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-043"
                        test="not(.//cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject'), '(/Q\{[^}]+\})', '/')"/></assert>

        </rule>



        <rule
                context="cac:InvoiceLine | cac:CreditNoteLine">

                <assert
                        id="OIOUBL-COMMON-052"
                        test="not(cac:Delivery/cbc:LatestDeliveryDate)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cbc:LatestDeliveryDate'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-053"
                        test="not(cac:Delivery/cbc:LatestDeliveryTime)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cbc:LatestDeliveryTime'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-054"
                        test="not(cac:Delivery/cac:DeliveryAddress)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryAddress'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-055"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-056"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-057"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-058"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-059"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms'), '(/Q\{[^}]+\})', '/')"/></assert>
                <assert
                        id="OIOUBL-COMMON-060"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-061"
                        test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-062"
                        test="not(cac:PaymentTerms)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:PaymentTerms'), '(/Q\{[^}]+\})', '/')"/></assert>
                <assert
                        id="OIOUBL-COMMON-063"
                        test="not(cac:Item/cac:TransactionConditions)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Item/cac:TransactionConditions'), '(/Q\{[^}]+\})', '/')"/></assert>

                <assert
                        id="OIOUBL-COMMON-064"
                        test="not(cac:Price/cac:AllowanceCharge/cac:PaymentMeans)"
                        flag="fatal">The use of element is not allowed - <value-of select="replace(concat(path(), '/cac:Price/cac:AllowanceCharge/cac:PaymentMeans'), '(/Q\{[^}]+\})', '/')"/></assert>


        </rule>
</pattern>
