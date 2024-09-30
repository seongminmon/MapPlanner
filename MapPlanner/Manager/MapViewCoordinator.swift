//
//  MapViewCoordinator.swift
//  MapPlanner
//
//  Created by 김성민 on 9/30/24.
//

import Foundation
import NMapsMap

final class Coordinator: NSObject, ObservableObject {
    static let shared = Coordinator()
    
    private let view = NMFNaverMapView(frame: .zero)
    private var locationManager: CLLocationManager?
    
    var markersDict: [String: NMFMarker] = [:] {
        didSet {
            print("마커 갯수 \(markersDict.count)")
        }
    }
    var didTapMap: (() -> Void)?
    
    private override init() {
        super.init()
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        view.mapView.zoomLevel = 15
        view.mapView.minZoomLevel = 5
        view.mapView.maxZoomLevel = 18
        view.showLocationButton = true
        view.showZoomControls = true
        view.showCompass = false
        view.showScaleBar = false
        view.mapView.touchDelegate = self
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        return view
    }
    
    // MARK: - 마커 관련 메서드
    
    func addMarker(_ location: Location, touchHandler: NMFOverlayTouchHandler?) {
        // 이미 딕셔너리에 있는 경우는 패스
        guard markersDict[location.id] == nil else { return }
        
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_BLUE
        marker.position = NMGLatLng(lat: location.lat, lng: location.lng)
        marker.mapView = view.mapView
        marker.touchHandler = touchHandler
        // 딕셔너리에 추가
        markersDict[location.id] = marker
    }
    
    func removeMarkers(_ locataionIDList: [String]) {
        locataionIDList.forEach { id in
            if let marker = markersDict[id] {
                marker.mapView = nil
                markersDict[id] = nil
            }
        }
    }
}

// MARK: - 위치 관련 Delegate
extension Coordinator: CLLocationManagerDelegate {
    
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager?.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("위치 서비스 이용 불가")
            }
        }
    }
    
    // 위치 정보 동의 확인
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 정보 권한 O")
            
        @unknown default:
            break
        }
    }
    
    func cameraUpdate(lat: Double, lng: Double) {
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(lat: lat, lng: lng),
            zoomTo: 15
        )
        cameraUpdate.animation = .linear
        cameraUpdate.animationDuration = 0.5
        view.mapView.moveCamera(cameraUpdate)
    }
}

// MARK: - 맵 터치 관련 Delegate
extension Coordinator: NMFMapViewTouchDelegate {
    
    // 지도가 탭되면 호출되는 메서드
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(#function, latlng)
        didTapMap?()
    }
}
