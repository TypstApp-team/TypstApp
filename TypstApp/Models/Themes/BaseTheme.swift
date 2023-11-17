//
//  BaseTheme.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/15.
//

import Runestone
import UIKit
import SwiftUI

private enum HighlightName: String {
    
    case markup
    case markupRawInline = "markup.raw.inline"
    case markupRawBlock = "markup.raw.block"
    case markupLinkURL = "markup.link.url"
    case markupLabel = "markup.label"
    case markupBold = "markup.bold"
    case markupItalic = "markup.italic"
    case markupHeading = "markup.heading.marker"
    
    case string
    case stringEscape = "string.escape"
    
    case punctuation
    case punctuationDelimiter = "punctuation.delimiter"
    case equationSymbol = "punctuation.special"
    case bracket = "punctuation.bracket"
    
    case `operator`
    
    case function
    case functionMethod = "function.method"
    
    case variable
    case variableParameter = "variable.parameter"
    case variableOtherMember = "variable.other.member"
    
    case constant
    case constantNumeric = "constant.numeric"
    case constantNumericInteger = "constant.numeric.integer"
    case constantNumericFloat = "constant.numeric.float"
    case constantBuiltIn = "constant.builtin"
    
    case keyword
    case keywordControl = "keyword.control"
    case keywordShow = "keyword.control.show"
    case keywordConditional = "keyword.control.conditional"
    case keuwordRepeat = "keyword.control.repeat"
    case keywordWhile = "keyword.control.repeat.while"
    case keywordFor = "keyword.control.repeat.for"
    case keywordIn = "keyword.control.repeat.in"
    case keywordImport = "keyword.control.import"
    case keywordReturn = "keyword.control.return"
    case keywordStorage = "keyword.storage"
    
    case identifier
    
    case comment
    case commentInline = "comment.inline"
    case commentBlock = "comment.block"
    
    
    
    
    public init?(_ rawHighlightName: String) {
        var comps = rawHighlightName.split(separator: ".")
        while !comps.isEmpty {
            let candidateRawHighlightName = comps.joined(separator: ".")
            if let highlightName = Self(rawValue: candidateRawHighlightName) {
                self = highlightName
                return
            }
            comps.removeLast()
        }
        assert(false, "Unknown highlight name: \(rawHighlightName)")
        return nil
    }
}

final class BaseTheme: Theme {
    var font: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)
    var textColor: UIColor = .label
    
    var gutterBackgroundColor: UIColor = .label.withAlphaComponent(0.5)
    var gutterHairlineColor: UIColor = .white
    
    var lineNumberColor: UIColor = .systemBackground
    var lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 12, weight: .regular)
    
    var selectedLineBackgroundColor: UIColor = .cyan.withAlphaComponent(0.2)
    var selectedLinesLineNumberColor: UIColor = .white
    var selectedLinesGutterBackgroundColor: UIColor = .green.withAlphaComponent(0.2)
    
    var invisibleCharactersColor: UIColor = .label
    var pageGuideHairlineColor: UIColor = .lightGray
    var pageGuideBackgroundColor: UIColor = .lightGray
    var markedTextBackgroundColor: UIColor = .red
    
    func textColor(for rawHighlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(rawHighlightName) else {
            return nil
        }
        
        return UIColor(named: highlightName.rawValue)
    }
    
    func fontTraits(for rawHighlightName: String) -> FontTraits {
        guard let highlightName = HighlightName(rawHighlightName) else {
            return []
        }
        if highlightName == .markupBold {
            return .bold
        }
        if highlightName == .markupItalic {
            return .italic
        }
        if highlightName == .markupHeading {
            return [.bold, .italic]
        }
        if highlightName == .comment || highlightName == .commentInline || highlightName == .commentBlock {
            return .italic
        }
        return []
    }
}
