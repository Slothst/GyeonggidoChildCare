//
//  Date+Extension.swift
//  Prototype
//
//  Created by 최낙주 on 3/16/25.
//

import Foundation

extension Date {
    var formattedDateAndTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd(E) HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
    
    var formattedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
