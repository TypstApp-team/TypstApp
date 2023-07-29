//
//  ContentView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import SwiftUI
import CodeEditorView
import PDFKit

struct ContentView: View {
    @Binding var document: TypstFile
    @State var codeEditorPosition: CodeEditor.Position = .init()
    @State var pdfData: Data?

    var body: some View {
        NavigationSplitView {
            List {
                Text("TBC")
            }
            .navigationTitle(document.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        } detail: {
            HStack {
                CodeEditor(text: $document.code,
                           position: $codeEditorPosition,
                           messages: .constant(.init()))

                if let pdfData {
                    Divider()
                    PDFView(pdfData)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Button {
                        self.pdfData = document.renderPDFData()
                    } label: {
                        Label("Refresh", systemImage: "arrowtriangle.right.fill")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
