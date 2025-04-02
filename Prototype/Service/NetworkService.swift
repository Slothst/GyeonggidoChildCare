//
//  NetworkService.swift
//  Prototype
//
//  Created by 최낙주 on 4/1/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequset
    case invalidResponse
    case responseError(statusCode: Int)
    case jsonDecodingError(error: Error)
}

struct NetworkService {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.urlRequest else {
            print("2")
            return .fail(NetworkError.invalidRequset)
        }
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
