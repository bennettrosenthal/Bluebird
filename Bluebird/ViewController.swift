//
//  ViewController.swift
//  Bluebird
//
//  Created by Bennett Rosenthal on 8/20/20.
//  Copyright © 2020 ModernEra. All rights reserved.
//

import Cocoa

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

    @IBOutlet weak var gameSelectionDropdown: NSPopUpButtonCell!
    @IBOutlet weak var statusLabel: NSTextField!
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
        var gameChosen = String()
        gameChosen = gameSelectionDropdown.titleOfSelectedItem!
        statusLabel.stringValue = ("Downloading " + gameChosen + "...")
    }
    
}

