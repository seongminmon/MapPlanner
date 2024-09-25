//
//  Location.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import Foundation

struct Location: Hashable, Identifiable {
    let id: String
    let placeName: String
    let addressName: String
    let lon: Double
    let lng: Double
}
