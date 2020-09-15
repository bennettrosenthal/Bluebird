//
//  ViewController.swift
//  Bluebird
//
//  Copyright © 2020 ModernEra. All rights reserved.
//

import Cocoa
import Foundation
import Alamofire
import SSZipArchive
import Zip

class ViewController: NSViewController {
    // universal variables
    let usernameFilePath = NSString(string: "~").expandingTildeInPath
    var gameSelected = String()
    var numOfGameSelected = 0
    
    var obbName = String()
    var gameURL = String()
    var gameFolderName = String()
    var apkName = String()
    var gameID = String()
    
    // arrays
    var array = [Array<String>.SubSequence]()
    var txtArray = [String]()
    var nameArray = [String]()
    
    // for-in counter
    var nameCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installButton.isEnabled = false
        self.uninstallButton.isEnabled = false
        self.permissionsButton.isEnabled = false
        gameSelectionDropdown.removeAllItems()
        let destination: DownloadRequest.Destination = { _, _ in
        let folderDownloadPath = NSString(string: "~/Downloads/Bluebird Stuff").expandingTildeInPath
        let folderDownloadURL = URL(fileURLWithPath: folderDownloadPath)
        let fileURL = folderDownloadURL.appendingPathComponent("upsiopts.txt")

        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download("https://thesideloader.co.uk/upsiopts.txt", to: destination).response { response in
        debugPrint(response)

            if response.error == nil {
                do {
                    // defines array from txt file
                    let txtPath: String = "\(self.usernameFilePath)/Downloads/Bluebird Stuff/upsiopts.txt"
                    let txtFile = try String(contentsOfFile: txtPath)
                    self.txtArray = txtFile.components(separatedBy: "\n")
                    let separator = "END\r"
                    self.array = self.txtArray.split(separator: separator)
        
                    // enable buttons
                    self.installButton.isEnabled = true
                    self.uninstallButton.isEnabled = true
                    self.permissionsButton.isEnabled = true
                    
                    // set dropdown stuff
                    for names in self.array {
                       if let name = names.firstIndex(where: {$0.hasPrefix("NAME=") }) {
                        let namePrint = self.txtArray[name]
                            let name2 = namePrint.replacingOccurrences(of: "NAME=", with: "")
                            let name3 = name2.replacingOccurrences(of: "\r", with: "")
                            self.nameCounter += 1
                            self.gameSelectionDropdown.insertItem(withTitle: name3, at: self.nameCounter - 1)
                            self.nameArray.insert(name3, at: self.nameCounter - 1)
                        }
                    }
                    // just makin sure
                    print(self.nameArray)
                    
                    // ok time to get details; this array is the subsect of the selected game from earlier
                    let newArray = self.array[self.numOfGameSelected]
                    
                    // gets download URL for selected game
                     if let downloadURLNumber = newArray.firstIndex(where: {$0.hasPrefix("DOWNLOADFROM=") }) {
                     let downloadURL1 = self.txtArray[downloadURLNumber]
                     let downloadURL2 = downloadURL1.replacingOccurrences(of: "DOWNLOADFROM=", with: "")
                     self.gameURL = downloadURL2.replacingOccurrences(of: "\r", with: "")
                     print(self.gameURL)
                    }
                    
                    // gets obb file name for selected game
                    if let obbNameNumber = newArray.firstIndex(where: {$0.hasPrefix("OBB=")}) {
                        let obbName1 = self.txtArray[obbNameNumber]
                        let obbName2 = obbName1.replacingOccurrences(of: "OBB=", with: "")
                        self.obbName = obbName2.replacingOccurrences(of: "\r", with: "")
                        print(self.obbName)
                    }
                    
                    // gets game folder name for selected game
                    if let gameFolderNumber = newArray.firstIndex(where: {$0.hasPrefix("ZIPNAME=")}) {
                        let folderName1 = self.txtArray[gameFolderNumber]
                        let folderName2 = folderName1.replacingOccurrences(of: "ZIPNAME=", with: "")
                        let folderName3 = folderName2.replacingOccurrences(of: ".zip", with: "")
                        self.gameFolderName = folderName3.replacingOccurrences(of: "\r", with: "")
                        print(self.gameFolderName)
                    }
                    
                    // gets game ID
                    if let gameIDNumber = newArray.firstIndex(where: {$0.hasPrefix("COMOBJECT=")}) {
                        let gameID1 = self.txtArray[gameIDNumber]
                        let gameID2 = gameID1.replacingOccurrences(of: "COMOBJECT=", with: "")
                        self.gameID = gameID2.replacingOccurrences(of: "/r", with: "")
                        print(self.gameID)
                    }
                    
                    // gets apk file name for selected game
                    if let apkNameNumber = newArray.firstIndex(where: {$0.hasPrefix("APK=")}) {
                        let apkName1 = self.txtArray[apkNameNumber]
                        let apkName2 = apkName1.replacingOccurrences(of: "APK=", with: "")
                        self.apkName = apkName2.replacingOccurrences(of: "\r", with: "")
                        print(self.apkName)
                        print("")
                    }
                }
                catch {
                    print(error)
                }
                self.gameSelected = self.nameArray[0]
                self.selectionLabel.stringValue = ("What do you want to do with " + self.gameSelected + "?")
            }
        }
        self.downloadProgressIndicator.isHidden = true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var selectionLabel: NSTextField!
    @IBOutlet weak var gameSelectionDropdown: NSPopUpButtonCell!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var uninstallButton: NSButton!
    @IBOutlet weak var downloadProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var installButton: NSButton!
    @IBOutlet weak var permissionsButton: NSButton!
    @IBOutlet weak var installationLabel: NSTextField!
    
    
    @IBAction func gameSelectionDropdownChanged(_ sender: Any) {
        gameSelected = gameSelectionDropdown.titleOfSelectedItem!
        selectionLabel.stringValue = ("What do you want to do with " + gameSelected + "?")
        numOfGameSelected = gameSelectionDropdown.indexOfSelectedItem
        
        // ima be real idk what the fuck this means but it works
        if gameSelectionDropdown.titleOfSelectedItem == nameArray[numOfGameSelected] {
         let newArray = self.array[numOfGameSelected]
        
        // getting download URL for newly selected game
         if let downloadURLNumber = newArray.firstIndex(where: {$0.hasPrefix("DOWNLOADFROM=")}) {
            let downloadURL1 = txtArray[downloadURLNumber]
            let downloadURL2 = downloadURL1.replacingOccurrences(of: "DOWNLOADFROM=", with: "")
            gameURL = downloadURL2.replacingOccurrences(of: "\r", with: "")
            print(gameURL)
         }
        
        // getting obb file name for newly selected game
        if let obbNameNumber = newArray.firstIndex(where: {$0.hasPrefix("OBB=")}) {
            let obbName1 = self.txtArray[obbNameNumber]
            let obbName2 = obbName1.replacingOccurrences(of: "OBB=", with: "")
            self.obbName = obbName2.replacingOccurrences(of: "\r", with: "")
            print(self.obbName)
        }
        
        // getting game folder name for newly selected game
        if let gameFolderNumber = newArray.firstIndex(where: {$0.hasPrefix("ZIPNAME=")}) {
            let folderName1 = self.txtArray[gameFolderNumber]
            let folderName2 = folderName1.replacingOccurrences(of: "ZIPNAME=", with: "")
            let folderName3 = folderName2.replacingOccurrences(of: ".zip", with: "")
            self.gameFolderName = folderName3.replacingOccurrences(of: "\r", with: "")
            print(self.gameFolderName)
        }
            
        // getting game ID
        if let gameIDNumber = newArray.firstIndex(where: {$0.hasPrefix("COMOBJECT=")}) {
            let gameID1 = self.txtArray[gameIDNumber]
            let gameID2 = gameID1.replacingOccurrences(of: "COMOBJECT=", with: "")
            let gameID3 = gameID2.replacingOccurrences(of: "\n", with: "")
            self.gameID = gameID3.replacingOccurrences(of: "\r", with: "")
            print(self.gameID)
        }
        
        // getting apk name for newly selected game
        if let apkNameNumber = newArray.firstIndex(where: {$0.hasPrefix("APK=")}) {
            let apkName1 = self.txtArray[apkNameNumber]
            let apkName2 = apkName1.replacingOccurrences(of: "APK=", with: "")
            self.apkName = apkName2.replacingOccurrences(of: "\r", with: "")
            print(self.apkName)
            print("")
        }
    }
}
        @IBAction func goButtonPressed(_ sender: Any) {
            // hiding buttons to prevent self-destruction
            self.installButton.isEnabled = false
            self.uninstallButton.isEnabled = false
            self.permissionsButton.isEnabled = false
            self.gameSelectionDropdown.isEnabled = false
            self.downloadProgressIndicator.isHidden = false
            self.selectionLabel.isHidden = true
            self.installationLabel.stringValue = ("Downloading " + self.gameSelected + ".")
            
            // setting destination for alamofire to do its shit
            let destination: DownloadRequest.Destination = { _, _ in
               let folderURLString = NSString(string: "~/Downloads/Bluebird Stuff").expandingTildeInPath
               let folderPathURL = URL(fileURLWithPath: folderURLString)
               let fileURL = folderPathURL.appendingPathComponent("\(self.gameFolderName).zip")
               return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                    }
            
            // alamofire does its shit
            AF.download(gameURL, to: destination).downloadProgress { progress in
                    self.downloadProgressIndicator.doubleValue = (progress.fractionCompleted * 100)
            }.response { response in
                debugPrint(response)

                if response.error == nil {
                    self.downloadProgressIndicator.isHidden = true
                    self.downloadProgressIndicator.doubleValue = 0
                    self.installationLabel.stringValue = (self.gameSelected + " downloaded! Unzipping game files...")
                    
                    // unzip game files
                    Dispatch.background {
                        let zipFolderPath = NSString(string: "~/Downloads/Bluebird Stuff/\(self.gameFolderName).zip").expandingTildeInPath
                        let folderPath = NSString(string: "~/Downloads/Bluebird Stuff/\(self.gameFolderName)").expandingTildeInPath
                        SSZipArchive.unzipFile(atPath: zipFolderPath, toDestination: folderPath)
                    Dispatch.main {
                        self.installationLabel.stringValue = "Unzip complete! Time to install " + self.gameSelected + ". Looking for Quest..."
                        
                        // bougie? maybe. Does it work? I think so. ADB time bitches
                        let stringPath = Bundle.main.path(forResource: "adb", ofType: "")
                        @discardableResult
                        func shell(_ args: String...) -> Int32 {
                            let task = Process()
                            task.launchPath = stringPath
                            task.arguments = args
                            task.launch()
                            task.waitUntilExit()
                            return task.terminationStatus
                        }
                        
                        Dispatch.background {
                            _ = shell("-d", "devices")
                            self.installationLabel.stringValue = "Quest found! Uninstalling previous version if present..."
                            _ = shell("-d", "uninstall", "\(self.gameID)")
                            
                            self.installationLabel.stringValue = "Previous version uninstalled! Installing APK..."
                            _ = shell("-d", "install", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/\(self.gameFolderName)/\(self.apkName)")
                            
                            self.installationLabel.stringValue = "APK installed! Pushing OBB if present. This may take a while, please be patient!"
                            _ = shell("-d", "shell", "mkdir", "/sdcard/Android/obb/\(self.gameID)")
                            _ = shell("-d", "push", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/\(self.gameFolderName)/\(self.obbName)", "/sdcard/Android/obb/\(self.gameID)")
                            
                            self.installationLabel.stringValue = "OBB pushed! Setting name and permissions..."
                            _ = shell("-d", "shell", "pm", "grant", "\(self.gameID)", "android.permission.RECORD_AUDIO")
                            _ = shell("-d", "shell", "pm", "grant", "\(self.gameID)", "android.permission.READ_EXTERNAL_STORAGE")
                            _ = shell("-d", "shell", "pm", "grant", "\(self.gameID)", "android.permission.WRITE_EXTERNAL_STORAGE")
                            _ = shell("-d", "kill-server")
                            
                            self.installationLabel.stringValue = "Game installed! Cleaning up files..."
                            let folderPath = NSString(string: "~/Downloads/Bluebird Stuff").expandingTildeInPath
                            let folderDoesExist = FileManager.default.fileExists(atPath: folderPath)
                            
                            if folderDoesExist == true {
                                do {
                                    try FileManager.default.removeItem(atPath: "\(self.usernameFilePath)/Downloads/Bluebird Stuff")
                                }
                                catch {
                                    print(error)
                                }
                            }

                            
                        Dispatch.main {
                            self.installationLabel.stringValue = "\(self.gameSelected) has been installed!"
                            
                            let destination: DownloadRequest.Destination = { _, _ in
                            let folderDownloadPath = NSString(string: "~/Downloads/Bluebird Stuff").expandingTildeInPath
                            let folderDownloadURL = URL(fileURLWithPath: folderDownloadPath)
                            let fileURL = folderDownloadURL.appendingPathComponent("upsiopts.txt")

                            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }
                            
                            AF.download("https://thesideloader.co.uk/upsiopts.txt", to: destination).response { response in
                            debugPrint(response)
                            }
                            
                            self.installButton.isEnabled = true
                            self.uninstallButton.isEnabled = true
                            self.permissionsButton.isEnabled = true
                            self.gameSelectionDropdown.isEnabled = true
                            self.downloadProgressIndicator.isHidden = true
                            self.selectionLabel.isHidden = false
                            }
                        }
                        
                        }
                    }
                }
             }
          }
       }

