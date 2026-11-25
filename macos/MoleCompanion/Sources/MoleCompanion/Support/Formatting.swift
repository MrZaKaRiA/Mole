import Foundation

enum MoleFormat {
    static func percent(_ value: Double?, digits: Int = 0) -> String {
        guard let value else { return "--" }
        return String(format: "%.\(digits)f%%", value)
    }

    static func number(_ value: Double?, digits: Int = 1) -> String {
        guard let value else { return "--" }
        return String(format: "%.\(digits)f", value)
    }

    static func bytes(_ value: UInt64?) -> String {
        guard let value else { return "--" }
        let units = ["B", "KB", "MB", "GB", "TB"]
        var amount = Double(value)
        var index = 0

        while amount >= 1024, index < units.count - 1 {
            amount /= 1024
            index += 1
        }

        let digits = index <= 1 ? 0 : 1
        return String(format: "%.\(digits)f %@", amount, units[index])
    }

    static func rate(_ value: Double?) -> String {
        guard let value else { return "--" }
        return String(format: "%.1f MB/s", value)
    }

    static func fallback(_ value: String?, _ fallback: String = "--") -> String {
        guard let value, !value.isEmpty else { return fallback }
        return value
    }
}
