# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
swift build          # Build the library
swift test           # Run all tests
swift build -c release  # Build release version
```

## Project Overview

**SwiftStencilKit** is a Swift library that provides string transformation functions as both Stencil template filters and Swift String extensions.

- **Language:** Swift 6.1
- **Platform:** macOS 10.15+
- **Dependency:** Stencil (templating engine)

## Architecture

Single-file library (`Sources/SwiftStencilKit/SwiftStencilKit.swift`) with two main components:

1. **`SwiftStencilFilters` class** - Registers filters on a Stencil `Environment` via `register(on:)`. Each filter delegates to String extension methods.

2. **Public String extensions** - Core transformation logic:
   - `tokenized()` - Splits strings into word components using regex (handles PascalCase, camelCase, snake_case, kebab-case, acronyms)
   - Case converters (`pascalCased()`, `camelCased()`, `snakeCased()`, `kebabCased()`) - Built on `tokenized()`
   - Pluralization (`pluralized()`, `singularized()`) - English rules with special cases and suffix handling

## Filter Aliases

Filters support multiple naming conventions for developer convenience:
- `camelcase` / `camelCase`
- `pascalcase` / `pascalCase` / `PascalCase`
- `snakecase` / `snakeCase` / `snake_case`
- `kebabcase` / `kebabCase` / `kebab-case`
