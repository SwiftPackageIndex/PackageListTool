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
import CleverBird


public struct GenerateDescriptions: AsyncParsableCommand {
    @Option(name: .shortAndLong, parsing: .upToNextOption)
    var packageIDs: [PackageID]

    @Option(name: .long)
    var githubApiToken: String

    @Option(name: .long)
    var openAIApiToken: String

    public func run() async throws {
        let openAIAPIConnection = OpenAIAPIConnection(apiKey: openAIApiToken)

        for packageID in packageIDs {
            print("Generating description: \(packageID)")

            let readme = try await Github.fetchReadme(packageID: packageID, githubApiToken: githubApiToken)
            print("Readme length:", readme.count)
            print("Message length:", readme.trimmedToMaxMessage.count)

            let chatThread = ChatThread(connection: openAIAPIConnection,
                                        model: .gpt35Turbo)
                .addSystemMessage(Self.systemPrompt)
                .addUserMessage(readme.trimmedToMaxMessage)
            let result = try await chatThread.complete()
            print("Result:", result.content ?? "none")
        }
    }


    public init() { }
}


extension GenerateDescriptions {
    static var systemPrompt: String {
        """
        README_FILE describes a software library. Summarise README_FILE in one paragraph with no more than 40 words. Establish the library’s purpose but do not begin the paragraph with “The purpose of” or “Summary:”. Do not include details of installation or compatibility. Do not include license information. Don’t include code listings. Your response must not include any of these words: iOS, macOS, tvOS, watchOS, Linux, CocoaPods, Carthage, Swift Package Manager, SPM.`
        """
    }
}


private extension String {
    var trimmedToMaxMessage: Self {
        return String(prefix(OpenAI.maxMessageLength))
    }
}


enum OpenAI {
    static let maxTokens = 4097.0
    static let charactersPerToken = 2.4
    static let completionMaxLength = 256.0
    static var maxMessageLength: Int { Int(maxTokens * charactersPerToken - completionMaxLength) }
}
