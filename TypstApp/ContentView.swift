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
    enum FocusedField {
        case editor
    }
    @FocusState private var focusedField: FocusedField?
    @State var pdf: PDFDocument?

    var body: some View {
        NavigationSplitView {
            List {
                Text("TBC")
            }
            .navigationTitle(document.title)
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            HStack {
                CodeEditor(text: $document.code,
                           position: $codeEditorPosition,
                           messages: .constant(.init()))
                .focused($focusedField, equals: .editor)

                if let pdf {
                    Divider()
                    PDFView(pdf)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Button {
                        self.pdf = document.renderPDF()
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
