//
//  ContentView.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import PDFKit
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Binding var document: TypstFile

    @AppStorage("autorefresh") var autoBuild = true

    //    @State var pdf: PDFDocument?
    @State var pdfShouldUpdate: Bool = true
    @State var pdfURL: URL?  // nil if not rendered, yet.
    @State var titles: [TypstTitle] = []
    @State var isRendering: Bool = false

    func render() {
        withAnimation {
            self.isRendering = true
        }

        if self.pdfURL == nil {
            (_, self.pdfURL) = document.renderPDF()
        } else {
            // prevent swiftUI update itself ??
            _ = document.renderPDF()
        }

        pdfShouldUpdate.toggle()
        self.isRendering = false
        self.titles = .parseFrom(document.code)
        print(self.titles)
    }

    var body: some View {
        NavigationStack {
            HStack {
                RunestoneView(text: $document.code)

                if let url = pdfURL {
                    Divider()
                    PDFKitReprentedView(pdfShouldUpdate: $pdfShouldUpdate, url: url)
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
                .disabled(isRendering)  // prevents multiple builds
                .keyboardShortcut("r", modifiers: .command)

                Toggle(isOn: $autoBuild) {
                    Text("Auto Build")
                }

                if let url = pdfURL {
                    ShareLink(item: url) {
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
                } while autoBuild  // using repeat-while so that a first render is always called
            }
        }
    }
}
