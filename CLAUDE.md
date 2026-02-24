# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build commands

```bash
swift build              # Build the library
swift test               # Run all tests
swift build -c release   # Release build
```

## Project overview

**SwiftStencilKit** is a Swift library that provides string transformation functions as both Stencil template filters and Swift String extensions.

- **Language:** Swift 6.1+
- **Platform:** macOS 10.15+
- **Dependency:** Stencil 0.15.1+

## Architecture

Single-file library (`Sources/SwiftStencilKit/SwiftStencilKit.swift`) with two public components:

1. **`SwiftStencilFilters` class** — Registers all filters on a Stencil `Environment` via `register(on:)`. Each filter is a thin wrapper that casts the input to `String` and delegates to the corresponding `String` extension method.

2. **`String` extensions** — Core transformation logic:
   - `tokenized() -> [String]` — Splits any input format (PascalCase, camelCase, snake\_case, kebab-case, acronyms, mixed) into lowercase word tokens using a single regex.
   - Case converters (`pascalCased()`, `camelCased()`, `snakeCased()`, `kebabCased()`, `constantCased()`, `dotCased()`, `pathCased()`, `sentenceCased()`, `headerCased()`) — all built on `tokenized()`.
   - Pluralization (`pluralized()`, `singularized()`) — English irregular forms + suffix rules; preserves first-character casing.

## Key behaviors to be aware of

- `capitalize`, `titlecase`, and `titleCase` are all aliases — they all call Swift's `.capitalized` (every word title-cased). `capitalizeFirst` is different: it uppercases only the first character.
- `isAcronym` returns `true` only if the string is all-uppercase **and** at most 6 characters. This limit is intentional but not widely advertised.
- All string-only filters return `""` for non-string inputs. Utility filters (`count`, `isEmpty`, `first`, `last`) accept both `String` and `[Any]`.
- `join` and `split` require a separator argument passed via Stencil's colon syntax: `{{ items | join:", " }}`.
- Filters can be chained: `{{ name | snakeCase | pluralize }}`.

## Filter aliases

Filters support multiple naming conventions:

- `camelcase` / `camelCase`
- `pascalcase` / `pascalCase` / `PascalCase`
- `snakecase` / `snakeCase` / `snake_case`
- `kebabcase` / `kebabCase` / `kebab-case`
- `constantcase` / `CONSTANT_CASE`
- `dotcase` / `dotCase`
- `pathcase` / `pathCase`
- `sentencecase` / `sentenceCase`
- `headercase` / `headerCase`
- `titlecase` / `titleCase`
- `capitalizeFirst` / `capitalizedFirst`
