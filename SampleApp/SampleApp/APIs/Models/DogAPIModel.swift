//
//  DogAPIModel.swift
//  SampleApp
//
//  Created by Marco Picchillo on 27/10/2025.
//

import Foundation

struct DogAPIModel: Decodable, Equatable {
    let data: [DogAPIModelData]
    
    struct DogAPIModelData: Decodable, Equatable {
        let attributes: DogAPIModelDataAttributes
        
        struct DogAPIModelDataAttributes: Decodable, Equatable {
            let body: String
        }
    }
}
