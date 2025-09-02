//
//  StaticSchedule.swift
//  Project Falcon V4
//
//  Created by Dominic Durso on 5/2/25.
//

import Foundation

public struct StaticSchedule {
    static let calendar = Calendar.current

    // Format: [YYYY, MM, DD]
    static let noSchoolDays: Set<Date> = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return Set([
            "2025-08-16", "2025-08-17", "2025-08-23", "2025-08-24", "2025-08-30",
            "2025-08-31", "2025-09-01", "2025-09-06", "2025-09-07", "2025-09-13",
            "2025-09-14", "2025-09-20", "2025-09-21", "2025-09-27", "2025-09-28",
            "2025-10-04", "2025-10-05", "2025-10-11", "2025-10-12", "2025-10-18",
            "2025-10-19", "2025-10-25", "2025-10-26", "2025-11-01", "2025-11-02",
            "2025-11-08", "2025-11-09", "2025-11-15", "2025-11-16", "2025-11-22",
            "2025-11-23", "2025-11-27", "2025-11-28", "2025-11-29", "2025-11-30",
            "2025-12-06", "2025-12-07", "2025-12-13", "2025-12-14", "2025-12-20",
            "2025-12-21", "2025-12-22", "2025-12-23", "2025-12-24", "2025-12-25",
            "2025-12-26", "2025-12-27", "2025-12-28", "2025-12-29", "2025-12-30",
            "2025-12-31", "2026-01-01", "2026-01-02", "2026-01-03", "2026-01-04",
            "2026-01-10", "2026-01-11", "2026-01-17", "2026-01-18", "2026-01-19",
            "2026-01-24", "2026-01-25", "2026-01-31", "2026-02-01", "2026-02-07",
            "2026-02-08", "2026-02-14", "2026-02-15", "2026-02-16", "2026-02-21",
            "2026-02-22", "2026-02-28", "2026-03-01", "2026-03-07", "2026-03-08",
            "2026-03-14", "2026-03-15", "2026-03-21", "2026-03-22", "2026-03-28",
            "2026-03-29", "2026-04-03", "2026-04-04", "2026-04-05", "2026-04-06",
            "2026-04-07", "2026-04-11", "2026-04-12", "2026-04-18", "2026-04-19",
            "2026-04-25", "2026-04-26", "2026-05-02", "2026-05-03", "2026-05-09",
            "2026-05-10", "2026-05-16", "2026-05-17", "2026-05-23", "2026-05-24",
            "2026-05-25", "2026-05-30", "2026-05-31", "2026-06-06", "2026-06-07",
            "2026-06-08", "2026-06-09", "2026-06-10"
        ].compactMap { formatter.date(from: $0) })
    }()

    static let cycleDayMap: [String: Int] = [
        "2025-08-13": 1,
        "2025-08-14": 2,
        "2025-08-15": 3,
        "2025-08-18": 4,
        "2025-08-19": 5,
        "2025-08-20": 6,
        "2025-08-21": 7,
        "2025-08-22": 1,
        "2025-08-25": 2,
        "2025-08-26": 3,
        "2025-08-27": 4,
        "2025-09-02": 5,
        "2025-09-03": 6,
        "2025-09-04": 7,
        "2025-09-05": 1,
        "2025-09-08": 2,
        "2025-09-09": 3,
        "2025-09-10": 4,
        "2025-09-11": 5,
        "2025-09-12": 6,
        "2025-09-15": 7,
        "2025-09-16": 1,
        "2025-09-17": 2,
        "2025-09-18": 3,
        "2025-09-19": 4,
        "2025-09-22": 5,
        "2025-09-23": 6,
        "2025-09-24": 7,
        "2025-09-25": 1,
        "2025-09-26": 2,
        "2025-09-29": 3,
        "2025-09-30": 4,
        "2025-10-01": 5,
        "2025-10-02": 6,
        "2025-10-03": 7,
        "2025-10-06": 1,
        "2025-10-07": 2,
        "2025-10-08": 3,
        "2025-10-09": 4,
        "2025-10-10": 5,
        "2025-10-13": 6,
        "2025-10-14": 7,
        "2025-10-15": 1,
        "2025-10-16": 2,
        "2025-10-17": 3,
        "2025-10-20": 4,
        "2025-10-21": 5,
        "2025-10-22": 6,
        "2025-10-23": 7,
        "2025-10-24": 1,
        "2025-10-27": 2,
        "2025-10-28": 3,
        "2025-10-29": 4,
        "2025-10-30": 5,
        "2025-10-31": 6
    ]

    
    static func cycleDay(for date: Date) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let key = formatter.string(from: date)
        return cycleDayMap[key]
    }

    static func isNoSchoolDay(_ date: Date) -> Bool {
        return noSchoolDays.contains(where: {
            calendar.isDate($0, inSameDayAs: date)
        })
    }
}

