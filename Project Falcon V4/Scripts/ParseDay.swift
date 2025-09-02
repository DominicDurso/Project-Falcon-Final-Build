//
//  ParseDay.swift
//  Project Falcon V4
//
//  Created by Frank Ratmiroff on 9/24/24.
//
import UIKit



class ParseDay: NSObject {

    private var _day : Int

    private var _month, _chunk : String

    

    init(day: Int, month: String, chunk: String) {

        _day = day

        _month = month

        _chunk = chunk

    }

    

    func getDay() -> Int {

        return _day

    }

    

    func getMonth() -> String {

        return _month

    }

    

    func getCycleDay() -> Int {
        if let range = _chunk.range(of: "CYCLE DAY") {
            // Try to get the index 2 characters after "CYCLE DAY"
            if let endIndex = _chunk.index(range.upperBound, offsetBy: 2, limitedBy: _chunk.endIndex) {
                let extendedRange = range.lowerBound..<endIndex
                let substring = _chunk[extendedRange]
                print(substring)
                
                // Separate the substring by spaces and try to get the last component (which should be the number)
                let components = substring.components(separatedBy: " ")
                if let dayString = components.last, let cycleDay = Int(dayString) {
                    print(cycleDay)
                    return cycleDay
                }
            }
        }
        return 0 // Return 0 if something goes wrong
    }
    
    func getChunk() -> String {
        return _chunk
    }

}
