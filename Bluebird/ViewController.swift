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
    var gameSelected = "Pavlov"
    
    // arrays
    var nameArray = [String]()
    var downloadArray = [String]()
    var apkArray = [String]()
    var obbArray = [String]()
    var folderNameArray = [String]()
    
    // for-in counters
    var nameCounter = 0
    var downloadCounter = 0
    var apkCounter = 0
    var obbCounter = 0
    var folderCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installButton.isEnabled = false
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
                    let txtArray: [String] = txtFile.components(separatedBy: "\n")
                    let separator = "END\r"
                    let array = txtArray.split(separator: separator)
        
                    // enable install button
                    self.installButton.isEnabled = true
                    
                    // set dropdown stuff
                    for names in array {
                       if let name = names.firstIndex(where: {$0.hasPrefix("NAME=") }) {
                            let namePrint = txtArray[name]
                            let name2 = namePrint.replacingOccurrences(of: "NAME=", with: "")
                            let name3 = name2.replacingOccurrences(of: "\r", with: "")
                            self.nameCounter += 1
                            self.gameSelectionDropdown.insertItem(withTitle: name3, at: self.nameCounter - 1)
                            self.nameArray.insert(name3, at: self.nameCounter - 1)
                        }
                    }
                    
                    for download in array {
                        if let downloads = download.firstIndex(where: {$0.hasPrefix("DOWNLOADFROM=")}) {
                            let download2 = txtArray[downloads]
                            let download3 = download2.replacingOccurrences(of: "DOWNLOADFROM=", with: "")
                            let download4 = download3.replacingOccurrences(of: "\r", with: "")
                            self.downloadCounter += 1
                            self.downloadArray.insert(download4, at: self.downloadCounter - 1)
                        }
                    }
                    
                    for folder in array {
                        if let folders = folder.firstIndex(where: {$0.hasPrefix("ZIPNAME=")}) {
                            let folders2 = txtArray[folders]
                            let folders3 = folders2.replacingOccurrences(of: "ZIPNAME=", with: "")
                            let folders4 = folders3.replacingOccurrences(of: ".zip", with: "")
                            let folders5 = folders4.replacingOccurrences(of: "\r", with: "")
                            self.folderNameArray.insert(folders5, at: self.folderCounter)
                            self.folderCounter += 1
                        }
                    }
                    print(self.downloadArray)
                    print(self.nameArray)
                    print(self.folderNameArray)
                }
                catch {
                    print(error)
                }
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
    
    
    @IBAction func gameSelectionDropdownChanged(_ sender: Any) {
        gameSelected = gameSelectionDropdown.titleOfSelectedItem!
        selectionLabel.stringValue = ("What do you want to do with " + gameSelected + "?")
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        self.installButton.isEnabled = false
        self.uninstallButton.isEnabled = false
        self.permissionsButton.isEnabled = false
        if gameSelected == nameArray[0] {
            statusLabel.stringValue = "Downloading latest version of Contractors..."
            self.downloadProgressIndicator.isHidden = false
            let destination: DownloadRequest.Destination = { _, _ in
            let contractorsDownloadPath = NSString(string: "~/Downloads/Bluebird Stuff/Contractors").expandingTildeInPath
            let contractorsDownloadURL = URL(fileURLWithPath: contractorsDownloadPath)
                let contractorsFileURL = contractorsDownloadURL.appendingPathComponent("\(self.folderNameArray[0]).zip")
            return (contractorsFileURL, [.removePreviousFile, .createIntermediateDirectories])
                    }

            AF.download(downloadArray[0], to: destination).downloadProgress { progress in
                    self.downloadProgressIndicator.doubleValue = (progress.fractionCompleted * 100)
            }.response { response in
                debugPrint(response)

                if response.error == nil {
                    self.statusLabel.stringValue = "Download Complete! Unzipping Now..."
                    self.downloadProgressIndicator.isHidden = true
                    Dispatch.background {
                        let zipFolderPath = NSString(string: "~/Downloads/Bluebird Stuff/Contractors/\(self.folderNameArray[0]).zip").expandingTildeInPath
                        let folderPath = NSString(string: "~/Downloads/Bluebird Stuff/Contractors/\(self.folderNameArray[0])").expandingTildeInPath
                        do {
                            let isFileUnzipped = try SSZipArchive.unzipFile(atPath: zipFolderPath, toDestination: folderPath)
                            print(isFileUnzipped)
                        }
                        catch {
                            print(error)
                        }
                    Dispatch.main {
                        self.statusLabel.stringValue = "Game files downloaded and unzipped! Looking for Quest..."
                        // adb stuff here
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
                         _ = shell("devices")
                            self.statusLabel.stringValue = "Quest found! Uninstalling previous version..."
                         _ = shell("uninstall", "com.CaveManStudio.ContractorsVR")
                        Dispatch.main {
                            self.statusLabel.stringValue = "\(self.gameSelected) is now installed!"
                            self.installButton.isEnabled = true
                            self.uninstallButton.isEnabled = true
                            self.permissionsButton.isEnabled = true
                              }
                             }
                            }
                          }
                        }
                      }
                    }
        if gameSelected == "Pavlov" {
            
        }
        if gameSelected == "Hi-Bow" {
            
        }
      }
    }
