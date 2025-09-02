//
//  TimeFrame.swift
//  Project Falcon V4
//
//  Created by Dominic Durso on 10/2/24.
//

import Foundation

public enum TimeFrame {
    
    case MON(type: String, times: [Int])
    case TUES(type: String, times: [Int])
    case WED(type: String, times: [Int])
    case THURS(type: String, times: [Int])
    case FRI(type: String, times: [Int])
    
    // Determines if the current day is a weekday
    public static func isWeekday() -> Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return weekday >= 2 && weekday <= 6
    }

    // Determines the next school day based on current day and time
    public static func getNextSchoolDay() -> TimeFrame? {
        let weekday = Calendar.current.component(.weekday, from: Date())
        
        switch weekday {
        case 2: 
            // Tuesday
            return .TUES(type: "Normal Schedule", times: [815, 925, 1035, 1145, 1255])
        case 3: 
            // Wednesday
            return .WED(type: "Late Start Schedule", times: [930, 1035, 1140, 1245, 1350])
        case 4: 
            // Thursday
            return .THURS(type: "Dress Uniform Schedule", times: [800, 900, 1000, 1100, 1200])
        case 5: 
            // Friday
            return .FRI(type: "Normal Schedule", times: [815, 925, 1035, 1145, 1255])
        case 6: 
            // Monday
            return .MON(type: "Normal Schedule", times: [815, 925, 1035, 1145, 1255])
        default: 
            return nil
        }
    }

    // Fetches the day type
    public func getDayType() -> String {
        switch self {
        case .MON: return "Normal Schedule"
        case .TUES: return "Normal Schedule"
        case .WED: return "Late Start Schedule"
        case .THURS: return "Dress Uniform Schedule"
        case .FRI: return "Normal Schedule"
        }
    }
}

// Formats a time given as an Int (e.g., 815) to a "h:mm a" string
public func formatTime(_ time: Int) -> String {
    let hour = time / 100
    let minute = time % 100
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    
    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minute
    
    let calendar = Calendar.current
    if let date = calendar.date(from: dateComponents) {
        return formatter.string(from: date)
    }
    return ""
}
