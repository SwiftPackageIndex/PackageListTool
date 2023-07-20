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

import ArgumentParser
import Yams


public struct GeneratePackageYML: AsyncParsableCommand {
    @Option(name: .long)
    var apiBaseURL: String = "https://swiftpackageindex.com"

    @Option(name: .long)
    var apiToken: String

    @Option(name: .shortAndLong, parsing: .upToNextOption)
    var packageIDs: [PackageID]

    public func run() async throws {
        var packages = [API.YMLPackage]()
        for packageID in packageIDs {
            print("Fetching package: \(packageID)...")
            let apiPackage = try await API(baseURL: apiBaseURL, apiToken: apiToken)
                .fetchPackage(owner: packageID.owner, repository: packageID.repository)
            print("OK")
            let pkg = API.YMLPackage(from: apiPackage)
            packages.append(pkg)
        }
        print(try YAMLEncoder().encode(PackageList(packages: packages)))
    }

    public init() { }
}


struct PackageList: Codable {
    // Extend with additional properties as needed (and make configurable via CLI args or so)
    //   var name: String
    //   var anchor: String
    //   var description: String
    var packages: [API.YMLPackage]
}


struct PackageID: ExpressibleByArgument, CustomStringConvertible {
    var owner: String
    var repository: String

    init?(argument: String) {
        let parts = argument.split(separator: "/").map(String.init)
        guard parts.count == 2 else { return nil }
        self.owner = parts[0]
        self.repository = parts[1]
    }

    var description: String { "\(owner)/\(repository)" }
}
