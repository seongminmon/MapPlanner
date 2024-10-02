//
//  Location.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import Foundation

struct Location: Hashable, Identifiable {
    var id: String
    var placeName: String
    var addressName: String
    var lat: Double
    var lng: Double
    var category: String
}

extension Location {
    static let defaultLat = 37.5642135
    static let defaultLng = 127.0016985
}
