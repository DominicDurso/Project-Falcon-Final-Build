//
//  Event2.swift
//  Project Falcon V4
//
//  Created by Daniel Da Silva Mullane on 11/14/24.
//


import Foundation

class Event2 {

    var sportTitle: String

    var time: String
    
    var date: Int
    
    var month: String

    var homeOrAway: String

    var location: String

    var opposingTeam: String
    
    var information: String

    

    init(sportTitle: String, time: String, date: Int, month: String, homeOrAway: String, location: String, opposingTeam: String, information: String) {

        self.sportTitle = sportTitle

        self.time = time
        
        self.date = date
        
        self.month = month

        self.homeOrAway = homeOrAway

        self.location = location

        self.opposingTeam = opposingTeam
        
        self.information = information

    }

    func getDayNum() -> Int {
        return self.date
    }

    func getName() -> String {
        return self.sportTitle
    }

}
