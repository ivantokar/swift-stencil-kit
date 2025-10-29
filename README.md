# MageStencilKit

**MageStencilKit** is a lightweight Swift library that provides powerful string transformation functions as both **Stencil template filters** and **Swift String extensions**.

Perfect for code generators, CLI tools, and any project that needs consistent string transformations across templates and Swift code.

```swift
import MageStencilKit

// Use as Swift extensions
"EmailToAdmin".camelCased()        // "emailToAdmin"
"Category".pluralized()            // "Categories"

// Use as Stencil filters
// {{ "EmailToAdmin" | camelCase }}   → emailToAdmin
// {{ "Category" | pluralize }}       → Categories
```

---

## ✨ Features

### Case Conversion
- 🪄 `camelcase` / `camelCase`: `user_profile_id` → `userProfileId`
- 🧱 `pascalcase` / `pascalCase` / `PascalCase`: `user-profile-id` → `UserProfileId`
- 🐍 `snakecase` / `snakeCase` / `snake_case`: `UserProfileId` → `user_profile_id`
- 🧩 `kebabcase` / `kebabCase` / `kebab-case`: `User Profile ID` → `user-profile-id`

### String Transformation
- 🔠 `uppercase`: `hello` → `HELLO`
- 🔡 `lowercase`: `HELLO` → `hello`
- 📝 `capitalize`: `hello world` → `Hello World`
- ✍️ `capitalizeFirst` / `capitalizedFirst`: `vapor` → `Vapor`
- 🎨 `titlecase` / `titleCase`: `hello world` → `Hello World`

### Pluralization
- 🔁 `pluralize`: `company` → `companies`, `person` → `people`, `box` → `boxes`
- ↩️ `singularize`: `categories` → `category`, `people` → `person`, `boxes` → `box`

### Utilities
- 🔎 `isAcronym`: `HTML` → `true`, `Http` → `false`

---

## 🔁 Input to Output Case Conversions

| Input           | `camelcase`     | `pascalcase`    | `snakecase`       | `kebabcase`       |
| --------------- | --------------- | --------------- | ----------------- | ----------------- |
| `UserProfile`   | `userProfile`   | `UserProfile`   | `user_profile`    | `user-profile`    |
| `user_profile`  | `userProfile`   | `UserProfile`   | `user_profile`    | `user-profile`    |
| `user-profile`  | `userProfile`   | `UserProfile`   | `user_profile`    | `user-profile`    |
| `user profile`  | `userProfile`   | `UserProfile`   | `user_profile`    | `user-profile`    |
| `USERProfileID` | `userProfileId` | `UserProfileId` | `user_profile_id` | `user-profile-id` |

---

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/ivantokar/mage-stencil-kit.git", from: "1.0.0")
```

Then to your target dependencies:

```swift
.product(name: "MageStencilKit", package: "mage-stencil-kit")
```

---

## 🛠 Usage

MageStencilKit provides **two ways** to use the transformation functions:

### 1️⃣ As Stencil Template Filters

```swift
import Stencil
import MageStencilKit

