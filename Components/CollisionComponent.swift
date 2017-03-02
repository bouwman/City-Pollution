//
//  CollisionComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class CollisionComponent: GKComponent {
    init(node: SKNode, category: UInt32, pinned: Bool, collideWith: UInt32 = Const.Physics.Collision.all) {
        super.init()
        
        if node.physicsBody == nil {
            node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
        }
        node.physicsBody?.categoryBitMask = category
        node.physicsBody?.collisionBitMask = collideWith
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.pinned = pinned
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
