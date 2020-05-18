//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Chase McElroy on 5/17/20.
//  Copyright © 2020 ChaseMcElroy. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBeheavior: UICollisionBehavior = {
         let behavior = UICollisionBehavior()
          behavior.translatesReferenceBoundsIntoBoundary = true
//          animator.addBehavior(behavior)
          return behavior
      }()
      
      lazy var itemBehavior: UIDynamicItemBehavior = {
         let behavior = UIDynamicItemBehavior()
          behavior.allowsRotation = false
          behavior.elasticity = 1.0
          behavior.resistance = 0
//          animator.addBehavior(behavior)
          return behavior
      }()
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
//        animator.addBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBeheavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBeheavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBeheavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
