# BDVE rules

A set of preconfigured rules for the Business Document Validation Engine (BDVE).

All projects found in here rely on the validation engine provided by https://github.com/phax/ph-bdve

This project is divided into sub-projects each keeping tracking of one document type set:
  * ph-bdve-cii - Validation rules for pure CII (without any Schematron) - since 4.0.1
  * ph-bdve-ebinterface - Validation rules for Austrian ebInterface - since 5.0.0
  * ph-bdve-ehf - Validation rules for EHF (Norwegian public procurement) - since 4.0.1
  * ph-bdve-en16931 - Validation rules for the EN 16931 (European e-Invoicing norm based on CEN TC 434)
  * ph-bdve-energieefactuur - Validation rules for Dutch Energie eFactuur - since 4.0.2
  * ph-bdve-oioubl - Validation rules for Danish OIOUBL - since 4.0.3
  * ph-bdve-peppol - the Peppol specific setup etc
  * ph-bdve-simplerinvoicing - Dutch SimplerInvoicing 1.x support from https://github.com/SimplerInvoicing/validation
  * ph-bdve-teapps - Validation rules for Tieto TEAPPSXML - since 5.0.0
  * ph-bdve-ubl - Validation rules for pure UBL (without any Schematron) - since 4.0.1
  * ph-bdve-ublbe - Validation rules for e-FFF/UBL.BE - since 5.0.5
  * ph-bdve-xrechnung - Validation rules for German XRechnung - since 5.1.9

The Java code in this project is licensed under the Apache 2 license.
The code of the validation artefacts used may use a different license. 

# Maven usage

Add the following to your `pom.xml` to use this artifact, replacing `x.y.z` with the latest version:

```xml
<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-cii</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-ebinterface</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-ehf</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-en16931</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-energieefactuur</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-oioubl</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-peppol</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-simplerinvoicing</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId7>ph-bdve-rules-teapps</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-ubl</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-ublbe</artifactId>
  <version>x.y.z</version>
</dependency>

<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-xrechnung</artifactId>
  <version>x.y.z</version>
</dependency>
```

Alternate usage as a Maven BOM:

```xml
<dependency>
  <groupId>com.helger.bdve.rules</groupId>
  <artifactId>ph-bdve-rules-parent-pom</artifactId>
  <version>x.y.z</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```
  
# News and noteworthy

* v6.0.0 - work in progress
    * Extracted from ph-bdve to allow for a clear separation between the engine and rules
    * Therefore a new Maven group was created `com.helger.bdve.rules`

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodingStyleguide.md) |
On Twitter: <a href="https://twitter.com/philiphelger">@philiphelger</a> |
Kindly supported by [YourKit Java Profiler](https://www.yourkit.com)
