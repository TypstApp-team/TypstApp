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
        
        controller.textToSaveValue.asObserver()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe({
                self.document.code = $0.element!
                if let url = self.document.fileURL {
                    // dump the code to the file
                    try! self.document.code.write(to: url, atomically: true, encoding: .utf8)
                }
            })
            .disposed(by: controller.disposeBag)
        
        return controller
    }
    
    func updateUIViewController(_ controller: EditorController, context: Context) {}
}

