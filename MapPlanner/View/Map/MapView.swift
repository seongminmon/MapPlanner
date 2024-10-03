//
//  MapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import NMapsMap

struct MapView: View {
    
    // TODO: - 지도 처음 띄울때 오래 걸리는 문제 -> 로딩 뷰 보이기
    
    @StateObject private var diaryManager = DiaryManager()
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @State private var selectedDiary: Diary?
    @State private var isFirst = true
    
    var body: some View {
        ZStack {
            MainMapView()
            .ignoresSafeArea(.all, edges: .top)
            AddDiaryButton()
        }
        .onAppear {
            if isFirst {
                coordinator.checkIfLocationServiceIsEnabled()
                coordinator.didTapMap = { selectedDiary = nil }
                isFirst = false
            }
        }
        .onChange(of: diaryManager.diaryList) { newValue in
            let currentLocations = newValue.compactMap { $0.toLocation() }
            let currentLocationIDList = currentLocations.map { $0.id }
            
            let existingLocations = coordinator.markersDict.keys
            let removeLocations: [String] = existingLocations.filter { !currentLocationIDList.contains($0) }
            
            // 없어진 마커 삭제
            coordinator.removeMarkers(removeLocations)
            
            // 새로운 마커 추가
            newValue.forEach { diary in
                if let location = diary.toLocation() {
                    coordinator.addMarker(location) { _ in
                        coordinator.cameraUpdate(lat: location.lat, lng: location.lng)
                        selectedDiary = diary
                        return true
                    }
                }
            }
        }
        .sheet(item: $selectedDiary) { diary in
            LocationDiaryListView(location: diary.toLocation())
        }
    }
}
