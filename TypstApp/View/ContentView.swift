//
//  ContentView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import PDFKit
import SwiftUI
import UIKit
import Runestone

struct TypstTitle {
    var id = UUID()
    var depth: Int
    var content: String
}

extension [TypstTitle] {
    static func parseFrom(_ code: String) -> [TypstTitle] {
        // 1. split by \n
        // 2. remove leading and trailing spaces
        // 3. count "=" at the beginning -> depth
        // 4. remove "=" at the beginning -> content

        code
            .split(separator: "\n")
            .compactMap { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                let depth = trimmed.prefix(while: { $0 == "=" }).count
                let content = trimmed.drop(while: { $0 == "=" })
                if depth == 0 {
                    return nil
                }
                return TypstTitle(depth: depth, content: String(content))
            }
    }
}

struct RunestoneView: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<RunestoneView>
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> TextView {
        let textView = TextView()
        textView.showLineNumbers = true
        textView.lineSelectionDisplayType = .lineFragment
        textView.showPageGuide = true
        textView.pageGuideColumn = 80
        textView.showTabs = true
        textView.showSpaces = true
//        textView.showLineBreaks = true
//        textView.showSoftLineBreaks = true
        textView.editorDelegate = context.coordinator
        textView.setLanguageMode(TreeSitterLanguageMode(language: .typst))
        textView.theme = TomorrowTheme()
        return textView
    }
    
    func updateUIView(_ textView: TextView, context: Context) {
        if !context.coordinator.isEditing {
            textView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, TextViewDelegate {
        var text: Binding<String>
        var isEditing: Bool = false
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: TextView) {
            self.text.wrappedValue = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: TextView) {
            self.isEditing = true
        }
        
        func textViewDidEndEditing(_ textView: TextView) {
            self.isEditing = false
        }
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @AppStorage("autorefresh") var autorefresh = true

    @Binding var document: TypstFile
    @State var pdf: PDFDocument?
    @State var titles: [TypstTitle] = []

    enum FocusField: Hashable {
        case field
    }
    @FocusState private var focusedField: FocusField?
    @State var isRendering: Bool = false

    func render() {
        withAnimation {
            self.isRendering = true
            self.pdf = document.renderPDF()
            self.isRendering = false
            self.titles = .parseFrom(document.code)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(500)) {
            self.focusedField = .field
        }
    }

    var body: some View {
        NavigationStack {
            HStack {
                RunestoneView(text: $document.code)
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
            .navigationTitle(document.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        Task.detached {
                            render()
                        }
                    } label: {
                        Label(
                            "Refresh",
                            systemImage: "arrowtriangle.right.fill"
                        )
                    }
                    .disabled(isRendering)
                    .keyboardShortcut("r", modifiers: .command)
                    
                    Toggle(isOn: $autorefresh) {
                        Text("Auto refresh")
                    }
                }

                if let pdf {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        ShareLink(item: pdf.documentURL!)
                    }
                }
            }
            .onAppear {
                Task.detached {
                    var oldValue = ""
                    while autorefresh {
                        if oldValue != document.code {
                            render()
                            oldValue = document.code
                        }
                        try await Task.sleep(nanoseconds: 2_000_000_000)  // refresh every 2 sec
                    }
                }
            }
        }
    }
}
