//
//  TypstRender.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/9/13.
//

import Foundation
import PDFKit

var tmpBaseURL: URL! {
    FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
}

func renderTypstCodeToPDF(code: String) -> (url: URL, docs: PDFDocument?) {
    let fm = FileManager.default
    
    let fileURL = tmpBaseURL
        .appendingPathComponent("tmp", conformingTo: .typ)
    
    let pdfURL = tmpBaseURL
        .appendingPathComponent("export", conformingTo: .pdf)
    
    try! fm.createDirectory(
        at: tmpBaseURL,
        withIntermediateDirectories: true
    )
    
    fm.createFile(
        atPath: fileURL.path,
        contents: code.data(using: .utf8)
    )
    
    run("typst compile \(fileURL.path) \(pdfURL.path)")
    
    return (pdfURL, PDFDocument(url: pdfURL))
}
