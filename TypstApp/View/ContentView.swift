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
    
    @State var pdf: PDFDocument?
    @State var titles: [TypstTitle] = []
    @State var isRendering: Bool = false
    
    func render() {
        withAnimation {
            self.isRendering = true
        }
        
        self.pdf = document.renderPDF()
        
        withAnimation(.smooth(duration: 3)) {
            self.isRendering = false
            self.titles = .parseFrom(document.code)
        }
        
        Task { @MainActor in
            // ensuring main thread for notification
            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(500)) {
                // offset to ensure the notification is sent after the animation
                NotificationCenter.default.post(
                    name: NSNotification.Name("RunestoneGetFoucs"),
                    object: nil
                )
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                RunestoneView(text: $document.code)
                
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
                .disabled(isRendering) // prevents multiple builds
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
                } while autoBuild // using repeat-while so that a first render is always called
            }
        }
    }
}
