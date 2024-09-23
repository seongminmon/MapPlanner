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
    @Persisted var contents: String?
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    @Persisted var photo: Bool
    
    convenience init(title: String, date: Date, lat: Double? = nil, lng: Double? = nil, contents: String? = nil, photo: Bool) {
        self.init()
        self.savedDate = Date()
        self.title = title
        self.date = date
        self.contents = contents
        self.lat = lat
        self.lng = lng
        self.photo = photo
    }
}
