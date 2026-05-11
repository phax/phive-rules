/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.phive.osa.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.osa.OSAValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    OSAValidation.initOSA (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { OSAValidation.VID_OSA_INVOICE_DATA_20,
                                                             OSAValidation.VID_OSA_INVOICE_ANNULMENT_20,
                                                             OSAValidation.VID_OSA_INVOICE_DATA_30,
                                                             OSAValidation.VID_OSA_INVOICE_ANNULMENT_30 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPrefix = "/external/test-files/";

    // v2.0 - Official NAV samples from
    // https://github.com/nav-gov-hu/Online-Invoice/tree/2.0/sample/Data%20sample
    if (aVESID.equals (OSAValidation.VID_OSA_INVOICE_DATA_20))
    {
      return new CommonsArrayList <> (new String [] { "01_Belföldi termékértékesítés kedvezényes tétellel.xml",
                                                      "01_Belföldi termékértékesítés.xml",
                                                      "02_Gyűjtőszámla-2.xml",
                                                      "02_Gyűjtőszámla.xml",
                                                      "04_Belföldi devizás számla saját mértékegységgel.xml",
                                                      "05_Termékdíjas számla.xml",
                                                      "06_Belföldi előlegszámla_A.xml",
                                                      "06_Belföldi előlegszámla.xml",
                                                      "07_Belföldi végszámla.xml",
                                                      "08_Téves egységár helyesbítése_A.xml",
                                                      "08_Téves egységár helyesbítése_B.xml",
                                                      "09_eredeti számla módosításokhozi.xml",
                                                      "10_Téves termék helyesbítése M1.xml",
                                                      "11_Téves termék helyesbítése M2a.xml",
                                                      "11_Téves termék helyesbítése M2b.xml",
                                                      "12_Többszörös módosítás_A.xml",
                                                      "12_Többszörös módosítás_B.xml",
                                                      "13_Módosítás és érvénytelenítés_A.xml",
                                                      "13_Módosítás és érvénytelenítés_B.xml",
                                                      "14_Tételadatok módosítása.xml",
                                                      "15_Alapszámla módosításhoz_1.xml",
                                                      "15_Alapszámla módosításhoz_2.xml",
                                                      "15_Alapszámla módosításhoz_3.xml",
                                                      "15_Több számla módosítása batchInvoice használatával.xml" },
                                      x -> new ClassPathResource (sPrefix + "v2.0/" + x));
    }
    if (aVESID.equals (OSAValidation.VID_OSA_INVOICE_ANNULMENT_20))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "v2.0/" + x));
    }

    // v3.0 - Official NAV samples from
    // https://github.com/nav-gov-hu/Online-Invoice/tree/master/sample/Data%20sample
    if (aVESID.equals (OSAValidation.VID_OSA_INVOICE_DATA_30))
    {
      return new CommonsArrayList <> (new String [] { "Belfoldi devizas szamla.xml",
                                                      "Belfoldi devizas vegszamla tobb eloleg tetel.xml",
                                                      "Belfoldi egyszerusitett szamla.xml",
                                                      "Belfoldi elolegszamla egysegar nelkul .xml",
                                                      "Belfoldi elolegszamla.xml",
                                                      "Belfoldi ertekesites tobb AFA tipus.xml",
                                                      "Belfoldi termekertekesites AFA csoportok kozott.xml",
                                                      "Belfoldi termekertekesites maganszemelynek.xml",
                                                      "Belfoldi termekertekesites tetelbol adott engedmennyel.xml",
                                                      "Belfoldi termekertekesites.xml",
                                                      "Belfoldi vegszamla.xml",
                                                      "Eredeti szamla modositasokhoz.xml",
                                                      "Gyujtoszamla 1.xml",
                                                      "Gyujtoszamla 2.xml",
                                                      "Harmadik orszagbeli devizas szamla.xml",
                                                      "Modositas es ervenytelenites 1.xml",
                                                      "Modositas es ervenytelenites 2.xml",
                                                      "Tagorszagi devizas szamla.xml",
                                                      "Termekdijas szamla.xml",
                                                      "Teteladatok modositasa.xml",
                                                      "Teves termek helyesbitese 20.xml",
                                                      "Teves termek helyesbitese 21.xml",
                                                      "Teves termek helyesbitese.xml",
                                                      "Tobb szamla modositasa egy okirattal alap 1.xml",
                                                      "Tobb szamla modositasa egy okirattal alap 2.xml",
                                                      "Tobb szamla modositasa egy okirattal alap 3.xml",
                                                      "Tobb szamla modositasa egy okirattal.xml",
                                                      "Tobbszoros modositas 1.xml",
                                                      "Tobbszoros modositas 2.xml",
                                                      "Uj kozlekedesi eszkoz export.xml" },
                                      x -> new ClassPathResource (sPrefix + "v3.0/" + x));
    }
    if (aVESID.equals (OSAValidation.VID_OSA_INVOICE_ANNULMENT_30))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "v3.0/" + x));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
