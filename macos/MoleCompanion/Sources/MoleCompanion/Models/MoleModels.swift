import Foundation

enum MoleTab: String, CaseIterable, Identifiable {
    case overview
    case clean
    case analyze
    case optimize
    case history

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview: "Overview"
        case .clean: "Clean"
        case .analyze: "Analyze"
        case .optimize: "Optimize"
        case .history: "History"
        }
    }

    var subtitle: String {
        switch self {
        case .overview: "Live Mac health"
        case .clean: "Dry-run cleanup"
        case .analyze: "Storage insight"
        case .optimize: "Safe maintenance"
        case .history: "Recent output"
        }
    }

    var iconName: String {
        switch self {
        case .overview: "health"
        case .clean: "clean"
        case .analyze: "disk"
        case .optimize: "spark"
        case .history: "history"
        }
    }
}

enum MoleCommand: String, CaseIterable, Identifiable {
    case clean
    case cleanDryRun
    case uninstallDryRun
    case purgeDryRun
    case installerDryRun
    case optimizeDryRun

    var id: String { rawValue }

    var title: String {
        switch self {
        case .clean: "Clean"
        case .cleanDryRun: "Preview Clean"
        case .uninstallDryRun: "Preview Uninstall"
        case .purgeDryRun: "Preview Purge"
        case .installerDryRun: "Preview Installers"
        case .optimizeDryRun: "Preview Optimize"
        }
    }

    var description: String {
        switch self {
        case .clean: "Run the clean workflow."
        case .cleanDryRun: "Estimate safe cache, log, and leftover cleanup."
        case .uninstallDryRun: "Review app removal candidates without changing files."
        case .purgeDryRun: "Inspect project artifacts that could be reclaimed."
        case .installerDryRun: "Find disk images and installers before deletion."
        case .optimizeDryRun: "Review maintenance tasks before running them."
        }
    }

    var arguments: [String] {
        switch self {
        case .clean: ["clean"]
        case .cleanDryRun: ["clean", "--dry-run"]
        case .uninstallDryRun: ["uninstall", "--dry-run"]
        case .purgeDryRun: ["purge", "--dry-run"]
        case .installerDryRun: ["installer", "--dry-run"]
        case .optimizeDryRun: ["optimize", "--dry-run"]
        }
    }
}

struct MoleSnapshot: Codable, Equatable {
    var collectedAt: String?
    var host: String?
    var platform: String?
    var uptime: String?
    var healthScore: Int?
    var healthScoreMessage: String?
    var hardware: HardwareInfo?
    var cpu: CPUStatus?
    var memory: MemoryStatus?
    var disks: [DiskStatus]?
    var diskIO: DiskIOStatus?
    var network: [NetworkStatus]?
    var batteries: [BatteryStatus]?
    var thermal: ThermalStatus?
    var topProcesses: [MoleProcessInfo]?
    var processAlerts: [ProcessAlert]?

    enum CodingKeys: String, CodingKey {
        case collectedAt = "collected_at"
        case host
        case platform
        case uptime
        case healthScore = "health_score"
        case healthScoreMessage = "health_score_msg"
        case hardware
        case cpu
        case memory
        case disks
        case diskIO = "disk_io"
        case network
        case batteries
        case thermal
        case topProcesses = "top_processes"
        case processAlerts = "process_alerts"
    }

    var health: Int {
        healthScore ?? 88
    }

    var primaryDisk: DiskStatus? {
        disks?.first(where: { $0.mount == "/" }) ?? disks?.first
    }

    var activeAlerts: [ProcessAlert] {
        (processAlerts ?? []).filter { $0.status == "active" }
    }

