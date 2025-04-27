//
//  MergeManager.swift
//  JamPack
//
//  Created by Clice Lee on 4/27/25.
//

import Foundation

struct MergeManager {
    static func merge(files: [URL], completion: @escaping (Bool) -> Void) {
        guard !files.isEmpty else {
            completion(false)
            return
        }

        var mergedContent = ""

        for fileURL in files {
            if let content = try? String(contentsOf: fileURL) {
                mergedContent += "// \(fileURL.lastPathComponent)\n"
                mergedContent += content
                mergedContent += "\n\n"
            }
        }

        let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let outputURL = downloadsDirectory.appendingPathComponent("JamPack-merged.txt")

        do {
            try mergedContent.write(to: outputURL, atomically: true, encoding: .utf8)
            completion(true)
        } catch {
            print("Failed to save merged file: \(error.localizedDescription)")
            completion(false)
        }
    }
}
