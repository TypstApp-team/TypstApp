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
    @State var isRenderding: Bool = false

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
            .overlay(alignment: .bottom) {
                if isRenderding {
                    Text("Rendering")
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.red)
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Button {
                        Task.detached {
                            self.isRenderding = true
                            self.pdf = document.renderPDF()
                            self.isRenderding = false
                        }
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
