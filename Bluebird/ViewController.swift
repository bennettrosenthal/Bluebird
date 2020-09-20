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

extension StringProtocol {
       var asciiValues: [UInt8] { compactMap(\.asciiValue) }
   }

class ViewController: NSViewController {
    // universal variables
    let usernameFilePath = NSString(string: "~").expandingTildeInPath
    var gameSelected = String()
    var numOfGameSelected = 0
    var gameIsPresent = false
    
    var obbName = String()
    var gameURL = String()
    var gameFolderName = String()
    var apkName = String()
    var gameID = String()
    var blessedGameID = String()
    var name = String()
    var namePath = String()
    
    // arrays
    var array = [Array<String>.SubSequence]()
    var txtArray = [String]()
    var nameArray = [String]()
    
    // for-in counter
    var nameCounter = 0
    
    // alert
    var alert = NSAlert()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installButton.isEnabled = false
        self.uninstallButton.isEnabled = false
        self.permissionsButton.isEnabled = false
        self.nameButton.isEnabled = false
        self.permissionsButton.isEnabled = false
        self.mapButton.isEnabled = false
        indeterminiteProgressBar.isHidden = true
        gameSelectionDropdown.removeAllItems()
        
        let txtPath = NSString(string: "~/Downloads/upsiopts.txt").expandingTildeInPath
        let folderPath = NSString(string: "~/Downloads/Bluebird Stuff").expandingTildeInPath
        let txtDoesExist = FileManager.default.fileExists(atPath: txtPath)
        let folderDoesExist = FileManager.default.fileExists(atPath: folderPath)
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
                    
                    // getting name path for selected game
                    if let gameFolderNumber = newArray.firstIndex(where: {$0.hasPrefix("INPUTFILENAME=")}) {
                        let folderName1 = self.txtArray[gameFolderNumber]
                        let folderName2 = folderName1.replacingOccurrences(of: "INPUTFILENAME=", with: "")
                        let folderName3 = folderName2.replacingOccurrences(of: ".zip", with: "")
                        self.namePath = folderName3.replacingOccurrences(of: "\r", with: "")
                        print(self.namePath)
                    }
                    
