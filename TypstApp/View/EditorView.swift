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
import RxSwift

struct EditorView: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<EditorView>

    @Binding var document: TypstFile
    
    var url: URL {
        document.renderedPDFURL
    }

    func makeUIView(context: Context) -> UIStackView {
        let textView = TextView()
        let pdfView = PDFView()

        textView.showLineNumbers = true
        textView.lineSelectionDisplayType = .lineFragment
        textView.theme = BaseTheme()
        textView.backgroundColor = .systemBackground
        textView.editorDelegate = context.coordinator
        textView.setLanguageMode(TreeSitterLanguageMode.typst)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartQuotesType = .no
        textView.text = document.code
        textView.insertionPointColor = .accent

        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true

        let view = UIStackView(arrangedSubviews: [textView, pdfView])
        view.axis = .horizontal
        view.distribution = .fillEqually
        
        Task.detached {
//            document.watchPDF()
//            assert(true)
            
            repeat {
                document.renderPDF()
                try await Task.sleep(for: .seconds(2))
            } while(true)
        }

        return view
    }

    func updateUIView(_ view: UIStackView, context: Context) {
        let textView = (view.subviews.first as! TextView)
        let pdfView = (view.subviews.last as! PDFView)

        pdfView.document = PDFDocument(url: url)
        
        document.code = textView.text
        textView.becomeFirstResponder()
        textView.insertionPointColor = .red
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(document: $document)
    }

    class Coordinator: NSObject, TextViewDelegate {
        var document: Binding<TypstFile>

        init(document: Binding<TypstFile>) {
            self.document = document
        }
        
        func textViewDidChange(_ textView: TextView) {}
    }
}
