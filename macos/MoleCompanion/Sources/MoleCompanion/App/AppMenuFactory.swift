import AppKit

enum AppMenuFactory {
    @MainActor
    static func makeMainMenu(delegate: AppDelegate) -> NSMenu {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu(title: "MoleCompanion")
        appMenu.addItem(withTitle: "About Mole", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Settings...", action: #selector(AppDelegate.openSettings), keyEquivalent: ",").target = delegate
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit Mole", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)

        let moleMenuItem = NSMenuItem()
        let moleMenu = NSMenu(title: "Mole")
        let openDashboard = moleMenu.addItem(withTitle: "Open Dashboard", action: #selector(AppDelegate.openDashboard), keyEquivalent: "1")
        openDashboard.target = delegate
        let openWidget = moleMenu.addItem(withTitle: "Open Widget", action: #selector(AppDelegate.openDesktopWidget), keyEquivalent: "2")
        openWidget.target = delegate
        moleMenu.addItem(NSMenuItem.separator())
        let refresh = moleMenu.addItem(withTitle: "Refresh Status", action: #selector(AppDelegate.refreshStatus), keyEquivalent: "r")
        refresh.target = delegate
        let previewClean = moleMenu.addItem(withTitle: "Preview Clean", action: #selector(AppDelegate.previewClean), keyEquivalent: "K")
        previewClean.target = delegate
        let previewPurge = moleMenu.addItem(withTitle: "Preview Purge", action: #selector(AppDelegate.previewPurge), keyEquivalent: "P")
        previewPurge.target = delegate
        moleMenuItem.submenu = moleMenu
        mainMenu.addItem(moleMenuItem)

        let windowMenuItem = NSMenuItem()
        let windowMenu = NSMenu(title: "Window")
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.zoom(_:)), keyEquivalent: "")
        windowMenuItem.submenu = windowMenu
        mainMenu.addItem(windowMenuItem)
        NSApp.windowsMenu = windowMenu

        return mainMenu
    }
}
