//
//  RealmDiary.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import RealmSwift

final class RealmDiary: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var savedDate: Date
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var isTimeIncluded: Bool
    @Persisted var contents: String
    @Persisted var rating: Double?
    
    // 장소 정보
    @Persisted var locationID: String
    @Persisted var placeName: String
    @Persisted var addressName: String
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    @Persisted var category: String
    
    convenience init(title: String, date: Date, isTimeIncluded: Bool, contents: String, rating: Double?, locationID: String, placeName: String, addressName: String, lat: Double? = nil, lng: Double? = nil, category: String) {
        self.init()
        self.savedDate = Date()
        self.title = title
        self.date = date
        self.isTimeIncluded = isTimeIncluded
        self.contents = contents
        self.rating = rating
        self.locationID = locationID
        self.placeName = placeName
        self.addressName = addressName
        self.lat = lat
        self.lng = lng
        self.category = category
    }
}

extension RealmDiary {    
    func toDiary() -> Diary {
        return Diary(
            id: self.id.stringValue,
            savedDate: self.savedDate,
            title: self.title,
            date: self.date,
            isTimeIncluded: self.isTimeIncluded,
            contents: self.contents,
            rating: self.rating,
            locationID: self.locationID,
            placeName: self.placeName,
            addressName: self.addressName,
            lat: self.lat,
            lng: self.lng, 
            category: self.category
        )
    }
}
