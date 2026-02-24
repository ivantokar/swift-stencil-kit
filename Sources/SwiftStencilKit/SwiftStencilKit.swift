// SwiftStencilKit.swift
// This module adds custom Stencil filters for Swift projects

import Foundation
import Stencil

public class SwiftStencilFilters {
    public static func register(on environment: Environment) {
        for ext in environment.extensions {
            // Case conversion filters (with both lowercase and camelCase aliases)
            ext.registerFilter("camelcase", filter: { camelCase($0) })
            ext.registerFilter("camelCase", filter: { camelCase($0) })

            ext.registerFilter("pascalcase", filter: { pascalCase($0) })
            ext.registerFilter("pascalCase", filter: { pascalCase($0) })
            ext.registerFilter("PascalCase", filter: { pascalCase($0) })

            ext.registerFilter("snakecase", filter: { snakeCase($0) })
            ext.registerFilter("snakeCase", filter: { snakeCase($0) })
            ext.registerFilter("snake_case", filter: { snakeCase($0) })

            ext.registerFilter("kebabcase", filter: { kebabCase($0) })
            ext.registerFilter("kebabCase", filter: { kebabCase($0) })
            ext.registerFilter("kebab-case", filter: { kebabCase($0) })

            // String transformation filters
            ext.registerFilter("uppercase", filter: { uppercase($0) })
            ext.registerFilter("lowercase", filter: { lowercase($0) })
            ext.registerFilter("capitalize", filter: { capitalize($0) })
            ext.registerFilter("capitalizeFirst", filter: { capitalizeFirst($0) })
            ext.registerFilter("capitalizedFirst", filter: { capitalizeFirst($0) })

            // Title case
            ext.registerFilter("titlecase", filter: { titleCase($0) })
            ext.registerFilter("titleCase", filter: { titleCase($0) })

            // Pluralization
            ext.registerFilter("pluralize", filter: { pluralize($0) })
            ext.registerFilter("singularize", filter: { singularize($0) })

            // Additional case conversions
            ext.registerFilter("constantcase", filter: { constantCase($0) })
            ext.registerFilter("CONSTANT_CASE", filter: { constantCase($0) })

            ext.registerFilter("dotcase", filter: { dotCase($0) })
            ext.registerFilter("dotCase", filter: { dotCase($0) })

            ext.registerFilter("pathcase", filter: { pathCase($0) })
            ext.registerFilter("pathCase", filter: { pathCase($0) })

            ext.registerFilter("sentencecase", filter: { sentenceCase($0) })
            ext.registerFilter("sentenceCase", filter: { sentenceCase($0) })

            ext.registerFilter("headercase", filter: { headerCase($0) })
            ext.registerFilter("headerCase", filter: { headerCase($0) })

            // Utility filters
            ext.registerFilter("isAcronym", filter: { isAcronym($0) })
            ext.registerFilter("count", filter: { count($0) })
            ext.registerFilter("isEmpty", filter: { isEmpty($0) })
            ext.registerFilter("isNotEmpty", filter: { isNotEmpty($0) })
            ext.registerFilter("first", filter: { first($0) })
            ext.registerFilter("last", filter: { last($0) })
            ext.registerFilter("join", filter: joinFilter)
            ext.registerFilter("split", filter: splitFilter)
        }
    }

    private static func camelCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.camelCased()
    }

    private static func pascalCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.pascalCased()
    }

    private static func snakeCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.snakeCased()
    }

    private static func kebabCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.kebabCased()
    }

    private static func uppercase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.uppercased()
    }

    private static func lowercase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.lowercased()
    }

    private static func capitalize(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.capitalized
    }

    private static func capitalizeFirst(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        guard !string.isEmpty else { return string }
        return string.prefix(1).uppercased() + string.dropFirst()
    }

    private static func titleCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.capitalized
    }

    private static func pluralize(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.pluralized()
    }

    private static func singularize(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.singularized()
    }

    private static func isAcronym(_ value: Any?) -> Bool {
        guard let string = value as? String else { return false }
        return string.uppercased() == string && string.count <= 6
    }

    private static func constantCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.constantCased()
    }

    private static func dotCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.dotCased()
    }

    private static func pathCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.pathCased()
    }

    private static func sentenceCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.sentenceCased()
    }

    private static func headerCase(_ value: Any?) -> String {
        guard let string = value as? String else { return "" }
        return string.headerCased()
    }

    private static func count(_ value: Any?) -> Int {
        if let array = value as? [Any] {
            return array.count
        }
        if let string = value as? String {
            return string.count
        }
        return 0
    }

    private static func isEmpty(_ value: Any?) -> Bool {
        if let array = value as? [Any] {
            return array.isEmpty
        }
        if let string = value as? String {
            return string.isEmpty
        }
        return true
    }

    private static func isNotEmpty(_ value: Any?) -> Bool {
        return !isEmpty(value)
    }

    private static func first(_ value: Any?) -> Any? {
        if let array = value as? [Any] {
            return array.first
        }
        if let string = value as? String {
            return string.first.map { String($0) }
        }
        return nil
    }

    private static func last(_ value: Any?) -> Any? {
        if let array = value as? [Any] {
            return array.last
        }
        if let string = value as? String {
            return string.last.map { String($0) }
        }
        return nil
    }

    private static func joinFilter(_ value: Any?, arguments: [Any?]) throws -> Any? {
        guard let array = value as? [Any] else { return "" }
        let separator = (arguments.first as? String) ?? ""
        return array.map { "\($0)" }.joined(separator: separator)
    }

    private static func splitFilter(_ value: Any?, arguments: [Any?]) throws -> Any? {
        guard let string = value as? String else { return [] }
        let separator = (arguments.first as? String) ?? ""
        return string.components(separatedBy: separator)
    }
}

