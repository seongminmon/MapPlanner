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
    @State private var showPlanCell = false
    
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
            let currentLocationIDList = currentLocations.map { $0.id }
            
            let existingLocations = coordinator.markersDict.keys
            let removeLocations: [String] = existingLocations.filter { !currentLocationIDList.contains($0) }
            
            // 없어진 마커 삭제
            coordinator.removeMarkers(removeLocations)
            
            // 새로운 마커 추가
            newValue.forEach { plan in
                if let location = plan.toLocation() {
                    coordinator.addMarker(location) { _ in
                        showPlanCell.toggle()
                        return true
                    }
                }
            }
        }
        .sheet(isPresented: $showPlanCell) {
            // TODO: - marker에서 탭한 plan 넘겨받기
//            PlanCell(plan: plan)
        }
    }
}
