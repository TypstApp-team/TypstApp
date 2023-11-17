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
        editorController?.textToRenderValue.onNext(textView.text)
    }
    
    func textViewDidChange(_ textView: TextView) {
        editorController?.textToSaveValue.onNext(textView.text)
        editorController?.textToRenderValue.onNext(textView.text)
    }
    
    func textViewShouldEndEditing(_ textView: TextView) -> Bool {
        false
    }
}

class EditorController: UIViewController {
    let textToRenderValue = PublishSubject<String>()
    let textToSaveValue = PublishSubject<String>()
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
        pdfView.backgroundColor = .systemBackground
        
        return pdfView
    }()
    
    private var stackView = UIStackView()
    
    @objc func dismissEditor() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func triggerBuild() {
        self.textToRenderValue.onNext(textView.text)
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
    
    @objc func setupStackView() {
        if UIDevice.current.orientation.isLandscape {
            stackView.removeArrangedSubview(pdfView)
            stackView.addArrangedSubview(pdfView)
            stackView.axis = .horizontal
        } else {
            stackView.removeArrangedSubview(textView)
            stackView.addArrangedSubview(textView)
            stackView.axis = .vertical
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [shareButton, buildButton]
        
        setupStackView()
        
        // listen to device rotate event
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupStackView),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        stackView = UIStackView(arrangedSubviews: [textView, pdfView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        self.textToRenderValue
            .map { code in
                renderTypstCodeToPDF(code: code).docs
            }
            .bind(to: pdfValue)
            .disposed(by: disposeBag)
            
        self.pdfValue.asObserver()
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { pdf in
                self.pdfView.document = pdf
            })
            .disposed(by: disposeBag)
        
        Task.detached {
            repeat {
                await self.textView.becomeFirstResponder()
            } while(true)
        }
        
        self.textToRenderValue.onNext(code)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
