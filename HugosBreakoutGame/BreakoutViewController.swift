//
//  BreakoutViewController.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-08.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var gameView: UIView!
    
    // MARK: - Animation
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    
    // MARK: - Gestures
    
    @IBAction func ball(sender: UITapGestureRecognizer) {
        ball()
    }
    
    // MARK: - Ball
    
    var ballSize : CGSize {
        let size = Constants.RelBallSize * min(gameView.bounds.size.width, gameView.bounds.size.height)
        return CGSize(width: size, height: size)
    }
    
    var ballInPlay = false
    
    func ball() {
        if ballInPlay == false {
            ballInPlay == true
            let ballView = UIView(frame: CGRect(origin: CGPointZero, size: ballSize))
            ballView.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
            ballView.backgroundColor = Constants.BallColor
            ballView.layer.cornerRadius = ballSize.width / 2.0
            ballView.layer.borderColor =  UIColor.blackColor().CGColor
            ballView.layer.borderWidth = 1.0
            
            gameView.addSubview(ballView)
        }
    }
    
    // MARK: - Constants
    
    struct Constants {
        static let RelBallSize = CGFloat(0.125)
        static let BallColor = UIColor.brownColor()
    }
}

// MARK: - Extensions

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}