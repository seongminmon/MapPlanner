//
//  MapPlannerApp.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI
import RealmSwift

@main
struct MapPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
                }
        }
    }
}
