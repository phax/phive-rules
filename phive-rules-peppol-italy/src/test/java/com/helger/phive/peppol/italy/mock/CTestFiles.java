/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.peppol.italy.PeppolItalyValidation;
import com.helger.phive.peppol.italy.PeppolItalyValidation2_2_9;
import com.helger.phive.peppol.italy.PeppolItalyValidation2_3_0;

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
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { PeppolItalyValidation2_2_9.VID_DESPATCH_ADVICE,
                                            PeppolItalyValidation2_2_9.VID_ORDER,
                                            PeppolItalyValidation2_2_9.VID_ORDER_RESPONSE,

                                            PeppolItalyValidation2_3_0.VID_DESPATCH_ADVICE,
                                            PeppolItalyValidation2_3_0.VID_INVOICE,
                                            PeppolItalyValidation2_3_0.VID_ORDER,
                                            PeppolItalyValidation2_3_0.VID_ORDER_AGREEMENT,
                                            PeppolItalyValidation2_3_0.VID_ORDER_RESPONSE, })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (MockFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

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

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
