import SwiftUI
import WidgetKit

struct MoleStatusEntry: TimelineEntry {
    let date: Date
    let healthScore: Int
    let cpuUsage: Double
    let memoryUsage: Double
    let diskUsage: Double
}

struct MoleStatusProvider: TimelineProvider {
    func placeholder(in context: Context) -> MoleStatusEntry {
        MoleStatusEntry(date: Date(), healthScore: 88, cpuUsage: 28, memoryUsage: 53, diskUsage: 51)
    }

    func getSnapshot(in context: Context, completion: @escaping (MoleStatusEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MoleStatusEntry>) -> Void) {
        let entry = placeholder(in: context)
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

struct MoleStatusWidgetView: View {
    let entry: MoleStatusEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Mole")
                    .font(.headline)
                Spacer()
                Text("\(entry.healthScore)")
                    .font(.title2.weight(.semibold))
            }

            Gauge(value: Double(entry.healthScore), in: 0...100) {
                Text("Health")
            }

            HStack {
                Label("\(Int(entry.cpuUsage))%", systemImage: "cpu")
                Spacer()
                Label("\(Int(entry.diskUsage))%", systemImage: "internaldrive")
            }
            .font(.caption)
        }
        .containerBackground(.thinMaterial, for: .widget)
    }
}

struct MoleStatusWidget: Widget {
    let kind = "MoleStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MoleStatusProvider()) { entry in
            MoleStatusWidgetView(entry: entry)
        }
        .configurationDisplayName("Mole Status")
        .description("Shows system health from Mole.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
