//
//  LocalRouter.swift
//  MapPlanner
//
//  Created by 김성민 on 10/27/24.
//

import Foundation

enum LocalRouter {
    // 키워드로 장소 검색하기
    case local(query: String, page: Int)
    // 좌표로 주소 변환하기
    case coordinate(lon: Double, lat: Double)
    
    // TODO: - 좌표로 장소 추가 기능
    // MARK: - 좌표로 주소를 변환하면 placeName이 없게됨
    // >> 유저가 placeName을 직접 정하도록 하기!!
    // >> +) 카테고리 네임까지!!
    
    // 어떻게 좌표로 추가하지??
    // 1. 메인 지도에서 추가하기
    // 2. 기록 추가하기 화면에서 검색으로 추가하거나 / 좌표로 추가하거나 선택하도록 하기
    
    // 장소 추가 Flow
    // 지도 탭 -> 이 위치로 장소를 추가할까요? 얼럿
    // -> placeName과 카테고리 네임 정하기
}

extension LocalRouter {
    private var baseURL: String {
        return "https://dapi.kakao.com/v2/local/"
    }
    
    var urlString: String {
        switch self {
        case .local:
            return baseURL + "search/keyword"
        case .coordinate:
            return baseURL + "geo/coord2address"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .local(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .coordinate(let lon, let lat):
            return [
                URLQueryItem(name: "x", value: "\(lon)"),
                URLQueryItem(name: "y", value: "\(lat)")
            ]
        }
    }
    
    var httpMethod: String {
        switch self {
        case .local:
            return "GET"
        case .coordinate:
            return "GET"
        }
    }
}
