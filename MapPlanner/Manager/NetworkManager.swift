//
//  NetworkManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import Foundation
import Combine

enum LocalRouter {
    // 키워드로 장소 검색하기
    case local(query: String, page: Int)
    // 좌표로 주소 변환하기
    case coordinate(lon: Double, lat: Double)
    
    // MARK: - 좌표로 주소를 변환하면 placeName이 없게됨
    // >> 유저가 placeName을 직접 정하도록 하기!!
    // >> +) 카테고리 네임까지!!
    
    // 어떻게 좌표로 추가하지??
    // 1. 메인 지도에서 추가하기
    // 2. 기록 추가하기 화면에서 검색으로 추가하거나 / 좌표로 추가하거나 선택하도록 하기
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

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest<T: Decodable>(_ router: LocalRouter, _ model: T.Type) -> AnyPublisher<T, Error> {
        guard var urlComponents = URLComponents(string: router.urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = router.queryItems
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // 헤더 추가
        var request = URLRequest(url: url)
        request.httpMethod = router.httpMethod
        request.addValue(APIKey.localKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
