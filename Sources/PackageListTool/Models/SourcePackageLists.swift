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


struct SourcePackageLists: Codable {
    var categories: [Category]

    struct Category: Codable {
        var name: String
        var anchor: String
        var description: String
        var more: MoreLink? = nil
        var source: Source

        enum Source: Equatable {
            case searchQuery(String)
            case packages([Package])
        }

        struct MoreLink: Codable {
            var title: String
            var url: String
        }
    }

    struct Package: Codable, Equatable {
        var identifier: String
        var note: String? = nil

        var packageId: PackageId? {
            PackageId(argument: identifier)
        }
        
        init(_ identifier: String, note: String? = nil) {
            self.identifier = identifier
            self.note = note
        }

        enum CodingKeys: CodingKey {
            case identifier
            case note
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<SourcePackageLists.Package.CodingKeys> = try decoder.container(keyedBy: SourcePackageLists.Package.CodingKeys.self)
            
            self.identifier = try container.decode(String.self, forKey: SourcePackageLists.Package.CodingKeys.identifier)
            self.note = try container.decodeIfPresent(String.self, forKey: SourcePackageLists.Package.CodingKeys.note)
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container: KeyedEncodingContainer<SourcePackageLists.Package.CodingKeys> = encoder.container(keyedBy: SourcePackageLists.Package.CodingKeys.self)
            
            try container.encode(self.identifier, forKey: SourcePackageLists.Package.CodingKeys.identifier)
            try container.encodeIfPresent(self.note, forKey: SourcePackageLists.Package.CodingKeys.note)
        }
    }
}


extension SourcePackageLists.Category {
    static var searchCache = [String: [SourcePackageLists.Package]]()
    func packageIds(api: SwiftPackageIndexAPI) async throws -> [SourcePackageLists.Package] {
        switch source {
            case let .searchQuery(query):
                if let packages = Self.searchCache[query] {
                    return packages
                }
                let ids = try await api.search(query: query)
                let packages = ids.map { SourcePackageLists.Package("\($0.owner)/\($0.repository)") }
                Self.searchCache[query] = packages
                return packages
            case let .packages(packages):
                return packages
        }
    }
}


extension SourcePackageLists.Category.Source: Codable {
    enum CodingKeys: CodingKey {
        case searchQuery
        case packages
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let searchQuery = try? container.decode(String.self, forKey: .searchQuery) {
            self = .searchQuery(searchQuery)
            return
        }
        if let packages = try? container.decode([SourcePackageLists.Package].self, forKey: .packages) {
            self = .packages(packages)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath,
                                                debugDescription: "Invalid number of keys found, expected one."))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
            case let .searchQuery(query):
                try container.encode(query, forKey: .searchQuery)
            case let .packages(packages):
                try container.encode(packages, forKey: .packages)
        }
    }
}
