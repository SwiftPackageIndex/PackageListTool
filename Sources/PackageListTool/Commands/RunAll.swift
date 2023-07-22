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


public struct RunAll: AsyncParsableCommand {
    @Option(name: .long)
    var apiBaseURL: String = "https://swiftpackageindex.com"

    @Option(name: .shortAndLong)
    var descriptionsDirectory: String = "./descriptions"

    @Option(name: .long)
    var githubApiToken: String

    @Option(name: .long)
    var openAIApiToken: String

    @Option(name: .shortAndLong)
    var output: String = "packages.yml"

    @Option(name: .shortAndLong, parsing: .upToNextOption)
    var packageIds: [PackageId]

    @Option(name: .long)
    var spiApiToken: String

    public func run() async throws {
        try await GenerateDescriptions.run(descriptionsDirectory: descriptionsDirectory,
                                           githubApiToken: githubApiToken,
                                           openAIApiToken: openAIApiToken,
                                           packageIds: packageIds)
        try await GeneratePackageYML.run(apiBaseURL: apiBaseURL,
                                         descriptionsDirectory: descriptionsDirectory,
                                         output: output,
                                         packageIds: packageIds,
                                         spiApiToken: spiApiToken)
    }

    public init() { }
}
