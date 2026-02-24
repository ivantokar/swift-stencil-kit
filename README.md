# SwiftStencilKit

A Swift library that provides string transformation functions as both **Stencil template filters** and **Swift String extensions**. Useful for code generators, CLI tools, and any project that needs consistent string transformations across templates and Swift code.

```swift
import SwiftStencilKit

// Swift extensions
"EmailToAdmin".camelCased()   // "emailToAdmin"
"Category".pluralized()       // "Categories"

// Stencil filters
// {{ "EmailToAdmin" | camelCase }}  →  emailToAdmin
// {{ "Category" | pluralize }}      →  Categories
```

---

## Requirements

- Swift 6.1+
- macOS 10.15+
- [Stencil](https://github.com/stencilproject/Stencil) 0.15.1+

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/swift-stencil-kit.git", from: "2.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "SwiftStencilKit", package: "swift-stencil-kit")
        ]
    )
]
```

---

## Setup

Register the filters on a Stencil `Environment` before rendering templates. You can use a plain `Environment()` or one with a loader — both work:

```swift
import Stencil
import SwiftStencilKit

// With a loader
let env = Environment(loader: FileSystemLoader(paths: ["./Templates"]))
SwiftStencilFilters.register(on: env)

// Or without a loader (e.g. rendering template strings directly)
let env = Environment()
SwiftStencilFilters.register(on: env)

