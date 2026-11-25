import AppKit
import WebKit

@MainActor
final class DesktopWidgetWindowController: NSWindowController, WKScriptMessageHandler, WKNavigationDelegate {
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

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 328, height: 420),
            styleMask: [.titled, .closable, .utilityWindow, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.title = "Mole Widget"
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isFloatingPanel = true
        panel.isMovableByWindowBackground = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.contentView = webView

        super.init(window: panel)

        contentController.add(self, name: "mole")
        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground")
        webView.loadHTMLString(DashboardHTML.widget, baseURL: nil)

        observerID = store.addObserver { [weak self] in
            self?.pushState()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        pushState()
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
            case "runCommand":
                await store.runCommand(.cleanDryRun)
                appDelegate?.openDashboard()
            case "openDashboard":
                appDelegate?.openDashboard()
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
