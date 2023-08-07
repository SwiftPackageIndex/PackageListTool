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


struct SourcePackageLists: Codable {
    var categories: [Category]

    struct Category: Codable {
        var name: String
        var anchor: String
        var description: String
        var more: MoreLink? = nil
        var packages: [Package]

        struct MoreLink: Codable {
            var title: String
            var url: String
        }
    }

    struct Package: Codable {
        var identifier: String
        var reason: String? = nil

        var packageId: PackageId? {
            PackageId(argument: identifier)
        }
    }
}
