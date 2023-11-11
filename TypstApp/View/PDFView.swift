//
//  PDFView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import PDFKit
import SwiftUI

struct PDFView: UIViewRepresentable {
    typealias UIViewType = PDFKit.PDFView

    @Binding var document: PDFDocument
    let singlePage: Bool

    init(_ document: Binding<PDFDocument>, singlePage: Bool = false) {
        self._document = document
        self.singlePage = singlePage
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFView>)-> UIViewType {
        let pdfView = PDFKit.PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        pdfView.backgroundColor = .white
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFView>) {
        pdfView.document = document
    }
}
