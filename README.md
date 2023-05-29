# PHIVE rules

[![Maven Central](https://maven-badges.herokuapp.com/maven-central/com.helger.phive.rules/phive-rules-parent-pom/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.helger.phive.rules/phive-rules-parent-pom) 

A set of preconfigured rules for PHIVE (Philip Helger Integrative Validation Engine) - pronounced `[ˈfaɪv]`.

All projects found in here rely on the PHIVE validation engine provided by https://github.com/phax/phive (formerly ph-bdve)

This project is divided into sub-projects each keeping tracking of one document type set:
* phive-rules-cii - Validation rules for pure UN CII (without any Schematron)
* phive-rules-cius-pt - Validation rules for the Portuguese EN 16931 CIUS (since v1.0.11)
* phive-rules-cius-ro - Validation rules for the Romanian EN 16931 CIUS (since v2.1.14)
* phive-rules-ebinterface - Validation rules for Austrian ebInterface
* phive-rules-ehf - Validation rules for Norwegian EHF (Norwegian public procurement)
* phive-rules-en16931 - Validation rules for the EN 16931 (European e-Invoicing norm based on CEN TC 434)
* phive-rules-energieefactuur - Validation rules for Dutch Energie eFactuur
* phive-rules-facturae - Validation rules for the Spanisch Facturae (since v1.0.11)
* phive-rules-fatturapa - Validation rules for Italian fattura PA (since v1.0.4)
* phive-rules-finvoice - Validation rules for Finvoice (since v1.0.6)
* phive-rules-isdoc - Validation rules for ISDOC (since v2.0.2)
* phive-rules-oioubl - Validation rules for Danish OIOUBL
* phive-rules-peppol - the Peppol specific rules - always the latest two rule sets
* phive-rules-peppol-legacy - older Peppol specific rules that are out of date (since v2.0.5)
* phive-rules-peppol-italy - Peppol Italy specific rules (since v2.1.1)
* phive-rules-simplerinvoicing - Dutch SimplerInvoicing support from https://github.com/SimplerInvoicing/validation
* phive-rules-svefaktura - Validation rules for Swedish Svefaktura (since v1.0.6)
* phive-rules-teapps - Validation rules for Finnish Tieto TEAPPSXML
* phive-rules-ubl - Validation rules for pure OASIS UBL (without any Schematron)
* phive-rules-ublbe - Validation rules for Belgium e-FFF/UBL.BE
* phive-rules-xrechnung - Validation rules for German XRechnung

The Java code in this project is licensed under the Apache 2 license.
The code of the validation artefacts used may use a different license. 

# Maven usage

Add the following to your `pom.xml` to use this artifact, replacing `x.y.z` with the latest version:

```xml
<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-cii</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-cius-pt</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-cius-ro</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ebinterface</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ehf</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-en16931</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-energieefactuur</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-facturae</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-fatturapa</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-finvoice</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-isdoc</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-oioubl</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-peppol</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-peppol-legacy</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-peppol-italy</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-simplerinvoicing</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-svefaktura</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-teapps</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ubl</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-ublbe</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-xrechnung</artifactId>
  <version>x.y.z</version>
</dependency>
```

Alternate usage as a Maven BOM:

```xml
<dependency>
  <groupId>com.helger.phive.rules</groupId>
  <artifactId>phive-rules-parent-pom</artifactId>
  <version>x.y.z</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```

## Peppol Validation Artefact Versioning

If you wonder why the Peppol version differs from the original version numbers - this is because I started versioning the Peppol artefacts before OpenPeppol did.
As OpenPeppol is only changing the "micro" version part (3.0.x), whereas I started using the "minor" part (3.x) from the beginning, I could never take over the official version numbers because their version number would always "smaller" then any old version from my numbering scheme.
I hope that with the introduction of PINT, the versioning problem will be solved.
  
# News and noteworthy

* v3.0.4 - work in progress
    * Updated XRechnung 2.3.1 rules to 1.8.2
    * Added Peppol A-NZ-PEPPOL 1.0.9 rules (deprecated version 1.0.8)
    * Added support for SimplerInvoicing 2.0.3.7 and deprecated old versions
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3.6 and deprecated old versions
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.7 and deprecated old versions
    * Added Peppol 2023 May release (Billing 3.0.14 and Upgrade 3.0.11) - using a new versioning number (yyyy.m)
* v3.0.3 - 2023-04-30
    * Requires ph-ubl 8.0.2 or later
    * Added support for UBL 2.4-CSD01
    * Added support for Japan PINT Invoice and Credit Note 0.1.2. See [issue #16](https://github.com/phax/phive-rules/issues/16) - thx @dwillekens
* v3.0.2 - 2023-04-12
    * Added support for EN 16931 1.3.10 format and deprecated EN 16931 1.3.6a, 1.3.7 and 1.3.8 versions
    * Deprecated Peppol rules 3.0.14
    * Added support for fatturaPA 1.2.2
    * Added support for SimplerInvoicing 2.0.3.6 and deprecated old versions
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3.5 and deprecated old versions
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.6 and deprecated old versions
* v3.0.1 - 2023-03-16
    * Added support for Peppol End User Statistics Report 1.0.0 (deprecated 1.0.0-RC2)
    * Added support for Peppol Transaction Statistics Report 1.0.1 (deprecated 1.0.0)
* v3.0.0 - 2023-02-20
    * Using Java 11 as the baseline
    * Updated to ph-commons 11
    * Updated to JAXB 4.0
* v2.1.19 - 2023-02-19
    * Added support for Energie eFactuur 3.1.0
    * Added support for XRechnung 2.3.1
    * Deprecated XRechnung 2.1.1
* v2.1.18 - 2022-12-12
    * Added Peppol A-NZ-PEPPOL 1.0.8 rules (deprecated version 1.0.7)
    * Moved Peppol A-NZ-PEPPOL 1.0.6 rules from `phive-rules-peppol` to `phive-rules-peppol-legacy`
    * Added support for Peppol November 2022 release as 3.15.0 (Billing 3.0.14 and the rest 3.0.10)
    * Moved Peppol 3.13.0 rules from `phive-rules-peppol` to `phive-rules-peppol-legacy`
    * Added support for UBL.BE 1.30, deprecated version 1.2.9 (see the change in numbering: `30` vs. `2.9`)
    * Added support for CIUS-RO 1.0.8 - thanks to @yleider for the PR again
* v2.1.17 - 2022-11-18
    * Added support for Peppol End User Statistics Report 1.0.0-RC2
    * Added support for Peppol Transaction Statistics Report 1.0.0
    * Added support for SimplerInvoicing 2.0.3.5
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3.4
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.5
    * Added support for OIOUBL 1.13.0
    * Updated XRechnung 2.2.0 rules to v1.7.3
* v2.1.16 - 2022-10-18
    * Added support for ebInterface 6.1
    * Added support for EN 16931 1.3.9 format
* v2.1.15 - 2022-07-06
    * Added Peppol A-NZ-PEPPOL 1.0.7 rules (deprecated version 1.0.6)
    * Moved Peppol A-NZ-PEPPOL 1.0.5 rules from `phive-rules-peppol` to `phive-rules-peppol-legacy`
    * Deprecated Peppol 3.13.0 rules
    * Updated XRechnung 2.2.0 rules to v1.7.2
    * Added support for OIOUBL 1.12.3
* v2.1.14 - 2022-05-19
    * Fixed the EN 16931 UBL 1.3.8 XSLT version. That does not impact the Peppol May 2022 release.
    * Added support for CIUS-RO 1.0.3 - thanks to @yleider for the PR :heart:
    * Added support for CIUS-RO 1.0.4
* v2.1.13 - 2022-05-09
    * Deprecated XRechnung 2.0.0 and 2.0.1
    * Added support for EN 16931 1.3.8 format
    * Added support for SimplerInvoicing 1.2.4, deprecated 1.2.3
    * Added support for SimplerInvoicing 2.0.3.4, deprecated 2.0.3.3
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3.3, deprecated 1.0.3.2
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.4, deprecated 1.0.3
    * Added support for Peppol May 2022 release as 3.14.0 (Billing 3.0.13 and the rest 3.0.9)
    * Moved Peppol rules 3.12.0 from `phive-rules-peppol` to `phive-rules-peppol-legacy`
* v2.1.12 - 2022-03-21
    * Updated rules for XRechnung 2.2.0 to Schematron 1.7.1
* v2.1.11 - 2022-01-25
    * Added support for Peppol Italy rules 2.3.0 (AGID Despatch Advice, Invoice, Order, Order Agreement and Order Response)
    * Deprecated support for Peppol Italy rules 2.2.9
    * Added support for XRechnung 2.2.0
* v2.1.10 - 2022-01-11
    * Added support for Portuguese CIUS-PT 2.1.1
    * Added Peppol A-NZ-PEPPOL 1.0.6 rules (deprecated version 1.0.5)
    * Moved Peppol A-NZ-PEPPOL 1.0.4 rules from `phive-rules-peppol` to `phive-rules-peppol-legacy`
    * Added support for Peppol Directory BusinessCard v1, v2 and v3
* v2.1.9 - 2021-12-23
    * Deprecated Peppol 3.12.0 rules
    * Added support for UBL.BE 1.2.9, deprecated version 1.2.8
    * Added support for SimplerInvoicing 2.0.3.3, deprecated 2.0.3.2
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3.2, deprecated 1.0.3.1
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.3, deprecated 1.0.2
* v2.1.8 - 2021-11-05
    * Fixed the UBL 2.3 version from `2.3-cs01` to `2.3` - no content-wise changes
    * Added support for EN 16931 1.3.7 format (deprecated version 1.3.6)
    * Added support for Peppol November 2021 rules (3.13.0)
    * Moved Peppol rules 3.11.1 from `phive-rules-peppol` to `phive-rules-peppol-legacy`
* v2.1.7 - 2021-09-02
    * Peppol rules 3.11.1 are now correctly marked as deprecated
    * Added support for SimplerInvoicing 2.0.3.2, deprecated 2.0.3 and 2.0.3.1
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3.1, deprecated 1.0.3
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.2, deprecated 1.0.1
* v2.1.6 - 2021-08-11
    * Added support for EN 16931 1.3.6a rules - a special fork on https://github.com/phax/eInvoicing-EN16931/releases/tag/validation-1.3.6a
    * Added support for XRechnung 2.1.1
    * Added support for UBL.BE 1.2.8, deprecated version 1.2.7
* v2.1.5 - 2021-07-02
    * Deprecated Peppol rules 3.11.1
    * Added support for EN 16931 1.3.6 format (deprecated version 1.3.5)
    * Added Peppol A-NZ-PEPPOL 1.0.5 rules (deprecated version 1.0.4)
    * Moved Peppol A-NZ-PEPPOL 1.0.3 rules from `phive-rules-peppol` to `phive-rules-peppol-legacy`
* v2.1.4 - 2021-05-10
    * Added support for UBL.BE 1.2.7, deprecated version 1.2.6
* v2.1.3 - 2021-05-03
    * Added support for Peppol Spring 2021 rules (final version)
    * Moved Peppol rules 3.11.0 from `phive-rules-peppol` to `phive-rules-peppol-legacy`
* v2.1.2 - 2021-05-02
    * Updated to ph-commons 10.1
    * Added support for Peppol Spring 2021 rules (Release Candidate)
* v2.1.1 - 2021-04-02
    * Added support for EN 16931 1.3.5 format (deprecated version 1.3.4)
    * Added new submodule `phive-rules-peppol-italy` with the AGID Order, Despatch Advice and Order Response
* v2.1.0 - 2021-03-22
    * Updated to ph-commons 10
    * Dropped support for `EN 16931 EDIFACT/ISO 20625 1.0.0`
* v2.0.5 - 2021-03-09
    * Extracted new submodule `phive-rules-peppol-legacy` to reduce the size of the default library. Only the latest two versions are contained in the main `phive-rules-peppol` module - older versions will be moved to `phive-rules-peppol-legacy`.
* v2.0.4 - 2021-01-27
    * Updated to phive 7.1.0
    * Added support for EN 16931 1.3.4 format (deprecated version 1.3.3)
* v2.0.3 - 2021-01-07
    * Added support for SimplerInvoicing 1.2.3
    * Added support for SimplerInvoicing 2.0.3
    * Added support for SimplerInvoicing 2.0.3.1
    * Added support for SimplerInvoicing NLCIUS-CII 1.0.3
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0
    * Added support for SimplerInvoicing 2.0 G-Account extension 1.0.1
* v2.0.2 - 2021-01-06
    * Updated to UBL 2.3-CSD04 (adding 2 new document types)
    * Added support for XRechnung 2.0.1 rules v1.5.0
    * Deprecated XRechnung 1.2.2 rules as they were valid only until December 31, 2020
    * Added support for Czech ISDOC (version 6.0.1) - in the submodule `phive-rules-isdoc`
* v2.0.1 - 2020-12-04
    * Updated to ph-schematron 6.0.1
    * Updated to phive 7.0.1
    * Fixed the XRechnung 2.0.0 rules to ignore certain base EN16931 rules
    * Fixed the display names of the Peppol rules to use the correct versioning
* v2.0.0 - 2020-11-25
    * Renamed modules from `ph-bdve-rules-*` to `phive-rules*`
    * Changed the Maven group from `com.helger.bdve.rules.*` to `com.helger.phive.rules.*`
    * Named the Maven artefacts from `ph-bdve-rules-*` to `phive-rules-*`
    * Updated to ph-schematron 6.0.0
    * Added support for UBL.BE 1.2.6, deprecated version 1.2.5
* v1.0.15 - 2020-11-24
    * Added A-NZ-PEPPOL 1.0.4 rules
* v1.0.14 - 2020-11-18
    * Added support for UBL.BE 1.2.5, deprecated version 1.2.3
    * Deprecated Peppol validation artefacts 3.10.1 and 3.11.0
* v1.0.13 - 2020-11-13
    * Added Peppol Fall 2020 release corrigendum as version 3.11.1
* v1.0.12 - 2020-11-12
    * Same as 1.0.11 - just re-released because I thought it was lost on the way to Maven Central
* v1.0.11 - 2020-11-12
    * Updated to ph-bdve engine 6.0.4
    * Fixed an error with the XRechnung 2.0.0 validation artefacts
    * Added support for Spanish Facturae (version 3.0, 3.1, 3.2, 3.2.1 and 3.2.2) - in the submodule `ph-bdve-rules-facturae`
    * Added support for Portuguese CIUS-PT (version 2.0.0) - in the submodule `ph-bdve-rules-cius-pt`
* v1.0.10 - 2020-11-06
    * Added support for XRechnung 2.0.0 - thanks to [@yleider](https://github.com/yleider) for the PR
* v1.0.9 - 2020-11-02
    * Added Peppol Fall 2020 release as version 3.11.0
* v1.0.8 - 2020-10-05
    * Added support for EN 16931 1.3.3 format (deprecated version 1.3.2)
* v1.0.7 - 2020-09-17
    * Updated to Jakarta JAXB 2.3.3
* v1.0.6 - 2020-08-30
    * Added support for Finvoice 1.3, 2.0, 2.01 and 3.0
    * Added Svefaktura 1.0 and Svefaktura ObjectEnvelope 1.0
    * Updated to UBL 2.3-CSD03
* v1.0.5 - 2020-07-22
    * Added support for UBL.BE 1.2.3 rules
* v1.0.4 - 2020-07-06
    * Added support for Italian fatturaPA 1.2 and 1.2.1
    * Deprecated Peppol 3.10.0 rules
    * A Hotfix to the Peppol 3.10.1 rules, only relevant for "0208" participant identifier scheme usage, was included
    * Added SG-PEPPOL 1.0.3 rules
    * Added A-NZ-PEPPOL 1.0.3 rules
* v1.0.3 - 2020-06-16
    * Added Peppol Spring 2020 Hotfix release as version 3.10.1
* v1.0.2 - 2020-06-15
    * EHF G2 rules no longer directly use the Peppol rules but the provided subsets
* v1.0.1 - 2020-06-10
    * Added support for EHF G3 version 2020-03-23
    * Updated the Peppol 3.10.0 VESIDs to contain the document types
* v1.0.0 - 2020-06-08
    * Extracted from ph-bdve to allow for a clear separation between the engine and rules
    * Therefore a new Maven group `com.helger.bdve.rules` was created

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodingStyleguide.md) |
It is appreciated if you star the GitHub project if you like it.