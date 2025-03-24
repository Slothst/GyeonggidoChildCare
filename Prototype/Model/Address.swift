//
//  Address.swift
//  Prototype
//
//  Created by 최낙주 on 3/18/25.
//

import Foundation

struct Address: Hashable {
    var latitude: Double
    var longitude: Double
    var administrativeArea: String
    var locality: String
    var subLocality: String
    var thoroughfare: String
    var subThoroughfare: String
    
    var roadAddress: String {
        return "\(administrativeArea) \(locality) \(subLocality) \(thoroughfare) \(subThoroughfare)"
    }
}
