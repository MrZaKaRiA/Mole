import Foundation

enum MoleCLIError: LocalizedError {
    case executableMissing(String)
    case commandFailed(status: Int32, output: String)
    case emptyOutput

    var errorDescription: String? {
        switch self {
        case .executableMissing(let path):
            "Mole CLI was not found at \(path). Install `mo` or set the path in Settings."
        case .commandFailed(let status, let output):
            "Mole command failed with exit code \(status).\n\n\(output)"
        case .emptyOutput:
            "Mole returned no output."
        }
    }
}

struct MoleCLIService {
    static func defaultCLIPath() -> String {
        let env = Foundation.ProcessInfo.processInfo.environment
        if let configured = env["MOLE_CLI_PATH"], FileManager.default.isExecutableFile(atPath: configured) {
            return configured
        }

        let candidates: [String?] = [
            Bundle.main.resourceURL?
                .appendingPathComponent("MoleCLI")
                .appendingPathComponent("mole")
                .path,
            "/opt/homebrew/bin/mo",
            "/usr/local/bin/mo",
            Bundle.main.bundleURL
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("mole")
                .path,
            URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("mole")
                .path,
            URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent("../../mole")
                .standardizedFileURL
                .path
        ]

        return candidates.compactMap { $0 }.first(where: { FileManager.default.isExecutableFile(atPath: $0) }) ?? "/opt/homebrew/bin/mo"
    }

    func fetchStatusSnapshot(cliPath: String) async throws -> MoleSnapshot {
        let data = try await run(arguments: ["status", "--json"], cliPath: cliPath)
        let decoder = JSONDecoder()
        return try decoder.decode(MoleSnapshot.self, from: data)
    }

    func run(command: MoleCommand, cliPath: String) async throws -> String {
        let data = try await run(arguments: command.arguments, cliPath: cliPath)
        guard let output = String(data: data, encoding: .utf8), !output.isEmpty else {
            throw MoleCLIError.emptyOutput
        }
        return output
    }

    private func run(arguments: [String], cliPath: String) async throws -> Data {
        try await Task.detached(priority: .userInitiated) {
            guard FileManager.default.isExecutableFile(atPath: cliPath) else {
                throw MoleCLIError.executableMissing(cliPath)
            }

            let process = Process()
            process.executableURL = URL(fileURLWithPath: cliPath)
            process.arguments = arguments

            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError = stderr

            try process.run()
            process.waitUntilExit()

            let stdoutData = stdout.fileHandleForReading.readDataToEndOfFile()
            let stderrData = stderr.fileHandleForReading.readDataToEndOfFile()

            if process.terminationStatus != 0 {
                let out = String(data: stdoutData + stderrData, encoding: .utf8) ?? ""
                throw MoleCLIError.commandFailed(status: process.terminationStatus, output: out)
            }

            if stdoutData.isEmpty {
                return stderrData
            }

            return stdoutData
        }.value
    }
}
