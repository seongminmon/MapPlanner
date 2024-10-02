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
        let markerLocation = NMGLatLng(lat: lat, lng: lng)
        
        // 마커 추가
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_BLUE
        marker.position = markerLocation
        marker.mapView = mapView

        // 마커 화면 중심으로 이동
        DispatchQueue.main.async {
            let cameraPosition = NMFCameraPosition(markerLocation, zoom: 15)
            mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        }
        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {}
}
