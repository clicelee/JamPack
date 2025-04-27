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
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                mergedContent += "```\(fileURL.lastPathComponent)\n"
                mergedContent += content
                mergedContent += "\n```\n\n"
            }
        }

        let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

        let combinedFileName = files
            .map { $0.lastPathComponent }
            .joined(separator: "-")
            .replacingOccurrences(of: " ", with: "")

        let outputFileName = "\(combinedFileName).txt"
        let outputURL = downloadsDirectory.appendingPathComponent(outputFileName)

        do {
            try mergedContent.write(to: outputURL, atomically: true, encoding: .utf8)
            completion(true)
        } catch {
            print("Failed to save merged file: \(error.localizedDescription)")
            completion(false)
        }
    }
}
