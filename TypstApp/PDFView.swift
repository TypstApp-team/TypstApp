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

    let data: Data
    let singlePage: Bool

    init(_ data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFView>) -> UIViewType {
        let pdfView = PDFKit.PDFView()
        pdfView.document = PDFKit.PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFView>) {
        pdfView.document = PDFKit.PDFDocument(data: data)
    }
}
