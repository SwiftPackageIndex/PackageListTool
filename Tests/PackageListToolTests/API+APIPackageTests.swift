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
}
