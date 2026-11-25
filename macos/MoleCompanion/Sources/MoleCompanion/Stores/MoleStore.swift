import Foundation

@MainActor
final class MoleStore {
    var selectedTab: MoleTab = .overview {
        didSet { notifyObservers() }
    }

    var snapshot: MoleSnapshot = .sample {
        didSet { notifyObservers() }
    }

    var isRefreshing = false {
        didSet { notifyObservers() }
    }

    var isRunningCommand = false {
        didSet { notifyObservers() }
    }

    var lastCommand: MoleCommand? {
        didSet { notifyObservers() }
    }

    var commandOutput = "No command has been run from the companion app yet." {
        didSet { notifyObservers() }
    }

    var lastError: String? {
        didSet { notifyObservers() }
    }

    var useMockData = false {
        didSet { notifyObservers() }
    }

    var cliPath = MoleCLIService.defaultCLIPath() {
        didSet { notifyObservers() }
    }

    private let service = MoleCLIService()
    private var observers: [UUID: () -> Void] = [:]

    @discardableResult
    func addObserver(_ observer: @escaping () -> Void) -> UUID {
        let id = UUID()
        observers[id] = observer
        observer()
        return id
    }

    func removeObserver(_ id: UUID) {
        observers.removeValue(forKey: id)
    }

    func refreshStatus() async {
        guard !isRefreshing else { return }

        isRefreshing = true
        defer { isRefreshing = false }

        if useMockData {
            snapshot = .sample
            lastError = nil
            return
        }

        do {
            snapshot = try await service.fetchStatusSnapshot(cliPath: cliPath)
            lastError = nil
        } catch {
            snapshot = .sample
            lastError = error.localizedDescription
        }
    }

    func runCommand(_ command: MoleCommand) async {
        guard !isRunningCommand else { return }

        isRunningCommand = true
        lastCommand = command
        commandOutput = "Running \(command.title)..."
        defer { isRunningCommand = false }

        if useMockData {
            commandOutput = """
            $ mo \(command.arguments.joined(separator: " "))

            Mock preview complete.
            Live command execution is disabled while mock data is enabled.
            """
            lastError = nil
            return
        }

        do {
            commandOutput = try await service.run(command: command, cliPath: cliPath)
            lastError = nil
        } catch {
            commandOutput = error.localizedDescription
            lastError = error.localizedDescription
        }
    }

    func payloadJSON() -> String {
        let payload = MoleUIPayload(
            selectedTab: selectedTab.rawValue,
            isRefreshing: isRefreshing,
            isRunningCommand: isRunningCommand,
            lastCommand: lastCommand?.rawValue,
            commandOutput: commandOutput,
            lastError: lastError,
            useMockData: useMockData,
            cliPath: cliPath,
            tabs: MoleTab.allCases,
            commands: MoleCommand.allCases,
            snapshot: snapshot
        )

        do {
            let data = try JSONEncoder().encode(payload)
            return String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            return "{}"
        }
    }

    private func notifyObservers() {
        for observer in observers.values {
            observer()
        }
    }
}

struct MoleUIPayload: Encodable {
    let selectedTab: String
    let isRefreshing: Bool
    let isRunningCommand: Bool
    let lastCommand: String?
    let commandOutput: String
    let lastError: String?
    let useMockData: Bool
    let cliPath: String
    let tabs: [MoleTab]
    let commands: [MoleCommand]
    let snapshot: MoleSnapshot
}

extension MoleTab: Encodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case iconName
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(iconName, forKey: .iconName)
    }
}

extension MoleCommand: Encodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case arguments
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(arguments, forKey: .arguments)
    }
}
