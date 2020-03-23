//
//  FoundationExtensions.swift
//  TVTrivia
//
//  Created by Eric Ziegler on 3/23/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

extension String {

    func replacingEscapeCharacters() -> String {
        var result = self
        result = result.replacingOccurrences(of: "&shy;", with: "-")
        result = result.replacingOccurrences(of: "&quot;", with: "\"")
        result = result.replacingOccurrences(of: "&#039;", with: "'")
        result = result.replacingOccurrences(of: "&#034;", with: "\"")
        result = result.replacingOccurrences(of: "&Agrave;", with: "À")
        result = result.replacingOccurrences(of: "", with: "&;")
        result = result.replacingOccurrences(of: "", with: "&;")
        result = result.replacingOccurrences(of: "", with: "&;")
        result = result.replacingOccurrences(of: "", with: "&;")
        result = result.replacingOccurrences(of: "", with: "&;")
        result = result.replacingOccurrences(of: "", with: "&;")
        result = result.replacingOccurrences(of: "", with: "&;")
        return result
    }

}
