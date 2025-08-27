/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.phive.peppol.italy.mock;

import static org.junit.Assert.assertTrue;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.peppol.italy.PeppolItalyValidation;
import com.helger.phive.peppol.italy.PeppolItalyValidation2_2_9;
import com.helger.phive.peppol.italy.PeppolItalyValidation2_3_0;
import com.helger.phive.peppol.italy.PeppolItalyValidation3_0_2;
import com.helger.phive.peppol.italy.PeppolItalyValidation3_1_0;
import com.helger.phive.peppol.italy.PeppolItalyValidation3_2_1;
import com.helger.phive.xml.source.IValidationSourceXML;

import jakarta.annotation.Nonnull;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolItalyValidation.init (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { PeppolItalyValidation2_2_9.VID_DESPATCH_ADVICE,
                                                            PeppolItalyValidation2_2_9.VID_ORDER,
                                                            PeppolItalyValidation2_2_9.VID_ORDER_RESPONSE,

                                                            PeppolItalyValidation2_3_0.VID_DESPATCH_ADVICE,
                                                            PeppolItalyValidation2_3_0.VID_INVOICE,
                                                            PeppolItalyValidation2_3_0.VID_ORDER,
                                                            PeppolItalyValidation2_3_0.VID_ORDER_AGREEMENT,
                                                            PeppolItalyValidation2_3_0.VID_ORDER_RESPONSE,

                                                            PeppolItalyValidation3_0_2.VID_CREDIT_NOTE,
                                                            PeppolItalyValidation3_0_2.VID_DESPATCH_ADVICE,
                                                            PeppolItalyValidation3_0_2.VID_INVOICE,
                                                            PeppolItalyValidation3_0_2.VID_ORDER,
                                                            PeppolItalyValidation3_0_2.VID_ORDER_AGREEMENT,
                                                            PeppolItalyValidation3_0_2.VID_ORDER_RESPONSE,

                                                            PeppolItalyValidation3_1_0.VID_CREDIT_NOTE,
                                                            PeppolItalyValidation3_1_0.VID_DESPATCH_ADVICE,
                                                            PeppolItalyValidation3_1_0.VID_INVOICE,
                                                            PeppolItalyValidation3_1_0.VID_ORDER,
                                                            PeppolItalyValidation3_1_0.VID_ORDER_AGREEMENT,
                                                            PeppolItalyValidation3_1_0.VID_ORDER_RESPONSE,

                                                            PeppolItalyValidation3_2_1.VID_CREDIT_NOTE,
                                                            PeppolItalyValidation3_2_1.VID_DESPATCH_ADVICE,
                                                            PeppolItalyValidation3_2_1.VID_INVOICE,
                                                            PeppolItalyValidation3_2_1.VID_ORDER,
                                                            PeppolItalyValidation3_2_1.VID_ORDER_AGREEMENT,
                                                            PeppolItalyValidation3_2_1.VID_ORDER_RESPONSE, })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    // 2.2.9
    final String sTestFiles229 = "src/test/resources/external/test-files/2.2.9/";
    if (aVESID.equals (PeppolItalyValidation2_2_9.VID_DESPATCH_ADVICE))
    {
      final String sBase = sTestFiles229 + "despatch-advice/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Spedizione semplice.xml",
                                                      "Caso d'uso 2 - Spedizione semplice con quantita' inevasa.xml",
                                                      "Caso d'uso 3 - Spedizione con unita' logistica utilizzando le chiavi GS1.xml",
                                                      "Caso d'uso 4  - Spedizione con indicazione del peso, lunghezza e-o volume degli articoli merce.xml",
                                                      "Caso d'uso 5 -  Spedizione avanzata con l'uso della maggior parte delle informazioni di business.xml",
                                                      "Esempio DDT con Diversi Ordini.xml",
                                                      "Esempio DDT con Gestione Temperatura e Merce Pericolosa.xml",
                                                      "Esempio DDT con Indicazione Segnacollo.xml",
                                                      "Esempio DDT con Ordine a Confezione 02.xml",
                                                      "Esempio DDT con Ordine a Singola Unita' 01.xml",
                                                      "Esempio DDT con Quantita' Inevasa.xml",
                                                      "Esempio DDT con Reintegro e Lotto.xml",
                                                      "Esempio DDT con Reintegro e Omaggio.xml",
                                                      "Esempio DDT con Singolo Ordine.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation2_2_9.VID_ORDER))
    {
      final String sBase = sTestFiles229 + "order/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Ordine di fornitura con articoli numerati.xml",
                                                      "Caso d'uso 2 - Ordine di fornitura con articoli e un allegato.xml",
                                                      "Caso d'uso 3 - Ordine di fornitura con servizi.xml",
                                                      "Caso d'uso 4 - Ordine di fornitura complesso.xml",
                                                      "Esempio Ordine Collegato di Regolazione.xml",
                                                      "Esempio Ordine Revisionato a Budget.xml",
                                                      "Esempio Ordine di Acquisto con Arrotondamento.xml",
                                                      "Esempio Ordine di Acquisto con Gestione CIG Esenzione Riga.xml",
                                                      "Esempio Ordine di Acquisto con Gestione CIG Riga.xml",
                                                      "Esempio Ordine di Acquisto con Omaggio.xml",
                                                      "Esempio Ordine di Acquisto con Sconto Merce.xml",
                                                      "Esempio Ordine di Acquisto per Fornitore Estero.xml",
                                                      "Esempio Ordine di Consegna Cancellato senza Righe.xml",
                                                      "Esempio Ordine di Consegna con Gestione CIG Esenzione Testata.xml",
                                                      "Esempio Ordine di Consegna con Gestione CIG Testata.xml",
                                                      "Esempio Ordine di Consegna con Gestione Codice GTIN.xml",
                                                      "Esempio Ordine di Consegna per Comodato d'uso gratuito con Kit 02.xml",
                                                      "Esempio Ordine di Consegna per Conto Deposito con Confezione.xml",
                                                      "Esempio Ordine di Consegna per Conto Deposito con Lotto e Seriale.xml",
                                                      "Esempio Ordine di Consegna per Conto Visione con Kit 01.xml",
                                                      "Esempio Ordine di Convalida.xml",
                                                      "Esempio Ordine di Fatturazione e Reintegro di un DM..xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation2_2_9.VID_ORDER_RESPONSE))
    {
      final String sBase = sTestFiles229 + "order-response/";
      return new CommonsArrayList <> (new String [] { "ph1.xml" }, x -> new FileSystemResource (sBase + x));
    }

    // 2.3.0
    final String sTestFiles230 = "src/test/resources/external/test-files/2.3.0/";
    if (aVESID.equals (PeppolItalyValidation2_3_0.VID_DESPATCH_ADVICE))
    {
      final String sBase = sTestFiles230 + "despatch-advice/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Spedizione semplice.xml",
                                                      "Caso d'uso 2 - Spedizione semplice con quantita' inevasa.xml",
                                                      "Caso d'uso 3 - Spedizione con unita' logistica utilizzando le chiavi GS1.xml",
                                                      "Caso d'uso 4  - Spedizione con indicazione del peso, lunghezza e-o volume degli articoli merce.xml",
                                                      "Caso d'uso 5 -  Spedizione avanzata con l'uso della maggior parte delle informazioni di business.xml",
                                                      "Esempio DDT con Diversi Ordini.xml",
                                                      "Esempio DDT con Gestione Temperatura e Merce Pericolosa.xml",
                                                      "Esempio DDT con Indicazione Segnacollo.xml",
                                                      "Esempio DDT con Ordine a Confezione 02.xml",
                                                      "Esempio DDT con Ordine a Singola Unita' 01.xml",
                                                      "Esempio DDT con Quantita' Inevasa.xml",
                                                      "Esempio DDT con Reintegro e Lotto.xml",
                                                      "Esempio DDT con Reintegro e Omaggio.xml",
                                                      "Esempio DDT con Singolo Ordine.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation2_3_0.VID_INVOICE))
    {
      // None
      return new CommonsArrayList <> ();
    }

    if (aVESID.equals (PeppolItalyValidation2_3_0.VID_ORDER))
    {
      final String sBase = sTestFiles230 + "order/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Ordine di fornitura con articoli numerati.xml",
                                                      "Caso d'uso 2 - Ordine di fornitura di articoli in testo libero.xml",
                                                      "Caso d'uso 3 - Ordine di fornitura con servizi.xml",
                                                      "Caso d'uso 4 - Ordine di fornitura complesso.xml",
                                                      "Esempio Ordine Collegato di Regolazione.xml",
                                                      "Esempio Ordine Revisionato a Budget.xml",
                                                      "Esempio Ordine di Acquisto con Arrotondamento.xml",
                                                      "Esempio Ordine di Acquisto con Gestione CIG Esenzione Riga.xml",
                                                      "Esempio Ordine di Acquisto con Gestione CIG Riga.xml",
                                                      "Esempio Ordine di Acquisto con Omaggio.xml",
                                                      "Esempio Ordine di Acquisto con Sconto Merce.xml",
                                                      "Esempio Ordine di Acquisto per Fornitore Estero.xml",
                                                      "Esempio Ordine di Consegna Cancellato senza Righe.xml",
                                                      "Esempio Ordine di Consegna con Gestione CIG Esenzione Testata.xml",
                                                      "Esempio Ordine di Consegna con Gestione CIG Testata.xml",
                                                      "Esempio Ordine di Consegna con Gestione Codice GTIN.xml",
                                                      "Esempio Ordine di Consegna per Comodato d'uso gratuito con Kit 02.xml",
                                                      "Esempio Ordine di Consegna per Conto Deposito con Confezione.xml",
                                                      "Esempio Ordine di Consegna per Conto Deposito con Lotto e Seriale.xml",
                                                      "Esempio Ordine di Consegna per Conto Visione con Kit 01.xml",
                                                      "Esempio Ordine di Convalida.xml",
                                                      "Esempio Ordine di Fatturazione e Reintegro di un DM..xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation2_3_0.VID_ORDER_AGREEMENT))
    {
      final String sBase = sTestFiles230 + "order-agreement/";
      return new CommonsArrayList <> (new String [] { "Esempio Ordine pre-concordato di revoca.xml",
                                                      "Esempio Ordine pre-concordato iniziale.xml",
                                                      "Esempio Ordine pre-concordato sostitutivo.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation2_3_0.VID_ORDER_RESPONSE))
    {
      final String sBase = sTestFiles230 + "order-response/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Risposta all'Ordine di fornitura su articoli numerati.xml",
                                                      "Caso d'uso 2 - Risposta all'Ordine di fornitura di articoli in testo libero.xml",
                                                      "Caso d'uso 3 - Risposta all'Ordine di fornitura per i servizi.xml",
                                                      "Caso d'uso 4 - Risposta ad un Ordine di fornitura complesso.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    // 3.0.2
    final String sTestFiles302 = "src/test/resources/external/test-files/3.0.2/";
    if (aVESID.equals (PeppolItalyValidation3_0_2.VID_CREDIT_NOTE))
    {
      final String sBase = sTestFiles302 + "credit-note/";
      return new CommonsArrayList <> (new String [] { "01_NC B2G_Regime di split payment, CIG e Convenzione in riga.xml",
                                                      "02_NC G2G_Regime di split payment, Riferimento ordine in testata.xml",
                                                      "03_NC B2G_Cassa previdenziale, Ritenuta su prestazione imponibile.xml",
                                                      "04_NC B2G_Natura N2.1, Bollo addebitato.xml",
                                                      "05_NC B2G_Natura N2.1, Bollo non addebitato, Rimborso bollo fattura precedente.xml",
                                                      "06_NC B2B_Natura N2.1, Bollo addebitato.xml",
                                                      "07_NC B2B_Natura N2.1, Bollo non addebitato, Rimborso bollo fattura precedente.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }
    if (aVESID.equals (PeppolItalyValidation3_0_2.VID_DESPATCH_ADVICE))
    {
      final String sBase = sTestFiles302 + "despatch-advice/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Spedizione semplice.xml",
                                                      "Caso d'uso 2 - Spedizione semplice con quantita' inevasa.xml",
                                                      "Caso d'uso 3 - Spedizione con unita' logistica utilizzando le chiavi GS1.xml",
                                                      "Caso d'uso 4  - Spedizione con indicazione del peso, lunghezza e-o volume degli articoli merce.xml",
                                                      "Caso d'uso 5 -  Spedizione avanzata con l'uso della maggior parte delle informazioni di business.xml",
                                                      "Esempio DDT con Diversi Ordini.xml",
                                                      "Esempio DDT con Gestione Temperatura e Merce Pericolosa.xml",
                                                      "Esempio DDT con Indicazione Segnacollo.xml",
                                                      "Esempio DDT con Ordine a Confezione 02.xml",
                                                      "Esempio DDT con Ordine a Singola Unita' 01.xml",
                                                      "Esempio DDT con Quantita' Inevasa.xml",
                                                      "Esempio DDT con Reintegro e Lotto.xml",
                                                      "Esempio DDT con Reintegro e Omaggio.xml",
                                                      "Esempio DDT con Singolo Ordine.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation3_0_2.VID_INVOICE))
    {
      final String sBase = sTestFiles302 + "invoice/";
      return new CommonsArrayList <> (new String [] { "01_FT B2G_Data fattura non coincide con data operazione, Regime di split payment.xml",
                                                      "02_FT B2B_Data fattura non coincide con data operazione, IVA standard.xml",
                                                      "03_FT B2G_Cliente con solo CF, Riferimento ordine analogico in testata.xml",
                                                      "04_FT B2B_Natura N6.3, Bollo addebitato, Riferimento ordine in testata.xml",
                                                      "05_FT B2G_RF19, Natura N2.2, Bollo non addebitato, Allegato.xml",
                                                      "06_FT B2B_RF19, Natura N2.2, Bollo non addebitato.xml",
                                                      "07_FT B2G_Riferimento ordine elettronico, CIG e CUP in testata.xml",
                                                      "08_FT G2G_Riferimento ordine elettronico in testata, Riferimento riga d'ordine in riga.xml",
                                                      "09_FT B2G_Riferimento a più ordini cartacei in riga, Utilizzo StandardItemIdentifier.xml",
                                                      "10_FT B2B_Riferimento a più ordini cartacei in riga, Utilizzo StandardItemIdentifier.xml",
                                                      "11_FT B2G_Multiordine, Tripletta ordine, CIG e Convenzione in riga.xml",
                                                      "12_FT B2B_Cassa previdenziale, Ritenuta su prestazione imponibile, IVA standard.xml",
                                                      "13_FT B2G_Cassa previdenziale, Ritenuta su prestazione imponibile, Regime di split payment.xml",
                                                      "14_FT B2G_Cassa previdenziale, Ritenuta su prestazione non imponibile, Terzo intermediario.xml",
                                                      "15_FT B2B_Doppia ritenuta IRPEF-ENASARCO, IVA standard.xml",
                                                      "16_FT B2G_Doppia ritenuta IRPEF-ENASARCO, Regime di split payment, Terzo intermediario.xml",
                                                      "17_FT G2C_Natura N4, pagamento con PagoPA.xml",
                                                      "18_FT G2G_Riga con sconto sul prezzo, Riga senza sconto sul prezzo.xml",
                                                      "19_FT G2G_Riga con maggiorazione sul prezzo, riferimento DDT in riga.xml",
                                                      "20_FT B2G_Sconto in testata, abbuono su riga, riferimenti in testata e in riga.xml",
                                                      "21_FT B2B_Gestione tipo Carburante.xml",
                                                      "22_FT B2G_Gestione AICFarmaco, Confezione, Riferimento a ordine e DDT, Quietanzamento.xml",
                                                      "23_FT B2B_TD27 AutoFattura per autoconsumo.xml",
                                                      "24_FT B2G_Terzo intermediario estero e fornitore italiano.xml",
                                                      "25_FT B2G_Terzo intermediario italiano e fornitore estero.xml",
                                                      "26_FT B2G_Terzo intermediario estero e fornitore estero.xml",
                                                      "27_FT G2E_Fornitore italiano e cliente estero.xml",
                                                      "28_FT B2G_TD20 AutoFattura per regolarizzazione.xml",
                                                      "29_FT B2G_Gestione Dispositivo Medico, Riferimento a ordine e DDT, Quietanzamento.xml",
                                                      "30_FT B2G_Prestazioni con IVA e senza IVA, Bollo addebitato.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation3_0_2.VID_ORDER))
    {
      final String sBase = sTestFiles302 + "order/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Ordine di fornitura con articoli numerati.xml",
                                                      "Caso d'uso 2 - Ordine di fornitura di articoli in testo libero.xml",
                                                      "Caso d'uso 3 - Ordine di fornitura con servizi.xml",
                                                      "Caso d'uso 4 - Ordine di fornitura complesso.xml",
                                                      "Esempio Ordine Collegato di Regolazione.xml",
                                                      "Esempio Ordine Revisionato a Budget.xml",
                                                      "Esempio Ordine di Acquisto con Arrotondamento.xml",
                                                      "Esempio Ordine di Acquisto con Gestione CIG Esenzione Riga.xml",
                                                      "Esempio Ordine di Acquisto con Gestione CIG Riga.xml",
                                                      "Esempio Ordine di Acquisto con Omaggio.xml",
                                                      "Esempio Ordine di Acquisto con Sconto Merce.xml",
                                                      "Esempio Ordine di Acquisto per Fornitore Estero.xml",
                                                      "Esempio Ordine di Consegna Cancellato senza Righe.xml",
                                                      "Esempio Ordine di Consegna con Gestione CIG Esenzione Testata.xml",
                                                      "Esempio Ordine di Consegna con Gestione CIG Testata.xml",
                                                      "Esempio Ordine di Consegna con Gestione Codice GTIN.xml",
                                                      "Esempio Ordine di Consegna per Comodato d'uso gratuito con Kit 02.xml",
                                                      "Esempio Ordine di Consegna per Conto Deposito con Confezione.xml",
                                                      "Esempio Ordine di Consegna per Conto Deposito con Lotto e Seriale.xml",
                                                      "Esempio Ordine di Consegna per Conto Visione con Kit 01.xml",
                                                      "Esempio Ordine di Convalida.xml",
                                                      "Esempio Ordine di Fatturazione e Reintegro di un DM..xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation3_0_2.VID_ORDER_AGREEMENT))
    {
      final String sBase = sTestFiles302 + "order-agreement/";
      return new CommonsArrayList <> (new String [] { "Esempio Ordine pre-concordato di revoca.xml",
                                                      "Esempio Ordine pre-concordato iniziale.xml",
                                                      "Esempio Ordine pre-concordato sostitutivo.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }

    if (aVESID.equals (PeppolItalyValidation3_0_2.VID_ORDER_RESPONSE))
    {
      final String sBase = sTestFiles302 + "order-response/";
      return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Risposta all'Ordine di fornitura su articoli numerati.xml",
                                                      "Caso d'uso 2 - Risposta all'Ordine di fornitura di articoli in testo libero.xml",
                                                      "Caso d'uso 3 - Risposta all'Ordine di fornitura per i servizi.xml",
                                                      "Caso d'uso 4 - Risposta ad un Ordine di fornitura complesso.xml" },
                                      x -> new FileSystemResource (sBase + x));
    }
    // 3.1.0
    {
      final String sTestFiles310 = "src/test/resources/external/test-files/3.1.0/";
      if (aVESID.equals (PeppolItalyValidation3_1_0.VID_CREDIT_NOTE))
      {
        final String sBase = sTestFiles310 + "credit-note/";
        return new CommonsArrayList <> (new String [] { "01_NC B2G_Regime di split payment, CIG e Convenzione in riga.xml",
                                                        "02_NC G2G_Regime di split payment, Riferimento ordine in testata.xml",
                                                        "03_NC B2G_Cassa previdenziale, Ritenuta su prestazione imponibile.xml",
                                                        "04_NC B2G_Natura N2.1, Bollo addebitato.xml",
                                                        "05_NC B2G_Natura N2.1, Bollo non addebitato, Rimborso bollo fattura precedente.xml",
                                                        "06_NC B2B_Natura N2.1, Bollo addebitato.xml",
                                                        "07_NC B2B_Natura N2.1, Bollo non addebitato, Rimborso bollo fattura precedente.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }
      if (aVESID.equals (PeppolItalyValidation3_1_0.VID_DESPATCH_ADVICE))
      {
        final String sBase = sTestFiles310 + "despatch-advice/";
        return new CommonsArrayList <> (new String [] { "01_DDT_B2G_Coincidenza Parti, Indicazione Richiedente, Riferimento a Ordine in testata.xml",
                                                        "02_DDT_B2G_Non coincidenza Parti, Riferimento a più Ordini in riga.xml",
                                                        "03_DDT_B2G_Periodo stimato di consegna e Quantità Inevasa.xml",
                                                        "04_DDT_B2G_Farmaco, Gestione Temperatura, Merce Pericolosa, Indicazione Segnacollo e informazioni lotto.xml",
                                                        "05_DDT_B2G_Dispositivo Medico, Reintegro e Omaggio.xml",
                                                        "06_DDT_B2G_Articoli indicati per singola Unità e per Confezione.xml",
                                                        "Caso d'uso 1 - Spedizione semplice.xml",
                                                        "Caso d'uso 2 - Spedizione semplice con quantita' inevasa.xml",
                                                        "Caso d'uso 3 - Spedizione con unita' logistica utilizzando le chiavi GS1.xml",
                                                        "Caso d'uso 4 - Spedizione con indicazione del peso, lunghezza e-o volume degli articoli merce.xml",
                                                        "Caso d'uso 5 -  Spedizione avanzata con l'uso della maggior parte delle informazioni di business.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_1_0.VID_INVOICE))
      {
        final String sBase = sTestFiles310 + "invoice/";
        return new CommonsArrayList <> (new String [] { "01_FT B2G_Data fattura non coincide con data operazione, Regime di split payment.xml",
                                                        "02_FT B2B_Data fattura non coincide con data operazione, IVA standard.xml",
                                                        "03_FT B2G_Cliente con solo CF, Riferimento ordine analogico in testata.xml",
                                                        "04_FT B2B_Natura N6.3, Bollo addebitato, Riferimento ordine in testata.xml",
                                                        "05_FT B2G_RF19, Natura N2.2, Bollo non addebitato, Allegato.xml",
                                                        "06_FT B2B_RF19, Natura N2.2, Bollo non addebitato.xml",
                                                        "07_FT B2G_Riferimento ordine elettronico, CIG e CUP in testata.xml",
                                                        "08_FT G2G_Riferimento ordine elettronico in testata, Riferimento riga d'ordine in riga.xml",
                                                        "09_FT B2G_Riferimento a più ordini cartacei in riga, Utilizzo StandardItemIdentifier.xml",
                                                        "10_FT B2B_Riferimento a più ordini cartacei in riga, Utilizzo StandardItemIdentifier.xml",
                                                        "11_FT B2G_Multiordine, Tripletta ordine, CIG e Convenzione in riga.xml",
                                                        "12_FT B2B_Cassa previdenziale, Ritenuta su prestazione imponibile, IVA standard.xml",
                                                        "13_FT B2G_Cassa previdenziale, Ritenuta su prestazione imponibile, Regime di split payment.xml",
                                                        "14_FT B2G_Cassa previdenziale, Ritenuta su prestazione non imponibile, Terzo intermediario.xml",
                                                        "15_FT B2B_Doppia ritenuta IRPEF-ENASARCO, IVA standard.xml",
                                                        "16_FT B2G_Doppia ritenuta IRPEF-ENASARCO, Regime di split payment, Terzo intermediario.xml",
                                                        "17_FT G2C_Natura N4, pagamento con PagoPA.xml",
                                                        "18_FT G2G_Riga con sconto sul prezzo, Riga senza sconto sul prezzo.xml",
                                                        "19_FT G2G_Riga con maggiorazione sul prezzo, riferimento DDT in riga.xml",
                                                        "20_FT B2G_Sconto in testata, abbuono su riga, riferimenti in testata e in riga.xml",
                                                        "21_FT B2B_Gestione tipo Carburante.xml",
                                                        "22_FT B2G_Gestione AICFarmaco, Confezione, Riferimento a ordine e DDT, Quietanzamento.xml",
                                                        "23_FT B2B_TD27 AutoFattura per autoconsumo.xml",
                                                        "24_FT B2G_Terzo intermediario estero e fornitore italiano.xml",
                                                        "25_FT B2G_Terzo intermediario italiano e fornitore estero.xml",
                                                        "26_FT B2G_Terzo intermediario estero e fornitore estero.xml",
                                                        "27_FT G2E_Fornitore italiano e cliente estero.xml",
                                                        "28_FT B2G_TD20 AutoFattura per regolarizzazione.xml",
                                                        "29_FT B2G_Gestione Dispositivo Medico, Riferimento a ordine e DDT, Quietanzamento.xml",
                                                        "30_FT B2G_Prestazioni con IVA e senza IVA, Bollo addebitato.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_1_0.VID_ORDER))
      {
        final String sBase = sTestFiles310 + "order/";
        return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Ordine di fornitura con articoli numerati.xml",
                                                        "Caso d'uso 2 - Ordine di fornitura di articoli in testo libero.xml",
                                                        "Caso d'uso 3 - Ordine di fornitura con servizi.xml",
                                                        "Caso d'uso 4 - Ordine di fornitura complesso.xml",
                                                        "Esempio Ordine Collegato di Regolazione.xml",
                                                        "Esempio Ordine Revisionato a Budget.xml",
                                                        "Esempio Ordine di Acquisto con Arrotondamento.xml",
                                                        "Esempio Ordine di Acquisto con Gestione CIG Esenzione Riga.xml",
                                                        "Esempio Ordine di Acquisto con Gestione CIG Riga.xml",
                                                        "Esempio Ordine di Acquisto con Omaggio.xml",
                                                        "Esempio Ordine di Acquisto con Sconto Merce.xml",
                                                        "Esempio Ordine di Acquisto per Fornitore Estero.xml",
                                                        "Esempio Ordine di Consegna Cancellato senza Righe.xml",
                                                        "Esempio Ordine di Consegna con Gestione CIG Esenzione Testata.xml",
                                                        "Esempio Ordine di Consegna con Gestione CIG Testata.xml",
                                                        "Esempio Ordine di Consegna con Gestione Codice GTIN.xml",
                                                        "Esempio Ordine di Consegna per Comodato d'uso gratuito con Kit 02.xml",
                                                        "Esempio Ordine di Consegna per Conto Deposito con Confezione.xml",
                                                        "Esempio Ordine di Consegna per Conto Deposito con Lotto e Seriale.xml",
                                                        "Esempio Ordine di Consegna per Conto Visione con Kit 01.xml",
                                                        "Esempio Ordine di Convalida.xml",
                                                        "Esempio Ordine di Fatturazione e Reintegro di un DM..xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_1_0.VID_ORDER_AGREEMENT))
      {
        final String sBase = sTestFiles310 + "order-agreement/";
        return new CommonsArrayList <> (new String [] { "Esempio Ordine pre-concordato di revoca.xml",
                                                        "Esempio Ordine pre-concordato iniziale.xml",
                                                        "Esempio Ordine pre-concordato sostitutivo.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_1_0.VID_ORDER_RESPONSE))
      {
        final String sBase = sTestFiles310 + "order-response/";
        return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Risposta all'Ordine di fornitura su articoli numerati.xml",
                                                        "Caso d'uso 2 - Risposta all'Ordine di fornitura di articoli in testo libero.xml",
                                                        "Caso d'uso 3 - Risposta all'Ordine di fornitura per i servizi.xml",
                                                        "Caso d'uso 4 - Risposta ad un Ordine di fornitura complesso.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }
    }

    // 3.2.1
    {
      final String sTestFiles321 = "src/test/resources/external/test-files/3.2.1/";
      if (aVESID.equals (PeppolItalyValidation3_2_1.VID_CREDIT_NOTE))
      {
        final String sBase = sTestFiles321 + "credit-note/";
        return new CommonsArrayList <> (new String [] { "01_NC B2G_Regime di split payment, CIG e Convenzione in riga.xml",
                                                        "02_NC G2G_Regime di split payment, Riferimento ordine in testata.xml",
                                                        "03_NC B2G_Cassa previdenziale, Ritenuta su prestazione imponibile.xml",
                                                        "04_NC B2G_Natura N2.1, Bollo addebitato.xml",
                                                        "05_NC B2G_Natura N2.1, Bollo non addebitato, Rimborso bollo fattura precedente.xml",
                                                        "06_NC B2B_Natura N2.1, Bollo addebitato.xml",
                                                        "07_NC B2B_Natura N2.1, Bollo non addebitato, Rimborso bollo fattura precedente.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }
      if (aVESID.equals (PeppolItalyValidation3_2_1.VID_DESPATCH_ADVICE))
      {
        final String sBase = sTestFiles321 + "despatch-advice/";
        return new CommonsArrayList <> (new String [] { "01_DDT_B2G_Coincidenza Parti, Indicazione Richiedente, Riferimento a Ordine in testata.xml",
                                                        "02_DDT_B2G_Non coincidenza Parti, Riferimento a pi— Ordini in riga.xml",
                                                        "03_DDT_B2G_Periodo stimato di consegna e Quantit… Inevasa.xml",
                                                        "04_DDT_B2G_Farmaco, Gestione Temperatura, Merce Pericolosa, Indicazione Segnacollo e informazioni lotto.xml",
                                                        "05_DDT_B2G_Dispositivo Medico, Reintegro e Omaggio.xml",
                                                        "06_DDT_B2G_Articoli indicati per singola Unit… e per Confezione.xml",
                                                        "Caso d'uso 1 - Spedizione semplice.xml",
                                                        "Caso d'uso 2 - Spedizione semplice con quantita' inevasa.xml",
                                                        "Caso d'uso 3 - Spedizione con unita' logistica utilizzando le chiavi GS1.xml",
                                                        "Caso d'uso 4 - Spedizione con indicazione del peso, lunghezza e-o volume degli articoli merce.xml",
                                                        "Caso d'uso 5 -  Spedizione avanzata con l'uso della maggior parte delle informazioni di business.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_2_1.VID_INVOICE))
      {
        final String sBase = sTestFiles321 + "invoice/";
        return new CommonsArrayList <> (new String [] { "01_FT B2G_Data fattura non coincide con data operazione, Regime di split payment.xml",
                                                        "02_FT B2B_Data fattura non coincide con data operazione, IVA standard.xml",
                                                        "03_FT B2G_Cliente con solo CF, Riferimento ordine analogico in testata.xml",
                                                        "04_FT B2B_Natura N6.3, Bollo addebitato, Riferimento ordine in testata.xml",
                                                        "05_FT B2G_RF19, Natura N2.2, Bollo non addebitato, Allegato.xml",
                                                        "06_FT B2B_RF19, Natura N2.2, Bollo non addebitato.xml",
                                                        "07_FT B2G_Riferimento ordine elettronico, CIG e CUP in testata.xml",
                                                        "08_FT G2G_Riferimento ordine elettronico in testata, Riferimento riga d'ordine in riga.xml",
                                                        "09_FT B2G_Riferimento a più ordini cartacei in riga, Utilizzo StandardItemIdentifier.xml",
                                                        "10_FT B2B_Riferimento a più ordini cartacei in riga, Utilizzo StandardItemIdentifier.xml",
                                                        "11_FT B2G_Multiordine, Tripletta ordine, CIG e Convenzione in riga.xml",
                                                        "12_FT B2B_Cassa previdenziale, Ritenuta su prestazione imponibile, IVA standard.xml",
                                                        "13_FT B2G_Cassa previdenziale, Ritenuta su prestazione imponibile, Regime di split payment.xml",
                                                        "14_FT B2G_Cassa previdenziale, Ritenuta su prestazione non imponibile, Terzo intermediario.xml",
                                                        "15_FT B2B_Doppia ritenuta IRPEF-ENASARCO, IVA standard.xml",
                                                        "16_FT B2G_Doppia ritenuta IRPEF-ENASARCO, Regime di split payment, Terzo intermediario.xml",
                                                        "17_FT G2C_Natura N4, pagamento con PagoPA.xml",
                                                        "18_FT G2G_Riga con sconto sul prezzo, Riga senza sconto sul prezzo.xml",
                                                        "19_FT G2G_Riga con maggiorazione sul prezzo, riferimento DDT in riga.xml",
                                                        "20_FT B2G_Sconto in testata, abbuono su riga, riferimenti in testata e in riga.xml",
                                                        "21_FT B2B_Gestione tipo Carburante.xml",
                                                        "22_FT B2G_Gestione AICFarmaco, Confezione, Riferimento a ordine e DDT, Quietanzamento.xml",
                                                        "23_FT B2B_TD27 AutoFattura per autoconsumo.xml",
                                                        "24_FT B2G_Terzo intermediario estero e fornitore italiano.xml",
                                                        "25_FT B2G_Terzo intermediario italiano e fornitore estero.xml",
                                                        "26_FT B2G_Terzo intermediario estero e fornitore estero.xml",
                                                        "27_FT G2E_Fornitore italiano e cliente estero.xml",
                                                        "28_FT B2G_TD29 AutoFattura per regolarizzazione.xml",
                                                        "29_FT B2G_Gestione Dispositivo Medico, Riferimento a ordine e DDT, Quietanzamento.xml",
                                                        "30_FT B2G_Prestazioni con IVA e senza IVA, Bollo addebitato.xml",
                                                        "31_FT B2G_Indicazione acconto in fattura di saldo.xml",
                                                        "32_FT B2B_Indicazione acconto in fattura di saldo.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_2_1.VID_ORDER))
      {
        final String sBase = sTestFiles321 + "order/";
        return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Ordine di fornitura con articoli numerati.xml",
                                                        "Caso d'uso 2 - Ordine di fornitura di articoli in testo libero.xml",
                                                        "Caso d'uso 3 - Ordine di fornitura con servizi.xml",
                                                        "Caso d'uso 4 - Ordine di fornitura complesso.xml",
                                                        "Esempio Ordine Collegato di Regolazione.xml",
                                                        "Esempio Ordine Revisionato a Budget.xml",
                                                        "Esempio Ordine di Acquisto con Arrotondamento.xml",
                                                        "Esempio Ordine di Acquisto con Gestione CIG Esenzione Riga.xml",
                                                        "Esempio Ordine di Acquisto con Gestione CIG Riga.xml",
                                                        "Esempio Ordine di Acquisto con Omaggio.xml",
                                                        "Esempio Ordine di Acquisto con Sconto Merce.xml",
                                                        "Esempio Ordine di Acquisto per Fornitore Estero.xml",
                                                        "Esempio Ordine di Consegna Cancellato senza Righe.xml",
                                                        "Esempio Ordine di Consegna con Gestione CIG Esenzione Testata.xml",
                                                        "Esempio Ordine di Consegna con Gestione CIG Testata.xml",
                                                        "Esempio Ordine di Consegna con Gestione Codice GTIN.xml",
                                                        "Esempio Ordine di Consegna per Comodato d'uso gratuito con Kit 02.xml",
                                                        "Esempio Ordine di Consegna per Conto Deposito con Confezione.xml",
                                                        "Esempio Ordine di Consegna per Conto Deposito con Lotto e Seriale.xml",
                                                        "Esempio Ordine di Consegna per Conto Visione con Kit 01.xml",
                                                        "Esempio Ordine di Convalida.xml",
                                                        "Esempio Ordine di Fatturazione e Reintegro di un DM..xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_2_1.VID_ORDER_AGREEMENT))
      {
        final String sBase = sTestFiles321 + "order-agreement/";
        return new CommonsArrayList <> (new String [] { "Esempio Ordine pre-concordato di revoca.xml",
                                                        "Esempio Ordine pre-concordato iniziale.xml",
                                                        "Esempio Ordine pre-concordato sostitutivo.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }

      if (aVESID.equals (PeppolItalyValidation3_2_1.VID_ORDER_RESPONSE))
      {
        final String sBase = sTestFiles321 + "order-response/";
        return new CommonsArrayList <> (new String [] { "Caso d'uso 1 - Risposta all'Ordine di fornitura su articoli numerati.xml",
                                                        "Caso d'uso 2 - Risposta all'Ordine di fornitura di articoli in testo libero.xml",
                                                        "Caso d'uso 3 - Risposta all'Ordine di fornitura per i servizi.xml",
                                                        "Caso d'uso 4 - Risposta ad un Ordine di fornitura complesso.xml" },
                                        x -> new FileSystemResource (sBase + x));
      }
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
