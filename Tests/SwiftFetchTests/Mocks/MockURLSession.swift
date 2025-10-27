//
//  File.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

@testable import SwiftFetch
import Foundation

struct MockURLSession: Fetcher {
    var mockData: Data = .init()
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        (mockData, URLResponse())
    }
}
