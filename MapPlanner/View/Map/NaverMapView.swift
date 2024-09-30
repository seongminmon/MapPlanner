//
//  NaverMapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/12/24.
//

import SwiftUI
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = context.coordinator.getNaverMapView()
        context.coordinator.cameraUpdate(
            lat: Location.defaultLat,
            lng: Location.defaultLng
        )
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}
