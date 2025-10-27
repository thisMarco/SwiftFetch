//
//  Fetcher.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

struct DataFetcher {
    private let fetcher: Fetchable
    
    init(fetcher: Fetchable = URLSession.shared) {
        self.fetcher = fetcher
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, responseHandler: ((FetchResult<T>) -> Void)) async {
        do {
            let (data, response) = try await fetcher.data(from: url)
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                let errorCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                responseHandler(.failure(.failedResponse(errorCode)))
                return
            }
            
            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                responseHandler(.failure(.failedToDecode))
                return
            }
            
            return responseHandler(.success(decoded))
        } catch {
            responseHandler(.failure(.unknown(error.localizedDescription)))
        }
    }
}
