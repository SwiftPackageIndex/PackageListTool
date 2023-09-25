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

#if !os(Linux)
import Prettier
import PrettierYAML
#endif

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
        let api = SwiftPackageIndexAPI(baseURL: apiBaseURL, apiToken: spiApiToken)
        let sourceYaml = try String(contentsOfFile: source, encoding: .utf8)
        let sourcePackageLists = try YAMLDecoder().decode(SourcePackageLists.self, from: sourceYaml)

        var packageIds = [PackageId]()
        for category in sourcePackageLists.categories {
            let ids = try await category.packageIds(api: api).compactMap(\.packageId)
            packageIds.append(contentsOf: ids)
        }
        try await GenerateDescriptions.run(descriptionsDirectory: descriptionsDirectory,
                                           githubApiToken: githubApiToken,
                                           openAIApiToken: openAIApiToken,
                                           packageIds: packageIds)
        try await generateOutputYaml(sourceCategories: sourcePackageLists.categories)
    }

    func generateOutputYaml(sourceCategories: [SourcePackageLists.Category]) async throws {
        let api = SwiftPackageIndexAPI(baseURL: apiBaseURL, apiToken: spiApiToken)
        var outputCategories = [SwiftOrgPackageLists.Category]()
        for sourceCategory in sourceCategories {
            print("Processing category: \(sourceCategory.name)...")

            var outputPackages = [SwiftOrgPackageLists.Package]()
            for sourcePackage in try await sourceCategory.packageIds(api: api) {
                guard let packageId = sourcePackage.packageId
                else {
                    print("Invalid package identifier \(sourcePackage.identifier). Skipping...")
                    continue
                }

                print("Fetching package: \(packageId)...")
                var apiPackage = try await api.fetchPackage(owner: packageId.owner, repository: packageId.repository)
                guard let summary = Self.getSummary(for: packageId, descriptionsDirectory: descriptionsDirectory) else {
                    throw Error.summaryNotFound(for: packageId)
                }
                apiPackage.summary = summary

                outputPackages.append(.init(from: apiPackage, note: sourcePackage.note))
            }

            outputCategories.append(.init(name: sourceCategory.name,
                                          slug: sourceCategory.slug,
                                          description: sourceCategory.description,
                                          more: .init(sourceCategory.more),
                                          packages: outputPackages)
            )
        }
        let content = try YAMLEncoder().encode(SwiftOrgPackageLists(categories: outputCategories))
        let reformatted = Self.reformatYMLToSwiftOrgStyle(content)
        try Data(reformatted.utf8).write(to: URL(filePath: output))
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

extension GeneratePackagesYML {
    static func reformatYMLToSwiftOrgStyle(_ yml: String) -> String {
        #if os(Linux)
        // Prettier isn't Linux compatible, because it uses JavaScriptCore
        return yml
        #else
        let formatter = PrettierFormatter(plugins: [YAMLPlugin()], parser: YAMLParser())
        formatter.printWidth = 120
        formatter.tabWidth = 2
        formatter.useTabs = false
        formatter.semicolons = false
        formatter.singleQuote = false
        formatter.quoteProperties = .asNeeded
        formatter.jsxSingleQuote = false
        formatter.trailingCommas = .es5
        formatter.bracketSpacing = true
        formatter.bracketSameLine = true
        formatter.arrowFunctionParentheses = .always
        formatter.proseWrap = .preserve
        formatter.htmlWhitespaceSensitivity = .css
        formatter.endOfLine = .lf
        formatter.prepare()
        switch formatter.format(yml) {
            case let .success(output):
                return output
            case let .failure(error):
                print("Reformatting failed: \(error)")
                return yml
        }
        #endif
    }
}
