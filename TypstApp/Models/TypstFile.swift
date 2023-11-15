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

enum TypstFileDecodeError: String, Error {
    case dataCorrupted = "Cannot decode file."
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
            throw TypstFileDecodeError.dataCorrupted
        }

        self.code = code
        self.title = configuration.file.filename ?? "Untitled"
    }

    /// New document
    init() {
        self.code = try! String(
            contentsOf: Bundle.main.url(forResource: "Example", withExtension: ".typ")!,
            encoding: .utf8
        )
        self.title = "Untitled"
    }
}

extension TypstFile: FileDocument {
    static var readableContentTypes: [UTType] = [.typstDocument]
    static var writableContentTypes: [UTType] = [.typstDocument, .pdf, .png]

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

struct TypstTitle {
    var id = UUID()
    var depth: Int
    var content: String
}

extension [TypstTitle] {
    static func parseFrom(_ code: String) -> [TypstTitle] {
        // 1. split by \n
        // 2. remove leading and trailing spaces
        // 3. count "=" at the beginning -> depth
        // 4. remove "=" at the beginning -> content

        code
            .split(separator: "\n")
            .compactMap { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                let depth = trimmed.prefix(while: { $0 == "=" }).count
                let content = trimmed.drop(while: { $0 == "=" })
                if depth == 0 {
                    return nil
                }
                return TypstTitle(depth: depth, content: String(content))
            }
    }
}
