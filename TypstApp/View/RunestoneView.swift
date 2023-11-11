//
//  RunestoneView.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/11.
//

import Foundation
import UIKit
import SwiftUI
import Runestone

struct RunestoneView: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<RunestoneView>
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> TextView {
        let textView = TextView()
        textView.showLineNumbers = true
        textView.lineSelectionDisplayType = .lineFragment
        textView.showPageGuide = true
        textView.pageGuideColumn = 80
        textView.showTabs = true
        textView.showSpaces = true
//        textView.showLineBreaks = true
//        textView.showSoftLineBreaks = true
        textView.editorDelegate = context.coordinator
        textView.setLanguageMode(TreeSitterLanguageMode(language: .typst))
        textView.theme = TomorrowTheme()
        return textView
    }
    
    func updateUIView(_ textView: TextView, context: Context) {
        if !context.coordinator.isEditing {
            textView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, TextViewDelegate {
        var text: Binding<String>
        var isEditing: Bool = false
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: TextView) {
            self.text.wrappedValue = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: TextView) {
            self.isEditing = true
        }
        
        func textViewDidEndEditing(_ textView: TextView) {
            self.isEditing = false
        }
    }
}
