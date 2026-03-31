# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**phive-rules** is a Maven multi-module project providing preconfigured validation rules for [PHIVE](https://github.com/phax/phive) (Philip Helger Integrative Validation Engine). It contains 34 sub-modules, each covering a specific e-invoicing document format (EN 16931, Peppol, XRechnung, UBL.BE, etc.).

Part of the Peppol solution stack: https://github.com/phax/peppol

## Build Commands

```bash
mvn clean install                    # Full build (all modules)
mvn clean install -pl phive-rules-en16931   # Single module
mvn test -pl phive-rules-peppol      # Tests for one module
mvn test -pl phive-rules-peppol -Dtest=PeppolValidationTest  # Single test class
```

CI runs on Java 17, 21, 25. Target is Java 17.

## Architecture

### Module Structure

Every format module follows the same pattern:

```
phive-rules-{format}/
├── src/main/java/.../
│   └── {Format}Validation.java              # Registers validation rule sets
├── src/main/resources/external/schematron/  # Pre-compiled XSLT rules
├── src/test/java/.../
│   ├── {Format}ValidationTest.java
│   ├── ValidationExecutionManagerFuncTest.java
│   ├── SPITest.java
│   └── mock/CTestFiles.java                # Test file loading utility
└── src/test/resources/external/
    ├── rule-source/                         # Original .sch Schematron files
    └── test-files/{version}/                # Sample XML documents
```

### Core Module: `phive-rules-api`

Provides shared helpers used by all format modules:
- `PhiveRulesHelper` — creates `DVRCoordinate` instances with version parsing
- `PhiveRulesUBLHelper` / `PhiveRulesCIIHelper` — format-specific XSD + Schematron rule registration
- `PhiveRulesTestHelper` — test utilities

### Validation Registration Pattern

Each `{Format}Validation.java` class:
1. Defines `GROUP_ID` and version constants
2. Creates `DVRCoordinate` constants (e.g., `VID_UBL_130`) via `PhiveRulesHelper.createCoordinate()`
3. Provides `init(IValidationExecutorSetRegistry<IValidationSourceXML>)` to register XSD + Schematron validation executor sets

### Key Dependencies

| Dependency | Purpose |
|---|---|
| `phive-parent-pom` (12.0.1) | PHIVE validation engine |
| `ph-schematron` (9.1.1) | Schematron processing |
| `ph-ubl` (10.1.0) | OASIS UBL bindings |
| `ph-cii` (4.1.1) | UN/CEFACT CII bindings |
| `peppol-commons` (12.4.0) | Peppol utilities |
| `ph-commons` (12.1.5) | Core utilities (collections, IO, etc.) |

### Module Dependencies

- `phive-rules-api` — base for all modules
- `phive-rules-en16931` — prerequisite for many country-specific modules
- `phive-rules-peppol` depends on `en16931`
- `phive-rules-ublbe` depends on `peppol`
- `phive-rules-energieefactuur` depends on `simplerinvoicing`

## Schematron Rules

Validation rules are pre-compiled: `.sch` → `.xslt` via `ph-schematron-maven-plugin`. The compiled XSLT files are committed to the repository under `src/main/resources/external/schematron/`. The plugin is disabled by default in module POMs (commented out); run it manually when updating rules.

## Testing

- **Framework:** JUnit 4
- **Test logging:** SLF4J Simple (`simplelogger.properties` in test resources)
- Each module has `SPITest`, format-specific validation tests, and functional tests running against real XML documents under `src/test/resources/external/test-files/`

## Packaging

All modules produce OSGi bundles (`<packaging>bundle</packaging>`) with `Automatic-Module-Name` for Java 9+ module system compatibility.
