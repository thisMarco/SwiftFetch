@testable import SwiftFetch
import XCTest

class DataFetcherTests: XCTestCase {
    let mockURL: URL = URL(string: "https://example.com")!
    
    func testFetchData_whenValidDataIsReturned_withApple() async {
        struct Apple: Decodable, Equatable {
            let variety: String
            let weight: Double
            
            init(variety: String = "Gala", weight: Double = 0.250) {
                self.variety = variety
                self.weight = weight
            }
        }
        
        var mockFetcher = MockURLSession()
        mockFetcher.mockResponse = HTTPURLResponse(
            url: mockURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        mockFetcher.mockData = """
            {
                "variety": "Gala",
                "weight": 0.250
            }
            """.data(using: .utf8)!
        
        var fetchState: FetchResult<Apple> = .idle
        let sut = DataFetcher(fetcher: mockFetcher)
        
        await sut.fetch(Apple.self, from: mockURL) { result in
            fetchState = result
        }
        
        switch fetchState {
        case .success(let apple):
            XCTAssertEqual(apple.variety, "Gala")
            XCTAssertEqual(apple.weight, 0.250)
        default:
            XCTFail("Expected a .success result")
        }
    }
    
    func testFetchData_whenValidDataIsReturned_withCar() async throws {
        struct Car: Decodable, Equatable {
            let model: String
            let features: [String]
            
            init(model: String = "Panda", features: [String] = ["ABS", "SatNav"]) {
                self.model = model
                self.features = features
            }
        }
        
        var mockFetcher = MockURLSession()
        mockFetcher.mockData = """
            {
                "model": "Panda",
                "features": [
                    "ABS",
                    "SatNav"
                ]
            }
            """.data(using: .utf8)!
        
        var fetchState: FetchResult<Car> = .idle
        let sut = DataFetcher(fetcher: mockFetcher)
        
        await sut.fetch(Car.self, from: mockURL) { result in
            fetchState = result
        }
        
        switch fetchState {
        case .success(let apple):
            XCTAssertEqual(apple.model, "Panda")
            XCTAssertEqual(apple.features.first!, "ABS")
            XCTAssertEqual(apple.features.last, "SatNav")
        default:
            XCTFail("Expected a .success result")
        }
    }
    
    func testFetchData_whenStatusCodeIsNot200() async throws {
        var mockFetcher = MockURLSession()
        
        mockFetcher.mockResponse = HTTPURLResponse(
            url: mockURL,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        mockFetcher.mockData = "".data(using: .utf8)!
        
        var fetchState: FetchResult<String> = .idle
        let sut = DataFetcher(fetcher: mockFetcher)
        
        await sut.fetch(String.self, from: mockURL) { result in
            fetchState = result
        }
        
        switch fetchState {
        case .failure(let error):
            XCTAssertEqual(error.description, "Failed response with status code: 404")
        default:
            XCTFail("Expected a .failure result")
        }
    }
    
    func testFetchData_whenFailsToDecode() async throws {
        var mockFetcher = MockURLSession()
        
        mockFetcher.mockResponse = HTTPURLResponse(
            url: mockURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        var fetchState: FetchResult<Int> = .idle
        let sut = DataFetcher(fetcher: mockFetcher)
        
        await sut.fetch(Int.self, from: mockURL) { result in
            fetchState = result
        }
        
        switch fetchState {
        case .failure(let error):
            XCTAssertEqual(error.description, "Failed to decode data")
        default:
            XCTFail("Expected a .failure result")
        }
    }
}
