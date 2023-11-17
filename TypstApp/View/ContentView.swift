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
        .toolbar(.hidden, for: .navigationBar)
    }
}
