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

    var body: some View {
        VStack(spacing: 30) {
            Text("Drop your files here")
                .font(.title)
                .foregroundColor(.white)

            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [10]))
                .foregroundColor(.white)
                .frame(width: 300, height: 300)
                .overlay(
                    VStack {
                        Text("Drop here")
                            .foregroundColor(.white)
                        if droppedFiles.isEmpty {
                            Text("(No files yet)")
                                .foregroundColor(.gray)
                                .font(.caption)
                        } else {
                            List {
                                ForEach(droppedFiles, id: \.self) { file in
                                    Text(file.path)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxHeight: 200)
                            .background(Color.black)
                            .listStyle(PlainListStyle())
                        }
                    }
                )
                .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                    handleDrop(providers: providers)
                }

            if !droppedFiles.isEmpty {
                Button(action: {
                    mergeFiles()
                }) {
                    Text("Merge to Text File")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }

            if mergeComplete {
                Text("✅ Merged to Downloads/JamPack-merged.txt")
                    .foregroundColor(.green)
            }
        }
        .frame(width: 500, height: 700)
        .background(Color.black)
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (item, error) in
                    DispatchQueue.main.async {
                        if let data = item as? Data,
                           let url = URL(dataRepresentation: data, relativeTo: nil) {
                            droppedFiles.append(url)
                        }
                    }
                }
            }
        }

        return true
    }

    private func mergeFiles() {
        MergeManager.merge(files: droppedFiles) { success in
            mergeComplete = success
        }
    }
}
