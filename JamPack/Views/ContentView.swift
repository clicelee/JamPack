//
//  ContentView.swift
//  JamPack
//
//  Created by Clice Lee on 4/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var droppedFiles: [URL] = []
    @State private var mergeComplete  = false
    @State private var isTargeted     = false
    @State private var showAlert      = false
    @State private var alertMessage   = ""

    var body: some View {
            VStack(spacing: 20) {
                Spacer()
                Text("Drop your files here")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                RoundedDropZone
                    .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: handleDrop)
                
                // ───── File list ─────
                if !droppedFiles.isEmpty {
                    FileList
                }
                
                // ───── Merge & Clear All  ─────
                if !droppedFiles.isEmpty {
                    
                    ZStack {
                        
                        
                        Button {
                            mergeFiles()
                        } label: {
                            Text(mergeComplete ? "✅ Merged Complete"
                                 : "Merge to Text File")
                            .padding(.vertical, 14)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            Spacer()
                            Button {
                                clearAllFiles()
                            } label: {
                                Text("Clear All")
                                    .font(.subheadline).fontWeight(.semibold)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 14)
                                    .background(Color.gray.opacity(0.65))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            .frame(width: 100)
                            .padding(.trailing, -8)
                        }
                    }
                    .padding(.top, 10)
                }
                
                Spacer()
            
        }
        .padding()
        .frame(width: 500, height: 700)
        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
        .animation(.easeInOut, value: mergeComplete)
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - View Building Helpers
    private var RoundedDropZone: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 30/255, green: 30/255, blue: 30/255))
            Image("icon")
                .resizable()
                .scaledToFit()
                .opacity(0.18)
                .frame(width: 300, height: 300)
                .offset(y: -10)
            
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: isTargeted ? 4 : 2, dash: [10]))
                .foregroundColor(isTargeted ? .blue : .gray)

            VStack {
                Image(systemName: "square.and.arrow.down")
                    .opacity(0)
                Text(droppedFiles.isEmpty ? "Drag & Drop files" : "Files ready to merge")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 255, maxHeight: 255)
    
    }

    private var FileList: some View {
        List {
            ForEach(droppedFiles, id: \.self) { file in
                HStack(spacing: 10) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.gray)

                    Image(iconName(for: file.pathExtension))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(file.lastPathComponent)
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    Button {
                        if let idx = droppedFiles.firstIndex(of: file) {
                            droppedFiles.remove(at: idx)
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.vertical, 4)
            }
            .onMove(perform: moveFile)
        }
        .listStyle(.plain)
        .frame(maxHeight: 200)
    }

    @ViewBuilder
    private func ActionButton(title: String,
                              bg: Color,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).fill(bg))
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
    }

    // MARK: - File Handling
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        var rejected: [String] = []

        for provider in providers where provider.hasItemConformingToTypeIdentifier("public.file-url") {
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                DispatchQueue.main.async {
                    if let data = item as? Data,
                       let url  = URL(dataRepresentation: data, relativeTo: nil) {

                        let ext = url.pathExtension.lowercased()
                        if blockedExtensions.contains(ext) {
                            rejected.append(url.lastPathComponent)
                        } else {
                            droppedFiles.append(url)
                        }
                    }
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if !rejected.isEmpty {
                alertMessage = "Unsupported files:\n" + rejected.joined(separator: "\n")
                showAlert = true
            }
        }
        return true
    }

    private func mergeFiles() {
        MergeManager.merge(files: droppedFiles) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    mergeComplete = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            mergeComplete = false
                        }
                    }
                } else {
                    alertMessage = errorMessage ?? "Unknown failure."
                    showAlert = true
                }
            }
        }
    }


    // MARK: - List Utilities
    private func moveFile(from src: IndexSet, to dst: Int) {
        droppedFiles.move(fromOffsets: src, toOffset: dst)
    }
    private func clearAllFiles() { droppedFiles.removeAll() }

    // MARK: - Icon Mapping
    private func iconName(for ext: String) -> String {
        switch ext.lowercased() {
        case "c": return "c";          case "cpp": return "cpp"
        case "cs": return "cs";        case "css": return "css"
        case "dart": return "dart";    case "go": return "go"
        case "html": return "html";    case "java": return "java"
        case "js": return "js";        case "jsx": return "react"
        case "kt", "kts": return "kotlin"
        case "lua": return "lua";      case "mysql", "sql": return "sql"
        case "perl", "pl": return "perl"
        case "php": return "php";      case "py": return "python"
        case "rb": return "ruby";      case "rs": return "rust"
        case "sass": return "sass";    case "sh", "zsh", "bat": return "shell"
        case "scala": return "scala";  case "swift": return "swift"
        case "ts", "tsx": return "ts"; case "vue": return "vue"
        default: return "doc"
        }
    }

    // MARK: - Blocked extensions
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
