import SwiftStencilKit
import Stencil
import Testing

@Suite struct SwiftStencilKitTests {
    func render(_ template: String, _ context: [String: Any]) throws -> String {
        let env = Environment(loader: nil)
        SwiftStencilFilters.register(on: env)
        return try env.renderTemplate(string: template, context: context)
    }

    @Test func camelCase() throws {
        let result = try render("{{ input | camelcase }}", ["input": "user_profile_id"])
        #expect(result == "userProfileId")
    }

    @Test func pascalCase() throws {
        let result = try render("{{ input | pascalcase }}", ["input": "user-profile-id"])
        #expect(result == "UserProfileId")
    }

    @Test func snakeCase() throws {
        let result = try render("{{ input | snakecase }}", ["input": "UserProfileId"])
        #expect(result == "user_profile_id")
    }

    @Test func kebabCase() throws {
        let result = try render("{{ input | kebabcase }}", ["input": "user profile ID"])
        #expect(result == "user-profile-id")
    }

    @Test func pluralize() throws {
        #expect(try render("{{ word | pluralize }}", ["word": "company"]) == "companies")
        #expect(try render("{{ word | pluralize }}", ["word": "bus"]) == "buses")
        #expect(try render("{{ word | pluralize }}", ["word": "user"]) == "users")
    }

    @Test func titleCase() throws {
        let result = try render("{{ name | titlecase }}", ["name": "hello world"])
        #expect(result == "Hello World")
    }

    @Test func capitalizedFirst() throws {
        let result = try render("{{ name | capitalizedFirst }}", ["name": "vapor"])
        #expect(result == "Vapor")
    }

    @Test func isAcronym() throws {
        #expect(try render("{{ name | isAcronym }}", ["name": "HTML"]) == "true")
        #expect(try render("{{ name | isAcronym }}", ["name": "Http"]) == "false")
    }

    // MARK: - New Case Conversions

    @Test func constantCase() throws {
        #expect(try render("{{ input | constantcase }}", ["input": "myAppName"]) == "MY_APP_NAME")
        #expect(try render("{{ input | CONSTANT_CASE }}", ["input": "user-profile"]) == "USER_PROFILE")
    }

    @Test func dotCase() throws {
        #expect(try render("{{ input | dotcase }}", ["input": "myAppName"]) == "my.app.name")
        #expect(try render("{{ input | dotCase }}", ["input": "UserProfile"]) == "user.profile")
    }

    @Test func pathCase() throws {
        #expect(try render("{{ input | pathcase }}", ["input": "myAppName"]) == "my/app/name")
        #expect(try render("{{ input | pathCase }}", ["input": "user_profile"]) == "user/profile")
    }

    @Test func sentenceCase() throws {
        #expect(try render("{{ input | sentencecase }}", ["input": "myAppName"]) == "My app name")
        #expect(try render("{{ input | sentenceCase }}", ["input": "user-profile"]) == "User profile")
    }

    @Test func headerCase() throws {
        #expect(try render("{{ input | headercase }}", ["input": "myAppName"]) == "My-App-Name")
        #expect(try render("{{ input | headerCase }}", ["input": "user_profile"]) == "User-Profile")
    }

    // MARK: - Utility Filters

    @Test func countFilter() throws {
        #expect(try render("{{ items | count }}", ["items": ["a", "b", "c"]]) == "3")
        #expect(try render("{{ text | count }}", ["text": "hello"]) == "5")
    }

    @Test func isEmptyFilter() throws {
        #expect(try render("{{ items | isEmpty }}", ["items": [String]()]) == "true")
        #expect(try render("{{ items | isEmpty }}", ["items": ["a"]]) == "false")
        #expect(try render("{{ text | isEmpty }}", ["text": ""]) == "true")
    }

    @Test func isNotEmptyFilter() throws {
        #expect(try render("{{ items | isNotEmpty }}", ["items": ["a"]]) == "true")
        #expect(try render("{{ items | isNotEmpty }}", ["items": [String]()]) == "false")
    }

    @Test func firstFilter() throws {
        #expect(try render("{{ items | first }}", ["items": ["a", "b", "c"]]) == "a")
        #expect(try render("{{ text | first }}", ["text": "hello"]) == "h")
    }

    @Test func lastFilter() throws {
        #expect(try render("{{ items | last }}", ["items": ["a", "b", "c"]]) == "c")
        #expect(try render("{{ text | last }}", ["text": "hello"]) == "o")
    }

    @Test func joinFilter() throws {
        #expect(try render("{{ items | join:\", \" }}", ["items": ["a", "b", "c"]]) == "a, b, c")
        #expect(try render("{{ items | join:\"-\" }}", ["items": ["x", "y"]]) == "x-y")
    }

    @Test func splitFilter() throws {
        let result = try render("{{ text | split:\"-\" | first }}", ["text": "a-b-c"])
        #expect(result == "a")
    }
}
