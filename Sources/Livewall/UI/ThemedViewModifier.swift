import SwiftUI

/// Applies the user's preferred color scheme to any view hierarchy.
struct ThemedViewModifier: ViewModifier {
    @ObservedObject var settings: AppSettings

    func body(content: Content) -> some View {
        content.preferredColorScheme(settings.theme.colorScheme)
    }
}

extension View {
    /// Passes the view through the theme constructor modifier to apply the active color scheme.
    func withAppTheme(_ settings: AppSettings) -> some View {
        modifier(ThemedViewModifier(settings: settings))
    }
}

