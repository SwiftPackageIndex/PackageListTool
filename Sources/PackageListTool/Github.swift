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


enum Github {
    enum Error: Swift.Error {
        case invalidURL
    }

    static func fetchReadme(packageID: PackageID, githubApiToken: String) async throws -> String {
        //        return mock

        guard let url = URL(string: "https://api.github.com/repos/\(packageID)/readme")
        else { throw Error.invalidURL }

        // Fetch readme html content
        var request = URLRequest(url: url)
        request.addValue("SPI PackageListTool", forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer \(githubApiToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github.raw+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        assert((response as? HTTPURLResponse)?.statusCode == 200)
        let readme = String(decoding: data, as: UTF8.self)

        return readme
    }

}


extension Github {
    static let mock = #"""
    ![The Swift Package Index](.readme-images/swift-package-index.png)

    **The Swift Package Index helps you make better decisions about the dependencies you use in your apps**.

    The [Swift Package Index](https://swiftpackageindex.com) is the place to find packages that are compatible with the [Swift Package Manager](https://swift.org/package-manager/). The project is [open-source](https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/blob/main/LICENSE) and written in Swift using [Vapor](https://swiftpackageindex.com/vapor/vapor).

    ## Code of Conduct

    All participation in this project, whether contributing code, communicating in discussions or issues, or pull requests, is subject to our code of conduct. Please read the [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

    ## Funding and Sponsorship

    The Swift Package Index is a community project that would not be possible without the support of its sponsors. Thank you to everyone who supports this project!

    ## Contributing

    There are many ways to contribute to the Swift Package Index. Whether it's helping to promote the site, suggesting or discussing a new feature, reporting a bug if you find one, through to helping with bug fixing, or the design/development of the software, we'd love to have you as a contributor.

    To keep our issues list under control, most bug reports or feature requests work best started as a [discussion in our forum](https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/discussions). From there, we can promote it into an issue and start work on a pull request. We have plenty of [open issues](https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues) if you'd like to get started. We've also tagged some with a [good first issue](https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) label.

    We also have a Discord server. If you'd like to join, please [use this invite](https://discord.gg/vQRb6KkYRw)!

    ### Running the Project Locally

    The best place to start is our in-depth guide to [setting up the Swift Package Index for local development](LOCAL_DEVELOPMENT_SETUP.md)! If you run into any problems, please [start a discussion](https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/discussions) or [join us on Discord](https://discord.gg/vQRb6KkYRw).

    ### Contributor License Agreements

    The Swift Package Index is [licensed under the Apache 2.0 license](LICENSE). Before we can accept your contributions, you'll need to sign a standard Apache 2.0 Contributor License Agreement. We will organise this during your first pull request.
    """#
}
