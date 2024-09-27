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
}

extension Location {
    static let defaultLat = 37.532600
    static let defaultLng = 127.024612
}
