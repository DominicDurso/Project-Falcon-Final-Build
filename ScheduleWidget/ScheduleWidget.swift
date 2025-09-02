//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by Dominic Durso on 5/6/25.
//

import WidgetKit
import SwiftUI
import SharedScheduleLogic

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), scheduleText: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let today = Date()
        let scheduleString = Self.getScheduleString(for: today)
        let entry = SimpleEntry(date: today, scheduleText: scheduleString)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let scheduleString = Self.getScheduleString(for: currentDate)
        let entry = SimpleEntry(date: currentDate, scheduleText: scheduleString)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private static func getScheduleString(for date: Date) -> String {
        return StaticSchedule.widgetTextForToday()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let scheduleText: String
}

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text("Today's Periods:")
                    .font(.body)
                    .bold()
                Text(entry.scheduleText)
                    .font(.caption2)
                    .lineLimit(5)
            }
        default:
            Text("Unsupported")
        }
    }
}

struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ScheduleWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ScheduleWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Schedule Widget")
        .description("Shows today's class schedule.")
        .supportedFamilies([.accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, scheduleText: "A: 8:15–9:15\nB: 9:25–10:25")
}
