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
    
    @IBOutlet weak var brickRowLabel: UILabel!
    @IBOutlet weak var brickRowStepper: UIStepper!
   
    @IBOutlet weak var brickColumnLabel: UILabel!
    @IBOutlet weak var brickColumnStepper: UIStepper!
    
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
        brickRows = setting.brickRows
        brickColumns = setting.brickColumns
        pushMagnitude = setting.pushMagnitude
        gravity = setting.gravity
    }
    
    // MARK: - View
    
    private let settings = Settings()
    
    private var brickRows: Int {
        get { return Int(brickRowStepper.value) }
        set {
            brickRowStepper.value = Double(newValue)
            brickRowLabel.text = "\(newValue)"
        }
    }
    
    @IBAction func brickRowChanged(sender: UIStepper) {
        brickRows = Int(sender.value)
        settings.brickRows = brickRows
    }
    
    private var brickColumns: Int {
        get { return Int(brickColumnStepper.value) }
        set {
            brickColumnStepper.value = Double(newValue)
            brickColumnLabel.text = "\(newValue)"
        }
    }
    
    @IBAction func brickColumnChanged(sender: UIStepper) {
        brickColumns = Int(sender.value)
        settings.brickColumns = brickColumns
    }
    
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






