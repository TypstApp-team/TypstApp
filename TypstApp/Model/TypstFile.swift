//
//  TypstFile.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/29.
//

import PDFKit
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let typstDocument = UTType("app.typst.typ")!
}

struct TypstFile {
    var id = UUID()
    var code: String
    var title: String

    /// Load from file
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
            let code = String(data: data, encoding: .utf8)
        else {
            throw BaseError.runtimeError("data corrupted")
        }

        self.code = code
        self.title = configuration.file.filename ?? "Untitled"
    }

    /// New document
    init() {
        self.code = "= Example Document\n#lorem(1000)"
        self.title = "Untitled"
    }
}

extension TypstFile: FileDocument {
    static var readableContentTypes: [UTType] = [.typstDocument]
    static var writableContentTypes: [UTType] = [.typstDocument, .pdf, .png]

    func fileWrapper(
        configuration: WriteConfiguration
    ) throws -> FileWrapper {
        let data = code.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }

    func snapshot(
        contentType: UTType
    ) throws -> String {
        code
    }

    func fileWrapper(
        snapshot: String,
        configuration: WriteConfiguration
    ) throws
        -> FileWrapper
    {
        let data = code.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
