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

import Collections

extension SwiftPackageIndexAPI {
    public struct Package: Codable {
        public var repositoryOwner: String
        public var repositoryName: String
        public var repositoryOwnerName: String?
        public var platformCompatibility: [PlatformCompatibility]?
        public var license: License
        public var swiftVersionCompatibility: [SwiftVersion]?
        public var summary: String?
        public var title: String
        public var url: String

        public enum PlatformCompatibilityGroup: String, CaseIterable, Codable {
            case apple = "Apple"
            case linux = "Linux"

            var platforms: OrderedSet<PlatformCompatibility> {
                switch self {
                    // The order here is important and should match the columns in the compatibility matrix on the SPI website.
                    case .apple: return [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
                    case .linux: return [.linux]
                }
            }
        }
    }
}

extension SwiftPackageIndexAPI.Package {
    public var groupedPlatformCompatibility: [PlatformCompatibilityGroup] {
        PlatformCompatibilityGroup.allCases.filter { group in
            Set(platformCompatibility ?? []).isDisjoint(with: group.platforms) == false
        }
    }

    public var platformCompatibilityTooltip: String {
        groupedPlatformCompatibility.map { group in
            let platforms = group.platforms.intersection(Set(platformCompatibility ?? []))
            if group == .apple {
                let detail = "(" + platforms.map(\.rawValue).joined(separator: ", ") + ")"
                return "\(group.rawValue) \(detail)"
            } else {
                return group.rawValue
            }
        }.joined(separator: " and ")
    }
}

extension SwiftPackageIndexAPI.Package {
    static var example: Self {
        .init(repositoryOwner: "foo",
              repositoryName: "bar",
              repositoryOwnerName: "Foo",
              platformCompatibility: [.macOS, .linux],
              license: .mit,
              swiftVersionCompatibility: [.init(major: 5, minor: 8, patch: 0), .init(major: 5, minor: 7, patch: 0)],
              summary: "Foo bar test package",
              title: "Foo",
              url: "https://github.com/foo/bar.git")
    }
}
