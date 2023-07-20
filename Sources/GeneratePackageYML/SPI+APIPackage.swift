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


extension SPI {
    struct APIPackage: Codable {
        var activity: Activity
        var authors: AuthorMetadata
        var history: History
        var platformCompatibility: [PlatformCompatibility]
        var license: License
        var stars: Int
        var swiftVersionCompatibility: [SwiftVersion]
        var summary: String  // FIXME: use GPT
        var title: String
        var url: String
    }
}


extension SPI.APIPackage {
    var activityClause: String {
        let clause = "In development for \(relativeDate: history.createdAt)"
        if let latest = [activity.lastIssueClosedAt, activity.lastPullRequestClosedAt].compactMap({ $0 }).sorted().last {
            return clause + ", with activity as late as \(latest)."  // TODO: make relative date
        } else {
            return clause + "."
        }
    }

    var authorClause: String {
        switch authors {
            case let .fromGitRepository(authors):
                return "Written by \(authors.authors.map(\.name).joined(separator: ", ")) and \(authors.numberOfContributors) other contributors."  // TODO: pluralize
            case let .fromSPIManifest(string):
                return "Written by \(string)"
        }
    }
}


extension SPI.APIPackage {
    static var example: Self {
        .init(activity: .init(openIssuesCount: 12, openPullRequestsCount: 12, lastIssueClosedAt: .example, lastPullRequestClosedAt: .example),
              authors: .fromGitRepository(.init(authors: [.init(name: "Foo Bar")], numberOfContributors: 5)),
              history: .init(createdAt: .example,
                             commitCount: 433, commitCountURL: "https://github.com/foo/bar/commits/main",
                             releaseCount: 5, releaseCountURL: "https://github.com/foo/bar/releases"),
              platformCompatibility: [.macOS, .linux],
              license: .mit,
              stars: 1234,
              swiftVersionCompatibility: [.init(major: 5, minor: 8, patch: 0), .init(major: 5, minor: 7, patch: 0)],
              summary: "Foo bar test package",
              title: "Foo",
              url: "https://github.com/foo/bar.git")
    }
}
