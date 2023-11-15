//
//  TomorrowTheme.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/15.
//

import Runestone
import UIKit

private enum HighlightName: String {
    case comment
    case function
    case keyword
    case number
    case `operator`
    case property
    case punctuation
    case string
    case markup
    case variableBuiltin = "variable.builtin"
    case variable
    case identifier
    case constantBuiltin = "constant.builtin"
    case constantNumericInteger = "constant.numeric.integer"

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
        print(
            "Unrecognized highlight name: '\(rawHighlightName)'."
                + " Add the highlight name to HighlightName.swift if you want to add support for syntax highlighting it."
                + " This message will only be shown once per highlight name."
        )
        return nil
    }
}

public final class TomorrowTheme: Theme {
    public let backgroundColor = UIColor(named: "TomorrowBackground")!
    public let userInterfaceStyle: UIUserInterfaceStyle = .light

    public let font: UIFont = .monospacedSystemFont(ofSize: 14, weight: .regular)
    public let textColor = UIColor(named: "TomorrowForeground")!

    public let gutterBackgroundColor = UIColor(named: "TomorrowCurrentLine")!
    public let gutterHairlineColor = UIColor(named: "TomorrowComment")!

    public let lineNumberColor = UIColor(named: "TomorrowForeground")!.withAlphaComponent(0.5)
    public let lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 14, weight: .regular)

    public let selectedLineBackgroundColor = UIColor(named: "TomorrowCurrentLine")!
    public let selectedLinesLineNumberColor = UIColor(named: "TomorrowForeground")!
    public let selectedLinesGutterBackgroundColor: UIColor = .clear

    public let invisibleCharactersColor = UIColor(named: "TomorrowForeground")!.withAlphaComponent(0.7)

    public let pageGuideHairlineColor = UIColor(named: "TomorrowForeground")!
    public let pageGuideBackgroundColor = UIColor(named: "TomorrowCurrentLine")!

    public let markedTextBackgroundColor = UIColor(named: "TomorrowForeground")!.withAlphaComponent(0.1)
    public let markedTextBackgroundCornerRadius: CGFloat = 4

    public init() {}

    public func textColor(for rawHighlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(rawHighlightName) else {
            return nil
        }
        switch highlightName {
        case .comment:
            return UIColor(named: "TomorrowComment")!
        case .operator, .punctuation:
            return UIColor(named: "TomorrowForeground")!.withAlphaComponent(0.75)
        case .property:
            return UIColor(named: "TomorrowAqua")!
        case .function:
            return UIColor(named: "TomorrowBlue")!
        case .string:
            return UIColor(named: "TomorrowGreen")!
        case .number:
            return UIColor(named: "TomorrowOrange")!
        case .keyword:
            return UIColor(named: "TomorrowPurple")!
        case .variableBuiltin:
            return UIColor(named: "TomorrowRed")!
        case .markup:
            return UIColor(named: "TomorrowForeground")!
        case .variable:
            return UIColor(named: "TomorrowBlue")!.withAlphaComponent(0.85)
        case .identifier:
            return UIColor(named: "TomorrowPurple")!
        case .constantBuiltin:
            return UIColor(named: "TomorrowOrange")!.withAlphaComponent(0.75)
        case .constantNumericInteger:
            return UIColor(named: "TomorrowOrange")!.withAlphaComponent(0.75)
        }
    }

    public func fontTraits(for rawHighlightName: String) -> FontTraits {
        guard let highlightName = HighlightName(rawHighlightName), highlightName == .keyword else {
            return []
        }
        return .bold
    }
}
