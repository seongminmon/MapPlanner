//
//  NaverMapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/12/24.
//

import SwiftUI
import NMapsMap

struct MainMapView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        return context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}

final class Coordinator: NSObject, ObservableObject {
    static let shared = Coordinator()
    
    private let view = NMFNaverMapView(frame: .zero)
    private var locationManager: CLLocationManager?
    
    var markersDict: [String: NMFMarker] = [:]
    var didTapMap: (() -> Void)?
    
    private override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 15
        view.mapView.minZoomLevel = 6
        view.mapView.maxZoomLevel = 18
        
        view.showLocationButton = true
        view.showZoomControls = true
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        return view
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
    
    func addMarker(_ location: Location, touchHandler: NMFOverlayTouchHandler?) {
        // 이미 딕셔너리에 있는 경우는 패스
        guard markersDict[location.id] == nil else { return }
        
        let marker = NMFMarker.customMarker
        marker.position = NMGLatLng(lat: location.lat, lng: location.lng)
        marker.captionText = location.placeName
        
        marker.mapView = view.mapView
        marker.touchHandler = { [weak self] overlay in
            guard self != nil else { return false }
            return touchHandler?(overlay) ?? false
        }
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
    
    // 네이버 길찾기로 연결
    static func openNaverMap(lat: Double, lng: Double, name: String) {
        let urlString = "nmap://route/public?dlat=\(lat)&dlng=\(lng)&dname=\(name)&appname=com.ksm.MapDiary"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString),
              let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else {
            print("네이버 길찾기 url 또는 앱스토어 url 없음")
            return
        }
        
        // TODO: - 앱이 이미 실행 중일 때 도착지 입력이 안됨
        if UIApplication.shared.canOpenURL(url) {
            print("네이버 길찾기 연결")
            print(url)
            UIApplication.shared.open(url)
        } else {
            print("앱 스토어 연결")
            print(appStoreURL)
            UIApplication.shared.open(appStoreURL)
        }
    }
}

// MARK: - 위치 권한 관련 메서드
extension Coordinator: CLLocationManagerDelegate {
    
    // 권한 변경 시점
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("위치 서비스 이용 불가")
            }
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // 권한 요청
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
            cameraUpdate(lat: Location.defaultLat, lng: Location.defaultLng)
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
            cameraUpdate(lat: Location.defaultLat, lng: Location.defaultLng)
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 권한 O 유저 위치로 이동")
            fetchUserLocation()
        @unknown default:
            break
        }
    }
    
    private func fetchUserLocation() {
        guard let locationManager = locationManager else { return }
        let lat = locationManager.location?.coordinate.latitude ?? Location.defaultLat
        let lng = locationManager.location?.coordinate.longitude ?? Location.defaultLng
        cameraUpdate(lat: lat, lng: lng)
    }
}

// MARK: - 카메라 관련 Delegate
extension Coordinator: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라의 위치가 변경되면 호출되는 함수
    }
}

// MARK: - 맵 터치 관련 Delegate
extension Coordinator: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        didTapMap?()
    }
}
