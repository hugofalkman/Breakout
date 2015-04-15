//
//  SettingsViewController.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-12.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var pushMagnLabel: UILabel!
    @IBOutlet weak var pushMagnSlider: UISlider!
    
    @IBOutlet weak var gravitySwitch: UISwitch!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let setting = Settings()
        pushMagnitude = setting.pushMagnitude
        gravity = setting.gravity
    }
    
    // MARK: - View
    
    private let settings = Settings()
    
    private var pushMagnitude: CGFloat {
        get { return CGFloat(pushMagnSlider.value) }
        set {
            pushMagnSlider.value = Float(newValue)
            pushMagnLabel.text = "\(pushMagnSlider.value)"
        }
    }
    
    @IBAction func pushMagnChanged(sender: UISlider) {
        pushMagnitude = CGFloat(sender.value)
        settings.pushMagnitude = pushMagnitude
    }
    
    private var gravity: Bool {
        get { return gravitySwitch.on }
        set { gravitySwitch.on = newValue }
    }
    
    @IBAction func gravityChanged(sender: UISwitch) {
        gravity = sender.on
        settings.gravity = gravity
    }
}





