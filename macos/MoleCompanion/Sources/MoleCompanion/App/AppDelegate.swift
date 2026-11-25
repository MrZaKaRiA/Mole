import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let store = MoleStore()
    private var mainWindowController: MainWindowController?
    private var widgetWindowController: DesktopWidgetWindowController?
    private var settingsWindowController: SettingsWindowController?
    private var statusMenuController: StatusMenuController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.mainMenu = AppMenuFactory.makeMainMenu(delegate: self)

        mainWindowController = MainWindowController(store: store, delegate: self)
        widgetWindowController = DesktopWidgetWindowController(store: store, delegate: self)
        settingsWindowController = SettingsWindowController(store: store)
        statusMenuController = StatusMenuController(store: store, delegate: self)

        openDashboard()

        Task { @MainActor in
            await store.refreshStatus()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    @objc func openDashboard() {
        NSApp.activate(ignoringOtherApps: true)
        mainWindowController?.showWindow(nil)
        mainWindowController?.present()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            NSApp.activate(ignoringOtherApps: true)
            self?.mainWindowController?.present()
        }
    }

    @objc func openDesktopWidget() {
        widgetWindowController?.showWindow(nil)
        widgetWindowController?.window?.orderFrontRegardless()
    }

    @objc func openSettings() {
        settingsWindowController?.showWindow(nil)
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func refreshStatus() {
        Task { @MainActor in
            await store.refreshStatus()
        }
    }

    @objc func previewClean() {
        Task { @MainActor in
            await store.runCommand(.cleanDryRun)
            openDashboard()
        }
    }

    @objc func previewPurge() {
        Task { @MainActor in
            await store.runCommand(.purgeDryRun)
            openDashboard()
        }
    }
}
