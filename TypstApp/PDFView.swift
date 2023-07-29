//
//  PDFView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import SwiftUI
import PDFKit

struct PDFView: UIViewRepresentable {
    typealias UIViewType = PDFKit.PDFView

    let document: PDFDocument
    let singlePage: Bool

    init(_ document: PDFDocument, singlePage: Bool = false) {
        self.document = document
        self.singlePage = singlePage
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFView>) -> UIViewType {
        let pdfView = PDFKit.PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFView>) {
        pdfView.document = document
    }
}
