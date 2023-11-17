//
//  Errors.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/16.
//

import Foundation

enum TypstFileDecodeError: String, Error {
    case dataCorrupted = "Cannot decode file."
}

enum TypstCompileError: String, Error {
    case invalidURL = "tmp folder isn't valid"
}

enum TypstEditorError: String, Error {
    case inValidPreviewURL = "invalid preview URL"
}
