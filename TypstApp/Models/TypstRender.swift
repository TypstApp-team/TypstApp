//
//  TypstRender.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/9/13.
//

import Foundation
import PDFKit

var documentBaseURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
}

extension TypstFile {
    var renderedPDFURL: URL {
        // This is where the rendered PDF should be
        return
            documentBaseURL
            .appending(path: "tmp")
            .appending(path: self.id.uuidString)
            .appendingPathComponent(self.title, conformingTo: .pdf)
    }

    var tmpFileURL: URL {
        // This is where the rendered PDF should be
        return
            documentBaseURL
            .appending(path: "tmp")
            .appending(path: self.id.uuidString)
            .appendingPathComponent(self.title, conformingTo: .typ)
    }

    func renderPDF() {
        let fm = FileManager.default

        try! fm.createDirectory(at: tmpFileURL.deletingLastPathComponent(), withIntermediateDirectories: true)

        fm.createFile(
            atPath: tmpFileURL.path,
            contents: code.data(using: .utf8)
        )

        let tmpFilePath = tmpFileURL.path.replacing(" ", with: "\\ ")
        let tmpPDFPath = renderedPDFURL.path.replacing(" ", with: "\\ ")

        run("typst compile \(tmpFilePath) \(tmpPDFPath)")
    }
}
