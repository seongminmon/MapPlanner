//
//  LocalResponse.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import Foundation

struct LocalResponse: Decodable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Decodable {
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
    let same_name: SameName
}

struct SameName: Decodable {
    let region: [String]
    let keyword: String
    let selected_region: String
}

struct Document: Decodable {
    let id: String
    let place_name: String
    let category_name: String
    let category_group_code: String
    let category_group_name: String
    let phone: String
    let address_name: String
    let road_address_name: String
    let x: String
    let y: String
    let place_url: String
    let distance: String?
}

extension Document {
    func toLocation() -> Location {
        return Location(
            id: self.id,
            placeName: self.place_name,
            addressName: self.address_name,
            lat: Double(self.y) ?? 0,
            lng: Double(self.x) ?? 0,
            category: self.category_name
        )
    }
}
