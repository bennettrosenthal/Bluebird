//
//  adbCommands.swift
//  Bluebird
//
//  Copyright © 2021 ModernEra. All rights reserved.
//

import Foundation

public class adbCommands {
    var package = String()
    var pipe = Pipe()
    let stringPath = Bundle.main.path(forResource: "adb", ofType: "")
    
    
    func startADB() {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("-d", "devices")
    }
    
    func installAPK(usernameFilePath: String, gameFolderName: String, apkName: String) {
        startADB()
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("-d", "install", "\(usernameFilePath)/Downloads/Bluebird Stuff/\(gameFolderName)/\(apkName)")
    }
    
    func uninstallGame(gameID: String) {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        startADB()
        _ = shell("-d", "uninstall", "\(gameID)")
    }
    
    func grantPermissions(gameID: String) {
        startADB()
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("-d", "shell", "pm", "grant", "\(gameID)", "android.permission.RECORD_AUDIO")
        _ = shell("-d", "shell", "pm", "grant", "\(gameID)", "android.permission.READ_EXTERNAL_STORAGE")
        _ = shell("-d", "shell", "pm", "grant", "\(gameID)", "android.permission.WRITE_EXTERNAL_STORAGE")
    }
    
    func pushOBB(gameID: String, usernameFilePath: String, gameFolderName: String, obbName: String) {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("-d", "shell", "mkdir", "/sdcard/Android/obb/\(gameID)")
        _ = shell("-d", "push", "\(usernameFilePath)/Downloads/Bluebird Stuff/\(gameFolderName)/\(obbName)", "/sdcard/Android/obb/\(gameID)")
    }
    
    func pushName(usernameFilePath: String, namePath: String) {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("-d", "push", "\(usernameFilePath)/Downloads/Bluebird Stuff/name.txt", "/sdcard\(namePath)")
    }
    
    func killADB() {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("-d", "kill-server")
    }
    
    func pushMap(usernameFilePath: String) {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("push", "\(usernameFilePath)/Downloads/Android_ASTC.pak", "/sdcard/pavlov/maps/test_map/Android_ASTC.pak")
    }
    
    func getPackages() {
        @discardableResult
        func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }
        _ = shell("shell", "pm", "list", "packages", "-3\"\"|cut", "-f", "2", "-d", "\":\"")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            package = string
        }
    }
}
