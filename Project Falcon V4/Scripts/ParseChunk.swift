//
//  ParseChunk.swift
//  Project Falcon V4
//
//  Created by Frank Ratmiroff on 9/24/24.
//  Updated for real cycle‑day scraping on 04/22/25.
//

import UIKit
import Foundation

class ParseChunk: NSObject {
    private var _sportEvents: [Event2] = []
    private var inputString: String
    
    /**
     Initializes the parser with the raw scraped text.
     */
    init(scrapedData: String) {
        self.inputString = scrapedData
        super.init()
    }
    
    func intToMonth(intInQuestion: Int) -> String {
        let months = ["JAN","FEB","MAR","APR","MAY","JUN",
                      "JUL","AUG","SEP","OCT","NOV","DEC"]
        return months[intInQuestion - 1]
    }
    
    func monthNumber(from abbreviation: String) -> Int {
        let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        return months.firstIndex(of: abbreviation.uppercased())! + 1
    }
    
    /**
     Parses the entire scraped text to find sport events.
     */
    func parseMonth() {
        print("🧪 Starting parseMonth with input length: \(inputString.count)")
        
        let stringArray = inputString.components(separatedBy: "\n")
        // print("🧾 Raw scraped data (first 10 lines):")
        // for line in stringArray.prefix(10) {
        //     print("🔹 \(line)")
        // }
        var index = 0
        
        var currentDay = 0
        var currentMonth = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        while index < stringArray.count {
            let line = stringArray[index].trimmingCharacters(in: .whitespacesAndNewlines)

            // print("📅 Checking line for date header: \(line)")
            let dateRegex = try! NSRegularExpression(pattern: #"^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s*(\d{1,2})$"#)
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = dateRegex.firstMatch(in: line, options: [], range: range),
               let monthRange = Range(match.range(at: 1), in: line),
               let dayRange = Range(match.range(at: 2), in: line) {
                currentMonth = String(line[monthRange])
                currentDay = Int(line[dayRange]) ?? 0
                
                print("📌 Found date header: \(currentMonth) \(currentDay)")
                print("📍 Trying to attach to date: \(currentMonth) \(currentDay)")
                
                let currentDate = "\(currentMonth)\(currentDay)"
                if let date = dateFormatter.date(from: currentDate), date.timeIntervalSinceNow > 864000 {
                    index += 1
                    continue
                }
                
                index += 1
                continue
            }

            if currentDay == 0 || currentMonth.isEmpty {
                print("⚠️ Skipping event parsing due to unset date context at line: \(line)")
                index += 1
                continue
            }

            let linesEaten = trySportEvent(
                lines: stringArray,
                index: index,
                day: currentDay,
                fday: currentMonth
            )

            if linesEaten > 0 {
                index += linesEaten
                currentDay = 0
                currentMonth = ""
            } else {
                print("⏭️ Skipping line: \(line)")
                index += 1
            }
        }
        
        _sportEvents = _sportEvents.filter { !$0.sportTitle.isEmpty && !$0.opposingTeam.isEmpty }
        
        // Debug: print events found
        // if _sportEvents.isEmpty {
        //     print("⚠️ No sport events found during parseMonth.")
        // } else {
        //     print("🏈 Sport events found:")
        //     for event in _sportEvents {
        //         print(" - \(event.sportTitle) on \(event.month) \(event.date) vs \(event.opposingTeam)")
        //     }
        // }
        print("📦 Sport events count from ParseChunk: \(_sportEvents.count)")
    }
    
    /**
     Attempts to parse sport events at the given line index.
     Returns the number of lines consumed so the loop can skip them.
     */
    func trySportEvent(
        lines: [String],
        index: Int,
        day: Int,
        fday: String
    ) -> Int {
        var i = index
        var linesConsumed = 0

        guard i < lines.count else { return 0 }
        let validSports = ["Football", "Soccer", "Basketball", "Tennis", "Golf", "Track", "Lacrosse", "Softball", "Baseball", "Volleyball"]
            + ["Championship", "Quarterfinal", "Semifinals", "Finals", "Regional"] // Added extra event types
        let lookahead = 10
        var sportTitle = ""
        var foundSport = false
        var localLines: [String] = []
        // Filter out sidebar filter sport lines before lookahead block
        let filterOnlySports = [
            "Golf - Coed, MS Intermediate", "Golf - Boys, MS", "Golf - Girls, MS",
            "Volleyball - Girls, MS Intermediate", "Volleyball - Girls, MS JV", "Volleyball - Girls, MS",
            "Basketball - Boys, MS Intermediate", "Basketball - Boys, MS JV",
            "Football - Boys, Middle School", "Soccer - Boys, MS", "Soccer - Girls, MS",
            "Baseball - Boys, MS", "Cheerleading - MS", "Tennis - Boys, MS", "Tennis - Girls, MS",
            "Track and Field - Coed, MS", "Lacrosse - Boys, MS", "Lacrosse - Girls, MS",
            "Softball - Girls, MS"
        ]
        let line = lines[i].trimmingCharacters(in: .whitespacesAndNewlines)
        print("🔍 Evaluating line for filtering: \(line)")
        if filterOnlySports.contains(where: { line.contains($0) }) {
            print("🚫 Skipping sidebar filter sport line: \(line)")
            return 0
        }
        else {
            print("✅ Line passed sidebar filter check")
        }
        // Before collecting localLines, check if a non-sport event appears within the lookahead.
        let unrelatedPatterns = [
            "AP EXAMS", "IB EXAMS", "FACULTY AND STAFF APPRECIATION WEEK",
            "Adrianna Truby", "Denise Gallardo", "BOOK CLUB", "LATE START",
            "BACCALAUREATE", "ORGAN CONCERT", "CYCLE DAY", "PTPA",
            "CAMPUS TOUR", "CLASS TRAVEL", "REUNION PARTY", "CHAPEL",
            "SENIOR ASSESSMENTS",
            "Andrew Cooper", "Amy Duarte", "Isabella Martino", "ATHLETIC SCHEDULES",
            #"^to \d{1,2}/\d{1,2}/\d{4}$"#
        ]
        for offset in 0..<lookahead {
            guard i + offset < lines.count else { break }
            let tempLine = lines[i + offset].trimmingCharacters(in: .whitespacesAndNewlines)
            // Stop if a known unrelated event is encountered
            let matchedUnrelated = unrelatedPatterns.contains { pattern in
                tempLine.range(of: pattern, options: .regularExpression) != nil
            }
            if matchedUnrelated { break }

            localLines.append(tempLine)
            if validSports.contains(where: { tempLine.localizedCaseInsensitiveContains($0) })
                || tempLine.uppercased().contains("CHAMPIONSHIP")
                || tempLine.uppercased().contains("QUARTERFINAL")
                || tempLine.uppercased().contains("SEMIFINAL")
                || tempLine.uppercased().contains("FINAL")
                || tempLine.uppercased().contains("REGIONAL")
            {
                // Avoid parsing person names or unrelated events as opponents
                let namePattern = #"^\b[A-Z][a-z]+ [A-Z][a-z]+\b$"#
                if tempLine.range(of: namePattern, options: .regularExpression) != nil {
                    continue
                }
                let unrelatedEvents = ["ALUMNI REUNION PARTY"]
                if unrelatedEvents.contains(where: { tempLine.localizedCaseInsensitiveContains($0) }) {
                    continue
                }
                // Skip all events on MAY 30 (end-of-year policy)
                if fday == "MAY" && day == 30 {
                    print("🚫 Skipping all events on MAY 30 — end-of-year no-event policy.")
                    return 0
                }
                if fday == "MAY" && day == 30 && sportTitle.contains("Golf") {
                    print("🚫 Skipping Golf on MAY 30 — false positive due to end-of-month filter listing.")
                    return 0
                }
                print("🔍 Found valid sport line: \(tempLine)")
                sportTitle = tempLine
                foundSport = true
            }
        }

        // Fallback logic for non-sport events removed as per instructions

        if day == 0 || fday.isEmpty {
            print("❌ Invalid date context for event parsing — day: \(day), month: \(fday)")
            return 0
        }
        print("📍 Trying to attach to date: \(fday) \(day)")
        if foundSport {
            // Guard against sportTitle being a date string or a known multi-day tag
            let datePattern = #"to \d{1,2}/\d{1,2}/\d{4}"#
            if let _ = sportTitle.range(of: datePattern, options: .regularExpression) {
                print("🚫 Skipping event with sport title that is actually a date: \(sportTitle)")
                return lookahead
            }
            let invalidTitles = ["AP EXAMS AND SENIOR ASSESSMENTS", "FACULTY AND STAFF APPRECIATION WEEK", "IB EXAMS"]
            if invalidTitles.contains(where: { sportTitle.uppercased().contains($0.uppercased()) }) {
                print("🚫 Skipping known non-event title: \(sportTitle)")
                return lookahead
            }
            if sportTitle.localizedCaseInsensitiveContains("cheerleading") {
                print("🚫 Skipping cheerleading event: \(sportTitle)")
                return lookahead
            }
            var time = "TBD"
            for line in localLines {
                if line.range(of: #"^\d{1,2}:\d{2}"#, options: .regularExpression) != nil {
                    time = line
                    break
                }
            }
            var homeOrAway = "TBD"
            for line in localLines {
                if line.lowercased().contains("home") || line.lowercased().contains("away") {
                    homeOrAway = line
                    break
                }
            }
            var location = "TBD"
            for line in localLines {
                if line.lowercased().contains("location:") || line.lowercased().contains("university") || line.lowercased().contains("academy") {
                    location = line.replacingOccurrences(of: "Location: ", with: "").trimmingCharacters(in: .whitespaces)
                    break
                }
            }
            if location.hasPrefix("Playing Fields - ") {
                location = location.replacingOccurrences(of: "Playing Fields - ", with: "")
            }
            var opposingTeam = ""
            for line in localLines {
                let lower = line.lowercased()
                if lower.contains(" vs ") || lower.contains(" vs.") || lower.contains(" versus ") {
                    let delimiters = [" vs ", " vs.", " versus "]
                    for delimiter in delimiters {
                        if line.contains(delimiter) {
                            let parts = line.components(separatedBy: delimiter)
                            if parts.count == 2 {
                                let candidateOpponent = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                                if candidateOpponent.range(of: #"to \d{1,2}/\d{1,2}/\d{4}"#, options: .regularExpression) != nil || candidateOpponent.uppercased().contains("EXAMS") {
                                    continue
                                }
                                sportTitle = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                opposingTeam = candidateOpponent
                                break
                            }
                        }
                    }
                    if !opposingTeam.isEmpty { break }
                }
            }
            
            if opposingTeam.isEmpty {
                opposingTeam = "TBD"
            }
            
            if let last = _sportEvents.last, last.sportTitle == sportTitle, last.date == day {
                return lookahead
            }

            if opposingTeam.isEmpty || opposingTeam == sportTitle {
                print("🚫 Skipping invalid event due to missing opponent: \(sportTitle)")
                return lookahead
            }

            print("🏈 Found sport event: \(sportTitle), vs \(opposingTeam), at \(location)")

            let event = Event2(
                sportTitle:    sportTitle,
                time:          time,
                date:          day,
                month:         fday,
                homeOrAway:    homeOrAway,
                location:      location,
                opposingTeam:  opposingTeam,
                information:   ""
            )
            _sportEvents.append(event)
            print("✅ Appended event: \(sportTitle) on \(fday) \(day)")
            return min(localLines.count, lookahead)
        }
        // Only real sports events (foundSport == true) are parsed and added.

        return linesConsumed
    }
    
    func getEvent2()  -> [Event2]   { return _sportEvents }
    func printInput()            { print(inputString) }
    
}

// Safe array index helper for lookahead
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

    // Helper method to filter out known bad lines
    func isBadLine(_ line: String) -> Bool {
        let patterns = [
            "^to \\d{1,2}/\\d{1,2}/\\d{4}$",
            "FACULTY AND STAFF APPRECIATION WEEK",
            "IB EXAMS",
            "AP EXAMS",
            "Adrianna Truby",
            "Denise Gallardo",
            "ATHLETIC SCHEDULES",
            "Amy Duarte",
            "Andrew Cooper",
            "Isabella Martino"
        ]
        return patterns.contains { pattern in
            line.range(of: pattern, options: .regularExpression) != nil
        }
    }
