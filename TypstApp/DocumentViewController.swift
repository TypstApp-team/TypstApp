//
//  DocumentViewController.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/13.
//

import UIKit
import Runestone

class DocumentViewController: UIDocumentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewsIfNecessary()
    }
    
    override func documentDidOpen() {
        super.documentDidOpen()
        self.updateViewsIfNecessary()
    }
    
    func updateViewsIfNecessary() {
        // Check if the document is open and the view is loaded
        guard let document, !document.documentState.contains(.closed) else { return }
        guard isViewLoaded else { return }
        
        let textView = TextView()
        
        self.view.frame = .infinite
        self.view.addSubview(textView)
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true)
    }
}
