//
//  Diary.swift
//  MapPlanner
//
//  Created by 김성민 on 9/27/24.
//

import Foundation

// MARK: - RealmModel / PresentModel 분리
struct Diary: Hashable, Identifiable {
    var id: String
    var savedDate: Date
    var title: String
    var date: Date
    var isTimeIncluded: Bool
    var contents: String
    
    var locationID: String
    var placeName: String
    var addressName: String
    var lat: Double?
    var lng: Double?
    var category: String
}

extension Diary {
    func toLocation() -> Location? {
        guard let lat = self.lat, let lng = self.lng else { return nil }
        return Location(
            id: self.locationID,
            placeName: self.placeName,
            addressName: self.addressName,
            lat: lat,
            lng: lng,
            category: self.category
        )
    }
}
