//
//  TypstLang.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import Foundation
import LanguageSupport


private let typstReserverdIDs =
    [
        "none", "auto", "true", "false", "not", "and", "or", "let", "set", "show", "if", "else",
        "for", "in", "while", "break", "continue", "return", "import", "include", "as",
    ]

extension LanguageConfiguration {
    public static func typst(_ languageService: LanguageServiceBuilder? = nil) -> LanguageConfiguration {
        return LanguageConfiguration(name: "Typst",
                                     stringRegexp: "\"[^\"]*\"",
                                     characterRegexp: nil,
                                     numberRegexp: group(alternatives([
                                        decimalLit,
                                        decimalLit   + "\\." + decimalLit
                                     ])),
                                     singleLineComment: "//",
                                     nestedComment: (open: "/*", close: "*/"),
                                     identifierRegexp: alternatives([
                                        identifierHeadChar +
                                        group(alternatives([
                                            identifierHeadChar,
                                            identifierBodyChar,
                                        ])) + "*",
                                        "`" + identifierHeadChar +
                                        group(alternatives([
                                            identifierHeadChar,
                                            identifierBodyChar,
                                        ])) + "*`",
                                        "\\\\$" + decimalLit,
                                        "\\\\$" + identifierHeadChar +
                                        group(alternatives([
                                            identifierHeadChar,
                                            identifierBodyChar,
                                        ])) + "*"
                                     ]),
                                     reservedIdentifiers: typstReserverdIDs,
                                     languageService: languageService)
    }
}
