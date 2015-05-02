//
//  BreakoutViewController.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-08.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UICollisionBehaviorDelegate
{
    // MARK: - Outlets
    
    @IBOutlet weak var gameView: BezierPathsView!
    
    @IBOutlet weak var ballLabel: UIBarButtonItem!
   
    @IBOutlet weak var bricksLabel: UIBarButtonItem!
    
    
    // MARK: - Animation
    
    lazy var animator: UIDynamicAnimator = {
        let lazyDynaAnimator = UIDynamicAnimator(referenceView: self.gameView)
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
    
    private var gameViewSizeChanged = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.collisionDelegate = self
        
        numBallsPushed = 0
        numBricksHit = 0
        
        // Setting background image
        if let image = UIImage(named:"bg") {
            gameView.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Changes to settings will become active when tabbing back to Breakout game (and initialized with defaults from settings first time)
        let settings = Settings()
        brickRows = settings.brickRows
        brickColumns = settings.brickColumns
        brickLevel = settings.brickLevel
        relPaddleWidth = settings.relPaddleSize
        pushStrength = settings.pushMagnitude
        breakoutBehavior.gravityOn = settings.gravity
        
        // Setup accelerometer
        let motionManager = AppDelegate.Motion.Manager
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                (data,error) -> Void in
                self.breakoutBehavior.gravity.gravityDirection = CGVector(dx: data.acceleration.x, dy: -data.acceleration.y)
            }
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        gameViewSizeChanged = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Reset bricks, paddle and side barriers when rotation changes
        if gameViewSizeChanged {
            gameViewSizeChanged = false
            
            // Add the three side barriers
            sideBarriers()
            
            // Set or reset paddle in center position
            resetPaddle()
            
            // If needed put ball back inside gameView after rotation
            for item in breakoutBehavior.items {
                if !CGRectContainsRect(gameView.bounds, item.frame) {
                    placeBall(item)
                    animator.updateItemUsingCurrentState(item)
                }
            }
            
            // Initialize brick array
            generateBricks()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
    
    // MARK: - Delegates
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if let bricksIndex = (identifier as? String)?.toInt() {
            removeBrickHit(bricksIndex)
        }
    }
    
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
    
    private var numBallsPushed: Int = 0 {
        didSet { ballLabel.title = "Ball \(numBallsPushed)" }
    }
    
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
            numBallsPushed++
        }
        
        var points = ballSize.width / 2.0
        points = CGFloat(M_PI) * points * points
        
        push(breakoutBehavior.items.last!, points: points)
    }
    
    private func placeBall(ball: UIView) {
        ball.center = paddle.center
        ball.center.y -= (Constants.PaddleHeight + ballSize.height) / 2
    }
    
    // MARK: - Barriers including paddle
    
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
        
        barrierOrigin = CGPoint(x: 0, y: -8)
        barrierSize = CGSize(width: gameView.bounds.size.width, height: 8)
        path = UIBezierPath(rect: CGRect(origin: barrierOrigin, size: barrierSize))
        breakoutBehavior.addBarrier(path, named: PathNames.TopBarrier)
        gameView.setPath(path, named: PathNames.TopBarrier)
    }
    
    private var relPaddleWidth: CGFloat! {
        didSet {
            if !gameViewSizeChanged &&
                oldValue != relPaddleWidth {
                resetPaddle()
            }
        }
    }
    
    private var paddleSize : CGSize {
        let width = relPaddleWidth * gameView.bounds.size.width
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
    
    private func resetPaddle() {
        paddle.frame.size = paddleSize
        paddle.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY - paddle.frame.size.height / 2 - Constants.PaddleYOffset)
        breakoutBehavior.addBarrier(UIBezierPath(ovalInRect: paddle.frame), named: PathNames.Paddle)
    }
    
    // MARK: - Bricks
    
    private var brickRows: Int! {
        didSet {
            if !gameViewSizeChanged &&
                oldValue != brickRows {
                generateBricks()
            }
        }
    }
    private var brickColumns: Int! {
        didSet {
            if !gameViewSizeChanged &&
                oldValue != brickColumns {
                generateBricks()
            }
        }
    }
    
    private var brickLevel: Int! {
        didSet {
            if !gameViewSizeChanged &&
                oldValue != brickLevel {
                generateBricks()
            }
        }
    }
    
    private var numBricksHit: Int = 0 {
        didSet { bricksLabel.title = "Bricks \(numBricksHit)" }
    }
    
    private var brickSize: CGSize {
        let width = (gameView.bounds.size.width - Constants.BrickSeparation) /  CGFloat(brickColumns) - Constants.BrickSeparation
        return CGSize(width: width, height: Constants.BrickHeight)
    }
    
    private var bricks = [UIView]()
    
    private func generateBricks() {
        removeBricks()
        numBallsPushed = 0
        numBricksHit = 0
        // Set the two different brick layout levels
        var top = gameView.bounds.minY
        var middle: CGFloat!
        switch brickLevel {
        case 0:
            top += Constants.BrickYOffset
            middle = Constants.BrickSeparation
        case 1:
            top += Constants.BrickSeparation
            middle = Constants.BrickYOffset
        default: break
        }
        // Set the brick layout
        let midPoint = brickRows / 2
        if midPoint != 0{
            let origin = CGPoint(x: Constants.BrickSeparation, y: top)
            addBricks(origin, rowStart: 0, rowEnd: midPoint - 1)
        }
        let origin = CGPoint(x: Constants.BrickSeparation, y: top + middle + CGFloat(midPoint) * (Constants.BrickHeight + Constants.BrickSeparation) - Constants.BrickSeparation)
        addBricks(origin, rowStart: midPoint, rowEnd: brickRows - 1)
    }
    
    private func addBricks(origin: CGPoint, rowStart: Int, rowEnd: Int) {
        var brickOrigin = origin
        for row in rowStart...rowEnd {
            for column in 0..<brickColumns {
                var brick = UIView(frame: CGRect(origin: brickOrigin, size: brickSize))
                brick.backgroundColor = UIColor.rainbow(row, n: brickRows)
                gameView.addSubview(brick)
                bricks.append(brick)
                breakoutBehavior.addBarrier(UIBezierPath(rect: brick.frame), named: "\(bricks.count - 1)")
                brickOrigin.x += Constants.BrickSeparation + brickSize.width
            }
            brickOrigin.x = Constants.BrickSeparation
            brickOrigin.y += Constants.BrickSeparation + brickSize.height
        }
    }
    
    private func removeBricks() {
        if bricks.count == 0 {return}
        for i in 0..<bricks.count {
            breakoutBehavior.removeBarrier(named: "\(i)")
            bricks[i].removeFromSuperview()
        }
        bricks = []
    }
    
    func removeBrickHit(i: Int) {
        breakoutBehavior.removeBarrier(named: "\(i)")
        numBricksHit++
        UIView.transitionWithView(bricks[i], duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.bricks[i].backgroundColor = UIColor.whiteColor()
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.75, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.bricks[i].alpha = 0
        }, completion: nil)
        
        if numBricksHit >= bricks.count { endOfGame() }
    }
    
    func endOfGame() {
        for item in breakoutBehavior.items {
            breakoutBehavior.removeBall(item)
        }
        var alert = UIAlertController(title: "Game Over", message: "Start New Game?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default) {
            (action) in
            self.resetPaddle()
            self.generateBricks()
            })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) in
            // do nothing
            })
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
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
        
        static let PaddleHeight = CGFloat(10)
        static let PaddleYOffset = CGFloat(50)
        static let PaddleImage = "paddle"
        
        static let BrickHeight = CGFloat(8)
        static let BrickSeparation = CGFloat(4)
        static let BrickYOffset = CGFloat(70)
    }
}

// MARK: - Extensions

private extension UIColor {
    class func rainbow(i: Int, n: Int) -> UIColor {
        let j = n % 5
        let N = n / 5
        let k = j * (N+1)
        var color = 5
        if i < k {
            color = i / (N+1)
        } else {
            color = j + (i-k) / N
        }
    
        switch color {
        case 0: return UIColor.redColor()
        case 1: return UIColor.orangeColor()
        case 2: return UIColor.yellowColor()
        case 3: return UIColor.greenColor()
        case 4: return UIColor.cyanColor()
        default: return UIColor.blackColor()
        }
    }
}