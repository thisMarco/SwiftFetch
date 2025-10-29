# SwiftFetch

SwiftFetch provides a simple, testable way to **fetch** and **decode** data from APIs using a protocol-based abstraction over `URLSession`.

---

## ✅ Features

- Protocol-based abstraction (`Fetchable`) for `URLSession` to allow easy mocking and testing  
- Generic `DataFetcher` to load `Decodable` models from a URL
- Supports Swift concurrency (async/await)
- Lightweight and unopinionated — you bring your own models and error handling

---

## 🚀 Installation

### Swift Package Manager  
Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/thisMarco/SwiftFetch.git", from: "1.0.0")
]
```

---

## 🧩 Usage

1. Define your model
```swift
public struct Apple: Decodable, Equatable {
    public let variety: String
    public let weight: Double

    public init(variety: String = "Gala", weight: Double = 0.250) {
        self.variety = variety
        self.weight = weight
    }
}
```

2. Create a fetcher and fetch data
```swift
let url = URL(string: "https://example.com/apple.json")!
let fetcher = DataFetcher()

await fetcher.fetch(Apple.self, from: url) { result in
    switch result {
    case .idle:
        print("Idle")
    case .fetching:
        print("Fetching…")
    case .success(let apple):
        print("Received apple: \(apple)")
    case .failure(let message):
        print("Error: \(message)")
    }
}
```

3. In SwiftUI, using `@State`
```swift
struct ContentView: View {
    @State private var result: FetchResult<Apple> = .idle
    private let fetcher = DataFetcher()

    var body: some View {
        VStack {
            switch result {
            case .idle:
                Text("Idle")
            case .fetching:
                ProgressView()
            case .success(let apple):
                Text("Apple: \(apple.variety), weight: \(apple.weight)")
            case .failure(let message):
                Text("Error: \(message)").foregroundColor(.red)
            }
        }
        .task {
            result = .fetching
            await fetcher.fetch(Apple.self, from: url) { result in
                self.result = result
            }
        }
    }
}
```

---

## 🔍 Testing & Mocking

Because the fetching logic uses a `Fetchable` protocol, you can inject a mock for tests:
```swift
struct MockFetcher: Fetchable {
    var data: Data
    var response: URLResponse

    func data(from url: URL) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}
```