let output = try env.renderTemplate(string: "{{ name | camelCase }}", context: ["name": "user_profile"])
// output: "userProfile"
```

`SwiftStencilFilters.register(on:)` iterates `environment.extensions` and registers all filters on each. A default `Environment()` comes with one built-in extension, so filters are always registered.

---

## Features

### Case conversion

| Filter aliases | Output format | Example input → output |
|---|---|---|
| `camelcase`, `camelCase` | camelCase | `user_profile_id` → `userProfileId` |
| `pascalcase`, `pascalCase`, `PascalCase` | PascalCase | `user-profile-id` → `UserProfileId` |
| `snakecase`, `snakeCase`, `snake_case` | snake\_case | `UserProfileId` → `user_profile_id` |
| `kebabcase`, `kebabCase`, `kebab-case` | kebab-case | `User Profile ID` → `user-profile-id` |
| `constantcase`, `CONSTANT_CASE` | CONSTANT\_CASE | `myAppName` → `MY_APP_NAME` |
| `dotcase`, `dotCase` | dot.case | `myAppName` → `my.app.name` |
| `pathcase`, `pathCase` | path/case | `myAppName` → `my/app/name` |
| `sentencecase`, `sentenceCase` | Sentence case | `myAppName` → `My app name` |
| `headercase`, `headerCase` | Header-Case | `myAppName` → `My-App-Name` |

All case conversion filters are built on `tokenized()`, so they correctly handle any input format — see the [Tokenization](#tokenization) section.

### String transformation

| Filter | Behavior | Example |
|---|---|---|
| `uppercase` | Uppercases all characters | `hello` → `HELLO` |
| `lowercase` | Lowercases all characters | `HELLO` → `hello` |
| `capitalize`, `titlecase`, `titleCase` | Capitalizes the first letter of every word (Swift `.capitalized`) | `hello world` → `Hello World` |
| `capitalizeFirst`, `capitalizedFirst` | Uppercases only the very first character, leaves the rest unchanged | `helloWorld` → `HelloWorld`, `hello world` → `Hello world` |

Note: `capitalize`, `titlecase`, and `titleCase` are all aliases for the same operation — every word is title-cased. Use `capitalizeFirst` if you only want the first character uppercased.

### Pluralization

| Filter | Examples |
|---|---|
| `pluralize` | `company` → `companies`, `person` → `people`, `box` → `boxes` |
| `singularize` | `categories` → `category`, `people` → `person`, `boxes` → `box` |

Original casing is preserved: `Category` → `Categories`, `PERSON` is not a recognized special case and will follow suffix rules.

### Utilities

| Filter | Input types | Behavior |
|---|---|---|
| `isAcronym` | String | Returns `true` if the string is all-uppercase and at most 6 characters long. `HTML` → `true`, `Http` → `false`, `TOOLONG` → `false` |
| `count` | String or Array | Returns the number of Unicode grapheme clusters (for strings) or elements (for arrays) |
| `isEmpty` | String or Array | Returns `true` if the string or array is empty |
| `isNotEmpty` | String or Array | Returns `true` if the string or array is non-empty |
| `first` | String or Array | Returns the first character (as a single-character `String`) or the first array element |
| `last` | String or Array | Returns the last character (as a single-character `String`) or the last array element |
| `join` | Array | Joins elements with a separator argument |
| `split` | String | Splits into an array on a separator argument |

**`join` and `split` take a required argument** passed with a colon in Stencil syntax:

```stencil
{{ items | join:", " }}        {# ["a","b","c"] → "a, b, c" #}
{{ "a-b-c" | split:"-" }}     {# → ["a","b","c"] #}
```

**Non-string input:** All string-only filters (`camelCase`, `snakeCase`, etc.) return an empty string if passed a non-string value. Utility filters that accept both strings and arrays handle each type as described above; other inputs return a zero/empty/`false` default.

---

## Conversion reference

| Input | `camelcase` | `pascalcase` | `snakecase` | `kebabcase` | `constantcase` | `dotcase` | `pathcase` | `sentencecase` | `headercase` |
|---|---|---|---|---|---|---|---|---|---|
| `UserProfile` | `userProfile` | `UserProfile` | `user_profile` | `user-profile` | `USER_PROFILE` | `user.profile` | `user/profile` | `User profile` | `User-Profile` |
| `user_profile` | `userProfile` | `UserProfile` | `user_profile` | `user-profile` | `USER_PROFILE` | `user.profile` | `user/profile` | `User profile` | `User-Profile` |
| `user-profile` | `userProfile` | `UserProfile` | `user_profile` | `user-profile` | `USER_PROFILE` | `user.profile` | `user/profile` | `User profile` | `User-Profile` |
| `myAppName` | `myAppName` | `MyAppName` | `my_app_name` | `my-app-name` | `MY_APP_NAME` | `my.app.name` | `my/app/name` | `My app name` | `My-App-Name` |

---

## Usage

### Stencil templates

```stencil
{# Case conversion #}
{{ "user_profile_id" | camelcase }}    → userProfileId
{{ "user profile" | pascalCase }}      → UserProfile
{{ "UserProfileId" | snakecase }}      → user_profile_id
{{ "EmailToAdmin" | kebab-case }}      → email-to-admin

{# String transformation #}
{{ "hello world" | uppercase }}        → HELLO WORLD
{{ "HELLO" | lowercase }}              → hello
{{ "hello world" | capitalize }}       → Hello World
{{ "hello world" | capitalizeFirst }}  → Hello world

{# Pluralization #}
{{ "Category" | pluralize }}           → Categories
{{ "Person" | pluralize }}             → People
{{ "Categories" | singularize }}       → Category

{# Utilities #}
{{ items | count }}                    → 3  (for ["a","b","c"])
{{ items | first }}                    → "a"
{{ items | last }}                     → "c"
{{ items | join:", " }}                → "a, b, c"
{{ "a-b-c" | split:"-" | first }}      → "a"

{% if "HTTP" | isAcronym %}
  HTTP is an acronym.
{% endif %}
```

**Filters can be chained.** Each filter receives the output of the previous one:

```stencil
{{ entityName | snakeCase | pluralize }}
{# "UserAccount" → "user_account" → "user_accounts" #}
```

**Practical code generation examples:**

```stencil
{# Repository variable #}
let {{ entityName | camelCase }}Repository = {{ entityName }}Repository()

{# Route path #}
router.get("/{{ entityName | kebabCase | pluralize }}", handler)

{# Database table name #}
let table = "{{ entityName | snakeCase | pluralize }}"
{# User → "users", Category → "categories" #}
```

### Swift String extensions

All transformations are also available directly on `String`:

```swift
import SwiftStencilKit

// Case conversion
"user_profile".pascalCased()     // "UserProfile"
"UserProfile".camelCased()       // "userProfile"
"UserProfile".snakeCased()       // "user_profile"
"UserProfile".kebabCased()       // "user-profile"
"myAppName".constantCased()      // "MY_APP_NAME"
"myAppName".dotCased()           // "my.app.name"
"myAppName".pathCased()          // "my/app/name"
"myAppName".sentenceCased()      // "My app name"
"myAppName".headerCased()        // "My-App-Name"

// Tokenization
"EmailToAdmin".tokenized()       // ["email", "to", "admin"]
"HTTPSConnection".tokenized()    // ["https", "connection"]
"API2Client".tokenized()         // ["api", "2", "client"]

// Pluralization
"Category".pluralized()          // "Categories"
"People".singularized()          // "Person"

// Example: generate a filename
let name = "EmailToAdmin"
let file = "\(name.kebabCased()).component.ts"   // "email-to-admin.component.ts"
```

The Swift extensions and Stencil filters use the same underlying logic, so output is always consistent between templates and Swift code.

---

## API reference

### `SwiftStencilFilters`

```swift
public class SwiftStencilFilters {
    public static func register(on environment: Environment)
}
```

Registers all filters on every extension of the given `Environment`. Call once before rendering.

### String extensions

```swift
public extension String {
    func tokenized() -> [String]      // Split into lowercase word tokens
    func pascalCased() -> String
    func camelCased() -> String
    func snakeCased() -> String
    func kebabCased() -> String
    func constantCased() -> String
    func dotCased() -> String
    func pathCased() -> String
    func sentenceCased() -> String
    func headerCased() -> String
    func pluralized() -> String
    func singularized() -> String
}
```

---

## Tokenization

All case conversion is built on `tokenized()`, which splits a string into lowercase word tokens regardless of the input format:

| Input | Tokens |
|---|---|
| `EmailToAdmin` (PascalCase) | `["email", "to", "admin"]` |
| `emailToAdmin` (camelCase) | `["email", "to", "admin"]` |
| `email_to_admin` (snake\_case) | `["email", "to", "admin"]` |
| `email-to-admin` (kebab-case) | `["email", "to", "admin"]` |
| `HTTPSConnection` (acronym prefix) | `["https", "connection"]` |
| `API2Client` (number token) | `["api", "2", "client"]` |

The regex pattern `([a-z0-9]+|[A-Z0-9]+(?![a-z])|[A-Z][a-z0-9]+)` handles three token classes:
- Lowercase/digit runs: `abc`, `123`
- All-uppercase runs not followed by lowercase: `HTTP`, `API`
- A single uppercase letter followed by lowercase/digits: `Profile`, `2client`

---

## Pluralization rules

Special irregular forms are handled first (lookup is case-insensitive, casing of the first character is preserved in the output):

| Singular | Plural |
|---|---|
| person | people |
| man | men |
| woman | women |
| child | children |
| tooth | teeth |
| foot | feet |
| mouse | mice |
| goose | geese |

For regular words, suffix rules are applied in order:

| Condition | Rule | Example |
|---|---|---|
| Ends in `-y` preceded by a consonant | Replace `-y` with `-ies` | `category` → `categories` |
| Ends in `-s`, `-x`, `-z`, `-ch`, `-sh` | Append `-es` | `box` → `boxes` |
| Ends in `-f` | Replace `-f` with `-ves` | `half` → `halves` |
| Ends in `-fe` | Replace `-fe` with `-ves` | `knife` → `knives` |
| Ends in `-o` preceded by a consonant | Append `-es` | `hero` → `heroes` |
| Default | Append `-s` | `user` → `users` |

Singularization applies the same irregular table and reverses the suffix rules in the same priority order.

---

## Testing

Tests use Swift's [Testing](https://github.com/apple/swift-testing) framework.

```bash
swift test
```

---

## Contributing

Contributions are welcome. Open a pull request against `main`.

Areas that could use improvement:
- Additional irregular pluralization cases
- Locale-aware transformations
- Performance benchmarks

---

## Related projects

- [Stencil](https://github.com/stencilproject/Stencil) — the templating engine this library extends

---

## License

MIT License.
