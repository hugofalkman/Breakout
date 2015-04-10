//
//  BreakoutViewController.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-08.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate
{
    // MARK: - Outlets
    
    @IBOutlet weak var gameView: BezierPathsView!
    
    // MARK: - Animation
    
    lazy var animator: UIDynamicAnimator = {
        let lazyDynaAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyDynaAnimator.delegate = self
        return lazyDynaAnimator
        }()
    
    let breakoutBehavior = BreakoutBehavior()
    
    func pushBall(ball: UIView) {
        if let pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous) {
            pushBehavior.magnitude = 1.0
            pushBehavior.angle = CGFloat(2 * M_PI * Double(arc4random()) / Double(UINT32_MAX))
            // println("\(pushBehavior.angle)")
            pushBehavior.action = { [unowned pushBehavior] in
                pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
            }
            animator.addBehavior(pushBehavior)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var barrierSize = CGSize(width: 8, height: gameView.bounds.size.height)
        var barrierOrigin = CGPoint(x: -8, y: 0)
        var path = UIBezierPath(rect: CGRect(origin: barrierOrigin, size: barrierSize))
        breakoutBehavior.addBarrier(path, named: PathNames.LeftBarrier)
        gameView.setPath(path, named: PathNames.LeftBarrier)
        
        barrierOrigin = CGPoint(x: gameView.bounds.size.width, y: 0)
        path = UIBezierPath(rect: CGRect(origin: barrierOrigin, size: barrierSize))
        breakoutBehavior.addBarrier(path, named: PathNames.RightBarrier)
        gameView.setPath(path, named: PathNames.RightBarrier)
        
        barrierOrigin = CGPoint(x: 0, y: 0)
        barrierSize = CGSize(width: gameView.bounds.size.width, height: 8)
        path = UIBezierPath(rect: CGRect(origin: barrierOrigin, size: barrierSize))
        breakoutBehavior.addBarrier(path, named: PathNames.TopBarrier)
        gameView.setPath(path, named: PathNames.TopBarrier)
        
        for item in breakoutBehavior.items {
            if !CGRectContainsRect(gameView.bounds, item.frame) {
                placeBall(item)
                animator.updateItemUsingCurrentState(item)
            }
        }
        
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
    
    func ball() {
        if breakoutBehavior.items.count == 0 {
            let ballView = UIView(frame: CGRect(origin: CGPointZero, size: ballSize))
            placeBall(ballView)
            ballView.backgroundColor = Constants.BallColor
            ballView.layer.cornerRadius = ballSize.width / 2.0
            
            breakoutBehavior.addBall(ballView)
        }
        pushBall(breakoutBehavior.items.last!)
    }
    
    func placeBall(ball: UIView) {
        ball.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
    }
    
    // MARK: - Constants
    
    struct PathNames {
        static let LeftBarrier = "LeftBarrier"
        static let TopBarrier = "TopBarrier"
        static let RightBarrier = "RightBarrier"
    }
    
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