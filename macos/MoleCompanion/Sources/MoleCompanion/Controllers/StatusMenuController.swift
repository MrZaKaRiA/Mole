import AppKit

@MainActor
final class StatusMenuController: NSObject {
    private let store: MoleStore
    private weak var appDelegate: AppDelegate?
    private let statusItem: NSStatusItem
    private var observerID: UUID?

    private let healthItem = NSMenuItem(title: "Health --", action: nil, keyEquivalent: "")
    private let cpuItem = NSMenuItem(title: "CPU --", action: nil, keyEquivalent: "")
    private let memoryItem = NSMenuItem(title: "Memory --", action: nil, keyEquivalent: "")
    private let diskItem = NSMenuItem(title: "Disk --", action: nil, keyEquivalent: "")

    init(store: MoleStore, delegate: AppDelegate) {
        self.store = store
        self.appDelegate = delegate
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()
        configureStatusItem()
        observerID = store.addObserver { [weak self] in
            self?.updateMenu()
        }
    }

    private func configureStatusItem() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "gauge.with.dots.needle.bottom.50percent", accessibilityDescription: "Mole")
            button.imagePosition = .imageLeading
            button.title = " --"
        }

        let menu = NSMenu()
        healthItem.isEnabled = false
        cpuItem.isEnabled = false
        memoryItem.isEnabled = false
        diskItem.isEnabled = false
        menu.addItem(healthItem)
        menu.addItem(cpuItem)
        menu.addItem(memoryItem)
        menu.addItem(diskItem)
        menu.addItem(NSMenuItem.separator())

        addMenuItem("Open Dashboard", #selector(AppDelegate.openDashboard), to: menu)
        addMenuItem("Desktop Widget", #selector(AppDelegate.openDesktopWidget), to: menu)
        addMenuItem("Refresh Status", #selector(AppDelegate.refreshStatus), to: menu)
        addMenuItem("Preview Clean", #selector(AppDelegate.previewClean), to: menu)
        menu.addItem(NSMenuItem.separator())
        addMenuItem("Settings", #selector(AppDelegate.openSettings), to: menu)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit Mole", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        statusItem.menu = menu
    }

    private func addMenuItem(_ title: String, _ action: Selector, to menu: NSMenu) {
        let item = menu.addItem(withTitle: title, action: action, keyEquivalent: "")
        item.target = appDelegate
    }

    private func updateMenu() {
        let snapshot = store.snapshot
        healthItem.title = "Health \(snapshot.health)"
        cpuItem.title = "CPU \(MoleFormat.percent(snapshot.cpu?.usage))"
        memoryItem.title = "Memory \(MoleFormat.percent(snapshot.memory?.usedPercent))"
        diskItem.title = "Disk \(MoleFormat.percent(snapshot.primaryDisk?.usedPercent))"

        if let button = statusItem.button {
            button.title = " \(snapshot.health)"
        }
    }
}
