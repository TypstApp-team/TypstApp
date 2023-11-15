//
//  DocumentViewController.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/13.
//

import UIKit
import Runestone

class DocumentViewController: UIDocumentViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
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
        
        self.view = UIView()
        
        let textView = TextView()
        textView.showLineNumbers = true
        textView.showPageGuide = true
        textView.theme = DefaultTheme()
        textView.text = """
GO FUCK YOURSELF
"""
        
        let text = UITextView()
        text.text = "TEST"
        self.view.addSubview(text)
        
        self.view.addSubview(textView)
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true)
    }
}
