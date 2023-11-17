//
//  TypstTile.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/16.
//

import Foundation

struct TypstTitle {
    var id = UUID()
    var depth: Int
    var content: String
}

extension [TypstTitle] {
    static func parseFrom(_ code: String) -> [TypstTitle] {
        // 1. split by \n
        // 2. remove leading and trailing spaces
        // 3. count "=" at the beginning -> depth
        // 4. remove "=" at the beginning -> content
        
        code
            .split(separator: "\n")
            .compactMap { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                let depth = trimmed.prefix(while: { $0 == "=" }).count
                let content = trimmed.drop(while: { $0 == "=" })
                if depth == 0 {
                    return nil
                }
                return TypstTitle(depth: depth, content: String(content))
            }
    }
}
