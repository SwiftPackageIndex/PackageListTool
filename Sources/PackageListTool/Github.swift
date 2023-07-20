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
        request.addValue("application/vnd.github.html+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        assert((response as? HTTPURLResponse)?.statusCode == 200)
        let readme = String(decoding: data, as: UTF8.self)

        return readme
    }

}


extension Github {
    static let mock = #"""
    <div id="readme" class="md" data-path="README.md"><article class="markdown-body entry-content container-lg" itemprop="text"><h1 dir="auto"><a id="user-content-swift-argument-parser" class="anchor" aria-hidden="true" href="#swift-argument-parser"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Swift Argument Parser</h1>
    <h2 dir="auto"><a id="user-content-usage" class="anchor" aria-hidden="true" href="#usage"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Usage</h2>
    <p dir="auto">Begin by declaring a type that defines the information
    that you need to collect from the command line.
    Decorate each stored property with one of <code>ArgumentParser</code>'s property wrappers,
    and then declare conformance to <code>ParsableCommand</code> and add the <code>@main</code> attribute.
    Finally, implement your command's logic in the <code>run()</code> method.</p>
    <div class="highlight highlight-source-swift notranslate position-relative overflow-auto" dir="auto" data-snippet-clipboard-copy-content="import ArgumentParser

    @main
    struct Repeat: ParsableCommand {
        @Flag(help: &quot;Include a counter with each repetition.&quot;)
        var includeCounter = false

        @Option(name: .shortAndLong, help: &quot;The number of times to repeat 'phrase'.&quot;)
        var count: Int? = nil

        @Argument(help: &quot;The phrase to repeat.&quot;)
        var phrase: String

        mutating func run() throws {
            let repeatCount = count ?? 2

            for i in 1...repeatCount {
                if includeCounter {
                    print(&quot;\(i): \(phrase)&quot;)
                } else {
                    print(phrase)
                }
            }
        }
    }"><pre><span class="pl-k">import</span> <span class="pl-en">ArgumentParser</span>

    <span class="pl-k">@main</span>
    <span class="pl-k">struct</span> <span class="pl-en">Repeat</span>: <span class="pl-e">ParsableCommand </span>{
        <span class="pl-k">@Flag</span>(help<span class="pl-k">:</span> <span class="pl-s"><span class="pl-pds">"</span>Include a counter with each repetition.<span class="pl-pds">"</span></span>)
        <span class="pl-k">var</span> includeCounter <span class="pl-k">=</span> <span class="pl-c1">false</span>

        <span class="pl-k">@Option</span>(name<span class="pl-k">:</span> .<span class="pl-smi">shortAndLong</span>, help<span class="pl-k">:</span> <span class="pl-s"><span class="pl-pds">"</span>The number of times to repeat 'phrase'.<span class="pl-pds">"</span></span>)
        <span class="pl-k">var</span> count: <span class="pl-c1">Int</span><span class="pl-k">?</span> <span class="pl-k">=</span> <span class="pl-c1">nil</span>

        <span class="pl-k">@Argument</span>(help<span class="pl-k">:</span> <span class="pl-s"><span class="pl-pds">"</span>The phrase to repeat.<span class="pl-pds">"</span></span>)
        <span class="pl-k">var</span> phrase: <span class="pl-c1">String</span>

        <span class="pl-k">mutating</span> <span class="pl-k">func</span> <span class="pl-en">run</span>() <span class="pl-k">throws</span> {
            <span class="pl-k">let</span> repeatCount <span class="pl-k">=</span> count <span class="pl-k">??</span> <span class="pl-c1">2</span>

            <span class="pl-k">for</span> i <span class="pl-k">in</span> <span class="pl-c1">1</span><span class="pl-k">...</span><span class="pl-smi">repeatCount</span> {
                <span class="pl-k">if</span> includeCounter {
                    <span class="pl-c1">print</span>(<span class="pl-s"><span class="pl-pds">"</span><span class="pl-pse">\(</span><span class="pl-s1">i</span><span class="pl-pse"><span class="pl-s1">)</span></span>: <span class="pl-pse">\(</span><span class="pl-s1">phrase</span><span class="pl-pse"><span class="pl-s1">)</span></span><span class="pl-pds">"</span></span>)
                } <span class="pl-k">else</span> {
                    <span class="pl-c1">print</span>(phrase)
                }
            }
        }
    }</pre></div>
    <p dir="auto">The <code>ArgumentParser</code> library parses the command-line arguments,
    instantiates your command type, and then either executes your <code>run()</code> method
    or exits with a useful message.</p>
    <p dir="auto"><code>ArgumentParser</code> uses your properties' names and type information,
    along with the details you provide using property wrappers,
    to supply useful error messages and detailed help:</p>
    <div class="snippet-clipboard-content notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="$ repeat hello --count 3
    hello
    hello
    hello
    $ repeat --count 3
    Error: Missing expected argument 'phrase'.
    Help:  &lt;phrase&gt;  The phrase to repeat.
    Usage: repeat [--count &lt;count&gt;] [--include-counter] &lt;phrase&gt;
      See 'repeat --help' for more information.
    $ repeat --help
    USAGE: repeat [--count &lt;count&gt;] [--include-counter] &lt;phrase&gt;

