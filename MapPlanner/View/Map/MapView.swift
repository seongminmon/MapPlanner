//
//  MapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI

struct MapView: View {
    
    @StateObject var coordinator = Coordinator.shared
    @StateObject private var planStore = PlanStore()
    
    var body: some View {
        VStack {
            NaverMapView()
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            // 권한 설정
            Coordinator.shared.checkIfLocationServiceIsEnabled()
        }
        .onChange(of: planStore.outputPlans) { newValue in
            let currentLocations = newValue.compactMap { $0.toLocation() }
            let existingLocations = coordinator.markersDict.keys
            
            let currentLocationIDList = currentLocations.map { $0.id }
            let removeLocations: [String] = existingLocations.filter { !currentLocationIDList.contains($0) }
            
            // 없어진 마커 삭제
            coordinator.removeMarkers(removeLocations)
            
            // 새로운 마커 추가
            currentLocations.forEach { location in
                coordinator.addMarker(location) { _ in
                    print("마커 탭", location)
                    return true
                }
            }
        }
    }
}
