//
//  AppDelegate.swift
//  Bluebird
//
//  Copyright © 2020 ModernEra. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let usernameFilePath = NSString(string: "~").expandingTildeInPath
        
            }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let usernameFilePath = NSString(string: "~").expandingTildeInPath
        let txtPath = NSString(string: "~/Downloads/upsiopts.txt").expandingTildeInPath
        let folderPath = NSString(string: "~/Downloads/Bluebird Stuff").expandingTildeInPath
        let txtDoesExist = FileManager.default.fileExists(atPath: txtPath)
        let folderDoesExist = FileManager.default.fileExists(atPath: folderPath)
        print(folderDoesExist)
        if txtDoesExist == true {
            do {
                try FileManager.default.removeItem(atPath: "\(usernameFilePath)/Downloads/upsiopts.txt")
            }
            catch {
                print(error)
            }
        }
        if folderDoesExist == true {
            do {
                try FileManager.default.removeItem(atPath: "\(usernameFilePath)/Downloads/Bluebird Stuff")
            }
            catch {
                print(error)
            }
        }


    }


}

