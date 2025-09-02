//
//  ScheduleWidgetBundle.swift
//  ScheduleWidget
//
//  Created by Dominic Durso on 5/6/25.
//

import WidgetKit
import SwiftUI

@main
struct ScheduleWidgetBundle: WidgetBundle {
    var body: some Widget {
        ScheduleWidget()
        ScheduleWidgetControl()
        ScheduleWidgetLiveActivity()
    }
}
