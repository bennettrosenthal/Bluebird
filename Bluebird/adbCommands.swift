//
//  adbCommands.swift
//  Bluebird
//
//  Copyright © 2021 ModernEra. All rights reserved.
//

import Foundation

public class adbCommands {
    var pipe = Pipe()
    var package = String()
    let stringPath = Bundle.main.path(forResource: "adb", ofType: "")
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
    
    public func startADB() {
        _ = shell("-d", "devices")
    }
    
    public func installAPK(usernameFilePath: String, gameFolderName: String, apkName: String) {
        startADB()
        _ = shell("-d", "install", "\(usernameFilePath)/Downloads/Bluebird Stuff/\(gameFolderName)/\(apkName)")
    }
    
    public func uninstallGame(gameID: String) {
        startADB()
        _ = shell("uninstall", "\(gameID)")
    }
    
    public func grantPermissions(gameID: String) {
        startADB()
        _ = shell("-d", "shell", "pm", "grant", "\(gameID)", "android.permission.RECORD_AUDIO")
        _ = shell("-d", "shell", "pm", "grant", "\(gameID)", "android.permission.READ_EXTERNAL_STORAGE")
        _ = shell("-d", "shell", "pm", "grant", "\(gameID)", "android.permission.WRITE_EXTERNAL_STORAGE")
    }
    
    public func pushOBB(gameID: String, usernameFilePath: String, gameFolderName: String, obbName: String) {
        _ = shell("-d", "shell", "mkdir", "/sdcard/Android/obb/\(gameID)")
        _ = shell("-d", "push", "\(usernameFilePath)/Downloads/Bluebird Stuff/\(gameFolderName)/\(obbName)", "/sdcard/Android/obb/\(gameID)")
    }
    
    public func pushName(usernameFilePath: String, namePath: String) {
        _ = shell("-d", "push", "\(usernameFilePath)/Downloads/Bluebird Stuff/name.txt", "/sdcard\(namePath)")
    }
    
    public func killADB() {
        _ = shell("-d", "kill-server")
    }
    
    public func pushMap(usernameFilePath: String) {
        _ = shell("push", "\(usernameFilePath)/Downloads/Android_ASTC.pak", "/sdcard/pavlov/maps/test_map/Android_ASTC.pak")
    }
    
    public func getPackages() {
        _ = shell("shell", "pm", "list", "packages", "-3\"\"|cut", "-f", "2", "-d", "\":\"")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            package = string
        }
    }
}