                    // gets game ID
                    if let gameIDNumber = newArray.firstIndex(where: {$0.hasPrefix("COMOBJECT=")}) {
                        let gameID1 = self.txtArray[gameIDNumber]
                        let gameID2 = gameID1.replacingOccurrences(of: "COMOBJECT=", with: "")
                        self.gameID = gameID2.replacingOccurrences(of: "\r", with: "")
                        self.blessedGameID = self.gameID
                        print(self.blessedGameID)
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
                // enable buttons
                self.installButton.isEnabled = true
                self.uninstallButton.isEnabled = true
                self.permissionsButton.isEnabled = true
                self.nameButton.isEnabled = true
                self.permissionsButton.isEnabled = true
                self.mapButton.isEnabled = true
                
                self.gameSelected = self.nameArray[0]
                let gameFilesPath = NSString(string: "~/Downloads/Bluebird Stuff/\(self.gameFolderName).zip").expandingTildeInPath
                let gameDoesExit = FileManager.default.fileExists(atPath: gameFilesPath)
                    if gameDoesExit == true {
                        self.gameIsPresent = true
                        print("yessir")
                    }

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
    @IBOutlet weak var indeterminiteProgressBar: NSProgressIndicator!
    @IBOutlet weak var nameButton: NSButton!
    @IBOutlet weak var mapButton: NSButton!
    
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
            
        // getting name path for newly selected game
        if let gameFolderNumber = newArray.firstIndex(where: {$0.hasPrefix("INPUTFILENAME=")}) {
            let folderName1 = self.txtArray[gameFolderNumber]
            let folderName2 = folderName1.replacingOccurrences(of: "INPUTFILENAME=", with: "")
            let folderName3 = folderName2.replacingOccurrences(of: ".zip", with: "")
            self.namePath = folderName3.replacingOccurrences(of: "\r", with: "")
            print(self.namePath)
        }
            
        // getting game ID
        if let gameIDNumber = newArray.firstIndex(where: {$0.hasPrefix("COMOBJECT=")}) {
            let gameID1 = txtArray[gameIDNumber]
            let gameID2 = gameID1.replacingOccurrences(of: "COMOBJECT=", with: "")
            gameID = gameID2.replacingOccurrences(of: "\r", with: "")
            blessedGameID = gameID
            print(blessedGameID)
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
    
    let gameFilesPath = NSString(string: "~/Downloads/Bluebird Stuff/\(self.gameFolderName).zip").expandingTildeInPath
    let gameDoesExit = FileManager.default.fileExists(atPath: gameFilesPath)
        if gameDoesExit == true {
            gameIsPresent = true
            print("yessir")
        }
        
}
        @IBAction func goButtonPressed(_ sender: Any) {
            // hiding buttons to prevent self-destruction
            self.installButton.isEnabled = false
            self.uninstallButton.isEnabled = false
            self.permissionsButton.isEnabled = false
            self.gameSelectionDropdown.isEnabled = false
            self.downloadProgressIndicator.isHidden = false
            self.statusLabel.isHidden = true
            self.mapButton.isEnabled = false
            self.nameButton.isEnabled = false
            self.selectionLabel.isHidden = true
            
            if gameIsPresent == true {
                self.downloadProgressIndicator.isHidden = true
                self.indeterminiteProgressBar.isHidden = false
                self.indeterminiteProgressBar.startAnimation(self)
                self.installationLabel.stringValue = "Looks like you already have the game files for " + gameSelected + " downloaded. Unzipping them now..."
                
                // get in-game name from user
                alert.messageText = "Enter Name"
                alert.informativeText = "Enter the name you would like in-game."
                alert.addButton(withTitle: "OK")
                let textfield = NSTextField(frame: NSRect(x: 0.0, y: 0.0, width: 100.0, height: 24.0))
                textfield.alignment = .center
                alert.accessoryView = textfield
                let modalResult = alert.runModal()
                if modalResult == .alertFirstButtonReturn {
                    self.name = textfield.stringValue
                }
                print(self.name)
                
                // make name.txt file
                let data:NSData = self.name.data(using: String.Encoding.utf8)! as NSData
                let tempdir = NSString("~/Downloads/Bluebird Stuff").expandingTildeInPath
                let dir = tempdir as NSString
                data.write(toFile: "\(dir)/name.txt", atomically: true)
                
                Dispatch.background {
                    let zipFolderPath = NSString(string: "~/Downloads/Bluebird Stuff/\(self.gameFolderName).zip").expandingTildeInPath
                    let folderPath = NSString(string: "~/Downloads/Bluebird Stuff/\(self.gameFolderName)").expandingTildeInPath
                    SSZipArchive.unzipFile(atPath: zipFolderPath, toDestination: folderPath)
                Dispatch.main {
                    self.installationLabel.stringValue = "Unzip complete! Time to install " + self.gameSelected + ". Looking for Quest..."
                    
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
                        _ = shell("uninstall", "\(self.blessedGameID)")
                        
                        
                        self.installationLabel.stringValue = "Previous version uninstalled! Installing APK..."
                        _ = shell("-d", "install", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/\(self.gameFolderName)/\(self.apkName)")
                        
                        self.installationLabel.stringValue = "APK installed! Setting permissions..."
                        _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.RECORD_AUDIO")
                        _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.READ_EXTERNAL_STORAGE")
                        _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.WRITE_EXTERNAL_STORAGE")
                        
                        self.installationLabel.stringValue = "Permissions set! Pushing OBB if present. This may take a while, please be patient!"
                        _ = shell("-d", "shell", "mkdir", "/sdcard/Android/obb/\(self.blessedGameID)")
                        _ = shell("-d", "push", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/\(self.gameFolderName)/\(self.obbName)", "/sdcard/Android/obb/\(self.blessedGameID)")
                        
                        self.installationLabel.stringValue = "Game installed! Setting name..."
                        _ = shell("-d", "push", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/name.txt", "/sdcard\(self.namePath)")
                        _ = shell("-d", "kill-server")
                        
                        self.installationLabel.stringValue = "Name set! Cleaning up files..."
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
                        let seconds = 10.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.installationLabel.stringValue = ""
                           }
                        
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
                        self.mapButton.isEnabled = true
                        self.nameButton.isEnabled = true
                        self.downloadProgressIndicator.isHidden = true
                        self.selectionLabel.isHidden = false
                        self.indeterminiteProgressBar.stopAnimation(self)
                        self.indeterminiteProgressBar.isHidden = true
                          }
                       }
                    }
                }
            } else {
                self.installationLabel.stringValue = ("Downloading " + self.gameSelected + ".")
                
                // get in-game name from user
                alert.messageText = "Enter Name"
                alert.informativeText = "Enter the name you would like in-game."
                alert.addButton(withTitle: "OK")
                let textfield = NSTextField(frame: NSRect(x: 0.0, y: 0.0, width: 100.0, height: 24.0))
                textfield.alignment = .center
                alert.accessoryView = textfield
                let modalResult = alert.runModal()
                if modalResult == .alertFirstButtonReturn {
                    self.name = textfield.stringValue
                }
                print(self.name)
                
                // make name.txt file
                let data:NSData = self.name.data(using: String.Encoding.utf8)! as NSData
                let tempdir = NSString("~/Downloads/Bluebird Stuff").expandingTildeInPath
                let dir = tempdir as NSString
                data.write(toFile: "\(dir)/name.txt", atomically: true)
                
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
                        self.indeterminiteProgressBar.isHidden = false
                        self.indeterminiteProgressBar.startAnimation(self)
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
                                _ = shell("uninstall", "\(self.blessedGameID)")
                                
                                
                                self.installationLabel.stringValue = "Previous version uninstalled! Installing APK..."
                                _ = shell("-d", "install", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/\(self.gameFolderName)/\(self.apkName)")
                                
                                self.installationLabel.stringValue = "APK installed! Setting permissions..."
                                _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.RECORD_AUDIO")
                                _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.READ_EXTERNAL_STORAGE")
                                _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.WRITE_EXTERNAL_STORAGE")
                                
                                self.installationLabel.stringValue = "Permissions set! Pushing OBB if present. This may take a while, please be patient!"
                                _ = shell("-d", "shell", "mkdir", "/sdcard/Android/obb/\(self.blessedGameID)")
                                _ = shell("-d", "push", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/\(self.gameFolderName)/\(self.obbName)", "/sdcard/Android/obb/\(self.blessedGameID)")
                                
                                self.installationLabel.stringValue = "Game installed! Setting name..."
                                _ = shell("-d", "push", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/name.txt", "/sdcard\(self.namePath)")
                                _ = shell("-d", "kill-server")
                                
                                self.installationLabel.stringValue = "Name set! Cleaning up files..."
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
                                let seconds = 10.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                    self.installationLabel.stringValue = ""
                                   }
                                
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
                                self.statusLabel.isHidden = false
                                self.permissionsButton.isEnabled = true
                                self.mapButton.isEnabled = true
                                self.indeterminiteProgressBar.stopAnimation(self)
                                self.indeterminiteProgressBar.isHidden = true
                                  }
                               }
                            }
                        }
                    }
                 }
              }
           }
    
    var clickAmount = 0
    @IBAction func uninstallButtonPressed(_ sender: Any) {
        clickAmount += 1
        if clickAmount == 1 {
            uninstallButton.title = "Are you sure?"
            let seconds = 10.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.uninstallButton.title = "Uninstall"
                self.clickAmount = 0
            }
        }
        
        if clickAmount == 2 {
            indeterminiteProgressBar.startAnimation(self)
            indeterminiteProgressBar.isHidden = false
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
                   
            installationLabel.stringValue = "Uninstalling " + gameSelected + ". Waiting for Quest..."
            Dispatch.background {
                _ = shell("devices")
                _ = shell("-d", "uninstall", "\(self.blessedGameID)")
                _ = shell("-d", "kill-server")
            Dispatch.main {
                self.installationLabel.stringValue = self.gameSelected + " uninstalled!"
                self.indeterminiteProgressBar.stopAnimation(self)
                self.indeterminiteProgressBar.isHidden = true
                let seconds = 10.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.installationLabel.stringValue = ""
                   }
                }
            }
        }
    }
    
    @IBAction func permissionsButtonPressed(_ sender: Any) {
        installationLabel.stringValue = "Setting permissions for " + gameSelected + ". Waiting for Quest..."
        
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
        
        _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.RECORD_AUDIO")
        _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.READ_EXTERNAL_STORAGE")
        _ = shell("-d", "shell", "pm", "grant", "\(self.blessedGameID)", "android.permission.WRITE_EXTERNAL_STORAGE")
        
        installationLabel.stringValue = "Permissions set for " + gameSelected + "!"
        let seconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.installationLabel.stringValue = ""
           }
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let helpAlert = NSAlert()
        helpAlert.messageText = "What do the buttons do?"
        helpAlert.informativeText = "Install - Downloads and installs the selected game, or installs previously downloaded files of the selected game placed in ~/Downloads/Bluebird Stuff/ if present.\n\nGrant Permissions - Grants read, write, and mic permissions to the selected game.\n\nUninstall - Uninstalls the selected game if installed on the Quest.\n\nChange Name - Prompts name entry and sets the name entered as the name for the selected game.\n\nPush Pavlov Map - Sends the Android_ASTC.pak file, if present in ~/Downloads/Bluebird Stuff/, to /sdcard/pavlov/maps/test_map on the Quest."
        helpAlert.runModal()
    }
    
    @IBAction func nameButtonPressed(_ sender: Any) {
        // get in-game name from user
        alert.messageText = "Enter Name"
        alert.informativeText = "Enter the name you would like in-game."
        alert.addButton(withTitle: "OK")
        let textfield = NSTextField(frame: NSRect(x: 0.0, y: 0.0, width: 100.0, height: 24.0))
        textfield.alignment = .center
        alert.accessoryView = textfield
        let modalResult = alert.runModal()
        if modalResult == .alertFirstButtonReturn {
            self.name = textfield.stringValue
        }
        print(self.name)
        
        // make name.txt file
        let data:NSData = self.name.data(using: String.Encoding.utf8)! as NSData
        let tempdir = NSString("~/Downloads/Bluebird Stuff").expandingTildeInPath
        let dir = tempdir as NSString
        data.write(toFile: "\(dir)/name.txt", atomically: true)
        
        // send name.txt file to quest
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
        _ = shell("-d", "push", "\(self.usernameFilePath)/Downloads/Bluebird Stuff/name.txt", "/sdcard\(self.namePath)")
        
        installationLabel.stringValue = "Name set!"
        let seconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.installationLabel.stringValue = ""
           }
    }
    
    @IBAction func mapsButtonPressed(_ sender: Any) {
        let stringPath = Bundle.main.path(forResource: "adb", ofType: "")
        let path = NSString(string: "~/Downloads/Bluebird Stuff/Android_ASTC.pak").expandingTildeInPath
        let fileDoesExist = FileManager.default.fileExists(atPath: path)
        if fileDoesExist == false {
            installationLabel.stringValue = "Android_ASTC.pak not found in ~/Downloads/Bluebird Stuff"
            let seconds = 10.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.installationLabel.stringValue = ""
            }
        } else {
            installationLabel.stringValue = "Pushing Android_ATSC.pak..."
        
            @discardableResult
            func shell(_ args: String...) -> Int32 {
            let task = Process()
            task.launchPath = stringPath
            task.arguments = args
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
            }

            self.indeterminiteProgressBar.startAnimation(self)
            self.indeterminiteProgressBar.isHidden = false
            
            Dispatch.background {
                _ = shell("push", "\(self.usernameFilePath)/Downloads/Android_ASTC.pak", "/sdcard/pavlov/maps/test_map/Android_ASTC.pak")
                _ = shell("-d", "kill-server")
                Dispatch.main {
                    self.installationLabel.stringValue = "Test map pushed!"
                    self.indeterminiteProgressBar.stopAnimation(self)
                    self.indeterminiteProgressBar.isHidden = true
                    let seconds = 10.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self.installationLabel.stringValue = ""
                }
              }
            }
          }
        }
      }

