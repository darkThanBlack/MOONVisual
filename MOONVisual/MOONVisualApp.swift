//
//  MOONVisualApp.swift
//  MOONVisual
//
//  Created by 徐一丁 on 2022/6/30.
//

import SwiftUI

@main
struct MOONVisualApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MOONVisualDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
