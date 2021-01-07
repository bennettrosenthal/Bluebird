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
    var zipCheck = String()
    var userApkPath = String()
    var mapPath = String()
    
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
        packageDropDown.isHidden = true
        self.uninstallAppButton.isEnabled = false
        self.pkgPermissionsButton.isEnabled = false
        gameSelectionDropdown.removeAllItems()
        
        let txtPath = NSString(string: "~/Documents/upsiopts.txt").expandingTildeInPath
        let folderPath = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
        let txtDoesExist = FileManager.default.fileExists(atPath: txtPath)
        let folderDoesExist = FileManager.default.fileExists(atPath: folderPath)
        if txtDoesExist == true {
            do {
                try FileManager.default.removeItem(atPath: "\(usernameFilePath)/Documents/upsiopts.txt")
            }
            catch {
                print(error)
            }
        }
        if folderDoesExist == true {
            do {
                try FileManager.default.removeItem(atPath: "\(usernameFilePath)/Documents/Bluebird Stuff")
            }
            catch {
                print(error)
            }
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
        let folderDownloadPath = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
        let folderDownloadURL = URL(fileURLWithPath: folderDownloadPath)
        let fileURL = folderDownloadURL.appendingPathComponent("upsiopts.txt")

        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download("https://pastebin.com/raw/Ar2cKLHE", to: destination).response { response in
        debugPrint(response)

            if response.error == nil {
                do {
                    // defines array from txt file
                    let txtPath: String = "\(self.usernameFilePath)/Documents/Bluebird Stuff/upsiopts.txt"
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
                    
                    if let zipCheckArray = newArray.firstIndex(where: {$0.hasPrefix("ZIP=")}) {
                        let zipCheck1 = self.txtArray[zipCheckArray]
                        let zipCheck2 = zipCheck1.replacingOccurrences(of: "ZIP=", with: "")
                        self.zipCheck = zipCheck2.replacingOccurrences(of: "\r", with: "")
                        print(self.zipCheck)
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
                
                self.gameSelected = self.nameArray[0]
                let gameFilesPath = NSString(string: "~/Documents/\(self.gameFolderName).zip").expandingTildeInPath
                let gameDoesExit = FileManager.default.fileExists(atPath: gameFilesPath)
                    if gameDoesExit == true {
                        self.gameIsPresent = true
                        print("yessir")
                    }

                self.selectionLabel.stringValue = ("What do you want to do with " + self.gameSelected + "?")
            }
        }
        self.downloadProgressIndicator.isHidden = true
        if blessedGameID != "com.vankrupt.pavlov" {
            mapButton.isEnabled = false
        } else {
            mapButton.isEnabled = true
        }
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
    @IBOutlet weak var packageDropDown: NSPopUpButton!
    @IBOutlet weak var uninstallAppButton: NSButton!
    @IBOutlet weak var pkgPermissionsButton: NSButton!
    
    
    @IBAction func gameSelectionDropdownChanged(_ sender: Any) {
        gameSelected = gameSelectionDropdown.titleOfSelectedItem!
        selectionLabel.stringValue = ("What do you want to do with " + gameSelected + "?")
        numOfGameSelected = gameSelectionDropdown.indexOfSelectedItem
        
        // ima be real idk what this means but it works
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
        
        // checking if game is in a zip
        if let zipCheckArray = newArray.firstIndex(where: {$0.hasPrefix("ZIP=")}) {
            let zipCheck1 = self.txtArray[zipCheckArray]
            let zipCheck2 = zipCheck1.replacingOccurrences(of: "ZIP=", with: "")
            self.zipCheck = zipCheck2.replacingOccurrences(of: "\r", with: "")
            print(self.zipCheck)
            print("")
        }
    }
    
    let gameFilesPath = NSString(string: "~/Documents/\(self.gameFolderName).zip").expandingTildeInPath
    let gameDoesExit = FileManager.default.fileExists(atPath: gameFilesPath)
        if gameDoesExit == true {
            gameIsPresent = true
            print("yessir")
        }
        
        if blessedGameID != "com.vankrupt.pavlov" {
            mapButton.isEnabled = false
        } else {
            mapButton.isEnabled = true
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
            
            let gameFilesPath = NSString(string: "~/Documents/\(self.gameFolderName).zip").expandingTildeInPath
            let gameDoesExit = FileManager.default.fileExists(atPath: gameFilesPath)
                if gameDoesExit == true {
                    gameIsPresent = true
                    print("yessir")
                }
            
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
                let tempdir = NSString("~/Documents/Bluebird Stuff").expandingTildeInPath
                let dir = tempdir as NSString
                data.write(toFile: "\(dir)/name.txt", atomically: true)
                
                Dispatch.background {
                    if self.zipCheck != "None" {
                        let zipFolderPath = NSString(string: "~/Documents/\(self.gameFolderName).zip").expandingTildeInPath
                        let folderPath = NSString(string: "~/Documents/\(self.gameFolderName)").expandingTildeInPath
                        SSZipArchive.unzipFile(atPath: zipFolderPath, toDestination: folderPath)
                    }
                Dispatch.main {
                    self.installationLabel.stringValue = "Unzip complete! Time to install " + self.gameSelected + ". Looking for Quest..."
 
                    Dispatch.background {
                        let adb = adbCommands()
                        adb.startADB()
                        self.installationLabel.stringValue = "Quest found! Uninstalling previous version if present..."
                        adb.uninstallGame(gameID: self.blessedGameID)
                        
                        
                        self.installationLabel.stringValue = "Previous version uninstalled! Installing APK..."
                        adb.installAPK(usernameFilePath: self.usernameFilePath, gameFolderName: self.gameFolderName, apkName: self.apkName)
                        
                        self.installationLabel.stringValue = "APK installed! Setting permissions..."
                        adb.grantPermissions(gameID: self.blessedGameID)
                        
                        self.installationLabel.stringValue = "Permissions set! Pushing OBB if present. This may take a while, please be patient!"
                        adb.pushOBB(gameID: self.blessedGameID, usernameFilePath: self.usernameFilePath, gameFolderName: self.gameFolderName, obbName: self.obbName)
                        
                        self.installationLabel.stringValue = "Game installed! Setting name..."
                        adb.pushName(usernameFilePath: self.usernameFilePath, namePath: self.namePath)
                        adb.killADB()
                        
                        self.installationLabel.stringValue = "Name set! Cleaning up files..."
                        let folderPath = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
                        let folderDoesExist = FileManager.default.fileExists(atPath: folderPath)
                        if folderDoesExist == true {
                            do {
                                try FileManager.default.removeItem(atPath: "\(self.usernameFilePath)/Documents/Bluebird Stuff")
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
                        let folderDownloadPath = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
                        let folderDownloadURL = URL(fileURLWithPath: folderDownloadPath)
                        let fileURL = folderDownloadURL.appendingPathComponent("upsiopts.txt")

                        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                        }
                        
                        AF.download("https://pastebin.com/raw/Ar2cKLHE", to: destination).response { response in
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
                let tempdir = NSString("~/Documents/Bluebird Stuff").expandingTildeInPath
                let dir = tempdir as NSString
                data.write(toFile: "\(dir)/name.txt", atomically: true)
                
                // setting destination for alamofire to do its shit
                let destination: DownloadRequest.Destination = { _, _ in
                    var folderURLString = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
                    if self.zipCheck == "None" {
                        folderURLString = NSString(string: "~/Documents/Bluebird Stuff/\(self.gameFolderName)").expandingTildeInPath
                    }
                    
                   let folderPathURL = URL(fileURLWithPath: folderURLString)
                    var fileURL = folderPathURL.appendingPathComponent("\(self.gameFolderName).zip")
                    if self.zipCheck == "None" {
                        fileURL = folderPathURL.appendingPathComponent("\(self.apkName)")
                    }
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
                            if self.zipCheck != "None" {
                                let zipFolderPath = NSString(string: "~/Documents/Bluebird Stuff/\(self.gameFolderName).zip").expandingTildeInPath
                                let folderPath = NSString(string: "~/Documents/Bluebird Stuff/\(self.gameFolderName)").expandingTildeInPath
                                SSZipArchive.unzipFile(atPath: zipFolderPath, toDestination: folderPath)
                            }
                        Dispatch.main {
                            self.installationLabel.stringValue = "Unzip complete! Time to install " + self.gameSelected + ". Looking for Quest..."
                            
                            Dispatch.background {
                                let adb = adbCommands()
                                adb.startADB()
                                self.installationLabel.stringValue = "Quest found! Uninstalling previous version if present..."
                                adb.uninstallGame(gameID: self.blessedGameID)
                                
                                
                                self.installationLabel.stringValue = "Previous version uninstalled! Installing APK..."
                                adb.installAPK(usernameFilePath: self.usernameFilePath, gameFolderName: self.gameFolderName, apkName: self.apkName)
                                
                                self.installationLabel.stringValue = "APK installed! Setting permissions..."
                                adb.grantPermissions(gameID: self.blessedGameID)
                                
                                self.installationLabel.stringValue = "Permissions set! Pushing OBB if present. This may take a while, please be patient!"
                                adb.pushOBB(gameID: self.blessedGameID, usernameFilePath: self.usernameFilePath, gameFolderName: self.gameFolderName, obbName: self.obbName)
                                
                                self.installationLabel.stringValue = "Game installed! Setting name..."
                                adb.pushName(usernameFilePath: self.usernameFilePath, namePath: self.namePath)
                                adb.killADB()
                                
                                self.installationLabel.stringValue = "Name set! Cleaning up files..."
                                let folderPath = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
                                let folderDoesExist = FileManager.default.fileExists(atPath: folderPath)
                                if folderDoesExist == true {
                                    do {
                                        try FileManager.default.removeItem(atPath: "\(self.usernameFilePath)/Documents/Bluebird Stuff")
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
                                let folderDownloadPath = NSString(string: "~/Documents/Bluebird Stuff").expandingTildeInPath
                                let folderDownloadURL = URL(fileURLWithPath: folderDownloadPath)
                                let fileURL = folderDownloadURL.appendingPathComponent("upsiopts.txt")

                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                                }
                                
                                AF.download("https://pastebin.com/raw/Ar2cKLHE", to: destination).response { response in
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
                                self.nameButton.isEnabled = true
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
 
            installationLabel.stringValue = "Uninstalling " + gameSelected + ". Waiting for Quest..."
            Dispatch.background {
                let uninstall = adbCommands()
                uninstall.startADB()
                uninstall.uninstallGame(gameID: self.blessedGameID)
                uninstall.killADB()
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
        let perms = adbCommands()
        perms.startADB()
        perms.grantPermissions(gameID: self.blessedGameID)
        perms.killADB()
        installationLabel.stringValue = "Permissions set for " + gameSelected + "!"
        let seconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.installationLabel.stringValue = ""
           }
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let helpAlert = NSAlert()
        helpAlert.messageText = "What do the buttons do?"
        helpAlert.informativeText = "Install - Downloads and installs the selected game.\n\nGrant Permissions - Grants read, write, and mic permissions to the selected game.\n\nUninstall - Uninstalls the selected game if installed on the Quest.\n\nChange Name - Prompts name entry and sets the name entered as the name for the selected game.\n\nPush Pavlov Map - Opens folder browser which allows for selection of a folder, then pushes the entire folder to \\sdcard\\pavlov\\maps\\ on the Quest. Keep this is mind, as there are no checks if it's a valid Pavlov map!\n\nGet Installed Packages - Gets the current installed games and apps on the Quest, and loads them into a handy dandy dropdown.\n\nInstall APK - Opens a file browser that allows the installation of a chosen APK file.\n\nGrant App Permissions - Grants read, write and microphone permissions to the selected application. Useful if your mic is not working or saves are not saving for a certain game or app.\n\nUninstall Chosen App - Uninstalls the chosen package from the dropdown mentioned earlier. Only accessible after the list is visible."
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
        let tempdir = NSString("~/Documents/Bluebird Stuff").expandingTildeInPath
        let dir = tempdir as NSString
        data.write(toFile: "\(dir)/name.txt", atomically: true)
        
        // send name.txt file to quest
        let name = adbCommands()
        name.startADB()
        name.pushName(usernameFilePath: self.usernameFilePath, namePath: self.namePath)
        name.killADB()
        
        installationLabel.stringValue = "Name set!"
        let seconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.installationLabel.stringValue = ""
           }
    }
    
    @IBAction func mapsButtonPressed(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if result != nil {
                mapPath = result!.path
                installationLabel.stringValue = "Pushing map folder at " + mapPath + "..."
                Dispatch.background {
                    let map = adbCommands()
                    map.pushMap(mapPath: self.mapPath)
                Dispatch.main {
                    self.installationLabel.stringValue = "Map pushed!"
                    }
                }
            }
        } else {
            return
        }
    }
    @IBAction func getAppsButtonPressed(_ sender: Any) {
        refreshPackageList()
    }
    
    
    @IBAction func installAPKButtonPressed(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.allowedFileTypes=["apk"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url
            if result != nil {
                userApkPath = result!.path
                installationLabel.stringValue = "Installing APK at " + userApkPath
                let userAPK = adbCommands()
                Dispatch.background {
                    userAPK.installUserAPK(apkFilePath: self.userApkPath)
                Dispatch.main {
                    self.installationLabel.stringValue = "APK at " + self.userApkPath + " installed!"
                    self.refreshPackageList()
                    }
                }
            }
        } else {
            return
        }
    }
    
    @IBAction func uninstallChosenAppButtonPressed(_ sender: Any) {
        let pkgPicked = packageDropDown.titleOfSelectedItem!
        installationLabel.stringValue = "Uninstalling " + pkgPicked + "..."
        let abd = adbCommands()
        Dispatch.background {
            abd.uninstallGame(gameID: pkgPicked)
        Dispatch.main {
            self.installationLabel.stringValue = pkgPicked + " uninstalled!"
            self.refreshPackageList()
            }
        }
    }
    
    @IBAction func pkgPermissionsButtonPressed(_ sender: Any) {
        let perms = adbCommands()
        let pkgPicked = packageDropDown.titleOfSelectedItem!
        installationLabel.stringValue = "Granting permissions for " + pkgPicked + "..."
        Dispatch.background {
            perms.grantPermissions(gameID: pkgPicked)
        Dispatch.main {
            self.installationLabel.stringValue = "Permissions granted for " + pkgPicked + "!"
            }
        }
    }
    
    
    func refreshPackageList() {
        let pkg = adbCommands()
        pkg.getPackages()
        let packages = pkg.package
        var packageArray = [String]()
        packageArray = packages.components(separatedBy: "\n")
        packageDropDown.removeAllItems()
        for item in packageArray {
            packageDropDown.addItem(withTitle: item)
        }
        packageDropDown.removeItem(at: packageArray.count - 1)
        packageDropDown.isHidden = false
        uninstallAppButton.isEnabled = true
        pkgPermissionsButton.isEnabled = true
    }
}

