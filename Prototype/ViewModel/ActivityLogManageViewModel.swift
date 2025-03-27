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
    @Published var selectedDateContent: String
    @Published var shouldDismissKeyboard: Bool
    
    init(
        selectedDate: Date = Date(),
        activityLogs: [ActivityLog] = [],
        isCalendarDisplay: Bool = false,
        selectedDateContent: String = "",
        shouldDismissKeyboard: Bool = false
    ) {
        self.selectedDate = selectedDate
        self.activityLogs = activityLogs
        self.isCalendarDisplay = isCalendarDisplay
        self.selectedDateContent = selectedDateContent
        self.shouldDismissKeyboard = shouldDismissKeyboard
    }
    
    func setIsCalendarDisplay(_ isDisplay: Bool) {
        isCalendarDisplay = isDisplay
    }
    
    func addActivityLog(_ activityLog: ActivityLog) {
        var activityLogWithDate = activityLog
        activityLogWithDate.content = selectedDateContent
        activityLogWithDate.date = selectedDate.formattedDateString
        self.activityLogs.append(activityLogWithDate)
    }
    
    func updateActivityLog(_ activityLog: ActivityLog) {
        if let index = activityLogs.firstIndex(where: { $0.date == selectedDate.formattedDateString }) {
            var al = activityLogs[index]
            al.content = selectedDateContent
            self.activityLogs[index] = al
        }
    }
    
    func getActivityLog() {
        if let activityLog = activityLogs.first(where: { $0.date == selectedDate.formattedDateString })?.content {
            selectedDateContent = activityLog
        } else {
            selectedDateContent = ""
        }
    }
}
