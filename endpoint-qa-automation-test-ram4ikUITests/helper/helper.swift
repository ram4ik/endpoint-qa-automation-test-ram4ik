//
//  helper.swift
//  endpoint-qa-automation-test-ram4ikUITests
//
//  Created by Ramill Ibragimov on 5/24/24.
//

import Foundation

func runAppleScript(_ script: String) {
    let process = Process()
    process.launchPath = "/usr/bin/osascript"
    process.arguments = ["-e", script]
    process.launch()
    process.waitUntilExit()
}

func copyFileToDocuments(filename: String) {
    let fileManager = FileManager.default
    guard let sourceURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
        print("Source file not found")
        return
    }
    
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationURL = documentsURL.appendingPathComponent(filename)
    
    do {
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
        print("File copied to \(destinationURL.path)")
    } catch {
        print("Error copying file: \(error)")
    }
}

func copyFileContentsToClipboard(filename: String) {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsURL.appendingPathComponent(filename)
    
    do {
        let fileContents = try String(contentsOf: fileURL)
        let appleScript = """
        set the clipboard to "\(fileContents)"
        """
        runAppleScript(appleScript)
    } catch {
        print("Error reading file: \(error)")
    }
}


