//
//  AddressResponse.swift
//  MapPlanner
//
//  Created by 김성민 on 10/27/24.
//

import Foundation

struct AddressResponse: Decodable {
    let meta: Meta // 0 또는 1
    let documents: [Document]
    
    struct Meta: Decodable {
        let total_count: Int
    }
    
    struct Document: Decodable {
        let address: Address
        let road_address: RoadAddress?
    }
    
    struct Address: Decodable {
        let address_name: String
        let region_1depth_name: String
        let region_2depth_name: String
        let region_3depth_name: String
        let mountain_yn: String
        let main_address_no: String
        let sub_address_no: String
    }
    
    struct RoadAddress: Decodable {
        let address_name: String
        let region_1depth_name: String
        let region_2depth_name: String
        let region_3depth_name: String
        let road_name: String
        let underground_yn: String
        let main_building_no: String
        let sub_building_no: String
        let building_name: String
        let zone_no: String
    }
}
