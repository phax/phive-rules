package com.helger.phive.peppol.legacy;

import javax.annotation.Nonnull;
import javax.xml.XMLConstants;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

public class PeppolLegacyThirdpartyValidation
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyThirdpartyValidation.class.getClassLoader ();
  }

  // Third-party
  public static final VESID VID_OPENPEPPOL_T10_V2_5_AT = new VESID ("eu.peppol.bis2", "t10", "6", "at");
  public static final VESID VID_OPENPEPPOL_T10_V2_7_AT_GOV = new VESID ("eu.peppol.bis2", "t10", "8", "at-gov");
  public static final VESID VID_OPENPEPPOL_T14_V2_5_AT = new VESID ("eu.peppol.bis2", "t14", "6", "at");
  public static final VESID VID_OPENPEPPOL_T14_V2_7_AT_GOV = new VESID ("eu.peppol.bis2", "t14", "8", "at-gov");

  public static final ClassPathResource INVOICE_AT_NAT = new ClassPathResource ("/thirdparty/atnat-invoice/atnat-invoice-ubl.xslt",
                                                                                _getCL ());
  public static final ClassPathResource INVOICE_AT_GOV = new ClassPathResource ("/thirdparty/atgov-invoice/atgov-invoice-ubl.xslt",
                                                                                _getCL ());

  public static final ClassPathResource CREDIT_NOTE_AT_NAT = new ClassPathResource ("/thirdparty/atnat-creditnote/atnat-creditnote-ubl.xslt",
                                                                                    _getCL ());
  public static final ClassPathResource CREDIT_NOTE_AT_GOV = new ClassPathResource ("/thirdparty/atgov-creditnote/atgov-creditnote-ubl.xslt",
                                                                                    _getCL ());

  @Nonnull
  @ReturnsMutableObject
  static MapBasedNamespaceContext createUBLNSContext (@Nonnull final String sNamespaceURI)
  {
    final MapBasedNamespaceContext aNSContext = UBL21NamespaceContext.getInstance ().getClone ();

    // Add the default mapping for the root namespace
    aNSContext.addMapping (XMLConstants.DEFAULT_NS_PREFIX, sNamespaceURI);
    // For historical reasons, the "ubl" prefix is also mapped to this
    // namespace URI
    aNSContext.addMapping ("ubl", sNamespaceURI);
    return aNSContext;
  }

  @SuppressWarnings ("deprecation")
  public static void initThirdParty (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    // Extending third-party artefacts
    final IValidationExecutorSet <IValidationSourceXML> aVESInvoice = aRegistry.getOfID (PeppolValidation370.VID_OPENPEPPOL_T10_V2);
    final IValidationExecutorSet <IValidationSourceXML> aVESCreditNote = aRegistry.getOfID (PeppolValidation370.VID_OPENPEPPOL_T14_V2);
    if (aVESInvoice == null || aVESCreditNote == null)
      throw new IllegalStateException ("Standard PEPPOL artefacts must be registered before third-party artefacts!");

    final String sPreReqInvoice = "/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'";
    final String sPreReqCreditNote = "/ubl:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'";

    final boolean bNotDeprecated = false;
    // Invoice
    final IValidationExecutorSet <IValidationSourceXML> aVESInvoiceAT = ValidationExecutorSet.createDerived (aVESInvoice,
                                                                                                             VID_OPENPEPPOL_T10_V2_5_AT,
                                                                                                             "OpenPEPPOL Invoice (Austria)",
                                                                                                             bNotDeprecated,
                                                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_AT_NAT,
                                                                                                                                                      sPreReqInvoice,
                                                                                                                                                      createUBLNSContext (EUBL21DocumentType.INVOICE.getNamespaceURI ())));
    aRegistry.registerValidationExecutorSet (aVESInvoiceAT);
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESInvoiceAT,
                                                                                  VID_OPENPEPPOL_T10_V2_7_AT_GOV,
                                                                                  "OpenPEPPOL Invoice (Austrian Government)",
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (INVOICE_AT_GOV,
                                                                                                                           sPreReqInvoice,
                                                                                                                           createUBLNSContext (EUBL21DocumentType.INVOICE.getNamespaceURI ()))));

    // CreditNote
    final IValidationExecutorSet <IValidationSourceXML> aVESCreditNoteAT = ValidationExecutorSet.createDerived (aVESCreditNote,
                                                                                                                VID_OPENPEPPOL_T14_V2_5_AT,
                                                                                                                "OpenPEPPOL Credit Note (Austria)",
                                                                                                                bNotDeprecated,
                                                                                                                ValidationExecutorSchematron.createXSLT (CREDIT_NOTE_AT_NAT,
                                                                                                                                                         sPreReqCreditNote,
                                                                                                                                                         createUBLNSContext (EUBL21DocumentType.CREDIT_NOTE.getNamespaceURI ())));
    aRegistry.registerValidationExecutorSet (aVESCreditNoteAT);
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCreditNoteAT,
                                                                                  VID_OPENPEPPOL_T14_V2_7_AT_GOV,
                                                                                  "OpenPEPPOL Credit Note (Austrian Government)",
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (CREDIT_NOTE_AT_GOV,
                                                                                                                           sPreReqCreditNote,
                                                                                                                           createUBLNSContext (EUBL21DocumentType.CREDIT_NOTE.getNamespaceURI ()))));
  }

}
