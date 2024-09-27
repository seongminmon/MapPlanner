//
//  MapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct MapView: View {
    
    @StateObject var coordinator = Coordinator.shared
    @ObservedResults(Plan.self) var plans
    
    var body: some View {
        VStack {
            NaverMapView()
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            // 권한 설정
            Coordinator.shared.checkIfLocationServiceIsEnabled()
        }
        .onChange(of: plans) { newValue in
            coordinator.clearMarkers()
            // 마커 그리기
            plans.forEach { item in
                guard let location = item.toLocation() else { return }
                coordinator.addMarker(location) { _ in
                    print("마커 탭", location)
                    return true
                }
            }
        }
    }
}
