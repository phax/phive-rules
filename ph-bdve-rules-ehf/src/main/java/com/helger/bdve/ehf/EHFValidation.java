package com.helger.bdve.ehf;

import javax.annotation.Nonnull;

import com.helger.bdve.api.executorset.IValidationExecutorSetRegistry;
import com.helger.bdve.engine.source.IValidationSourceXML;

/**
 * @author Philip Helger
 */
public final class EHFValidation
{
  private EHFValidation ()
  {}

  public static void initEHF (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    EHFValidationG2.initEHF (aRegistry);
    EHFValidationG3.initEHF (aRegistry);
  }
}
