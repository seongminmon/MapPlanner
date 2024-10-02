//
//  SubMapView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/1/24.
//

import SwiftUI
import NMapsMap

// 서브 지도 뷰 (NMFMapView 사용)
struct SubMapView: UIViewRepresentable {
    let lat: Double
    let lng: Double

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        
        // 지정된 위도, 경도로 마커 위치 설정
        let markerLocation = NMGLatLng(lat: lat, lng: lng)
        
        // 마커 추가
        let marker = NMFMarker(position: markerLocation)
        marker.mapView = mapView

        // 초기 카메라 설정
        let cameraPosition = NMFCameraPosition(markerLocation, zoom: 15)
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {}
}
