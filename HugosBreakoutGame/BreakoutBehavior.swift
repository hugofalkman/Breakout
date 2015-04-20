//
//  BreakoutBehavior.swift
//  HugosBreakoutGame
//
//  Created by H Hugo Falkman on 2015-04-09.
//  Copyright (c) 2015 H Hugo Fakman. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    private let gravity = UIGravityBehavior()
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        didSet { collider.collisionDelegate = collisionDelegate}
    }
    
    private lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = false
        return lazyCollider
        }()
    
    private lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBallBehavior = UIDynamicItemBehavior()
        lazyBallBehavior.allowsRotation = false
        lazyBallBehavior.elasticity = 1.0
        lazyBallBehavior.friction = 0.0
        lazyBallBehavior.resistance = 0.008
        lazyBallBehavior.action = {
            for item in self.items {
                if !CGRectIntersectsRect(item.frame, self.dynamicAnimator!.referenceView!.bounds) {
                    self.removeBall(item)
                }
            }
        }
        return lazyBallBehavior
        }()

    var gravityOn: Bool!
    
    var items: [UIView] {
        return ballBehavior.items.map{$0 as UIView}
    }
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(named name: String) {
        collider.removeBoundaryWithIdentifier(name)
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        if gravityOn == true { gravity.addItem(ball) }
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
}









