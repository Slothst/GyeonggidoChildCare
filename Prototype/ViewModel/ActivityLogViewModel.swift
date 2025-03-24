//
//  ActivityLogViewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/23/25.
//

import Foundation

class ActivityLogViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var content: String
    @Published var isCalendarDisplay: Bool
    
    init(
        selectedDate: Date = Date(),
        content: String = "",
        isCalendarDisplay: Bool = false
    ) {
        self.selectedDate = selectedDate
        self.content = content
        self.isCalendarDisplay = isCalendarDisplay
    }
    
    func setIsCalendarDisplay(_ isDisplay: Bool) {
        isCalendarDisplay = isDisplay
    }
}
