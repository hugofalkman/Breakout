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
    
    var pushMagnitude: CGFloat {
        get {return defaults.objectForKey(Constants.pushMagnKey) as? CGFloat ?? Constants.pushMagnDefault}
        set {defaults.setObject(newValue, forKey: Constants.pushMagnKey) }
    }
    
    var gravity: Bool {
        get {return defaults.objectForKey(Constants.gravityKey) as? Bool ?? Constants.gravityDefault}
        set {defaults.setObject(newValue, forKey: Constants.gravityKey) }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let pushMagnKey = "pushMagnKey"
        static let pushMagnDefault: CGFloat = 7.0
        static let gravityKey = "gravityKey"
        static let gravityDefault = false
    }
}