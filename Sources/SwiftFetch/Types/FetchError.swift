//
//  File.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

enum FetchError: Equatable {
    case failedToDecode
    case failedResponse(Int)
    case unknown(String)
    
    var description: String {
        switch self {
        case .failedToDecode:
            "Failed to decode data"
        case .failedResponse(let statusCode):
            "Failed response with status code: \(statusCode)"
        case .unknown(let message):
            message
        }
    }
}
