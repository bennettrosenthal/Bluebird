//
//  ViewController.swift
//  Bluebird
//
//  Created by Bennett Rosenthal on 8/20/20.
//  Copyright © 2020 ModernEra. All rights reserved.
//

import Cocoa
import Foundation
import Alamofire
import SSZipArchive

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func gameSelectionDropdownChanged(_ sender: Any) {
        var gameChosen = String()
        gameChosen = gameSelectionDropdown.titleOfSelectedItem!
        selectionLabel.stringValue = ("What do you want to do with " + gameChosen + "?")
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        var gameChosen = String()
        gameChosen = gameSelectionDropdown.titleOfSelectedItem!
        statusLabel.stringValue = ("Downloading " + gameChosen + "...")
    }
    var amount = 0
    @IBAction func uninstallButtonPressed(_ sender: Any) {
        amount += 1
        if amount == 1 {
            uninstallButton.title = "Are you sure?"
        }
        print(amount)
        if amount == 2 {
            uninstallButton.title = "Uninstalling..."
        }
    }
}

