import Foundation

/// Presentation state and actions for `LibraryView`.
@MainActor
final class LibraryViewModel: ObservableObject {
    @Published var isImporting = false
    @Published var isAddingWebsite = false
    @Published var importError: String?

    func importFiles(_ result: Result<[URL], Error>, library: WallpaperLibrary, settings: AppSettings) {
        do {
            var lastImported: Wallpaper?
            for url in try result.get() {
                lastImported = try library.importItem(at: url)
            }
            if let lastImported {
                settings.selectedWallpaperID = lastImported.id
            }
        } catch {
            importError = error.localizedDescription
        }
    }

    func remove(_ wallpaper: Wallpaper, library: WallpaperLibrary, settings: AppSettings, lockScreen: LockScreenModel? = nil) {
        if settings.selectedWallpaperID == wallpaper.id {
            let fallback = library.userWallpapers.first(where: { $0.id != wallpaper.id })?.id
                ?? BuiltInShaders.wallpapers.first?.id
            settings.selectedWallpaperID = fallback
        }
        lockScreen?.restoreIfApplied(wallpaperID: wallpaper.id)
        library.remove(wallpaper)
    }
}
