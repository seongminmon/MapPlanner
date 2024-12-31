//
//  MapPlannerApp.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI
import RealmSwift

// TODO: - 사진 비율 조절 기능
// TODO: - 다국어 대응
// TODO: - 위젯 추가
// TODO: - Push Notification 추가
// TODO: - 테스트 코드 작성

// TODO: - 별점 기능 추가

@main
struct MapPlannerApp: App {
    
    @State private var toast: Toast? = nil
    
    init() {
        configureRealm()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    // Toast NotificationCenter 구독
                    NotificationCenter.default.addObserver(
                        forName: .showToast,
                        object: nil,
                        queue: .main
                    ) { notification in
                        if notification.toast != nil {
                            self.toast = toast
                            ToastWindowManager.shared.showToast(toast: self.$toast)
                        }
                    }
                }
        }
    }
    
    private func configureRealm() {
//        print("Realm file path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // 별점 추가
                    migration.enumerateObjects(ofType: RealmDiary.className()) { oldObject, newObject in
                        newObject?["rating"] = nil
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}
