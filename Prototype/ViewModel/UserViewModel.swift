//
//  UserViewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/28/25.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
}
