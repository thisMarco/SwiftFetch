//
//  File.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

@testable import SwiftFetch
import Foundation

struct MockURLSession: Fetchable {
    var mockData: Data = .init()
    var mockResponse: HTTPURLResponse = HTTPURLResponse()
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        (mockData, mockResponse)
    }
}
