//
//  TypstLang.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import Foundation
import SwiftyMonaco

extension SyntaxHighlight {
    static let typst = SyntaxHighlight(
        title: "Typst",
        fileURL: Bundle.main.url(forResource: "Typst", withExtension: "js")!
    )
}
