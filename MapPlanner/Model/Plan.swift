//
//  Plan.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import RealmSwift

final class Plan: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var savedDate: Date
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var isTimeIncluded: Bool
    @Persisted var contents: String
    
    // 장소 정보
    @Persisted var locationID: String
    @Persisted var placeName: String
    @Persisted var addressName: String
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    
    convenience init(title: String, date: Date, isTimeIncluded: Bool, contents: String, locationID: String, placeName: String, addressName: String, lat: Double? = nil, lng: Double? = nil) {
        self.init()
        self.savedDate = Date()
        self.title = title
        self.date = date
        self.isTimeIncluded = isTimeIncluded
        self.contents = contents
        self.locationID = locationID
        self.placeName = placeName
        self.addressName = addressName
        self.lat = lat
        self.lng = lng
    }
}
