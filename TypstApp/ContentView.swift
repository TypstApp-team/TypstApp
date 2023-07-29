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
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Binding var document: TypstFile
    @State var codeEditorPosition: CodeEditor.Position = .init()
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
                           messages: .constant(.init()),
                           language: .typst(),
                           layout: .init(showMinimap: true, wrapText: true))
                .environment(\.codeEditorTheme,
                              colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight)

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
                            withAnimation {
                                self.isRenderding = true
                                self.pdf = document.renderPDF()
                                self.isRenderding = false
                            }
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
