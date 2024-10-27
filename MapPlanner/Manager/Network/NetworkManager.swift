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
            .catch { error -> Fail<T, Error> in
                if let decodingError = error as? DecodingError {
                    print("디코딩 에러: \(decodingError)")
                } else {
                    print("에러: \(error.localizedDescription)")
                }
                return Fail(error: error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
