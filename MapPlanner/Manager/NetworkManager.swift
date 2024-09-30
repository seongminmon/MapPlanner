//
//  NetworkManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // 키워드로 장소 검색하기
    private let urlString = "https://dapi.kakao.com/v2/local/search/keyword"
    
    func callRequest(_ query: String, page: Int = 1) async throws -> LocalResponse {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        // 헤더 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(APIKey.localSearchKey, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = try JSONDecoder().decode(LocalResponse.self, from: data)
        return decodedData
    }
}
