//
//  FetchError.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

public enum FetchError: Equatable {
    case failedToDecode
    case failedResponse(Int)
    case unknown(String)
    
    public var message: String {
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
