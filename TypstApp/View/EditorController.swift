//
//  EditorController.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/17.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import Runestone
import PDFKit


class TextViewControllerDelegate: TextViewDelegate {
    var editorController: EditorController?
    
    func textViewDidEndEditing(_ textView: TextView) {
        editorController?.textValue.onNext(textView.text)
    }
    
    func textViewShouldEndEditing(_ textView: TextView) -> Bool {
        false
    }
}

class EditorController: UIViewController {
    let textValue = PublishSubject<String>()
    let pdfValue = PublishSubject<PDFDocument?>()
    let disposeBag = DisposeBag()
    
    private let textViewDelegate = TextViewControllerDelegate()
    private var textView: TextView = {
        let textView = TextView()
        textView.showLineNumbers = true
        textView.lineSelectionDisplayType = .lineFragment
        textView.theme = BaseTheme()
        textView.backgroundColor = .systemBackground
        textView.setLanguageMode(TreeSitterLanguageMode.typst)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartQuotesType = .no
        textView.insertionPointColor = .accent
        
        return textView
    }()
    
    private var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        return pdfView
    }()
    
    @objc func dismissEditor() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func triggerBuild() {
        self.textValue.onNext(textView.text)
    }
    
    @objc func displayShareMenu() {
        // build -> tmpPDFURL -> share
        let url = renderTypstCodeToPDF(code: textView.text).url
        // pop share menu:
        
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        if let popController = activityViewController.popoverPresentationController {
            popController.sourceRect = CGRect(
                x: view.bounds.midX,
                y: view.bounds.midY,
                width: 0,
                height: 0
            )
            popController.barButtonItem = shareButton
        }
        
        self.present(activityViewController, animated: true)
    }
    
    private let dismissButton = UIBarButtonItem(
        title: "Dismiss",
        style: .plain,
        target: self,
        action: #selector(dismissEditor)
    )
    
    private let buildButton = UIBarButtonItem(
        title: "Build",
        style: .plain,
        target: self,
        action: #selector(triggerBuild)
    )
    
    private let shareButton = UIBarButtonItem(
        title: "Share",
        style: .plain,
        target: self,
        action: #selector(displayShareMenu)
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [shareButton, buildButton]
        
        let hStackView = UIStackView(arrangedSubviews: [textView, pdfView])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStackView)
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    required init(
        code: String,
        pdf: PDFDocument? = nil
    ) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.textView.text = code
        self.textViewDelegate.editorController = self
        self.textView.editorDelegate = textViewDelegate
        self.pdfView.document = pdf
        
        // use rx to bind textValue -> pdfValue, and bind pdfValue to pdfView
        self.textValue
            .map { code in
                renderTypstCodeToPDF(code: code).docs
            }
            .bind(to: pdfValue)
            .disposed(by: disposeBag)
        
        self.pdfValue
            .bind(to: pdfView.rx.document)
            .disposed(by: disposeBag)
        
        self.textValue.onNext(code)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
