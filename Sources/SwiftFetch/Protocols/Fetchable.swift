//
//  Fetchable.swift
//  SwiftFetch
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

public protocol Fetchable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: Fetchable {}
