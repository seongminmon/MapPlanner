//
//  UIMapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/12/24.
//

import SwiftUI
import NMapsMap

struct UIMapView: UIViewRepresentable {
    
    var coord: (Double, Double)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
    // naverMap 길찾기 구현
    func naverMap(lat: Double, lng: Double) {
        // URL Scheme을 사용하여 네이버맵 앱을 열고 자동차 경로를 생성합니다.
        guard let url = URL(string: "nmap://route/car?dlat=\(lat)&dlng=\(lng)&appname=kr.co.kepco.ElectricCar") else { return }
        // 앱 스토어 URL을 설정합니다.
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }

        if UIApplication.shared.canOpenURL(url) {
            // 네이버맵 앱이 설치되어 있는 경우 앱을 엽니다.
            UIApplication.shared.open(url)
        } else {
            // 네이버맵 앱이 설치되어 있지 않은 경우 앱 스토어로 이동합니다.
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        
        var coord: (Double, Double)
        
        init(_ coord: (Double, Double)) {
            self.coord = coord
        }
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
            print("카메라 변경 - reason: \(reason)")
        }
        
        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
            print("카메라 변경 - reason: \(reason)")
        }
    }
}
