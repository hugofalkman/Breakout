//
//  BezierPathsView.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-10.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {

    private var bezierPaths = [String: UIBezierPath]()
    
    func setPath(path:UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
}
