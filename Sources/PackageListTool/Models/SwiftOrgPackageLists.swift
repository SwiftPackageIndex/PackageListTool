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


struct SwiftOrgPackageLists: Codable {
    var categories: [Category]

    init(packages: [Package]) {
        self.categories = [
            .init(name: "Test", anchor: "test", description: "Testing", packages: packages)
        ]
    }

    struct Category: Codable {
        var name: String
        var anchor: String
        var description: String
        var more: MoreLink? = nil
        var packages: [Package]

        struct MoreLink: Codable {
            var title: String
            var url: String
        }
    }

    struct Package: Codable {
        var name: String
        var description: String
        var swiftCompatibility: String
        var platformCompatibility: [String]
        var platformCompatibilityTooltip: String
        var license: String
        var url: String

        enum CodingKeys: String, CodingKey {
            case name
            case description
            case swiftCompatibility = "swift_compatibility"
            case platformCompatibility = "platform_compatibility"
            case platformCompatibilityTooltip = "platform_compatibility_tooltip"
            case license
            case url
        }

        init(from package: API.APIPackage) {
            self.name = package.title
            self.description = package.summary ?? ""
            self.swiftCompatibility = package.swiftVersionCompatibility.sorted().first.map { "\($0.major).\($0.minor)+" } ?? "unknown"
            self.platformCompatibility = package.groupedPlatformCompatibility.map(\.rawValue)
            self.platformCompatibilityTooltip = package.platformCompatibilityTooltip
            self.license = package.license.shortName
            self.url = "https://swiftpackageindex.com/\(package.repositoryOwner)/\(package.repositoryName)"
        }
    }
}