    static let sample = MoleSnapshot(
        collectedAt: nil,
        host: "Local Mac",
        platform: "macOS",
        uptime: "3d 4h",
        healthScore: 88,
        healthScoreMessage: "Healthy. Refresh to load live Mole data.",
        hardware: HardwareInfo(
            model: "MacBook Pro",
            cpuModel: "Apple Silicon",
            totalRAM: "32 GB",
            diskSize: "1 TB",
            osVersion: "macOS",
            refreshRate: "120 Hz"
        ),
        cpu: CPUStatus(
            usage: 28,
            perCore: [18, 21, 35, 44, 12, 8, 17, 26],
            load1: 1.18,
            load5: 1.05,
            load15: 0.92,
            coreCount: 8
        ),
        memory: MemoryStatus(
            used: 18_300_000_000,
            total: 34_359_738_368,
            available: 16_000_000_000,
            usedPercent: 53,
            pressure: "normal"
        ),
        disks: [
            DiskStatus(
                mount: "/",
                device: "disk3s1",
                used: 512_000_000_000,
                total: 1_000_000_000_000,
                usedPercent: 51.2,
                fstype: "apfs",
                external: false
            )
        ],
        diskIO: DiskIOStatus(readRate: 4.8, writeRate: 14.2),
        network: [
            NetworkStatus(name: "en0", rxRateMBs: 1.8, txRateMBs: 0.4, ip: "192.168.1.10")
        ],
        batteries: [
            BatteryStatus(percent: 82, status: "AC", health: "Normal", cycleCount: 142, capacity: 94)
        ],
        thermal: ThermalStatus(cpuTemp: 48, fanSpeed: 1200),
        topProcesses: [
            MoleProcessInfo(name: "Xcode", command: "Xcode", cpu: 34, memory: 12, memoryBytes: 2_400_000_000),
            MoleProcessInfo(name: "Safari", command: "Safari", cpu: 18, memory: 8, memoryBytes: 1_300_000_000),
            MoleProcessInfo(name: "Terminal", command: "Terminal", cpu: 6, memory: 2, memoryBytes: 380_000_000)
        ],
        processAlerts: []
    )
}

struct HardwareInfo: Codable, Equatable {
    var model: String?
    var cpuModel: String?
    var totalRAM: String?
    var diskSize: String?
    var osVersion: String?
    var refreshRate: String?

    enum CodingKeys: String, CodingKey {
        case model
        case cpuModel = "cpu_model"
        case totalRAM = "total_ram"
        case diskSize = "disk_size"
        case osVersion = "os_version"
        case refreshRate = "refresh_rate"
    }
}

struct CPUStatus: Codable, Equatable {
    var usage: Double?
    var perCore: [Double]?
    var load1: Double?
    var load5: Double?
    var load15: Double?
    var coreCount: Int?

    enum CodingKeys: String, CodingKey {
        case usage
        case perCore = "per_core"
        case load1
        case load5
        case load15
        case coreCount = "core_count"
    }
}

struct MemoryStatus: Codable, Equatable {
    var used: UInt64?
    var total: UInt64?
    var available: UInt64?
    var usedPercent: Double?
    var pressure: String?

    enum CodingKeys: String, CodingKey {
        case used
        case total
        case available
        case usedPercent = "used_percent"
        case pressure
    }
}

struct DiskStatus: Codable, Equatable {
    var mount: String?
    var device: String?
    var used: UInt64?
    var total: UInt64?
    var usedPercent: Double?
    var fstype: String?
    var external: Bool?

    enum CodingKeys: String, CodingKey {
        case mount
        case device
        case used
        case total
        case usedPercent = "used_percent"
        case fstype
        case external
    }
}

struct DiskIOStatus: Codable, Equatable {
    var readRate: Double?
    var writeRate: Double?

    enum CodingKeys: String, CodingKey {
        case readRate = "read_rate"
        case writeRate = "write_rate"
    }
}

struct NetworkStatus: Codable, Equatable {
    var name: String?
    var rxRateMBs: Double?
    var txRateMBs: Double?
    var ip: String?

    enum CodingKeys: String, CodingKey {
        case name
        case rxRateMBs = "rx_rate_mbs"
        case txRateMBs = "tx_rate_mbs"
        case ip
    }
}

struct BatteryStatus: Codable, Equatable {
    var percent: Double?
    var status: String?
    var health: String?
    var cycleCount: Int?
    var capacity: Int?

    enum CodingKeys: String, CodingKey {
        case percent
        case status
        case health
        case cycleCount = "cycle_count"
        case capacity
    }
}

struct ThermalStatus: Codable, Equatable {
    var cpuTemp: Double?
    var fanSpeed: Int?

    enum CodingKeys: String, CodingKey {
        case cpuTemp = "cpu_temp"
        case fanSpeed = "fan_speed"
    }
}

struct MoleProcessInfo: Codable, Equatable, Identifiable {
    var id: String { "\(name ?? command ?? "process")-\(cpu ?? 0)" }
    var name: String?
    var command: String?
    var cpu: Double?
    var memory: Double?
    var memoryBytes: UInt64?

    enum CodingKeys: String, CodingKey {
        case name
        case command
        case cpu
        case memory
        case memoryBytes = "memory_bytes"
    }
}

struct ProcessAlert: Codable, Equatable, Identifiable {
    var id: String { "\(name ?? command ?? "alert")-\(status ?? "unknown")" }
    var name: String?
    var command: String?
    var cpu: Double?
    var threshold: Double?
    var window: String?
    var status: String?
}
