//
//  ContentView.swift
//  MOONVisual
//
//  Created by 徐一丁 on 2022/6/30.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @Binding var document: MOONVisualDocument
    
    @State var presented = false
    
    
    var body: some View {
        VStack {
            Button {
                saveAction()
            } label: {
                Text("321")
            }
            .padding()
            .alert("JSON failed...", isPresented: $presented) {
                Text("message...")
            }
            TextEditor(text: $document.text)
                .font(.system(size: 15.0, weight: .regular, design: .monospaced))
        }
    }
    
    private func saveAction() {
        let path = FileManager.default.currentDirectoryPath
        print("app_path=\(path)")
        let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
        print("desktop_path=\(url)")
        
        // 读取配置
        guard let data = $document.text.wrappedValue.data(using: .utf8),
              let config = try? JSONDecoder().decode(Config.self, from: data) else {
            $presented
            Binding
            print("config JSON failed...")
            return
        }
        
        
        // 读取映射规则
        let pannel = NSOpenPanel()
        pannel.canChooseDirectories = true
        pannel.begin { result in
            if result == .OK {
                guard let path = pannel.urls.first?.path else {
                    return
                }
                
                if FileManager.default.fileExists(atPath: path) {
                    print("file existed...")
                } else {
                    FileManager.default.createFile(atPath: path + "result.json", contents: data)
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(MOONVisualDocument()))
    }
}

struct Config: Codable {
    
    var key: String
    
    var rule: ColorRule
}

struct ColorRule: Codable {
    
    var fileName: String
    
    var snapName: String
    
    var snapValue: String
}
