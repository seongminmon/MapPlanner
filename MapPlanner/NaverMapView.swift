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
        return context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}

final class Coordinator: NSObject, ObservableObject {
    static let shared = Coordinator()
    
    private let view = NMFNaverMapView(frame: .zero)
    private var locationManager: CLLocationManager?
    
    typealias Coord = (lat: Double, lon: Double)
    @Published private var coord: Coord = (0.0, 0.0)
    @Published private var userLocation: Coord = (0.0, 0.0)
    
    private override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        view.mapView.zoomLevel = 15
        //        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        //        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
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
    
    func setMarker(lat: Double, lng: Double) {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_PINK
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = view.mapView
        
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = "서울특별시청"
        infoWindow.dataSource = dataSource
        infoWindow.open(with: marker)
    }
    
    // naverMap 길찾기 구현
    func openRouteURL(lat: Double, lng: Double) {
        // URL Scheme을 사용하여 네이버맵 앱을 열고 자동차 경로를 생성합니다.
        guard let url = URL(string: "nmap://route/car?dlat=\(lat)&dlng=\(lng)&appname=com.ksm.MapPlanner") else { return }
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
}

// MARK: - 위치 관련 Delegate
extension Coordinator: CLLocationManagerDelegate {
    
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on")
            }
        }
    }
    
    // MARK: - 위치 정보 동의 확인
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
            
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            
            fetchUserLocation()
            
        @unknown default:
            break
        }
    }
    
    private func fetchUserLocation() {
        guard let locationManager = locationManager else { return }
        
        let lat = locationManager.location?.coordinate.latitude
        let lng = locationManager.location?.coordinate.longitude
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0),
            zoomTo: 15
        )
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        let locationOverlay = view.mapView.locationOverlay
        locationOverlay.location = NMGLatLng(
            lat: lat ?? 0.0,
            lng: lng ?? 0.0
        )
        locationOverlay.hidden = false
        
        locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
        
        view.mapView.moveCamera(cameraUpdate)
    }
}

// MARK: - 카메라 이동 관련 Delegate
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
    
}
