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
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    @Persisted var contents: String?
    @Persisted var photo: String?
    
    convenience init(title: String, date: Date, lat: Double? = nil, lng: Double? = nil, contents: String? = nil, photo: String? = nil) {
        self.init()
        self.title = title
        self.date = date
        self.lat = lat
        self.lng = lng
        self.contents = contents
        self.photo = photo
    }
}
