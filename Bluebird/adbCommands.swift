//
//  adbCommands.swift
//  Bluebird
//
//  Copyright © 2021 ModernEra. All rights reserved.
//

import Foundation

public class adbCommands {
    var package = String()
    let stringPath = Bundle.main.path(forResource: "adb", ofType: "")
    
    func startADB() {
        let start = Process()
        start.launchPath = stringPath
        start.arguments = ["-d", "devices"]
        start.launch()
        start.waitUntilExit()
    }
    
    func installAPK(usernameFilePath: String, gameFolderName: String, apkName: String) {
        let apk = Process()
        apk.launchPath = stringPath
        apk.arguments = ["-d", "install", "\(usernameFilePath)/Downloads/Bluebird Stuff/\(gameFolderName)/\(apkName)"]
        apk.launch()
        apk.waitUntilExit()
    }
    
   func uninstallGame(gameID: String) {
        let un = Process()
        un.launchPath = stringPath
        un.arguments = ["-d", "uninstall", "\(gameID)"]
        un.launch()
        un.waitUntilExit()
   }
    
    func grantPermissions(gameID: String) {
        let audio = Process()
        audio.launchPath = stringPath
        audio.arguments = ["-d", "shell", "pm", "grant", "\(gameID)", "android.permission.RECORD_AUDIO"]
        audio.launch()
        audio.waitUntilExit()
        
        let read = Process()
        read.launchPath = stringPath
        read.arguments = ["-d", "shell", "pm", "grant", "\(gameID)", "android.permission.READ_EXTERNAL_STORAGE"]
        read.launch()
        read.waitUntilExit()
        
        let write = Process()
        write.launchPath = stringPath
        write.arguments = ["-d", "shell", "pm", "grant", "\(gameID)", "android.permission.WRITE_EXTERNAL_STORAGE"]
        write.launch()
        write.waitUntilExit()
    }
    
    func pushOBB(gameID: String, usernameFilePath: String, gameFolderName: String, obbName: String) {
        let dir = Process()
        dir.launchPath = stringPath
        dir.arguments = ["-d", "shell", "mkdir", "/sdcard/Android/obb/\(gameID)"]
        dir.launch()
        dir.waitUntilExit()
        
        let push = Process()
        push.launchPath = stringPath
        push.arguments = ["-d", "push", "\(usernameFilePath)/Downloads/Bluebird Stuff/\(gameFolderName)/\(obbName)", "/sdcard/Android/obb/\(gameID)"]
        push.launch()
        push.waitUntilExit()
    }
    
    func pushName(usernameFilePath: String, namePath: String) {
        let name = Process()
        name.launchPath = stringPath
        name.arguments = ["-d", "push", "\(usernameFilePath)/Downloads/Bluebird Stuff/name.txt", "/sdcard\(namePath)"]
        name.launch()
        name.waitUntilExit()
    }
    
    func killADB() {
        let kill = Process()
        kill.launchPath = stringPath
        kill.arguments = ["-d", "kill-server"]
        kill.launch()
        kill.waitUntilExit()
    }
    
    func pushMap(usernameFilePath: String) {
        let map = Process()
        map.launchPath = stringPath
        map.arguments = ["push", "\(usernameFilePath)/Downloads/Android_ASTC.pak", "/sdcard/pavlov/maps/test_map/Android_ASTC.pak"]
        map.launch()
        map.waitUntilExit()
    }
    
    func getPackages() {
        let pipe = Pipe()
        let pkg = Process()
        pkg.launchPath = stringPath
        pkg.arguments = ["shell", "pm", "list", "packages", "-3\"\"|cut", "-f", "2", "-d", "\":\""]
        pkg.standardOutput = pipe
        pkg.launch()
        pkg.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            package = string
        }
    }
    
    func installUserAPK(apkFilePath: String) {
        let apk = Process()
        apk.launchPath = stringPath
        apk.arguments = ["install", "\(apkFilePath)"]
        apk.launch()
        apk.waitUntilExit()
    }
}
