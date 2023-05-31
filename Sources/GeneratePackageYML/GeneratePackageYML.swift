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


public struct GeneratePackageYML: AsyncParsableCommand {
    @Option(name: .shortAndLong, parsing: .upToNextOption)
    var packageIDs: [PackageID]

    public func run() async throws {
        for packageID in packageIDs {
            let pkg = try await SPI.fetchPackage(owner: packageID.owner, repository: packageID.repository)
            //        let pkg = SPI.APIPackage.example
            //        dump(pkg)
            dump(SPI.Package(from: pkg))
        }
    }

    public init() { }
}


struct PackageID: ExpressibleByArgument {
    var owner: String
    var repository: String

    init?(argument: String) {
        let parts = argument.split(separator: "/").map(String.init)
        guard parts.count == 2 else { return nil }
        self.owner = parts[0]
        self.repository = parts[1]
    }
}
