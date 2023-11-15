//
//  TypstLang.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import Foundation
import Runestone
import UIKit

extension TreeSitterLanguage {
    static let typst = TreeSitterLanguage(
        tree_sitter_typst()!,
        highlightsQuery: .init(
            contentsOf: Bundle.main.url(forResource: "highlights", withExtension: "scm")!
        ),
        injectionsQuery: .init(
            contentsOf: Bundle.main.url(forResource: "injections", withExtension: "scm")!
        )
    )
}

extension TreeSitterLanguageMode {
    static let typst = TreeSitterLanguageMode(language: .typst)
}