    ARGUMENTS:
      &lt;phrase&gt;                The phrase to repeat.

    OPTIONS:
      --include-counter       Include a counter with each repetition.
      -c, --count &lt;count&gt;     The number of times to repeat 'phrase'.
      -h, --help              Show help for this command."><pre class="notranslate"><code>$ repeat hello --count 3
    hello
    hello
    hello
    $ repeat --count 3
    Error: Missing expected argument 'phrase'.
    Help:  &lt;phrase&gt;  The phrase to repeat.
    Usage: repeat [--count &lt;count&gt;] [--include-counter] &lt;phrase&gt;
      See 'repeat --help' for more information.
    $ repeat --help
    USAGE: repeat [--count &lt;count&gt;] [--include-counter] &lt;phrase&gt;

    ARGUMENTS:
      &lt;phrase&gt;                The phrase to repeat.

    OPTIONS:
      --include-counter       Include a counter with each repetition.
      -c, --count &lt;count&gt;     The number of times to repeat 'phrase'.
      -h, --help              Show help for this command.
    </code></pre></div>
    <h2 dir="auto"><a id="user-content-documentation" class="anchor" aria-hidden="true" href="#documentation"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Documentation</h2>
    <p dir="auto">For guides, articles, and API documentation see the
    <a href="https://swiftpackageindex.com/apple/swift-argument-parser/documentation/argumentparser" rel="nofollow">library's documentation on the Web</a> or in Xcode.</p>
    <ul dir="auto">
    <li><a href="https://swiftpackageindex.com/apple/swift-argument-parser/documentation/argumentparser" rel="nofollow">ArgumentParser documentation</a></li>
    <li><a href="https://swiftpackageindex.com/apple/swift-argument-parser/documentation/argumentparser/gettingstarted" rel="nofollow">Getting Started with ArgumentParser</a></li>
    <li><a href="https://swiftpackageindex.com/apple/swift-argument-parser/documentation/argumentparser/parsablecommand" rel="nofollow"><code>ParsableCommand</code> documentation</a></li>
    </ul>
    <h4 dir="auto"><a id="user-content-examples" class="anchor" aria-hidden="true" href="#examples"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Examples</h4>
    <p dir="auto">This repository includes a few examples of using the library:</p>
    <ul dir="auto">
    <li><a href="Examples/repeat/Repeat.swift"><code>repeat</code></a> is the example shown above.</li>
    <li><a href="Examples/roll/main.swift"><code>roll</code></a> is a simple utility implemented as a straight-line script.</li>
    <li><a href="Examples/math/Math.swift"><code>math</code></a> is an annotated example of using nested commands and subcommands.</li>
    <li><a href="Examples/count-lines/CountLines.swift"><code>count-lines</code></a> uses <code>async</code>/<code>await</code> code in its implementation.</li>
    </ul>
    <p dir="auto">You can also see examples of <code>ArgumentParser</code> adoption among Swift project tools:</p>
    <ul dir="auto">
    <li><a href="https://github.com/apple/swift-format/"><code>swift-format</code></a> uses some advanced features, like custom option values and hidden flags.</li>
    <li><a href="https://github.com/apple/swift-package-manager/"><code>swift-package-manager</code></a> includes a deep command hierarchy and extensive use of option groups.</li>
    </ul>
    <h2 dir="auto"><a id="user-content-project-status" class="anchor" aria-hidden="true" href="#project-status"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Project Status</h2>
    <p dir="auto">The Swift Argument Parser package is source-stable;
    version numbers follow semantic versioning.
    Source-breaking changes to public API can only land in a new major version.</p>
    <p dir="auto">The public API of version 1.0.0 of the <code>swift-argument-parser</code> package
    consists of non-underscored declarations that are marked public in the <code>ArgumentParser</code> module.
    Interfaces that aren't part of the public API may continue to change in any release,
    including the exact wording and formatting of the autogenerated help and error messages,
    as well as the package’s examples, tests, utilities, and documentation.</p>
    <p dir="auto">Future minor versions of the package may introduce changes to these rules as needed.</p>
    <p dir="auto">We want this package to quickly embrace Swift language and toolchain improvements that are relevant to its mandate.
    Accordingly, from time to time,
    we expect that new versions of this package will require clients to upgrade to a more recent Swift toolchain release.
    Requiring a new Swift release will only require a minor version bump.</p>
    <h2 dir="auto"><a id="user-content-adding-argumentparser-as-a-dependency" class="anchor" aria-hidden="true" href="#adding-argumentparser-as-a-dependency"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Adding <code>ArgumentParser</code> as a Dependency</h2>
    <p dir="auto">To use the <code>ArgumentParser</code> library in a SwiftPM project,
    add it to the dependencies for your package and your command-line executable target:</p>
    <div class="highlight highlight-source-swift notranslate position-relative overflow-auto" dir="auto" data-snippet-clipboard-copy-content="let package = Package(
        // name, platforms, products, etc.
        dependencies: [
            // other dependencies
            .package(url: &quot;https://github.com/apple/swift-argument-parser&quot;, from: &quot;1.2.0&quot;),
        ],
        targets: [
            .executableTarget(name: &quot;&lt;command-line-tool&gt;&quot;, dependencies: [
                // other dependencies
                .product(name: &quot;ArgumentParser&quot;, package: &quot;swift-argument-parser&quot;),
            ]),
            // other targets
        ]
    )"><pre><span class="pl-k">let</span> package <span class="pl-k">=</span> <span class="pl-c1">Package</span>(
        <span class="pl-c"><span class="pl-c">//</span> name, platforms, products, etc.</span>
    <span class="pl-c"></span>    <span class="pl-c1">dependencies</span>: [
            <span class="pl-c"><span class="pl-c">//</span> other dependencies</span>
    <span class="pl-c"></span>        .<span class="pl-c1">package</span>(<span class="pl-c1">url</span>: <span class="pl-s"><span class="pl-pds">"</span>https://github.com/apple/swift-argument-parser<span class="pl-pds">"</span></span>, <span class="pl-c1">from</span>: <span class="pl-s"><span class="pl-pds">"</span>1.2.0<span class="pl-pds">"</span></span>),
        ],
        <span class="pl-c1">targets</span>: [
            .<span class="pl-c1">executableTarget</span>(<span class="pl-c1">name</span>: <span class="pl-s"><span class="pl-pds">"</span>&lt;command-line-tool&gt;<span class="pl-pds">"</span></span>, <span class="pl-c1">dependencies</span>: [
                <span class="pl-c"><span class="pl-c">//</span> other dependencies</span>
    <span class="pl-c"></span>            .<span class="pl-c1">product</span>(<span class="pl-c1">name</span>: <span class="pl-s"><span class="pl-pds">"</span>ArgumentParser<span class="pl-pds">"</span></span>, <span class="pl-c1">package</span>: <span class="pl-s"><span class="pl-pds">"</span>swift-argument-parser<span class="pl-pds">"</span></span>),
            ]),
            <span class="pl-c"><span class="pl-c">//</span> other targets</span>
    <span class="pl-c"></span>    ]
    )</pre></div>
    <h3 dir="auto"><a id="user-content-supported-versions" class="anchor" aria-hidden="true" href="#supported-versions"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>Supported Versions</h3>
    <p dir="auto">The most recent versions of swift-argument-parser support Swift 5.5 and newer. The minimum Swift version supported by swift-argument-parser releases are detailed below:</p>
    <table>
    <thead>
    <tr>
    <th>swift-argument-parser</th>
    <th>Minimum Swift Version</th>
    </tr>
    </thead>
    <tbody>
    <tr>
    <td><code>0.0.1 ..&lt; 0.2.0</code></td>
    <td>5.1</td>
    </tr>
    <tr>
    <td><code>0.2.0 ..&lt; 1.1.0</code></td>
    <td>5.2</td>
    </tr>
    <tr>
    <td><code>1.1.0 ...</code></td>
    <td>5.5</td>
    </tr>
    </tbody>
    </table>
    </article></div>

    """#
}
