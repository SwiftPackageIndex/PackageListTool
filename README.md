# GeneratePackageYML

Invoke as follows:

```
generate-package-yml -p apple/swift-argument-parser sindresorhus/settings \
  --api-token api-token \
  --api-base-url http:localhost:8080
```

Example output:

```
Fetching package: apple/swift-argument-parser...
OK
Fetching package: sindresorhus/settings...
OK
packages:
- name: swift-argument-parser
  description: Straightforward, type-safe argument parsing for Swift
  swiftCompatibility: 5.5+
  platformCompatibility:
  - linux
  - macos
  activity: In development for 3 years ago, with activity as late as 2023-05-19 18:03:39
    +0000.
  authors: Written by Nate Cook and 84 other contributors.
  license: Apache 2.0
  stars: '2974'
  url: https://github.com/apple/swift-argument-parser.git
- name: Settings
  description: "\u2699 Add a settings window to your macOS app in minutes"
  swiftCompatibility: 5.7+
  platformCompatibility:
  - macos
  activity: In development for 4 years ago, with activity as late as 2023-05-17 13:35:06
    +0000.
  authors: Written by Sindre Sorhus and 13 other contributors.
  license: MIT
  stars: '1272'
  url: https://github.com/sindresorhus/Settings.git
  ```