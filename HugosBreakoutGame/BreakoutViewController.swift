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
    
    private var pushStrength: CGFloat!
    
    private func push(view: UIView, points: CGFloat) {
        if let pushBehavior = UIPushBehavior(items: [view], mode: UIPushBehaviorMode.Instantaneous) {
            pushBehavior.magnitude = pushStrength * points / 10000.0
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Settings changes to become active when tabbing back to Breakout game
        let settings = Settings()
        pushStrength = settings.pushMagnitude
        breakoutBehavior.gravityOn = settings.gravity
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting background image
        if let image = UIImage(named:"bg") {
            gameView.backgroundColor = UIColor(patternImage: image)
        }
        
        // Add the three side barriers
        sideBarriers()
        
        // If needed put ball back inside gameView after rotation
        for item in breakoutBehavior.items {
            if !CGRectContainsRect(gameView.bounds, item.frame) {
                placeBall(item)
                animator.updateItemUsingCurrentState(item)
            }
        }
        
        // Set or reset paddle in center posiion
        paddle.frame.size = paddleSize
        paddle.center.y = CGFloat(gameView.bounds.maxY - paddle.bounds.height / 2 - Constants.PaddleYOffset)
        if breakoutBehavior.items.count == 0 {
            paddle.center.x = gameView.bounds.midX 
        }
        breakoutBehavior.addBarrier(UIBezierPath(rect: paddle.frame), named: PathNames.Paddle)
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    
    // MARK: - Gestures
    
    @IBAction func ball(gesture: UITapGestureRecognizer) {
        ball()
    }
    
    @IBAction func paddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(gameView)
            let posChange = translation.x
            if posChange != 0 {
                paddleXPosition += posChange
                gesture.setTranslation(CGPointZero, inView: gameView)
            }
        default: break
        }
    }
    
    
    // MARK: - Ball
    
    private var ballSize : CGSize {
        let size = Constants.RelBallSize * min(gameView.bounds.size.width, gameView.bounds.size.height)
        return CGSize(width: size, height: size)
    }
    
    private func ball() {
        if breakoutBehavior.items.count == 0 {
            let ballView = UIView(frame: CGRect(origin: CGPointZero, size: ballSize))
            placeBall(ballView)
            ballView.backgroundColor = Constants.BallColor
            ballView.layer.cornerRadius = ballSize.width / 2.0
          
            breakoutBehavior.addBall(ballView)
        }
        
        var points = ballSize.width / 2.0
        points = CGFloat(M_PI) * points * points
        
        push(breakoutBehavior.items.last!, points: points)
    }
    
    private func placeBall(ball: UIView) {
        ball.center = paddle.center
        ball.center.y -= (Constants.PaddleHeight + ballSize.height) / 2
    }
    
    // MARK: - Barriers
    
    private func sideBarriers() {
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
    }
    
    private var paddleSize : CGSize {
        let width = Constants.RelPaddleWidth * gameView.bounds.size.width
        return CGSize(width: width, height: Constants.PaddleHeight)
    }
    
    private var paddleXPosition: CGFloat {
        get { return paddle.frame.origin.x }
        set {
            paddle.frame.origin.x = min(max(newValue, 0), gameView.bounds.maxX - paddleSize.width)
            breakoutBehavior.addBarrier(UIBezierPath(rect: paddle.frame), named: PathNames.Paddle)
        }
    }
    
    private lazy var paddle: UIImageView = {
        let paddle = UIImageView(frame: CGRect(origin: CGPointZero, size: self.paddleSize))
        if let image = UIImage(named: "paddle") {
            paddle.image = image
        }
        
        self.gameView.addSubview(paddle)
        return paddle
    }()
    
    
    // MARK: - Constants
    
    private struct PathNames {
        static let LeftBarrier = "LeftBarrier"
        static let TopBarrier = "TopBarrier"
        static let RightBarrier = "RightBarrier"
        
        static let Paddle = "Paddle"
    }
    
    struct Constants {
        static let RelBallSize = CGFloat(0.07)
        static let BallColor = UIColor.brownColor()
        
        static let RelPaddleWidth = CGFloat(0.2)
        static let PaddleHeight = CGFloat(10)
        static let PaddleYOffset = CGFloat(30)
        static let PaddleImage = "paddle"
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