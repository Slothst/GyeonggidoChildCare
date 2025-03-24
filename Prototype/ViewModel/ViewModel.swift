//
//  viewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/16/25.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var startDate: Date?
    @Published var finishDate: Date?
    @Published var isStarted: Bool
    @Published var isDisplayAlert: Bool
    
    init(
        startDate: Date? = nil,
        finishDate: Date? = nil,
        isStarted: Bool = false,
        isDisplayAlert: Bool = false
    ) {
        self.startDate = startDate
        self.finishDate = finishDate
        self.isStarted = isStarted
        self.isDisplayAlert = isDisplayAlert
    }
    
    func saveDate() {
        if isStarted {
            finishDate = Date()
        } else {
            startDate = Date()
            setIsDisplayAlert(true)
        }
        isStarted.toggle()
    }
    
    func setIsDisplayAlert(_ isDisplay: Bool) {
        self.isDisplayAlert = isDisplay
    }
}
