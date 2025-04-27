//
//  ContentView.swift
//  JamPack
//
//  Created by Clice Lee on 4/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var droppedFiles: [URL] = []
    @State private var mergeComplete: Bool = false
    @State private var isTargeted: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Drop your files here")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: isTargeted ? 4 : 2, dash: [10]))
                .foregroundColor(isTargeted ? .blue : .gray)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 30/255, green: 30/255, blue: 30/255))
                )
                .frame(maxWidth: .infinity, minHeight: 255, maxHeight: 255)
                .overlay(
                    VStack {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 0, height: 0)
                            .foregroundColor(.white)
                        Text(droppedFiles.isEmpty ? "Drag & Drop files" : "Files ready to merge")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                )
                .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
                    handleDrop(providers: providers)
                }
            if !droppedFiles.isEmpty {
                List {
                    ForEach(droppedFiles, id: \.self) { file in
                        HStack(spacing: 10) {
                            Image(iconName(for: file.pathExtension))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)

                            Text(file.lastPathComponent)
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .frame(maxHeight: 200)
                .listStyle(PlainListStyle())
            }

            if !droppedFiles.isEmpty {
                Button(action: {
                    mergeFiles()
                }) {
                    Text("Merge to Text File")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: 250)
                .padding(.top, 10)
            }

            if mergeComplete {
                Text("✅ Merged successfully!")
                    .font(.title3)
                    .foregroundColor(.green)
                    .padding(.top, 10)
                    .transition(.opacity)
            }

            Spacer()
        }
        .padding()
        .frame(width: 500, height: 700)
        .background(Color(red: 30/255, green: 30/255, blue: 30/255)) // 앱 전체 배경 (다크그레이)
        .animation(.easeInOut, value: mergeComplete)
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (item, error) in
                    DispatchQueue.main.async {
                        if let data = item as? Data,
                           let url = URL(dataRepresentation: data, relativeTo: nil) {
                            let fileExtension = url.pathExtension.lowercased()
                            if !blockedExtensions.contains(fileExtension) {
                                droppedFiles.append(url)
                            } else {
                                print("❌ Blocked non-text file: \(url.lastPathComponent)")
                            }
                        }
                    }
                }
            }
        }
        return true
    }

    private func mergeFiles() {
        MergeManager.merge(files: droppedFiles) { success in
            withAnimation {
                mergeComplete = success
            }
        }
    }

    private func iconName(for fileExtension: String) -> String {
        switch fileExtension.lowercased() {
        case "c": return "c"
        case "cpp": return "cpp"
        case "cs": return "cs"
        case "css": return "css"
        case "dart": return "dart"
        case "go": return "go"
        case "html": return "html"
        case "java": return "java"
        case "js": return "js"
        case "jsx": return "react"
        case "kt", "kts": return "kotlin"
        case "lua": return "lua"
        case "mysql", "sql": return "sql"
        case "perl", "pl": return "perl"
        case "php": return "php"
        case "py": return "python"
        case "rb": return "ruby"
        case "rs": return "rust"
        case "sass": return "sass"
        case "sh", "zsh", "bat": return "shell"
        case "scala": return "scala"
        case "swift": return "swift"
        case "ts", "tsx": return "ts"
        case "vue": return "vue"
        default: return "doc"
        }
    }
    private let blockedExtensions: Set<String> = [
        // image
        "png", "jpg", "jpeg", "gif", "bmp", "svg", "webp", "ico", "tiff", "heic",
        // video
        "mp4", "mov", "avi", "mkv", "webm", "m4v", "flv",
        // audio
        "mp3", "wav", "ogg", "flac", "aac",
        // binary
        "exe", "dmg", "app", "bin", "iso", "tar", "zip", "gz", "7z", "rar",
        // document
        "pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "key", "pages", "numbers"
    ]
}
