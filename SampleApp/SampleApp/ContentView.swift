//
//  ContentView.swift
//  SampleApp
//
//  Created by Marco Picchillo on 27/10/2025.
//

import SwiftUI
import SwiftFetch

struct ContentView: View {
    @State private var selectedApi: AvailableAPIs = .dogApi
    @State private var fact: String = "Loading Initial Fact..."
    private let fetcher = DataFetcher()

    var body: some View {
        VStack {
            Picker("Select The API for a Fact", selection: $selectedApi) {
                ForEach(AvailableAPIs.allCases, id: \.self) {
                    Text($0.description)
                }
            }
            .pickerStyle(.inline)
            
            Text(fact)
                .font(.body)
        }
        .padding()
        .onChange(of: selectedApi) {
            switch selectedApi {
            case .dogApi:
                Task {
                    await fetcher.fetch(DogAPIModel.self, from: selectedApi.url, responseHandler: {
                        result in
                        switch result {
                        case .success(let dogApiFact):
                            fact = dogApiFact.data.first!.attributes.body
                        default:
                            fact = "Failed to fetch a dog fact"
                        }
                    })
                }
                
            case .meaowFacts, .decodingError:
                // Decoding error will try to decode the DogAPIModel with MeaowFacts data.
                Task {
                    await fetcher.fetch(MeaowAPIModel.self, from: selectedApi.url, responseHandler: {
                        result in
                        switch result {
                        case .success(let dogApiFact):
                            fact = dogApiFact.data.first!
                        case .failure(let error):
                            fact = "Failed with error: \(error.message)"
                        default:
                            fact = "Failed to fetch a cat fact"
                        }
                    })
                }
            case .httpError:
                Task {
                    await fetcher.fetch(String.self, from: selectedApi.url, responseHandler: {
                        result in
                        switch result {
                        case .success:
                            fact = "Espected to Fail"
                        case .failure(let error):
                            fact = error.message
                        default:
                            fact = "Expecting a 404 Error"
                        }
                    })
                }
            }
        }
        .task {
            selectedApi = .meaowFacts
        }
    }
}

#Preview {
    ContentView()
}
