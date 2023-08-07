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


public struct GeneratePackagesYML: AsyncParsableCommand {
    @Option(name: .long)
    var apiBaseURL: String = "https://swiftpackageindex.com"

    @Option(name: .shortAndLong)
    var descriptionsDirectory: String = "./descriptions"

    @Option(name: .long)
    var githubApiToken: String

    @Option(name: .long)
    var openAIApiToken: String

    @Option(name: .shortAndLong)
    var source: String = "source.yml"

    @Option(name: .shortAndLong)
    var output: String = "packages.yml"

    @Option(name: .long)
    var spiApiToken: String

    public func run() async throws {
        let sourceYaml = try String(contentsOfFile: source, encoding: .utf8)
        let sourcePackageLists = try YAMLDecoder().decode(SourcePackageLists.self, from: sourceYaml)

        let packageIds = sourcePackageLists.categories.flatMap { category in
            category.packages.compactMap { $0.packageId }
        }
        try await GenerateDescriptions.run(descriptionsDirectory: descriptionsDirectory,
                                           githubApiToken: githubApiToken,
                                           openAIApiToken: openAIApiToken,
                                           packageIds: packageIds)
        try await generateOutputYaml(sourceCategories: sourcePackageLists.categories)
    }

    func generateOutputYaml(sourceCategories: [SourcePackageLists.Category]) async throws {
        var outputCategories = [SwiftOrgPackageLists.Category]()
        for sourceCategory in sourceCategories {
            print("Processing category: \(sourceCategory.name)...")

            var outputPackages = [SwiftOrgPackageLists.Package]()
            for sourcePackage in sourceCategory.packages {
                guard let packageId = sourcePackage.packageId
                else {
                    print("Invalid package identifier \(sourcePackage.identifier). Skipping...")
                    continue
                }

                print("Fetching package: \(packageId)...")
                var apiPackage = try await SwiftPackageIndexAPI(baseURL: apiBaseURL, apiToken: spiApiToken)
                    .fetchPackage(owner: packageId.owner, repository: packageId.repository)
                guard let summary = Self.getSummary(for: packageId, descriptionsDirectory: descriptionsDirectory) else {
                    throw Error.summaryNotFound(for: packageId)
                }
                apiPackage.summary = summary
                outputPackages.append(.init(from: apiPackage))
            }

            outputCategories.append(.init(name: sourceCategory.name,
                                          anchor: sourceCategory.anchor,
                                          description: sourceCategory.description,
                                          more: .init(sourceCategory.more),
                                          packages: outputPackages)
            )
        }
        let content = try YAMLEncoder().encode(SwiftOrgPackageLists(categories: outputCategories))
        try Data(content.utf8).write(to: URL(filePath: output))
    }

    enum Error: Swift.Error {
        case summaryNotFound(for: PackageId)
    }

    public init() { }
}

extension GeneratePackagesYML {
    static func getSummary(for packageID: PackageId, descriptionsDirectory: String) -> String? {
        let filepath = descriptionsDirectory + "/" + packageID.descriptionFilename
        let description = FileManager.default.contents(atPath: filepath).map { String(decoding: $0, as: UTF8.self) }
        guard let description else { return nil }
        return description.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
