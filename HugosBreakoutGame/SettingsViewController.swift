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
    
    @IBOutlet weak var brickLevelSegmControl: UISegmentedControl!
    
    @IBOutlet weak var relPaddleLabel: UILabel!
    @IBOutlet weak var relPaddleSlider: UISlider!
    
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
        brickLevel = setting.brickLevel
        relPaddleSize = setting.relPaddleSize
        pushMagnitude = setting.pushMagnitude
        gravity = setting.gravity
    }
    
    // MARK: - View
    
    private let settings = Settings()
    
    @IBAction func resetSettings(sender: UIBarButtonItem) {
        settings.resetSettings()
        brickRows = settings.brickRows
        brickColumns = settings.brickColumns
        brickLevel = settings.brickLevel
        relPaddleSize = settings.relPaddleSize
        pushMagnitude = settings.pushMagnitude
        gravity = settings.gravity
    }
    
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
    
    private var brickLevel: Int {
        get { return brickLevelSegmControl.selectedSegmentIndex }
        set { brickLevelSegmControl.selectedSegmentIndex = newValue }
    }
    
    @IBAction func brickLevelChanged(sender: UISegmentedControl) {
        brickLevel = sender.selectedSegmentIndex
        settings.brickLevel = brickLevel
    }
    
    private var relPaddleSize: CGFloat {
        get { return CGFloat(relPaddleSlider.value) }
        set {
            relPaddleSlider.value = Float(newValue)
            relPaddleLabel.text = "\(relPaddleSlider.value)"
        }
    }
    
    @IBAction func relPaddleChanged(sender: UISlider) {
        relPaddleSize = CGFloat(sender.value)
        settings.relPaddleSize = relPaddleSize
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






