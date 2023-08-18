// Copyright Dave Verwer, Sven A. Schmidt, and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import Foundation


struct SwiftPackageIndexAPI {
    var baseURL: String
    var apiToken: String

    struct Error: Swift.Error {
        var message: String
    }

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func fetchPackage(owner: String, repository: String) async throws -> Package {
        let url = URL(string: "\(baseURL)/api/packages/\(owner)/\(repository)")!
        var req = URLRequest(url: url)
        req.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: req)
        return try Self.decoder.decode(Package.self, from: data)
    }

    func search(query: String, limit: Int) async throws -> [PackageId] {
        var urlComponents = URLComponents(string: "\(baseURL)/api/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "pageSize", value: "\(limit)"),
        ]
        guard let url = urlComponents?.url else {
            throw Error(message: "Failed to construct search query URL")
        }
        var req = URLRequest(url: url)
        req.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: req)
        let results = try Self.decoder.decode(SearchResponse.self, from: data)
        var ids = [PackageId]()
        for res in results.results {
            switch res {
                case .author, .keyword:
                    break
                case let .package(pkg):
                    ids.append(.init(owner: pkg.repositoryOwner, repository: pkg.packageName))
            }
        }
        return ids
    }

    struct SearchResponse: Decodable {
        var hasMoreResults: Bool
        var results: [Result]

        enum Result: Decodable {
            case author(Author)
            case keyword(Keyword)
            case package(Package)

            struct Author: Decodable {
                var name: String
            }
            struct Keyword: Decodable {
                var keyword: String
            }
            struct Package: Decodable {
                var packageURL: String
                var repositoryOwner: String
                var packageName: String
            }
        }
    }
}
