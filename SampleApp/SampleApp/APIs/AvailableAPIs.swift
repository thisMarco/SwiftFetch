//
//  AvailableAPIs.swift
//  SampleApp
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

enum AvailableAPIs: CaseIterable {
    case dogApi
    case meaowFacts
    case httpError
    case decodingError
    
    var description: String {
        switch self {
        case .dogApi:
            "Dog API"
        case .meaowFacts:
            "Meow Facts"
        case .httpError:
            "404 Error"
        case .decodingError:
            "Decoding Error"
        }
    }
    
    var url: URL {
        switch self {
        case .dogApi:
            URL(string: "https://dogapi.dog/api/v2/facts?limit=1")!
        case .meaowFacts:
            URL(string: "https://meowfacts.herokuapp.com/")!
        case .httpError:
            URL(string: "https://google.com/404")!
        case .decodingError:
            URL(string: "https://dogapi.dog/api/v2/facts?limit=1")!
        }
    }
}
