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


// These extension are pretty much 1:1 from SwiftPackageIndex-Server.

extension NumberFormatter {
    static var spiDefault: NumberFormatter = {
        let f = NumberFormatter()
        f.thousandSeparator = ","
        f.numberStyle = .decimal
        return f
    }()

    func string(from value: Int) -> String? {
        string(from: NSNumber(value: value))
    }
}


// Pluralisation
extension DefaultStringInterpolation {
    static func pluralize(_ count: Int, singular: String, plural: String? = nil, capitalized: Bool = false, numberFormatter: NumberFormatter = .spiDefault) -> String {
        let plural = plural ?? singular + "s"
        switch count {
            case 0:
                return capitalized ? "No \(plural)" : "no \(plural)"
            case 1:
                return "1 \(singular)"
            default:
                return "\(numberFormatter.string(from: count) ?? "\(count)") \(plural)"
        }
    }

    mutating func appendInterpolation(pluralizedCount: Int, singular: String, plural: String? = nil, capitalized: Bool = false, numberFormatter: NumberFormatter = .spiDefault) {
        appendInterpolation(Self.pluralize(pluralizedCount, singular: singular, plural: plural, capitalized: capitalized, numberFormatter: numberFormatter))
    }
}


// Relative date formatting
extension DefaultStringInterpolation {
    mutating func appendInterpolation(relativeDate date: Date, to referenceDate: Date = .now) {
        appendInterpolation(Self.localizedString(for: date, relativeTo: referenceDate))
    }

    mutating func appendingInterpolation(since date: Date) {
        appendInterpolation(inWords: Date.now.timeIntervalSince(date))
    }

    mutating func appendInterpolation(inWords timeDifference: TimeInterval) {
        appendInterpolation(Self.distancePhrase(timeDifference))
    }

    static func localizedString(for date: Date, relativeTo reference: Date) -> String {
        let delta = date.timeIntervalSince(reference)
        let phrase = Self.distancePhrase(delta)
        return delta >= 0 ? "in \(phrase)" : "\(phrase) ago"
    }

    // Based on: https://apidock.com/rails/ActionView/Helpers/DateHelper/distance_of_time_in_words
    static func distancePhrase(_ delta: TimeInterval) -> String {
        let m = 60
        let H = 60*m
        let d = 24*H
        let M = 30*d   // crude...
        let Y = 365*d  // ignore leap years
        let seconds = Int(round(abs(delta)))
        let minutes = seconds/m
        let hours = seconds/H
        let days = seconds/d
        let months = seconds/M
        let years = seconds/Y
        switch seconds {
            case 0:
                return "0 seconds"
            case 0 ..< 30:
                return "less than a minute"
            case 30 ..< m + 30:
                return "1 minute"
            case m + 30 ..< 44*m + 30:
                return Self.pluralize(minutes, singular: "minute")
            case 44*m + 30 ..< 89*m + 30:
                return "1 hour"
            case 89*m + 30 ..< 24*H - 30:
                return Self.pluralize(hours, singular: "hour")
            case 24*H - 30 ..< 42*H - 30:
                return "1 day"
            case 42*H - 30 ..< 30*d - 30:
                return Self.pluralize(days, singular: "day")
            case 30*d - 30 ..< 45*d - 30:
                return "about 1 month"
            case 45*d - 30 ..< 60*d - 30:
                return "about 2 months"
            case 60*d - 30 ..< Y - 1:
                return Self.pluralize(months, singular: "month")
            case Y ..< Y + 3*M:
                return "about 1 year"
            case Y + 3*M ..< Y + 9*M:
                return "over 1 year"
            case Y + 9*M ..< 2*Y - 1:
                return "almost 2 years"
            default:
                return Self.pluralize(years, singular: "year")
        }
    }

    mutating func appendInterpolation(kiloPostfixedQuantity value: Int) {
        if abs(value) < 1000 {
            appendInterpolation(NumberFormatter.spiDefault.string(from: value))
        } else {
            let thousands = (abs(value) + 50) / 1000
            let remainder = (abs(value) + 50) % 1000
            let fraction = remainder / 100
            let sign = value < 0 ? "-" : ""
            appendInterpolation("\(sign)\(thousands).\(fraction)k")
        }
    }
}


extension Date {
    static var iso8601Formatter: ISO8601DateFormatter { ISO8601DateFormatter() }

    public static var example: Self { iso8601Formatter.date(from: "2020-03-20T10:08:54Z")! }
}