// MARK: - Public String Extensions
// These extensions are available for use by any Swift code importing SwiftStencilKit

public extension String {
    /// Tokenize a string into word components
    /// Handles PascalCase, camelCase, snake_case, kebab-case, etc.
    func tokenized() -> [String] {
        let pattern = "([a-z0-9]+|[A-Z0-9]+(?![a-z])|[A-Z][a-z0-9]+)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [self] }
        let range = NSRange(self.startIndex..., in: self)
        let matches = regex.matches(in: self, range: range)
        return matches.map {
            String(self[Range($0.range, in: self)!]).lowercased()
        }
    }

    /// Convert string to PascalCase
    func pascalCased() -> String {
        return tokenized().map { $0.capitalized }.joined()
    }

    /// Convert string to camelCase
    func camelCased() -> String {
        let parts = tokenized()
        return parts.enumerated().map { i, part in
            i == 0 ? part : part.capitalized
        }.joined()
    }

    /// Convert string to snake_case
    func snakeCased() -> String {
        return tokenized().joined(separator: "_")
    }

    /// Convert string to kebab-case
    func kebabCased() -> String {
        return tokenized().joined(separator: "-")
    }

    /// Convert string to CONSTANT_CASE (screaming snake case)
    func constantCased() -> String {
        return tokenized().joined(separator: "_").uppercased()
    }

    /// Convert string to dot.case
    func dotCased() -> String {
        return tokenized().joined(separator: ".")
    }

    /// Convert string to path/case
    func pathCased() -> String {
        return tokenized().joined(separator: "/")
    }

    /// Convert string to Sentence case (first word capitalized)
    func sentenceCased() -> String {
        let tokens = tokenized()
        guard let first = tokens.first else { return "" }
        return ([first.capitalized] + tokens.dropFirst()).joined(separator: " ")
    }

    /// Convert string to Header-Case (title case with hyphens)
    func headerCased() -> String {
        return tokenized().map { $0.capitalized }.joined(separator: "-")
    }

    /// Pluralize a noun (English rules)
    func pluralized() -> String {
        // Special cases
        let specialCases: [String: String] = [
            "person": "people",
            "man": "men",
            "woman": "women",
            "child": "children",
            "tooth": "teeth",
            "foot": "feet",
            "mouse": "mice",
            "goose": "geese"
        ]

        let lower = self.lowercased()
        if let special = specialCases[lower] {
            // Preserve original casing
            if self.first?.isUppercase == true {
                return special.capitalized
            }
            return special
        }

        // Words ending in 'y' preceded by consonant
        if hasSuffix("y") && count > 1 {
            let beforeY = self[index(endIndex, offsetBy: -2)]
            if !"aeiou".contains(beforeY.lowercased()) {
                return String(dropLast()) + "ies"
            }
        }

        // Words ending in s, x, z, ch, sh
        if hasSuffix("s") || hasSuffix("x") || hasSuffix("z") ||
           hasSuffix("ch") || hasSuffix("sh") {
            return self + "es"
        }

        // Words ending in 'f' or 'fe'
        if hasSuffix("f") {
            return String(dropLast()) + "ves"
        }
        if hasSuffix("fe") {
            return String(dropLast(2)) + "ves"
        }

        // Words ending in 'o' preceded by consonant
        if hasSuffix("o") && count > 1 {
            let beforeO = self[index(endIndex, offsetBy: -2)]
            if !"aeiou".contains(beforeO.lowercased()) {
                return self + "es"
            }
        }

        // Default: just add 's'
        return self + "s"
    }

    /// Singularize a noun (English rules)
    func singularized() -> String {
        // Special cases
        let specialCases: [String: String] = [
            "people": "person",
            "men": "man",
            "women": "woman",
            "children": "child",
            "teeth": "tooth",
            "feet": "foot",
            "mice": "mouse",
            "geese": "goose"
        ]

        let lower = self.lowercased()
        if let special = specialCases[lower] {
            // Preserve original casing
            if self.first?.isUppercase == true {
                return special.capitalized
            }
            return special
        }

        // Words ending in 'ies'
        if hasSuffix("ies") && count > 3 {
            return String(dropLast(3)) + "y"
        }

        // Words ending in 'ves'
        if hasSuffix("ves") {
            return String(dropLast(3)) + "f"
        }

        // Words ending in 'es'
        if hasSuffix("es") && count > 2 {
            // Check if it's sses, xes, zes, ches, shes
            if hasSuffix("sses") || hasSuffix("xes") || hasSuffix("zes") ||
               hasSuffix("ches") || hasSuffix("shes") || hasSuffix("oes") {
                return String(dropLast(2))
            }
        }

        // Words ending in 's' (simple plural)
        if hasSuffix("s") && count > 1 {
            return String(dropLast())
        }

        // Already singular
        return self
    }
}
