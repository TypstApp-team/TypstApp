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
        textView.smartQuotesType = .no
        textView.text = document.code

        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true

        let view = UIStackView(arrangedSubviews: [textView, pdfView])
        view.axis = .horizontal
        view.distribution = .fillEqually

        return view
    }

    func updateUIView(_ view: UIStackView, context: Context) {
        document.renderPDF()
        (view.subviews.last as! PDFView).document = PDFDocument(url: url)
        view.subviews.first?.becomeFirstResponder()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(document: $document)
    }

    class Coordinator: NSObject, TextViewDelegate {
        var document: Binding<TypstFile>

        init(document: Binding<TypstFile>) {
            self.document = document
        }
        
        func textViewDidChange(_ textView: TextView) {
            DispatchQueue.main.async {
                self.document.wrappedValue.code = textView.text
            }
        }
        
        func textViewDidEndEditing(_ textView: TextView) {
            Task.detached {
                self.document.wrappedValue.renderPDF()
            }
        }
    }
}
