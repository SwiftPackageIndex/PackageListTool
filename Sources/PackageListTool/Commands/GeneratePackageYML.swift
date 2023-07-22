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

import ArgumentParser
import Yams


public struct GeneratePackageYML: AsyncParsableCommand {
    @Option(name: .long)
    var apiBaseURL: String = "https://swiftpackageindex.com"

    @Option(name: .long)
    var spiApiToken: String

    @Option(name: .shortAndLong, parsing: .upToNextOption)
    var packageIds: [PackageId]

    @Option(name: .shortAndLong)
    var descriptionsDirectory: String = "./descriptions"

    @Option(name: .shortAndLong)
    var output: String = "packages.yml"

    public func run() async throws {
        try await Self.run(apiBaseURL: apiBaseURL,
                           descriptionsDirectory: descriptionsDirectory,
                           output: output,
                           packageIds: packageIds,
                           spiApiToken: spiApiToken)
    }

    static func run(apiBaseURL: String, descriptionsDirectory: String, output: String, packageIds: [PackageId], spiApiToken: String) async throws {
        var packages = [API.YMLPackage]()
        for packageId in packageIds {
            print("Fetching package: \(packageId)...")
            var apiPackage = try await API(baseURL: apiBaseURL, apiToken: spiApiToken)
                .fetchPackage(owner: packageId.owner, repository: packageId.repository)
            guard let summary = getSummary(for: packageId, descriptionsDirectory: descriptionsDirectory) else {
                throw Error.summaryNotFound(for: packageId)
            }
            apiPackage.summary = summary
            let pkg = API.YMLPackage(from: apiPackage)
            packages.append(pkg)
        }
        let content = try YAMLEncoder().encode(PackageList(packages: packages))
        try Data(content.utf8).write(to: URL(filePath: output))
    }

    public init() { }

    enum Error: Swift.Error {
        case summaryNotFound(for: PackageId)
    }
}


extension GeneratePackageYML {
    static func getSummary(for packageID: PackageId, descriptionsDirectory: String) -> String? {
        let filepath = descriptionsDirectory + "/" + packageID.descriptionFilename
        return FileManager.default.contents(atPath: filepath).map { String(decoding: $0, as: UTF8.self) }
    }
}


struct PackageList: Codable {
    // Extend with additional properties as needed (and make configurable via CLI args or so)
    //   var name: String
    //   var anchor: String
    //   var description: String
    var packages: [API.YMLPackage]
}


struct PackageId: ExpressibleByArgument, CustomStringConvertible {
    var owner: String
    var repository: String

    init?(argument: String) {
        let parts = argument.split(separator: "/").map(String.init)
        guard parts.count == 2 else { return nil }
        self.owner = parts[0]
        self.repository = parts[1]
    }

    var description: String { "\(owner)/\(repository)" }

    var descriptionFilename: String { "\(owner)-\(repository)".lowercased() + ".txt" }
}
