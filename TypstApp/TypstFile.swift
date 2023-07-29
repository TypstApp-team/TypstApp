//
//  TypstFile.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

extension UTType {
    static let typstDocument = UTType("app.typst.typ")!
}

struct TypstFile: FileDocument {
    static var readableContentTypes: [UTType] = [.typstDocument]
    static var writableContentTypes: [UTType] = [.typstDocument, .pdf, .png]

    var code: String = ""
    var title: String = ""

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let code = String(data: data, encoding: .utf8) else{
            throw BaseError.runtimeError("data corrupted")
        }

        self.code = code
        self.title = configuration.file.filename ?? "Untitled.typs"
    }

    init() {
        self.code = "= Example Document"
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = code.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
    func snapshot(contentType: UTType) throws -> String {
        code
    }

    func fileWrapper(snapshot: String, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = code.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

extension TypstFile {
    func renderPDF() -> PDFDocument? {
        let fm = FileManager.default
        let fileName = UUID().uuidString
        let baseURL = fm.urls(for: .documentDirectory, in: .allDomainsMask)[0]
        let tmpDocumentURL = baseURL.appendingPathComponent(fileName, conformingTo: .typstDocument)
        let tmpPDFURL = baseURL.appendingPathComponent(fileName, conformingTo: .pdf)

        fm.createFile(atPath: tmpDocumentURL.path, contents: code.data(using: .utf8))
        debugPrint(try! String(contentsOf: tmpDocumentURL))
        run("typst compile \(tmpDocumentURL.path)")
        let pdf = PDFDocument(url: tmpPDFURL)
        try! fm.removeItem(at: tmpPDFURL)
        try! fm.removeItem(at: tmpDocumentURL)
        return pdf
    }
}
