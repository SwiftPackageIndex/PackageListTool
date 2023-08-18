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

import XCTest

@testable import PackageListTool

import Yams

class API_APIPackageTests: XCTestCase {

    func test_groupedPlatformCompatibility() throws {
        var package = SwiftPackageIndexAPI.Package.example

        package.platformCompatibility = [.iOS, .macOS, .watchOS, .tvOS, .visionOS]
        XCTAssertEqual(package.groupedPlatformCompatibility, [.apple])

        package.platformCompatibility = [.iOS, .macOS, .watchOS, .tvOS, .visionOS, .linux]
        XCTAssertEqual(package.groupedPlatformCompatibility, [.apple, .linux])

        package.platformCompatibility = [.macOS, .linux]
        XCTAssertEqual(package.groupedPlatformCompatibility, [.apple, .linux])

        package.platformCompatibility = [.linux]
        XCTAssertEqual(package.groupedPlatformCompatibility, [.linux])
    }

    func test_platformCompatibilityTooltip() throws {
        var package = SwiftPackageIndexAPI.Package.example

        package.platformCompatibility = [.iOS, .macOS, .watchOS, .tvOS, .visionOS]
        XCTAssertEqual(package.platformCompatibilityTooltip, "Apple (iOS, macOS, visionOS, watchOS, tvOS)")

        package.platformCompatibility = [.iOS, .macOS, .watchOS, .tvOS, .visionOS, .linux]
        XCTAssertEqual(package.platformCompatibilityTooltip, "Apple (iOS, macOS, visionOS, watchOS, tvOS) and Linux")

        package.platformCompatibility = [.macOS, .linux]
        XCTAssertEqual(package.platformCompatibilityTooltip, "Apple (macOS) and Linux")

        package.platformCompatibility = [.linux]
        XCTAssertEqual(package.platformCompatibilityTooltip, "Linux")
    }

    func test_reformatYMLToSwiftOrgStyle() {
        #if !os(Linux)
        let yml = """
            categories:
            - description: The community showcase celebrates new and innovative packages discussed
                on recent community podcasts, blogs, and newsletters. If you would like to submit
                a package for inclusion here, please [message the Swift Website
              name: Community Showcase
            """
        let res = GeneratePackagesYML.reformatYMLToSwiftOrgStyle(yml)
        XCTAssertEqual(res, """
            categories:
              - description: The community showcase celebrates new and innovative packages discussed
                  on recent community podcasts, blogs, and newsletters. If you would like to submit
                  a package for inclusion here, please [message the Swift Website
                name: Community Showcase

            """)
        #endif
    }

    func test_Source_Codable() throws {
        do {
            let yml = """
                packages:
                - identifier: apple/swift-nio

                """
            let res = try YAMLDecoder().decode(SourcePackageLists.Category.Source.self, from: yml)
            XCTAssertEqual(res, .packages([SourcePackageLists.Package("apple/swift-nio")]))
            XCTAssertEqual(try YAMLEncoder().encode(res), yml)
        }
        do {
            let yml = """
                search:
                  query: some query
                  limit: 6
                
                """
            let res = try YAMLDecoder().decode(SourcePackageLists.Category.Source.self, from: yml)
            XCTAssertEqual(res, .search(.init(query: "some query", limit: 6)))
            XCTAssertEqual(try YAMLEncoder().encode(res), yml)
        }
    }

}
