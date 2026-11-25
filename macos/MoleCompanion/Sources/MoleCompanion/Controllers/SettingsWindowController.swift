import AppKit

@MainActor
final class SettingsWindowController: NSWindowController {
    private let store: MoleStore
    private let pathField = NSTextField()
    private let mockCheckbox = NSButton(checkboxWithTitle: "Use mock data for UI design", target: nil, action: nil)
    private var observerID: UUID?

    init(store: MoleStore) {
        self.store = store

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 540, height: 280),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Mole Settings"

        super.init(window: window)
        window.contentView = makeContentView()

        observerID = store.addObserver { [weak self] in
            self?.syncFromStore()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeContentView() -> NSView {
        let root = NSVisualEffectView()
        root.material = .windowBackground
        root.blendingMode = .behindWindow

        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        let title = NSTextField(labelWithString: "Mole CLI")
        title.font = .systemFont(ofSize: 20, weight: .semibold)

        let detail = NSTextField(wrappingLabelWithString: "The companion app reads `mo status --json` and runs only dry-run preview commands from the UI.")
        detail.textColor = .secondaryLabelColor

        pathField.placeholderString = "/opt/homebrew/bin/mo"
        pathField.target = self
        pathField.action = #selector(pathChanged)
        pathField.translatesAutoresizingMaskIntoConstraints = false

        mockCheckbox.target = self
        mockCheckbox.action = #selector(mockChanged)

        let refresh = NSButton(title: "Refresh Status", target: self, action: #selector(refreshStatus))
        refresh.bezelStyle = .rounded

        stack.addArrangedSubview(title)
        stack.addArrangedSubview(detail)
        stack.addArrangedSubview(label("CLI path"))
        stack.addArrangedSubview(pathField)
        stack.addArrangedSubview(mockCheckbox)
        stack.addArrangedSubview(refresh)

        root.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: root.topAnchor, constant: 24),
            pathField.widthAnchor.constraint(equalTo: stack.widthAnchor)
        ])

        return root
    }

    private func label(_ text: String) -> NSTextField {
        let field = NSTextField(labelWithString: text)
        field.font = .systemFont(ofSize: 12, weight: .semibold)
        field.textColor = .secondaryLabelColor
        return field
    }

    private func syncFromStore() {
        pathField.stringValue = store.cliPath
        mockCheckbox.state = store.useMockData ? .on : .off
    }

    @objc private func pathChanged() {
        store.cliPath = pathField.stringValue
    }

    @objc private func mockChanged() {
        store.useMockData = mockCheckbox.state == .on
    }

    @objc private func refreshStatus() {
        Task { @MainActor in
            await store.refreshStatus()
        }
    }
}
