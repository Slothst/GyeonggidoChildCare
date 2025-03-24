//
//  ActivityLogViewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/24/25.
//

import Foundation

class ActivityLogViewModel: ObservableObject {
    @Published var activityLog: ActivityLog
    
    init(activityLog: ActivityLog) {
        self.activityLog = activityLog
    }
}
