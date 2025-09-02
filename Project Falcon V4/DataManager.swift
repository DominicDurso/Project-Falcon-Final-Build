//
//  DataManager.swift
//  Project Falcon V4
//
//  Created by Dominic Durso on 12/11/24.
//

class DataManager {
    static let shared = DataManager()

    var globalData: String = ""
    var cycleDay: Int = 0

    private init() { }
}
