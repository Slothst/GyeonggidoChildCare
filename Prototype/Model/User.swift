//
//  User.swift
//  Prototype
//
//  Created by 최낙주 on 3/28/25.
//

import Foundation

struct User: Hashable {
    var userId: String
    var location: Address?
    var progressedTime: Int?
}
