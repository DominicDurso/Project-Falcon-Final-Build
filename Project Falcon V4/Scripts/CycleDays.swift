//
//  CycleDays.swift
//  Project Falcon V4
//
//  Created by Frank Ratmiroff on 10/8/24.
//

enum CycleDays{
    
    case CD1(day: Int)
    case CD2(day: Int)
    case CD3(day: Int)
    case CD4(day: Int)
    case CD5(day: Int)
    case CD6(day: Int)
    case CD7(day: Int)
    case NOCD
    
    static func match(day: Int) -> CycleDays {
        switch day {
        case 1: return .CD1(day: 1)
        case 2: return .CD2(day: 2)
        case 3: return .CD3(day: 3)
        case 4: return .CD4(day: 4)
        case 5: return .CD5(day: 5)
        case 6: return .CD6(day: 6)
        case 7: return .CD7(day: 7)
        default: return .NOCD
        }
    }
    func getCycleDay() -> Int{
        switch self {
        case .CD1: return 1
        case .CD2: return 2
        case .CD3: return 3
        case .CD4: return 4
        case .CD5: return 5
        case .CD6: return 6
        case .CD7: return 7
        case .NOCD: return 0
        }
    }
    
    func getPeriods() -> [String] {
        switch self {
        case .CD1: return ["A", "B", "C", "D", "E"]
        case .CD2: return ["F", "G", "A", "B", "C"]
        case .CD3: return ["D", "E", "F", "G", "A"]
        case .CD4: return ["B", "C", "D", "E", "F"]
        case .CD5: return ["G", "A", "B", "C", "D"]
        case .CD6: return ["E", "F", "G", "A", "B"]
        case .CD7: return ["C", "D", "E", "F", "G"]
        case .NOCD: return []
        }
    }
}
