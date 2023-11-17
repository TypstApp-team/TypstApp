//
//  EditorView.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/15.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import Runestone
import PDFKit


// SwiftUI Bridge
struct EditorView: UIViewControllerRepresentable {
    typealias UIViewControllerType = EditorController
    
    @Binding var document: TypstFile
    
    func makeUIViewController(context: Context) -> EditorController {
        let controller = EditorController(
            code: document.code
        )
        
        controller.textValue.asObserver().subscribe({
            self.document.code = $0.element!
        })
        .disposed(by: controller.disposeBag)
        
        return controller
    }
    
    func updateUIViewController(_ controller: EditorController, context: Context) {}
}

