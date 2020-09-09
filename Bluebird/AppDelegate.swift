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
        let destination: DownloadRequest.Destination = { _, _ in
        let documentsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("upsiopts.txt")

        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download("https://thesideloader.co.uk/upsiopts.txt", to: destination).response { response in
        debugPrint(response)

            if response.error == nil, let imagePath = response.fileURL?.path {
            
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let usernameFilePath = NSString(string: "~").expandingTildeInPath
        let txtPath = NSString(string: "~/Downloads/upsiopts.txt").expandingTildeInPath
        let txtDoesExist = FileManager.default.fileExists(atPath: txtPath)
        if txtDoesExist == true {
            do {
                try FileManager.default.removeItem(atPath: "\(usernameFilePath)/Downloads/upsiopts.txt")
            }
            catch {
                print(error)
            }
        }

    }


}

