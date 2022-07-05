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
        
        // 读取配置(指 rule.json)
        
        var t = $document.text.wrappedValue
        t = t.replacingOccurrences(of: "\n", with: "")
        t = t.replacingOccurrences(of: " ", with: "")
        t = t.replacingOccurrences(of: "\\", with: "")
        
        guard let data = t.data(using: .utf8),
              let menus = try? JSONDecoder().decode([Rule].self, from: data) else {
            print("config JSON failed...")
            return
        }
        
        guard let item = menus.first else {
            print("rule JSON failed...")
            return
        }
        
        showPannel(with: "选择模板文件路径") { tPath in
            guard var tStr = try? String(contentsOfFile: tPath) else {
                print("template TEXT failed...")
                return
            }
            
            for rule in item.rules {
                tStr = tStr.replacingOccurrences(of: rule.key, with: rule.value)
            }
            
            showPannel(with: "选择存储路径") { path in
                let nPath = path + "/result.text"
                if FileManager.default.fileExists(atPath: nPath) {
                    print("file existed...")
                } else {
                    if let result = tStr.data(using: .utf8) {
                        FileManager.default.createFile(atPath: nPath, contents: result)
                    } else {
                        print("result utf8 failed...")
                    }
                }
            }
        }
    }
    
    /// 打开选择文件对话框
    private func showPannel(with title: String, completed: ((_ path: String)->())?) {
        let pannel = NSOpenPanel()
        pannel.title = title
        pannel.canChooseDirectories = true
        pannel.begin { result in
            if result == .OK {
                guard let path = pannel.urls.first?.path else {
                    return
                }
                
                completed?(path)
            }
        }
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView(document: .constant(MOONVisualDocument()))
//        }
//    }
//}

// ---

struct Rule: Codable {
    
    var name: String
    
    var template: String
    
    var rules: [String: String] = [:]
}
