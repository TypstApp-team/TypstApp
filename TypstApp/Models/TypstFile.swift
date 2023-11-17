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
    static let typ = UTType("app.typst.typ")!
}

class TypstFile: FileDocument {
    static var readableContentTypes: [UTType] = [.typ]
    static var writableContentTypes: [UTType] = [.typ, .pdf, .png]
    
    var id = UUID()
    var code: String
    var filename: String

    // Save
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = code.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
    func snapshot(contentType: UTType) throws -> String {
        code
    }
    
    func fileWrapper(snapshot: String, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = snapshot.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
    // Load
    required init(configuration: ReadConfiguration) throws {

        guard let data = configuration.file.regularFileContents,
            let code = String(data: data, encoding: .utf8)
        else {
            throw TypstFileDecodeError.dataCorrupted
        }

        self.code = code
        self.filename = (configuration.file.preferredFilename as NSString?)?.deletingPathExtension ?? "Untitled"
    }

    // New document
    init() {

        // Copies code from bundled Example.typ file
        self.code = try! String(
            contentsOf: Bundle.main.url(forResource: "Example", withExtension: ".typ")!,
            encoding: .utf8
        )
        self.filename = "Untitled"
    }
}
