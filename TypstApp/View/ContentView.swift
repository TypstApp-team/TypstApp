//
//  ContentView.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/15.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TypstFile
    
    var body: some View {
        NavigationStack {
            EditorView(
                document: $document
            )
            .ignoresSafeArea(.keyboard)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    document.renderPDF()
                } label: {
                    Label("Build", systemImage: "arrowtriangle.right.fill")
                }
                .keyboardShortcut("r", modifiers: .command)
                
                ShareLink(item: document.renderedPDFURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}
