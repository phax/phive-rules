/*
 * Copyright (C) 2024-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.rules.api;

import java.util.Collection;
import java.util.List;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.ValidationExecutorSetAlias;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.xml.schematron.CustomErrorDetails;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;

/**
 * Fluent builder for creating and registering
 * {@link IValidationExecutorSet}&lt;{@link IValidationSourceXML}&gt; objects.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PhiveRulesBuilder
{
  public static record Alias (@NonNull DVRCoordinate vesID, @NonNull @Nonempty String displayName)
  {
    public Alias
    {
      ValueEnforcer.notNull (vesID, "VESID");
      ValueEnforcer.notEmpty (displayName, "DisplayName");
    }
  }

  private DVRCoordinate m_aVESID;
  private String m_sDisplayName;
  private String m_sDisplayNamePrefix;
  private IValidationExecutorSetStatus m_aStatus;
  private IValidationExecutorSet <IValidationSourceXML> m_aBaseVES;
  private ICommonsMap <String, CustomErrorDetails> m_aCustomErrorLevels;
  private final ICommonsList <IValidationExecutor <IValidationSourceXML>> m_aExecutors = new CommonsArrayList <> ();
  private final ICommonsList <Alias> m_aAliases = new CommonsArrayList <> ();

  protected PhiveRulesBuilder ()
  {}

  @NonNull
  public static PhiveRulesBuilder builder ()
  {
    return new PhiveRulesBuilder ();
  }

  @NonNull
  public PhiveRulesBuilder vesID (@NonNull final DVRCoordinate aVESID)
  {
    m_aVESID = ValueEnforcer.notNull (aVESID, "VESID");
    return this;
  }

  @NonNull
  public PhiveRulesBuilder displayName (@NonNull @Nonempty final String sDisplayName)
  {
    m_sDisplayName = ValueEnforcer.notEmpty (sDisplayName, "DisplayName");
    return this;
  }

  @NonNull
  public PhiveRulesBuilder displayNamePrefix (@NonNull @Nonempty final String sDisplayNamePrefix)
  {
    m_sDisplayNamePrefix = ValueEnforcer.notEmpty (sDisplayNamePrefix, "DisplayNamePrefix");
    return this;
  }

  @NonNull
  public PhiveRulesBuilder status (@NonNull final IValidationExecutorSetStatus aStatus)
  {
    m_aStatus = ValueEnforcer.notNull (aStatus, "Status");
    return this;
  }

  @NonNull
  public PhiveRulesBuilder deprecated (final boolean bIsDeprecated)
  {
    return status (PhiveRulesHelper.createSimpleStatus (bIsDeprecated));
  }

  @NonNull
  public PhiveRulesBuilder deprecated ()
  {
    return deprecated (true);
  }

  @NonNull
  public PhiveRulesBuilder notDeprecated ()
  {
    return deprecated (false);
  }

  @NonNull
  public PhiveRulesBuilder basedOn (@NonNull final IValidationExecutorSet <IValidationSourceXML> aBaseVES)
  {
    return basedOn (aBaseVES, null);
  }

  @NonNull
  public PhiveRulesBuilder basedOn (@NonNull final IValidationExecutorSet <IValidationSourceXML> aBaseVES,
                                    @Nullable final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels)
  {
    m_aBaseVES = ValueEnforcer.notNull (aBaseVES, "BaseVES");
    m_aCustomErrorLevels = new CommonsHashMap <> (aCustomErrorLevels);
    return null;
  }

  @NonNull
  public PhiveRulesBuilder addXSD (@NonNull final IReadableResource aXSDRes)
  {
    ValueEnforcer.notNull (aXSDRes, "XSDRes");
    m_aExecutors.add (ValidationExecutorXSD.create (aXSDRes));
    return this;
  }

  @NonNull
  public PhiveRulesBuilder addXSD (@NonNull final IReadableResource... aXSDRes)
  {
    ValueEnforcer.notEmptyNoNullValue (aXSDRes, "XSDRes");
    m_aExecutors.add (ValidationExecutorXSD.create (aXSDRes));
    return this;
  }

  @NonNull
  public PhiveRulesBuilder addXSD (@NonNull final List <? extends IReadableResource> aXSDRes)
  {
    ValueEnforcer.notEmptyNoNullValue (aXSDRes, "XSDRes");
    m_aExecutors.add (ValidationExecutorXSD.create (aXSDRes));
    return this;
  }

  @NonNull
  public PhiveRulesBuilder addSchematron (@NonNull final ValidationExecutorSchematron aSchematron)
  {
    ValueEnforcer.notNull (aSchematron, "Schematron");
    m_aExecutors.add (aSchematron);
    return this;
  }

  @NonNull
  public PhiveRulesBuilder addExecutorsManually (@NonNull final Collection <? extends IValidationExecutor <IValidationSourceXML>> aExecutors)
  {
    ValueEnforcer.notEmptyNoNullValue (aExecutors, "Executors");
    m_aExecutors.addAll (aExecutors);
    return this;
  }

  @NonNull
  public PhiveRulesBuilder addAlias (@NonNull final Alias aAlias)
  {
    ValueEnforcer.notNull (aAlias, "Alias");
    m_aAliases.add (aAlias);
    return this;
  }

  @NonNull
  private String _resolveDisplayName ()
  {
    if (m_sDisplayName != null)
      return m_sDisplayName;
    if (m_sDisplayNamePrefix != null)
      return m_sDisplayNamePrefix + m_aVESID.getVersionString ();

    throw new IllegalStateException ("Either displayName or displayNamePrefix must be set");
  }

  @NonNull
  public ValidationExecutorSet <IValidationSourceXML> createVES ()
  {
    if (m_aVESID == null)
      throw new IllegalStateException ("VESID is missing");
    if (m_aStatus == null)
      throw new IllegalStateException ("Status is missing");

    final String sName = _resolveDisplayName ();

    final ValidationExecutorSet <IValidationSourceXML> aVES = new ValidationExecutorSet <> (m_aVESID, sName, m_aStatus);

    if (m_aBaseVES != null)
    {
      // If derived, copy all executors from the base VES first
      for (final IValidationExecutor <IValidationSourceXML> aVE : m_aBaseVES)
      {
        if (aVE instanceof final ValidationExecutorSchematron aSch)
        {
          if (m_aCustomErrorLevels != null && m_aCustomErrorLevels.isNotEmpty ())
          {
            // Explicitly apply the custom error levels
            aVES.addExecutor (aSch.getClone ().addCustomErrorDetails (m_aCustomErrorLevels));
          }
          else
            aVES.addExecutor (aSch);
        }
        else
          aVES.addExecutor (aVE);
      }
    }

    // Add all configured executors
    for (final IValidationExecutor <IValidationSourceXML> aVE : m_aExecutors)
    {
      aVES.addExecutor (aVE);
    }

    return aVES;
  }

  public void registerInto (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final ValidationExecutorSet <IValidationSourceXML> aVES = createVES ();
    aRegistry.registerValidationExecutorSet (aVES);

    // Finally register also all aliases (e.g. for Zugferd)
    for (final Alias aAlias : m_aAliases)
      aRegistry.registerValidationExecutorSet (new ValidationExecutorSetAlias <> (aAlias.vesID (),
                                                                                  aAlias.displayName (),
                                                                                  aVES));
  }
}