extension StaticSchedule {
    static func scheduleType(for date: Date) -> ScheduleType? {
        // Basic defaulting logic; adjust as needed based on real conditions
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 4 { // Wednesday
            return .lateStart
        } else if weekday == 5 { // Thursday
            return .chapel
        } else {
            return .normal
        }
    }

    static func schedule(for type: ScheduleType) -> [Period]? {
        return staticSchedules[type]
    }
    
    static func advisoryAndFlexInfo(for type: ScheduleType) -> (hasAdvisory: Bool, hasFlex: Bool) {
        switch type {
        case .normal:
            return (true, true)
        case .lateStart:
            return (false, false)
        case .chapel:
            return (false, true)
        case .halfDay:
            return (true, false)
        case .hourLongSpecial:
            return (true, false)
        }
    }
    
    public static func widgetTextForTomorrow() -> String {
        // Get the next school day as an Optional
        let nextSchoolDay = TimeFrame.getNextSchoolDay()
        
        // If it fails to fetch, return default message
        guard let schoolDay = nextSchoolDay else {
            return "No schedule tomorrow"
        }
        
        // Get the next calendar date (tomorrow)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nextSchoolDayDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

        // Check if it's a no school day
        if isNoSchoolDay(nextSchoolDayDate) {
            return "No schedule tomorrow"
        }
        
        // Get the cycle day for the next school day
        if let cycleDay = cycleDay(for: nextSchoolDayDate) {
            let cycle = CycleDays.match(day: cycleDay)
            let periods = cycle.getPeriods().joined()
            let scheduleType = schoolDay.getDayType()
            
            return """
            Periods for tomorrow:
            \(periods)
            \(scheduleType)
            """
        } else {
            return "No schedule tomorrow"
        }
    }
}


enum ScheduleType {
    case normal
    case lateStart
    case chapel
    case halfDay
    case hourLongSpecial
}


extension ScheduleType {
    var name: String {
        switch self {
        case .normal: return "Normal"
        case .lateStart: return "Late Start"
        case .chapel: return "Chapel"
        case .halfDay: return "Half Day"
        case .hourLongSpecial: return "Hour-Long Special"
        }
    }
}

struct Period {
    let name: String
    let startTime: String
    let endTime: String
}

let staticSchedules: [ScheduleType: [Period]] = [
    .normal: [
        Period(name: "1", startTime: "8:15 am", endTime: "9:15 am"),
        Period(name: "2", startTime: "9:25 am", endTime: "10:25 am"),
        Period(name: "3", startTime: "11:10 am", endTime: "12:55 pm"),
        Period(name: "4", startTime: "1:05 pm", endTime: "2:05 pm"),
        Period(name: "5", startTime: "2:15 pm", endTime: "3:15 pm"),
    ],
    .lateStart: [
        Period(name: "1", startTime: "9:00 am", endTime: "10:00 am"),
        Period(name: "2", startTime: "10:05 am", endTime: "11:05 am"),
        Period(name: "3", startTime: "11:10 am", endTime: "12:55 pm"),
        Period(name: "4", startTime: "1:05 pm", endTime: "2:05 pm"),
        Period(name: "5", startTime: "2:15 pm", endTime: "3:15 pm"),
    ],
    .chapel: [
        Period(name: "1", startTime: "8:00 am", endTime: "8:55 am"),
        Period(name: "2", startTime: "9:05 am", endTime: "10:00 am"),
        Period(name: "3", startTime: "11:25 am", endTime: "1:05 pm"),
        Period(name: "4", startTime: "1:15 pm", endTime: "2:10 pm"),
        Period(name: "5", startTime: "2:20 pm", endTime: "3:15 pm"),
    ],
    .halfDay: [
        Period(name: "1", startTime: "8:15 am", endTime: "8:55 am"),
        Period(name: "2", startTime: "9:00 am", endTime: "9:40 am"),
        Period(name: "3", startTime: "9:50 am", endTime: "10:30 am"),
        Period(name: "4", startTime: "10:35 am", endTime: "11:15 am"),
        Period(name: "5", startTime: "11:20 am", endTime: "12:00 pm"),
    ],
    .hourLongSpecial: [
        Period(name: "1", startTime: "8:15 am", endTime: "9:10 am"),
        Period(name: "2", startTime: "9:20 am", endTime: "10:15 am"),
        Period(name: "3", startTime: "1:15 pm", endTime: "2:10 pm"),
        Period(name: "4", startTime: "2:20 pm", endTime: "3:15 pm"),
    ]
]


// MARK: - Lock Screen Widget String
public extension StaticSchedule {
    /// Returns a string suitable for Lock Screen widgets, like:
    /// "ABCDE"
    public static func widgetTextForToday() -> String {
        let today = Date()
        guard let cycleDay = cycleDay(for: today) else {
            return "No schedule today"
        }
        let cycle = CycleDays.match(day: cycleDay)
        return cycle.getPeriods().joined()
    }
}
