//
//  Settings.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-12.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class Settings
{
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var brickRows: Int {
        get {return defaults.objectForKey(Constants.brickRowKey) as? Int ?? Constants.brickRowDefault}
        set {defaults.setObject(newValue, forKey: Constants.brickRowKey) }
    }
    
    var brickColumns: Int {
        get {return defaults.objectForKey(Constants.brickColumnKey) as? Int ?? Constants.brickColumnDefault}
        set {defaults.setObject(newValue, forKey: Constants.brickColumnKey) }
    }
    
    var brickLevel: Int {
        get {return defaults.objectForKey(Constants.brickLevelKey) as? Int ?? Constants.brickLevelDefault}
        set {defaults.setObject(newValue, forKey: Constants.brickLevelKey) }
    }
    
    var relPaddleSize: CGFloat {
        get {return defaults.objectForKey(Constants.relPaddleKey) as? CGFloat ?? Constants.relPaddleDefault}
        set {defaults.setObject(newValue, forKey: Constants.relPaddleKey) }
    }
    
    var pushMagnitude: CGFloat {
        get {return defaults.objectForKey(Constants.pushMagnKey) as? CGFloat ?? Constants.pushMagnDefault}
        set {defaults.setObject(newValue, forKey: Constants.pushMagnKey) }
    }
    
    var gravity: Bool {
        get {return defaults.objectForKey(Constants.gravityKey) as? Bool ?? Constants.gravityDefault}
        set {defaults.setObject(newValue, forKey: Constants.gravityKey) }
    }
    
    func resetSettings() {
        brickRows = Constants.brickRowDefault
        brickColumns = Constants.brickColumnDefault
        brickLevel = Constants.brickLevelDefault
        relPaddleSize = Constants.relPaddleDefault
        gravity = Constants.gravityDefault
        pushMagnitude = Constants.pushMagnDefault
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let brickRowKey = "brickRowKey"
        static let brickRowDefault: Int = 5
        static let brickColumnKey = "brickColumnKey"
        static let brickColumnDefault: Int = 6
        static let brickLevelKey = "brickLevelKey"
        static let brickLevelDefault: Int = 0
        static let relPaddleKey = "relPaddleKey"
        static let relPaddleDefault: CGFloat = 0.2
        static let pushMagnKey = "pushMagnKey"
        static let pushMagnDefault: CGFloat = 7.0
        static let gravityKey = "gravityKey"
        static let gravityDefault = false
    }
}