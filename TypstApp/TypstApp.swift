//
//  TypstApp.swift
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

import SwiftUI

@main
struct TypstApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TypstFile()) { config in
            ContentView(document: config.$document)
                .toolbarRole(.automatic)
        }
    }
}
