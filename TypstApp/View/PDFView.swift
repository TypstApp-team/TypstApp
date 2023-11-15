//
//  PDFView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import PDFKit
import SwiftUI

struct PDFKitReprentedView: UIViewRepresentable {
    @Binding var pdfShouldUpdate: Bool
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        PDFView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.document = PDFDocument(url: url)

    }
}
