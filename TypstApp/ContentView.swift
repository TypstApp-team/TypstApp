//
//  ContentView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import SwiftUI
import CodeEditorView
import SwiftUIIntrospect
import PDFKit

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Binding var document: TypstFile
    @State var codeEditorPosition: CodeEditor.Position = .init()

    enum FocusField: Hashable {
        case field
    }
    @FocusState private var focusedField: FocusField?

    @State var pdf: PDFDocument?
    @State var isRendering: Bool = false

    func render() {
        withAnimation {
            self.isRendering = true
            self.pdf = document.renderPDF()
            self.isRendering = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(500)) {
            self.focusedField = .field
        }
    }

    var body: some View {
        NavigationSplitView {
            List {
                Text("TBC")
            }
            .navigationTitle(document.title)
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            HStack {
                TextEditor(text: $document.code)
                    .scrollIndicators(.hidden)
                    .focused($focusedField, equals: .field)
                    .onAppear {
                        self.focusedField = .field
                    }

                if let pdf {
                    Divider()
                    PDFView(pdf)
                }
            }
            .overlay(alignment: .bottom) {
                if isRendering {
                    Text("Rendering")
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.red)
                        }
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        Task.detached {
                            render()
                        }
                    } label: {
                        Label("Refresh", systemImage: "arrowtriangle.right.fill")
                    }
                    .disabled(isRendering)
                    .keyboardShortcut("r", modifiers: .command)
                }

                if let pdf {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        ShareLink(item: pdf.documentURL!)
                    }
                }
            }
            .task {
                Task.detached {
                    render() // awaiting rendering result
                    var oldValue = document.code

                    while true {
                        if oldValue != document.code {
                            render()
                            oldValue = document.code
                        }
                        try await Task.sleep(nanoseconds: 2_000_000_000) // refresh every 2 sec
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar) // Used only on simulator to fix swifUI bug
    }
}
