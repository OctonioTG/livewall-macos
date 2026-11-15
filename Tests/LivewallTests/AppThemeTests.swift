import SwiftUI
import Testing
@testable import Livewall

@MainActor
@Suite struct AppThemeTests {
    @Test func colorSchemeMatchesTheme() {
        #expect(AppTheme.system.colorScheme == nil)
        #expect(AppTheme.light.colorScheme == .light)
        #expect(AppTheme.dark.colorScheme == .dark)
    }

    @Test func allCasesHaveValidIdentifiersAndDisplayNames() {
        for theme in AppTheme.allCases {
            #expect(!theme.id.isEmpty)
            #expect(!theme.displayName.isEmpty)
        }
    }

    @Test func persistsThemeInUserDefaults() {
        let suiteName = "test-theme-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let settings = AppSettings(defaults: defaults)
        #expect(settings.theme == .system)

        settings.theme = .dark
        #expect(defaults.string(forKey: "appTheme") == "dark")

        let reloaded = AppSettings(defaults: defaults)
        #expect(reloaded.theme == .dark)

        settings.theme = .light
        #expect(defaults.string(forKey: "appTheme") == "light")
        #expect(AppSettings(defaults: defaults).theme == .light)
    }
}
