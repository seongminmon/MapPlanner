//
//  MapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI

struct MapView: View {
    
    @StateObject private var coordinator = Coordinator.shared
    @StateObject private var diaryManager = DiaryManager()
    
    @State private var selectedDiary: Diary?
    
    var body: some View {
        ZStack {
            NaverMapView()
                .ignoresSafeArea(.all, edges: .top)
            AddDiaryButton()
        }
        .onAppear {
            // 권한 설정
            print("onAppear")
            coordinator.checkIfLocationServiceIsEnabled()
            coordinator.didTapMap = {
                selectedDiary = nil
            }
        }
        .onChange(of: diaryManager.diaryList) { newValue in
            print("onChange")
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
