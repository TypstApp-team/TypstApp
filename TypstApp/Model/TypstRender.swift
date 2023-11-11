//
//  TypstRender.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/9/13.
//

import Foundation
import PDFKit

var baseURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
}

var docsURL: URL {
    baseURL.appending(path: "docs")
}

extension TypstFile {
    func renderPDF() -> PDFDocument? {
        let fm = FileManager.default
        let dirURL = docsURL.appending(path: self.id.uuidString)
        let tmpDocsURL = dirURL.appendingPathComponent(
            self.title,
            conformingTo: .typstDocument
        )
        let tmpPDFURL = dirURL.appendingPathComponent(
            self.title,
            conformingTo: .pdf
        )

        try! fm.createDirectory(at: docsURL, withIntermediateDirectories: true)
        try! fm.createDirectory(at: dirURL, withIntermediateDirectories: true)

        fm.createFile(
            atPath: tmpDocsURL.path,
            contents: code.data(using: .utf8)
        )

        run("typst compile \(tmpDocsURL.path) \(tmpPDFURL.path)")
        let pdf = PDFDocument(url: tmpPDFURL)
        return pdf
    }
}
