//
//  ActivityLogViewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/23/25.
//

import Foundation

class ActivityLogManageViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var activityLogs: [ActivityLog]
    @Published var isCalendarDisplay: Bool
    
    init(
        selectedDate: Date = Date(),
        activityLogs: [ActivityLog] = [],
        isCalendarDisplay: Bool = false
    ) {
        self.selectedDate = selectedDate
        self.activityLogs = activityLogs
        self.isCalendarDisplay = isCalendarDisplay
    }
    
    func setIsCalendarDisplay(_ isDisplay: Bool) {
        isCalendarDisplay = isDisplay
    }
    
    func addActivityLog(_ activityLog: ActivityLog) {
        self.activityLogs.append(activityLog)
    }
    
    func updateActivityLog(_ activityLog: ActivityLog) {
        if let index = activityLogs.firstIndex(of: activityLog) {
            self.activityLogs[index] = activityLog
        }
    }
    
    func getActivityLog(at date: Date) -> ActivityLog? {
        return activityLogs.first(where: { $0.date == date }) ?? nil
    }
}
