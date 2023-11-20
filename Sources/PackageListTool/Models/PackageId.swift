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

public struct PackageId: ExpressibleByArgument, Codable, CustomStringConvertible {
    var owner: String
    var repository: String

    init(owner: String, repository: String) {
        self.owner = owner
        self.repository = repository
    }

    public init?(argument: String) {
        let parts = argument.split(separator: "/").map(String.init)
        guard parts.count == 2 else { return nil }
        self.owner = parts[0]
        self.repository = parts[1]
    }

    public var description: String {
        "\(owner)/\(repository)"
    }

    var descriptionFilename: String {
        "\(owner)-\(repository)".lowercased() + ".txt"
    }
}
