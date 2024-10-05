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
    let same_name: SameName?
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
            category: self.category_group_name
        )
    }
}

enum CategoryName: String, CaseIterable {
    case MT1 = "대형마트"
    case CS2 = "편의점"
    case PS3 = "어린이집, 유치원"
    case SC4 = "학교"
    case AC5 = "학원"
    case PK6 = "주차장"
    case OL7 = "주유소, 충전소"
    case SW8 = "지하철역"
    case BK9 = "은행"
    case CT1 = "문화시설"
    case AG2 = "중개업소"
    case PO3 = "공공기관"
    case AT4 = "관광명소"
    case AD5 = "숙박"
    case FD6 = "음식점"
    case CE7 = "카페"
    case HP8 = "병원"
    case PM9 = "약국"
}
