//
//  NetworkManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // 키워드로 장소 검색하기
    private let urlString = "https://dapi.kakao.com/v2/local/search/keyword"
    
    func callRequest(_ query: String, page: Int) -> AnyPublisher<LocalResponse, Error> {
        guard var urlComponents = URLComponents(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // 헤더 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(APIKey.localSearchKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: LocalResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
