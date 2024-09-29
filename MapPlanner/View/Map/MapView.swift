//
//  MapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI

struct MapView: View {
    
    // TODO: - 마커 선택 시
    // 일정 정보 띄우기
    // 다른 곳 탭하면 일정 정보 사라지게 하기
    // 일정 추가 버튼
    
    @StateObject private var coordinator = Coordinator.shared
    @StateObject private var planStore = PlanStore()
    @State private var selectedPlan: PlanOutput?
    
    var body: some View {
        VStack {
            NaverMapView()
                .ignoresSafeArea(.all, edges: .bottom)
                .overlay(alignment: .bottom) {
                    if let selectedPlan {
                        PlanCell(plan: selectedPlan)
                            .transition(.move(edge: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .animation(.easeInOut, value: selectedPlan)
        }
        .onAppear {
            // 권한 설정
            coordinator.checkIfLocationServiceIsEnabled()
            coordinator.didTapMap = {
                print(#function)
                selectedPlan = nil
            }
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
                        selectedPlan = plan
                        return true
                    }
                }
            }
        }
    }
}
