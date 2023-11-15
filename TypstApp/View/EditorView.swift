//
//  EditorView.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/15.
//

import PDFKit
import Runestone
import SwiftUI
import UIKit

struct EditorView: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<EditorView>

    @Binding var document: TypstFile

    var text: Binding<String> {
        _document.code
    }

    var url: URL {
        document.renderedPDFURL
    }

    @State var _run_once: Bool = false

    var run_once: Bool {
        guard _run_once else {
            _run_once = true
            return true
        }
        return false
    }

    func makeUIView(context: Context) -> UIStackView {
        let textView = TextView()
        let pdfView = PDFView()

        textView.showLineNumbers = true
        textView.lineSelectionDisplayType = .lineFragment
        textView.theme = TomorrowTheme()
        textView.editorDelegate = context.coordinator
        textView.setLanguageMode(TreeSitterLanguageMode.typst)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none

        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true

        let view = UIStackView(arrangedSubviews: [textView, pdfView])
        view.axis = .horizontal
        view.distribution = .fillEqually

        return view
    }

    func updateUIView(_ view: UIStackView, context: Context) {
        if run_once {
            // fill the text when first load
            (view.subviews.first as! TextView).text = text.wrappedValue
        }
        document.renderPDF()
        (view.subviews.last as! PDFView).document = PDFDocument(url: url)

        view.subviews.first?.becomeFirstResponder()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: text)
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
