//
//  ContentView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import PDFKit
import SwiftUI

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


struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @AppStorage("autorefresh") var autoBuild = true

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
        }
        
        Task.detached {
            self.pdf = document.renderPDF()
        }
        
        withAnimation(.smooth(duration: 3)) {
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

                if let _ = pdf {
                    Divider()
                    PDFView(Binding($pdf)!)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup {
                if isRendering {
                    Text("Rendering")
                        .foregroundColor(.red)
                }
                
                Button {
                    render()
                } label: {
                    Text("Build")
                }
                .disabled(isRendering)
                .keyboardShortcut("r", modifiers: .command)
                
                Toggle(isOn: $autoBuild) {
                    Text("Auto Build")
                }
                
                
                
                if let pdf {
                    ShareLink(item: pdf.documentURL!) {
                        Text("Share")
                    }
                }
            }
        }
        .onAppear {
            Task.detached {
                var oldValue = ""
                repeat {
                    if oldValue != document.code {
                        render()
                        oldValue = document.code
                    }
                    try await Task.sleep(nanoseconds: 2_000_000_000)  // refresh every 2 sec
                } while autoBuild
            }
        }
    }
}
