import AppKit
import WebKit

@MainActor
final class MainWindowController: NSWindowController, WKScriptMessageHandler, WKNavigationDelegate {
    private let store: MoleStore
    private weak var appDelegate: AppDelegate?
    private let webView: WKWebView
    private var observerID: UUID?

    init(store: MoleStore, delegate: AppDelegate) {
        self.store = store
        self.appDelegate = delegate

        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        self.webView = WKWebView(frame: .zero, configuration: config)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1440, height: 860),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Mole"
        window.titlebarAppearsTransparent = false
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor.windowBackgroundColor
        window.collectionBehavior = [.managed, .moveToActiveSpace]
        window.identifier = NSUserInterfaceItemIdentifier("MoleMainWindow")
        window.isRestorable = false
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 1180, height: 720)
        window.center()
        window.contentView = webView

        super.init(window: window)

        contentController.add(self, name: "mole")
        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground")
        webView.loadHTMLString(DashboardHTML.main, baseURL: nil)

        observerID = store.addObserver { [weak self] in
            self?.pushState()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        present()
        pushState()
    }

    func present() {
        guard let window else { return }
        window.setFrame(NSRect(x: 180, y: 120, width: 1440, height: 860), display: true)
        if !window.isVisible {
            window.center()
        }
        window.alphaValue = 1
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let payload = message.body as? [String: Any],
              let action = payload["action"] as? String else {
            return
        }

        Task { @MainActor in
            switch action {
            case "refresh":
                await store.refreshStatus()
            case "selectTab":
                if let raw = payload["tab"] as? String, let tab = MoleTab(rawValue: raw) {
                    store.selectedTab = tab
                }
            case "runCommand":
                if let raw = payload["command"] as? String, let command = MoleCommand(rawValue: raw) {
                    await store.runCommand(command)
                    store.selectedTab = .history
                }
            case "openWidget":
                appDelegate?.openDesktopWidget()
            case "openSettings":
                appDelegate?.openSettings()
            default:
                break
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pushState()
    }

    private func pushState() {
        let json = store.payloadJSON()
        webView.evaluateJavaScript("window.moleUpdate && window.moleUpdate(\(json));", completionHandler: nil)
    }
}
