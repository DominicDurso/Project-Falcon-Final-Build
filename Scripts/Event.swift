//
//  Event.swift
//  Project Falcon V4
//
//  Created by Daniel Da Silva Mullane on 10/16/24.
//


class Event {
    
    private var _name : String
    
    private var _dayNum : Int
    
        
    init(name: String, dayNum : Int) {
        _name = name
        _dayNum = dayNum
    }
    
    func getName() -> String {
        return _name
    }
    
    func getDayNum() -> Int {
        return _dayNum
    }


}

