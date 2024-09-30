//
//  NaverMapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/12/24.
//

import SwiftUI
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    // TODO: - 첫 위치 카메라 이동하기
    // 권한 설정시 내 위치로 카메라 이동하기
    // 권한 없으면 기본 위치로 이동하기
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        print(#function)
        let mapView = context.coordinator.getNaverMapView()
        context.coordinator.cameraUpdate(
            lat: Location.defaultLat,
            lng: Location.defaultLng
        )
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}

final class Coordinator: NSObject, ObservableObject {
    static let shared = Coordinator()
    
    private let view = NMFNaverMapView(frame: .zero)
    private var locationManager: CLLocationManager?
    var markersDict: [String: NMFMarker] = [:] {
        didSet {
            print("마커 갯수", markersDict.count)
        }
    }
    var didTapMap: (() -> Void)?
    
    typealias Coord = (lat: Double, lng: Double)
    @Published private var coord = Coord(lat: Location.defaultLat, lng: Location.defaultLng)
    @Published private var userLocation = Coord(lat: Location.defaultLat, lng: Location.defaultLng)
    
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
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        return view
    }
    
    // TODO: - 커스텀 마커 사용
    
    func addMarker(_ location: Location, touchHandler: NMFOverlayTouchHandler?) {
        // 이미 딕셔너리에 있는 경우는 패스
        guard markersDict[location.id] == nil else { return }
        
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_BLUE
        marker.position = NMGLatLng(lat: location.lat, lng: location.lng)
        marker.mapView = view.mapView
        marker.touchHandler = touchHandler
        markersDict[location.id] = marker
    }
    
    func removeMarkers(_ locataionIDList: [String]) {
        print("마커 지우기", locataionIDList)
        locataionIDList.forEach { id in
            if let marker = markersDict[id] {
                marker.mapView = nil
                markersDict[id] = nil
            }
        }
    }
    
    // MARK: - 미사용
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
                    self.locationManager?.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on")
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
            let lat = locationManager.location?.coordinate.latitude ?? Location.defaultLat
            let lng = locationManager.location?.coordinate.longitude ?? Location.defaultLng
            coord = (lat, lng)
            userLocation = (lat, lng)
            fetchUserLocation()
            
        @unknown default:
            break
        }
    }
    
    private func fetchUserLocation() {
        guard let locationManager = locationManager else { return }
        let lat = locationManager.location?.coordinate.latitude ?? Location.defaultLat
        let lng = locationManager.location?.coordinate.longitude ?? Location.defaultLng
        print("위경도:", lat, lng)
        cameraUpdate(lat: lat, lng: lng)
    }
    
    func cameraUpdate(lat: Double, lng: Double) {
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(lat: lat, lng: lng),
            zoomTo: 15
        )
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        let locationOverlay = view.mapView.locationOverlay
        locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
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
        //        print(#function, "카메라 이동 전")
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라의 위치가 변경되면 호출되는 함수
        //        print(#function, "카메라 위치 변경")
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
