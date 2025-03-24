//
//  ActivityLog.swift
//  Prototype
//
//  Created by 최낙주 on 3/24/25.
//

import Foundation

struct ActivityLog: Hashable {
    var id: UUID
    var content: String
    var date: Date?
    var place: Address?
    var time: Time?
}
