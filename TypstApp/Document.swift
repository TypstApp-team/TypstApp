//
//  Document.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/13.
//

import UIKit

class Document: UIDocument {

    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}
