//
//  MergeManager.swift
//  JamPack
//
//  Created by Clice Lee on 4/27/25.
//

import Foundation
import CryptoKit

struct MergeManager {

    /// Merges multiple files into a single text file.
    /// - Parameters:
    ///   - files: List of file URLs to merge
    ///   - completion: (success: Bool, errorMessage: String?)
    static var lastOutputURL: URL?
    static func merge(files: [URL],
                      outputDir: URL? = nil,
                      completion: @escaping (Bool, String?) -> Void) {

        // ---------- 0. Pre-check ----------
        guard !files.isEmpty else {
            completion(false, "No files were dropped.")
            return
        }
        
        let dir = outputDir ??
                     FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

        // ---------- 1. Build a SAFE output file name (≤ 240 bytes) ----------
        var parts: [String] = []
        var currentBytes = 0
        for filename in files.map(\.lastPathComponent) {
            let byteLength = filename.utf8.count + 1 // +1 for separator "-"
            if currentBytes + byteLength > 200 { break }
            parts.append(filename)
            currentBytes += byteLength
        }

        let slug = parts.joined(separator: "-")
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let timestamp = formatter.string(from: .init()).replacingOccurrences(of: ":", with: "-")
        let shortHash = SHA256.hash(data: Data(slug.utf8)).description.prefix(6)

        let safeName = (slug.isEmpty ? "JamPack" : slug) + "-\(shortHash)-\(timestamp).txt"
        assert(safeName.utf8.count < 240, "Output file name too long!")

        // ---------- 2. Prepare output file ----------
//        guard let downloadsDir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
//            completion(false, "Cannot access Downloads folder.")
//            return
//        }

        let outputURL = dir.appendingPathComponent(safeName)

        FileManager.default.createFile(atPath: outputURL.path, contents: nil)
        guard let outputHandle = try? FileHandle(forWritingTo: outputURL) else {
            completion(false, "Cannot open \(outputURL.lastPathComponent) for writing.")
            return
        }
        defer { try? outputHandle.close() }

        // ---------- 3. Stream files one by one ----------
        let bufferSize = 32 * 1024 // 32 KiB buffer
        let footerData = Data("\n```\n\n".utf8)

        for file in files {

            // --- Write header ---
            do {
                let headerData = Data("```\(file.lastPathComponent)\n".utf8)
                try outputHandle.write(contentsOf: headerData)
            } catch {
                return handleMergeFailure(file, action: "writing header", error: error, completion)
            }

            // --- Write file body ---
            do {
                let inputHandle = try FileHandle(forReadingFrom: file)
                defer { try? inputHandle.close() }

                while let chunk = try inputHandle.read(upToCount: bufferSize), !chunk.isEmpty {
                    try outputHandle.write(contentsOf: chunk)
                }
            } catch {
                return handleMergeFailure(file, action: "copying data", error: error, completion)
            }

            // --- Write footer ---
            do {
                try outputHandle.write(contentsOf: footerData)
            } catch {
                return handleMergeFailure(file, action: "writing footer", error: error, completion)
            }
        }

        try? outputHandle.synchronize()
        MergeManager.lastOutputURL = outputURL      
        completion(true, nil)
    }

    /// Handles merge failure by printing an error and calling completion
    private static func handleMergeFailure(_ file: URL,
                                           action: String,
                                           error: Error,
                                           _ completion: @escaping (Bool, String?) -> Void) {
        let message = """
        Failed while \(action) for file: \(file.lastPathComponent)
        Error: \(error.localizedDescription)
        """
        print("❌ \(message)")
        completion(false, message)
    }
}
