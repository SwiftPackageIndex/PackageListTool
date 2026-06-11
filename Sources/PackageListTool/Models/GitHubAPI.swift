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


enum GitHubAPI {
    enum Error: Swift.Error {
        case invalidURL
    }

    static func fetchReadme(packageID: PackageId, githubApiToken: String) async throws -> String {
        guard let url = URL(string: "https://api.github.com/repos/\(packageID)/readme")
        else { throw Error.invalidURL }

        // Fetch readme html content
        var request = URLRequest(url: url)
        request.addValue("SPI PackageListTool", forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer \(githubApiToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github.raw+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        assert((response as? HTTPURLResponse)?.statusCode == 200, "expected 200, received \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
        let readme = String(decoding: data, as: UTF8.self)

        return readme
    }
}
