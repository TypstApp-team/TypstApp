//
//  ContentView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import SwiftUI
import CodeEditorView
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    typealias UIViewType = PDFView

    let data: Data
    let singlePage: Bool

    init(_ data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = PDFDocument(data: data)
    }
}

struct ContentView: View {
    @State var code: String = "== Example"
    @State var position: CodeEditor.Position       = CodeEditor.Position()
//    @State var messages: Set<Located<Message>> = Set()
    @State var data: Data?
    var url: URL = { () -> URL in
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("example.typ")
        return url
    }()

    var pdfURL: URL = { () -> URL in
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("example.pdf")
        return url
    }()

//    func render(code: String) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
//            try! code.write(to: url, atomically: true, encoding: .utf8)
//            run("typst compile \(url.path)")
//            self.data = PDFDocument(url: pdfURL)?.dataRepresentation()
//        }
//    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                HStack {
                    CodeEditor(text: $code, position: $position, messages: .constant(.init()))
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .scrollDismissesKeyboard(.never)
                    Divider()
                    Group {
                        if let data {
                            PDFKitRepresentedView(data)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                }
            }
            .navigationTitle("Typst")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    run("typst compile \(url.path)")
                    self.data = PDFDocument(url: pdfURL)?.dataRepresentation()
                } label: {
                    Label("Refresh", systemImage: "arrowtriangle.right.fill")
                }
            }
        }
        .padding()
        .onChange(of: code) { newValue in
            try! newValue.write(to: url, atomically: true, encoding: .utf8)
//            render(code: $0)
        }
        .task {
//            try! code.write(to: url, atomically: true, encoding: .utf8)
//            Task.detached {
//                run("typst compile \(url.path)")
//            }
//            Task.detached {
//                while true {
//                    self.data = PDFDocument(url: pdfURL)?.dataRepresentation()
//                    print("PIEJ")
//                    try? await Task.sleep(nanoseconds: 20_000_000_000)
//                }
//            }
//            render(code: "== Example")
        }
    }
}
