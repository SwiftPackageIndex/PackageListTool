// swift-tools-version: 5.8

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

import PackageDescription

let package = Package(
    name: "PackageListTool",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "package-list-tool", targets: ["Executable"]),
        .library(name: "PackageListTool", targets: ["PackageListTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
        .package(url: "https://github.com/btfranklin/CleverBird.git", from: "3.1.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.5"),
        .package(url: "https://github.com/simonbs/Prettier", from: "0.2.1")
    ],
    targets: [
        .executableTarget(name: "Executable", dependencies: ["PackageListTool"]),
        .target(name: "PackageListTool", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "CleverBird", package: "CleverBird"),
            .product(name: "Collections", package: "swift-collections"),
            .product(name: "Prettier", package: "Prettier"),
            .product(name: "PrettierYAML", package: "Prettier"),
            .product(name: "Yams", package: "Yams"),
        ]),
        .testTarget(name: "PackageListToolTests",
                    dependencies: [
                        .target(name: "PackageListTool")
                    ])
    ]
)
