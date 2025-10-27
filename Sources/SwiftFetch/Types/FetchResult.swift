//
//  FetchResult.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

enum FetchResult<T: Equatable>: Equatable {
    case success(T)
    case idle
    case fetching
    case failure(String)
}