let env = Environment(loader: ...)
MageStencilFilters.register(on: env)
```

Then use in `.stencil` templates:

```stencil
{# Case Conversion #}
{{ "user_profile_id" | camelcase }}       → userProfileId
{{ "user profile" | pascalCase }}         → UserProfile
{{ "UserProfileId" | snakecase }}         → user_profile_id
{{ "EmailToAdmin" | kebab-case }}         → email-to-admin

{# String Transformation #}
{{ "hello world" | uppercase }}           → HELLO WORLD
{{ "HELLO" | lowercase }}                 → hello
{{ "hello world" | capitalize }}          → Hello World
{{ "hello world" | capitalizeFirst }}     → Hello world

{# Pluralization #}
{{ "Category" | pluralize }}              → Categories
{{ "Person" | pluralize }}                → People
{{ "Categories" | singularize }}          → Category

{# Utilities #}
{% if "HTTP" | isAcronym %}
  const HTTP_CONSTANT = "HTTP";
{% endif %}
```

**Advanced Template Examples:**

```stencil
{# Generate repository variable from entity name #}
const {{ entityName | camelCase }}Repository = new {{ entityName }}Repository();

{# Generate route path from entity name #}
router.get('/{{ entityName | kebabCase | pluralize }}', handler);

{# Generate plural controller method #}
async getAll{{ entityName | pluralize }}() {
  // Implementation
}

{# Generate database table name (snake_case plural) #}
const tableName = "{{ entityName | snakeCase | pluralize }}";
// User → users, Category → categories
```

### 2️⃣ As Swift String Extensions

All filters are also available as **public String extension methods** for use in Swift code:

```swift
import MageStencilKit

// Case conversion
let className = "user_profile".pascalCased()        // "UserProfile"
let variableName = "UserProfile".camelCased()       // "userProfile"
let databaseColumn = "UserProfile".snakeCased()     // "user_profile"
let cssClass = "UserProfile".kebabCased()           // "user-profile"

// Tokenization (helpful for parsing)
let tokens = "EmailToAdmin".tokenized()             // ["email", "to", "admin"]

// Pluralization
let tableName = "Category".pluralized()             // "Categories"
let singular = "People".singularized()              // "Person"

// Example: Generate filename from class name
let className = "EmailToAdmin"
let fileName = "\(className.kebabCased()).component.ts"  // "email-to-admin.component.ts"
```

**Why both?** This dual approach ensures:
- ✅ **Consistency** - Swift code and Stencil templates use the same transformation logic
- ✅ **Flexibility** - Use filters in templates OR methods in Swift code
- ✅ **Zero Duplication** - Single source of truth for all transformations

**Perfect for code generators** like [Mage CLI](https://github.com/ivantokar/mage) that need transformations in both contexts!

---

## 📚 API Reference

### Public String Extensions

All methods are available via `import MageStencilKit`:

| Method | Description | Example |
|--------|-------------|---------|
| `tokenized() -> [String]` | Split string into word tokens | `"EmailToAdmin"` → `["email", "to", "admin"]` |
| `pascalCased() -> String` | Convert to PascalCase | `"user-profile"` → `"UserProfile"` |
| `camelCased() -> String` | Convert to camelCase | `"UserProfile"` → `"userProfile"` |
| `snakeCased() -> String` | Convert to snake_case | `"UserProfile"` → `"user_profile"` |
| `kebabCased() -> String` | Convert to kebab-case | `"UserProfile"` → `"user-profile"` |
| `pluralized() -> String` | Convert to plural | `"Category"` → `"Categories"` |
| `singularized() -> String` | Convert to singular | `"Categories"` → `"Category"` |

### Stencil Filters

All filters support multiple naming styles for convenience:

**Case Conversion:**
- `camelcase`, `camelCase`
- `pascalcase`, `pascalCase`, `PascalCase`
- `snakecase`, `snakeCase`, `snake_case`
- `kebabcase`, `kebabCase`, `kebab-case`

**String Transformation:**
- `uppercase`, `lowercase`
- `capitalize`, `capitalizeFirst`, `capitalizedFirst`
- `titlecase`, `titleCase`

**Pluralization:**
- `pluralize`, `singularize`

**Utilities:**
- `isAcronym` (returns boolean)

---

## 🏗️ Architecture

MageStencilKit uses a **smart tokenization algorithm** that correctly handles:

- **PascalCase**: `EmailToAdmin` → `["email", "to", "admin"]`
- **camelCase**: `emailToAdmin` → `["email", "to", "admin"]`
- **snake_case**: `email_to_admin` → `["email", "to", "admin"]`
- **kebab-case**: `email-to-admin` → `["email", "to", "admin"]`
- **Acronyms**: `HTTPSConnection` → `["https", "connection"]`
- **Mixed formats**: `API2Client` → `["api", "2", "client"]`

This enables **seamless conversion between any naming convention** and ensures consistency across your codebase.

### Pluralization Rules

English pluralization with comprehensive rules:

**Special Cases:** person→people, man→men, child→children, tooth→teeth, mouse→mice

**Suffix Rules:**
- Words ending in `-y` (consonant before): `category` → `categories`
- Words ending in `-s`, `-x`, `-z`, `-ch`, `-sh`: `box` → `boxes`
- Words ending in `-f`, `-fe`: `knife` → `knives`
- Words ending in `-o` (consonant before): `hero` → `heroes`

**Case Preservation:** Maintains capitalization (`Category` → `Categories`, `person` → `people`)

---

## 🧪 Run Tests

We use Swift's new [Testing](https://github.com/apple/swift-testing) framework.

```bash
swift test
```

---

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

**Ideas for contributions:**
- Additional pluralization edge cases
- More language-specific transformations
- Performance optimizations
- Additional utility filters

---

## 🔗 Related Projects

- **[Mage CLI](https://github.com/ivantokar/mage)** - DDD code generator for Node.js/TypeScript that uses MageStencilKit
- **[Stencil](https://github.com/stencilproject/Stencil)** - The templating engine for Swift

---

## 🔖 License

MIT License. Created with ❤️ to make Stencil more expressive in Swift projects.
